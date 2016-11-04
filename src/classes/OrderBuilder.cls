global with sharing class OrderBuilder {

        //---------------------- Changing Record Type to Finding Transactions record type ----------------------------------------//    
    Webservice static void UpdateBatchType( Id batchJobId )
    {   
         try
         {
            ID findingRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Processing Orders').getRecordTypeId();
         	Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
         	batchJobObj.RecordTypeId =  findingRecordTypeID;
         	update batchJobObj; 
         }
         catch( Exception Ex )
         {
            System.debug('Exception in UpdateBatchType():' + Ex.getMessage());
         }         
    }
    
    Webservice  static boolean GenerateOrders(Id batchJobId)
    {
        //

        system.debug('Processing batchJobId: ' + batchJobId);
        // get current batch job
        Batch_Jobs__c job = [SELECT Batch_Type__c,From_Date__c,Id,Name,Process_Range__c
                            ,RecordType.Name,To_Date__c,Week_Month_Of__c , Description__c
                            FROM Batch_Jobs__c 
                            WHERE Id = :batchJobId LIMIT 1];

        //system.debug('processType: ' + processType);

        // get the Processing_Orders rec type to set batch as
        RecordType nextStepType = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                            WHERE SobjectType = 'Batch_Jobs__c' and DeveloperName = 'Processing_Orders' LIMIT 1] ;
    
        job.RecordTypeId = nextStepType.Id;

        update job;

        // SLs and PEs need leave processed LHs do not
        if (job.Batch_Type__c  == 'SL' || job.Batch_Type__c  == 'PE')
        {
            
            // GET THE record type that  matchs the  batch type
            RecordType processType =  [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                            WHERE SobjectType = 'Opportunity' and DeveloperName = :job.Batch_Type__c LIMIT 1];

            // GET THE Opps (acc bus) with a record type that  matchs the  batch type
            List<Opportunity> opps = [select Id, Name, accountid, pricebook2id
                              ,(select id from MondayStalls__r)
                              ,(select id from TuesdayStalls__r)
                              ,(select id from WednesdayStalls__r)
                              ,(select id from ThursdayStalls__r)
                              ,(select id from FridayStalls__r)
                              ,(select id from SaturdayStalls__r)
                              ,(select id from SundayStalls__r)
                              from opportunity
                              where RecordTypeId = :processType.Id
                              and Business_Status__c = 'Open'];
            
            
             System.debug('PPPP processType.Id: ' + processType.Id);
             
             GenerateOrdersFromAllocatedStalls(job.From_Date__c, job.To_Date__c, opps , batchJobId, job.Description__c, processType.Id) ;               
        }
        else if (job.Batch_Type__c  == 'LH' )
        {
            RecordType processType = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType
                    WHERE SobjectType = 'Opportunity' and DeveloperName = :job.Batch_Type__c LIMIT 1];

            List<Opportunity> opps = [select Id, Name, accountid
                     ,(select id, Monthly_Rent__c, Product__c from Perm_Stalls__r WHERE IsActive__c = TRUE)
                    from opportunity
                    where id IN (select Tenant__c from Stall__c where Tenant__c  != null  AND Monthly_Rent__c  > 0) and
                     Business_Status__c = 'Open'
                    ];

            GenerateOrdersFromAllocatedPermStalls(job.From_Date__c, job.To_Date__c, opps , batchJobId, job.Description__c) ; 
        }   
        else 
        {

            List<Opportunity> opps = [select Id, Name, accountid
                     ,(select id, Monthly_Rent__c,CWW_Annual_Parks__c,CWW_Qtr_Drainage_Charge__c,CWW_Water_Usage__c,MCC_1st_Qtr_Ins__c,MCC_2nd_Qtr_Ins__c,MCC_3rd_Qtr_Ins__c,MCC_4th_Qtr_Ins__c,Metered_Water__c, Product__c from Perm_Stalls__r WHERE IsActive__c = TRUE)
                    from opportunity
                    where id IN (select Tenant__c from Stall__c where Tenant__c  != null) and
                     Business_Status__c = 'Open'
                    ];

            GenerateFeeOrders(job.From_Date__c, job.To_Date__c, opps , batchJobId, job.Description__c, job.Batch_Type__c) ; 
        }   

        return true;
    }


    /* Luke Farbotko 18-Aug-2016 

       Generations order items for PE and SLs , creates i line items for each stall per day in the period range provided

    */
    public static boolean GenerateOrdersFromAllocatedStalls(Date startDate, Date endDate, List<Opportunity> opps, id batchJobId, string description, id processTypeId)
    {
        // GET ALL ACTIVE PRICE BOOK ENTRIES TO USE LATER
        list<PricebookEntry> pricebookEntries = [SELECT  Id,ProductCode,IsActive,Name,Pricebook2Id,Product2Id,UnitPrice,UseStandardPrice 
                                         FROM PricebookEntry
                                         WHERE  IsActive = true];

        // create map of leave to ref here 
        list<Leave__c> leaveEntries = [SELECT Id, Leave_Date__c, Account_Business__c
                                    FROM Leave__c
                                    WHERE   Account_Business__r.RecordTypeId = :processTypeId];
        
        System.debug('PPPP leaveEntries : ' + leaveEntries );
                                    
        map<string, Leave__c> leaveEntriesMap = new map<string, Leave__c>();
        
        for(Leave__c lv: leaveEntries)
        {
            String val = lv.Leave_Date__c + (String)lv.Account_Business__c;
            leaveEntriesMap.put(val,lv);
        } 
        
        system.debug('PPPP  leaveEntriesMap : ' + leaveEntriesMap);
        system.debug('pricebookEntries  : ' + pricebookEntries);                                 

        map<string, PricebookEntry> pricebookEntriesMap =  new map<string, PricebookEntry>();

        for(PricebookEntry pb: pricebookEntries)
        {
            String val = pb.ProductCode + pb.Pricebook2Id;
            pricebookEntriesMap.put(val, pb);
        }    
        system.debug('pricebookEntriesMap  : ' + pricebookEntriesMap);          
            
        List<Order> ordersToCreate = new List<Order>();

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(opps);

        for (Opportunity opp : opps)
        {
            if (opp.MondayStalls__r.size()  > 0 
                || opp.TuesdayStalls__r.size()  > 0
                || opp.WednesdayStalls__r.size()  > 0
                || opp.ThursdayStalls__r.size()  > 0
                || opp.FridayStalls__r.size()  > 0
                || opp.SaturdayStalls__r.size()  > 0
                || opp.SundayStalls__r.size()  > 0
               )
            {
                system.debug('opp stuff' + opp);
                Order order = new Order();
                order.AccountId = opp.AccountId;
                order.OpportunityId = opp.Id;
                order.EffectiveDate = startDate;
                order.EndDate = endDate;
                order.Status = 'Draft';
                order.Description = description;
                order.Pricebook2Id = opp.Pricebook2Id;
                if (batchJobId != null)
                {
                    order.Batch_Job__c =  batchJobId;
                }
                

                ordersToCreate.add(order);
            }
     
        }

        Insert ordersToCreate;

        //Orders orders = [select id from Orders where ] ;
        //List<Free_Day__c> freeDays = [SELECT Date__c FROM Free_Day__c WHERE ];
		//Map<Free_Day__c, Date__c> m = new Map<Free_Day__c, Date__c>([SELECT Date__c FROM Free_Day__c]);
        //List<Free_Day__c> myList=[select Date__c,Name from Free_Day__c];
        
        Map<Date, String> freesMap = new Map<Date, String>();

        for(Free_Day__c freeDay:[select Date__c,Name from Free_Day__c]){
            freesMap.put(freeDay.Date__c, freeDay.Name);
        }

        List<OrderItem> orderItemsToCreate  = new List<OrderItem>();
        For(Order order : ordersToCreate)
        {
            Date dateIndex = startDate;
            while(dateIndex <= endDate)
            {
                if(!freesMap.containsKey(dateIndex))
                {
                
                    String dayOfWeek = ((Datetime)dateIndex).format('EEEE'); 
                    List<Stall__c> stalls;
                    if (dayOfWeek == 'Monday') 
                    {
                        stalls = oppMap.get(order.OpportunityId).MondayStalls__r;
                    }       
                    else if (dayOfWeek == 'Tuesday') 
                    {
                        stalls = oppMap.get(order.OpportunityId).TuesdayStalls__r;
                    }   
                    else if (dayOfWeek == 'Wednesday')
                    {
                        stalls = oppMap.get(order.OpportunityId).WednesdayStalls__r;
                    }   
                    else if (dayOfWeek == 'Thursday')
                    {
                        stalls = oppMap.get(order.OpportunityId).ThursdayStalls__r;
                    }                           
                    else if (dayOfWeek == 'Friday')
                    {
                        stalls = oppMap.get(order.OpportunityId).FridayStalls__r;
                    }       
                    else if (dayOfWeek == 'Saturday')
                    {  
                        stalls = oppMap.get(order.OpportunityId).SaturdayStalls__r;
                    }   
                    else if (dayOfWeek == 'Sunday')
                    {
                        stalls = oppMap.get(order.OpportunityId).SundayStalls__r;
                    }   
    
                    
                    // here we need to handle leave requirments
                    for (Stall__c stall : stalls)
                    {
                        //system.debug('order : ' + order.Id); 
                        //system.debug('opp : ' + oppMap.get(order.OpportunityId));
                        //system.debug('pricebook id : ' + oppMap.get(order.OpportunityId).Pricebook2Id);
                        //system.debug('dayOfWeek : ' + dayOfWeek);
                        //system.debug('PricebookEntryId :' + pricebookEntriesMap.get(dayOfWeek + (String)oppMap.get(order.OpportunityId).Pricebook2Id ).Id); 
                        // create an order line
                        OrderItem ordItm =new OrderItem();
                        // detirmine the key to use to get the prive book entry for this day
                        String val = dayOfWeek + (String)oppMap.get(order.OpportunityId).Pricebook2Id ; 
                        
                        String leaveKey =  dateIndex + (String)order.OpportunityId; 
                        ordItm.Date__c = dateIndex;
                        ordItm.PricebookEntryId = pricebookEntriesMap.get(val).Id;// + (String)oppMap.get(oppMap).Pricebook2Id
                        
                        ordItm.OrderId = order.Id;
                        ordItm.UnitPrice =  pricebookEntriesMap.get(val).UnitPrice;
                        ordItm.Quantity = 1;
                        ordItm.Stall__c = stall.Id;
                        If(leaveEntriesMap.containsKey(leaveKey))
                        ordItm.Leave__c = true;
                        orderItemsToCreate.add(ordItm);
    
                    }
                }
                dateIndex = dateIndex.addDays(1);
            }
            
        }

        OrderBuilderBatch batch = new OrderBuilderBatch(orderItemsToCreate,  batchJobId); 

        database.executebatch(batch,200);

        //Insert orderItemsToCreate;

        return true;

    }


    /*
        Generates orders for the LH perm stalls, 
    */
    public static boolean GenerateOrdersFromAllocatedPermStalls(Date startDate, Date endDate, List<Opportunity> opps, id batchJobId, string description)
    {

        //get the avaliable pricebook entries for perm stall and put in map for looking up by the product id
        Id standardPriceBookId = PriceBookUtils.getStdPricebookId();

        List<PricebookEntry> pricebookEntries = [SELECT  Id,ProductCode,IsActive,Name,Pricebook2Id,Product2Id,UnitPrice,UseStandardPrice 
                                         FROM PricebookEntry
                                         WHERE  IsActive = true and Pricebook2Id = :standardPriceBookId];

        Map<Id , PricebookEntry> pricebookEntriesMap = new Map<Id, PricebookEntry>();


        for (PricebookEntry pricebookEntry : pricebookEntries)
        {
            pricebookEntriesMap.put(pricebookEntry.Product2Id, pricebookEntry);

        }

        // build order headers
        List<Order> ordersToCreate = new List<Order>();

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(opps);

        for (Opportunity opp : opps)
        {
            Order order = new Order();
            order.AccountId = opp.AccountId;
            order.OpportunityId = opp.Id;
            order.EffectiveDate = startDate;
            order.EndDate = endDate;
            order.Status = 'Draft';
            order.Description = description;
            // Perm products can be gathered from the standard pricebook as they will0 have $0 prices
            order.Pricebook2Id =  standardPriceBookId;//'01s28000009tRAS';//opp.Pricebook2Id;
            if (batchJobId != null)
            {
                order.Batch_Job__c =  batchJobId;
            }
            ordersToCreate.add(order);
        }
        Insert ordersToCreate; 

        // build order lines
        List<OrderItem> orderItemsToCreate  = new List<OrderItem>();
        For(Order order : ordersToCreate)
        {
            Opportunity opp  = oppMap.get(order.OpportunityId);
            for (Stall__c stall : opp.Perm_Stalls__r)
            {
                OrderItem ordItm =new OrderItem();
                ordItm.Date__c = startDate;
                ordItm.PricebookEntryId = pricebookEntriesMap.get(stall.Product__c).Id ;// + (String)oppMap.get(oppMap).Pricebook2Id '01up0000000xyDs'
                ordItm.OrderId = order.Id;
                ordItm.UnitPrice =  stall.Monthly_Rent__c;
                ordItm.Quantity = 1;
                ordItm.Stall__c = stall.Id;
                orderItemsToCreate.add(ordItm);
            }

        }
        OrderBuilderBatch batch = new OrderBuilderBatch(orderItemsToCreate,  batchJobId); 

        database.executebatch(batch,150);

        return true;
    }


    /*
        Process the selected fee related to LH traders
    */
    public static boolean GenerateFeeOrders(Date startDate, Date endDate, List<Opportunity> opps, id batchJobId, string description, string fieldName)
    {

        
        QVM_LH_FEE_SETTING__c setting = QVM_LH_FEE_SETTING__c.getValues(fieldName);

        List<Order> ordersToCreate = new List<Order>();

        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(opps);

        for (Opportunity opp : opps)
        {


            //workout if the opp has any fees of the passed type if so the create an order 
            Double feeAmount = 0.0;
            for (Stall__c stall : opp.Perm_Stalls__r)
            {
                if(stall.get(setting.Fee_Field__c) != null && (Double)stall.get(setting.Fee_Field__c) > 0 )
                {
                    feeAmount += (Double)stall.get(setting.Fee_Field__c); 
                }
            }
            if (feeAmount > 0 )
            {
                Order order = new Order();
                order.AccountId = opp.AccountId;
                order.OpportunityId = opp.Id;
                order.EffectiveDate = startDate;
                order.EndDate = endDate;
                order.Status = 'Draft';
                order.Description = description;
                // Perm products can be gathered from the standard pricebook as they will0 have $0 prices
                order.Pricebook2Id =  PriceBookUtils.getStdPricebookId();
                if (batchJobId != null)
                {
                    order.Batch_Job__c =  batchJobId;
                }
                ordersToCreate.add(order);
            }
        }

        Insert ordersToCreate; 

        List<OrderItem> orderItemsToCreate  = new List<OrderItem>();
        For(Order order : ordersToCreate)
        {
            Opportunity opp  = oppMap.get(order.OpportunityId);
            for (Stall__c stall : opp.Perm_Stalls__r)
            {
                if (stall.get(setting.Fee_Field__c) != null && (Double)stall.get(setting.Fee_Field__c) > 0 )
                {
                    OrderItem ordItm =new OrderItem();
                    ordItm.Date__c = startDate;
                    ordItm.PricebookEntryId = (Id)setting.PricebookEntryId__c;// + (String)oppMap.get(oppMap).Pricebook2Id '01up0000000xyDs'
                    ordItm.OrderId = order.Id;
                    ordItm.UnitPrice =  (Double)stall.get(setting.Fee_Field__c);
                    ordItm.Quantity = 1;
                    ordItm.Description = fieldName;
                    ordItm.Stall__c = stall.Id;
                    orderItemsToCreate.add(ordItm);
                }
            }

        }
        //Insert orderItemsToCreate;

        OrderBuilderBatch batch = new OrderBuilderBatch(orderItemsToCreate,  batchJobId); 

        database.executebatch(batch,150);

        return true;
    }

}