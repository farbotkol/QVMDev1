@isTest
public class PrintToPDFControllerTest {
    
    @isTest static void Test_Constructor(){
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accs = TestDataFactory.createAccountsWithOpps(1,1,'SL');
        TestDataFactory.createOpportunity(accs.get(0).Id);
        List<OrderItem> orders = TestDataFactory.createOrderItemWithLeave(3,'SL');
        Test.setCurrentPage(Page.PrintToPdf);
        ApexPages.currentPage().getParameters().put('Id', orders.get(0).OrderId);
        Test.startTest();
        Order orderObj = new Order();
        ApexPages.StandardController sc = new ApexPages.StandardController(orderObj);
        PrintToPDFController pdfCon = new PrintToPDFController(sc);
        List<OrderItem> oi = pdfCon.orderItems;
        Test.stopTest();
        System.assert(oi.size() > 1);
    }
    
}