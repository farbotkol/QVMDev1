public class DownloadABAFileController
{
    Batch_Jobs__c batchlobObj;
    ID  recId; 
    public Qvm_ABA_File_Generator__c qvmABAFileObj{get;set;}
    
    // Header details
    public string emptyString17 {get ;set;}
    public string emptyString7 {get ;set;}
    public string newLine {get ;set;}
    public string UserName {get ;set;}
    
    
    public DownloadABAFileController( ApexPages.StandardController stdController )
    {        
		batchlobObj = (Batch_Jobs__c)stdController.getRecord();      
        recId = stdController.getRecord().Id;
        
        emptyString17 = ''.rightPad(17);
        emptyString7 = ''.rightPad(7);
        newLine = '\r\n';
    }
    
    public void fetch()
    {
        try
        {
             qvmABAFileObj = [SELECT Financial_Institution__c,Name_Of_User__c,
                             User_Identification_Number__c,Description__c,Date_to_be_Processed__c 
                             FROM Qvm_ABA_File_Generator__c where Name = 'ABA File Header Generator' LIMIT 1]; 
            UserName  =  qvmABAFileObj.Name_Of_User__c;
            UserName = UserName.rightPad(7);
        }
        catch( Exception Ex )
        {
            System.debug('Exception in DownloadABAFileController:fetch():-' + Ex.getMessage());
        }  
    }
    public void FormatStrings()
    {
              
    }
}