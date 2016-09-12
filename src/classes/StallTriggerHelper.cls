public class StallTriggerHelper {

    public static void UpdateStallValues(List<Stall__c> stalls)
    {
        //GET ALL THE PRICES
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
            if(stall.TuesdayTrader__c != null)
            {
                system.debug('traderMap.get(stall.TuesdayTrader__c).Pricebook2Id:' + traderMap.get(stall.TuesdayTrader__c).Pricebook2Id);
                priceKey = 'Tuesday' + traderMap.get(stall.TuesdayTrader__c).Pricebook2Id;
                double price = pricesMap.get(priceKey).UnitPrice;
                system.debug('price' + price );
                system.debug('price' + price );
                system.debug('price' + price );
                stall.Tuesday_Active_Price__c = price * traderMap.get(stall.TuesdayTrader__c).Uplift_Factor__c *  stall.TuesdayMultiplier__c;
            }
            
        }
        
    }
}