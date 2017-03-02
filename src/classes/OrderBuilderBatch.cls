global class OrderBuilderBatch implements Database.Batchable<sObject> {
	
	List<OrderItem> orderItems;
	Id batchJob;
	
	global OrderBuilderBatch(List<OrderItem> items, Id batchJobId) {
		orderItems = items;
		batchJob = batchJobId;
	}
	
	global List<OrderItem> start(Database.BatchableContext BC) {
		return orderItems;

	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		insert scope;
	}
	
	global void finish(Database.BatchableContext BC) {
			//UPDATE THE BATCH JOB TO 'Orders_Generated'
	 	Batch_Jobs__c job = [SELECT Batch_Type__c,From_Date__c,Id,Name,Process_Range__c
						,RecordType.DeveloperName,To_Date__c,Week_Month_Of__c 
						FROM Batch_Jobs__c 
						WHERE Id = :batchJob LIMIT 1];

		RecordType nextStepType = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
						WHERE SobjectType = 'Batch_Jobs__c' and DeveloperName = 'Orders_Generated' LIMIT 1] ;

		job.RecordTypeId = nextStepType.Id;

		update job;
	}
	
}