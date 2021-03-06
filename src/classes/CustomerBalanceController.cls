public without sharing class CustomerBalanceController {
    
    public id accountID {get;set;}
    
    public CustomerBalanceController(ApexPages.StandardController controller) {
        accountID = ((Account)controller.getRecord()).id;
    }
    
    @AuraEnabled
    public static Double getCustomerBalance() {
                
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        
        String qboID = [SELECT QuickBooks_Id__c FROM Account
     				WHERE ID in
     				(SELECT AccountId FROM User WHERE Id =: userinfo.getUserId())].QuickBooks_Id__c;
        // '005p0000000uK5d'
        System.debug(qboID);
        if (qboID != null){
            QBOCustomerResponse customerResponse = (QBOCustomerResponse)crudHelper.read( 'customer', qboID , QBOCustomerResponse.class);
            System.debug('READ customerResponse: ' + customerResponse); 
            System.debug('READ customerResponse: ' + ((QBOCustomerResponse)customerResponse).Customer.Balance);
            return ((QBOCustomerResponse)customerResponse).Customer.Balance;
        }
        else
            return null;
    }
    
    public Double getCustomerBalanceVFP() {        
        
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        
        String qboID = [SELECT QuickBooks_Id__c FROM Account
     				WHERE ID =: accountID].QuickBooks_Id__c;
        
        // '005p0000000uK5d'
        System.debug(qboID);
        
        if (qboID != null){
            
            QBOCustomerResponse customerResponse = (QBOCustomerResponse)crudHelper.read( 'customer', qboID , QBOCustomerResponse.class);
            System.debug('READ customerResponse: ' + customerResponse); 
            System.debug('READ customerResponse: ' + ((QBOCustomerResponse)customerResponse).Customer.Balance);
            return ((QBOCustomerResponse)customerResponse).Customer.Balance;
			
            //return qboID;
        }
        else
            return null;
		
        //return 2.0;
    }
}