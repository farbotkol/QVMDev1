public with sharing class StallsAvaliableTodayController {


	 public List<Stall__c> getStallsAvaliableToday() {

        return [SELECT Name FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                LIMIT 1000];

    }

}