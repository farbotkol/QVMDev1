trigger Case_AfterInsert on Case (After insert, after update) {

    if(AvoidRecursion.isFirstRun())
    {
    
    
    //Fetching the assignment rules on case
    AssignmentRule AR = new AssignmentRule();
    AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true and Name = 'Case Assignment Rule' limit 1];
    
    //Creating the DMLOptions for "Assign using active assignment rules" checkbox
    Database.DMLOptions dmlOpts = new Database.DMLOptions();
    dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
    dmlOpts.EmailHeader.TriggerUserEmail = true;
    //dmlOpts.assignmentRuleHeader.useDefaultRule = true;
    
    //Case newCase = new Case(Status = 'New') ;
    ////Setting the DMLOption on Case instance
    //newCase.setOptions(dmlOpts);
    
    List<Case> casesToUpdate = new List<Case>();
    List<Offense_Rule__c> offenses = [SELECT Description__c, Rules__c FROM Offense_Rule__c];
        
        
    for(Case obj: Trigger.new)
    {
        Case newCase = new case(Id = obj.id);//Create instance and set dml options to that instance
        newCase.setOptions(dmlOpts);
        
        //set case description to looked up order rule object
        
        Offense_Rule__c currentRule = [SELECT Description__c FROM Offense_Rule__c WHERE Offense_Rule__c.Rules__c =: obj.Offense_Rule_Picklist__c];
        newCase.Rule_Description__c = currentRule.Description__c;
        
        Offense_Rule__c currentRemedy = [SELECT Description__c FROM Offense_Rule__c WHERE Offense_Rule__c.Rules__c =: obj.Remedy__c];
        newCase.Remedy_Rule__c = currentRemedy.Description__c;
        
		
        
        
        casesToUpdate.add(newCase);
    }
    
    update casesToUpdate;
    }

}