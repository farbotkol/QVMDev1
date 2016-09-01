global class LeaveCreditNoteBuilder {
    
    Webservice static boolean GenerateLeaveCreditNotes(Id batchJobId)
    {
        // update the batch to processing 
        LeaveCreditNoteBuilder.SetOrderItemRecordType('Processing_Leave_Credit_Notes', batchJobId);
        // get the orders of the batch and batch process them
        List<OrderItem> orderItems = [SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                               		  ,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c,
                                      Order.Account.QuickBooks_Id__c, Status__c , Batch_Jobs__c, QuickBooksId__c
                               		  FROM OrderItem
                               		  WHERE (Batch_Jobs__r.Id = '' or Batch_Jobs__r.Id  = :batchJobId) and QuickBooksId__c ='' and Leave__c = True];
        
        if(orderItems.size()>0){
            System.debug('I have values '+orderItems);
            LeaveCreditNoteBuilderBatch batch = new LeaveCreditNoteBuilderBatch(orderItems,  batchJobId); 
            database.executebatch(batch,35);
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
                invoice.DocNumber = 'LCN--'+item.OrderItemNumber;
                invoice.TxnDate = ((DateTime)Date.today()).format('YYYY-MM-dd');
                
                
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
                    
                    item.Status__c = 'Error';
                    orderItemsToUpdate.add(item);
                    continue;
                }else{
                    creditMemoResponse = (QBOCreditMemoResponse)response;
                    item.QuickBooksId__c = creditMemoResponse.CreditMemo.Id;
                    item.Status__c = 'Activated';
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
    
    
    public static void SetOrderItemRecordType(String DeveloperName, Id batchJobId)
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