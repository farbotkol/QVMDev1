@isTest
public class InvoiceBuilderTest {

    @isTest static void TestGenerateOrderAndInvoiceSL() {
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');

        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        

        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);

        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Orders/Invoices').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);
        
       
        List<OrderItem> oi = TestDataFactory.createOrderItemWithLeave(1,'SL');
		Test.startTest();
     	
       
       	boolean result = InvoiceBuilder.GenerateInvoiceFromOrder(oi[0].OrderId);
    
        Test.stopTest();
        
        system.assert(result == true);
    }
    
    @isTest static void TestGenerateOrdersAndInvoicesSL() {
        
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');

        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        

        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        TestDataFactory.createSingleStall(opp);

        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Orders/Invoices').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);
        
       
        List<OrderItem> oi = TestDataFactory.createOrderItemWithLeave(1,'SL');
		Test.startTest();
     	
       
       	boolean result = InvoiceBuilder.GenerateInvoices(job.Id);
    
        Test.stopTest();
        
        system.assert(result == true);
    }
        
}