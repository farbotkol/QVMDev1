global class ScheduleUpdatePrimaryContact implements Schedulable {
   global void execute(SchedulableContext SC) {
    	//QBOCRUDHelper.callReconnectTocken();
    	UpdatePrimaryContact.startUpdate();
   }
}