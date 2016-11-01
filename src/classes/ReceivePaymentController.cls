public class ReceivePaymentController {
    
    public ReceivePaymentController(ApexPages.StandardSetController controller){
        
    }
    
    public PageReference Redirect()
    {
        PageReference newPage;
        Id devRecordTypeId ;
        string returnUrl = ApexPages.currentPage().getParameters().get('retURL') ;
        try
        {
            Id accountId = ApexPages.currentPage().getParameters().get('id') ;
            
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE Name LIKE '%Payments From Accounts%' LIMIT 1];
            newPage  = new PageReference('/a01/e?' + '&RecordType=' + recordType.Id);
        }
        catch(Exception ex)
        { 
            newPage = new PageReference('/a01/e');
        }
        return newPage.setRedirect(true);
    }
}