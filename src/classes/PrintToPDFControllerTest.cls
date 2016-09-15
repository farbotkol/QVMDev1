@isTest
public class PrintToPDFControllerTest {
    
    @isTest static void Test_Constructor(){
        Test.setCurrentPage(Page.PrintToPdf);
        ApexPages.currentPage().getParameters().put('Id', '201');
        Test.startTest();
        Order orderObj = new Order();
        ApexPages.StandardController sc = new ApexPages.StandardController(orderObj);
        PrintToPDFController pdfCon = new PrintToPDFController(sc);
        List<OrderItem> oi = pdfCon.orderItems;
        Test.stopTest();
    }
    
}