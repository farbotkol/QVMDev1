//Define an interface for sending HttpRequests so we can hook 
//in and write tests more easily
public interface IHttpRequestDispatcher {

	//Define the method signature to be implemented in classes that implements the interface
	HttpResponse send(HttpRequest request);
}