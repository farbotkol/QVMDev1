@isTest public class BatchJobTriggerTest {
    @isTest 
    static void TestTransactionsAllPaid() {
       
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.CreateQvm_ABA_File_Generator();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Transaction__c> trans = TestDataFactory.createTransactions();
        //1000,600,200
        
        Batch_Jobs__c batchJob = [SELECT Id,Balance_Receeded__c,Payment_Amount__c,Outstanding_Balance__c 
                                  FROM Batch_Jobs__c 
                                  WHERE Id = :trans.get(0).Batch_Jobs__c LIMIT 1];
        
        system.debug('BBB ' + batchJob);
        
        system.assert(batchJob.Payment_Amount__c == 1400);
        
        for(Transaction__c tran: trans){
            system.assert(Math.abs(tran.Outstanding_Balance__c) == Math.abs(tran.Balance__c));
        }
    }
    @isTest 
    static void TestTransactionsPartPaidFullAmountWithCredit() {
       
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.CreateQvm_ABA_File_Generator();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Transaction__c> trans = TestDataFactory.createTransactions();
        //1000,600,200
        
        Batch_Jobs__c batchJob = [SELECT Id,Balance_Receeded__c,Payment_Amount__c,Outstanding_Balance__c 
                                  FROM Batch_Jobs__c 
                                  WHERE Id = :trans.get(0).Batch_Jobs__c LIMIT 1];
        batchJob.Balance_Receeded__c = 800;
        update(batchJob);
        
        system.debug('BBB ' + batchJob);
        
        List<Transaction__c> transactions = [SELECT Id,Balance__c,TotalAmount__c,Outstanding_Balance__c 
                                  FROM Transaction__c 
                                  WHERE Batch_Jobs__c = :trans.get(0).Batch_Jobs__c];
        
        	//first transaction is 1000 - 800 - 200(C)
            system.assert(transactions.get(0).Balance__c == 1000);
            //system.assert(transactions.get(1).Balance__c == 0);
        	//credit transaction doesnt matter
            //system.assert(Math.abs(transactions.get(2).Balance__c) == 200);
    }
    
    @isTest 
    static void TestTransactionsPartPaidPartAmountWithCredit() {
       
        TestDataFactory.CreateOAuthServiceEntries();
        TestDataFactory.CreateQvm_ABA_File_Generator();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        List<Transaction__c> trans = TestDataFactory.createTransactions();
        //1000,600,200
        
        Batch_Jobs__c batchJob = [SELECT Id,Balance_Receeded__c,Payment_Amount__c,Outstanding_Balance__c 
                                  FROM Batch_Jobs__c 
                                  WHERE Id = :trans.get(0).Batch_Jobs__c LIMIT 1];
        batchJob.Balance_Receeded__c = 650;
        update(batchJob);
        
        system.debug('BBB ' + batchJob);
        
        List<Transaction__c> transactions = [SELECT Id,Balance__c,TotalAmount__c,Outstanding_Balance__c 
                                  FROM Transaction__c 
                                  WHERE Batch_Jobs__c = :trans.get(0).Batch_Jobs__c];
        
        	//first transaction is 1000 - 800 - 200(C)
            //system.assert(transactions.get(0).Balance__c == 850);
            //system.assert(transactions.get(1).Balance__c == 0);
        	//credit transaction doesnt matter
            //system.assert(Math.abs(transactions.get(2).Balance__c) == 200);
    }
}