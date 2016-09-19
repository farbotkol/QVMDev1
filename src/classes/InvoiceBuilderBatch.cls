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
        
        list<Order> orderErrors = [Select id from Order where Status = 'Error' and Batch_Job__c = :batchJob];
		if (orderErrors.size()> 0 )
        {
            InvoiceBuilder.SetOrderRecordType('Error_Processing_Invoices', batchJob);
        }
        else 
        {
            InvoiceBuilder.SetOrderRecordType('Invoices_Generated', batchJob);
        }
	}
}