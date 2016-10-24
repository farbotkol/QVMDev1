@isTest
public class TestDataFactory {
    
    public static List<Account> createAccountsWithOpps(Integer numAccts, Integer numOppsPerAcct, string recordType ) {

        Id PriceBookId = Test.getStandardPricebookId();
        if(recordType == 'SL' || recordType == 'PE' ) 
        {
            PriceBook2 PriceBook = [select Id from PriceBook2 where Name = 'General Merchandise' limit 1];
            PriceBookId = PriceBook.Id;
        }
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 

        Id oppRecordTypeId = oppRecordTypeInfo.get(recordType).getRecordTypeId();

        List<Account> accts = new List<Account>();
        
        
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccountTEST1S' + i);
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
                                       pricebook2id=PriceBookId,
                                       Uplift_Factor__c=1));
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

            PriceBook2 pb = new PriceBook2();
            pb.name = 'General Merchandise';
            pb.isActive=true;
            pb.SLPE__c = true;
            pb.Sku__c = '0000000';
        	pb.PO_Pricebook__c = true;
            //pb.IsStandard  = true;
            insert pb;
        
            
        
            //PriceBook2 pb = PriceBookUtils.getStdPriceBook();
            
            //update pb;

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
        
        	pbeToInsert.clear();
        
        	pricebookId = pb.Id;
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
        Id rtId = BatchJobsTypeInfo.get('New Orders/Invoices').getRecordTypeId();
            
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
        Id rtId = BatchJobsTypeInfo.get('New Orders/Invoices').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);

        Batch_Jobs__c bj = new Batch_Jobs__c();
        bj.Batch_Type__c = 'LH';
        bj.Process_Range__c = 'Month';
        bj.Week_Month_Of__c = Date.today();
        bj.RecordTypeid = rtId;

        insert bj;

        return bj;
       
    }
    
    public static Batch_Jobs__c createSLBatchJobLCN()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Leave Credit Notes').getRecordTypeId();
            
        system.debug('TEST : ' + rtId);

        Batch_Jobs__c bj = new Batch_Jobs__c();
        bj.Batch_Type__c = 'SL';
        bj.Process_Range__c = 'Month';
        bj.Week_Month_Of__c = Date.today();
        bj.RecordTypeid = rtId;

        insert bj;

        return bj;
       
    }
    
    public static void createOrder(String recordType)
    {
    	List<Account> accounts = [SELECT Id from Account];
        Id PriceBookId = Test.getStandardPricebookId();
        if(recordType == 'SL' || recordType == 'PE' ) 
        {
            PriceBook2 PriceBook = [select Id from PriceBook2 where Name = 'General Merchandise' limit 1];
            PriceBookId = PriceBook.Id;
        }
        Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        Order orderObj = new Order();
        orderObj.OpportunityId = opp.Id;
        orderObj.AccountId = accounts.get(0).Id;
        orderObj.Status = 'Draft';
        orderObj.EffectiveDate = Date.today();
        orderObj.PriceBook2Id = PriceBookId;
        orderObj.QuickBooksId__c = '33876';
        orderObj.Balance_Due__c = 0.00;
        orderObj.Total_With_GST__c = 0.00;
        insert orderObj;
    }
    
    public static List<OrderItem> createOrderItemWithLeave(Integer numOrderItems, String recordType)
    {
        List<OrderItem> oi = new List<OrderItem>();
        //TestDataFactory.createStallProductsAndGeneralPriceBook();
		//List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
		List<Account> accounts = [SELECT Id from Account];
        Stall__c stallObj = TestDataFactory.createSingleStallWithNoOpp();
        Id PriceBookId = Test.getStandardPricebookId();
        if(recordType == 'SL' || recordType == 'PE' ) 
        {
            PriceBook2 PriceBook = [select Id from PriceBook2 where Name = 'General Merchandise' limit 1];
            PriceBookId = PriceBook.Id;
        }
        List<PricebookEntry>  prods = [SELECT Id,UnitPrice FROM PricebookEntry where PriceBook2Id = :PriceBookId];
        Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        Order orderObj = new Order();
        orderObj.OpportunityId = opp.Id;
        orderObj.AccountId = accounts.get(0).Id;
        orderObj.Status = 'Draft';
        orderObj.EffectiveDate = Date.today();
        orderObj.PriceBook2Id = PriceBookId;
        insert orderObj;
        
        System.debug('PriceBookId '+PriceBookId);
        //System.debug('ProdId '+prod.Id);
        for(Integer i=0;i<numOrderItems;i++) {
            OrderItem item = new OrderItem();
            item.Leave__c = True;
            item.Date__c = Date.today();
            item.OrderId = orderObj.Id;
            item.Stall__c = stallObj.Id;  
            item.PricebookEntryId = prods[0].Id; 
            item.Quantity = 1; 
            item.UnitPrice = 123; 
            oi.add(item);
        }
        insert oi;
        return oi;
        
    }
    
    public static Order createPO()
    {
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Supplier').getRecordTypeId();
        
        
        Account a = new Account(Name='TestAccountSupplier');
        a.RecordTypeId = accRecordTypeId;
 
        insert a;
        a.Supplier_Approved__c = true;
        update a;
        
        //TestDataFactory.createStallProductsAndGeneralPriceBook();
		List<Account> accounts = TestDataFactory.createAccountsWithOpps(1,1, 'SL');
        Stall__c stallObj = TestDataFactory.createSingleStallWithNoOpp();
        Id PriceBookId = Test.getStandardPricebookId();
        
        
        List<PricebookEntry>  prods = [SELECT Id,UnitPrice FROM PricebookEntry where PriceBook2Id = :PriceBookId];
        Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        Order orderObj = new Order();
       
        orderObj.AccountId = a.Id;
        orderObj.Status = 'Draft';
        orderObj.EffectiveDate = Date.today();
        orderObj.PriceBook2Id = PriceBookId;
        insert orderObj;
        
        
        System.debug('PriceBookId '+PriceBookId);
        //System.debug('ProdId '+prod.Id);
        OrderItem item = new OrderItem();
        item.Leave__c = True;
        item.Date__c = Date.today();
        item.OrderId = orderObj.Id;
        item.Stall__c = stallObj.Id;  
        item.PricebookEntryId = prods[0].Id; 
        item.Quantity = 1; 
        item.UnitPrice = 123; 


        insert item;
        return orderObj;
        
    }

    public static Batch_Jobs__c createMCCBatchJob()
    {

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Batch_Jobs__c; 
        Map<String,Schema.RecordTypeInfo> BatchJobsTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = BatchJobsTypeInfo.get('New Orders/Invoices').getRecordTypeId();
            
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
    
    public static void CreateQvm_ABA_File_Generator()
    {
        Qvm_ABA_File_Generator__c aba = new Qvm_ABA_File_Generator__c();
        aba.Name = 'ABA File Content';
        aba.Name_Of_User__c =  'test';
        aba.Financial_Institution__c =  'CBA';
        aba.User_Identification_Number__c =  2464664;
        aba.Description__c =  'TEST';
        aba.Date_to_be_Processed__c =  171712;
        aba.Lodgement_Reference__c =  'TEST';
        aba.BSB_Number__c =  '222-222';
        aba.Account_Number__c =  '3245423';
        aba.Name_of_Remitter__c =  'TEST';

		Insert aba;
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
    
    /*
      * @description       This method is using to create supplier accounts.                       
      * @param             NA 
      * @return            List<Account>
      * @throws            NA
    */  
    public static List<Account> createSupplierAccounts( Integer numAccts )
    {
        //Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        //Map<String,Schema.RecordTypeInfo> oppRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 

       // Id oppRecordTypeId = oppRecordTypeInfo.get(recordType).getRecordTypeId();

        List<Account> accts = new List<Account>();
        
        
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Supplier').getRecordTypeId();
        
        for(Integer i=0;i<numAccts;i++) 
		{
            Account a = new Account(Name='TestAccount' + i);
            a.RecordTypeId = accRecordTypeId;
            accts.add(a);
        }
        insert accts;
        
        return accts;
  }

    /*
      * @description       Test method to create a Lead.                       
      * @param             NA 
      * @return            Lead Object
      * @throws            NA
    */  
    public static Lead CreateLead()
    {
        Lead leadRecord = new Lead();
        leadRecord.LastName='TestLastName';
        leadRecord.FirstName='TestFirstName';
        leadRecord.Company='TestCompany';
        leadRecord.Status='New Application';             
        return leadRecord ;   
    }
    
    /*
      * @description       Test method to create a Lead with No Identity Files.                       
      * @param             NA 
      * @return            Lead Object
      * @throws            NA
    */  
    public static Lead createLeadWithNoAustralianLicense()
    {
        Lead leadRecord = new Lead();
        leadRecord.LastName='TestLastName';
        leadRecord.FirstName='TestFirstName';
        leadRecord.Company='TestCompany';
        leadRecord.Status='New Application';             
        return leadRecord ;   
    }
    
    /*
      * @description       This method creates test user for unit testing.                           
      * @param             lastName , profileId, roleId, emailAddress    
      * @return            User - Returns the user object
      * @throws            NA
    */
    public static User createUser(String lastName,Id profileId,String emailAddress)
    {
        User usr = new User(alias = lastName, email= emailAddress,
                            emailencodingkey = Constants.ENCODE_KEY, lastname = lastName,
                            timezonesidkey = Constants.TIME_ZONE,
                            languagelocalekey = Constants.LOCALE_KEY,
                            localesidkey = Constants.LOCALE_KEY, profileid = profileId,
                            username = lastName + System.currentTimeMillis() + Constants.USER_POSTFIX );
        return usr;      
    } 
    
    /*
      * @description       This method creates test contact for unit testing.                           
      * @param             lastName , profileId, roleId, emailAddress    
      * @return            Contact - Returns the contact object
      * @throws            NA
    */
    public static Contact createContact(String accountName, String firstName, String lastName, String emailAddress)
    {
        Account newAccount = new Account (name = accountName,
                                          BillingCity ='TestCity',
                                          BillingCountry ='TestCountry',
                                          BillingStreet ='TestStreet',
                                          BillingPostalCode ='t3stcd3'
                                         );
        insert newAccount;
		Contact contact = new Contact (FirstName = firstName,
                                       LastName = lastName,
                                       AccountId = newAccount.Id,
                                       Email = emailAddress
                                      );
        insert contact;
        return contact;       
    } 
    /*
      * @description       This method creates test contact for unit testing.                           
      * @param             lastName , profileId, roleId, emailAddress    
      * @return            Contact - Returns the contact object
      * @throws            NA
    */
    public static Opportunity createOpportunity(Id accountId)
    {
        Opportunity opportunity = new Opportunity (AccountId = accountId,
                                                      Name = 'TestOpportunity',
                                                   StageName = 'TestStage',
                                                   CloseDate = System.today()
                                                     );
        insert opportunity;

        return opportunity;
    } 
    
    /*
      * @description       This method creates custom setting data for QVM_Web_Form_Config__c name is MerchandiseStall .                           
      * @param             NA  
      * @return            NA
      * @throws            NA
    */
    public static QVM_Web_Form_Config__c createCustomSettingMerchandiseStall()
    {
      QVM_Web_Form_Config__c csWebFormObj = new QVM_Web_Form_Config__c ();
      csWebFormObj.Name = 'MerchandiseStall';
      csWebFormObj.Is_Linked_To_Campaign__c = false; 
      csWebFormObj.CampaignId__c   = null;        
      csWebFormObj.leadRecordTypeId__c = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('QVM Property Management').getRecordTypeId();
      csWebFormObj.LeadSource__c = 'Website';
      csWebFormObj.OpportunityRecordTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SL').getRecordTypeId();
      csWebFormObj.Minimum_Number_Of_Images_Required__c = 0;
      csWebFormObj.Maximum_Number_Of_Images_Required__c = 2;
      csWebFormObj.Terms_And_Conditions_URL__c  = null;
      return csWebFormObj;
    }
    
    /*
      * @description       This method creates custom setting data for QVM_Web_Form_Config__c name is FruitAndVegetableTrading.                           
      * @param             NA  
      * @return            NA
      * @throws            NA
    */
    public static QVM_Web_Form_Config__c createCustomSettingFruitAndVegetableTrading()
    {
      QVM_Web_Form_Config__c csWebFormObj = new QVM_Web_Form_Config__c ();
      csWebFormObj.Name = 'FruitAndVegetableTrading';
      csWebFormObj.Is_Linked_To_Campaign__c = false; 
      csWebFormObj.CampaignId__c   = null;        
      csWebFormObj.leadRecordTypeId__c = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('QVM Property Management').getRecordTypeId();
      csWebFormObj.LeadSource__c = 'Website';
      csWebFormObj.OpportunityRecordTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SL').getRecordTypeId();
      csWebFormObj.Minimum_Number_Of_Images_Required__c = 0;
      csWebFormObj.Maximum_Number_Of_Images_Required__c = 2;
      csWebFormObj.Terms_And_Conditions_URL__c  = null;
      return csWebFormObj;
    }  
    
    /*
      * @description       This method creates LeadObject with all required data for Application Submission.                           
      * @param             NA  
      * @return            Lead Object
      * @throws            NA
    */
    public static Lead createLeadWithallRequiredData()
    {
        Lead leadRecord = new Lead();
        leadRecord.LastName='TestLastName';
        leadRecord.FirstName='TestFirstName';
        leadRecord.Company='TestCompany';
        leadRecord.Status='New Application'; 
        leadRecord.Email = 'resmi.ramakrishnan@rxpservices.com';                    
        return leadRecord ; 
    }
    
   /*
      * @description       This method is using to create Campaign
      * @param             NA  
      * @return            NA
      * @throws            NA
    */
    public static Campaign createCampaign()
    {     
         Campaign s = new Campaign ( Name = 'TestCampaign' );
         return s;
    }
    
    /*
      * @description       This method creates custom setting data for QVM_Web_Form_Config__c name is NightMarketSpecialityStalls.                           
      * @param             NA  
      * @return            NA
      * @throws            NA
    */
    public static QVM_Web_Form_Config__c createCustomSettingNightMarketSpecialityStalls()
    {
      QVM_Web_Form_Config__c csWebFormObj = new QVM_Web_Form_Config__c ();
      csWebFormObj.Name = 'NightMarketSpecialityStalls';
      csWebFormObj.Is_Linked_To_Campaign__c = true; 
      
      Campaign  newCampaign = createCampaign();
      csWebFormObj.CampaignId__c   = newCampaign.id;        
      csWebFormObj.leadRecordTypeId__c = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('QVM Events').getRecordTypeId();
      csWebFormObj.LeadSource__c = 'Website';
      csWebFormObj.OpportunityRecordTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Events').getRecordTypeId();
      csWebFormObj.Minimum_Number_Of_Images_Required__c = 3;
      csWebFormObj.Maximum_Number_Of_Images_Required__c = 5;
      csWebFormObj.Terms_And_Conditions_URL__c  = 'www.qvm.com.au';
      return csWebFormObj;
    }
    
    /*
      * @description       This method creates custom setting data for QVM_Web_Form_Config__c name is SpecialEvents.                           
      * @param             NA  
      * @return            NA
      * @throws            NA
    */
    public static QVM_Web_Form_Config__c createCustomSettingSpecialEvents()
    {
      QVM_Web_Form_Config__c csWebFormObj = new QVM_Web_Form_Config__c ();
      csWebFormObj.Name = 'SpecialEvents';
      csWebFormObj.Is_Linked_To_Campaign__c = true; 
      
      Campaign  newCampaign = createCampaign();
      
      csWebFormObj.CampaignId__c   = newCampaign.id;        
      csWebFormObj.leadRecordTypeId__c = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('QVM Events').getRecordTypeId();
      csWebFormObj.LeadSource__c = 'Website';
      csWebFormObj.OpportunityRecordTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Other Events').getRecordTypeId();
      csWebFormObj.Minimum_Number_Of_Images_Required__c = 0;
      csWebFormObj.Maximum_Number_Of_Images_Required__c = 0;
      csWebFormObj.Terms_And_Conditions_URL__c  = 'www.qvm.com.au';
      return csWebFormObj;
    }
    
    /*
      * @description       This method creates custom setting data for QVM_Web_Form_Config__c name is NightMarketFoodVendor.                           
      * @param             NA  
      * @return            NA
      * @throws            NA
    */
    public static QVM_Web_Form_Config__c createCustomSettingNightMarketFoodVendor()
    {
      QVM_Web_Form_Config__c csWebFormObj = new QVM_Web_Form_Config__c ();
      csWebFormObj.Name = 'NightMarketFoodVendor';
      csWebFormObj.Is_Linked_To_Campaign__c = true; 

      Campaign  newCampaign = createCampaign();
      csWebFormObj.CampaignId__c   = newCampaign.id; 
                
      csWebFormObj.leadRecordTypeId__c = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('QVM Events').getRecordTypeId();
      csWebFormObj.LeadSource__c = 'Website';
      csWebFormObj.OpportunityRecordTypeId__c = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Events').getRecordTypeId();
      csWebFormObj.Minimum_Number_Of_Images_Required__c = 3;
      csWebFormObj.Maximum_Number_Of_Images_Required__c = 5;
      csWebFormObj.Terms_And_Conditions_URL__c  = null;
      return csWebFormObj;
    }
    
  	/*  public static Order createOpportunityAndOrder()
    {
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Testopportunity';
        
        Order orderObj = new Order();
        orderObj.OpportunityId = 
        orderObj.
        return createOrder;
    }*/
    public static Account createAccountTrader()
    {
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Trader').getRecordTypeId();        
        Account a = new Account(Name='TestAccount1');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c =  '100';
        return a;
   }
    
    //Create Account Supplier.
    public static Account createAccountSupplier()
    {
        Schema.DescribeSObjectResult acccCfrSchema = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> accRecordTypeInfo = acccCfrSchema.getRecordTypeInfosByName(); 
        Id accRecordTypeId = accRecordTypeInfo.get('Supplier').getRecordTypeId();        
        Account a = new Account(Name='TestAccount2');
        a.RecordTypeId = accRecordTypeId;
        a.QuickBooks_Id__c =  '101';
        return a;
   }
    
   // Create Order.
    public static order createOrder()
    {
        Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        List<Account> accounts = [SELECT Id from Account];
        PriceBook2 PriceBook = [select Id from PriceBook2 limit 1];
        Order orderObj = new Order();
        orderObj.OpportunityId = opp.Id;
        orderObj.AccountId = accounts.get(0).Id;
        orderObj.Status = 'Draft';
        orderObj.EffectiveDate = Date.today();
        orderObj.PriceBook2Id = PriceBook.Id;
        orderObj.QuickBooksId__c = '100';
        insert orderObj;
        return orderObj;
    }
    
     // Create Order.
    public static order createOrderQuickBookIdNull()
    {
        Opportunity opp = [SELECT ID FROM Opportunity LIMIT 1];
        List<Account> accounts = [SELECT Id from Account];
        PriceBook2 PriceBook = [select Id from PriceBook2 limit 1];
        Order orderObj = new Order();
        orderObj.OpportunityId = opp.Id;
        orderObj.AccountId = accounts.get(0).Id;
        orderObj.Status = 'Draft';
        orderObj.EffectiveDate = Date.today();
        orderObj.PriceBook2Id = PriceBook.Id;
        orderObj.QuickBooksId__c = null;
        insert orderObj;
        return orderObj;
    }
}