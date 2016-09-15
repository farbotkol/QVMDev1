public class OpportunityTriggerHelper {
	public static void UpdateStallValues(List<Opportunity> opps)
    {
        set<Id> oppIds = new set<Id>();
        
        for (Opportunity opp : opps)
        {
            oppIds.add(opp.Id);
        }
        
        
        list<Stall__c> stalls = [SELECT FridayTrader__c,MondayTrader__c,Name,SaturdayTrader__c
                                        ,SundayTrader__c,ThursdayTrader__c,TuesdayTrader__c,WednesdayTrader__c
               					,Friday_Active_Price__c,Monday_Active_Price__c,Saturday_Active_Price__c
               					,Sunday_Active_Price__c,Thursday_Active_Price__c,Tuesday_Active_Price__c
               					,Wednesday_Active_Price__c, FridayMultiplier__c,MondayMultiplier__c
                                ,SaturdayMultiplier__c,SundayMultiplier__c,ThursdayMultiplier__c
                                 ,TuesdayMultiplier__c,WednesdayMultiplier__c
               					FROM Stall__c
                                where MondayTrader__c in  :oppIds    or
                                TuesdayTrader__c in  :oppIds    or
                                WednesdayTrader__c in  :oppIds   or
                                ThursdayTrader__c in  :oppIds   or
                                FridayTrader__c in  :oppIds or
                                SaturdayTrader__c in  :oppIds  or
                                SundayTrader__c in  :oppIds ];
        
        update StallTriggerHelper.UpdateStallValues(stalls);
        
    }
}