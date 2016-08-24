public class HttpResponseMessage {
	private HttpRequestMessage requestMessage;
	private HttpContent content;
	private String reasonPhrase;
	private final Integer statusCode;
	private final HttpResponseHeaders headers;
    
	public static HttpResponseMessage create(HttpResponse response){
		HttpResponseMessage retVal = new HttpResponseMessage(response.getStatusCode());
		 
		retVal.setReasonPhrase(response.getStatus());
        HttpParameterList headerValues= retVal.getHeaders().getHeaders();
		for(String headerName : response.getHeaderKeys()){
            //weird that it would return a null but it does..
            //then the 'getHeader' method call fails..
            if (headerName==null){
                continue;
            }
            headerValues.add(headerName, response.getHeader(headerName));
        }
        retVal.setContent(HttpContent.fromResponse(response));
        
		return retVal;
	}
    
	public HttpResponseMessage(Integer statusCode) {
		if (statusCode==null){
			throw ArgumentNullException.create('statusCode');
		}
		this.statusCode = statusCode;
        this.headers = new HttpResponseHeaders();
	}
    public HttpResponseHeaders getHeaders(){
        return headers;
    }
	public Integer getStatusCode(){
		return this.statusCode;
	}
	public HttpRequestMessage getRequestMessage(){
		return requestMessage;
	}
	public void setRequestMessage(HttpRequestMessage requestMessage){
		this.requestMessage =requestMessage;
	}

	public String getReasonPhrase(){
		//TODO: if this is not defined return a 'default' message for the status code
		return reasonPhrase;
	}
	public void setReasonPhrase(String reasonPhrase)
	{
		this.reasonPhrase = reasonPhrase;
	}

	public Boolean isSuccessStatusCode() {
		return statusCode >= 200 && statusCode<=299;
	}
	public void ensureIsSuccessStatusCode()
	{
		if (!isSuccessStatusCode()){
			String message ='Server responded '+statusCode;
			if (!string.isBlank(reasonPhrase)){
				message = message+ ' ('+reasonPhrase + ')';
			}
			throw new CalloutException(message,null);
		}
	}
    
	public HttpContent getContent()
	{
		return content;
	}
	public void setContent(HttpContent content){
		this.content = content;
	}
}