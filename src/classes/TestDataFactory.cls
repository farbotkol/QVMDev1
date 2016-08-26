@isTest
public class TestDataFactory {
    

    public static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct, string recordType ) {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 

        Id oppRecordTypeId = oppRecordTypeInfo.get(recordType).getRecordTypeId();

        List<Account> accts = new List<Account>();
        
        
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            a.RecordTypeId = accRecordTypeId;
            accts.add(a);
        }
        insert accts;
        
        List<Opportunity> opps = new List<Opportunity>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add opportunities
            for (Integer k=0;k<numOppsPerAcct;k++) {
                opps.add(new Opportunity(Name=acct.Name + ' Opportunity ' + k,
                                       RecordTypeid=oppRecordTypeId,
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id,
                                       Contracted_Leave__c=20,
                                       Business_Status__c = 'Open',
                                       pricebook2id=Test.getStandardPricebookId()));
            }
        }
        // Insert all opportunities for all accounts.
        insert opps;
        
        return accts;
    }

    public static Stall__c createSingleStall(Opportunity accBus)
    {


        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Stall__c; 
        Map<String,Schema.RecordTypeInfo> stallTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = stallTypeInfo.get('Casual').getRecordTypeId();
            
        Stall__c stall = new Stall__c();
        stall.RecordTypeid = rtId;
        stall.ShedId__c = 'A' ;
        stall.StallId__c = '1';

        stall.StallId__c = '1';
        stall.name = 'A1';

        stall.FridayMultiplier__c = 1;
        stall.FridayTrader__c = accBus.Id;
        stall.IsActive__c = true;
        stall.MondayTrader__c = accBus.Id;
        stall.SaturdayMultiplier__c = 1;
        stall.SaturdayTrader__c = accBus.Id;
        stall.SundayMultiplier__c = 1;
        stall.SundayTrader__c = accBus.Id;
        stall.ThursdayMultiplier__c = 1;
        stall.ThursdayTrader__c = accBus.Id;
        stall.TuesdayMultiplier__c = 1;
        stall.TuesdayTrader__c = accBus.Id;
        stall.WednesdayMultiplier__c = 1;
        stall.WednesdayTrader__c = accBus.Id; 

        Insert stall;

        return stall;
    }





    public static Stall__c createSingleStallWithNoOpp()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Stall__c; 
        Map<String,Schema.RecordTypeInfo> stallTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = stallTypeInfo.get('Casual').getRecordTypeId();
            


        Stall__c stall = new Stall__c();
        stall.RecordTypeid = rtId;
        stall.ShedId__c = 'A' ;
        stall.StallId__c = '1';

        stall.StallId__c = '1';
        stall.name = 'A1';

        stall.FridayMultiplier__c = 1;
        stall.IsActive__c = true;
        stall.SaturdayMultiplier__c = 1;
        stall.SundayMultiplier__c = 1;
        stall.ThursdayMultiplier__c = 1;
        stall.TuesdayMultiplier__c = 1;
        stall.WednesdayMultiplier__c = 1;

        Insert stall;

        return stall;
    }


    public static Stall__c createPermStallWithNoOpp()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Stall__c; 
        Map<String,Schema.RecordTypeInfo> stallTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = stallTypeInfo.get('Permanent').getRecordTypeId();
            


        Stall__c stall = new Stall__c();
        stall.RecordTypeid = rtId;
        stall.ShedId__c = 'X' ;
        stall.StallId__c = '1';

        stall.StallId__c = '1';
        stall.name = 'X1';

        stall.Annual_Rent__c = 12000;

        stall.FridayMultiplier__c = 1;
        stall.IsActive__c = true;
        stall.SaturdayMultiplier__c = 1;
        stall.SundayMultiplier__c = 1;
        stall.ThursdayMultiplier__c = 1;
        stall.TuesdayMultiplier__c = 1;
        stall.WednesdayMultiplier__c = 1;

        Insert stall;

        return stall;
    }

    public static Stall__c createPermStallWithOpp(Opportunity accBus)
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Stall__c; 
        Map<String,Schema.RecordTypeInfo> stallTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = stallTypeInfo.get('Permanent').getRecordTypeId();
            


        Stall__c stall = new Stall__c();
        stall.RecordTypeid = rtId;
        stall.ShedId__c = 'X' ;
        stall.StallId__c = '1';
        stall.Tenant__c = accBus.Id; 
        stall.StallId__c = '1';
        stall.Product__c = TestDataFactory.createPremStallProducts().Id;
        stall.name = 'X1';

        stall.Annual_Rent__c = 12000;
        stall.MCC_1st_Qtr_Ins__c = 100;

        stall.FridayMultiplier__c = 1;
        stall.IsActive__c = true;
        stall.SaturdayMultiplier__c = 1;
        stall.SundayMultiplier__c = 1;
        stall.ThursdayMultiplier__c = 1;
        stall.TuesdayMultiplier__c = 1;
        stall.WednesdayMultiplier__c = 1;

        Insert stall;

        return stall;
    }




    public static void createStallProductsAndGeneralPriceBook()
    {

            /*PriceBook2 pb = new PriceBook2();
            pb.name = 'General Merchandise';
            pb.isActive=true;
            pb.IsStandard  = true;
            insert pb;*/

            List<Product2> productsToInsert = new List<Product2>();

            Product2 prodMon= new Product2();
            prodMon.name='Monday';
            prodMon.ProductCode='Monday';
            prodMon.isActive=true;
            productsToInsert.add(prodMon);

            Product2 prodTue= new Product2();
            prodTue.name='Tuesday';
            prodTue.ProductCode='Tuesday';
            prodTue.isActive=true;
            productsToInsert.add(prodTue);

            Product2 prodWed= new Product2();
            prodWed.name='Wednesday';
            prodWed.ProductCode='Wednesday';
            prodWed.isActive=true;
            productsToInsert.add(prodWed);

            Product2 prodThu= new Product2();
            prodThu.name='Thursday';
            prodThu.ProductCode='Thursday';
            prodThu.isActive=true;
            productsToInsert.add(prodThu);

            Product2 prodFri= new Product2();
            prodFri.name='Friday';
            prodFri.ProductCode='Friday';
            prodFri.isActive=true;
            productsToInsert.add(prodFri);

            Product2 prodSat = new Product2();
            prodSat.name='Saturday';
            prodSat.ProductCode='Saturday';
            prodSat.isActive=true;
            productsToInsert.add(prodSat);

            Product2 prodSun= new Product2();
            prodSun.name='Sunday';
            prodSun.ProductCode='Sunday';
            prodSun.isActive=true;
            productsToInsert.add(prodSun);

            insert productsToInsert;

            List<PriceBookEntry> pbeToInsert = new List<PriceBookEntry>();

             Id pricebookId = Test.getStandardPricebookId();

            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodMon.id,unitprice=30, isActive=true));
            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodTue.id,unitprice=30, isActive=true));
            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodWed.id,unitprice=30, isActive=true));
            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodThu.id,unitprice=30, isActive=true));
            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodFri.id,unitprice=30, isActive=true));
            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodSat.id,unitprice=30, isActive=true));
            pbeToInsert.add(new PricebookEntry(pricebook2id=pricebookId, product2id=prodSun.id,unitprice=30, isActive=true));

            insert pbeToInsert;

            
    }


    public static Product2 createPremStallProducts()
    {


        

        Product2 prod= new Product2();
        prod.name='perm stall';
        prod.ProductCode='perm stall';
        prod.Family ='Permanent Stall';
        prod.isActive=true;

        insert prod;


        Id pricebookId = Test.getStandardPricebookId();


        PricebookEntry pbe = new PricebookEntry(pricebook2id=pricebookId, product2id=prod.id,unitprice=30, isActive=true);

        insert pbe;

        return prod;

        
    }




    public static Batch_Jobs__c createSLBatchJob()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);

        Batch_Jobs__c bj = new Batch_Jobs__c();
        bj.Batch_Type__c = 'SL';
        bj.Process_Range__c = 'Month';
        bj.Week_Month_Of__c = Date.today();
        bj.RecordTypeid = rtId;

        insert bj;

        return bj;
       
    }


    public static Batch_Jobs__c createLHBatchJob()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);

        Batch_Jobs__c bj = new Batch_Jobs__c();
        bj.Batch_Type__c = 'LH';
        bj.Process_Range__c = 'Month';
        bj.Week_Month_Of__c = Date.today();
        bj.RecordTypeid = rtId;

        insert bj;

        return bj;
       
    }

    public static Batch_Jobs__c createMCCBatchJob()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);

        Batch_Jobs__c bj = new Batch_Jobs__c();
        bj.Batch_Type__c = 'MCC 1st Qtr Ins';
        //bj.Process_Range__c = 'Quarter';
        bj.Week_Month_Of__c = Date.today();
        bj.RecordTypeid = rtId;

        insert bj;

        return bj;
       
    }

    public static void CreateQVM_LH_FEE_SETTING_Entries()
    {

        //CREATE Product and add to standard pricebook
        Product2 prod= new Product2();
        prod.name='a fee';
        prod.ProductCode='fee';
        prod.Family ='Permanent Stall';
        prod.isActive=true;

        insert prod;

        //add to standard pricebook
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pricebookId, product2id=prod.id,unitprice=0, isActive=true);

        insert pbe;



        //List<QVM_LH_FEE_SETTING__c> settings = new List<QVM_LH_FEE_SETTING__c>();
        QVM_LH_FEE_SETTING__c setting1 = new QVM_LH_FEE_SETTING__c();
        setting1.Name = 'MCC 1st Qtr Ins';
        setting1.Fee_Field__c = 'MCC_1st_Qtr_Ins__c';
        setting1.PricebookEntryId__c = pbe.Id;

        Insert setting1;


    }
    
    
    public static void CreateOAuthServiceEntries()
    {
        OAuthService__c service = new OAuthService__c();
        service.Request_Token_URL__c = 'https://oauth.intuit.com/oauth/v1/get_request_token';
        service.Authorization_URL__c = 'https://appcenter.intuit.com/Connect/Begin';
        service.Access_Token_URL__c = 'https://oauth.intuit.com/oauth/v1/get_access_token';
        service.BaseURL__c = 'https://sandbox-quickbooks.api.intuit.com/v3/company/';
        service.CallbackUrl__c = 'https://cs31.salesforce.com/apex/QuickBooksLogin';
        service.Consumer_Key__c = 'qyprdf5ltQR3fLoNbAq8rVXp2Y3cxK';
        service.Consumer_Secret__c = 'gVblWDndfHuObNQY03aJjUgi7tFqYnQmJzZSsMp3';
        service.Application_Token__c = 'af18d34bbd246b43c3b9781bd831b85be89b';
        service.Name = 'QuickBooksAU';
        
        insert  service;
        OAuth_Token__c oaToken = new OAuth_Token__c();
        oaToken.OAuthService__c = service.Id;
        //oaToken.OAuthService__r.Consumer_Key__c = service.Consumer_Key__c;
        //oaToken.OAuthService__r.Consumer_Secret__c = service.Consumer_Secret__c;
        oaToken.Token__c = 'qyprdf5ltQR3fLoNbAq8rVXp2Y3c';
        oaToken.Secret__c = 'qyprdf5ltQR3fLoNbAq8rVXp2';
        oaToken.Is_Access__c = True;
        oaToken.Realm_Id__c = '67454209';
        
        insert oaToken;
        
    }



}