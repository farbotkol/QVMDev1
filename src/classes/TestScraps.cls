@isTest
public class TestScraps {

    @isTest 
    static void Test_ErrorLogHelper_LogAccountError(){
    	
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());

        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        Account a = new Account(Name='TestAccount');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        insert a;
        
        String json = '{'+
		'	\"Fault\": {'+
		'		\"Error\": [{'+
		'			\"Message\": \"Request has invalid or unsupported property\",'+
		'			\"Detail\": \"Property Name:Unrecognized token \'gdhjfghj\': was expecting (\'true\', \'false\' or \'null\')\\n  specified is unsupported or invalid\",'+
		'			\"code\": \"2010\"'+
		'		}],'+
		'		\"type\": \"ValidationFault\"'+
		'	},'+
		'	\"time\": \"2016-08-25T17:02:42.843-07:00\"'+
		'}';
		QBOError r = QBOError.parse(json);
        
        test.startTest();
       
        List<Error_Log__c> logs = ErrorLogHelper.LogAccountError(a,r );
        
        test.stopTest();
        
        System.assert(logs.size() > 0);
    }
    
     @isTest 
    static void Test_ErrorLogHelper_LogOrderError(){
    	
            	TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        Order order = TestDataFactory.createPO();
        
        order.PO_Approved__c = true;
        update order;
        
        String json = '{'+
		'	\"Fault\": {'+
		'		\"Error\": [{'+
		'			\"Message\": \"Request has invalid or unsupported property\",'+
		'			\"Detail\": \"Property Name:Unrecognized token \'gdhjfghj\': was expecting (\'true\', \'false\' or \'null\')\\n  specified is unsupported or invalid\",'+
		'			\"code\": \"2010\"'+
		'		}],'+
		'		\"type\": \"ValidationFault\"'+
		'	},'+
		'	\"time\": \"2016-08-25T17:02:42.843-07:00\"'+
		'}';
		QBOError r = QBOError.parse(json);
        
        test.startTest();
       
        List<Error_Log__c> logs = ErrorLogHelper.LogOrderError(order,r );
        
        test.stopTest();
        
        System.assert(logs.size() > 0);
    }
    
    @isTest 
    static void Test_ErrorLogHelper_LogOrderItemError(){
    	
         TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        Order order = TestDataFactory.createPO();
        
        order.PO_Approved__c = true;
        update order;
        
        OrderItem item = [SELECT id from OrderItem Limit 1];
        
        String json = '{'+
		'	\"Fault\": {'+
		'		\"Error\": [{'+
		'			\"Message\": \"Request has invalid or unsupported property\",'+
		'			\"Detail\": \"Property Name:Unrecognized token \'gdhjfghj\': was expecting (\'true\', \'false\' or \'null\')\\n  specified is unsupported or invalid\",'+
		'			\"code\": \"2010\"'+
		'		}],'+
		'		\"type\": \"ValidationFault\"'+
		'	},'+
		'	\"time\": \"2016-08-25T17:02:42.843-07:00\"'+
		'}';
		QBOError r = QBOError.parse(json);
        
        test.startTest();
       
        List<Error_Log__c> logs = ErrorLogHelper.LogOrderItemError(item,r );
        
        test.stopTest();
        
        System.assert(logs.size() > 0);
    }
    
    // Are the contructors really needed? if the othere tests are not calling
    @isTest 
    static void Test_Constructors(){
        
        QBOInvoiceResponse qir = new QBOInvoiceResponse();
    }
    
    
}