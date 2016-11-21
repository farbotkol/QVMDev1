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
    
    public List<String> pairingCalculations(List<Stall__c> stallList) {
        Integer i=0;
        String pairedName;
        List<String> pairedStallNameList = new List<String>();	//stores the string pairings of site names
        List<Integer> intStallNameList = new List<Integer>();	//stores the integer siteID values for sorting
        
        try 
        {
            for (Stall__c stall : stallList)
            {
                intStallNameList.add(Integer.valueOf(stall.StallId__c));	//populate integer list of siteIDs
            }
                
            intStallNameList.sort();	//sort the site numbers into order by int siteID value
        }
        catch (exception e)
        {
            //StallID__c cannot safely convert to integer values. Treat them as strings
            stallList.sort();
            for (Stall__c stall : stallList)
            {
                pairedStallNameList.add(stall.Name);
            }
            
            return pairedStallNameList;
        }
        
        
		for (Integer currStallID : intStallNameList) {
            if ((math.mod(i,2)!=0))	//Check the previous stallID was odd and the current stallID is one above the previously recorded one
            {
                if (currStallID == i+1)
                {
                    //A vacant pairing is here
                    pairedName = i+'-'+string.valueOf(currStallID);
                    pairedStallNameList.add(pairedName);
                }
                else {	//If not a vacant pairing, add the previous single one to the list
                    pairedStallNameList.add(string.valueOf(i));
                } 
            }
            i = currStallID;	//Update the previous entry
        }
        
        return pairedStallNameList;
        
        
        /*
        
        for (Stall__c s : stallList) {
            if ((math.mod(i,2)!=0))	//Check the previous stallID was odd and the current stallID is one above the previously recorded one
            {
                if (integer.valueOf(s.StallId__c) == i+1)
                {
                    //A vacant pairing is here
                    pairedName = i+'-'+s.StallId__c;
                    pairedStallNameList.add(pairedName);
                }
                else {	//If not a vacant pairing, add the previous single one to the list
                    pairedStallNameList.add(string.valueOf(i));
                } 
            }
            i = integer.valueOf(s.StallId__c);	//Update the previous entry
        }

		return pairedStallNameList;
        */
        
        
    }
    
    public List<String> getAStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getAStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getBStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getBStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getCStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getCStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getDStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getDStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getEStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getEStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getHStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getHStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getIStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getIStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getJStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getJStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getKStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getKStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getLStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getLStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getRKStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getRKStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getRLStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getRLStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<String> getOtherStallsAvailableTodayPairedNames() {
        List<Stall__c> stallList = new List<Stall__c>();
        stallList = getOtherStallsAvaliableToday();
        
        return pairingCalculations(stallList);
    }
    
    public List<Stall__c> getAStallsAvaliableToday() {
        
        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'A'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getBStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'B'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getCStallsAvaliableToday() {
        
        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'C'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getDStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'D'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getEStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'E'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getHStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'H'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getIStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'I'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getJStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'J'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getKStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'K'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getLStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'L'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getRKStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'RK'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getRLStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and ShedId__c = 'RL'
                order by StallId__c 
                LIMIT 1000];

    }
    
    public List<Stall__c> getOtherStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c, StallId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.Name = 'Casual'
                and IsActive__c = true
                and (ShedId__c <> 'A' AND ShedId__c <> 'B' AND ShedId__c <> 'C' AND ShedId__c <> 'D' AND ShedId__c <> 'E' AND ShedId__c <> 'J' AND ShedId__c <> 'K' AND ShedId__c <> 'L' AND ShedId__c <> 'RK' AND ShedId__c <> 'RL' AND ShedId__c <> 'H' AND ShedId__c <> 'I')
                order by StallId__c  
                LIMIT 1000];

    }
    


}