public class NoticeOfBreachController {
    public string myId {get;set;}
    public string strConvertedDate {get;set;}
    public Case standardCase{get;set;}
    public NoticeOfBreachController(ApexPages.StandardController stdcontroller){
        myId = ApexPages.currentPage().getParameters().get('id');
        //standardCase = (Case)stdcontroller.getRecord();
        system.debug(standardCase);
        standardCase = [Select Id, BreachDateAndTime__c FROM Case WHERE Id = :myId];
        strConvertedDate = standardCase.BreachDateAndTime__c.format('MMMM d\',\'  yyyy \'at\' hh:mm a', UserInfo.getTimeZone().toString());
     }
}