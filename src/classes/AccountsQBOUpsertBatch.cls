global class AccountsQBOUpsertBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts {
	
	List<Account> customers;
    
    global AccountsQBOUpsertBatch()
    {
        
    }

	
	global AccountsQBOUpsertBatch(List<Account> items) {
		customers = items;
	}



	global List<Account> start(Database.BatchableContext BC) {
		return customers;

	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
   		
        AccountQBOHelper.AccountQBOUpsert(scope);
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}