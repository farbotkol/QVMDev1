/*
Changes : Uday/Prasannanjaneyulu
Date = 17-Apr-2015
*/
public with sharing class QuickBooksConnector {
    public OAuthService__c service { get; set; }
    public OAuth_Token__c oaToken { get; set; }
    
    public string responseString {get;set;}
    
    private String token;
    private String tokenSecret;
    private String verifier;
    
    private String nonce;
    private String timestamp;
    private String signature;
    @TestVisible private String consumerKey;
    @TestVisible private String consumerSecret;
    
    private String callbackUrl;
    
    private Map<String, String> parameters = new Map<String, String>();
    
    public QuickBooksConnector() {
        service = [
                SELECT Request_Token_URL__c, Access_Token_URL__c, Consumer_Key__c, Consumer_Secret__c,
                    Authorization_URL__c, Application_Token__c, BaseURL__c,CallbackUrl__c,
                    (SELECT Token__c, Secret__c, Is_Access__c, Realm_Id__c
                    FROM OAuth_Tokens__r
                    Order by CreatedDate DESC
                    )
                FROM OAuthService__c
                WHERE Name = 'QuickBooksAU' LIMIT 1];
        system.debug('Service Token::::::'+service.OAuth_Tokens__r);
        if(service != NULL && ! service.OAuth_Tokens__r.isEmpty()) {
            oaToken = new OAuth_Token__c();
            oaToken = service.OAuth_Tokens__r[0];
            system.debug('==oaToken==>>'+oaToken);
        }
    }
    
    
    
    
    public PageReference authorize() {
        if(service == NULL) {
            return NULL;
        }
        
        // Use 'oob' when you do not have a callback url
        //callbackUrl =
         //   EncodingUtil.urlEncode('http://' + ApexPages.currentPage().getHeaders().get('Host') +
           //     '/QuickBooksLogin', 'UTF-8');
        
        System.debug(':::::  callbackUrl:  ' + service.CallbackUrl__c );
        callbackUrl=EncodingUtil.urlEncode(service.CallbackUrl__c ,'UTF-8');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(service.Request_Token_URL__c);
        
        consumerKey = service.Consumer_Key__c;
        consumerSecret = service.Consumer_Secret__c;
        
        System.debug(':::::  Key and secret:  ' + consumerKey + ' - ' + consumerSecret);
        
        sign(req);
        
        HttpResponse res = NULL;
        
        if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req);
        }
        
        responseString = res.getBody();
        System.debug('::::: Response from request token request: (' + res.getStatusCode() + ')' + res.getBody());
        
        String resParams = (Test.isRunningTest() ?
            'oauth_token=token&oauth_token_secret=token_secret' :
            res.getBody());
        
        Map<String, String> rp = getUrlParams(resParams);
        
        oaToken = new OAuth_Token__c(
                Owner__c = UserInfo.getUserId(),
                OAuthService__c = service.Id,
                Token__c = rp.get('oauth_token'),
                Secret__c = rp.get('oauth_token_secret'),
                Is_Access__c = false);
        
        insert oaToken;
        
        system.debug('oaToken.Token__c: '  + oaToken.Token__c);
        String authorizePage = service.Authorization_URL__c + '?oauth_token=' +
            EncodingUtil.urlDecode(oaToken.Token__c, 'UTF-8') + '&oauth_consumer_key=' +
            service.Consumer_Key__c;
        
        return new PageReference(authorizePage);
    }
    
    public void sign(HttpRequest req) {
        nonce = String.valueOf(Crypto.getRandomLong());
        timestamp = String.valueOf(DateTime.now().getTime() / 1000);
        
        refreshParameters();
        
        String s = createBaseString(parameters, req);
        
       // Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(s), Blob.valueOf(consumerSecret + '&' +
         //   (tokenSecret != NULL ? tokenSecret : '')));

        
        //Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(s), Blob.valueOf(service.Consumer_Secret__c + '&' +
            //(oaToken.Secret__c != NULL ? oaToken.Secret__c : '')));
        
        Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(s), Blob.valueOf(service.Consumer_Secret__c + '&' +
            (tokenSecret != NULL ? tokenSecret : '')));
        
        signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');
        
        String header = 'OAuth ';
        for(String key : parameters.keySet()) {
            header = header + key + '="' + parameters.get(key) + '", ';
        }
        
        header = header + 'oauth_signature="' + signature + '"';
        
        System.debug('::::: header = ' + header);
        
        req.setHeader('Authorization', header);
    }
    
    public Boolean completeAuthorization(String p_Token, String p_Verifier, String p_RealmId) {
        oaToken = NULL;
        
        try {
            oaToken = [
                    SELECT OAuthService__r.Name, OAuthService__r.Access_Token_Url__c,
                        OAuthService__r.Consumer_Key__c, OAuthService__r.Consumer_Secret__c,
                        Token__c, Secret__c, Is_Access__c, Realm_Id__c
                    FROM OAuth_Token__c
                    WHERE Owner__c = :UserInfo.getUserId()
                    AND Token__c = :EncodingUtil.urlEncode(p_Token, 'UTF-8')
                    AND Is_Access__c = false];
        
        } catch(System.QueryException e) {
            return false;
        }
        
        consumerKey = oaToken.OAuthService__r.Consumer_Key__c;
        consumerSecret = oaToken.OAuthService__r.Consumer_Secret__c;
        
        this.token = oaToken.Token__c;
        tokenSecret = oaToken.Secret__c;
        
        if(p_Verifier != NULL) {
            this.verifier = EncodingUtil.urlEncode(p_Verifier, 'UTF-8');
        }
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(oaToken.OAuthService__r.Access_Token_Url__c);
        req.setBody('');
        
        sign(req);
        
        HttpResponse res = NULL;
        
        if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req);
        }
        
        System.debug('::::: Response from request token request: (' + res.getStatusCode() + ')' + res.getBody());
        
        if(res.getStatusCode() > 299) {
            return false;
        }
        
        String resParams = (Test.isRunningTest() ?
            'oauth_token=token&oauth_token_secret=token_secret' :
            res.getBody());
        
        Map<String, String> rp = new Map<String, String>();
        for(String s : resParams.split('&')) {
            List<String> kv = s.split('=');
            rp.put(kv[0], kv[1]);
        }
        
        oaToken.Token__c = rp.get('oauth_token');
        oaToken.Secret__c = rp.get('oauth_token_secret');
        oaToken.Realm_Id__c = p_RealmId;
        oaToken.Is_Access__c = true;
        
        Database.update(oaToken);
        
        return true;
    }
    
    @TestVisible private void refreshParameters() {
        
        
                //token = oaToken.Token__c;
        //tokenSecret = oaToken.Secret__c;
        //consumerKey = service.Consumer_Key__c;
        //consumerSecret = service.Consumer_Secret__c
        parameters.clear();
        parameters.put('oauth_consumer_key', service.Consumer_Key__c);
        
        system.debug('tocken');
         if(this.token != NULL) {
            parameters.put('oauth_token', this.token);
        }
        /*
        if(oaToken.Token__c != NULL) {
            parameters.put('oauth_token', oaToken.Token__c);
        }*/
        
        if(verifier != NULL) {
            parameters.put('oauth_verifier', verifier);
        }
        
        if(callbackUrl != NULL) {
            parameters.put('oauth_callback', callbackUrl);
        }
        
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_version', '1.0');
        parameters.put('Host','qbo.intuit.com');
       // parameters.put('X-NewRelic-ID','UQMAU15RGwEFXVFUBQE=');
       // parameters.put('X-NewRelic-Transaction','PxQOI1BaCnEFJlNadgYAVCEDFB8EBw8RVT8=');
        parameters.put('Connection','Keep-Alive');
    }
    
    @TestVisible private String createBaseString(Map<String,String> oauthParams, HttpRequest req) {
        Map<String,String> p = oauthParams.clone();
        
       // if(req.getMethod().equalsIgnoreCase('post') && req.getBody() != NULL &&
           // req.getHeader('Content-Type') == 'application/x-www-form-urlencoded') {
            
            p.putAll(getUrlParams(req.getBody()));
           
        //}
        
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        
        if(n > -1) {
            p.putAll(getUrlParams(host.substring(n + 1)));
            host = host.substring(0, n);
        }
        
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        
        String s = (keys.get(0) != 'status' ?
            EncodingUtil.urlEncode(keys.get(0) + '=' + p.get(keys.get(0)), 'UTF-8') :
            urlEncode(keys.get(0) + '=' + p.get(keys.get(0))));
            
        for(Integer i = 1; i < keys.size(); i++) {
            if(keys.get(i) != 'status') {
                s += EncodingUtil.urlEncode('&' + keys.get(i) + '=' + p.get(keys.get(i)), 'UTF-8');
            } else {
                s += EncodingUtil.urlEncode('&', 'UTF-8');
                s += urlEncode(keys.get(i) + '=' + p.get(keys.get(i)));
            }
        }
        
        return req.getMethod().toUpperCase() + '&' + EncodingUtil.urlEncode(host, 'UTF-8') + '&' + s;
    }
    
    @TestVisible private Map<String, String> getUrlParams(String value) {
        Map<String, String> res = new Map<String, String>();
        
        if(value == NULL || value.trim() == '') {
            return res;
        }
        
        for(String s : value.split('&')) {
            List<String> kv = s.split('=');
            if(kv.size() > 1) {
                res.put(kv[0], kv[1]);
            }
        }
        
        return res;
    }
    
    @TestVisible private String urlEncode(String unencodedString) {
        String returnVal = NULL;
        
        if(unencodedString != NULL) {
            returnVal = '';
            
            for(Integer i = 0; i < unencodedString.length(); i++) {
                String c = charAt(unencodedString, i);
                
                if(' '.equals(c)) {
                    returnVal += '%20';
                } else {
                    returnVal += EncodingUtil.urlEncode(c, 'UTF-8');
                }
            }
        }
        
        return returnVal;
    }
    
    @TestVisible private String charAt(String str, Integer index) {
        if(str == NULL) {
            return NULL;
        }
        
        if(str.length() <= 0) {
            return str;
        }
        
        if(index < 0 || index >= str.length()){
            return null;
        }
        
        return str.substring(index, index + 1);
    }
    
    public void fixToken()
    {
        verifier = NULL;
        callbackUrl = NULL;
        
        token = oaToken.Token__c;
        tokenSecret = oaToken.Secret__c;
        consumerKey = service.Consumer_Key__c;
        consumerSecret = service.Consumer_Secret__c;
    }
    
    
    public void retrieveAllQBAccounts() {
        verifier = NULL;
        callbackUrl = NULL;
        
        token = oaToken.Token__c;
        tokenSecret = oaToken.Secret__c;
        consumerKey = service.Consumer_Key__c;
        consumerSecret = service.Consumer_Secret__c;
                
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(service.BaseURL__c + oaToken.Realm_Id__c + '/query?query=select%20%2A%20from%20Account');

        //req.setEndPoint('https://qb.sbfinance.intuit.com/v3/company/1183910435/customer/1');
        req.setHeader('Accept', 'application/json;charset=UTF-8');
        //req.getHeader('application/Xml;charset=UTF-8');
        sign(req);
        // System.debug('::::: Request = ' + req.getBodyDocument());
        System.debug('::::: Request = ' + req.getHeader('Content-Type'));
        System.debug('::::: Request = ' + req.getHeader('oauth_token'));
        System.debug('::::: Request = ' + req.getHeader('oauth_consumer_key'));
        System.debug('::::: Request = ' + req.getHeader('Host'));
        System.debug('::::: Request = ' + req.getHeader('oauth_version'));
        System.debug('::::: Request = ' + req.getHeader('oauth_nonce'));
        System.debug('::::: Request = ' + req.getHeader('oauth_signature_method'));
        System.debug('::::: Request = ' + req.getHeader('oauth_signature'));
        System.debug('Request='+req);
        
        HttpResponse res;
         if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req); 
        }
        
        responseString = res.getBody();
        System.debug('::::: Response = (' + res.getStatusCode() + ')' + res.getBody());
       
    }
    
    /*
    public void createCustomers()
    {
        system.debug('==oaToken in create==>>'+oaToken);
        
        token = oaToken.Token__c;
        tokenSecret = oaToken.Secret__c;
        consumerKey = service.Consumer_Key__c;
        consumerSecret = service.Consumer_Secret__c;
        string str=  '<?xml version="1.0" encoding="utf-8"?><Customer xmlns:ns2="http://www.intuit.com/sb/cdm/qbo" xmlns="http://schema.intuit.com/finance/v3"><TypeOf>Person</TypeOf><Name>Prasad</Name><Address>'+
                    '<Line1>Park Avenue</Line1><City>Woodland Hills</City><CountrySubDivisionCode>CA</CountrySubDivisionCode><PostalCode>91367</PostalCode></Address><Phone><DeviceType>Mobile</DeviceType><FreeFormNumber>(770) 349-1200</FreeFormNumber>'+
                    '</Phone><Phone><DeviceType>Fax</DeviceType><FreeFormNumber>(770) 349-1300</FreeFormNumber></Phone><WebSite><URI>http://www.digitalinsight.mint.com/</URI></WebSite><Email><Address>john_doe@digitalinsight.mint.com</Address></Email>'+
                    '<GivenName>jAMES</GivenName><MiddleName>TESTER</MiddleName><FamilyName>TEST</FamilyName><DBAName>Prakash</DBAName><SalesTermId>5</SalesTermId></Customer>';
           
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        ///company/:companyId/customer
        //req.setEndpoint('https://qbo.intuit.com/qbo1/resource/customer/v2/' + oaToken.Realm_Id__c);
        req.setEndPoint(service.BaseURL__c + oaToken.Realm_Id__c + '/customer');
        req.setHeader('Content-Type', 'application/xml');
        
      
       
        sign(req);
        req.setBody(str);
        System.debug('::::: Request = ' + req);
        
        HttpResponse res;
        if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req);
        }
        
        responseString = res.getBody();
        
        system.debug('$$$$$'+res);
        System.debug('::::: response = ' + res.getbody());
    }

    public void createCustomers2()
    {
        system.debug('==oaToken in create==>>'+oaToken);
        
        token = oaToken.Token__c;
        tokenSecret = oaToken.Secret__c;
        consumerKey = service.Consumer_Key__c;
        consumerSecret = service.Consumer_Secret__c;
        string str=  '{'+
        '    \"BillAddr\": {'+
        '        \"Line1\": \"123 Main Street\",'+
        '        \"City\": \"Mountain View\",'+
        '        \"Country\": \"USA\",'+
        '        \"CountrySubDivisionCode\": \"CA\",'+
        '        \"PostalCode\": \"94042\"'+
        '    },'+
        '    \"Notes\": \"Here are other details.\",'+
        '    \"Title\": \"Mr\",'+
        '    \"GivenName\": \"James13342\",'+
        '    \"MiddleName\": \"B\",'+
        '    \"FamilyName\": \"King13342\",'+
        '    \"Suffix\": \"Jr\",'+
        '    \"FullyQualifiedName\": \"King Grocerie43s13111\",'+
        '    \"CompanyName\": \"King Groceries133423341\",'+
        '    \"DisplayName\": \"King\'s Groceries134e431\",'+
        '    \"PrimaryPhone\": {'+
        '        \"FreeFormNumber\": \"(555) 555-5555\"'+
        '    },'+
        '    \"PrimaryEmailAddr\": {'+
        '        \"Address\": \"jdrew13334@myemail.com\"'+
        '    }'+
        '}';
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        ///company/:companyId/customer
        //req.setEndpoint('https://qbo.intuit.com/qbo1/resource/customer/v2/' + oaToken.Realm_Id__c);
        req.setEndPoint(service.BaseURL__c + oaToken.Realm_Id__c + '/customer');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        //application/json;charset=UTF-8
      
       
        sign(req);
        req.setBody(str);
        System.debug('::::: Request = ' + req);
        
        HttpResponse res;
        if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req);
        }
        
        responseString = res.getBody();
        
        system.debug('$$$$$'+res);
        System.debug('::::: response = ' + res.getbody());
    }
    */
}