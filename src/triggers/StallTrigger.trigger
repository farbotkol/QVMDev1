trigger StallTrigger on Stall__c (before insert, before update) {

     if((trigger.isUpdate || trigger.isInsert) && trigger.isBefore) 
     {
         
		StallTriggerHelper.UpdateStallValues(trigger.new);
     }
}