//Container class for any form of payload to be sent in a HttpRequest
public abstract class HttpContent {
	private final HttpContentType contentType;
	
   
    
    
    
   
	protected virtual HttpContentType getContentType() {
		return contentType;
	}
	
	public static HttpContent fromResponse(HttpResponse response)
    {
		 return fromSource(new ResponseContent(response));
	} 
	private interface IHasContent
	{
		String getHeader(String headerName);
		void setHeader(String headerName, String value);
		Blob getBody();
		void setBody(Blob body);
	}
	private class ResponseContent implements IHasContent
	{
		private final HttpResponse response;
		public ResponseContent(HttpResponse response){
			this.response = response;
		}
		public String getHeader(String key){
			return response.getHeader(key);
		}
		public void setHeader(String key, String value){
			response.setHeader(key,value);
		}
		public void setBody(Blob body){
			response.setBodyAsBlob(body);
		}
		public Blob getBody()	{
			return response.getBodyAsBlob();
		}
	}
	//adapter class to make request and response objects look behave the same
	private class RequestContent implements IHasContent
	{
		private final HttpRequest request;
		public RequestContent(HttpRequest request){
			this.request = request;
		}
		public String getHeader(String key){
			return request.getHeader(key);
		}
		public void setHeader(String key, String value){
			request.setHeader(key,value);
		}
		public void setBody(Blob body){
			request.setBodyAsBlob(body);
		}
		public Blob getBody()	{
			return request.getBodyAsBlob();
		}
	}
	private static Integer getContentLength(IHasContent content)
	{
		String value = content.getHeader('Content-Length');
		if (String.isEmpty(value)){
			return null;
		}
		return Integer.valueOf(value);
	}
	private static HttpContent fromSource(IHasContent source){
		 HttpContentType contentType = new HttpContentType(source.getHeader('Content-Type'));
		 Integer contentLength = getContentLength(source);
		 Log.debug('Content Length: {0}',contentLength);		
		 Log.debug('Content Type Header: {0}',contentType);
		 
		 //should really be a factory but doing this in APEX is a bit of a faff
		 //so do it the old way
		 HttpContent retVal;
		 if (contentType.is(MediaType.json)) {
		 	//do something
		 	retVal=new Json();
		 } else if (contentType.is(MediaType.FormUrlEncoded))
		 {
		 	retVal= new FormUrlEncoded();
		 } else {
		 	 retval = new PlainText();
		 }		 //TODO: any other text content types
		
		 retVal.readFrom(source);
		 return retVal;
		 
	}
	public static HttpContent fromRequest(HttpRequest request){
		return fromSource(new RequestContent(request));
	}

	public class Json extends HttpContent {
	 	private Blob content;

	 	public Json(Object payload){
	 		this();
	 		setPayload(payload);
	 	}

	 	public Json() {
			super(new HttpContentType(MediaType.json));
		}
		public void setPayload(Object payload){
			if (payload==null){
				content =null;
			} else {
				content = Blob.valueOf( System.JSON.serialize(payload, true));
			}
		}
        
        
        
		public override void readFrom(IHasContent source){
			content = source.getBody();
		}
        public Blob getContent(){
            return content;
        }
		public override void writeTo(IHasContent target){
            system.debug('target: ' + target);
            system.debug('content: ' + content);
            system.debug('content.size(): ' + content.size());
			Integer contentLength;
			//target.setBody(null);
            //target.setBody(null);
            if (content == null){
				contentLength = 0;
			} else {
                target.setBody(content);
				contentLength = content.size();
			}
			writeHeaders(target,contentLength);
		}
		public Object deserializeAs(Type apexType){
			system.debug('deserializeAs apexType : ' + apexType);
            system.debug('deserializeAs content : ' + content.toString());
            if (content==null || content.size()==0)
			{
				return null;
			}
            String jsonString = content.toString();
            system.debug('deserializeAs jsonString : ' + jsonString);
			return System.JSON.deserialize(jsonString, apexType);
		}
		public Object deserialize() {
            if (content==null || content.size()==0) {
				return null;
			}
            
            String jsonString = content.toString();
			return System.JSON.deserializeUntyped(jsonString);
		}
	}
	public class FormUrlEncoded extends HttpContent 
	{
		private Iterable<HttpParameter> formData;
		public FormUrlEncoded(){
			this(new HttpParameterList());
		}
		public FormUrlEncoded(Iterable<HttpParameter> formData){
			super(new HttpContentType(MediaType.FormUrlEncoded));
			this.formData = formData;
		}
		public Iterable<HttpParameter> getFormData(){
			return this.formData;
		}

		//returns the content as a parameter list - if the 
		//content is not of the correct type will error
		public HttpParameterList getParameters()
		{
			if (this.formData instanceof HttpParameterList)
			{
				return (HttpParameterList) this.formData;
			}
			throw InvalidOperationException.create().withMessage('Content is not a HttpParameterList');
		}

		public override void readFrom(IHasContent source){
			HttpParameterList parameters = new HttpParameterList();
            Blob content = source.getBody();
            if (content!=null && content.size()>0){
            	parameters.addFrom(content.toString(), HttpParameterFormat.FormUrl);    
            }
			
			this.formData = parameters;
		}
		public override void writeTo(IHasContent target){
			Integer contentLength;
			String content ;

			if (this.formData==null)
			{
				content='';
			} else {
				content = HttpParameterFormat.FormUrl.join(formData);
			}

			contentLength = content.length();
			target.setBody(Blob.valueOf(content));
			writeHeaders(target,contentLength);
		}
	}
	//base class for string based content.. this implementation defaults to plain 
	//text
	public class PlainText extends HttpContent {
		private Blob content;

		
		public PlainText() {
			super(new HttpContentType(MediaType.plainText));
		}
		public PlainText(String content) {
			this();
            setContent(content);
		}
		public String getContent(){
            if (content==null){
                return null;
            }
            
			return  this.content.toString();
		}
		public void setContent(String content){
            if (content==null){
                content='';
            }
           
            this.content = Blob.valueOf(content);
		}
        
        
        
		public override void readFrom(IHasContent source){
			content = source.getBody();

		}
		public override void writeTo(IHasContent target){
			Integer contentLength;
			if (content==null){
				contentLength = 0;
				
			} else {
				contentLength = content.size();
				
			}
            target.setBody(content);
			writeHeaders(target,contentLength);
		}
	}

	protected HttpContent(HttpContentType contentType) {
		if (contentType==null){
			
			throw ArgumentNullException.create('contentType');
		}
		this.contentType = contentType;
	}

	//Should set:
	// content type header
	// content length
	// the content
	// encoding or other content related headers
	protected abstract void writeTo(IHasContent target);
	protected abstract void readFrom(IHasContent source);

	public void writeTo(HttpRequest request){
        System.debug('writeTo: ' + request );
		writeTo(new RequestContent(request));
	}
	public void writeTo(HttpResponse response){
		writeTo(new ResponseContent(response));
	}
	
	public void readFrom(HttpRequest request){
		readFrom(new RequestContent(request));
	}
	public void readFrom(HttpResponse response){
		readFrom(new ResponseContent(response));
	}

	protected void writeHeaders(IHasContent target, Integer contentLength){
		target.setHeader('Content-Type', contentType.toString());
		if (contentLength>0) {
			target.setHeader('Content-Length', String.valueOf( contentLength)) ;
		}
	}
	
}