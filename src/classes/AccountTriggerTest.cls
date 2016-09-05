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
    
 // ***************** Supplier  ***************************//
     private class Mock implements HttpCalloutMock 
     {
        public HTTPResponse respond(HTTPRequest req)
        { 
            system.debug('hi there');
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
           
            
           String json = '{'+
                '  \"Vendor\": {'+
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
           res.setBody(json);           
            return res;
        }
    }
    
    
     @isTest static  void Test_SupplierAccounts() 
     {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        List<Account> accounts = createSupplierAccounts(1);         
        Test.stopTest();
        System.assert(accounts.size() != 0);
     }
// ***************** Trader  ***************************//
 private class traderMock implements HttpCalloutMock 
     {
        public HTTPResponse respond(HTTPRequest req)
        { 
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            String json = '{'+
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
           res.setBody(json);           
            return res;
        }
    }
    
     @isTest static  void Test_TraderAccounts() 
     {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new traderMock());
        Test.startTest();
        List<Account> accounts = createTraderAccounts(1);         
        Test.stopTest();
        System.assert(accounts.size() != 0);
     }
      @isTest static  void Test_TraderAccountsNoQuickBookId() 
     {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new traderMock());
        Test.startTest();
        List<Account> accounts = createTraderAccountsWithoutQuickbookId(1);         
        Test.stopTest();
        System.assert(accounts.size() != 0);
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
            a.QuickBooks_Id__c = 'Q' + i ;
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
            a.QuickBooks_Id__c = 'Q' + i ;
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