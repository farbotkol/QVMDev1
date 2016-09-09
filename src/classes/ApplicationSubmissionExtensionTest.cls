/*
  **********************************************************************************************
  * @author       : Resmi Ramakrishnan
  * @date         : 23/08/2016
  * @description  : Test class for ApplicationSubmissionExtension class.
  **********************************************************************************************
*/
@isTest( SeeAllData = false )
private class ApplicationSubmissionExtensionTest
{
 
    /*
      * @description       Testing Lead creation without Australian License.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithNoIdentityFiles()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithNoAustralianLicense( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingMerchandiseStall();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);       
                                  
                     ApexPages.currentPage().getParameters().put('type', 'MerchandiseStall');                                   
                     System.assertEquals( 'MerchandiseStall',ApexPages.currentPage().getParameters().get('type'));
                     
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj ));              
                     controller.saveLead();
                }
                Test.stopTest();
                
                System.assertEquals(Constants.NO_AUSTRALIAN_LICENSE, ApexPages.getMessages().get(0).getDetail());
             }
        
    }
    
    
    /*
      * @description       Testing Lead creation with all required data .                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithAllRequiredData()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
        
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingFruitAndVegetableTrading();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'FruitAndVegetableTrading');                                   
                     System.assertEquals( 'FruitAndVegetableTrading',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                     controller.fileName3 = 'StallDisplay.txt';
                     controller.fileBody3 = Blob.valueOf('StallDisplay Body');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     controller.fileName5 = 'Food Act Registration.txt';
                     controller.fileBody5 = Blob.valueOf('Food Act Registration Body');
                     
                     controller.fileName6 = 'Food Safety Supervisor Certificate.txt';
                     controller.fileBody6 = Blob.valueOf('Food Safety Supervisor Certificate Body');
                                          
                     controller.saveLead();
                     
                     List<Attachment> attachments=[select id, name from Attachment where parent.id=:leadObj.id];
                     System.assertEquals( attachments.size(), 4); 
                     
                     Lead leadAfterInsert = [SELECT id,FirstName,LastName from Lead where Email = 'resmi.ramakrishnan@rxpservices.com' LIMIT 1];
                     System.assertEquals( leadAfterInsert.FirstName, 'TestFirstName');
                     System.assertEquals( leadAfterInsert.LastName, 'TestLastName');                                          
                }
                Test.stopTest();                
             }
         
    }
    
    /*
      * @description       Testing Lead creation with Night MarketSpeciality Stall application without adding Image files.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithNightMarketFormWithNoImageFiles()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingNightMarketSpecialityStalls();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'NightMarketSpecialityStalls');                                   
                     System.assertEquals( 'NightMarketSpecialityStalls',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));                                 
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');                                        
                                          
                     controller.saveLead();                   
                }
                Test.stopTest();
                
                System.assertEquals('ERROR: Please select minimum 3 images', ApexPages.getMessages().get(0).getDetail());                
             }
         
    }
    
    /*
      * @description       Testing Lead creation with Night MarketSpeciality Stall application adding all input Files.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithNightMarketFormWithImageFiles()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
     
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingNightMarketSpecialityStalls();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'NightMarketSpecialityStalls');                                   
                     System.assertEquals( 'NightMarketSpecialityStalls',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));                                 
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     controller.newAttachments[0].Name =  'NewImage1.txt';
                     controller.newAttachments[0].Body=  Blob.valueOf('NewImage1');
                     
                     controller.newAttachments[1].Name =  'NewImage2.txt';
                     controller.newAttachments[1].Body=  Blob.valueOf('NewImage2');
                     
                     controller.newAttachments[2].Name =  'NewImage3.txt';
                     controller.newAttachments[2].Body=  Blob.valueOf('NewImage3');                                  
                                          
                     controller.saveLead();                   
                }
                Test.stopTest();
                
                Lead leadAfterInsert = [SELECT id,FirstName,LastName from Lead where Email = 'resmi.ramakrishnan@rxpservices.com' LIMIT 1];
                System.assertEquals( leadAfterInsert.FirstName, 'TestFirstName');
                System.assertEquals( leadAfterInsert.LastName, 'TestLastName'); 
                               
             }
     
    }
    
    /*
      * @description       Testing Lead creation with Special Events.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithSpecialEvents()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
            Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingSpecialEvents();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'SpecialEvents');                                   
                     System.assertEquals( 'SpecialEvents',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));                                 
                     
                     controller.EventExpense = 'Event Expense.txt';
                     controller.eventExpenseBody = Blob.valueOf('Event Expense');
                     
                     controller.Revenue = 'Revenue.txt';
                     controller.RevenueBody = Blob.valueOf('Revenue Body');
                                          
                     controller.Budget = 'Budget.txt';
                     controller.BudgetBody = Blob.valueOf('Budget');
                                 
                     controller.saveLead();                   
                }
                Test.stopTest();
                
                Lead leadAfterInsert = [SELECT id,FirstName,LastName from Lead where Email = 'resmi.ramakrishnan@rxpservices.com' LIMIT 1];
                System.assertEquals( leadAfterInsert.FirstName, 'TestFirstName');
                System.assertEquals( leadAfterInsert.LastName, 'TestLastName'); 
                               
             }
            
    }

    
    /*
      * @description       Testing Lead creation with Special Events Without Event Expense.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithSpecialEventsWithoutEventExpense()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingSpecialEvents();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'SpecialEvents');                                   
                     System.assertEquals( 'SpecialEvents',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));                                 
                                         
                     controller.Revenue = 'Revenue.txt';
                     controller.RevenueBody = Blob.valueOf('Revenue Body');
                                          
                     controller.Budget = 'Budget.txt';
                     controller.BudgetBody = Blob.valueOf('Budget');
                                 
                     controller.saveLead();                   
                }
                Test.stopTest();
                System.assertEquals( Constants.NO_OPERATING_EXPENSE, ApexPages.getMessages().get(0).getDetail());                                                
             }
            
    }
  
    
    /*
      * @description       Testing Lead creation with Special Events Without Revenue File.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithSpecialEventsWithoutRevenueFile()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingSpecialEvents();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'SpecialEvents');                                   
                     System.assertEquals( 'SpecialEvents',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));                                 
                                         
                     controller.EventExpense = 'Event Expense.txt';
                     controller.eventExpenseBody = Blob.valueOf('Event Expense');
                                          
                     controller.Budget = 'Budget.txt';
                     controller.BudgetBody = Blob.valueOf('Budget');
                                 
                     controller.saveLead();                   
                }
                Test.stopTest();
                System.assertEquals( Constants.NO_REVENUE_FILE, ApexPages.getMessages().get(0).getDetail());                                                
             }
          
    }
    
       
    /*
      * @description       Testing Lead creation with Special Events Without Budget File.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithSpecialEventsWithoutBudgetFile()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
        
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingSpecialEvents();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'SpecialEvents');                                   
                     System.assertEquals( 'SpecialEvents',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));                                 
                                         
                     controller.EventExpense = 'Event Expense.txt';
                     controller.eventExpenseBody = Blob.valueOf('Event Expense');
                                          
                     controller.Revenue = 'Revenue.txt';
                     controller.RevenueBody = Blob.valueOf('Revenue Body');
                                 
                     controller.saveLead();                   
                }
                Test.stopTest();
                System.assertEquals( Constants.NO_BUDGET_FILE , ApexPages.getMessages().get(0).getDetail());                                                
             }
           
    }
    
    /*
      * @description       Testing Lead creation with with FruitAndVegetableTrading form withoutvuploading FoodActRegistration File.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testWithFruitAndVegetableTradingNoFoodActRegistration()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingFruitAndVegetableTrading();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'FruitAndVegetableTrading');                                   
                     System.assertEquals( 'FruitAndVegetableTrading',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                     controller.fileName3 = 'StallDisplay.txt';
                     controller.fileBody3 = Blob.valueOf('StallDisplay Body');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                                                            
                     controller.fileName6 = 'Food Safety Supervisor Certificate.txt';
                     controller.fileBody6 = Blob.valueOf('Food Safety Supervisor Certificate Body');
                                          
                     controller.saveLead();                                                            
                }
                Test.stopTest();  
                System.assertEquals( Constants.NO_FOOD_ACT_REGISTRATION, ApexPages.getMessages().get(0).getDetail());                 
             }
         
    }
    
    
    /*
      * @description       Testing Lead creation with NightMarketFoodVendor Application form .                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testNightMarketFoodVendorFormWithNoStallLayout()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingNightMarketFoodVendor();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'NightMarketFoodVendor');                                   
                     System.assertEquals( 'NightMarketFoodVendor',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                    
                    
                     controller.newAttachments[0].Name =  'NewImage1.txt';
                     controller.newAttachments[0].Body=  Blob.valueOf('NewImage1');
                     
                     controller.newAttachments[1].Name =  'NewImage2.txt';
                     controller.newAttachments[1].Body=  Blob.valueOf('NewImage2');
                     
                     controller.newAttachments[2].Name =  'NewImage3.txt';
                     controller.newAttachments[2].Body=  Blob.valueOf('NewImage3');
                    
                     //controller.fileName3 = 'StallLayOut.txt';
                    // controller.fileBody3 = Blob.valueOf('StallLayOutBody');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     controller.fileName5 = 'Currency Covering.txt';
                     controller.fileBody5 = Blob.valueOf('Currency Covering Body');
                     
                     controller.fileName6 = 'Food Registration.txt';
                     controller.fileBody6 = Blob.valueOf('Food Registration Body');
                                          
                     controller.saveLead();                                                                                   
                }
                Test.stopTest();
                System.assertEquals( Constants.NO_SALL_LAYOUT , ApexPages.getMessages().get(0).getDetail());                                
             }
         
    }

    
    /*
      * @description       Testing Lead creation with NightMarketFoodVendor Application form With No CurrencyCovering file.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testNightMarketFoodVendorFormWithNoCurrencyCovering()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
       
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingNightMarketFoodVendor();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'NightMarketFoodVendor');                                   
                     System.assertEquals( 'NightMarketFoodVendor',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                    
                    
                     controller.newAttachments[0].Name =  'NewImage1.txt';
                     controller.newAttachments[0].Body=  Blob.valueOf('NewImage1');
                     
                     controller.newAttachments[1].Name =  'NewImage2.txt';
                     controller.newAttachments[1].Body=  Blob.valueOf('NewImage2');
                     
                     controller.newAttachments[2].Name =  'NewImage3.txt';
                     controller.newAttachments[2].Body=  Blob.valueOf('NewImage3');
                    
                     controller.fileName3 = 'StallLayOut.txt';
                     controller.fileBody3 = Blob.valueOf('StallLayOutBody');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     //controller.fileName5 = 'Currency Covering.txt';
                     //controller.fileBody5 = Blob.valueOf('Currency Covering Body');
                     
                     controller.fileName6 = 'Food Registration.txt';
                     controller.fileBody6 = Blob.valueOf('Food Registration Body');
                                          
                     controller.saveLead();                                                                                   
                }
                Test.stopTest();
                System.assertEquals( Constants.NO_CURRENCY_COVERING, ApexPages.getMessages().get(0).getDetail());                                
             }
        
    }
    
    
    /*
      * @description       Testing Lead creation with NightMarketFoodVendor Application form With No Food Premise Registration file.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testNightMarketFoodVendorFormWithNoFoodRegistration()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();

             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingNightMarketFoodVendor();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'NightMarketFoodVendor');                                   
                     System.assertEquals( 'NightMarketFoodVendor',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                    
                    
                     controller.newAttachments[0].Name =  'NewImage1.txt';
                     controller.newAttachments[0].Body=  Blob.valueOf('NewImage1');
                     
                     controller.newAttachments[1].Name =  'NewImage2.txt';
                     controller.newAttachments[1].Body=  Blob.valueOf('NewImage2');
                     
                     controller.newAttachments[2].Name =  'NewImage3.txt';
                     controller.newAttachments[2].Body=  Blob.valueOf('NewImage3');
                    
                     controller.fileName3 = 'StallLayOut.txt';
                     controller.fileBody3 = Blob.valueOf('StallLayOutBody');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     controller.fileName5 = 'Currency Covering.txt';
                     controller.fileBody5 = Blob.valueOf('Currency Covering Body');
                     
                     //controller.fileName6 = 'Food Registration.txt';
                     //controller.fileBody6 = Blob.valueOf('Food Registration Body');
                                          
                     controller.saveLead();                                                                                   
                }
                Test.stopTest();
                System.assertEquals( Constants.NO_FOOD_PREMISES_REGISTRATION, ApexPages.getMessages().get(0).getDetail());                                
             }
        
    }
    
     /*
      * @description       Testing Lead creation with NightMarketFoodVendor Application form With all data.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testNightMarketFoodVendorFormWithallData()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
        
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingNightMarketFoodVendor();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'NightMarketFoodVendor');                                   
                     System.assertEquals( 'NightMarketFoodVendor',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                    
                    
                     controller.newAttachments[0].Name =  'NewImage1.txt';
                     controller.newAttachments[0].Body=  Blob.valueOf('NewImage1');
                     
                     controller.newAttachments[1].Name =  'NewImage2.txt';
                     controller.newAttachments[1].Body=  Blob.valueOf('NewImage2');
                     
                     controller.newAttachments[2].Name =  'NewImage3.txt';
                     controller.newAttachments[2].Body=  Blob.valueOf('NewImage3');
                    
                     controller.fileName3 = 'StallLayOut.txt';
                     controller.fileBody3 = Blob.valueOf('StallLayOutBody');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     controller.fileName5 = 'Currency Covering.txt';
                     controller.fileBody5 = Blob.valueOf('Currency Covering Body');
                     
                     controller.fileName6 = 'Food Registration.txt';
                     controller.fileBody6 = Blob.valueOf('Food Registration Body');
                                          
                     controller.saveLead();                                                                                   
                }
                Test.stopTest();
                Lead leadAfterInsert = [SELECT id,FirstName,LastName from Lead where Email = 'resmi.ramakrishnan@rxpservices.com' LIMIT 1];
                System.assertEquals( leadAfterInsert.FirstName, 'TestFirstName');
                System.assertEquals( leadAfterInsert.LastName, 'TestLastName');                            
             }
         
    }
    
    
    /*
      * @description       Testing Lead creation With No FoodSafety Certificate.                       
      * @param             NA 
      * @return            Void
      * @throws            NA
    */ 
    static testMethod void testAsSystemAdminWithAllRequiredDataNoFoodSafety()
    {
        Lead leadObj = new Lead();
        QVM_Web_Form_Config__c  qvmWebFormConfigObj = new QVM_Web_Form_Config__c ();
        
             Profile prof = [SELECT Id FROM Profile WHERE Name =: Constants.ADMIN_PROFILE LIMIT 1];
             User adminUser = TestDataFactory.createUser('Admin',prof.id,'admin@advdev.org');
             system.runAs( adminUser )
             {
                Test.startTest();
                leadObj = TestDataFactory.createLeadWithallRequiredData( );  
                
                qvmWebFormConfigObj = TestDataFactory.createCustomSettingFruitAndVegetableTrading();                   
                if( qvmWebFormConfigObj  != null)
                {
                   insert qvmWebFormConfigObj;
                }           
                if( leadObj != null && qvmWebFormConfigObj != null )
                {                                   
                     PageReference tpageRef = Page.ApplicationSubmission;
                     Test.setCurrentPage(tpageRef);                    
                     ApexPages.currentPage().getParameters().put('type', 'FruitAndVegetableTrading');                                   
                     System.assertEquals( 'FruitAndVegetableTrading',ApexPages.currentPage().getParameters().get('type'));
                     leadObj.id =null;
                     ApplicationSubmissionExtension controller = new ApplicationSubmissionExtension(new ApexPages.StandardController( leadObj));              
                     controller.fileName3 = 'StallDisplay.txt';
                     controller.fileBody3 = Blob.valueOf('StallDisplay Body');
                     
                     controller.fileName4 = 'Australian License.txt';
                     controller.fileBody4= Blob.valueOf('Australian License Body');
                     
                     controller.fileName5 = 'Food Act Registration.txt';
                     controller.fileBody5 = Blob.valueOf('Food Act Registration Body');
                     
                     //controller.fileName6 = 'Food Safety Supervisor Certificate.txt';
                    // controller.fileBody6 = Blob.valueOf('Food Safety Supervisor Certificate Body');
                                          
                     controller.saveLead();                                                                                    
                }
                Test.stopTest();   
                System.assertEquals(  Constants.NO_FOOD_SAFETY_CERTIFICATE, ApexPages.getMessages().get(0).getDetail());               
             }
         
    }  
}