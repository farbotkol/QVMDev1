trigger OrderTrigger on Order (after update ) {
	
    // create PO if the Order has been flagged as approved
    if(trigger.isUpdate && trigger.isAfter) {
         for (Order order : Trigger.new) {
            if(order.PO_Approved__c != trigger.oldMap.get(order.Id).PO_Approved__c){
                if (order.PO_Approved__c == true && (order.QuickBooksId__c == '' || order.QuickBooksId__c == NULL)){
                    system.debug('Create PO');
                    POBuilder.GeneratePurchaseOrder(order.Id);
                }
        	}
         }
    }
}