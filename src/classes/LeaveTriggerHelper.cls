public without sharing class LeaveTriggerHelper 
{
	
 
	public static void UpdateLeaveTakenThisYear(List<Leave__c> leave, Boolean isDelete)
	{
		try 
		{
			Set<Id> oppset = new Set<Id>();
			Set<date> dateset = new Set<date>();
			List<Opportunity> oppsToUpdate = new List<Opportunity>();
			List<OrderItem> orderItemsToUpdate = new List<orderItem>();
			Map<string , Leave__c> leaveMap = new Map<string , Leave__c>();

			for (Leave__c item : leave)
			{
				If (item.In_Valid__c == false)
				{
					oppset.add(item.Account_Business__c);
					dateset.add(item.Leave_Date__c );
					leaveMap.put(item.Account_Business__c + item.Leave_Date__c.format(), item);
				}
				
			}

			System.debug('Getting orderItems');
			// need to set that the order line items for the opp and date are flagged as on leave so the casuals can reuse the allocated stalls
	 		List<OrderItem> orderItems = [SELECT id , date__c, Order.OpportunityId, Leave__c FROM OrderItem WHERE   Order.OpportunityId in :oppset and date__c in :dateset];
	 	
	 		for (OrderItem orderItem : orderItems)
	 		{
	 			Leave__c leaveItem  = leaveMap.get(orderItem.Order.OpportunityId + orderItem.date__c.format());
	 			if (leaveItem != null)
	 			{
	 				orderItem.Leave__c = !isDelete;
	 				orderItemsToUpdate.add(orderItem);
	 			}

	 		}
	 		
			Update orderItemsToUpdate;

			
			// now update the opp fields for each day
			List<Opportunity> opps = [select Id, Name ,Leave_Taken_Friday__c,Leave_Taken_Monday__c
						,Leave_Taken_Saturday__c,Leave_Taken_Sunday__c
						,Leave_Taken_Thursday__c,Leave_Taken_Tuesday__c,Leave_Taken_Wednesday__c   
						from opportunity
						where  Id in  :oppset];
			Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();

			//reset values  back to  zero before updating with new amounts 
			for (Opportunity opp : opps)
			{
				opp.Leave_Taken_Sunday__c = 0;
				opp.Leave_Taken_Monday__c = 0;
				opp.Leave_Taken_Tuesday__c = 0;
				opp.Leave_Taken_Wednesday__c = 0;
				opp.Leave_Taken_Thursday__c = 0;
				opp.Leave_Taken_Friday__c = 0;
				opp.Leave_Taken_Saturday__c = 0;

				oppMap.put(opp.Id, opp);
			}

			
			


			AggregateResult[] groupedResults = [select Account_Business__c, count(id)cnt
							, DAY_IN_WEEK(Leave_Date__c )day 
							from Leave__c 
							where Leave_Date__c = THIS_YEAR and Over_65_and_36_Degree_Day__c = false and in_valid__c = false 
                                                and Account_Business__c in  :oppset 
							group by Account_Business__c, DAY_IN_WEEK(Leave_Date__c )];
			for (AggregateResult ar : groupedResults)  
			{
				Opportunity currOpp =  oppMap.get((Id)ar.get('Account_Business__c'));

				if (ar.get('day') == 1)
				{
						currOpp.Leave_Taken_Sunday__c = (Integer)ar.get('cnt');
				}
				else if (ar.get('day') == 2)
				{
						currOpp.Leave_Taken_Monday__c = (Integer)ar.get('cnt');
				}
				else if (ar.get('day') == 3)
				{
						currOpp.Leave_Taken_Tuesday__c = (Integer)ar.get('cnt');
				}
				else if (ar.get('day') == 4)
				{
						currOpp.Leave_Taken_Wednesday__c = (Integer)ar.get('cnt');
				}
				else if (ar.get('day') == 5)
				{
						currOpp.Leave_Taken_Thursday__c = (Integer)ar.get('cnt');
				}
			    else if (ar.get('day') == 6)
				{
						currOpp.Leave_Taken_Friday__c = (Integer)ar.get('cnt');
				}
			    else if (ar.get('day') == 7)
				{
						currOpp.Leave_Taken_Saturday__c = (Integer)ar.get('cnt');
				}
			   
			   
	        	oppMap.put(currOpp.Id,currOpp);

			}
			System.debug('oppMap.values():' + oppMap.values());	
			update oppMap.values();
		}
		catch(DMLException  ex)
		{
			System.debug(ex);
			  //throw new LeaveException('Hello');


			leave[0].addError(ex.getMessage());
		}
	}

	//public class LeaveException extends Exception{}
}