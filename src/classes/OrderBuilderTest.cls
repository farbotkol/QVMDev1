@isTest
private class OrderBuilderTest {

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            
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
    
    @isTest static void TestGenerateOrdersSL() {
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');

        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new Mock());
        TestDataFactory.createStallProductsAndGeneralPriceBook();

        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);

        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Orders/Invoices').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);

        Test.startTest();
     
        boolean result = OrderBuilder.GenerateOrders(job.Id );
    
        Test.stopTest();
        
            

        //System.assert(opp3.Leave_Taken_This_Year__c == 0);

    }

    
    @isTest static void TestGenerateOrdersLH() {
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'LH');

        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();

        Opportunity opp = [select id, name, Stall__c  from Opportunity limit 1];
        TestDataFactory.createPermStallWithOpp(opp);

        Batch_Jobs__c job = TestDataFactory.createLHBatchJob();

        Test.startTest();
     
        boolean result = OrderBuilder.GenerateOrders(job.Id );
    
        Test.stopTest();
    
        //System.assert(opp3.Leave_Taken_This_Year__c == 0);

    }
    
    @isTest static void TestGenerateOrdersFees() {
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'LH');

        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();

        Opportunity opp = [select id, name, Stall__c  from Opportunity limit 1];
        TestDataFactory.createPermStallWithOpp(opp);

        Batch_Jobs__c job = TestDataFactory.createMCCBatchJob();
        TestDataFactory.CreateQVM_LH_FEE_SETTING_Entries();

        Test.startTest();
     
        boolean result = OrderBuilder.GenerateOrders(job.Id );
    
        Test.stopTest();
    
        //System.assert(opp3.Leave_Taken_This_Year__c == 0);

    }
    
}