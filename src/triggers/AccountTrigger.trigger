trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {




		List<Account> accountToUpsertToQBO = new List<Account>();
		system.debug('rigger.new:' + trigger.new);
		for (Account so : Trigger.new) {
		if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter) 
		{
			system.debug('so:' + so);
			accountToUpsertToQBO.add(so);

		}

		
	}
     if(accountToUpsertToQBO.size()>0)
     {
         system.debug('accountToInsertToQBO:' + accountToUpsertToQBO);
         if (accountToUpsertToQBO.size() == 1)
         {
             AccountQBOHelper.AccountQBOUpsert(accountToUpsertToQBO);
         }
         else
         {
             AccountsQBOUpsertBatch batch = new AccountsQBOUpsertBatch(accountToUpsertToQBO); 
             database.executebatch(batch,10);    
         }
        
     }

}