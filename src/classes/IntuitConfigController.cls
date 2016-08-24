//this controller is for testing the connectivity to QuickBooks
public class IntuitConfigController extends CustomController{
	private String queryText;
    private String jsonResult;
    
    public String getQueryText(){
        return queryText;
    }
    public void setQueryText(String queryText){
        this.queryText = queryText;
    }
    public String getJsonResult()
    {
        return jsonResult;
    }
    public void execute(){
        if (!String.isBlank(queryText)){
           
            try
            {
                 HttpClient client = IntuitService.createClient();
            	jsonResult=(String) client.jsonGet('query?query='+EncodingUtil.urlEncode(queryText, 'UTF-8'), String.class);    
            } catch(Exception ex){
                addError(ex,'Error sending message to quickbooks');
            }
            
        }
    }
}