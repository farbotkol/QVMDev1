@isTest
public class QBOInvoiceOrderWebhook_Test {
    
    static testMethod void testPost(){
        RestRequest req = new RestRequest(); 
        req.addHeader('Content-Type', 'application/json');                
        req.requestURI = '/services/apexrest/QBOInvoiceWebhook';
        req.httpMethod = 'POST';
        String JSONMsg = '{"eventNotifications":[{"realmId":"123145821595617","dataChangeEvent":{"entities":[{"name":"Payment","id":"33898","operation":"Create","lastUpdated":"2016-10-03T18:42:04.000Z"},{"name":"Invoice","id":"33876","operation":"Create","lastUpdated":"2016-10-04T05:40:18.000Z"}]}}]}';
        req.requestBody = Blob.valueof(JSONMsg);
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        RestContext.request.addHeader('httpMethod', 'POST');
        System.debug('RestContext.response '+RestContext.request);
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);
        Batch_Jobs__c job = TestDataFactory.createSLBatchJobLCN();
        TestDataFactory.createOrder('SL');
        
        Test.startTest();
        QBOInvoiceOrderWebhook.post();
        Test.stopTest();
    }
}