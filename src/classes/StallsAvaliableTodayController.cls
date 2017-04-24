public with sharing class StallsAvaliableTodayController {

	 public String laneID{get;set;}
     
    
	 public List<Stall__c> getStallsAvaliableToday() {

        return [SELECT Name, IsActive__c, ShedId__c FROM Stall__c WHERE Id NOT IN 
                	(SELECT Stall__c 
                    FROM OrderItem
                    WHERE Date__c = TODAY AND Leave__c = FALSE
                    AND Stall__c  != NULL)  
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                order by Name 
                LIMIT 1000];

    }
    
    public List<String> pairingCalculations(List<Stall__c> stallList) {
        Integer prevStallID=0;	//Incrementing integer to cycle through all stall IDs
        Boolean prevWasJoint = false;
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
            if ((math.mod(prevStallID,2)==1))	//If previous stalls id is ODD
            {
                if (currStallID == prevStallID+1)	//if CURRENT stalls id is equal to PREVIOUS stalls id PLUS ONE (therefore even, and concurrent with the prev)
                {  
                    
                         //REMOVE THE LAST ADDITION TO THE PAIREDSTALLNAMELIST
                         
                        if ((pairedStallNameList.size()>0) && (prevWasJoint == false))
                        {
                            pairedStallNameList.remove(pairedStallNameList.size()-1);
                        }
                   		pairedName = prevStallID+'-'+string.valueOf(currStallID);	//AN AVAILABLE ODD-EVEN PAIRING IS HERE
                    	pairedStallNameList.add(pairedName);
                    	prevWasJoint = true;
                    
                   
                }
                else if (currStallID != prevStallID+1)	//if CURRENT stalls id is NOT EQUAL to PREVIOUS stalls id PLUS ONE
                {													
                    //if (math.mod(currStallID,2)==0)
                    //{
                    	pairedName = string.valueOf(currStallID);	//ADD IT AS A SINGLETON
                 		pairedStallNameList.add(pairedName);
                        prevWasJoint = false;
                    //}
                    
                }
            }
            else if ((math.mod(prevStallID,2)==0))	//If PREVIOUS stalls id is EVEN
            {
                if (currStallID != prevStallID+1)		//if CURRENT stalls id is NOT equal to PREVIOUS stalls id PLUS ONE
                {													
                    pairedName = string.valueOf(currStallID);	
                    pairedStallNameList.add(pairedName);
                    prevWasJoint = false;
                   
                }
                else 	//CURRENT stalls id IS equal to PREVIOUS stalls id PLUS ONE, so it is a joint addition
                {
                    pairedName = string.valueOf(currStallID);
                    pairedStallNameList.add(pairedName);
                    prevWasJoint = false;
                   //prevWasJoint = true;
                }
            }
            
            prevStallID = currStallID;	//Set the PREVIOUS id to the CURRENT id
        }
        
        return pairedStallNameList;
        
    }
	
    
    // NEW METHOD FOR MAKING A LIST OF UNPAIRED STALLS
    public List<String> unpairedList(List<Stall__c> stallList) {
        Integer i=0;
        String pairedName;
        List<String> unpairedStallNameList = new List<String>();	//stores the string pairings of site names
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
                unpairedStallNameList.add(stall.Name);
            }
            
            return unpairedStallNameList;
        }
        
        
		for (Integer currStallID : intStallNameList) {
            
                    unpairedStallNameList.add(string.valueOf(currStallID));
                
        }
        
        return unpairedStallNameList;
    }
    
    
    
    //Use pairingCalculations() method to display paired stalls, use unpairedList() method to display unpaired stalls
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
        //stallList = getCStallsAvaliableToday();

        //return pairingCalculations(stallList);
        
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
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
                and RecordType.DeveloperName = 'Casual'
                and IsActive__c = true
                and isAvailableToday__c = 1
                and (ShedId__c <> 'A' AND ShedId__c <> 'B' AND ShedId__c <> 'C' AND ShedId__c <> 'D' AND ShedId__c <> 'E' AND ShedId__c <> 'J' AND ShedId__c <> 'K' AND ShedId__c <> 'L' AND ShedId__c <> 'RK' AND ShedId__c <> 'RL' AND ShedId__c <> 'H' AND ShedId__c <> 'I')
                order by StallId__c  
                LIMIT 1000];

    }
    


}