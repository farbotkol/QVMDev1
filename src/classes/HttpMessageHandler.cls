public virtual class HttpMessageHandler {
    transient private IHttpRequestDispatcher dispatcher;
    private String endpointAddress;
    private String userAgent;
    private HttpRequestHeaders defaultHeaders;
    public HttpMessageHandler(){
        this(null);
    }
    
    public HttpMessageHandler(String endpointAddress){
        this.endpointAddress = endpointAddress;
        this.defaultHeaders = new HttpRequestHeaders(new HttpParameterList());
    }
    public String getUserAgent(){
        return userAgent;
    }
    public void setUserAgent(String value){
        this.userAgent = value;
    }
    protected virtual void prepareContent(HttpRequest request, HttpRequestMessage requestMessage){
        
        HttpContent content = requestMessage.getContent();

        if (content!=null){
            content.writeTo( request);
        }
    }
    //for testing only

    public void setDispatcher(IHttpRequestDispatcher dispatcher){
        this.dispatcher = dispatcher;
    }
    //when testing the dispatcher may have been injected in test setup
    private IHttpRequestDispatcher getDispatcher(){
        if (dispatcher==null) {
            dispatcher = new HttpRequestDispatcher();
        }
        return dispatcher;
    }
    private void prepareEndpoint(HttpRequest request, HttpRequestMessage requestMessage){
        String requestUri = requestMessage.getRequestUri();
        if (String.IsBlank(requestUri)){
            if (String.isBlank(this.endpointAddress)){
                throw  InvalidOperationException.create().withMessage('Unable to determine endpoint address for request, set an address in the HttpClient or HttpRequestMessage');
            }
            request.setEndpoint(this.endpointAddress);
        } else {
            //TODO: Add support for named callouts 
            UriBuilder uriBuilder = new UriBuilder(requestUri);

            if (!uriBuilder.isAbsoluteUri()){
                if (String.isBlank(this.endpointAddress)){
                    throw new UnsupportedOperationException('Request has a relative address and no endpoint address is spcified for the HttpClient');
                }
                
                //combine the baseUri with the base
                uriBuilder = new UriBuilder(this.endpointAddress, uriBuilder);
            }
            request.setEndpoint(uriBuilder.toString());
        }
    }
    protected virtual void prepareHeaders(HttpRequest request,HttpRequestMessage requestMessage){
        //add use agent header if required
        Iterator<HttpParameter> it = requestMessage.getHeaders().mergeWith(defaultHeaders).iterator();
        while(it.hasNext()){
            HttpParameter header = it.next();
            request.setHeader(header.name, header.value);
        }
    
    }
    public HttpResponseMessage send(HttpRequestMessage requestMessage){
        if (requestMessage==null){throw ArgumentNullException.create('requestMessage');}

        HttpRequest request = new HttpRequest();
        request.setMethod(requestMessage.getMethod().toString());
        
        System.debug('HttpRequestMessage request:' + request);
        System.debug('HttpRequestMessage requestMessage:' + requestMessage);
        prepareEndpoint(request, requestMessage);
        prepareHeaders(request, requestMessage);
        prepareContent(request, requestMessage);
    
        HttpResponse response = send(request);
        
        HttpResponseMessage responseMessage = HttpResponseMessage.create(response);
        responseMessage.setRequestMessage(requestMessage);
        return responseMessage;
    }
    
    protected virtual HttpResponse send(HttpRequest request) {
        return getDispatcher().send(request);
    }
}