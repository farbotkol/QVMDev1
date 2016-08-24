//defines how HttpParameters are encoded in to a message component.
//essentially a wrapper and some extensions over URL Encoding functions
//built in to APEX
public abstract class HttpParameterFormat {

    
    //standard modern URL encoding, spaces are represented as %20
    public static final HttpParameterFormat Url = new UrlFormat('Url');

    //URL Encoding as used in HTTP POST operations when the content 
    //type is application/x-www-form-urlencoded.  In this case the spaces
    //are represented with a +
    public static final HttpParameterFormat FormUrl = new FormUrlFormat('FormUrl');

    //The OAuth1 Signature base string defines a very specific set of unreserved characters
    //http://oauth.net/core/1.0a/#encoding_parameters
    // unreserved = ALPHA, DIGIT, '-', '.', '_', '~'
    public static final HttpParameterFormat OAuthSignature = new OAuthBaseStringFormat('OAuthSignature');

    //Quoted value style this format is can be used with HTTP Headers
    //where paramaters are separated with a comma.  names and values are separated
    //with an equals sign.  Names will be quoted if required, values will always be 
    //quoted
    public static final HttpParameterFormat AuthorizationHeader = new AuthorizationHeaderFormat('AuthorizationHeader');
    
    private static final String ENCODING_DEFAULT = 'UTF-8';
    //an arbitary name for this instance to identify it during debugging
    private final String name;
    
    //the character(s) that are used to separate each parameter when many parameters are combined in to a 
    //single string
    private final String separator;

    protected HttpParameterFormat(String name, String separator){
        this.name = name;    
        if (separator==null||separator.length()!=1){
                throw ArgumentException.forArgument('separator')
                    .withMessage('separator should be a single character such as \',\' or \';\'');
        }
        this.separator = separator;
        
    }

    //the character used to define the boundary between one HttpParamater and the next
    public String getSeparator()
    {
        return separator;
    }
    //should return an encoded name value pair 
    protected abstract String format(String name, String value);

    // Percent encoded as with the URL encoding but the values are quoted
    // http://oauth.net/core/1.0a/#auth_header
    private class AuthorizationHeaderFormat extends UrlFormat {
        
        public AuthorizationHeaderFormat(String name){
            super(name,',');
            
        }
        public override Iterable<HttpParameter> getParameterSource(String values)
        {
            //not used at this stage anyway
        	throw new UnsupportedOperationException('TODO: Not implemented');
    	}
        public override String format(String name, String value){
            if (String.isEmpty(name)){
                if (string.isEmpty(value)){
                    return '';
                }
                //this is a parameter with no name, so return just the value..
                return value;
            }
            return encodeValue(name)+'="'+encodeValue(value)+'"';
        }
        
    }

    private virtual class UrlFormat extends FormUrlFormat {
        public UrlFormat(String name){
            super(name);
        }
        protected UrlFormat(String name, String separator){
            super(name, separator);
        }
        protected override String encodeValue(String value){
            String result = super.encodeValue(value);
            //base class encodes using form URL encoding
            //as per https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_encodingUtil.htm
            // so swap out the + with %20
            return result.replace('+', '%20');
        }
    } 
    
    //represents an additional substitution to be made when encoding 
    //text values - this is pretty dirty stuff but will do
    private class TextReplacement
    {
        private final String target;
        private final String replacement;

        public TextReplacement(String target, String replacement){
            this.target = target;
            this.replacement = replacement;
        }
        public String replace(String input){
            return input.replace(target, replacement);
        }
    }   
    private virtual class OAuthBaseStringFormat extends FormUrlFormat
    {
        private List<TextReplacement> additionalReplacements;
        public OAuthBaseStringFormat(String name){
            super(name,'&');
            additionalReplacements = new List<TextReplacement>();
            addReplacement('+','%20');
            addReplacement('!');
            addReplacement('*');
            addReplacement('\'');
            addReplacement('(');
            addReplacement(')');
        }
        private void addReplacement(String character, String replacement){
            
            additionalReplacements.add(new TextReplacement(character, replacement));
        
        }
        private void addReplacement(String character){
            Integer charValue = character.charAt(0);
            // convert the character to HEX - must be upper case
            String replacement = '%'+EncodingUtil.convertToHex(Blob.valueOf('*')).toUpperCase();
            additionalReplacements.add(new TextReplacement(character, replacement));
        }
        protected override String encodeValue(String value){
            String result = super.encodeValue(value);
            //base class encodes using form URL encoding
            //as per https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_encodingUtil.htm
            // so swap out the + with %20
            for(TextReplacement replacement: additionalReplacements){
                result = replacement.replace(result);
            }
            return result;
        }
    }
    private virtual class FormUrlFormat extends HttpParameterFormat {
        public FormUrlFormat(String name){
            super(name,'&');
        }
        protected FormUrlFormat(String name, String separator){
            super(name, separator);
        }
        public virtual override Iterable<HttpParameter> getParameterSource(String values)
        {
        	return new UrlParameterSource(values);
    	}
        public virtual override String format(String name, String value){
            if (String.isEmpty(name)){
                if (string.isEmpty(value)){
                    return '';
                }
                //this is a parameter with no name, so return just the value..
                return encodeValue(value);
            }
            return encodeValue(name)+'='+encodeValue(value);
        }
        protected virtual string encodeValue(String value){
            if (value==null){
                return '';
            }
            return EncodingUtil.urlEncode(value, ENCODING_DEFAULT);
        }
    }
    private class FormattingList implements Iterable<String>{
        private final Iterable<HttpParameter> source;
        private final HttpParameterFormat formatter;

