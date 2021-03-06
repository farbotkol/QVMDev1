@isTest
public class AccountQBOHelperTest 
{
    /*
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
    }   */
    
    // Trader
    @isTest static void validateGetAccountQBOUrlTrader() 
    {
		Account traderAccobj = new Account();
        traderAccobj = TestDataFactory.createAccountTrader();
        insert traderAccobj;
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        //Test.setMock(HttpCalloutMock.class, new TraderMock());
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
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        //Test.setMock(HttpCalloutMock.class, new MockSupplier());
        String sString =  AccountQBOHelper.GetAccountQBOUrl(supplierAccobj.id);
        system.assertNotEquals(sString, null);
         
    }
    
    // Supplier
    @isTest static void validateGetPOQBOUrl() 
    {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1,'SL');
        TestDataFactory.createOrder('SL');
        Order order =  [Select Id,QuickBooksId__c from Order LIMIT 1];
        order.QuickBooksId__c = '234';
        update order;
        TestDataFactory.CreateOAuthServiceEntries();
        String sString =  AccountQBOHelper.GetPOQBOUrl(order.Id);
        //system.assert(sString == 'hello/app/purchaseorder?txnId=234');
        system.assertNotEquals(sString, null);
    }
    
    // Supplier
    @isTest static void validateGetPaymentQBOUrl() 
    {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1,'SL');
        Payment__c payment = TestDataFactory.createPayment(accounts.get(0).Id);
        system.debug('validateGetPaymentQBOUrl: ' + payment);
        String sString =  AccountQBOHelper.GetPaymentQBOUrl(payment.Id);
        system.debug('validateGetPaymentQBOUrl: ' + sString);
        system.assertNotEquals(sString, null);
    }
    
    @isTest static void validateGetInvoiceQBOUrl()
    {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.createAccountsWithOpps(1, 1, 'SL');
        Order ordObj = TestDataFactory.createOrder();
        String s = AccountQBOHelper.GetInvoiceQBOUrl(ordObj.id);
        system.debug('ONE: ' + s);
        system.assertNotEquals(s, null);
    }
    
    @isTest static void validateGetInvoiceQBOUrlNullScenario()
    {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.createAccountsWithOpps(1, 1, 'SL');
        Order ordObj = TestDataFactory.createOrderQuickBookIdNull();
        String s = AccountQBOHelper.GetInvoiceQBOUrl(ordObj.id);
        system.debug('TWO: ' + s);
        system.assertEquals(s, null);
    }
    
    @isTest static void validateFinish()
    {
        AccountsQBOUpsertBatch newbatchObj = new AccountsQBOUpsertBatch();
        newbatchObj.finish(null);
    }
   
}