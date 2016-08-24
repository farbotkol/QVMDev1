@isTest
public class OAuth1Tests {
    
  
 

    @testSetup 
    static void testSetup()
    {
        Clock.reset();
    }
    private static TestFixture test()
    {
        return new TestFixture();
    }
    
    @isTest 
    static void test1(){
        
        Clock.freezeAt(Datetime.newInstance(1471671671000L));
        OAuth1TestFixture test = new OAuth1TestFixture().useNonce('-7573429099354025761').createClient('https://sandbox-quickbooks.api.intuit.com/');
        HttpClient client = test.getClient();
        HttpRequestMessage requestMessage = new HttpRequestMessage(HttpMethod.GET, '/v3/company/193514335420637/query?query=Select * from Customer');
        HttpResponseMessage responseMessage= client.send(requestMessage);
        HttpRequest request= test.getInterceptedRequest();
        Assert.areEqual('GET', request.getMethod(), 'method');
        Assert.areEqual('https://sandbox-quickbooks.api.intuit.com/v3/company/193514335420637/query?query=Select%20*%20from%20Customer', request.getEndpoint(),'endpoint address');
        String authHeader =request.getHeader('Authorization');
        Assert.isMatch('OAuth .*',authHeader);
    
        Map<String, String> params = new Map<String,String>();
        for(String item :  authHeader.substring(5).split(','))
        {
            List<String> parts= item.split('=', 2);
            Log.debug(parts);
            String value = parts[1].trim();
            value=value.substring(1, value.length()-1);
            params.put(parts[0].trim() ,value);
        }
        Assert.areEqual('qyprdBeCEyz8XgXyQLhGyVKFJxSj5R',params.get('oauth_consumer_key'),'Consumer Key');
        Assert.areEqual('-7573429099354025761',params.get('oauth_nonce'),'Nonce');
        
        Assert.areEqual('HMAC-SHA1',params.get('oauth_signature_method'), 'Signature Method');
        Assert.areEqual('1471671671',params.get('oauth_timestamp'), 'Time stamp');
        Assert.areEqual('1.0', params.get('oauth_version'),'version');
        Assert.areEqual('qyprdzprZlXnWrBopgxXftKiJBXdnsUwddcW5rNhuoZy0Mpm',params.get('oauth_token'), 'token');
        Assert.areEqual('XTM8RetTpetvl7L8guF6bvcYxfo%3D',params.get('oauth_signature'), 'Signature');
    
    //Accept: application/json
    //Request-ID: 8d549292-1bc3-470e-a435-cbdae699e22b
    //Authorization: 
    //Host: sandbox-quickbooks.api.intuit.com
    //Connection: Keep-Alive
    //User-Agent: Apache-HttpClient/4.1.1 (java 1.5)


        //check
        // - endpoint address
        // - URL
        // - auth header

        Clock.reset();
    }
}