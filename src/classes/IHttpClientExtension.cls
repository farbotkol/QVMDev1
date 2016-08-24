public interface IHttpClientExtension
{
	//callback made before the request is sent
	void HandleRequest(HttpRequest request);
	//callback made once the response has been received
    void HandleResponse(HttpResponse response);
}