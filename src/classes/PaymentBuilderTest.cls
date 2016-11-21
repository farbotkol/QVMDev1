@isTest 
public class PaymentBuilderTest {

    @isTest 
    static void TestProcessTransactions() 
    {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account;
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        Account a = new Account(Name='TestAccount');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        insert a;
        
        // Create Opportunity
        Opportunity oppObj = new Opportunity();
        OppObj.Name = 'Test Opportunity';
        OppObj.Business_Status__c = 'Open';
        OppObj.AccountId = a.id;
        OppObj.CloseDate = date.parse('22/10/2016');
        oppObj.Uplift_Factor__c = 1.0;
        oppObj.Permitted_Use__c	= 'Hardware';
        oppObj.Payment_Type__c = 'EFT';
        oppObj.StageName = 'Closed Won';
        insert oppObj;
        /*
        Order orderObj = new Order();
        orderObj.AccountId  = a.id;
        orderObj.OpportunityId =oppObj.id; 
        orderObj.EffectiveDate = date.parse('22/09/2016');
        orderObj.QuickBooksId__c = '208';
        orderObj.Status = 'Draft';
        orderObj.Balance_Due__c = 0.00;
        orderObj.Total_With_GST__c = 0.00;
        orderObj.PriceBook2Id = '123';
        insert orderObj;
        */
        Order order = TestDataFactory.createOrder('SL');
        order.QuickBooksId__c = '208';
        //orderObj.QuickBooksId__c = '100';
        update order;
  
        
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
        system.debug('TestMikel: '+ trans.size());
        system.assert(trans.size()>0);


    }
    
    @isTest
    static void TestGeneratePayments() {
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.CreateQvm_ABA_File_Generator();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());

        /*Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        Account a = new Account(Name='TestAccount');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        insert a;*/
                
        TestDataFactory.createContact('accountName', 'firstName', 'lastName', 'emailAddress@gma.com');
        Account a =  [SELECT Id, RecordTypeId, QuickBooks_Id__c, Def_Payment_Type__c FROM Account LIMIT 1];
        
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        UPDATE a;
        
		Opportunity opp = TestDataFactory.createOpportunity(a.Id);
        
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
        transInv.Account_Business__c = opp.Id;
        transInv.Customer_Reference__c = '3';
        transInv.DocNumber__c = '123';
        transInv.TotalAmount__c = 1000;
        transInv.Invoice_QuickBookId__c = '2';
        transInv.Balance__c = 1000;
        transInv.Type__c = 'Invoice';
        transInv.Batch_Jobs__c = job.Id; 
        insert transInv;
        
        Transaction__c transInv2 = new Transaction__c();
        transInv2.Account__c = a.Id;
        transInv2.Account_Business__c = opp.Id;
        transInv2.Customer_Reference__c = '3';
        transInv2.TotalAmount__c = 600;
        transInv2.DocNumber__c = '124';
        transInv2.Invoice_QuickBookId__c = '4';
        transInv2.Balance__c = 600;
        transInv2.Type__c = 'Invoice';
        transInv2.Batch_Jobs__c = job.Id;
        insert transInv2;     
        
        Transaction__c transCN = new Transaction__c();
        transCN.Account__c = a.Id;
        transCN.Account_Business__c = opp.Id;
        transCN.Customer_Reference__c = '3';
        transCN.TotalAmount__c = 200;
        transCN.DocNumber__c = '124cn';
        transCN.Invoice_QuickBookId__c = '5';
        transCN.Balance__c = 200;
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

        /*Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        Account a = new Account(Name='TestAccount');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        insert a;*/
        
        TestDataFactory.createContact('accountName', 'firstName', 'lastName', 'emailAddress@gma.com');
        Account a =  [SELECT Id, RecordTypeId, QuickBooks_Id__c, Def_Payment_Type__c FROM Account LIMIT 1];
        
        a.QuickBooks_Id__c = '3';
        a.Def_Payment_Type__c = 'EFT';
        UPDATE a;
        
		Opportunity opp = TestDataFactory.createOpportunity(a.Id);
        
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
        transInv.Account_Business__c = opp.Id;
        transInv.Customer_Reference__c = '3';
        transInv.DocNumber__c = '123';
        transInv.TotalAmount__c = 1000;
        transInv.Invoice_QuickBookId__c = '2';
        transInv.Balance__c = 1000;
        transInv.Type__c = 'Invoice';
        transInv.Batch_Jobs__c = job.Id; 
        insert transInv;
        
        Transaction__c transInv2 = new Transaction__c();
        transInv2.Account__c = a.Id;
        transInv2.Account_Business__c = opp.Id;
        transInv2.Customer_Reference__c = '3';
        transInv2.TotalAmount__c = 600;
        transInv2.DocNumber__c = '124';
        transInv2.Invoice_QuickBookId__c = '4';
        transInv2.Balance__c = 600;
        transInv2.Type__c = 'Invoice';
        transInv2.Batch_Jobs__c = job.Id;
        insert transInv2;     
        
        Transaction__c transCN = new Transaction__c();
        transCN.Account__c = a.Id;
        transCN.Account_Business__c = opp.Id;
        transCN.Customer_Reference__c = '3';
        transCN.TotalAmount__c = 200;
        transCN.DocNumber__c = '124cn';
        transCN.Invoice_QuickBookId__c = '5';
        transCN.Balance__c = 200;
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
        
        //List<Opportunity> opp = [select id from Opportunity];
        
        
        //system.assert(opp.size()>0);
        system.assert(pmt.size()>0);

    }
    @isTest 
    public static void ExceptionScenario()
    {
        
    }
}