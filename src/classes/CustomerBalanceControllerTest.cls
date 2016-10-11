@isTest
public class CustomerBalanceControllerTest {
    
      private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            
            system.debug('hi there');
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            
            system.debug('MOCK : ' + req.getEndpoint());
           
            String json = '';
            if (req.getEndpoint().contains('customer')){
                
                json = '{'+
                '  \"Customer\": {'+
                '    \"Taxable\": false,'+
                '    \"Job\": false,'+
                '    \"BillWithParent\": false,'+
                '    \"Balance\": 0,'+
                '    \"BalanceWithJobs\": 0,'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"PreferredDeliveryMethod\": \"None\",'+
                '    \"PrimaryTaxIdentifier\": \"XXXX2352345\",'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"89\",'+
                '    \"SyncToken\": \"0\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-08-23T20:57:44-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-08-23T20:57:44-07:00\"'+
                '    },'+
                '    \"FullyQualifiedName\": \"www1\",'+
                '    \"CompanyName\": \"www1\",'+
                '    \"DisplayName\": \"www1\",'+
                '    \"PrintOnCheckName\": \"www1\",'+
                '    \"Active\": true'+
                '  },'+
                '  \"time\": \"2016-08-23T20:57:44.496-07:00\"'+
                '}';
            }
            else if (req.getEndpoint().contains('query')){
                 json = '{'+
                    ''+
                    '  \"QueryResponse\": {'+
                    ''+
                    '    \"Invoice\": ['+
                    ''+
                    '      {'+
                    ''+
                    '        \"sparse\": true,'+
                    ''+
                    '        \"Id\": \"224\",'+
                    ''+
                    '        \"DocNumber\": \"1029\",'+
                    ''+
                    '        \"TxnDate\": \"2016-08-11\",'+
                    ''+
                    '        \"LinkedTxn\": [],'+
                    ''+
                    '        \"Line\": [],'+
                    ''+
                    '        \"DueDate\": \"2016-09-10\",'+
                    ''+
                    '        \"TotalAmt\": 82.5,'+
                    ''+
                    '        \"Balance\": 82.5'+
                    ''+
                    '      },'+
                    ''+
                    '      {'+
                    ''+
                    '        \"sparse\": true,'+
                    ''+
                    '        \"Id\": \"8\",'+
                    ''+
                    '        \"DocNumber\": \"1004\",'+
                    ''+
                    '        \"TxnDate\": \"2016-07-19\",'+
                    ''+
                    '        \"LinkedTxn\": [],'+
                    ''+
                    '        \"Line\": [],'+
                    ''+
                    '        \"DueDate\": \"2016-08-07\",'+
                    ''+
                    '        \"TotalAmt\": 528.0,'+
                    ''+
                    '        \"Balance\": 0'+
                    ''+
                    '      }'+
                    ''+
                    '    ],'+
                    ''+
                    '    \"startPosition\": 1,'+
                    ''+
                    '    \"maxResults\": 2,'+
                    ''+
                    '    \"totalCount\": 2'+
                    ''+
                    '  },'+
                    ''+
                    '  \"time\": \"2016-09-01T22:34:11.245-07:00\"'+
                    ''+
                    '}';

            }
                        
   
            res.setBody(json);
            
            return res;
        }
    }
    
    @isTest static void Test_GetCustomerBalance(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        User user1;
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'alias',
            Email='test.1@example.com',
            EmailEncodingKey='UTF-8',
            Firstname='Firstname',
            Lastname='Lastname',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_GB',
            TimeZoneSidKey='GMT'
        );
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            TestDataFactory.CreateOAuthServiceEntries(); 
            Test.setMock(HttpCalloutMock.class, new Mock());
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                QuickBooks_Id__c = '201'
            );
            Database.insert(portalAccount1);
            
            Contact contact1 = new Contact(
                FirstName = 'Firstname',
                Lastname = 'Lastname',
                AccountId = portalAccount1.Id,
                Email = 'test@test.com'
            );
            Database.insert(contact1);
            
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Trader' Limit 1];
            user1 = new User(
                Username = 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Lastname',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_GB',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
        }
        
        Double balance;
        Test.startTest();
        System.runas(user1){
            Test.setMock(HttpCalloutMock.class, new Mock());                       
            balance = CustomerBalanceController.getCustomerBalance();
            
        }
        Test.stopTest();
        System.assert(balance != null);
        
    }
    
    @isTest static void Test_GetCustomerBalanceQuickBookIdNull(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        User user1;
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'alias',
            Email='test.1@example.com',
            EmailEncodingKey='UTF-8',
            Firstname='Firstname',
            Lastname='Lastname',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_GB',
            TimeZoneSidKey='GMT'
        );
        Database.insert(portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            TestDataFactory.CreateOAuthServiceEntries(); 
            Test.setMock(HttpCalloutMock.class, new Mock());
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                QuickBooks_Id__c = null
            );
            Database.insert(portalAccount1);
            
            Contact contact1 = new Contact(
                FirstName = 'Firstname',
                Lastname = 'Lastname',
                AccountId = portalAccount1.Id,
                Email = 'test@test.com'
            );
            Database.insert(contact1);
            
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Trader' Limit 1];
            user1 = new User(
                Username = 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Lastname',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_GB',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
        }
        
        Double balance;
        Test.startTest();
        System.runas(user1){
            Test.setMock(HttpCalloutMock.class, new Mock());                       
            balance = CustomerBalanceController.getCustomerBalance();
            
        }
        Test.stopTest();
        System.assert(balance == null);
        
    }
}