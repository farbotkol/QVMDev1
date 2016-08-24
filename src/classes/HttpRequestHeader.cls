public class HttpRequestHeader {
    
    public static HttpContentType getContentType(HttpRequest request){
        return new HttpContentType(request.getHeader('Content-Type'));
    }
}