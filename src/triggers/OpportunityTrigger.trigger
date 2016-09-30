trigger OpportunityTrigger on Opportunity (after update, after insert) {
     if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter) 
     {
         OpportunityTriggerHelper.UpdateStallValues(trigger.new);
     }
}