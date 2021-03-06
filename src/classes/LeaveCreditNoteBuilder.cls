global class LeaveCreditNoteBuilder {
    
    Webservice static boolean GenerateLeaveCreditNotes(Id batchJobId)
    {
        // update the batch to processing 
        LeaveCreditNoteBuilder.SetOrderItemRecordType('Processing_Leave_Credit_Notes', batchJobId);
        // get the orders of the batch and batch process them
        List<OrderItem> orderItems = [SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                               		  ,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c,
                                      Order.Account.QuickBooks_Id__c, Status__c , Batch_Jobs__c, QuickBooksId__c, Order.Opportunity.Majik_AccountNo__c
                                      , Order.Status
                               		  FROM OrderItem
                               		  WHERE (Batch_Jobs__r.Id = '' or Batch_Jobs__r.Id  = :batchJobId) and QuickBooksId__c ='' and Status__c = '' and Leave__c = True and Order.Status = 'Activated'];
        
        if(orderItems.size()>0){
            System.debug('I have values '+orderItems);
            LeaveCreditNoteBuilderBatch batch = new LeaveCreditNoteBuilderBatch(orderItems,  batchJobId); 
            database.executebatch(batch,30);
        }
        else
        {
            System.debug('I have no values '+orderItems);
            LeaveCreditNoteBuilder.SetOrderItemRecordType('Leave_Credit_Notes_Generated', batchJobId);
        } 


            


        return true;
    }
    
    
    public static boolean GenerateLeaveCreditNotes(List<OrderItem> orderItems, Id batchJobId)
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
        
        List<OrderItem> orderItemsToUpdate = new List<OrderItem>();
        List<Error_Log__c> errorLogsToInsert = new List<Error_Log__c>();
        for (OrderItem item : orderItems)
        {
            ///
            try
            {
                QBOInvoice invoice = new QBOInvoice();
                QBOInvoice.Reference custRef = new QBOInvoice.Reference();
                custRef.value = item.Order.Account.QuickBooks_Id__c;
                invoice.CustomerRef = custRef;
                invoice.PrivateNote = item.Description;
               // invoice.DocNumber = item.OrderItemNumber + 'LCN';
                invoice.TxnDate = ((DateTime)item.Date__c).format('YYYY-MM-dd'); //  ((DateTime)Date.today()).format('YYYY-MM-dd');
                
                
                // Add Majic number to the first custom field so that it can be used on the statements
                List<QBOInvoice.CustomField> customFieldList  = new   List<QBOInvoice.CustomField>();
                QBOInvoice.CustomField customField1  = new QBOInvoice.CustomField();
                customField1.DefinitionId = '1';
                customField1.Name = 'AccountBusiness';
                customField1.StringValue = item.order.Opportunity.Majik_AccountNo__c;
                customField1.Type_Z = 'StringType';
                
                customFieldList.add(customField1);
                
                invoice.CustomField = customFieldList;
                
                ////////////////////////////////////
                
                List<QBOInvoice.Line> invLines = new List<QBOInvoice.Line>();
                
                QBOInvoice.Line line = new QBOInvoice.Line();
                line.Amount = item.Total__c;
                line.Description = '';
                if (item.Stall__r != null)
                {
                    line.Description = item.Stall__r.Name + ' ';
                } 
                if (item.Description != null)
                {
                    line.Description += item.Description;  
                }
                
                try
                {
                    invoice.DocNumber = 'L' + String.valueOf(Integer.valueOf(item.OrderItemNumber)) + '-' + line.Description.replace(' ', '');
                    
                }
                catch (Exception ex)
                {
                    invoice.DocNumber = 'L' + item.OrderItemNumber + '-' + line.Description.replace(' ', '');
                }
                
                
                line.DetailType = 'SalesItemLineDetail';
                QBOInvoice.SalesItemLineDetail lineDetail = new QBOInvoice.SalesItemLineDetail();
                lineDetail.ServiceDate = ((DateTime)item.Date__c).format('YYYY-MM-dd'); 
                // if  oi.Total__c != oi.TotalPrice then this is a SL or PE order
                // Which should only have a qty of 1 per line and a total that is affected by the 
                // uplift and multiplier
      

                lineDetail.UnitPrice = item.Total__c;
                lineDetail.Qty = 1;  
                
                
                QBOProductList.Item product = productMap.get(item.PricebookEntry.Sku__c);
                string taxCodeRefValue = '10';// defaults to handle unmapped senarios 10 is GST 
                string itemRefValue = '1';  // defaults to handle unmapped senarios 1 is SERVCICE 
                
                if (product != null)
                {
                    itemRefValue = product.Id;
                    if (product.SalesTaxCodeRef != null)
                    {
                        taxCodeRefValue = product.SalesTaxCodeRef.value;
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
                    
                    
                
                invoice.Line = invLines;
                
                System.debug('Creating Invoice : ' + system.JSON.serialize(invoice, true));
                
                item.Batch_Jobs__c = batchJobId;
                object response = qbo.upsertData('creditmemo', system.JSON.serialize(invoice, true), QBOCreditMemoResponse.class);
                QBOCreditMemoResponse creditMemoResponse;
                if (response instanceof QBOError){
                    //log the error and move to next account
                    errorLogsToInsert.addAll( ErrorLogHelper.LogOrderItemError(item, (QBOError)response));
                    //if(((QBOError)response).errors.Fault.Error[0].Message.contains('Duplicate Document Number Error'))
                     //   item.Status__c = 'Error';
                    //else
                    item.Status__c = 'Error';
                    orderItemsToUpdate.add(item);
                    continue;
                }else{
                    creditMemoResponse = (QBOCreditMemoResponse)response;
                    item.QuickBooksId__c = creditMemoResponse.CreditMemo.Id;
                    item.Status__c = 'Activated';
                    AutoApplyCreditNote(creditMemoResponse , qbo);
                }                  
            }
            catch(Exception ex)
            {
                errorLogsToInsert.add(ErrorLogHelper.LogOrderItemError(item, ex));
                item.Status__c = 'Error';
                
            }
            orderItemsToUpdate.add(item);
            
            ///
        }
        Insert errorLogsToInsert;// insert any errors
        if (errorLogsToInsert.size()> 0 )
        {
            LeaveCreditNoteBuilder.SetOrderItemRecordType('Error_Processing_Leave_Credit_Notes', batchJobId);
        }
        else 
        {
            LeaveCreditNoteBuilder.SetOrderItemRecordType('Leave_Credit_Notes_Generated', batchJobId);
        }
        update orderItemsToUpdate;   // updatethe orders with the qboId

         

        return true;
    }


    public static void AutoApplyCreditNote(QBOCreditMemoResponse creditmemo, QBOCRUDHelper crudHelper)
    {
        // Auto Apply Credit Notes;
        //QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        try
        {
            String queryString;


            queryString = 'select Id,DocNumber,TxnDate,DueDate,TotalAmt,Balance , CustomerRef from INVOICE where CustomerRef = \''  + creditmemo.CreditMemo.CustomerRef.value + '\' and Balance != \'0\' order by id Desc MAXRESULTS 1';
            
            System.debug('QueryString: ' + queryString );
            Object res =  crudHelper.query(queryString, QBOInvoiceList.Class);
            System.debug('crudHelper.query: ' + res ); 
            if (res instanceof QBOError)
            {
                System.debug('RESMI:TTTT:-error'  + (QBOError)res); 
                
            }
            else 
            {   
                List<QBOInvoice> invs = ((QBOInvoiceList)res).queryResponse.invoice;
                System.debug('invs.Size(): ' + invs.Size() ); 
                if (invs != null || invs.size() > 0 )
                {
                    //System.Debug('RESMI:TTT 2');
                        QBOPaymentResponse.Payment paymentInstance = new QBOPaymentResponse.Payment();
                        QBOPaymentResponse.CustomerRef  custref = new QBOPaymentResponse.CustomerRef();
                       
                        
                        custref.value = creditmemo.CreditMemo.CustomerRef.value;
                        system.debug('test1');
                        paymentInstance.CustomerRef  = custref;
                        paymentInstance.TotalAmt = 0;
                        paymentInstance.TxnDate = ((DateTime)Date.today()).format('YYYY-MM-dd');
                        paymentInstance.PrivateNote = 'Leave Credit Note Auto Apply';               
                        //QBOPaymentResponse.DepositToAccountRef payTypeRef = new QBOPaymentResponse.DepositToAccountRef();
                        //payTypeRef.value = payType.QBO_Id__c;
                        //paymentInstance.PaymentMethodRef = payTypeRef;


                        List<QBOPaymentResponse.Line> invLines = new List<QBOPaymentResponse.Line>();
                        //Invoice               
                        QBOPaymentResponse.Line line = new QBOPaymentResponse.Line();
                    
                        line.Amount = creditmemo.CreditMemo.Balance;
                   
                        List<QBOPaymentResponse.LinkedTxn> LinkedTxnLines = new List<QBOPaymentResponse.LinkedTxn> ();
                    
                        QBOPaymentResponse.LinkedTxn linkedTxnObj = new QBOPaymentResponse.LinkedTxn();
                        linkedTxnObj.TxnId = invs.get(0).Id;
                        linkedTxnObj.TxnType = 'Invoice';
                   
                        LinkedTxnLines.add(linkedTxnObj);

                        line.LinkedTxn = LinkedTxnLines;

                        invLines.add(line); 


                        //Credir Memo
                        QBOPaymentResponse.Line lineCR = new QBOPaymentResponse.Line();
                    
                        lineCR.Amount = creditmemo.CreditMemo.Balance;
                   
                        List<QBOPaymentResponse.LinkedTxn> LinkedTxnLinesCR = new List<QBOPaymentResponse.LinkedTxn> ();
                    
                        QBOPaymentResponse.LinkedTxn linkedTxnObjCR = new QBOPaymentResponse.LinkedTxn();
                        linkedTxnObjCR.TxnId = creditmemo.CreditMemo.Id;
                        linkedTxnObjCR.TxnType = 'CreditMemo';
                   
                        LinkedTxnLinesCR.add(linkedTxnObjCR);

                        lineCR.LinkedTxn = LinkedTxnLinesCR;
                        

                        invLines.add(lineCR); 

                        paymentInstance.line = invLines;

                        QBOPaymentResponse paymentResponse;
                        System.debug('system.JSON.serialize(paymentInstance, true): ' + system.JSON.serialize(paymentInstance, true) ); 
                        Object response = crudHelper.upsertData('payment', system.JSON.serialize(paymentInstance, true), QBOPaymentResponse.class)  ;

                }
            }
        }
        catch(Exception Ex)
        {}

    }
    
    
    public static void SetOrderItemRecordType(String DeveloperName, Id batchJobId)
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