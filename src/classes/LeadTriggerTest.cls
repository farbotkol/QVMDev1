/*
  **********************************************************************************************
  * @author       : Resmi Ramakrishnan
  * @date         : 23/08/2016
  * @description  : Test class for LeadTrigger.
  **********************************************************************************************
*/
@isTest( SeeAllData = false )
private class LeadTriggerTest
{
    static testMethod void testAsSystemAdmin()
    {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Lead leadObj = new Lead();
        try
        {
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.CreateLead( );  
                     
                
                if( leadObj != null )
                {
                    Database.insert( leadObj );
                }
                
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(leadObj .id);
                lc.setDoNotCreateOpportunity(false);
                lc.setConvertedStatus('Qualified');
                
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                System.assert(lcr.isSuccess());
                
                Opportunity convertedOpp = [SELECT id,Primary_Contact__c  FROM Opportunity  where id=:leadObj.ConvertedOpportunityId LIMIT 1];
                System.assertEquals( convertedOpp.Primary_Contact__c, leadObj.ConvertedContactId);             
                
                
                Account convertedAccount = [SELECT id,Primary_Contact__c FROM Account where id =: leadObj.ConvertedAccountId LIMIT 1];
                System.assertEquals( convertedAccount.Primary_Contact__c , leadObj.ConvertedContactId);   
                
                Test.stopTest();
             }
         }
         catch( Exception Ex )
         {
            System.debug('Exception testAsSystemAdmin():' + Ex.getMessage());
         }
      }    
}