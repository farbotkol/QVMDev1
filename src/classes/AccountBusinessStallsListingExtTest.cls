@isTest
private class AccountBusinessStallsListingExtTest {
    
/*private class Mock implements HttpCalloutMock {
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
  */  

    @isTest static  void Test_AccountBusinessStallsListingExt() {
		TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        Test.startTest();

        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];

		system.debug(':D:');

        TestDataFactory.createSingleStallWithNoOpp();
		system.debug(':F:');
        TestDataFactory.createPermStallWithNoOpp();

		system.debug(':G:');

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Stall__c; 
        Map<String,Schema.RecordTypeInfo> stallTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = stallTypeInfo.get('Licence').getRecordTypeId();
        
		system.debug(':H:');
        Stall__c stall =  [select id, name  from Stall__c where RecordTypeid = :rtId limit 1];


        Id prtId = stallTypeInfo.get('Lease').getRecordTypeId();
        
        Stall__c permStall =  [select id, name  from Stall__c where RecordTypeid = :prtId limit 1];

		system.debug(':J:');

        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AccountBusinessStallsListingExt controller = new AccountBusinessStallsListingExt(sc);

        controller.ResetUpdater();
        controller.getStallsFromQuery();

        controller.SetOppStall(stall);
        //ontroller.aStall = stall.Id;
        controller.monday = true;
        controller.tuesday = true;
        controller.wednesday = true;
        controller.thursday = true;
        controller.friday = true;
        controller.saturday = true;
        controller.sunday = true;

		system.debug(':K:');
        PageReference pr =  controller.Add();

		system.debug(':L:');
        System.assert(pr == null);

        controller.aStall = stall.Id;
        controller.day = 'monday';
        controller.UpdateStall();
        controller.day = 'tuesday';
        controller.UpdateStall();
        controller.day = 'wednesday';
        controller.UpdateStall();
        controller.day = 'thursday';
        controller.UpdateStall();
        controller.day = 'friday';
        controller.UpdateStall();
        controller.day = 'saturday';
        controller.UpdateStall();
        controller.day = 'sunday';
        controller.UpdateStall();
        controller.aStall = stall.Id;
        controller.day = 'monday';
        controller.UpdateStall();
        controller.day = 'tuesday';
        controller.UpdateStall();
        controller.day = 'wednesday';
        controller.UpdateStall();
        controller.day = 'thursday';
        controller.UpdateStall();
        controller.day = 'friday';
        controller.UpdateStall();
        controller.day = 'saturday';
        controller.UpdateStall();
        controller.day = 'sunday';
        controller.UpdateStall();


		system.debug(':Z:');
        controller.getPermStallsFromQuery();
		system.debug(':X:');
        controller.SetPermOppStall(permStall);
		system.debug(':C:');
        pr =  controller.AddPerm();
        System.assert(pr == null);
		Test.stopTest();
    }
    
}