@isTest
public class StallMapControllerTest {

    @isTest 
    static void test_getbuildTable() {

         
        TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        
        
        
        Opportunity opp = [select id, name, Stall__c from Opportunity limit 1];
        
        opp.Permitted_Use__c = 'Apparel';
        update opp;
        TestDataFactory.createSingleStall(opp);
        

        StallMapController ctl = new StallMapController();
        string mapstr = ctl.getbuildTable();

        System.assert(mapstr.contains('div'));

    }
    @isTest
    static void test_updateAttributes()
    {
        
       TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Opportunity opp = [select id, name, Stall__c from Opportunity  limit 1];
        opp.Permitted_Use__c = 'Fresh Food';
        update opp;
        
   
        Stall__c stallObj = TestDataFactory.createSingleStall(opp);
        
        PageReference tpageRef = Page.StallMap;
        Test.setCurrentPage(tpageRef);                                         
        ApexPages.currentPage().getParameters().put('stallid', stallObj.id); 
        ApexPages.currentPage().getParameters().put('width', ''); 
        ApexPages.currentPage().getParameters().put('height', ''); 
        ApexPages.currentPage().getParameters().put('left', '');
        ApexPages.currentPage().getParameters().put('top', '');         
        StallMapController.UpdateAttributes();
        
        StallMapController ctl = new StallMapController();
        ctl.getbuildTable();
        opp.Permitted_Use__c = 'Apparel';
        update opp;
        ctl.getbuildTable();
        
        opp.Permitted_Use__c = 'Toys';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Footwear';
        update opp;
        ctl.getbuildTable();
        
        opp.Permitted_Use__c = 'Souvenirs';
        update opp;
        ctl.getbuildTable();
        opp.Permitted_Use__c = 'Fashion Accessories';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Hardware';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Homewares';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Services';
        update opp;
        ctl.getbuildTable();
        opp.Permitted_Use__c = 'Fresh Food';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Technology';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Prepared Food';
        update opp;
        ctl.getbuildTable();
         opp.Permitted_Use__c = 'Artists-Self Designed and Made';
        update opp;
        String s = ctl.getbuildTable();
        system.assertNotEquals(s, null);
        
    
        
    }
    
     @isTest
    static void test_updateAttributeData()
    {
        
       TestDataFactory.createStallProductsAndGeneralPriceBook();
        List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Opportunity opp = [select id, name, Stall__c from Opportunity  limit 1];
        opp.Permitted_Use__c = 'Fresh Food';
        update opp;
        
   
        Stall__c stallObj = TestDataFactory.createSingleStall(opp);
        
        PageReference tpageRef = Page.StallMap;
        Test.setCurrentPage(tpageRef);                                         
        ApexPages.currentPage().getParameters().put('stallid', stallObj.id); 
        ApexPages.currentPage().getParameters().put('width', ''); 
        ApexPages.currentPage().getParameters().put('height', ''); 
        ApexPages.currentPage().getParameters().put('left', '');
        ApexPages.currentPage().getParameters().put('top', '');         
        StallMapController.UpdateAttributes();
        
        StallMapController ctl = new StallMapController();
        opp.Permitted_Use__c = 'Paper Products';
        update opp;
        ctl.getbuildTable();
        
        opp.Permitted_Use__c = 'Personal Care/Health';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Botantical';
        update opp;
         ctl.selectedWeekdayRefresh = 'Thursday';
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Livestock/Pets';
        update opp;
        ctl.getbuildTable();
        
         opp.Permitted_Use__c = 'Materials/Craft Products';
        update opp;
        ctl.selectedWeekdayRefresh = 'Tuesday';
        ctl.getbuildTable();
         opp.Permitted_Use__c = 'Non-Consumables';
        update opp;
        ctl.getbuildTable();
         opp.Permitted_Use__c = 'Travel';
        update opp;
        ctl.selectedWeekdayRefresh = 'Sunday';
        ctl.getbuildTable();
         opp.Permitted_Use__c = 'aaaaa**';
        update opp;
        ctl.selectedWeekdayRefresh = 'Saturday';
        ctl.getbuildTable();
         opp.Permitted_Use__c = null;
        update opp;
        ctl.getbuildTable();
        ctl.selectedWeekdayRefresh = 'aaa';
       ctl.getWeekdayRefreshOptions();
        
        pageReference p;
        p = ctl.refresh();
        system.assertEquals(p, null);
    
        
    }
    
    
    

}