@isTest
public class LeaveCreditNoteBuilderTest {
    /*
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            
            system.debug('hi there');
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            
            String json = '';
            if (req.getEndpoint().contains('customer')){
                json = '{'+
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
            }
            else if(req.getEndpoint().contains('query'))
            {
                json = '{'+
                    '  \"QueryResponse\": {'+
                    '    \"Item\": ['+
                    '      {'+
                    '        \"SalesTaxCodeRef\": {'+
                    '          \"value\": \"10\",'+
                    '          \"name\": \"SalesTaxCodeRef\"'+
                    '        },'+
                    '        \"sparse\": true,'+
                    '        \"Id\": \"20\"'+
                    '      },'+
                    '      {'+
                    '        \"SalesTaxCodeRef\": {'+
                    '          \"value\": \"10\",'+
                    '          \"name\": \"SalesTaxCodeRef\"'+
                    '        },'+
                    '        \"sparse\": true,'+
                    '        \"Id\": \"1\"'+
                    '      }'+
                    '    ],'+
                    '    \"startPosition\": 1,'+
                    '    \"maxResults\": 2'+
                    '  }' + 
                    '}';
                
            }
            
            res.setBody(json);
            
            return res;
        }
    }*/
    
    @isTest static void TestGenerateLeaveCreditNotes(){
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        
        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);
        
        Batch_Jobs__c job = TestDataFactory.createSLBatchJobLCN();
        Test.startTest();
        boolean result = LeaveCreditNoteBuilder.GenerateLeaveCreditNotes(job.Id);
        System.assert(result);
        Test.stopTest();
    }
    
    @isTest static void TestGenerateLeaveCreditNotesWithLeave(){
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        
        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);
        
        Batch_Jobs__c job = TestDataFactory.createSLBatchJobLCN();
        List<OrderItem> oi = TestDataFactory.createOrderItemWithLeave(1,'SL');
        Test.startTest();
        Map<string, QBOProductList.Item >  productMap = new Map<string, QBOProductList.Item  >();
        boolean resultSuccess = LeaveCreditNoteBuilder.GenerateLeaveCreditNotes(null);
        System.assert(resultSuccess);
        Test.stopTest();
        
        
    }
   
    
}