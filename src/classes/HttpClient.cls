public virtual class HttpClient {
    //allow tests to get here and change the dispatcher
    
    public final HttpMessageHandler messageHandler;

    public HttpClient(){
        this(new HttpMessageHandler());
    }
    public HttpClient(String endpointAddress){
        this(new HttpMessageHandler(endpointAddress)); 
    }
    public HttpClient(HttpMessageHandler messageHandler) {
        if (messageHandler ==null){
            throw ArgumentNullException.create('messageHandler');
        }
        this.messageHandler = messageHandler;
    }

    public static HttpContentType getContentType(HttpRequest request){
        return new HttpContentType(request.getHeader( 'Content-Type'));
    }
    public static HttpMethod getMethod(HttpRequest request){
        String method= request.getMethod();
        if (String.isBlank(method)){
            return null;
        }
        return new HttpMethod(method);
    }
    public Object jsonRequest(HttpMethod method, String requestUri, HttpContent content, Type responseApexType){
        HttpRequestMessage request = new HttpRequestMessage(method, requestUri);
        request.getHeaders().setAccept( MediaType.json);
        if (content!=null){
            system.debug('Httpcontent is not null' + content);
            
            request.setContent(content);
        }
         system.debug('Request : ' + request);
        HttpResponseMessage response = send(request);
        response.ensureIsSuccessStatusCode();
        HttpContent reponseContent = response.getContent();
        if (!(reponseContent instanceof HttpContent.Json)){
            //Log.error('Expected JSON content, found {0}\n{1}', response.getContentType(), request);
            throw new CalloutException('Response was not JSON');
        }
        
        
        HttpContent.Json jsonContent = (HttpContent.Json) reponseContent;
        if (responseApexType ==null){
            //untyped - so a Map
            return jsonContent.deserialize();
        } if (responseApexType==  String.class){
            //the raw string
            return jsonContent.getContent().toString();
        }
        return jsonContent.deserializeAs(responseApexType);
    }
    //Accepts absolute or relative URIs, when using relative URIs
    //don't prefix with a / you can however do ./
    // if you use / then the final URI will be from the root path for
    // the host
    public Object jsonGet(String requestUri, Type responseApexType){
        return jsonRequest(HttpMethod.GET,requestUri,null, responseApexType);
    }
    
	public Object jsonPost(String requestUri,Object requestObject, Type responseApexType){
        system.debug('Request json: ' +  (new HttpContent.Json(requestObject)).getContent().toString());
        return jsonRequest(HttpMethod.Post,requestUri, new HttpContent.Json(requestObject), responseApexType);
    }    
    //send the request and get a response
    public HttpResponseMessage send(HttpRequestMessage requestMessage){
        system.debug('messageHandler :' + messageHandler);
        system.debug('HttpRequestMessage :' + requestMessage);
        return messageHandler.send(requestMessage);
    }
}