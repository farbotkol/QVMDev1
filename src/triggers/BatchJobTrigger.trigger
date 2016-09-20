trigger BatchJobTrigger on Batch_Jobs__c (after update) {

  /* List<Id> Ids = new List<Id>();
    for (Batch_Jobs__c job: trigger.new)
    {
        Ids.add(job.Id);
    }
    
    List<Batch_Jobs__c> jobs = [SELECT ID, recordType.Name FROM Batch_Jobs__c WHERE Id in :Ids];
    
    for (Batch_Jobs__c job: jobs)
    {
    	system.debug('job recordtype = ' + job.recordType.Name);
        if(job.recordType.Name == 'Finding Transactions')
        {
            PaymentBuilder.processTransactions(job.Id);
        }
    }*/
}