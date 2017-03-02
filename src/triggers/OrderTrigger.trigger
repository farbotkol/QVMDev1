trigger OrderTrigger on Order (after update, before insert ) {
    
    // create PO if the Order has been flagged as approved
    if(trigger.isUpdate && trigger.isAfter) {
        for (Order order : Trigger.new) {
            if(order.Goods_Services_Recieved__c != trigger.oldMap.get(order.Id).Goods_Services_Recieved__c){
                if (order.Goods_Services_Recieved__c == true && (order.QuickBooksId__c == '' || order.QuickBooksId__c == NULL)){
                    system.debug('Create PO');
                    POBuilder.GeneratePurchaseOrder(order.Id);
                }
            }
        }
    }
    
    // set default price book for POs
    if(trigger.isInsert && trigger.isBefore) {
        Id priceBookId = [SELECT Id FROM Pricebook2 WHERE PO_Pricebook__c = true LIMIT 1].Id;
        Id PORecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Accounts Payable').getRecordTypeId();
        if(priceBookId != null){
            for(Order order : Trigger.new){
                if(order.RecordTypeId == PORecordTypeID) {
                    order.Pricebook2Id = priceBookId;
                }
            }           
        }        
    }    
}