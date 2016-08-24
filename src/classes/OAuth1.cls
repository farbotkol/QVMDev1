public class OAuth1 {
    
    
    public enum TokenIdentityType {None, NamedPrincipal, PerUser}
    private static final String SIGNATURE_PLAIN_TEXT='PLAINTEXT';
    private static final String SIGNATURE_HMAC_SHA1='HMAC-SHA1';
    
    //parse the string to an enum but be less strict
    private static TokenIdentityType parseTokenIdentityType(String value, TokenIdentityType defaultValue){
        if (String.isBlank(value)){
            return defaultValue;
        }
        String cleanedValue = value.replace(' ','');

        for(TokenIdentityType item : TokenIdentityType.values()){
            if (cleanedValue.equalsIgnoreCase(item.name()) )
            {
                return item;
                
            }
        }
        Log.warn('Encountered invalid \'Identity Type\' \'\'{0}\'\'',value);
        return TokenIdentityType.None;
    }

    public interface ITokenService
    {
        IConfiguration getConfig();
        PageReference beginConnect(Url callbackUrl);
    }
    //extend the standard Http Message Handler so it signs the 
    //requests with our OAuth token
    private class MessageHandler extends HttpMessageHandler{
        private IConfiguration config;
        public MessageHandler( IConfiguration config, String baseAddress){
            super(baseAddress);
            this.config  =config;
        }
        protected virtual override HttpResponse send(HttpRequest request) {
            OAuth1.IMessageSigner signer = OAuth1.createMessageSigner(config, request);
            signer.signRequest();
            
            return super.send(request);
        }
    }
    public static HttpClient createHttpClient(IConfiguration config, String endpointAddress){
        return new HttpClient(new MessageHandler(config, endpointAddress));
    }
    

    public class TokenService implements ITokenService, IHttpClientExtension {
        private final IConfiguration config;

        private TokenService(IConfiguration config){
            if (config==null){
                throw ArgumentNullException.create('config');
            }
            this.config = config;
        }
        public IConfiguration getConfig(){
            return config;
        }
        //callback made before the request is sent
        public void HandleRequest(HttpRequest request){
            IMessageSigner signer = OAuth1.createMessageSigner(config, request);
            signer.signRequest();
        }
        //callback made once the response has been received
        public void HandleResponse(HttpResponse response){
            //TODO: Implement the verification to ensure the server we are talking to is not a fake
        }


        public PageReference beginConnect(Url callbackUrl){
            
            //copy the configuration
            Configuration tempConfig = new Configuration(this.config);
            tempConfig.setTokenSecret(null);
            tempConfig.setToken(null);

            //step 1: get a request token
            HttpRequest request = new HttpRequest();
            request.setEndpoint(tempConfig.getRequestTokenUrl());
            request.setMethod(HttpMethod.POST.toString());

            //I have no idea where oob comes from??
            String callbackUrlText = callbackUrl==null?'oob':callbackUrl.toExternalForm();

            tempConfig.getProviderParameters(true).add('oauth_callback', callbackUrl.toExternalForm());

            IMessageSigner signer = OAuth1.createMessageSigner(tempConfig, request);
            signer.signRequest();
            Http h = new Http();
            HttpContent r= HttpContent.fromRequest(request);
            Log.debug(Debug.describe(request));
            HttpResponse re= h.send(request);
            HttpResponseMessage response= HttpResponseMessage.create(re);
            //The server should return 401 unathorized 
            if (!response.isSuccessStatusCode()) {
                Log.warn('Did not get expected response from {0} while obtaining a request token.',request.getEndpoint());
                Log.warn('Response was {0}', re);   

                throw OAuthException.create()
                    .withMessage(MessageFormat.format('Unable to obtain request token from {0}: {1} ({2})\n{3}',
                                                      request.getEndpoint(),
                                                      response.getStatusCode(), 
                                                      response.getReasonPhrase()));
            }
    
            //if (!())
            //{
            //  throw ConnectedApiException.create().withMessage(Text.format('Unable to obtain request token from {0}',request.getEndpoint()));
            //}
            Log.debug(response);
            HttpContent.FormUrlEncoded content =(HttpContent.FormUrlEncoded) response.getContent();
            HttpParameterList parameters = content.getParameters();
            if (parameters.extractByName('oauth_callback_confirmed').value!='true'){
                throw new UnexpectedException('was not confirmed');
            }
            tempConfig.setToken(parameters.extractByName('oauth_token').value);
            tempConfig.setTokenSecret(parameters.extractByName('oauth_token_secret').value);
            //remaining parameters should be sent as provider parameters
            tempConfig.setProviderParameters(parameters);
            UriBuilder builder = new UriBuilder(tempConfig.getAuthorizationUrl());
            HttpParameterList queryParameters = new HttpParameterList();
            queryParameters.addFromQueryString(builder.getQuery());
            queryParameters.add('oauth_token', tempConfig.getToken());
            queryParameters.add(parameters);
            builder.setQuery(queryParameters);

            return builder.toPageReference().setRedirect(true);
            
        }
    }
    public static IMessageSigner createMessageSigner(IConfiguration config, HttpRequest request){
            String signatureMethod = config.getSignatureMethod();
            if (signatureMethod == SIGNATURE_HMAC_SHA1){
                return new HmacSha1Signer(config, request);
            }
            throw new UnsupportedOperationException('Not implemented');
        }

    public interface IMessageSigner
    {
        void signRequest();
    }
    @testVisible
    //a simple implementation with property get / set
    public class Configuration implements IConfiguration{
        
        private String apiName;

        private String consumerKey;
        private String consumerSecret;
        private String token;
        private String tokenSecret;
        private HttpParameterList providerParameters;
        private String signatureMethod;
        private String requestTokenUrl;
        private String authorizationUrl;
        private String accessTokenUrl;
        private INonceGenerator nonceGen;

        //default constructor
        public Configuration(){
            this.nonceGen = NonceGenerator.getDefault();    
        }
        //copy constructor
        public Configuration(IConfiguration source){
            apiName = source.getApiName();
        
            nonceGen = source.getNonceGenerator();
            consumerKey = source.getConsumerKey();
            consumerSecret = source.getConsumerSecret();
            token = source.getToken();
            tokenSecret = source.getTokenSecret();
            signatureMethod = source.getSignatureMethod();
            requestTokenUrl = source.getRequestTokenUrl();
            authorizationUrl = source.getAuthorizationUrl();
            accessTokenUrl = source.getAccessTokenUrl();
            HttpParameterList sourceParameters = source.getProviderParameters();

            if (sourceParameters!=null){
                providerParameters = new HttpParameterList(sourceParameters);
            }
        }
        public INonceGenerator getNonceGenerator(){return nonceGen;}
        public void            setNonceGenerator(INonceGenerator nonceGenerator){this.nonceGen = nonceGenerator;}
        
        public String getApiName(){return apiName;}
        public Void   setApiName(String value){apiName=value;}

        //the human readable form of the ApiName

        
        public String getConsumerKey(){return consumerKey;}
        public Void   setConsumerKey(String value){consumerKey=value;}

        public String getConsumerSecret(){return consumerSecret;}
        public Void   setConsumerSecret(String value){consumerSecret=value;}

        public String getToken(){return token;}
        public Void   setToken(String value){token=value;}

        public String getTokenSecret(){return tokenSecret;}
        public Void   setTokenSecret(String value){tokenSecret=value;}

        public HttpParameterList getProviderParameters(Boolean createIfNull){
            if (providerParameters==null && createIfNull){
                providerParameters = new HttpParameterList();
            }
            return providerParameters;
        }
        public HttpParameterList getProviderParameters(){return providerParameters;}
        public void   setProviderParameters(HttpParameterList value){providerParameters=value;}

        public String getSignatureMethod(){return signatureMethod;}
        public void   setSignatureMethod(String value){signatureMethod=value;}

        public String getRequestTokenUrl(){return requestTokenUrl;}
        public void   setRequestTokenUrl(String value){requestTokenUrl=value;}

        public String getAuthorizationUrl(){return authorizationUrl;}
        public void   setAuthorizationUrl(String value){authorizationUrl=value;}

        public String getAccessTokenUrl(){return accessTokenUrl;}
        public void   setAccessTokenUrl(String value){accessTokenUrl = value;}
    }

    public interface IConfiguration
    {
        //the name for this API
        String getApiName();
        INonceGenerator getNonceGenerator();
        //the human readable form of the ApiName
        String getConsumerKey();
        String getConsumerSecret();
        String getToken();
        String getTokenSecret();
        HttpParameterList getProviderParameters();
        String getSignatureMethod();
        String getRequestTokenUrl();
        String getAuthorizationUrl();
        String getAccessTokenUrl();
    }
    
    
    public static ITokenService createTokenService(IConfiguration configuration){
        return new TokenService(configuration);
    }
   
    

    
    //A container for the OAuth related parameters carried in a HTTP Message
    //This will usually end up in the Athorize HTTP Header however if there is no 
    //access token yet then these parameters will end up in the message body
    @testVisible
    private class OAuthMessageParameters implements iterable<HttpParameter> {
        @testVisible
        private List<HttpParameter> parameters;
        //NOTE: this is a nullable type       
        private Integer insertAt;

        public OAuthMessageParameters(IConfiguration configuration){

            this.parameters = new List<HttpParameter>();
            String consumerKey = configuration.getConsumerKey();

            if (String.isBlank(consumerKey)){
                throw InvalidOperationException.create().withMessage('consumerKey must be specified');
            }
            add('oauth_consumer_key', consumerKey);
            add('oauth_nonce', configuration.getNonceGenerator().generateNonce());
            add('oauth_timestamp', String.valueOf(Clock.now().getTime() / 1000));     
            String token = configuration.getToken();
            if (String.isNotBlank(token)){
                add('oauth_token', token);
            }

            add('oauth_version', '1.0');

            addProviderParameters(configuration.getProviderParameters() );
        }
        private void addProviderParameters(HttpParameterList providerParameters){
            if (providerParameters!=null){
                // record location these are added so we can ensure additional items are 
                // added before these
                insertAt = parameters.size();
                Iterator<HttpParameter> it = providerParameters.iterator();
                while(it.hasNext()) {
                    parameters.add(it.next());
                }
               
            }
        }
        public void add(String name, String value){
            HttpParameter parameter = new HttpParameter(name, value);
            if (insertAt==null){
                parameters.add(parameter);
            } else {
                this.parameters.add(insertAt,parameter);
                insertAt++;    
            }
            
        }
        public Iterator<HttpParameter> iterator()
        {
            return parameters.iterator();
        }
        public Iterator<HttpParameter> getSigningParameters(){
            return new MessageSignParameterIterator(parameters);
        }
         

        public String toAuthorizeHeader(){
            HttpParameterFormat formatter = HttpParameterFormat.AuthorizationHeader;
            return 'OAuth '+ formatter.join(parameters);
        }
        
    }
    //extracts the required parts from the message and signs it.

    private abstract class MessageSigner implements IMessageSigner {

        protected final HttpRequest request;
        protected final HttpMethod method;
        protected final UriBuilder requestUri;
        protected final IConfiguration configuration;
        protected final OAuthMessageParameters oauthParameters;

        protected MessageSigner(IConfiguration configuration, HttpRequest request){
            this.request = request;
            this.configuration = configuration;
            this.requestUri = new UriBuilder(request.getEndpoint());
            this.method = HttpClient.getMethod(request);
            this.oauthParameters =new OAuthMessageParameters(configuration);
        }
        
       protected abstract String getSignature(String baseString);
       public abstract String getSignatureMethod();
       public void signRequest(){
            //this parameter needs to be in the signed content so add it now
            oauthParameters.add('oauth_signature_method',getSignatureMethod());
           
            HttpParameterList signingParameters = getSigningParameters();
            signingParameters.sort();

            //parameters must be in a consistent order
            HttpParameterList finalList = new HttpParameterList();
            finalList.add(null,  method.toString());
            finalList.add(null,  requestUri.leftPart(UriBuilder.UriComponent.Path));
            finalList.add(null,  HttpParameterFormat.OAuthSignature.join(signingParameters) );
            
            //stringify...
            String signatureBaseString =HttpParameterFormat.OAuthSignature.join(finalList);
            Log.debug('Signature base string: {0}', signatureBaseString);
            String signature = getSignature(signatureBaseString);
            oauthParameters.add('oauth_signature', signature);

            updateMessage();
            
         }
         //add the signature and other OAuth realted information to the message
         private void updateMessage(){
            //ONLY attach an Authorization header IF there is a TOKEN
            //otherwise add the information to the request body (POST requests with form URL encoded content)
            //or URL for GET requests
            if (String.isEmpty(configuration.getToken() )){
                if (method==HttpMethod.POST){
                    HttpContent content= new HttpContent.FormUrlEncoded(oauthParameters);
                    content.writeTo(request);
                } else {
                    throw new UnsupportedOperationException('NOT IMPLEMENTED'); 
                }
            } else {
                request.setHeader(HttpHeaders.REQUEST_AUTHORIZATION, oauthParameters.toAuthorizeHeader());
            }
        }
         private HttpParameterList getSigningParameters(){
             //now bring together the stuff to sign..
            HttpParameterList signingParameters = new HttpParameterList();
            signingParameters.add(oauthParameters.getSigningParameters());
            signingParameters.addFrom(requestUri.getQuery(), HttpParameterFormat.Url);

            if (method==HttpMethod.POST && HttpClient.getContentType(request).is(MediaType.formUrlEncoded)){
                signingParameters.addFrom(request.getBody(), HttpParameterFormat.formUrl);
            }
            return signingParameters;
         }
         
    }

    private class HmacSha1Signer extends MessageSigner {
        private final Blob combinedKey;

        public  HmacSha1Signer(IConfiguration configuration, HttpRequest request){
            super(configuration, request);
            //combine the 2 keys in the form, if a value is missing the & still stays in place
            //oh and the actual values need encoding too... 
            //
            //          consumerSecret&tokenSecret

            HttpParameterList keys = new HttpParameterList();
            keys.add(null, configuration.getConsumerSecret());
            keys.add(null, configuration.getTokenSecret());
            combinedKey= Blob.valueOf(HttpParameterFormat.OAuthSignature.join(keys));

        }   
        protected override String getSignature(String baseString){
            //the key we use to sign is made up of the 
            //consumer secret and token secret (if we have one)
            
            Blob signature = Crypto.generateMac(
                'HmacSHA1',
                Blob.valueOf(baseString),
                combinedKey
            );
            return EncodingUtil.base64encode(signature);
        }
        public override String getSignatureMethod(){
            return SIGNATURE_HMAC_SHA1;
        }
    }
    private static final Set<String> parametersExcludedFromMessageSigning = new Set<String>{'oauth_token_secret','oauth_signature'};

     //provides a filtered view on the OAuth parameters returning only those that should
    //form part of the message signature
    private class MessageSignParameterIterator implements iterator<HttpParameter>
    {
        List<HttpParameter> source;
        HttpParameter current;
        Integer position;
        
        public MessageSignParameterIterator(List<HttpParameter> source){
            this.source=source;
            position=-1;
        }
        public Boolean hasNext(){
            Log.debug('hasNext called with Position: {0}, Count: {1}', position, source.size());
            do {
                position++;
                if (position>=source.size()){
                    current=null;
                    return false;
                }
                current = source.get(position);
            } while(shouldSkipCurrent());
           return true;
            

        }
        private Boolean shouldSkipCurrent(){
            string name = current.name;
            //may need to skip realm??
            return  OAuth1.parametersExcludedFromMessageSigning.contains(name);
        }

        public HttpParameter next(){
            return current;
        }
    }
}