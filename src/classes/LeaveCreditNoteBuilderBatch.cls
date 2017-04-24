global class LeaveCreditNoteBuilderBatch implements Database.Batchable<sObject>,  Database.AllowsCallouts {
    List<OrderItem> orderItems;
    Id batchJob;
    
    global LeaveCreditNoteBuilderBatch(List<OrderItem> orderItemsToProcess, Id batchJobId) {
        orderItems = orderItemsToProcess;
        batchJob = batchJobId;
    }
    
    global List<OrderItem> start(Database.BatchableContext BC) {
        return orderItems;
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        LeaveCreditNoteBuilder.GenerateLeaveCreditNotes(scope, batchJob);
    }
    
    global void finish(Database.BatchableContext BC) {
        
         ///TESTING OUT SOMETHING NEW 
        System.debug('here we are : ');
        //PaymentBuilder.getInvoices(batchJob,new List<String>()); 
        //PaymentBuilder.getCredits( batchJob,new List<String>());    
        
    }
}