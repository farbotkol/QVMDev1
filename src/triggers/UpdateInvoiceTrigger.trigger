trigger UpdateInvoiceTrigger on Invoice__c ( after insert, after update )
{
    Set<String> invoiceMagicAccountSet = new Set<String>();    
    for( Invoice__c invObj: Trigger.New )
    {
        invoiceMagicAccountSet.add(invObj.Magic_Account_Number__c);
    }
}