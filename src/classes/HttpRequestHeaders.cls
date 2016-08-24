public class HttpRequestHeaders  {
	private HttpParameterList headers;
   	
    public HttpRequestHeaders(){
        this(new HttpParameterList());
    }
    public HttpRequestHeaders(HttpParameterList headers){
        this.headers = headers;
    }
    public Iterable<HttpParameter> mergeWith(HttpRequestHeaders defaultValues){
        return headers.mergeWith(defaultValues.headers);
    }
    public String getUserAgent(){
        return headers.getValue('User-Agent');
    }
    public void setUserAgent(String value){
        if (String.isEmpty(value)){
            headers.remove('User-Agent');
        } else {
            headers.setValue('User-Agent', value);
        }
    }
    public String getHeader(String name){
        return headers.getValue(name);
    }
    public Boolean containsHeader(String name){
        return headers.indexOf(name)>=0;
    }
    public void setHeader(String name, String value){
        headers.setValue(name, value);
    }
     public MediaType getAccept(){
        String headerValue = headers.getValue('Accept');
        if (String.isEmpty(headerValue)){
            return null;
        }
        return new MediaType( headerValue);
    }
    public void setAccept(MediaType value)
    {
        if (value==null) {
            headers.remove('Accept');
        } else {
            headers.setValue('Accept', value.toString());
        }
    }
    public void setHost(String value)
    {
        if (value==null) {
            headers.remove('Host');
        } else {
            headers.setValue('Host', value);
        }
    }
    public void getHost(String value)
    {
        
        headers.getValue('Host');
        
    }
}