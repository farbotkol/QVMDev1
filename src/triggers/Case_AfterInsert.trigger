trigger Case_AfterInsert on Case (After insert) {
    
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
        
        
     //Set the remedy and rule descriptions on the Case object   
    for(Case obj: Trigger.new)
    {
        Case newCase = new case(Id = obj.id);//Create instance and set dml options to that instance
        newCase.setOptions(dmlOpts);
        
        casesToUpdate.add(newCase);
    }
    
    update casesToUpdate;
}