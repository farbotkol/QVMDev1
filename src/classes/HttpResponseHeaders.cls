public class HttpResponseHeaders {
    private final HttpParameterList headers;
    //we don't expose the content related headers in here - the content class itself does that
 	public HttpResponseHeaders(){
        this(new HttpParameterList());
    }
    public HttpResponseHeaders(HttpParameterList headers){
        this.headers = headers;
    }
    public HttpParameterList getHeaders(){
        return headers;
    }
    public String getWwwAuthenticate(){
        return headers.getValue('WWW-Authenticate');
    }
    public String getServer(){
        return headers.getValue('Server');
    }
}