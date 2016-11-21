@isTest
private class ScheduleableTest {

   // CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void testUpdatePrimaryContactSchedule() {
       
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

      // Schedule the test job
      String jobId = System.schedule('ScheduleUpdatePrimaryContact_Banana',
                        CRON_EXP, 
                        new ScheduleUpdatePrimaryContact());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
      // Verify the scheduled job hasn't run yet.
      List<Account> accounts1 = [Select Primary_Contact__c From Account Where Primary_Contact__c = :accContactRole.ContactId];
      System.assertEquals(accounts1.size(),0);
      Test.stopTest();

      // Now that the scheduled job has executed after Test.stopTest(),
      //   fetch the new merchandise that got added.
      List<Account> accounts2 = [Select Primary_Contact__c From Account Where Primary_Contact__c = :accContactRole.ContactId];
      System.assertEquals(accounts2.size(), 1);

   }
    
   static testmethod void testReconnectSchedule() {
       
       TestDataFactory.CreateOAuthServiceEntries();
       Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
       Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('ScheduleReconnect',
                        CRON_EXP, 
                        new ScheduleReconnect());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
      // Verify the scheduled job hasn't run yet.
      // List<Account> accounts1 = [Select Primary_Contact__c From Account Where Primary_Contact__c = :accContactRole.ContactId];
      //System.assertEquals(accounts1.size(),0);
      Test.stopTest();

      // Now that the scheduled job has executed after Test.stopTest(),
      //   fetch the new merchandise that got added.
      //List<Account> accounts2 = [Select Primary_Contact__c From Account Where Primary_Contact__c = :accContactRole.ContactId];
      //System.assertEquals(accounts2.size(), 1);

   }
}