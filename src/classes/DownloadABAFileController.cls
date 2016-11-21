public class DownloadABAFileController
{
    public Batch_Jobs__c batchlobObj;
    public ID  recId; 
    public Qvm_ABA_File_Generator__c qvmABAFileObj{get;set;}
    
    // Header details
    public string emptyString17 {get ;set;}
    public string emptyString7 {get ;set;}
    public string emptyString40 {get ;set;}
    public string emptyString12 {get ;set;}
    public string emptyString24 {get ;set;}
    public string newLine {get ;set;}
    public string lineFeed {get ;set;}
    
    public string financialInstitution {get ;set;}
    public integer maxLengthFinancialInst =3;
    public string UserName {get ;set;}
    public string UserName32 {get ;set;}
    public integer maxLengthUserName = 26;
    public integer maxLengthUserName32 = 32;
    public string userIdentityNumber{get ;set;}
    public integer maxUserIdentityNumber = 6;
    public string Description{get ;set;}
    public integer maxLengthDescription = 12;
    public string processingDate{get ;set;}
    public integer maxLengthDate = 6;
    
    //Detail Section
    public integer maxLengthAccountName = 32;    
    List<Payment__c> paymentList{get ;set;}
    List<Payment__c> updatedPaymentList{get ;set;}
    
    public string lodgementReference{get;set;}
    public integer maxLengthlodgementReference = 18;
    public string bsbNumber{get;set;}
    public string accountNumber{get;set;}
    public integer maxlengthAccountNumber = 9;
    public string nameOfRemitter{get;set;}
    public integer maxlengthNameOfRemitter = 16;
    
    // Total section
    public string totalRecordCount{get;set;}
    public string netTotalAmount{get;set;}
    public string credittotalAmount{get;set;}
    public string debitTotalAmount{get;set;}
    
    // Last detail line - this is the Credit that offsets the debits
    
    
    
    
    public DownloadABAFileController( ApexPages.StandardController stdController )
    {        
        batchlobObj = (Batch_Jobs__c)stdController.getRecord();      
        recId = stdController.getRecord().Id;
        paymentList = new List<Payment__c>();
        updatedPaymentList = new List<Payment__c>();
        
        emptyString17 = ''.rightPad(17);
        emptyString7 = ''.rightPad(7);
        emptyString40 = ''.rightPad(40);
        emptyString12 = ''.rightPad(12);
        emptyString24 = ''.rightPad(24);
        newLine = '\r';
        lineFeed = '\n';
        
    }
    
    public void fetch()
    {
        Date todaysDate = Date.today();
        string day = string.valueof(todaysDate.day()).leftPad(2).replace(' ', '0');
        string month = string.valueof(todaysDate.month()).leftPad(2).replace(' ', '0');
        string year = string.valueof(todaysDate.year()).right(2);
                                     
        try
        {
             // Query data from custom setting.
             qvmABAFileObj = [SELECT Financial_Institution__c,Name_Of_User__c,
                             User_Identification_Number__c,Description__c,Date_to_be_Processed__c,
                             Lodgement_Reference__c,BSB_Number__c,Account_Number__c,Name_of_Remitter__c 
                             FROM Qvm_ABA_File_Generator__c where Name = 'ABA File Content' LIMIT 1]; 
             // Header section Formatting
             financialInstitution = qvmABAFileObj.Financial_Institution__c.rightPad(maxLengthFinancialInst);
             UserName = qvmABAFileObj.Name_Of_User__c.rightPad(maxLengthUserName);
             UserName32 = qvmABAFileObj.Name_Of_User__c.rightPad(maxLengthUserName32);
             userIdentityNumber = string.valueof(qvmABAFileObj.User_Identification_Number__c).rightPad(maxUserIdentityNumber); 
             Description = qvmABAFileObj.Description__c.rightPad(maxLengthDescription);
            processingDate = string.valueof(day + month + year).rightPad(maxLengthDate);
             Integer footerTotalAmount = 0;
            //Detail section Formatting
             paymentList = [SELECT Total_Amount__c,Account__r.Name,BSB_Number__c,Bank_Account_Number__c 
                        FROM Payment__c where Batch_Jobs__c =:recId AND ( Batch_Jobs__r.Payment_Type__c = 'EFT' OR   Batch_Jobs__r.Payment_Type__c = '' )];
             for(Payment__c paymentObj : paymentList )
             {
                 if ( paymentObj.BSB_Number__c == null ||paymentObj.BSB_Number__c == 'null')
                    paymentObj.BSB_Number__c = '000-000';
                 if ( paymentObj.Bank_Account_Number__c == null || paymentObj.Bank_Account_Number__c == 'null' )
                 {
                     paymentObj.Bank_Account_Number__c = '         ';   
                 }                                                   
                 else
                 {
                     paymentObj.Bank_Account_Number__c = paymentObj.Bank_Account_Number__c.right(maxlengthAccountNumber).leftPad(maxlengthAccountNumber);
                 }
                     
                 Integer nTotalValue = Integer.valueOf(paymentObj.Total_Amount__c * 100); // total value without '$' 
                 footerTotalAmount += nTotalValue;
                 paymentObj.AmountText__c  = string.valueOf(nTotalValue).leftPad(10).replace(' ', '0');// totalvalue with leading 0000008865.34
                 
                 paymentObj.Account__r.Name = paymentObj.Account__r.Name.left(maxLengthAccountName).rightPad(maxLengthAccountName);
                 updatedPaymentList.add(paymentObj);                 
             }             
             // Custom setting's values for detail section
             lodgementReference = qvmABAFileObj.Lodgement_Reference__c.left(maxLengthlodgementReference).rightPad(maxLengthlodgementReference);
             if(qvmABAFileObj.BSB_Number__c == null || qvmABAFileObj.BSB_Number__c == 'null')
             {
                 bsbNumber = '000-000';
             }
             else
             {
                bsbNumber = qvmABAFileObj.BSB_Number__c;
             }
             if ( qvmABAFileObj.Account_Number__c == null || qvmABAFileObj.Account_Number__c == 'null')
             {
                accountNumber = '         ';   
             }                                                   
             else
             {
                accountNumber = qvmABAFileObj.Account_Number__c.right(maxlengthAccountNumber).leftPad(maxlengthAccountNumber);
             }
             nameOfRemitter = qvmABAFileObj.Name_of_Remitter__c.left(maxlengthNameOfRemitter).rightPad(maxlengthNameOfRemitter); 
            
            // Total Section
             if( !updatedPaymentList.isEmpty())
             {
                 integer totalRecordSize = updatedPaymentList.size()+1;
                 totalRecordCount = string.valueOf(totalRecordSize).leftPad(6).replace(' ', '0');
                 netTotalAmount = string.valueOf(0).leftPad(10).replace(' ', '0');
                 debitTotalAmount =  string.valueOf(footerTotalAmount).leftPad(10).replace(' ', '0');
                 credittotalAmount = string.valueOf(footerTotalAmount).leftPad(10).replace(' ', '0');
             }             
             
        }
        catch( Exception Ex )
        {
            System.debug('Exception in DownloadABAFileController:fetch():-' + Ex.getMessage());
        }  
    }
    public  List<Payment__c> getpaymentList()
    {
        return updatedPaymentList;
    }
    

}