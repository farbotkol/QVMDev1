public class NoticeOfBreachController {
    public string myId {get;set;}
    public string strConvertedDate {get;set;}
    public string SubjectTitle {get;set;}
    public string SubjectDescription {get;set;}
    public string DescriptionTitle {get;set;}
    public string DescriptionDescription {get;set;}
    public Case standardCase{get;set;}
    
    public NoticeOfBreachController(ApexPages.StandardController stdcontroller){
        myId = ApexPages.currentPage().getParameters().get('id');
        //standardCase = (Case)stdcontroller.getRecord();
        system.debug(standardCase);
        standardCase = [Select Id, BreachDateAndTime__c,Subject,Description FROM Case WHERE Id = :myId];
        if(standardCase.BreachDateAndTime__c == null){
        	strConvertedDate = '(null)';
        }else{
        	strConvertedDate = standardCase.BreachDateAndTime__c.format('MMMM d\',\'  yyyy \'at\' hh:mm a', UserInfo.getTimeZone().toString());
        }
        if(standardCase.Subject == null){
            SubjectTitle = '';
            SubjectDescription = '';
        }else{
            SubjectTitle = 'Subject:';
            SubjectDescription = standardCase.Subject;
        }
        if(standardCase.Description == null){
            DescriptionTitle = '';
            DescriptionDescription = '';
        }else{
            DescriptionTitle = 'Description:';
            DescriptionDescription = standardCase.Description;
        }
     }
}