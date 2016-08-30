global class InvoiceBuilderBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts  {
	
	List<Order> orders;
	Id batchJob;
	
	global InvoiceBuilderBatch(List<Order> ordersToProcess, Id batchJobId) {
		orders = ordersToProcess;
		batchJob = batchJobId;
	}
	
	global List<Order> start(Database.BatchableContext BC) {
		return orders;

	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		InvoiceBuilder.GenerateInvoiceFromOrders(scope, batchJob);
	}
	
	global void finish(Database.BatchableContext BC) {
        
        
		
	}
}