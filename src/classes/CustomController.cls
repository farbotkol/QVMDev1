// base class for our custom controllers, this simply adds some helper methods
// for interacting with the static APEX class methods
public abstract class CustomController {
	
    protected void addError(String format, List<String> arguments ){
    
        addMessage(ApexPages.Severity.ERROR,String.format(format,arguments),null);
    }
    protected void addMessage(ApexPages.Severity messageSeverity ,String messageText){
        addMessage(messageSeverity,messageText, null);
    }

    protected virtual ApexPages.Message addMessage(ApexPages.Severity messageSeverity ,String messageText, String detailText){
        //All other message methods should end up here - this way we can intercept 
        //in one place when testing 
        ApexPages.Message retVal;
        if (detailText==null) {
            retVal = new ApexPages.Message(messageSeverity,messageText);
        } else {
            retVal = new ApexPages.Message(messageSeverity,messageText,detailText);
        }

        ApexPages.addMessage(retVal);
        return retVal;
        
    }
    protected void addError(String messageText){
        addMessage(ApexPages.Severity.ERROR,messageText,null);
    }
    protected void addError(Exception ex){
                
        String detail;        
        Exception cause = ex.getCause();
        if (cause!=null) {
            detail = cause.getMessage();

        }
        addMessage(ApexPages.Severity.ERROR, ex.getMessage(), detail);
    }
    protected void addError(System.Exception ex, String messageText){
        String detail= ex.getMessage() + ex.getStackTraceString();
        addMessage(ApexPages.Severity.ERROR, messageText, detail);
    }
    protected void addUnexpectedError(System.Exception ex) {
        String message = 'We were unable to complete your request, please try again later.  If the problem persists please contact your support representative and provide the additional information below.';
        addError(ex,message);
    }
        protected void addBadRequestError(String detailText){
        addMessage(ApexPages.Severity.ERROR,'Bad request',detailText);
    }
    public Boolean getHasError()
    {
        List<ApexPages.Message> messages = ApexPages.getMessages();
        
        for(ApexPages.Message message : messages) {
            ApexPages.Severity severity = message.getSeverity();
            if (severity ==ApexPages.Severity.ERROR || severity == ApexPages.Severity.FATAL) {
                return true;
            }
        }
        return false;
    }
}