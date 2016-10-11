global class PaymentBuilderBatch implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    List<Payment__c> payments = new List<Payment__c>();
    Id batchJob;
        
    global PaymentBuilderBatch(List<Payment__c> payments_a, ID batchJobId ) 
    {
		payments = payments_a;
        batchJob = batchJobId;
	}
    global List<Payment__c> start( Database.BatchableContext BC ) 
    {
		return payments;
	}
    global void execute(Database.BatchableContext BC, List<Payment__c>   scope) 
    {
        List<Error_Log__c> errorLogsToInsert = new List<Error_Log__c>();
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();	
        List<Payment__c> paymentsToUpdate = new List<Payment__c>();
        system.debug('Scope:size' + scope.size());        
        for(Payment__c payment:scope) 
        {
            try{
                QBOPaymentResponse paymentResponse;
                Object response = crudHelper.upsertData('payment', payment.PaymentJson__c, QBOPaymentResponse.class)  ;
                
                if (response instanceof QBOError)
                {
                    //log the error and move to next account
                    system.debug('Opp error :');
                   
               
                    continue;
                }
                else
                {
                    paymentResponse = (QBOPaymentResponse)response;
                    payment.QuickBook_Id__c = paymentResponse.Payment.Id;
                    paymentsToUpdate.add(payment);
                }    
            }
            catch(Exception ex){
                errorLogsToInsert.add(ErrorLogHelper.LogBatchJobError(batchJob, ex));
                paymentsToUpdate.add(payment);
            }
                
           
        }
        System.debug('RRR:Payment before update' + paymentsToUpdate.size());
        insert  paymentsToUpdate;
        if (errorLogsToInsert.size() > 0){
            insert  errorLogsToInsert;
        }
        
        // loop through the results now to process the payments in qbo
	}
    global void finish(Database.BatchableContext BC)
    {
        // Getting Record Type - Payments Generated.
        ID paymentgeneratedRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Payments Generated').getRecordTypeId();
        
        Batch_Jobs__c batchJobObj = [SELECT id,Transaction_Count__c  FROM Batch_Jobs__c where id =:batchJob LIMIT 1];
         
         if( batchJobObj != null )
         {
            // Changing Record Type Id to Payments Generated.
            batchJobObj.RecordTypeId =  paymentgeneratedRecordTypeID;
            update batchJobObj;
         }
    }

}