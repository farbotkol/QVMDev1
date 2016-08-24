@isTest
public with sharing class QuickBooksLoginControllerTest {
       
        @isTest static void Test_Constructor(){
            
           
            TestDataFactory.CreateOAuthServiceEntries();
       
            Test.startTest();
            
            QuickBooksLoginController qbl = new QuickBooksLoginController();
            
            Test.stopTest();
            System.assert(qbl.qbConnector != null);
           
        }
        

        
        @isTest static void Test_CompleteAuthorization(){
            
            TestDataFactory.CreateOAuthServiceEntries();
            Test.setCurrentPage(Page.QuickBooksLogin);
            ApexPages.currentPage().getParameters().put('oauth_token', 'qyprdf5ltQR3fLoNbAq8rVXp2Y3c');
            ApexPages.currentPage().getParameters().put('oauth_verifier', 'qyprdf5ltQR3fLoNbAq8rVX');
            ApexPages.currentPage().getParameters().put('realmId', '67454209');
            Test.startTest();
   
            QuickBooksLoginController qbl = new QuickBooksLoginController();
            qbl.completeAuthorization();
            Test.stopTest();          

			System.assert(qbl.isQuickBooksAuthorized != true);

        }
        
        
}