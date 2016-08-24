@isTest
class IntuitServiceTests {
    private static final String TEST_API_NAME='Intuit_test';

    @testSetup 
    static void setupTest()
    {
        setupSettings();
        setupToken();
    }
    static void setupSettings(){
        qvm_intuit_api__c settings = new qvm_intuit_api__c();
        settings.ApiName__c = TEST_API_NAME;
        settings.ServiceBaseAddress__c = 'https://sandbox-quickbooks.api.intuit.com/v3/company/{realm}/';
        settings.ConsumerKey__c ='qyprdBeCEyz8XgXyQLhGyVKFJxSj5R';
        settings.ConsumerSecret__c='d89SNefvcrnlgY1ot88GL1uhviL68L5MenIhjZmw';
        insert settings; 
    }
    static void setupToken(){
        qvm_intuit_api_token__c settings = new qvm_intuit_api_token__c();
        settings.Name = TEST_API_NAME;
        settings.Token__c ='qyprdIx7WetkvVG49F5VGZU09h8AfGMczXhjW8LyTzdSiw4t';
        settings.TokenSecret__c='k21QG4eRHBo1rQf1RgZmtsYFRreBMRUyldFtTNeN';
        settings.Realm__c='193514335420637';
        insert settings;
    }
   
    @isTest
    static void sample()
    {
        HttpClient client = IntuitService.createClient();
        MockHttpRequestDispatcher dispatcher = new MockHttpRequestDispatcher();

        client.messageHandler.setDispatcher(dispatcher);
        dispatcher.handleRequest().jsonContent('{"Name":"Value"}');
        String response= (String) client.jsonGet('query?query=select * from Customer', String.class);
        Assert.areEqual('{"Name":"Value"}', response);

    }
    @isTest
    static void readConfig(){
        IntuitService.Configuration config= IntuitService.getConfig();
        Assert.areEqual('Intuit_test',config.getApiName());
        Assert.areEqual('https://sandbox-quickbooks.api.intuit.com/v3/company/193514335420637/',config.getServiceBaseAddress());
    }
}