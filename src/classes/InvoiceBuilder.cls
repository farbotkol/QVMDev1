global class InvoiceBuilder {

    // Used to generate one order into a QBO invoice from the Salesforce UI
    Webservice static boolean GenerateInvoiceFromOrder(Id orderId)
    {
        /*
        SELECT Account.QuickBooks_Id__c,Batch_Job__c,Description,EffectiveDate,EndDate,Id,OpportunityId,OrderNumber,QuickBooksId__c,Status,StatusCode , 
		(SELECT Date__c,Description,Formula_Total__c,ListPrice,OrderItemNumber,Quantity,ServiceDate,Total__c,UnitPrice,
		Stall__r.Name
        FROM OrderItems)
			FROM Order
		*/
        return true;
    }
    
    
    /*static boolean GenerateInvoiceFromOrder(Id orderId)
    {
        
    }*/

}