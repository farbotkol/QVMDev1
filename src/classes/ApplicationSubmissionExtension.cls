/*
*****************************************************************************************
Author: Resmi Ramakrishnan
Date : 15/08/2016
Description : This is an extension class for ApplicationSubmission visualforce page                   

****************************************************************************************
*/

public without sharing class ApplicationSubmissionExtension
{
     public Lead weblead {get;set;} 
     public Id recId {get;set; }
     public String selectedType{get;set;}    

    /* public string fileName1 {  get;set; }
     public Blob fileBody1 {    get;set;  }
     public string fileName2 {  get;set; }
     public Blob fileBody2 {    get;set;  }    
     public string imagename3 {get;set;}
     public Blob imagebody3 {get;set;}
     public string imagename4 {get;set;}
     public Blob imagebody4 {get;set;}
     public string imagename5 {get;set;}
     public Blob imagebody5 {get;set;}*/
     
     private Integer intMinimumImages;
     private Integer intMaximumImages;
     public List<Attachment> newAttachments {get; set;}


     public string fileName3 {  get;set; }
     public Blob fileBody3 {    get;set;  }
     public string fileName4 {  get;set; }
     public Blob fileBody4 {    get;set;  }
     public string fileName5 {  get;set; }
     public Blob fileBody5 {    get;set;  }
     public string fileName6 {  get;set; }
     public Blob fileBody6 {    get;set;  }
     public boolean isDisplay   {get;set;}

     public String Revenue {get;set;}
     public Blob RevenueBody {get;set;}

     public String EventExpense { get;set;}
     public Blob eventExpenseBody {get;set;}

     public String Budget {get;set;}
     public Blob BudgetBody {get;set;}
     
     public ApplicationSubmissionExtension theController{get;set;}
     private String urlParameter;
     private QVM_Web_Form_Config__c qvmWebConfigObj;
     
     public Boolean acceptanceTextFlag{get;set;}
     public String  termsAndConditionLink {get;set;}
     
     

    /*
     * @description       Constructor of ApplicationSubmissionExtension class.   
     * @param             NA
     * @return            NA
     * @throws            NA
    */ 
    public ApplicationSubmissionExtension(ApexPages.StandardController stdController) 
    {
        weblead = (Lead)stdController.getRecord();       
        recId = stdController.getRecord().Id; 
        isDisplay=true;
        this.theController = this;
        urlParameter = ApexPages.currentPage().getParameters().get('type');
        
        
        qvmWebConfigObj = [ SELECT Is_Linked_To_Campaign__c, CampaignId__c, leadRecordTypeId__c,
                                 LeadSource__c, OpportunityRecordTypeId__c, Minimum_Number_Of_Images_Required__c,
                                 Maximum_Number_Of_Images_Required__c,Terms_And_Conditions_URL__c  
                                 FROM QVM_Web_Form_Config__c where Name =: urlParameter LIMIT 1 ];
                                 
        intMinimumImages = Integer.valueOf( qvmWebConfigObj.Minimum_Number_Of_Images_Required__c);
        intMaximumImages = Integer.valueOf( qvmWebConfigObj.Maximum_Number_Of_Images_Required__c);
        newAttachments=new List<Attachment>();
        for (Integer idx=0; idx<intMaximumImages; idx++)
        {
            newAttachments.add(new Attachment());
        }
        
        
        if( qvmWebConfigObj.Terms_And_Conditions_URL__c  == null )
        {
           acceptanceTextFlag = false;
        }
        else
        {
          acceptanceTextFlag = true; 
          termsAndConditionLink = qvmWebConfigObj.Terms_And_Conditions_URL__c;
        }        
    }


    /*
     * @description       This method is invoking when user clicks Submit button.   
     * @param             NA
     * @return            NA
     * @throws            NA
    */ 
    public PageReference saveLead()
    {
         try 
         {                          
             if( weblead != null )
             {               
                if( !checkIdentityFilesRequired())
                {
                    return null; 
                }
                
                if( ! validateImageFileInput( intMinimumImages  ))
                {
                    return null;
                }
                setLeadFieldsBeforeInsert(); 
                insert weblead;
               
             }

             // This method is for inserting image list.
             insertImageList();
             

             // Image Attachment starts---------------         
              /*if(fileBody1 != null && fileName1 != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = fileBody1;
                myAttachment.Name = fileName1;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }
                         
             }
             if(fileBody2 != null && fileName2 != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = fileBody2;
                myAttachment.Name = fileName2;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }          
             }
             if( imagebody3 !=null && imagename3 != null )
             {
                Attachment myAttachment = new Attachment();
                myAttachment.Body = imagebody3;
                myAttachment.Name = imagename3;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null )
                {
                    insert myAttachment;
                }
              }
              if( imagebody4 !=null && imagename4 != null )
              {
                Attachment myAttachment = new Attachment();
                myAttachment.Body = imagebody4;
                myAttachment.Name = imagename4;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null )
                {
                    insert myAttachment;
                }
              }
              if( imagebody5 !=null && imagename5 != null )
              {
                Attachment myAttachment = new Attachment();
                myAttachment.Body = imagebody5;
                myAttachment.Name = imagename5;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null )
                {
                    insert myAttachment;
                }
              }*/
             // Image Attachment Ends -------------------

             if(fileBody3 != null && fileName3 != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = fileBody3;
                myAttachment.Name = 'StallDisplay' + getFileNameExtension(fileName3 );
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }         
             }
             if(fileBody4 != null && fileName4 != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = fileBody4;
                myAttachment.Name = 'AustralianDriversLicense' + getFileNameExtension(fileName4 );
                myAttachment.ParentId = weblead.id;               
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }        
             }
             if(fileBody5 != null && fileName5 != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = fileBody5;
                myAttachment.Name = fileName5;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }        
             }
             if(fileBody6 != null && fileName6 != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = fileBody6;
                myAttachment.Name = fileName6;
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }         
             }
             if(eventExpenseBody!= null && EventExpense != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = eventExpenseBody;
                myAttachment.Name = 'EventExpense'+getFileNameExtension(EventExpense);
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }         
             }
             if(RevenueBody!= null && Revenue != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = RevenueBody;                
                myAttachment.Name = 'Revenue'+ getFileNameExtension(Revenue);
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }         
             }
             if( BudgetBody!= null && Budget != null)
             {
                Attachment myAttachment  = new Attachment();
                myAttachment.Body = BudgetBody;
                myAttachment.Name = 'Budget'+ getFileNameExtension(Budget);
                myAttachment.ParentId = weblead.id;
                if( myAttachment != null)
                {
                  insert myAttachment; 
                }         
             }

             PageReference p = Page.LeadConfirmationForSite;
             p.setRedirect(true);
             return p;
             
         }
         catch(System.DMLException e)
         {
               ApexPages.addMessages(e);
               return null;
         }
     } 


   /*
     * @description       This method is using to set the values before inserting the lead.   
     * @param             NA
     * @return            NA
     * @throws            NA
    */
     public void setLeadFieldsBeforeInsert()
     {
        if( urlParameter != null )
        {
          weblead.Application_Type__c = urlParameter;      
        }
         
        if( qvmWebConfigObj != null )
        {
            weblead.LeadSource = qvmWebConfigObj.LeadSource__c;

            weblead.RecordTypeId = qvmWebConfigObj.leadRecordTypeId__c;
            weblead.LeadOppRecordTypeId__c = qvmWebConfigObj.OpportunityRecordTypeId__c;
            if( qvmWebConfigObj.Is_Linked_To_Campaign__c == true )
            {
                //Assign CampaignId to custom CampaignId Field;
                weblead.Campaign__c =  qvmWebConfigObj.CampaignId__c;
            }

            //Fetching the assignment rules on Lead Object.
            AssignmentRule AR = new AssignmentRule();
            AR = [ select id from AssignmentRule where SobjectType = 'Lead' and Active = true and Name = 
                  'WebLead Assignment' limit 1 ];

            //Creating the DMLOptions for "Assign using active assignment rules" checkbox.

            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            dmlOpts.EmailHeader.TriggerUserEmail = true;
            weblead.setOptions(dmlOpts);
        }                                                   
     }
     
    /*
     * @description       This method is using to check whether all identity files are uploaded correctly.   
     * @param             NA
     * @return            NA
     * @throws            NA
    */ 
     public Boolean checkIdentityFilesRequired()
     {
        Boolean retVal = true;
        if( fileBody3 == null )
        {
          if( urlParameter == 'NightMarketFoodVendor' )
          {
              ApexPages.Message checkLicense = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please upload a sketch or plan of your proposed stall layout*');
              ApexPages.addMessage(checkLicense);                
              retVal = false;
          }         
        }
        if( fileBody4 == null )
        {
            if( urlParameter == 'FoodTrading' || urlParameter == 'MerchandiseStall' || urlParameter == 'FruitAndVegetableTrading' ||
               urlParameter == 'RetailTenancy' || urlParameter == 'ModularRetailUnit' || urlParameter == 'NightMarketSpecialityStalls' ||
               urlParameter == 'NightMarketFoodVendor' )
            {
                ApexPages.Message checkLicense = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please select Australian License');
                ApexPages.addMessage(checkLicense);                
                retVal = false;
            }                        
        }
        if( fileBody5 == null )
        {
            if( urlParameter == 'FoodTrading' || urlParameter == 'FruitAndVegetableTrading' )
            {
                ApexPages.Message checkFoodAct = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please select Food Act Registration');
                ApexPages.addMessage(checkFoodAct);
                retVal = false;
            }
            if( urlParameter == 'NightMarketFoodVendor' )
            {
                ApexPages.Message checkFoodAct = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please upload your Certificate of Currency covering up to $20,000,000*');
                ApexPages.addMessage(checkFoodAct);
                retVal = false; 
            }                        
        }
        if( fileBody6 == null )
        {
            if( urlParameter == 'FoodTrading' || urlParameter == 'FruitAndVegetableTrading' )
            {
                ApexPages.Message checkFoodSafety = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please select Food Safety Supervisor Certificate');
                ApexPages.addMessage(checkFoodSafety);
                retVal = false;
            }
            if( urlParameter == 'NightMarketFoodVendor' )
            {              
                ApexPages.Message checkFoodSafety = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please upload your Certificate of Registration of Food Premises*');
                ApexPages.addMessage(checkFoodSafety);
                retVal = false;  
            }                        
        }
        if( eventExpenseBody == null )
        {
          if( urlParameter  == 'SpecialEvents' )
          {
               ApexPages.Message checkFoodSafety = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please upload your total anticipated operating expenses for the event');
               ApexPages.addMessage(checkFoodSafety);
               retVal = false; 
          }
        } 
        if( RevenueBody == null )
        {
          if( urlParameter  == 'SpecialEvents' )
          {
              ApexPages.Message checkFoodSafety = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please upload your is the total anticipated revenue from your event');
              ApexPages.addMessage(checkFoodSafety);
              retVal = false; 
          }
        }
        if( BudgetBody == null )
        {
            if( urlParameter  == 'SpecialEvents' )
            {
                ApexPages.Message checkFoodSafety = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please attach a copy of your budget showing any anticipated profit to this application');
                ApexPages.addMessage(checkFoodSafety);
                retVal = false;   
            }
        }
        return retVal;
    }

    
    /*
     * @description       This method is using to check the the required number of image input files .   
     * @param             minimumImages - Minimum number of images required for a form.
     * @return            NA
     * @throws            NA
    */ 
    private Boolean validateImageFileInput( Integer minimumImages )
    {
        Boolean retVal = true;
        for(Integer i=0; i< minimumImages; i++)
        {
            if( newAttachments.size() > 0 )
            {
                if(newAttachments.get(i).body == null)
                {
                    ApexPages.Message imgError = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR: Please select minimum' + ' ' + minimumImages +' ' + 'images' );
                    ApexPages.addMessage(imgError);
                    retVal = false;
                }   
            }                  
        }
        return retVal;       
    }


    /*
     * @description       This method is using to insert list of image files .   
     * @param             NA
     * @return            NA
     * @throws            NA
    */ 
    public void insertImageList()
    {    
        Integer filenameCount = 1;
        List<Attachment> toInsert=new List<Attachment>();
        for (Attachment newAtt : newAttachments)
        {
            if (newAtt.Body!=null)
            {  
                newAtt.Name = 'Image' + filenameCount + getFileNameExtension(newAtt.Name) ;              
                newAtt.parentId = weblead.id;
                toInsert.add(newAtt);
            }
            filenameCount++;
        }
        insert toInsert;
        newAttachments.clear();
        newAttachments.add(new Attachment());      
    }
    
    /*
     * @description       This method is using to get extension from File name.   
     * @param             FileName - Name of file choose for upload.
     * @return            NA
     * @throws            NA
    */
    private string getFileNameExtension( String FileName )
    {
        String extension = FileName.substring(FileName.lastIndexOf('.'));
        return extension; 
    }
}