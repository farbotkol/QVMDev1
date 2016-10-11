@RestResource(urlMapping='/QBOInvoiceWebhook/*')
global without sharing class QBOInvoiceOrderWebhook {
    public static integer MAXRESULTS = 300;
    @HttpPost	
    global static void post() {
        try{
            System.debug('RestContext.request.requestBody.toString()' + RestContext.request.requestBody.toString());
            QBOCRUDHelper crudHelper = new QBOCRUDHelper();
            String res = RestContext.request.requestBody.toString();
            WebhookInvoice webhookInvoiceObj = WebhookInvoice.parse(res);
            List<String> idInvList = new List<String>();
            List<String> idInvoices = new List<String>();
            List<String> idPayments = new List<String>();
            List<Order> orders = new List<Order>();
            List<Order> ordersToUpdate = new List<Order>();
            integer position = 1;
            
            if(webhookInvoiceObj != null){
                for(WebhookInvoice.Entities entity : webhookInvoiceObj.eventNotifications[0].dataChangeEvent.entities){
                    if(entity.name == 'Payment'){
                        idPayments.add('\''+entity.id+'\'');
                    }
                    else if(entity.name == 'Invoice'){
                        idInvList.add('\''+entity.id+'\'');
                        idInvoices.add(entity.id);
                    }
                }
                
                if(!idPayments.isEmpty()){
                    String payIds = string.join(idPayments,',');
                    payIds = '('+payIds+')';
                    while (position != 0){
                        Integer newStartingPosition;
                        if( position == 1)
                        {
                            newStartingPosition = 1;
                        }
                        else
                        {
                            newStartingPosition =(position  * MAXRESULTS ) - MAXRESULTS + 1; 
                        }
                        String queryPaymentString = 'select line from payment where Id IN ' + payIds+' STARTPOSITION ' + newStartingPosition.format().Replace(',', '') +' MAXRESULTS ' + MAXRESULTS.format();
                        Object paymentResponse =  crudHelper.query(queryPaymentString, QBOPaymentList.Class);
                        if(paymentResponse instanceof QBOError){
                            System.debug('error : '  + (QBOError)paymentResponse); 
                            position = 0;
                        }
                        else{
                            System.debug('Yah!! : '  + (QBOPaymentList)paymentResponse); 
                            System.debug('PP Yah!! : '  + ((QBOPaymentList)paymentResponse).queryResponse.payment);
                            List<QBOPaymentResponse.Payment> pays = ((QBOPaymentList)paymentResponse).queryResponse.payment;
                            
                            if (pays == null || pays.size() == 0 )
                            {
                                system.debug('exit loop: ');
                                position = 0;
                                break;  
                            }
                            if (pays.size() == MAXRESULTS)
                            {
                                system.debug('position before :' + position);
                                position++;
                                system.debug('position after :' + position);
                            }
                            else if  (pays.size()  > 0)
                            {
                                system.debug('setting position to 0 its currenty:' + position);
                                position = 0;
                            }
                            for(QBOPaymentResponse.Payment pay : pays){
                                List<QBOPaymentResponse.Line> lines = pay.Line;
                                for(QBOPaymentResponse.Line line : lines){
                                    idInvList.add('\''+line.LinkedTxn[0].TxnId+'\'');
                                    idInvoices.add(line.LinkedTxn[0].TxnId);
                                }
                            }
                        }
                    }
                }
                if(!idInvoices.isEmpty()){
                    orders = [SELECT Id,QuickBooksId__c,Balance_Due__c,Total_With_GST__c 
                              FROM Order 
                              WHERE QuickBooksId__c IN :idInvoices];
                }
                System.debug('idInvoices : '+idInvoices);
                System.debug('orders : '+orders);
                String invIds = string.join(idInvList,',');
                invIds = '('+invIds+')';
                position = 1;
                while (position != 0){
                    Integer newStartingPosition;
                    if( position == 1)
                    {
                        newStartingPosition = 1;
                    }
                    else
                    {
                        newStartingPosition =(position  * MAXRESULTS ) - MAXRESULTS + 1; 
                    }
                    String queryString = 'select Id,TotalAmt,Balance from INVOICE where Id IN ' + invIds+' STARTPOSITION ' + newStartingPosition.format().Replace(',', '') +' MAXRESULTS ' + MAXRESULTS.format();
                    Object response =  crudHelper.query(queryString, QBOInvoiceList.Class);
                    if(response instanceof QBOError){
                        System.debug('error : '  + (QBOError)response); 
                        position = 0;
                    }
                    else{
                        System.debug('Yah!! : '  + (QBOInvoiceList)response); 
                        System.debug('PP Yah!! : '  + ((QBOInvoiceList)response).queryResponse.invoice);
                        List<QBOInvoice> invs = ((QBOInvoiceList)response).queryResponse.invoice;
                        if (invs == null || invs.size() == 0 )
                        {
                            system.debug('exit loop: ');
                            position = 0;
                            break;  
                        }
                        if (invs.size() == MAXRESULTS)
                        {
                            system.debug('position before :' + position);
                            position++;
                            system.debug('position after :' + position);
                        }
                        else if  (invs.size()  > 0)
                        {
                            system.debug('setting position to 0 its currenty:' + position);
                            position = 0;
                        }
                        for (Order order: orders)
                        {
                            for(QBOInvoice item : invs){
                                if(order.QuickBooksId__c == item.Id){
                                    order.Balance_Due__c = item.Balance;
                                    order.Total_With_GST__c = item.TotalAmt;
                                }
                                
                            }
                            ordersToUpdate.add(order); 
                        }
                    }
                }
                if(!ordersToUpdate.isEmpty()){
                    update ordersToUpdate;
                }
            }
            
        }
        catch(Exception ex){
            
        }
        Error_Log__c err = new Error_Log__c();
        err.Code__c = 'WEBHOOK';
        err.Message__c = RestContext.request.requestBody.toString().left(200);
        err.Webhooks__c = RestContext.request.requestBody.toString().left(32766);
        insert err;        
    }
}