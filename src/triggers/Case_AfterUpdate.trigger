trigger Case_AfterUpdate on Case (After update) {

    if(AvoidRecursion.isFirstRun())
    {
    
    List<Case> casesToUpdate = new List<Case>();
        
    List<Offense_Rule__c> rules = [SELECT Rules__c, Description__c FROM Offense_Rule__c];
    //List<Offense_Rule__c> remedy = [SELECT Rules__c, Description__c FROM Offense_Rule__c];
        
     //Set the remedy and rule descriptions on the Case object   
    for(Case obj: Trigger.new)
    {
        Case newCase = new case(Id = obj.id);//Create instance and set dml options to that instance
       
        
        //set case description to looked up order rule object
        for (integer i=0; i<rules.size(); i++)
        {
            if (rules[i].Rules__c == obj.Offense_Rule_Picklist__c)
            {
                newCase.Rule_Description__c = rules[i].Description__c;
            }
            
            if (rules[i].Rules__c == obj.Remedy__c)
            {
                newCase.Remedy_Rule__c = rules[i].Description__c;
            }
        }
        
        casesToUpdate.add(newCase);
    }
    
    update casesToUpdate;
    }

}