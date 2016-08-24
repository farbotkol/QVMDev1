/*
*******************************************************************************************
*******************************************************************************************

	@Date  :26/07/2016
	@Description: This test class has written for testing assignment rules in Case object.

*******************************************************************************************
*******************************************************************************************
*/

@isTest(seeAllData=true)
private class CaseAfterInsertTest 
{
	public CaseAfterInsertTest()
	{
		
	}

	static testMethod void assignRuletocase()
    {
    	Case caseObj = new Case( Status = 'New', Origin = 'Phone', Type = 'Marketing');
        test.startTest();
        try
        {
        	Database.insert( caseObj );
        	Case caseObj1 = [SELECT OwnerId, Owner.name from Case where id=:caseObj.id] ;
        	System.assertEquals('Marketing Department Queue', caseObj1.Owner.name );

        }
        catch( DMLException e )
        {
           System.debug('Database Exception occured');
        }
        test.stopTest();
    }
}