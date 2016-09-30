@IsTest
public class NewOrderControllerExtTest {

    
    @isTest static  void Test_NewOrderControllerExtAccountInit() {

        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        Test.startTest();
       

        Opportunity opp = [select id, name, AccountId from Opportunity limit 1];
        system.debug('opp.AccountId : ' + opp.AccountId);
        List<Order> orders = new List<Order>();
        
        PageReference ref = Page.NewOrder;
        ref.getParameters().put('id',opp.AccountId);
        ref.getParameters().put('retURL',opp.AccountId);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardSetController std = new ApexPages.StandardSetController(orders);
        NewOrderControllerExt myNewOrderControllerExt = new NewOrderControllerExt(std);
        
        PageReference pr = myNewOrderControllerExt.Redirect();
       
        Test.stopTest();
        System.assert(pr != null);
    
    }
    
    @isTest static  void Test_NewOrderControllerExtOppInit() {

        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        Test.startTest();
       

        Opportunity opp = [select id, name, AccountId from Opportunity limit 1];
        system.debug('opp.AccountId : ' + opp.AccountId);
        List<Order> orders = new List<Order>();
        
        PageReference ref = Page.NewOrder;
        ref.getParameters().put('id',opp.Id);
        ref.getParameters().put('retURL',opp.Id);
        Test.setCurrentPage(ref);
        
        ApexPages.StandardSetController std = new ApexPages.StandardSetController(orders);
        NewOrderControllerExt myNewOrderControllerExt = new NewOrderControllerExt(std);
        
        PageReference pr = myNewOrderControllerExt.Redirect();
       
        Test.stopTest();
        System.assert(pr != null);
    
    }
}