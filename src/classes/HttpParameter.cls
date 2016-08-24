//Basically a Name / value pair representing a parameter in a HTTP message
//be it queiry string, cookie, header
//these are immutable 
public class HttpParameter implements Comparable
{
    public final String name;
    public final String value;
          
    //constructor when there is no name - when no name the separator between name and value is not 
    //generated...  take a HTTP Header such as Content-Type with:
    //
    //  image/jpeg;charset=utf-8
    //
    //  the first parameter:
    //    name : <null>
    //    value: image/jpeg
    //
    //  second parameter
    //    name : charset
    //    value: utf-8
    public HttpParameter(String value){
        this.value = value;
    }
    //name and value are always in the un-encoded form
    public HttpParameter(String name, String value){
        this.name = name;
        this.value = value;
    }
    public String toString(HttpParameterFormat parameterFormat){
        if (parameterFormat==null){
            throw ArgumentNullException.create('parameterFormat');
        }
        return parameterFormat.format(this);
    }
    public override String toString(){
        return toString(HttpParameterFormat.Url);
    }

    //implementation of Comparable 
    public Integer compareTo(Object compareTo){
        if (compareTo instanceof HttpParameter){
            HttpParameter other = (HttpParameter) compareTo;
            Integer retVal= name.compareTo(other.name);
            if (retVal==0){
                retVal = value.compareTo(other.value);
            }
            return retVal;    
        }
        return -1;
    }
}