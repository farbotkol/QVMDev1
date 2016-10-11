global class ScheduleReconnect implements Schedulable {
   global void execute(SchedulableContext SC) {
    	QBOCRUDHelper.callReconnectTocken();
   }
}