public class HttpRequestDispatcher implements IHttpRequestDispatcher {
	private final Http http;
	public HttpRequestDispatcher() {
		http = new Http();
	}
	public HttpResponse send(HttpRequest request){
		return http.send(request);
	}
}