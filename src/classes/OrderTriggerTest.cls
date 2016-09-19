@isTest public class OrderTriggerTest {
	@isTest 
    static void TestGenerateOrdersAndInvoicesSL() {
    	TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        Order order = TestDataFactory.createPO();
        
        order.PO_Approved__c = true;
        update order;

    }
}