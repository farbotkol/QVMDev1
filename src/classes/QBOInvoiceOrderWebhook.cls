@RestResource(urlMapping='/QBOInvoiceWebhook/*')
global without sharing class QBOInvoiceOrderWebhook {
    
    @HttpPost	
    global static string post() {
        System.debug('RestContext.request.requestBody.toString()' + RestContext.request.requestBody.toString());
        String res = RestContext.request.requestBody.toString();
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        WebhookInvoice webhookInvoiceObj = WebhookInvoice.parse(res);
        List<Order> orders = [SELECT Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate, Opportunity.Terms__c, Opportunity.Payment_Type__c
                       		,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , 
                        	(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber
                             	,Quantity,ServiceDate,Total__c,UnitPrice,Stall__r.Name, PricebookEntry.Sku__c
                                ,PricebookEntry.Product2.Name
                        	 FROM OrderItems)
                       FROM Order 
                       WHERE RecordTypeId IN (SELECT Id FROM RecordType WHERE Name = 'Accounts Receivable')];
        List<Order> ordersToUpdate = new List<Order>();
        for(WebhookInvoice.Entities entity : webhookInvoiceObj.eventNotifications[0].dataChangeEvent.entities){
            if(entity.name == 'Invoice'){
                Object response = crudHelper.read(entity.name, entity.id, QBOInvoiceList.Class);
                if(response instanceof QBOError){
                    System.debug('error : '  + (QBOError)response); 
                    return null;
                }
                else{
                    List<QBOInvoice> invs = ((QBOInvoiceList)response).queryResponse.invoice;
                    
                    for (QBOInvoice item : invs)
                    {
                        for(Order order: orders)
                        {
                            if(order.QuickBooksId__c == item.Id && order.Id == item.DocNumber){
                                
                            }
                            ordersToUpdate.add(order);
                        }                        
                    }
                }                   
            }
            else if(entity.name == 'Payment'){
                Object response = crudHelper.read(entity.name, entity.id, QBOInvoiceList.Class);
                if(response instanceof QBOError){
                    System.debug('error : '  + (QBOError)response); 
                    return null;
                }
                else{
                    List<QBOInvoice> invs = ((QBOInvoiceList)response).queryResponse.invoice;
                    
                    for (QBOInvoice item : invs)
                    {
                        for(Order order: orders)
                        {
                            if(order.Account.QuickBooks_Id__c == item.CustomerRef.value && order.Id == item.DocNumber){
                                
                            }
                            ordersToUpdate.add(order);
                        }                        
                    }
                }
            }
        }
        Error_Log__c err = new Error_Log__c();
        err.Code__c = 'WEBHOOK';
        //err.Type__c = objType;
        //err.Detail__c = objId;
        err.Message__c = RestContext.request.requestBody.toString().left(200);
        //err.Webhooks__c = RestContext.request.requestBody.toString();
        insert err;
        
        return 'Hi there ' + UserInfo.getUserName();
        
    }
}