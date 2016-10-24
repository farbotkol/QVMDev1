public class UpdatePrimaryContact {
    public static void startUpdate(){
        updateOpportunity();
        updateAccount();
    }
    
    private static void updateOpportunity(){
        List<Opportunity> opportunities = [Select Id, Primary_Contact__c 
                                           From Opportunity 
                                           where id in (Select OpportunityId From OpportunityContactRole 
                                                        WHERE LastModifiedDate = THIS_WEEK AND IsPrimary = true)];
        List<OpportunityContactRole> opportunityContactRole = [SELECT OpportunityId, ContactId, IsPrimary 
                                                               FROM OpportunityContactRole 
                                                               WHERE LastModifiedDate = THIS_WEEK AND IsPrimary = true];
        Map<Id,OpportunityContactRole> opportunityContactRoleMap = new Map<Id,OpportunityContactRole>();
        for (OpportunityContactRole oppContactRole : opportunityContactRole) {
            opportunityContactRoleMap.put(oppContactRole.OpportunityId,oppContactRole);
        }
        
        for (Opportunity opp : opportunities) {
            OpportunityContactRole oppTemp = opportunityContactRoleMap.get(opp.Id);
                if(opp.Primary_Contact__c != oppTemp.ContactId){
            		opp.Primary_Contact__c = oppTemp.ContactId;
                    //System.debug(oppTemp.ContactId);
            }
        }
        // save the change you made
        update opportunities;
    }
    
    private static void updateAccount(){
        List<Account> accounts = [Select Id, Primary_Contact__c 
                                           From Account 
                                           where id in (Select AccountId From AccountContactRole 
                                                        WHERE LastModifiedDate = THIS_WEEK AND IsPrimary = true)];
        List<AccountContactRole> accountContactRole = [SELECT AccountId, ContactId, IsPrimary 
                                                               FROM AccountContactRole 
                                                               WHERE LastModifiedDate = THIS_WEEK AND IsPrimary = true];
        Map<Id,AccountContactRole> accountContactRoleMap = new Map<Id,AccountContactRole>();
        for (AccountContactRole accContactRole : accountContactRole) {
            accountContactRoleMap.put(accContactRole.AccountId,accContactRole);
        }
        
        for (Account acc : accounts) {
            AccountContactRole accTemp = accountContactRoleMap.get(acc.Id);
                if(acc.Primary_Contact__c != accTemp.ContactId){
            		acc.Primary_Contact__c = accTemp.ContactId;
                    //System.debug(accTemp.ContactId);
            }
        }
        // save the change you made
        update accounts;
    }
}