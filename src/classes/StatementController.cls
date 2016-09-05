public without sharing class StatementController {
    
    public static void getStatement() {
        
        
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        
        String customerRef = [SELECT QuickBooks_Id__c FROM Account
     				WHERE ID in
     				(SELECT AccountId FROM User WHERE Id = :userinfo.getUserId())].QuickBooks_Id__c;
        //  '005p0000000uK5d'
		System.debug('PP customerRef '+customerRef);
        
        Object res =  crudHelper.report('CustomerBalanceDetail','customer=\'' + String.escapeSingleQuotes(customerRef)+'\''+'&arpaid=All&sort_by=tx_date&sort_order=descend',QBOCustomerBalanceDetail.class); 
                
        if (res instanceof QBOError)
        {
            System.debug('error : '  + (QBOError)res); 
        }
        else 
        {
            System.debug('Yah!! : '  + (QBOCustomerBalanceDetail)res);             
        }
    }
}