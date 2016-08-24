trigger LeaveTrigger on Leave__c (before insert, before update, after insert, after update , after delete) 
{

    if(( Trigger.isInsert || Trigger.isUpdate ) && Trigger.isAfter)
    {
    	LeaveTriggerHelper.UpdateLeaveTakenThisYear(Trigger.new, false);   
    }
    if(Trigger.isDelete && Trigger.isAfter) 
    {
    	LeaveTriggerHelper.UpdateLeaveTakenThisYear(Trigger.old, true);
	}
}