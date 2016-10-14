@isTest(SeeAllData=true)
public class AccountQBOHelperTest 
{
      private class TraderMock implements HttpCalloutMock
      { 
        public HTTPResponse respond(HTTPRequest req) 
        {            
            system.debug('hi there');
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
    
    private class MockSupplier implements HttpCalloutMock 
    {
        public HTTPResponse respond(HTTPRequest req) {
            
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
    // Trader
    @isTest static void validateGetAccountQBOUrlTrader() 
    {
		Account traderAccobj = new Account();
        traderAccobj = TestDataFactory.createAccountTrader();
        insert traderAccobj;
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new TraderMock());
        String tstring = AccountQBOHelper.GetAccountQBOUrl(traderAccobj.id); 
        system.assertNotEquals(tstring, null);
    }
    // Supplier
    @isTest static void validateGetAccountQBOUrlSupplier() 
    {
        QBOCustomerResponse newObj = new QBOCustomerResponse();
		Account supplierAccobj = new Account();
        supplierAccobj = TestDataFactory.createAccountSupplier();
        insert supplierAccobj;
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new MockSupplier());
        String sString =  AccountQBOHelper.GetAccountQBOUrl(supplierAccobj.id);
        system.assertNotEquals(sString, null);
         
    }
    @isTest static void validateGetInvoiceQBOUrl()
    {
        Order ordObj = TestDataFactory.createOrder();
        String s = AccountQBOHelper.GetInvoiceQBOUrl(ordObj.id);
        system.assertNotEquals(s, null);
    }
    @isTest static void validateGetInvoiceQBOUrlNullScenario()
    {
        Order ordObj = TestDataFactory.createOrderQuickBookIdNull();
        String s = AccountQBOHelper.GetInvoiceQBOUrl(ordObj.id);
        system.assertEquals(s, null);
    }
    @isTest static void validateFinish()
    {
        AccountsQBOUpsertBatch newbatchObj = new AccountsQBOUpsertBatch();
        newbatchObj.finish(null);
    }
   
}