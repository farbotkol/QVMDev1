@isTest
private class LeaveTriggerTest {

    @isTest static void TestLeaveTrigger() {
    	TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.startTest();
       
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');


        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);

        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();

        //where id = '006p0000002kWG0AAM'
        

        List<Opportunity> opps = [select Id, Name, accountid, pricebook2id
                          ,(select id from MondayStalls__r)
                          ,(select id from TuesdayStalls__r)
                          ,(select id from WednesdayStalls__r)
                          ,(select id from ThursdayStalls__r)
                          ,(select id from FridayStalls__r)
                          ,(select id from SaturdayStalls__r)
                          ,(select id from SundayStalls__r)
                          from opportunity
                          ];

		RecordType processType =  [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                            WHERE SobjectType = 'Opportunity' and DeveloperName = 'SL' LIMIT 1];

		
        //boolean result = OrderBuilder.GenerateOrders(job.Id );
        boolean result = OrderBuilder.GenerateOrdersFromAllocatedStalls( Date.today(),Date.today() + 6, opps, job.Id,'', processType.Id );
       
        Test.stopTest();
        
            

        
        opp = [select id, name, Stall__c from Opportunity limit 1];
        // test adding each day of the week 
        List<Leave__c> leaveToAdd = new List<Leave__c>();
        Integer i = 1;
        while (i < 8)
        {
            Leave__c leave = new Leave__c();
            leave.Account_Business__c = opp.Id;
            leave.Leave_Date__c = Date.today().addDays(i);
            leaveToAdd.add(leave);
            i++;
        }
        

        Insert leaveToAdd;

        Opportunity opp2 = [select id, name, Leave_Taken_This_Year__c from Opportunity limit 1];    

        System.assert(opp2.Leave_Taken_This_Year__c == 7);

        Delete leaveToAdd;

        Opportunity opp3 = [select id, name, Leave_Taken_This_Year__c from Opportunity limit 1];    

        System.assert(opp3.Leave_Taken_This_Year__c == 0);

    }
    

    
}