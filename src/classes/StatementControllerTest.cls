@isTest
public class StatementControllerTest {
   
    @isTest static void Test_Constructor(){
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.setCurrentPage(Page.ViewStatement);
        ApexPages.currentPage().getParameters().put('customerRef', '201');
        Test.startTest();
        Account acc = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        StatementController con = new StatementController(sc);
        String totalVal = con.total;
        String customerNameVal = con.customerName;
        String reportDate = con.reportDate;
        List<QBOStatement> qboStatements = con.getStatements();
        Test.stopTest();
        
    }
}