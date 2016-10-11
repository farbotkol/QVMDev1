@isTest
public class QuickBooksConnectorTest {
       
        
        @isTest static void Test_Constructor()
        {
        
       
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
    // New modifications...
     @isTest(SeeAllData=true)
     static void Test_ConstructorWithotService()
     {
        
         //
         OAuthService__c service = new OAuthService__c();
        service.Request_Token_URL__c = 'https://oauth.intuit.com/oauth/v1/get_request_token';
        service.Authorization_URL__c = 'https://appcenter.intuit.com/Connect/Begin';
        service.Access_Token_URL__c = 'https://oauth.intuit.com/oauth/v1/get_access_token';
        service.BaseURL__c = 'https://sandbox-quickbooks.api.intuit.com/v3/company/';
        service.CallbackUrl__c = 'https://cs31.salesforce.com/apex/QuickBooksLogin';
        service.Consumer_Key__c = 'qyprdf5ltQR3fLoNbAq8rVXp2Y3cxK';
        service.Consumer_Secret__c = 'gVblWDndfHuObNQY03aJjUgi7tFqYnQmJzZSsMp3';
        service.Application_Token__c = 'af18d34bbd246b43c3b9781bd831b85be89b';
        service.Name = 'QuickBooksAU';
        
        insert  service;
         
        OAuth_Token__c oaToken = new OAuth_Token__c();
        oaToken.OAuthService__c = service.Id;
        //oaToken.OAuthService__r.Consumer_Key__c = service.Consumer_Key__c;
        //oaToken.OAuthService__r.Consumer_Secret__c = service.Consumer_Secret__c;
        oaToken.Token__c = 'UTF-8';
        oaToken.Secret__c = 'qyprdf5ltQR3fLoNbAq8rVXp2';
        oaToken.Is_Access__c = false;
        oaToken.Realm_Id__c = '67454209';
         oaToken.Owner__c = UserInfo.getUserId();
        
        insert oaToken;
         //
           
          Test.startTest();
          QuickBooksConnector qbo = new QuickBooksConnector();
          service.id = null;
          //update service;
          qbo.authorize();
          Boolean boolValue = qbo.completeAuthorization('UTF-8','UTF-8','67454209');
          qbo.fixToken();
          Test.stopTest();
           
          System.assert(qbo.service != null);

    }
    
    
}