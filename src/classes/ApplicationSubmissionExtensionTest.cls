/*
  **********************************************************************************************
  * @author       : Resmi Ramakrishnan
  * @date         : 23/08/2016
  * @description  : Test class for ApplicationSubmissionExtension class.
  **********************************************************************************************
*/
@isTest( SeeAllData = false )
private class ApplicationSubmissionExtensionTest
{
    static testMethod void testAsSystemAdmin()
    {
        Lead leadObj = new Lead();
        try
        {
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = DataFactoryForTestClass.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = DataFactoryForTestClass.createLeadForApplicationSubmission( );  
                if( leadObj != null )
                {  
                    insert leadObj; 
                }               
                if( leadObj != null )
                {             
                    Test.setCurrentPage(Page.ApplicationSubmission);
                    ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj ));
                    system.debug('TTTTTT1');
                    controller.saveLead();
                    system.debug('TTTTTT2');
                }
                Test.stopTest();
             }
         }
         catch( Exception Ex )
         {
            System.debug('Exception testAsSystemAdmin():' + Ex.getMessage());
         }
    }
    
}