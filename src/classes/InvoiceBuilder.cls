global class InvoiceBuilder {

    
    
    // Used to generate one order into a QBO invoice from the Salesforce UI
    Webservice static boolean GenerateInvoiceFromOrder(Id orderId)
    {
        QBOProductList products = QBOProductList.getInstance();
        
        Map<string, QBOProductList.Item >  productMap = new Map<string, QBOProductList.Item  >(); 
        for (QBOProductList.Item item : products.QueryResponse.Item)
        {
            productMap.put(item.Sku, item);
            
        }
        
        system.debug('productMap: ' + productMap);
         
        
        Order order = [SELECT Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , 
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                        	 FROM OrderItems)
                       FROM Order 
                       WHERE Id = :orderId];
        
        QBOInvoice invoice = new QBOInvoice();
        QBOInvoice.Reference custRef = new QBOInvoice.Reference();
        custRef.value = order.Account.QuickBooks_Id__c;
        invoice.CustomerRef = custRef;
        invoice.PrivateNote = order.Description;
        invoice.TxnDate = ((DateTime)order.EffectiveDate).format('YYYY-MM-dd');
        invoice.DueDate = ((DateTime)order.EffectiveDate.addDays(15)).format('YYYY-MM-dd');
        invoice.DocNumber = order.OrderNumber;
        
        
        List<QBOInvoice.Line> invLines = new List<QBOInvoice.Line>();
        for(OrderItem oi : order.OrderItems)
        {
            //system.debug('OrderItem :::::: ' + oi); 
            QBOInvoice.Line line = new QBOInvoice.Line();
           
            line.Amount = oi.Total__c;
            //system.debug('Stall__r :::::: ' + oi.Stall__r.Name); 
            //system.debug('Description :::::: ' + oi.Description); 
            if (oi.Stall__r != null)
            {
                line.Description = oi.Stall__r.Name + ' ';
            } 
            else if (oi.Stall__r != null)
            {
                line.Description += oi.Description;  
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
            string taxCodeRefValue = '10';
            string itemRefValue = '1';
            
            if (item != null)
            {
                itemRefValue = item.Id;
                if (item.SalesTaxCodeRef != null)
                {
                    taxCodeRefValue = item.SalesTaxCodeRef.value;
                }
            }
            
			QBOInvoice.TaxCodeRef taxCodeRef = new QBOInvoice.TaxCodeRef();
            taxCodeRef.value = taxCodeRefValue;//'10';
            lineDetail.TaxCodeRef = taxCodeRef;
            QBOInvoice.Reference itemRef  = new QBOInvoice.Reference();
            itemRef.value = itemRefValue;//'20';
            lineDetail.ItemRef = itemRef;
            line.SalesItemLineDetail = lineDetail;
            
            invLines.add(line);
            
        }
        invoice.Line = invLines;
        
        System.debug('Creating Invoice : ' + system.JSON.serialize(invoice, true));
        
  		QBOCRUDHelper qbo = new QBOCRUDHelper();
        object response = qbo.upsertData('invoice', system.JSON.serialize(invoice, true), QBOInvoiceResponse.class);
        QBOInvoiceResponse invoiceResponse;
        if (response instanceof QBOError){
            //log the error and move to next account
            //ErrorLogHelper.LogAccountError(so, (QBOError)response);
            //continue;
        }else{
            invoiceResponse = (QBOInvoiceResponse)response;
        }
                 
        
        order.QuickBooksId__c = invoiceResponse.Invoice.Id;
        
        update order;
        
        return true;
    }
    
    
    /*static boolean GenerateInvoiceFromOrder(Id orderId)
    {
        
    }*/

}