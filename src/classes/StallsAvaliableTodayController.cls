public with sharing class StallsAvaliableTodayController {

	 public String laneID{get;set;}
    
	 public List<Stall__c> getStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                order by Name 
                LIMIT 1000];

    }
    /*
    public List<Stall__c> getSelectStallsAvaliableToday() {
        
        laneID = Apexpages.currentPage().getParameters().get('laneID');
        System.debug(laneID);
		

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = :laneID
                order by Name 
                LIMIT 1000];

    }
*/
    
    public List<Stall__c> getAStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'A'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getBStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'B'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getCStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'C'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getDStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'D'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getEStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'E'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getHStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'H'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getIStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'I'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getJStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'J'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getKStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'K'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getLStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'L'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getRKStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'RK'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getRLStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'RL'
                order by Name 
                LIMIT 1000];

    }
    
    public List<Stall__c> getOtherStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and (ShedId__c <> 'A' AND ShedId__c <> 'B' AND ShedId__c <> 'C' AND ShedId__c <> 'D' AND ShedId__c <> 'E' AND ShedId__c <> 'J' AND ShedId__c <> 'K' AND ShedId__c <> 'L' AND ShedId__c <> 'RK' AND ShedId__c <> 'RL' AND ShedId__c <> 'H' AND ShedId__c <> 'I')
                order by Name 
                LIMIT 1000];

    }
    


}