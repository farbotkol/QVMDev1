@isTest
public class QuickBooksConnectorTest {
       
        
        @isTest static void Test_Constructor(){
        
       
            TestDataFactory.CreateOAuthServiceEntries();
           
            Test.startTest();
            QuickBooksConnector qbo = new QuickBooksConnector();
            Test.stopTest();
           
            System.assert(qbo.service != null);

    }
    
      @isTest static void Test_Authorize(){
        
       
            TestDataFactory.CreateOAuthServiceEntries();
            QuickBooksConnector qbo = new QuickBooksConnector();
           
            Test.startTest();
            PageReference page = qbo.authorize();
            Test.stopTest();
           
            System.assert(page != null);

    }
    
    @isTest static void Test_CompleteAuthorization(){
        
       
            TestDataFactory.CreateOAuthServiceEntries();
            QuickBooksConnector qbo = new QuickBooksConnector();
           
            Test.startTest();
            Boolean boolValue = qbo.completeAuthorization('UTF-8','UTF-8','67454209');
            Test.stopTest();
            

            System.assert(boolValue != null);

    }
    
    @isTest static void Test_RefreshParameters(){
        
            Map<String, String> parameters = new Map<String, String>();
            
            TestDataFactory.CreateOAuthServiceEntries();
            QuickBooksConnector qbo = new QuickBooksConnector();
            
            Test.startTest();
            qbo.refreshParameters();
            
            Test.stopTest();
           
    }
    
    @isTest static void Test_UrlEncode(){
        
           
            TestDataFactory.CreateOAuthServiceEntries();
            QuickBooksConnector qbo = new QuickBooksConnector();
            
            Test.startTest();
            String url = qbo.urlEncode('qyprdf5ltQR3fLoNbAq8rVXp2Y3c');
            
            Test.stopTest();
            System.assert(url != null);
           
    }
    
    @isTest static void Test_RetrieveAllQBAccounts(){
        
           
            TestDataFactory.CreateOAuthServiceEntries();
            QuickBooksConnector qbo = new QuickBooksConnector();
            
            Test.startTest();
            qbo.retrieveAllQBAccounts();
            
            Test.stopTest();
           
    }
}