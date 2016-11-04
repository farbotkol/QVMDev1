/*
*****************************************************************************************
Author: Resmi Ramakrishnan
Date  : 07/09/2016
Description : This is the transaction batch class for PaymentBuilder.                  

****************************************************************************************
*/
global class TransactionBuilderBatch implements Database.Batchable<sObject>
{
	List<Transaction__c> transList = new List<Transaction__c>();
    Id mybatchJobId;
    integer transactionCount =0;
    decimal Balance_Receded = 0 ;
    
    global TransactionBuilderBatch( List<Transaction__c> items_i, ID batchJobId, decimal Default_Balance_Receded) 
    {
		transList = items_i;
        mybatchJobId = batchJobId;
        Balance_Receded = Default_Balance_Receded;
        transactionCount = transList.size();
	}
    global List<Transaction__c> start( Database.BatchableContext BC ) 
    {
        system.debug('Inside start');
		return transList;

	}
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
        try
        {
            //Schema.SObjectField f = Transaction__c.Fields.Invoice_QuickBookId__c;
         	//Database.UpsertResult [] cr = Database.upsert((List<Transaction__c>)scope, f, false); 
         	//
         	INSERT scope;
        }
        catch( Exception Ex )
        {
            System.debug('Exception in TransactionBuilderBatch Execute():' + Ex.getMessage());
        }        
	}
    global void finish(Database.BatchableContext BC)
    {
        try
        {
            Batch_Jobs__c batchjob = [select id,Balance_Receeded__c,Outstanding_Balance__c,	Payment_Amount__c from Batch_Jobs__c where id = :mybatchJobId];
            
            system.debug('Default_Balance_Receded: ' + Balance_Receded);
            //system.debug(Balance_Receded.setScale(2) + ' : ' + batchjob.Outstanding_Balance__c + ' : ' + batchJob.Payment_Amount__c);

            if(Balance_Receded.setScale(2) <= batchjob.Outstanding_Balance__c){
                batchjob.Balance_Receeded__c = Balance_Receded.setScale(2);
            }else{
                batchjob.Balance_Receeded__c = batchjob.Outstanding_Balance__c;
            }
            update  batchjob ;

        	// Getting Record Type - Transactions Found.
        	ID foundRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Transactions Found').getRecordTypeId();        
        	Batch_Jobs__c batchJobObj = [SELECT id,Transaction_Count__c  FROM Batch_Jobs__c where id = :mybatchJobId ];         
         	if( batchJobObj != null )
         	{
            	// Changing Record Type Id to Transactions Found.
            	batchJobObj.RecordTypeId =  foundRecordTypeID;
            	batchJobObj.Transaction_Count__c = transactionCount;
            	update batchJobObj;
         	}  
        }
        catch( Exception Ex )
        {
            System.debug('Exception in TransactionBuilderBatch finish():' + Ex.getMessage());
        }
    }
}