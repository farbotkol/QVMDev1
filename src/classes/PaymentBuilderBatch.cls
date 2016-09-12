/*
*****************************************************************************************
Author: Resmi Ramakrishnan
Date  : 07/09/2016
Description : This is the batch class for PaymentBuilder.                  

****************************************************************************************
*/


global class PaymentBuilderBatch implements Database.Batchable<sObject>
{
    List<Transaction__c> transList = new List<Transaction__c>();
    Id batchJob;
    integer transactionCount =0;
    
    global PaymentBuilderBatch( List<Transaction__c> items_i, ID batchJobId ) 
    {
		transList = items_i;
        batchJob = batchJobId;
        transactionCount = transList.size();
	}
    global List<Transaction__c> start( Database.BatchableContext BC ) 
    {
        system.debug('Inside start');
		return transList;

	}
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {
         Schema.SObjectField f = Transaction__c.Fields.Invoice_QuickBookId__c;
         Database.UpsertResult [] cr = Database.upsert((List<Transaction__c>)scope, f, false);
	}
    global void finish(Database.BatchableContext BC)
    {
        // Getting Record Type - Found  Invoices.
        ID foundRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Invoices Found').getRecordTypeId();
        
        Batch_Jobs__c batchJobObj = [SELECT id,Transaction_Count__c  FROM Batch_Jobs__c where id =:batchJob LIMIT 1];
         
         if( batchJobObj != null )
         {
            // Changing Record Type Id to Found invoices.
            batchJobObj.RecordTypeId =  foundRecordTypeID;
            batchJobObj.Transaction_Count__c = transactionCount;
            update batchJobObj;
         }
    }

}