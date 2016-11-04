trigger BatchJobTrigger on Batch_Jobs__c (after update) {

    List<Id> Ids = new List<Id>();
    Map<Id,Batch_Jobs__c> batchJobsMap = new Map<Id,Batch_Jobs__c>();


    for (Batch_Jobs__c job: trigger.new)
    {
        Ids.add(job.Id);
        batchJobsMap.put(job.Id, job);
    }

    List<Transaction__c> trans = [SELECT ID, Balance__c, Batch_Jobs__c,Outstanding_Balance__c,Type__c FROM Transaction__c WHERE Batch_Jobs__c in :Ids order by Batch_Jobs__c];
    
    if (trans.size() > 0  )
    {
        id currentBatchId = trans[0].Batch_Jobs__c ;
        double receed = 0;
        if(batchJobsMap.get(currentBatchId).Balance_Receeded__c != null){
            receed = batchJobsMap.get(currentBatchId).Balance_Receeded__c;
        double balanceReceeded = receed + batchJobsMap.get(currentBatchId).Credit_Notes__c;
        system.debug('Start Res: ' + balanceReceeded);
        for (Transaction__c tran: trans)
        {
            if (tran.Batch_Jobs__c != currentBatchId)
            {
                currentBatchId = tran.Batch_Jobs__c ;
            }
            double outstanding = 0;
            if(tran.Outstanding_Balance__c != null){
                outstanding = tran.Outstanding_Balance__c;
            }
        system.debug('Start Res: ' + outstanding);
            double result = outstanding - balanceReceeded;
            if(tran.Type__c == 'CreditMemo')continue;
            if(balanceReceeded == 0){
                tran.Balance__c = 0;
            }
            if(result < 0){
                //its all been paid with remainder
                tran.Balance__c = outstanding;
                balanceReceeded = Math.abs(result);
            }else{
                //remainder is smaller than balance so put remainder and set balance to zero for the rest.
                tran.Balance__c = balanceReceeded;
                balanceReceeded = 0;
            }
            //system.debug('Outstanding: ' + tran.Outstanding_Balance__c + ':::' + tran.Balance__c );
            //
        }
            update trans;
        }
    }
}