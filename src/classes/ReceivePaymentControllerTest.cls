@IsTest
public class ReceivePaymentControllerTest {

    @isTest static  void Test_NewOrderControllerExtAccountInit() {

        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.startTest();
        //RecordType ty = [SELECT Id, Name FROM RecordType WHERE Name LIKE '%Payments From Accounts%' LIMIT 1];
        //system.debug(':D '+ty);
        
		//Opportunity opp = [select id, name, AccountId from Opportunity limit 1];
        //system.debug('opp.AccountId : ' + opp.AccountId);
        List<Batch_Jobs__c> batches = new List<Batch_Jobs__c>();
        
        PageReference ref = Page.NewOrder;
        //ref.getParameters().put('id',opp.AccountId);
        //ref.getParameters().put('retURL',opp.AccountId);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardSetController std = new ApexPages.StandardSetController(batches);
        ReceivePaymentController receivePaymentController = new ReceivePaymentController(std);
        
        PageReference pr = receivePaymentController.Redirect();
        //system.debug(''+pr);
        Test.stopTest();
        System.assert(pr != null);
    
    }
}