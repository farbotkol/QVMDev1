public class NewOrderControllerExt {
    
    
    public  NewOrderControllerExt(ApexPages.StandardSetController controller)
    {
       
    }
    
    public PageReference Redirect()
    {
        PageReference newPage;
        Id devRecordTypeId ;
        string returnUrl = ApexPages.currentPage().getParameters().get('retURL') ;
        try
        {
             system.debug('current Page' + ApexPages.currentPage());
             system.debug('aid :' + ApexPages.currentPage().getParameters().get('id'));
             Id accountId = ApexPages.currentPage().getParameters().get('id') ;
             
            
             Account acct = [SELECT Id, RecordType.Name from Account where id = :accountId LIMIT 1];
             system.debug('acct: ' + acct);
            
             if (acct.RecordType.Name == 'Trader')
             {
                 devRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Accounts Receivable').getRecordTypeId();
              
             }
             else 
             {
                 devRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Accounts Payable').getRecordTypeId();
             }
             //      retURL=%2F001p000000Df4Gr&aid=001p000000Df4Gr&sfdc.override=1
             //801/e?retURL=%2F001p000000Df4Gr&aid=001p000000Df4Gr&RecordType=012p0000000CgVq&ent=Order
             newPage  = new PageReference('/801/e?retURL=' + returnUrl + '&aid=' + accountId + '&ent=Order&RecordType=' + devRecordTypeId );
             
        }
        catch(Exception ex)
        {
            // we are in an opp 
             Id orderId = ApexPages.currentPage().getParameters().get('id') ;
             Opportunity opp  = [SELECT Id, AccountId from Opportunity where id = :orderId LIMIT 1];
             devRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Accounts Receivable').getRecordTypeId();    
             newPage  = new PageReference('/801/e?retURL=' + returnUrl + '&aid=' + opp.AccountId + '&oid=' + opp.Id + '&ent=Order&RecordType=' + devRecordTypeId );
             
        }
        return  newPage.setRedirect(true);
        // return null;
    }
}