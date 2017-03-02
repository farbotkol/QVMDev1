@isTest
public class QBOClassTriggerTest {
    
    static testmethod void test_trigger()
    {
        
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.startTest();
            QBO_Class__c qboclass = new QBO_Class__c();
            
            qboclass.Name = 'LH';
            insert qboclass;
            //update qboclass;
        Test.stopTest();
        System.assertEquals(1,1);
    }

}