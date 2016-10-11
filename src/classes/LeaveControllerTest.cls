@isTest
public class LeaveControllerTest {

    @isTest static void Test_GetAccountBusiness(){
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
        system.debug('portalAccountOwner1 : ' + portalAccountOwner1);
        System.runAs ( portalAccountOwner1 ) {
            TestDataFactory.CreateOAuthServiceEntries();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id,
                QuickBooks_Id__c = '3'
            );
            
            Database.insert(portalAccount1);
            system.debug('portalAccount1 : ' + portalAccount1);
            
            TestDataFactory.createStallProductsAndGeneralPriceBook();
            PriceBook2 PriceBook = [select Id from PriceBook2 where Name = 'General Merchandise' limit 1];
            Id PriceBookId = PriceBook.Id;
            
            
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
            Id oppRecordTypeId = oppRecordTypeInfo.get('SL').getRecordTypeId();
            
            Opportunity opp = new Opportunity(Name=portalAccount1.Name + ' Opportunity ' ,
                                     RecordTypeid=oppRecordTypeId,
                                     StageName='Prospecting',
                                     CloseDate=System.today().addMonths(1),
                                     AccountId=portalAccount1.Id,
                                     Contracted_Leave__c=20,
                                     Business_Status__c = 'Open',
                                     pricebook2id=PriceBookId,
                                     Uplift_Factor__c=1);
            insert opp;
            
            
            Contact contact1 = new Contact(
                FirstName = 'Firstname',
                Lastname = 'Lastname',
                AccountId = portalAccount1.Id,
                Email = 'test@test.com'
            );
            Database.insert(contact1);
            system.debug('contact1 : ' + contact1);
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
            system.debug('user1 : ' + user1);
            
        }
        Test.startTest();
        List<Opportunity> opp = new List<Opportunity>();        
        System.runas(user1){
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
            opp = LeaveController.getAccountBusiness();            
        }
        Test.stopTest();
        System.assert(opp != null);
    }
    
    @isTest static void Test_CreateLeave(){
        TestDataFactory.CreateOAuthServiceEntries(); 
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> acc = TestDataFactory.createAccountsWithOpps(1,1,'SL');
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        String Id = [SELECT ID from Opportunity LIMIT 1].Id;
        String leaveDate = '2080-09-14';
        Test.startTest();
        LeaveController.createLeave(Id,leaveDate);  
        Test.stopTest();
    }
    
  
}