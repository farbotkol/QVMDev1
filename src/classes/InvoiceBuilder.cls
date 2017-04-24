global class InvoiceBuilder {

    Webservice static boolean GenerateInvoices(Id batchJobId)
    {
        // update the batch to processing 
        InvoiceBuilder.SetOrderRecordType('Processing_Invoices', batchJobId);
		// get the orders of the batch and batch process them
        List<Order> orders = [SELECT Account.Majik_AccountNo__c,Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate, Opportunity.Terms__c, Opportunity.Payment_Type__c
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , Account.Name,
                            Account.BillingAddress,Account.BillingCity ,Account.BillingCountry,Account.BillingGeocodeAccuracy,Account.BillingLatitude,Account.BillingLongitude
                            ,Account.BillingPostalCode,Account.BillingState,Account.BillingStreet
                            , Opportunity.Majik_AccountNo__c, Opportunity.RecordType.DeveloperName, Batch_Job__r.Batch_Type__c,
                            Batch_Job__r.From_Date__c, Batch_Job__r.To_Date__c, bond__c,Opportunity.Class__c ,
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                             , PricebookEntry.Product2.Name,  QBO_Class_Id__c
                        	 FROM OrderItems)
                       FROM Order 
                       WHERE Batch_Job__c  = :batchJobId and Total__c > 0 and QuickBooksId__c = ''];
        
        
        InvoiceBuilderBatch batch = new InvoiceBuilderBatch(orders,  batchJobId); 
        database.executebatch(batch,35);
        
        return true;
    }
    
    // Used to generate one order into a QBO invoice from the Salesforce UI
    Webservice static boolean GenerateInvoiceFromOrder(Id orderId)
    {

        List<Order> orders = [SELECT Account.Majik_AccountNo__c,Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate, Opportunity.Terms__c, Opportunity.Payment_Type__c
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , Account.Name
                            , Account.BillingAddress,Account.BillingCity ,Account.BillingCountry,Account.BillingGeocodeAccuracy,Account.BillingLatitude
                            ,Account.BillingLongitude ,Account.BillingPostalCode,Account.BillingState,Account.BillingStreet
                            , Opportunity.Majik_AccountNo__c, Opportunity.RecordType.DeveloperName , Batch_Job__r.Batch_Type__c,
                            Batch_Job__r.From_Date__c, Batch_Job__r.To_Date__c,  bond__c,Opportunity.Class__c ,
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                                ,PricebookEntry.Product2.Name, QBO_Class_Id__c
                        	 FROM OrderItems)
                       FROM Order 
                       WHERE Id = :orderId];
        
        
        
        
        
        return GenerateInvoiceFromOrders(orders, NULL);
    }
    
    
    public static boolean GenerateInvoiceFromOrders(List<Order> orders, Id batchJobId)
    {
        QBOCRUDHelper qbo = new QBOCRUDHelper();
        //create map of quick books products to map against the salesforce products by Sku Id
        QBOProductList products = QBOProductList.getInstance();
        Map<string, QBOProductList.Item >  productMap = new Map<string, QBOProductList.Item  >(); 
        for (QBOProductList.Item item : products.QueryResponse.Item)
        {
            productMap.put(item.Sku, item);  
        }
        system.debug('productMap: ' + productMap);
        
        List<Order> ordersToUpdate = new List<Order>();
        List<Error_Log__c> errorLogsToInsert = new List<Error_Log__c>();
        for (Order order : orders)
        {
            ///
            try
            {
                QBOInvoice invoice = new QBOInvoice();
                QBOInvoice.Reference custRef = new QBOInvoice.Reference();
                custRef.value = order.Account.QuickBooks_Id__c;
                invoice.CustomerRef = custRef;
                invoice.PrivateNote = order.Description;

                QBOInvoice.BillAddr billingAddress = new QBOInvoice.BillAddr();
                billingAddress.Line1 = order.Account.Name + '(' + order.Account.Majik_AccountNo__c + ')' ;
                billingAddress.Line2 = order.Account.BillingStreet;
                billingAddress.Line3 = order.Account.BillingCity + ' ' + order.Account.BillingState + ' ' + order.Account.BillingPostalCode ;
                invoice.BillAddr = billingAddress;
                
                // Add Majic number to the first custom field so that it can be used on the statements
                List<QBOInvoice.CustomField> customFieldList  = new   List<QBOInvoice.CustomField>();
                QBOInvoice.CustomField customField1  = new QBOInvoice.CustomField();
                customField1.DefinitionId = '1';
                customField1.Name = 'AccountBusiness';
                customField1.StringValue = order.Opportunity.Majik_AccountNo__c;
                customField1.Type_Z = 'StringType';


                customFieldList.add(customField1);

                if (order.Batch_Job__c != null)
                {
                    QBOInvoice.CustomField customField2  = new QBOInvoice.CustomField();
                    customField2.DefinitionId = '2';
                    customField2.Name = 'BillingPeriod';
                    customField2.StringValue = ((DateTime)order.Batch_Job__r.From_Date__c).format('dd/MM/YYYY') + ' to ' + ((DateTime)order.Batch_Job__r.To_Date__c).format('dd/MM/YYYY');
                    customField2.Type_Z = 'StringType';
                    customFieldList.add(customField2);
                }   

                
                invoice.CustomField = customFieldList;
                
                ////////////////////////////////////
                
                integer terms = 14;
                if(order.Opportunity.Terms__c !=null)
                {
                    try{
                        terms = integer.valueof(order.Opportunity.Terms__c);
                    }catch(Exception ex){}
                }
                
                if ( order.Opportunity.RecordType.DeveloperName == 'LH' &&  order.Batch_Job__c != null && order.Batch_Job__r.Batch_Type__c == 'LH' 
                        && order.Opportunity.Class__c != 'MB')
                {
                   //LH invoices are due on the effective date and the transaction date is back dated
                   invoice.TxnDate = ((DateTime)order.EffectiveDate.addDays(terms * -1)).format('YYYY-MM-dd');
                   invoice.DueDate = ((DateTime)order.EffectiveDate).format('YYYY-MM-dd');
                }
                else
                {
                   invoice.TxnDate = ((DateTime)order.EffectiveDate).format('YYYY-MM-dd');
                   invoice.DueDate = ((DateTime)order.EffectiveDate.addDays(terms)).format('YYYY-MM-dd');
                    
                }

                //bonds have zero terms
                if (order.Bond__c == true )
                {
                    invoice.DueDate = ((DateTime)Date.today()).format('YYYY-MM-dd');
                }
                
                invoice.DocNumber = order.OrderNumber + '-0'; 
                
                if (order.Opportunity.Payment_Type__c == 'EFT')
                {
                    QBOInvoice.TaxCodeRef memo = new QBOInvoice.TaxCodeRef();
                    memo.value = 'Outstanding balance will be paid by Direct Debit';
                    invoice.CustomerMemo = memo;
                }
                
                List<QBOInvoice.Line> invLines = new List<QBOInvoice.Line>();
                for(OrderItem oi : order.OrderItems)
                {
                   
                    QBOInvoice.Line line = new QBOInvoice.Line();
                    line.Amount = oi.Total__c;
                    line.Description = '';
                    if (oi.Stall__r != null && oi.Description != null)
                    {
                        line.Description =  oi.PricebookEntry.Product2.Name + ' ' + oi.Stall__r.Name;
                    } 
                    else if (oi.Stall__r != null)
                    {
                        line.Description =  oi.PricebookEntry.Product2.Name + ' ' + oi.Stall__r.Name ;
                    } 
                    else if (oi.Description != null)
                    {
                        line.Description += oi.PricebookEntry.Product2.Name + ' ' +  oi.Description;  
                    }
                    else if (line.Description == '' && (oi.Description == null || oi.Description == ''))
                    {
                        line.Description += oi.PricebookEntry.Product2.Name;  
                    }
                    
                     
                    line.DetailType = 'SalesItemLineDetail';
                    QBOInvoice.SalesItemLineDetail lineDetail = new QBOInvoice.SalesItemLineDetail();
                    lineDetail.ServiceDate = ((DateTime)oi.Date__c).format('YYYY-MM-dd'); 
                    // if  oi.Total__c != oi.TotalPrice then this is a SL or PE order
                    // Which should only have a qty of 1 per line and a total that is affected by the 
                    // uplift and multiplier
                    if (oi.Total__c != oi.UnitPrice * oi.Quantity)
                    {
                        lineDetail.UnitPrice = oi.Total__c.setScale(2);
                        lineDetail.Qty = 1;  
                    }
                    else
                    {
                        lineDetail.UnitPrice = oi.UnitPrice.setScale(2);
                        lineDetail.Qty = oi.Quantity;  
                    }
                    
                    QBOProductList.Item item = productMap.get(oi.PricebookEntry.Sku__c);
                    string taxCodeRefValue = '10';// defaults to handle unmapped senarios 10 is GST 
                    string itemRefValue = '1';  // defaults to handle unmapped senarios 1 is SERVCICE 
                    
                    if (item != null)
                    {
                        itemRefValue = item.Id;
                        if (item.SalesTaxCodeRef != null)
                        {
                            taxCodeRefValue = item.SalesTaxCodeRef.value;
                        }
                    }
                    
                    if (oi.QBO_Class_Id__c != null && oi.QBO_Class_Id__c != '')
                    {
                        QBOInvoice.Reference classRef  = new QBOInvoice.Reference();
                    	classRef.value = oi.QBO_Class_Id__c;
                    	lineDetail.ClassRef = classRef;
                    }
                    
                    QBOInvoice.TaxCodeRef taxCodeRef = new QBOInvoice.TaxCodeRef();
                    taxCodeRef.value = taxCodeRefValue;
                    lineDetail.TaxCodeRef = taxCodeRef;
                    QBOInvoice.Reference itemRef  = new QBOInvoice.Reference();
                    itemRef.value = itemRefValue;
                    lineDetail.ItemRef = itemRef;
                    line.SalesItemLineDetail = lineDetail;
                    
                    invLines.add(line);
                    
                    
                }
                invoice.Line = invLines;
                
                System.debug('Creating Invoice : ' + system.JSON.serialize(invoice, true));
                
                
                object response = qbo.upsertData('invoice', system.JSON.serialize(invoice, true), QBOInvoiceResponse.class);
                QBOInvoiceResponse invoiceResponse;
                if (response instanceof QBOError){
                    //log the error and move to next account
                    errorLogsToInsert.addAll( ErrorLogHelper.LogOrderError(order, (QBOError)response));
                    order.Status = 'Error';
                    ordersToUpdate.add(order);
                    continue;
                }else{
                    invoiceResponse = (QBOInvoiceResponse)response;
                    order.QuickBooksId__c = invoiceResponse.Invoice.Id;
                    order.Status = 'Activated';
                }                  
            }
            catch(Exception ex)
            {
                errorLogsToInsert.add(ErrorLogHelper.LogOrderError(order, ex));
                order.Status = 'Error';
                
            }
            ordersToUpdate.add(order);
            
            ///
        }
        Insert errorLogsToInsert;// insert any errors
        
        // moved to batch final method
        /*if (errorLogsToInsert.size()> 0 )
        {
            InvoiceBuilder.SetOrderRecordType('Error_Processing_Invoices', batchJobId);
        }
        else 
        {
            InvoiceBuilder.SetOrderRecordType('Invoices_Generated', batchJobId);
        }*/
		update ordersToUpdate;   // updatethe orders with the qboId
        return true;
    }
    Webservice static void UpdateBatchType( Id batchJobId )
    {  
		   InvoiceBuilder.SetOrderRecordType('Processing_Invoices', batchJobId);
    }
    
    public static void SetOrderRecordType(String DeveloperName, Id batchJobId)
    {
         if (batchJobId != null)
         {
             Batch_Jobs__c job = [SELECT Batch_Type__c,From_Date__c,Id,Name,Process_Range__c
                                 ,RecordType.DeveloperName,To_Date__c,Week_Month_Of__c 
                                 FROM Batch_Jobs__c 
                                 WHERE Id = :batchJobId LIMIT 1];
            
            RecordType nextStepType = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                                       WHERE SobjectType = 'Batch_Jobs__c' and DeveloperName = :DeveloperName LIMIT 1] ;
            
            job.RecordTypeId = nextStepType.Id;
            
            update job;
         }
             
    }
    
    

}