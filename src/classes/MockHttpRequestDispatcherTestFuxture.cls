public class MockHttpRequestDispatcherTestFuxture {

	MockHttpRequestDispatcher dispatcher;
    
    
    public MockHttpRequestDispatcherTestFuxture initialize(){
        dispatcher = new MockHttpRequestDispatcher();
        dispatcher.handleRequest().respondWith(400,'BAD REQUEST').whenUriMatches('^.*/bad-request$');
        dispatcher.handleRequest().whenUriMatches('.*one-time-only').jsonContent('{"name":"value"}').forOneRequestOnly();
        dispatcher.handleRequest().whenUriMatches('.*xml-response').xmlContent('<data></data>');
        //handlers are called in sequence so this last one will be a fall back giving a 404 
        dispatcher.handleRequest().respondWith(404, 'NOT FOUND').htmlContent('<html><body><h1>Page not found</h1></body></html>');
        return this;
    }
    
    public HttpResponseAssert send(String endpointAddress){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointAddress);
        return send(request);
    }
    public HttpResponseAssert send(HttpRequest request){
        Integer requestCountBefore= dispatcher.getRequests().size();
        HttpResponse response= dispatcher.send(request);
        Assert.isNotNull(response, 'response');
        List<MockHttpRequestDispatcher.RequestInfo> requests= dispatcher.getRequests();
        Assert.areEqual(requestCountBefore+1,requests.size(), 'captured requests');
        MockHttpRequestDispatcher.RequestInfo info = requests[requests.size()-1];
        //check the request was captured correctly
        Assert.areSame(request,info.request);
        Assert.areSame(response,info.response);
        
        return new HttpResponseAssert(response);
    }
    
    public class HttpResponseAssert {
		private final HttpResponse response;
		
		public HttpResponseAssert(HttpResponse response){
			this.response = response;
		}
		public HttpResponseAssert statusCodeIs(Integer expected){
			Assert.areEqual(expected,response.getStatusCode(),'response status code' );
			return this;
		}
		public HttpResponseAssert contentIs(String content){
			Assert.areEqual(content, response.getBody(), 'response content ');
			return this;
		}

		public HttpResponseAssert hasHeader(String headerName){
			Boolean found = false;
			for(String key : response.getHeaderKeys())
			{
				if (key ==headerName){
					found = true;
					break;
				}
			}
			Assert.isTrue(found,'header {0}',headerName);
			return this;
		}
	} 

}