        public FormattingList(Iterable<HttpParameter> source, HttpParameterFormat formatter){
            this.source = source;
            this.formatter = formatter;
        }
        public Iterator<String> iterator(){
            return new FormattingIterator(source.iterator(),formatter);
        }
    }

    //iterates through a list of HttpParameters and returns a list of strings
    private class FormattingIterator implements Iterator<String>
    {
        private final Iterator<HttpParameter> source;
        private final HttpParameterFormat formatter;

        public FormattingIterator(Iterator<HttpParameter> source, HttpParameterFormat formatter){
            this.source = source;
            this.formatter = formatter;

        }
        public Boolean hasNext(){
            return source.hasNext();
        }
        public String next(){
            return formatter.format(source.next());
        }
    }
    //an name for this instance so we can write it in logs and identify it
    public String getName(){
        return name;
    }
    //returns the parameter represented in string form with encoding applied  
    public String format(HttpParameter parameter){
        if (parameter==null){
            return '';
        }
        return format(parameter.name, parameter.value);
    }
    //returns an iterator over the source items returning 
    //a string representation of each with encoding applied.
    //this does not inclide any item separator (for example with URL
    //parameters this would be a '&') 
    public Iterable<String> format(Iterable<HttpParameter> source){
        if (source==null){
            throw ArgumentNullException.create('source');
        }
        return new FormattingList(source,this );
    }
    //returns the source list as a single formatted and 
    //encoded string value
    public String join(Iterable<HttpParameter> source){
        return String.join(format(source),separator);
    }
    //cleans up possible partially encoded information, for example query strings with
    //spaces that have not been escaped correctly. 
    public String normalize(String input){
        if (String.isEmpty(input)){
            return input;
        }

        return join( this.getParameterSource(input));
    }
    //returns an iterator allowing a sequential parsing and reading of the 
    //HttpParameters represented by the provided string
    public Iterator<HttpParameter> getValueReader(String values){
        return getParameterSource(values).iterator();
    }

    public abstract Iterable<HttpParameter> getParameterSource(String inputValue);

    private abstract class ParamaterSource implements Iterable<HttpParameter>
    {
        protected final String inputValue;
        protected ParamaterSource(String inputValue){
            this.inputValue = inputValue;
        }
        public abstract Iterator<HttpParameter> iterator();
        public override String toString(){
            return inputValue;
        } 
    }
    private class UrlParameterSource extends ParamaterSource
    {
        public UrlParameterSource(String inputValue){
            super(inputValue);
        }
        public override Iterator<HttpParameter> iterator()
        {
            return new UrlParameterReader(inputValue);
        }
    }
    //base class for implementing a sequencial reader over a string
    private abstract class ParameterReader implements Iterator<HttpParameter>
    {
        private final String inputValue;
        private HttpParameter current;
        
        //the position in the string
        protected Integer position;
        protected final Integer valueLength;
        
        protected ParameterReader(String inputValue){
            this.inputValue = inputValue;
            this.position =0;
            this.valueLength = inputValue==null?-1:inputValue.length();
        }
        public HttpParameter next(){
            return current;
        }
        
        public Boolean hasNext(){
            current = readNext();
            return current!=null;
            return position<valueLength;
        }

        protected abstract HttpParameter readNext();
    }

    //implementation of the reader for URL encoded parameters
    private class UrlParameterReader extends ParameterReader
    {
        
        public UrlParameterReader(String value){
            super(value);
          
        }
        private String decodeValue(String value){
            try
            {
                return EncodingUtil.urlDecode(value, ENCODING_DEFAULT);
            } catch(Exception ex){

                Log.warn( 'failed when decoding \'\'{0}\'\'. {1}',value,ex.getMessage());
                return value;
            }
            
        }
        
        public override HttpParameter readNext(){
           
            Log.debug('readNext with position: {0} valueLength {1}', position, valueLength);
            if (position>=valueLength){
                return null;
            }
            Integer endOfValue = inputValue.indexOf('&', position);
            Integer endOfName = inputValue.indexOf('=', position);
            
            String parameterName;
            String parameterValue;
            Integer startOfValue;
            
            if (endOfValue<0){
                endOfValue=valueLength; 
            } 
            
            if (endOfName<0||endOfName>endOfValue){
                //this is a value only...
               startOfValue =position;
            } else{
                startOfValue=endOfName+1;
              
                if (endOfName<position){
                    //found white space or an empty token at the end of the text
                    return null;
                }
            
                parameterName =decodeValue(inputValue.substring(position, endOfName));
                
            }
            if (startOfValue < endOfValue) {
            
            	parameterValue = decodeValue(inputValue.substring(startOfValue, endOfValue));
            }
            position = endOfValue+1;
            if (parameterName==null && position >=valueLength && String.isBlank(parameterValue)){
                //this will be white space at the end of the input - 
                //drop it
                return null;
                
            }
            return new HttpParameter(parameterName,parameterValue);
        
        }        
    }
  
    
}