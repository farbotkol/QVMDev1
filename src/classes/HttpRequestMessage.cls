public class HttpRequestMessage {
    private HttpContent content;
    private HttpMethod method;
    private String requestUri;
    //contains general request and content specific headers

    private final HttpRequestHeaders headers; 
    public HttpRequestMessage() {
        this(null,null);
    }
    public HttpRequestMessage(String requestUri) {
        this(null,requestUri);
    }
    
    public HttpRequestMessage(HttpMethod method, String requestUri) {
        this.method = (method==null ? HttpMethod.GET :method);
        this.requestUri = requestUri;
        this.headers = new HttpRequestHeaders();
    }
    public HttpRequestHeaders getHeaders(){
        return headers;
    }
   
    
    public String getRequestUri(){
        return requestUri;
    }
    
    //RequestUri - if undefined will use the endpoint address for the HttpClient, if a complete Uri is specified then 
    //the request's URI will be used.  If a fragment is provided then the endpoint address from the client and 
    //the fragment specified here will be combined when the request is sent
    public void setRequestUri(String requestUri) {
        this.requestUri = requestUri;
    }

    public HttpContent getContent() {
        return content;
    }

    public void setContent(HttpContent content){
        
        system.debug(content);
        this.content = content;
    }

    public HttpMethod getMethod(){
        return method;
    }

    public void setMethod(HttpMethod method){
        if (method==null)
        {
            throw ArgumentNullException.create('method');
        }
        this.method = method;
    }

}