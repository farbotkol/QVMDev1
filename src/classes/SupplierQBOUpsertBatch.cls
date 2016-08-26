global class SupplierQBOUpsertBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts {
	List<Account> supplier;

	
	global SupplierQBOUpsertBatch(List<Account> items) {
		supplier = items;
	}



	global List<Account> start(Database.BatchableContext BC) {
		return supplier;

	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
   		
        AccountQBOHelper.SupplierQBOUpsert(scope);
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}