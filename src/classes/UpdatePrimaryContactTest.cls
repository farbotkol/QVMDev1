@isTest
public class UpdatePrimaryContactTest {

    @isTest static void AddedPirmaryContactToAccountContactRole(){
        /* Create Contact
         * Create Account
         * Create the AccountContactRole
         * Run the Method
         * Assert the Contact's Primary Contact is the Contact
		 */
        
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        
        Test.startTest();
        
        Contact contact = TestDataFactory.createContact('TestAccountName', 
                                                         'TestFirstName', 
                                                         'TestLastName',
                                                         'TestEmail@mail.com');
		AccountContactRole accContactRole = new AccountContactRole(AccountId = contact.AccountId,
                                                                   ContactId = contact.Id,
                                                                   IsPrimary = true
                                                                  );
        insert accContactRole;
        
        UpdatePrimaryContact.startUpdate();
        List<Account> accounts = [Select Primary_Contact__c From Account Where Primary_Contact__c = :accContactRole.ContactId];
        Test.stopTest();
        System.assert(accounts[0] != null);
    }
    
    @isTest static void AddedSecondaryContactToAccountContactRole(){
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        
        Test.startTest();
        
        Contact contact = TestDataFactory.createContact('TestAccountName', 
                                                         'TestFirstName', 
                                                         'TestLastName',
                                                         'TestEmail@mail.com');
		AccountContactRole accContactRole = new AccountContactRole(AccountId = contact.AccountId,
                                                                   ContactId = contact.Id,
                                                                   IsPrimary = true
                                                                  );
        insert accContactRole;
        UpdatePrimaryContact.startUpdate();
        Contact contact2 = TestDataFactory.createContact('TestAccountName2', 
                                                         'TestFirstName2', 
                                                         'TestLastName2',
                                                         'TestEmail2@mail.com');
		AccountContactRole accContactRole2 = new AccountContactRole(AccountId = contact2.AccountId,
                                                                   ContactId = contact2.Id,
                                                                   IsPrimary = false
                                                                  );
        insert accContactRole2;
        UpdatePrimaryContact.startUpdate();
        
        List<Account> accounts = [Select Primary_Contact__c From Account Where Primary_Contact__c = :accContactRole.ContactId];
        Test.stopTest();
        System.assert(accounts[0] != null);
    }
    
    @isTest static void AddedPirmaryContactToOpportunityContactRole(){
        /* Create Contact
         * Create Opportunity
         * Create the AccountContactRole
         * Run the Method
         * Assert the Contact's Primary Contact is the Contact
		 */
        
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
                Contact contact = TestDataFactory.createContact('TestAccountName', 
                                                         'TestFirstName', 
                                                         'TestLastName',
                                                         'TestEmail@mail.com');
        Opportunity opportunity = TestDataFactory.createOpportunity(contact.AccountId);
		OpportunityContactRole oppContactRole = new OpportunityContactRole(OpportunityId = opportunity.Id,
                                                                   ContactId = contact.Id,
                                                                   IsPrimary = true
                                                                  );
        insert oppContactRole;
        
        UpdatePrimaryContact.startUpdate();
        Test.startTest();

        List<Opportunity> opportunities = [Select Primary_Contact__c From Opportunity Where Primary_Contact__c = :oppContactRole.ContactId];
        System.assert(opportunities[0] != null);
        Test.stopTest();
    }
    
    @isTest static void AddedSecondaryContactToOpportunityContactRole(){
        
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
                
        Contact contact = TestDataFactory.createContact('TestAccountName', 
                                                         'TestFirstName', 
                                                         'TestLastName',
                                                         'TestEmail@mail.com');
        Opportunity opportunity = TestDataFactory.createOpportunity(contact.AccountId);
		OpportunityContactRole oppContactRole = new OpportunityContactRole(OpportunityId = opportunity.Id,
                                                                   ContactId = contact.Id,
                                                                   IsPrimary = true
                                                                  );
        insert oppContactRole;
        
        UpdatePrimaryContact.startUpdate();
        
        
        Contact contact2 = TestDataFactory.createContact('TestAccountName2', 
                                                         'TestFirstName2', 
                                                         'TestLastName2',
                                                         'TestEmail2@mail.com');
        Opportunity opportunity2 = TestDataFactory.createOpportunity(contact2.AccountId);
		OpportunityContactRole oppContactRole2 = new OpportunityContactRole(OpportunityId = opportunity2.Id,
                                                                   ContactId = contact2.Id,
                                                                   IsPrimary = true
                                                                  );
        insert oppContactRole2;
        
        UpdatePrimaryContact.startUpdate();
        Test.startTest();

        
        List<Opportunity> opportunities = [Select Primary_Contact__c From Opportunity Where Primary_Contact__c = :oppContactRole.ContactId];
        System.assert(opportunities[0] != null);
        Test.stopTest();
    }
}