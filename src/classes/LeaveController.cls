public without sharing class LeaveController {
    @AuraEnabled
    public static String getAccountId(){
        String accId = [SELECT AccountId FROM User WHERE Id = :userinfo.getUserId()].AccountId;
        return accId;
    }
    @AuraEnabled
    public static List<Opportunity> getAccountBusiness() {
        
        String accId = LeaveController.getAccountId();
        if(accId != null){
            List<Opportunity> accBusiness = [SELECT Id,Name,RecordType.Name,Leave_Remaining_Monday__c,Leave_Remaining_Tuesday__c,Leave_Remaining_Wednesday__c,
                                             Leave_Remaining_Thursday__c,Leave_Remaining_Friday__c,Leave_Remaining_Saturday__c,Leave_Remaining_Sunday__c
                                             , (select id, Name,Leave_Date__c from Leave__r)
                                             FROM Opportunity
                                             WHERE AccountId  = :accId];
            System.debug('PP '+accBusiness.get(0).RecordType.Name);
            System.debug('accBusiness '+accBusiness);
            if(accBusiness != null){
                return accBusiness;
            }
            else
                return null;
        }
        else
            return null;
    }
    
    @AuraEnabled
    public static void createLeave(String accBusinessId, String leaveDate) {
        System.debug('Hello accBusinessId '+accBusinessId);
        System.debug('Hello leaveDate '+leaveDate);
        if(accBusinessId != null && leaveDate != null){
            Leave__c leaveObj = new Leave__c();
            leaveObj.Account_Business__c = accBusinessId;
            leaveObj.Leave_Date__c = Date.valueOf(leaveDate);
            insert leaveObj;
            
        }
    }
    
}