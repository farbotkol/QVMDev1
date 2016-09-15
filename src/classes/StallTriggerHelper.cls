public class StallTriggerHelper {

    public static List<Stall__c> UpdateStallValues(List<Stall__c> stalls)
    {
        
         List<Stall__c> stallsToReturn = new List<Stall__c>() ; 
        //GET ALL THE PRICES
        //
       
        list<PricebookEntry> prices = [SELECT ProductCode,UnitPrice,  Pricebook2.Name,  Pricebook2Id FROM PricebookEntry where Pricebook2.SLPE__c = true ];
        map<String,PricebookEntry> pricesMap = new map<String,PricebookEntry>();
        for (PricebookEntry price : prices)
        {
            pricesMap.put(price.ProductCode + price.Pricebook2Id , price);
        }
        
        // GET ALL THE TRADER INVOLVED
        SET<Id> traderIds = new SET<Id>();
        for (Stall__c stall : stalls )
        {
           traderIds.add(stall.MondayTrader__c);
           traderIds.add(stall.TuesdayTrader__c);
           traderIds.add(stall.WednesdayTrader__c);
           traderIds.add(stall.ThursdayTrader__c);
           traderIds.add(stall.FridayTrader__c);
           traderIds.add(stall.SaturdayTrader__c);
           traderIds.add(stall.SundayTrader__c);
        }
        List<Opportunity> traders = [SELECT Id, Pricebook2Id,Uplift_Factor__c from Opportunity where Id in :traderIds];
        // asdd traders to map
        Map<Id , Opportunity> traderMap = new Map<Id , Opportunity>();
        for (Opportunity trader : traders)
        {
            traderMap.put(trader.Id, trader);
        }
        
        
        for (Stall__c stall : stalls )
        {
            String priceKey = '' ;
            if(stall.MondayTrader__c != null)
            {
                priceKey = 'Monday' + traderMap.get(stall.MondayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Monday_Active_Price__c = price * traderMap.get(stall.MondayTrader__c).Uplift_Factor__c *  stall.MondayMultiplier__c;
            }
            if(stall.TuesdayTrader__c != null)
            {
                priceKey = 'Tuesday' + traderMap.get(stall.TuesdayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Tuesday_Active_Price__c = price * traderMap.get(stall.TuesdayTrader__c).Uplift_Factor__c *  stall.TuesdayMultiplier__c;
            }
            if(stall.WednesdayTrader__c != null)
            {
                priceKey = 'Wednesday' + traderMap.get(stall.WednesdayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Wednesday_Active_Price__c = price * traderMap.get(stall.WednesdayTrader__c).Uplift_Factor__c *  stall.WednesdayMultiplier__c;
            }
            if(stall.ThursdayTrader__c != null)
            {
                priceKey = 'Thursday' + traderMap.get(stall.ThursdayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Thursday_Active_Price__c = price * traderMap.get(stall.ThursdayTrader__c).Uplift_Factor__c *  stall.ThursdayMultiplier__c;
            }
            if(stall.FridayTrader__c != null)
            {
                priceKey = 'Friday' + traderMap.get(stall.FridayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Friday_Active_Price__c = price * traderMap.get(stall.FridayTrader__c).Uplift_Factor__c *  stall.FridayMultiplier__c;
            }
            if(stall.SaturdayTrader__c != null)
            {
                priceKey = 'Saturday' + traderMap.get(stall.SaturdayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Saturday_Active_Price__c = price * traderMap.get(stall.SaturdayTrader__c).Uplift_Factor__c *  stall.SaturdayMultiplier__c;
            }
            if(stall.SundayTrader__c != null)
            {
                priceKey = 'Sunday' + traderMap.get(stall.SundayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                stall.Sunday_Active_Price__c = price * traderMap.get(stall.SundayTrader__c).Uplift_Factor__c *  stall.SundayMultiplier__c;
            }
            
            stallsToReturn.add(stall);
            
        }
        
        return stallsToReturn;
        
    }
}