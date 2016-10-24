global class POBuilder {

    @future  (callout=true)
    Webservice static void GeneratePurchaseOrder(Id orderId)
    {

        List<Order> orders = [SELECT Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , 
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                        	 FROM OrderItems)
                       FROM Order 
                       WHERE Id = :orderId];

        GeneratePurchaseOrders(orders);
    }
    
    public static boolean GeneratePurchaseOrders(List<Order> orders)
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
            try
            {
                QBOPurchaseOrderResponse.PurchaseOrder po = new  QBOPurchaseOrderResponse.PurchaseOrder();
                QBOPurchaseOrderResponse.Reference vendorRef = new QBOPurchaseOrderResponse.Reference();
                vendorRef.value = order.Account.QuickBooks_Id__c;
                po.VendorRef = vendorRef;
                po.Memo = order.Description;
                po.GlobalTaxCalculation = 'TaxInclusive';

                po.TxnDate = ((DateTime)order.EffectiveDate).format('YYYY-MM-dd');
                po.DocNumber = order.OrderNumber;
                
                List<QBOPurchaseOrderResponse.Line> invLines = new List<QBOPurchaseOrderResponse.Line>();
                for(OrderItem oi : order.OrderItems)
                {
                   
                    QBOPurchaseOrderResponse.Line line = new QBOPurchaseOrderResponse.Line();
                    line.Amount = oi.UnitPrice * oi.Quantity / 1.1;
                    line.Description = '';
                    
                    if (oi.Description != null)
                    {
                        line.Description += oi.Description;  
                    }
                     
                    line.DetailType = 'ItemBasedExpenseLineDetail';
                    QBOPurchaseOrderResponse.ItemBasedExpenseLineDetail lineDetail = new QBOPurchaseOrderResponse.ItemBasedExpenseLineDetail();

                    lineDetail.UnitPrice = oi.UnitPrice;
                    lineDetail.Qty = oi.Quantity;  
                    
                    QBOProductList.Item item = productMap.get(oi.PricebookEntry.Sku__c);
                    string taxCodeRefValue = '10';// defaults to handle unmapped senarios 10 is GST 
                    string itemRefValue = '1';  // defaults to handle unmapped senarios 1 is SERVCICE 
                    
                    if (item != null)
                    {
                        itemRefValue = item.Id;
                        if (item.PurchaseTaxCodeRef != null)
                        {
                            taxCodeRefValue = item.PurchaseTaxCodeRef.value;
                        }
                    }
                    
                    QBOPurchaseOrderResponse.TaxCodeRef taxCodeRef = new QBOPurchaseOrderResponse.TaxCodeRef();
                    taxCodeRef.value = taxCodeRefValue;
                    lineDetail.TaxCodeRef = taxCodeRef;
                    QBOPurchaseOrderResponse.Reference itemRef  = new QBOPurchaseOrderResponse.Reference();
                    itemRef.value = itemRefValue;
                    lineDetail.ItemRef = itemRef;
                    line.ItemBasedExpenseLineDetail = lineDetail;
                    
                    invLines.add(line);
                    
                    
                }
                po.Line = invLines;
                
                System.debug('Creating PO : ' + system.JSON.serialize(po, true));
                
                
                object response = qbo.upsertData('purchaseorder', system.JSON.serialize(po, true), QBOPurchaseOrderResponse.class);
                QBOPurchaseOrderResponse poResponse;
                if (response instanceof QBOError){
                    //log the error and move to next account
                    errorLogsToInsert.addAll( ErrorLogHelper.LogOrderError(order, (QBOError)response));
                    order.Status = 'Error';
                    ordersToUpdate.add(order);
                    continue;
                }else{
                    poResponse = (QBOPurchaseOrderResponse)response;
                    order.QuickBooksId__c = poResponse.PurchaseOrder.Id;
                    order.Status = 'Activated';
                }                  
            }
            catch(Exception ex)
            {
                errorLogsToInsert.add(ErrorLogHelper.LogOrderError(order, ex));
                order.Status = 'Error';
                
            }
            ordersToUpdate.add(order);

        }
        Insert errorLogsToInsert;// insert any errors
		update ordersToUpdate;   // updatethe orders with the qboId
        return true;
    }
}