public class MockHttpRequestDispatcher implements IHttpRequestDispatcher {
	private final List<RequestInfo> requests;
	private final List<IRequestHandler> requestHandlers;
	
	public class RequestInfo {
		public final HttpRequest request;
		public final HttpResponse response;
		public RequestInfo(HttpRequest request, HttpResponse response){
			this.request = request;
			this.response = response;
		}
	}
	public MockHttpRequestDispatcher(){
		requests = new List<RequestInfo>();
		requestHandlers = new List<IRequestHandler>();
	}

	private interface IRequestHandler{
		//try to handle the request, return null if it can't be handled
		 HttpResponse handleRequest(HttpRequest request);
	}
	public class RequestHandler implements IRequestHandler {
		private Integer statusCode;
		private String statusMessage;
		private Blob content;
		private String contentType;
		private String requestUriPattern;
		private Integer limitToRequestCount;
		private Integer handledRequestCount;
		private String method;

		public RequestHandler(){
			handledRequestCount = 0;
			limitToRequestCount = -1;
			statusCode = 200;
			statusMessage= 'OK';
		}
		public RequestHandler forOneRequestOnly(){
			limitToRequestCount = 1;
			return this;
		}
		public RequestHandler forMethod(String method){
			this.method = method.toUpperCase();
			return this;
		}
		public RequestHandler whenUriMatches(String regex){
			requestUriPattern = regex;
			return this;
		}
		
		public RequestHandler htmlContent(String content){
			this.content = Blob.valueOf(content);
			this.contentType ='text/html';
			return this;
		}

		public RequestHandler xmlContent(String content){
			this.content = Blob.valueOf(content);
			this.contentType ='application/xml';
			return this;
		}

		public RequestHandler jsonContent(String content){
			this.content = Blob.valueOf(content);
			this.contentType ='application/json';
			return this;
		}
		public RequestHandler respondWith(Integer statusCode,String statusMessage ){
			this.statusCode = statusCode;
			this.statusMessage = statusMessage;
			return this;
		}
		public RequestHandler respondWith(Integer statusCode ){
			this.statusCode = statusCode;
			this.statusMessage = null;
			return this;
		}

		public HttpResponse handleRequest(HttpRequest request){
			if (String.isNotEmpty(method) && request.getMethod()!=method){
				return null;
			}
			String endpointAddress = request.getEndpoint();
			
			if (String.isNotEmpty(requestUriPattern) && !Pattern.matches(requestUriPattern, endpointAddress)){
				Log.debug('did not match pattern {0}',requestUriPattern);
				return null;
			}
			if (limitToRequestCount>0 && handledRequestCount==limitToRequestCount){
				Log.debug('request count limit reached');
				return null;
			}
			handledRequestCount ++;
			HttpResponse response = new HttpResponse();
			response.setStatusCode(statusCode);
			response.setStatus(statusMessage);
			if (content!=null){
				response.setBodyAsBlob(content);
				response.setHeader('Content-Length', String.valueOf(content.size()));
				if (contentType!=null){
					response.setHeader('Content-Type',contentType);
				}
			}
			return response;
		}

	}
	public List<RequestInfo> getRequests(){
		return requests;
	}
	public void addRequestHandler(IRequestHandler handler){
		this.requestHandlers.add(handler);
	}
	public RequestHandler handleRequest(){
		RequestHandler handler = new RequestHandler();
		addRequestHandler(handler);
		return handler;
	}
	public HttpResponse send(HttpRequest request){
		Log.debug('Mock request dispatcher processing {0}:{1}',request.getMethod(), request.getEndpoint());
		HttpResponse response = null;
		for(IRequestHandler handler : requestHandlers){
			response = handler.handleRequest(request);
			if (response!=null){
				break;
			}
		}
		RequestInfo info = new RequestInfo(request,response );
		requests.add(info);
		if (response==null){
			throw new CalloutException('Test request not handled');
		}

		return response;
	}
	
	

	
}