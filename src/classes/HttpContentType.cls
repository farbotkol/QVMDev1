public class HttpContentType {
    private static final String CHARSET_TOKEN ='charset';
    
    private final String mediaType;
    //the other information, for example one entry may include charset=utf8  
    private final List<String> parameters;
    private HttpContentType(){
        parameters = new List<String>();
    }
    public HttpContentType(String value) {
        this();
        if (!String.isEmpty(value)){
            List<String> values= value.split(';');
            if (values.size()>0){
                mediaType = values[0].toLowerCase().trim();
                values.remove(0);
            } else {
                mediaType='';
            }
            for(String item : values){
                addParameter(item);
            }
            
        } else {
            mediaType = '';
        }
    }
    private Boolean addParameter(String value){
        if (String.isBlank(value)){
            return false;
        }
        //if it is a key value pair then trim the parts
        Integer position = value.indexOf('=');
        if (position >= 0){
            addParamater(value.substring(0,position), value.substring(position+1));
        } else {
        	parameters.add(value.trim());
        }
       return true;
    }
    private void addParamater(String name,String value){
        parameters.add(name.trim()+'='+value.trim());
    }
    public string getMediaType() {
        return mediaType;
    }
     
    public HttpContentType(MediaType mediaType, String charset)
    {

        this.mediaType = mediaType.toString();
        parameters = new List<String>();
        if (String.isNotBlank(charset)){
            parameters.add(CHARSET_TOKEN+'='+charset.trim());
        }
    }
    public HttpContentType(MediaType mediaType)
    {
        this(mediaType,(String) null);
    }
    public Boolean is(MediaType mediaType){
        if (mediaType ==null) {
            return false;
        }
        String value=getMediaType();
        if (String.isEmpty(value)){
            return false;
        }
        return value.equalsIgnoreCase(mediaType.toString()) ;
    }
    public override String toString()
    {
        String retVal = getMediaType();
        if (parameters!=null && parameters.size()>0) {
            retVal=retVal+'; '+ String.join(parameters, ';');
        }
        return retVal;
    }
}