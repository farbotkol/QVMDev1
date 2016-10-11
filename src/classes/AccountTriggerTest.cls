/*
  **********************************************************************************************
  * @author       : Resmi Ramakrishnan
  * @date         : 02/09/2016
  * @description  : Test class for AccountTrigger.  Checking Trader and Supplier accounts.
  **********************************************************************************************
*/
@isTest
public class AccountTriggerTest 
{
    

     @isTest static  void Test_SupplierAccounts() 
     {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.startTest();
        List<Account> accounts = createSupplierAccounts(1);         
        Test.stopTest();
        System.assert(accounts.size() != 0);
     }
    

    
     @isTest static  void Test_TraderAccounts() 
     {
        TestDataFactory.CreateOAuthServiceEntries();
        //Test.setMock(HttpCalloutMock.class, new traderMock());
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.startTest();
        List<Account> accounts = createTraderAccounts(1);         
        Test.stopTest();
        System.assert(accounts.size() != 0);
     }
    
     @isTest static  void Test_TraderAccountsNoQuickBookId() 
     {
        TestDataFactory.CreateOAuthServiceEntries();
        //Test.setMock(HttpCalloutMock.class, new traderMock());
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.startTest();
        List<Account> accounts = createTraderAccountsWithoutQuickbookId(1);         
        Test.stopTest();
        System.assert(accounts.size() != 0);
     }
    
     @isTest static  void Test_SupplierResponse() 
     {
        SupplierResponse  suppObj = new SupplierResponse();
         suppObj.Vendor = null;
     }
 
 ////////**********  Data Creation - Move to datafactory*********/////  
 
    
    
    public static List<Account> createSupplierAccounts( Integer numAccts )
    {
        List<Account> accts = new List<Account>();        
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Supplier').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) 
		{
            Account a = new Account(Name='TestAccount' + i);
            a.RecordTypeId = accRecordTypeId;
            a.QuickBooks_Id__c = '89' ;
            accts.add(a);
        }
        insert accts;        
        return accts;
     } 
     public static List<Account> createTraderAccounts( Integer numAccts )
     {
        List<Account> accts = new List<Account>();        
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) 
		{
            Account a = new Account(Name='TestAccount' + i);
            a.RecordTypeId = accRecordTypeId;
            a.QuickBooks_Id__c = '3' ;
            accts.add(a);
        }
        insert accts;        
        return accts;
     }
     public static List<Account> createTraderAccountsWithoutQuickbookId( Integer numAccts )
     {
        List<Account> accts = new List<Account>();        
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) 
		{
            Account a = new Account(Name='TestAccount' + i);
            a.RecordTypeId = accRecordTypeId;
            //a.QuickBooks_Id__c = 'Q' + i ;
            accts.add(a);
        }
        insert accts;        
        return accts;
     }
      
}