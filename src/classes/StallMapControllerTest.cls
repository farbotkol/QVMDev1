@isTest
public class StallMapControllerTest {

    @isTest 
    static void test_getbuildTable() {

		 
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
		
        
        
        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        
        opp.Permitted_Use__c = 'Apparel';
        update opp;
        TestDataFactory.createSingleStall(opp);
		

		StallMapController ctl = new StallMapController();
		string mapstr = ctl.getbuildTable();

		System.assert(mapstr.contains('div'));

	}
}