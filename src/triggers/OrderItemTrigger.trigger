trigger OrderItemTrigger on OrderItem (before insert, before update) {
     system.debug('WHERE IN : ');
     if((trigger.isInsert || trigger.isUpdate  )&& trigger.isBefore) 
     {

         List<Id> priceBookEntryIds = new  List<Id>();
         List<Id> stallIds = new  List<Id>();
         List<Id> orderIds = new  List<Id>();
         for (OrderItem orderItem : trigger.new)
         {
             priceBookEntryIds.add(orderItem.PricebookEntryId);
             stallIds.add(orderItem.Stall__c);
             orderIds.add(orderItem.OrderId);
         }
         
         Map<ID, PricebookEntry> PricebookEntryMap = new Map<ID, PricebookEntry>([SELECT Id, Default_QBO_Class__c, Product2.ProductCode 
                                                                                  ,Product2.GST_Inclusive__c 
                                                                                  FROM PricebookEntry where Id in :priceBookEntryIds]);
         Map<ID, Stall__c> stallMap = new Map<ID, Stall__c>([SELECT Id, MondayMultiplier__c, TuesdayMultiplier__c
                                                             ,WednesdayMultiplier__c, ThursdayMultiplier__c, FridayMultiplier__c
                                                             , SaturdayMultiplier__c, SundayMultiplier__c
                                                             FROM Stall__c where Id in :stallIds]);
         
         
         Map<ID, Order> orderMap = new Map<ID, Order>([SELECT Id, Opportunity.Uplift_Factor__c, Account.RecordType.DeveloperName
                                                             FROM Order where Id in :orderIds]);
         
         for (OrderItem orderItem : trigger.new)
         {
             //This code has been added to remove the process builder 'Update Order Line Total' as the 
             // process builder is causing soql limits to be hit
             // 
             double uplift = 1;
             if (orderMap.get(orderItem.OrderId).Opportunity.Uplift_Factor__c  != null )   
             {
                 
                uplift = orderMap.get(orderItem.OrderId).Opportunity.Uplift_Factor__c;
             }
             
             double gstMultiplier =  0.9090909;
             if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.GST_Inclusive__c == false )
             {
             	gstMultiplier =  1;  
             } 
                 
                 
             
             System.debug('orderItem.Stall__c - ' + orderItem.Stall__c);
             if (orderItem.Stall__c != null)
             {
                 double Multiplier = 1;
                 system.debug('HI THERE TODAY IS : ' + PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode);
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Monday')
                 {
                 	Multiplier = stallMap.get(orderItem.Stall__c).MondayMultiplier__c;
                 }
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Tuesday')
                 {
                   Multiplier = stallMap.get(orderItem.Stall__c).TuesdayMultiplier__c;
                 }
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Wednesday')
                 {
                   Multiplier = stallMap.get(orderItem.Stall__c).WednesdayMultiplier__c;
                 }
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Thursday')
                 {
                   Multiplier = stallMap.get(orderItem.Stall__c).ThursdayMultiplier__c;
                 }
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Friday')
                 {
                   Multiplier = stallMap.get(orderItem.Stall__c).FridayMultiplier__c;
                 }
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Saturday')
                 {
                   Multiplier = stallMap.get(orderItem.Stall__c).SaturdayMultiplier__c;
                 }
                 if( PricebookEntryMap.get(orderItem.PricebookEntryId).Product2.ProductCode == 'Sunday')
                 {
                   Multiplier = stallMap.get(orderItem.Stall__c).SundayMultiplier__c;
                 }
                 

                 System.debug('Multiplier - ' + Multiplier);
                 System.debug('UnitPrice - ' + orderItem.UnitPrice);
                 System.debug('Quantity - ' + orderItem.Quantity);
                 System.debug('Uplift_Factor__c - ' + uplift);
                 System.debug('gstMultiplier - ' + gstMultiplier);
                 
                 orderItem.Total__c = orderItem.UnitPrice * orderItem.Quantity * Multiplier * uplift * gstMultiplier;
                 //[OrderItem].UnitPrice  * [OrderItem].Quantity * 
                     //CASE( [OrderItem].PricebookEntry.Product2.ProductCode , 'Monday', BLANKVALUE([OrderItem].Stall__r.MondayMultiplier__c,1), 'Tuesday', BLANKVALUE([OrderItem].Stall__r.TuesdayMultiplier__c,1) , 'Wednesday', BLANKVALUE([OrderItem].Stall__r.WednesdayMultiplier__c,1) , 'Thursday', BLANKVALUE([OrderItem].Stall__r.ThursdayMultiplier__c,1), 'Friday', BLANKVALUE([OrderItem].Stall__r.FridayMultiplier__c,1), 'Saturday', BLANKVALUE([OrderItem].Stall__r.SaturdayMultiplier__c,1), 'Sunday', BLANKVALUE([OrderItem].Stall__r.SundayMultiplier__c,1),1) *   BLANKVALUE([OrderItem].Order.Opportunity.Uplift_Factor__c, 1) * IF([OrderItem].PricebookEntry.Product2.GST_Inclusive__c , 0.9090909, 1) 
             }
             else if (orderMap.get(orderItem.OrderId).Account.RecordType.DeveloperName == 'Trader' )
             {
                 orderItem.Total__c = orderItem.UnitPrice * gstMultiplier ;
                 //[OrderItem].UnitPrice  * [OrderItem].Quantity  *   BLANKVALUE([OrderItem].Order.Opportunity.Uplift_Factor__c, 1) 
                 //* IF([OrderItem].PricebookEntry.Product2.GST_Inclusive__c , 0.9090909, 1) 
             }
             
             
             //////
             
             System.debug('HERE - ' + PricebookEntryMap.get(orderItem.PricebookEntryId).Default_QBO_Class__c);
             if ( PricebookEntryMap.get(orderItem.PricebookEntryId).Default_QBO_Class__c != null)
             {
             	orderItem.QBO_Class__c = PricebookEntryMap.get(orderItem.PricebookEntryId).Default_QBO_Class__c;
             }
         }
         
     }
    

}