@isTest
private class OrderBuilderTest {
	
	@isTest static void TestGenerateOrdersSL() {
		List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');


		TestDataFactory.createStallProductsAndGeneralPriceBook();

		Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
		TestDataFactory.createSingleStall(opp);

		Batch_Jobs__c job = TestDataFactory.createSLBatchJob();


     	Test.startTest();
     
		boolean result = OrderBuilder.GenerateOrders(job.Id );
	
        Test.stopTest();
		
		    

		//System.assert(opp3.Leave_Taken_This_Year__c == 0);

	}


	@isTest static void TestGenerateOrdersLH() {
		List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'LH');


		TestDataFactory.createStallProductsAndGeneralPriceBook();

		Opportunity opp = [select id, name, Stall__c  from Opportunity limit 1];
		TestDataFactory.createPermStallWithOpp(opp);

		Batch_Jobs__c job = TestDataFactory.createLHBatchJob();

     	Test.startTest();
     
		boolean result = OrderBuilder.GenerateOrders(job.Id );
	
        Test.stopTest();
	
		//System.assert(opp3.Leave_Taken_This_Year__c == 0);

	}
	
	@isTest static void TestGenerateOrdersFees() {
		List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'LH');


		TestDataFactory.createStallProductsAndGeneralPriceBook();

		Opportunity opp = [select id, name, Stall__c  from Opportunity limit 1];
		TestDataFactory.createPermStallWithOpp(opp);

		Batch_Jobs__c job = TestDataFactory.createMCCBatchJob();
		TestDataFactory.CreateQVM_LH_FEE_SETTING_Entries();

     	Test.startTest();
     
		boolean result = OrderBuilder.GenerateOrders(job.Id );
	
        Test.stopTest();
	
		//System.assert(opp3.Leave_Taken_This_Year__c == 0);

	}
}