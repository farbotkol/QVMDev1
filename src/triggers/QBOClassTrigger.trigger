trigger QBOClassTrigger on QBO_Class__c (After insert, After Update) {
 	
    List<Id> scope = new List<Id>();
    for(QBO_Class__c cls : trigger.new)
    {
        scope.add(cls.Id);
    }
        
    if ( trigger.isInsert && trigger.isAfter && System.IsBatch() == false && System.isFuture() == false)
    {
        
        QBOClassHelper.QBOClassInsertFuture(scope);
    }
    
    if (trigger.isUpdate && trigger.isAfter && System.IsBatch() == false && System.isFuture() == false)
    { 
        QBOClassHelper.QBOClassUpdateFuture(scope);
    }
}