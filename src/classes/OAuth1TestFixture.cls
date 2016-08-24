public class OAuth1TestFixture {
    private MockHttpRequestDispatcher dispatcher;
    private OAuth1.Configuration config;
    HttpClient client;
    
    public OAuth1TestFixture()
    {
        dispatcher = new MockHttpRequestDispatcher();
        
        //add a request handler that always returns a 200 OK with no content.
        dispatcher.handleRequest();
        
        initConfig();
    }
     
    private void initConfig(){
        if (config==null){
            
            config  = new OAuth1.Configuration();
            config.setToken('qyprdzprZlXnWrBopgxXftKiJBXdnsUwddcW5rNhuoZy0Mpm');
            config.setTokenSecret('hOSewaqp57eEmfASbnFfZKy7amcAkqLyz8zMVk24');
            config.setApiName('Test');
            config.setConsumerKey('qyprdBeCEyz8XgXyQLhGyVKFJxSj5R');
            config.setConsumerSecret('d89SNefvcrnlgY1ot88GL1uhviL68L5MenIhjZmw');
            config.setSignatureMethod('HMAC-SHA1');
        }
    }
    public OAuth1TestFixture useNonce(String nonce){
        config.setNonceGenerator(new TestNonceGenerator(nonce));
        return this;
    }
    public OAuth1TestFixture createClient(String endpointAddress){
        client = OAuth1.createHttpClient(config,endpointAddress);
        client.messageHandler.setDispatcher(dispatcher);
        return this;
    }
    public HttpRequest getInterceptedRequest(){
        List<MockHttpRequestDispatcher.RequestInfo> requests = dispatcher.getRequests();
        Assert.areEqual(1, requests.size(), 'intercepted rquests') ;
        return requests[0].request;
    }
    public HttpClient getClient(){
        return client;
    }
    
    private class TestNonceGenerator implements INonceGenerator
    {
        private final String nonce;
        public TestNonceGenerator(String nonce){
            this.nonce = nonce;
        }
        public String generateNonce(){
            return nonce;
        }
    }

}