global class InvoiceBuilder {

    Webservice static boolean GenerateInvoices(Id batchJobId)
    {
        // update the batch to processing 
        InvoiceBuilder.SetOrderRecordType('Processing_Invoices', batchJobId);
		// get the orders of the batch and batch process them
        List<Order> orders = [SELECT Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate, Opportunity.Terms__c, Opportunity.Payment_Type__c
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , 
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                             , PricebookEntry.Product2.Name
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

        List<Order> orders = [SELECT Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate, Opportunity.Terms__c, Opportunity.Payment_Type__c
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , 
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                                ,PricebookEntry.Product2.Name
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
                integer terms = 14;
                if(order.Opportunity.Terms__c !=null)
                {
                    try{
                        terms = integer.valueof(order.Opportunity.Terms__c);
                    }catch(Exception ex){}
                }
                invoice.TxnDate = ((DateTime)order.EffectiveDate).format('YYYY-MM-dd');
                invoice.DueDate = ((DateTime)order.EffectiveDate.addDays(terms)).format('YYYY-MM-dd');
                invoice.DocNumber = order.OrderNumber;
                
                if (order.Opportunity.Payment_Type__c == 'EFT')
                {
                    QBOInvoice.TaxCodeRef memo = new QBOInvoice.TaxCodeRef();
                    memo.value = '!!!DO NOT PAY!!!\nThis Invoice will be paid by Driect Debit';
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
                    
                     
                    line.DetailType = 'SalesItemLineDetail';
                    QBOInvoice.SalesItemLineDetail lineDetail = new QBOInvoice.SalesItemLineDetail();
                    lineDetail.ServiceDate = ((DateTime)oi.Date__c).format('YYYY-MM-dd'); 
                    // if  oi.Total__c != oi.TotalPrice then this is a SL or PE order
                    // Which should only have a qty of 1 per line and a total that is affected by the 
                    // uplift and multiplier
                    if (oi.Total__c != oi.UnitPrice * oi.Quantity)
                    {
                        lineDetail.UnitPrice = oi.Total__c;
                        lineDetail.Qty = 1;  
                    }
                    else
                    {
                        lineDetail.UnitPrice = oi.UnitPrice;
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
    
    
    public static void SetOrderRecordType(String DeveloperName, Id batchJobId)
    {
         if (batchJobId != null)
         {
             Batch_Jobs__c job = [SELECT Batch_Type__c,From_Date__c,Id,Name,Process_Range__c
                                 ,RecordType.Name,To_Date__c,Week_Month_Of__c 
                                 FROM Batch_Jobs__c 
                                 WHERE Id = :batchJobId LIMIT 1];
            
            RecordType nextStepType = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                                       WHERE SobjectType = 'Batch_Jobs__c' and DeveloperName = :DeveloperName LIMIT 1] ;
            
            job.RecordTypeId = nextStepType.Id;
            
            update job;
         }
             
    }
    
    

}