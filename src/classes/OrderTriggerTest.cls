@isTest public class OrderTriggerTest {
    @isTest 
    static void TestGeneratePuchaseOrder() {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        Order order = TestDataFactory.createPO();
        system.debug('Test:: ' + order.QuickBooksId__c);
        order.PO_Approved__c = true;
        update order;
    }
}