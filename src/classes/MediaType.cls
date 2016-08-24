public class MediaType
{
    private final string value;
    public MediaType(String value){
        this.value = value;
    }
    
    public override String toString()
    {
        return value;
    }

    public static final MediaType formUrlEncoded = new MediaType('application/x-www-form-urlencoded');
    public static final MediaType json = new MediaType('application/json');
    public static final MediaType html = new MediaType('text/html');
    public static final MediaType plainText = new MediaType('text/plain');
}