trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    
	if(System.IsBatch() == false && System.isFuture() == false)
    {
        
       	RecordType traderType =  [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                            WHERE SobjectType = 'Account' and DeveloperName = 'Trader' LIMIT 1];
        
        RecordType SupplierType =  [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                            WHERE SobjectType = 'Account' and DeveloperName = 'Supplier' LIMIT 1];
        
 
       
        List<Account> accountToUpsertToQBO = new List<Account>();//trader
        List<Id> accountToUpsertToQBOIds = new List<Id>();//trader
        List<Account> supplierToUpsertToQBO = new List<Account>();
        List<Id> supplierToUpsertToQBOIds = new List<Id>();
        system.debug('rigger.new:' + trigger.new);
        for (Account so : Trigger.new) {
            if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter) 
            {
                system.debug('so:' + so);
                
                //add to list of Traders to process to customers in QBO
                if (so.RecordTypeId == traderType.Id)
                {
                    accountToUpsertToQBO.add(so);
                    accountToUpsertToQBOIds.add(so.Id);
                }
                //add to list of SUPPLIERS  to process to suppliers in QBO
                if (so.RecordTypeId == SupplierType.Id)
                {
                    supplierToUpsertToQBO.add(so);
                    supplierToUpsertToQBOIds.add(so.Id);
                }
            }
        }
        if(accountToUpsertToQBO.size()>0)
        {
            system.debug('accountToInsertToQBO:' + accountToUpsertToQBO);
            // FUTURES TEND TO OCCURE FASTER THEN BATCHES, THERE IS ONLY A Small number of items use the furture
            if (accountToUpsertToQBO.size() == 1)
            {
                AccountQBOHelper.AccountQBOUpsertFuture(accountToUpsertToQBOIds);
            }
            else
            {
                AccountsQBOUpsertBatch batch = new AccountsQBOUpsertBatch(accountToUpsertToQBO); 
                database.executebatch(batch,30);    
            }
        }
        if(supplierToUpsertToQBO.size()>0)
        {
            system.debug('accountToInsertToQBO:' + supplierToUpsertToQBO);
            // FUTURES TEND TO OCCURE FASTER THEN BATCHES, THERE IS ONLY A Small number of items use the furture
            if (supplierToUpsertToQBO.size() == 1)
            {
                AccountQBOHelper.SupplierQBOUpsertFuture(supplierToUpsertToQBOIds);
            }
            else
            {
                SupplierQBOUpsertBatch batch = new SupplierQBOUpsertBatch(supplierToUpsertToQBO); 
                database.executebatch(batch,30);    
            }
   
        }
    }

}