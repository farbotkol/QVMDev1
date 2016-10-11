trigger LeadTrigger on Lead (after update) {

    Map <ID, Lead> updatedOppLeads = new Map <ID, Lead>();
    Map <ID, Lead> updatedAccountLeads = new Map <ID, Lead>();
       
    for (Lead l1: Trigger.new)
    {
        for (Lead l2: Trigger.old)
        {
            if ((l1.id == l2.id) && (l1.ConvertedOpportunityId  != l2.ConvertedOpportunityId)) 
            {
                updatedOppLeads.put(l1.id, l1);
            } 

            if ((l1.id == l2.id) && (l1.ConvertedAccountId  != l2.ConvertedAccountId)) 
            {
                updatedAccountLeads.put(l1.id, l1);
            }           
            
        }
    }

    if(updatedOppLeads.size()>0)
    { 
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();   

        for(Lead l : updatedOppLeads.values())
        {
            Opportunity opp = new Opportunity(id=l.ConvertedOpportunityId, Primary_Contact__c =l.ConvertedContactId);
            oppMap.put(l.ConvertedOpportunityId, opp);
        } 

        if(oppMap.size()>0)
        {
            update oppMap.values();
        }       
    }

    if(updatedAccountLeads.size()>0)
    {   
        Map<Id, Account> acctMap = new Map<Id, Account>(); 
        
        //-------------- New changes starts --------------
        Set <Id> setAccountIds = new Set<Id>();        
        for(Lead l : updatedAccountLeads.values())
        {
            setAccountIds.add( l.ConvertedAccountId);
        }
        
        List<Account> convertedAccountList= [ SELECT id,Primary_Contact__c from Account where Id IN:setAccountIds];
        Map<Id, Id> accountPrimaryContactmap = new Map<Id,Id>();
        for( Account aa : convertedAccountList )
        {
           accountPrimaryContactmap.put(aa.id, aa.Primary_Contact__c);
        }
        // ------------New changes ends--------------------
        
        List<AccountContactRole> newAccRoleList = new List<AccountContactRole>();
        for(Lead l : updatedAccountLeads.values())
        {
            // ------------New changes starts--------------------
            AccountContactRole accRole = new AccountContactRole();
            accRole.ContactId  = l.ConvertedContactId;
            accRole.AccountId  = l.ConvertedAccountId;
            accRole.Role = 'Manager';
            if( accountPrimaryContactmap.get(l.ConvertedAccountId) == null)
            {
                accRole.IsPrimary = true;
            }
            newAccRoleList.add(accRole);
            // ------------New changes ends--------------------
            
            
            if( accountPrimaryContactmap.get(l.ConvertedAccountId) == null)// New change....
            {
            	Account acct = new Account(id=l.ConvertedAccountId, Primary_Contact__c =l.ConvertedContactId);
            	acctMap.put(l.ConvertedAccountId, acct);
            }
        } 
        if(newAccRoleList.size() > 0 )
        {
            insert newAccRoleList;
        }
        if(acctMap.size()>0)
        {
            update acctMap.values();            
        }
        
    }
}