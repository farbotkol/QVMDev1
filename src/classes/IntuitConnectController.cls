public class IntuitConnectController {
    
    public String getGrantUrl()
    {
        
    	UriBuilder builder=new UriBuilder(Url.getSalesforceBaseUrl().toString(),'apex/ApiConnect' );
        builder.setQuery('api=intuit');
        String grantUrl = builder.toString();
        Log.debug('Connect to quickbooks grant URL:{0}', grantUrl);
        
        return grantUrl;
        
    }	
    
}