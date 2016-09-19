@isTest 
public class PaymentBuilderTest {

	@isTest 
    static void TestProcessTransactions() {
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
        
        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();
        
        job.Due_Before__c = Date.today();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Payments').getRecordTypeId();
        job.RecordTypeId = rtId;
        Update job;
        
        PaymentBuilder.UpdateBatchObject(job.Id);
        
        test.startTest();
        
		PaymentBuilder.processTransactions(job.Id);
        
        test.stopTest();
        
        List<Transaction__c> trans = [select id from Transaction__c];
        
        system.assert(trans.size()>0);


    }
    
    @isTest 
    static void TestGeneratePayments() {
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
        
        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();
        
        job.Due_Before__c = Date.today();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Payments').getRecordTypeId();
        job.RecordTypeId = rtId;
        Update job;
        
        PaymentBuilder.changeRecordTypegeneratePayments(job.Id);
        
        Transaction__c transInv = new Transaction__c();
        transInv.Account__c = a.Id;
        transInv.Customer_Reference__c = '3';
        transInv.DocNumber__c = '123';
        transInv.TotalAmount__c = 1000;
        transInv.Invoice_QuickBookId__c = '2';
        transInv.Type__c = 'Invoice';
        transInv.Batch_Jobs__c = job.Id; 
        insert transInv;
        
        Transaction__c transInv2 = new Transaction__c();
        transInv2.Account__c = a.Id;
        transInv2.Customer_Reference__c = '3';
        transInv2.TotalAmount__c = 600;
        transInv2.DocNumber__c = '124';
        transInv2.Invoice_QuickBookId__c = '4';
        transInv2.Type__c = 'Invoice';
        transInv2.Batch_Jobs__c = job.Id;
        insert transInv2;     
        
        Transaction__c transCN = new Transaction__c();
        transCN.Account__c = a.Id;
        transCN.Customer_Reference__c = '3';
        transCN.TotalAmount__c = 200;
        transCN.DocNumber__c = '124cn';
        transCN.Invoice_QuickBookId__c = '5';
        transCN.Type__c = 'CreditMemo';
        transCN.Batch_Jobs__c = job.Id;
        insert transCN; 
        
        test.startTest();
        
		PaymentBuilder.generatePayments(job.Id);
        
        test.stopTest();
        
        List<Payment__c> pmt = [select id from Payment__c];
        
        system.assert(pmt.size()>0);


    }
    
    
    
    @isTest 
    static void TestDownloadABAFileController() {
    	TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.CreateQvm_ABA_File_Generator();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());

        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        Account a = new Account(Name='TestAccount');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        insert a;
        
        Batch_Jobs__c job = TestDataFactory.createSLBatchJob();
        
        job.Due_Before__c = Date.today();
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Payments').getRecordTypeId();
        job.RecordTypeId = rtId;
        Update job;
        
        PaymentBuilder.changeRecordTypegeneratePayments(job.Id);
        
        Transaction__c transInv = new Transaction__c();
        transInv.Account__c = a.Id;
        transInv.Customer_Reference__c = '3';
        transInv.DocNumber__c = '123';
        transInv.TotalAmount__c = 1000;
        transInv.Invoice_QuickBookId__c = '2';
        transInv.Type__c = 'Invoice';
        transInv.Batch_Jobs__c = job.Id; 
        insert transInv;
        
        Transaction__c transInv2 = new Transaction__c();
        transInv2.Account__c = a.Id;
        transInv2.Customer_Reference__c = '3';
        transInv2.TotalAmount__c = 600;
        transInv2.DocNumber__c = '124';
        transInv2.Invoice_QuickBookId__c = '4';
        transInv2.Type__c = 'Invoice';
        transInv2.Batch_Jobs__c = job.Id;
        insert transInv2;     
        
        Transaction__c transCN = new Transaction__c();
        transCN.Account__c = a.Id;
        transCN.Customer_Reference__c = '3';
        transCN.TotalAmount__c = 200;
        transCN.DocNumber__c = '124cn';
        transCN.Invoice_QuickBookId__c = '5';
        transCN.Type__c = 'CreditMemo';
        transCN.Batch_Jobs__c = job.Id;
        insert transCN; 
        
        test.startTest();
        
		PaymentBuilder.generatePayments(job.Id);
        
        test.stopTest();
        
        
        List<Payment__c> pmt = [select id from Payment__c];
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(job); 
        DownloadABAFileController pg = new DownloadABAFileController(sc);
        pg.fetch();
        system.assert(pmt.size()>0);


    }
}