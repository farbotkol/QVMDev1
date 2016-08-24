public class IntuitService {
    private static final String HEADER_REQUEST_ID='Request-ID';

    //extend the standard Http Message Handler so it signs the 
    //requests with our OAuth token
    private class MessageHandler extends HttpMessageHandler{
        private Configuration config;
        public MessageHandler( Configuration config){
            super(config.getServiceBaseAddress());
            this.config  =config;
            setUserAgent(config.getUserAgentString()); 
             //need to replace known tokens in the URL.. for example {realmId}
        }
        protected virtual override void prepareHeaders(HttpRequest request,HttpRequestMessage requestMessage){
            HttpRequestHeaders headers = requestMessage.getHeaders();
            //add request ID for tracking
            //the API also supports a correlationID through 'Tracking-ID' but we are not using this at the moment

            if (!headers.containsHeader(IntuitService.HEADER_REQUEST_ID)){
                headers.setHeader(IntuitService.HEADER_REQUEST_ID, Uuid.newUuid().toString());
            }
            super.prepareHeaders(request, requestMessage);
        }
        protected virtual override HttpResponse send(HttpRequest request) {
            OAuth1.IMessageSigner signer = OAuth1.createMessageSigner(config, request);
            signer.signRequest();
            
            return super.send(request);
        }
    }
    //Wrapper class for the configuration information that can be passed
    //in to the OAuth message signing functions
    @testVisible
    private class Configuration implements OAuth1.IConfiguration{
        private qvm_intuit_api__c config;
        private qvm_intuit_api_token__c tokenConfig;
        public Configuration(){
            load();
        }
        public void load(){
            load(false);
        }
        //refresh / load settings from the store
        public void load(Boolean loadOAuthConnectToken){
            config = qvm_intuit_api__c.getOrgDefaults();
            loadToken(loadOAuthConnectToken);
        }
        //load the token from settings - if loadOAuthConnectToken is 
        //true then will load the temporary token issued as part of the
        //OAuth flow otherwise will load the standard token
        private void loadToken(Boolean loadOAuthConnectToken){
            if (config==null || String.isBlank(config.ApiName__c)){
                tokenConfig = null;
            } else {
                String settingName = config.ApiName__c;
                if (loadOAuthConnectToken) {

                    settingName = MessageFormat.format('{0}_temp_{1}', settingName, System.UserInfo.getUserId() );
                }
                tokenConfig = qvm_intuit_api_token__c.getInstance(settingName);
            }

        }
        public String getServiceBaseAddress(){
            if (config==null){
                return null;
            }
            String baseAddress= config.ServiceBaseAddress__c;
            if (baseAddress!=null){
                baseAddress = baseAddress.replace('{realm}', getRealm());
            }
            return baseAddress;
        }
        public String getUserAgentString(){return config==null?null: config.UserAgent__c;}
        public INonceGenerator getNonceGenerator(){return NonceGenerator.getDefault();}
        public String getApiName(){return config==null?null: config.ApiName__c;}
        public String getConsumerKey(){return config==null?null:config.ConsumerKey__c;}
        public String getConsumerSecret(){return config==null?null:config.ConsumerSecret__c;}
        public String getToken(){return tokenConfig==null?null:tokenConfig.TokenSecret__c;}
        public String getTokenSecret(){return tokenConfig==null?null:tokenConfig.Token__c;}
        public String getRealm(){return tokenConfig==null?null:tokenConfig.Realm__c;}
        public HttpParameterList getProviderParameters(){return null;}
        public String getSignatureMethod(){return 'HMAC-SHA1';}
        public String getRequestTokenUrl(){return config==null?null: config.RequestTokenUrl__c;}
        public String getAuthorizationUrl(){return config==null?null: config.UserAuthorizationUrl__c;}
        public String getAccessTokenUrl(){return config==null?null: config.AccessTokenRequestUrl__c;}
        
        

        public void ensureIsValid(){
            new ConfigurationValidator().validate(this,true);
        }
    }
    private class ConfigurationValidator {
        private List<String> errors;
        private Boolean validate(Configuration config, Boolean throwIfInvalid){
            errors = null;

            if (String.isBlank(config.getApiName())){
                addError('No organisation default configurtion for Intuit Quickbooks found or the "API Name" field has no value');
                //this is the end - no more we can validate
            } else {
                if (String.isBlank(config.getServiceBaseAddress())){
                    addError('Service base address is not configured');
                }
                if (String.isBlank(config.getConsumerKey()) || String.isBlank(config.getConsumerSecret())){
                    addError('OAuth consumer key / secret is not configured');   
                }
            }
            if (throwIfInvalid){
                if (!isValid()){
                    throw new QuickbooksException().withMessage(String.join(errors, '\n'));
                }
            }
            return isValid();
            
        }
        public Boolean isValid(){
            return errors==null || errors.size()==0;
        }
        private void addError(String message){
            if (errors==null){
                errors = new List<String>();
            }
            errors.add(message);
        }

    }
    @testVisible
    private static Configuration getConfig(){
        return new Configuration();
    }

    public static HttpClient createClient()
    {
        Configuration config = getConfig();
        config.ensureIsValid();
        MessageHandler handler = new MessageHandler(config);
        return new HttpClient(handler);
    }
}