//strongly typed representation of a HttpMethod
public class HttpMethod {
	private final string value;

    public HttpMethod(String value){
        if (String.isBlank(value)){
            throw ArgumentException.forArgument('value').withMessage('HttpMethod cannot be created from an empty string');
        }

        this.value = value.trim().toUpperCase();
    }
    //parses a string input and returns an instance of HttpMethod or NULL if
    //there is no value
    public static HttpMethod parse(String value) {
        if ( String.isBlank(value)) {
            return null;
        }
        return new HttpMethod(value); 
    }
    
    public static final HttpMethod GET = new HttpMethod('GET');
    public static final HttpMethod PUT = new HttpMethod('PUT');
    public static final HttpMethod POST = new HttpMethod('POST');
    public static final HttpMethod HEAD = new HttpMethod('HEAD');
    public static final HttpMethod PATCH = new HttpMethod('PATCH');
    public static final HttpMethod TRACE = new HttpMethod('TRACE');
    //could not use the name DELETE as it is a reserved word
    public static final HttpMethod HTTP_DELETE = new HttpMethod('DELETE');
        

    public Boolean equals(Object other) {
        if (other==null){
            return false;
        }
        
        if (other instanceof String)
        {
            return equals((String) other);
        }
        if (other instanceof HttpMethod){
            return equals((HttpMethod) other);
        }
        return false;
    }
    public Boolean equals(HttpMethod other) {
        if (other==null){
            return false;
        }
        return other===this || this.value.equalsIgnoreCase(other.value);
    }
    public Integer hashCode(){
        return this.value.hashCode();
    }
    public Boolean equals(String value){
        return value!=null && this.value.equalsIgnoreCase(value);
    }
    public override String toString(){
        return value;
    }
}