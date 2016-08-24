@isTest
private class StallsAvaliableTodayControllerTest {
	
	@isTest static void test_getStallsAvaliableToday() {


		TestDataFactory.createSingleStallWithNoOpp();

		StallsAvaliableTodayController ctl = new StallsAvaliableTodayController();
		List<Stall__c> stalls = ctl.getStallsAvaliableToday();

		System.assert(stalls.size() == 1);

	}
	
	
	
}