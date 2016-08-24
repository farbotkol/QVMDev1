public class AccountQBOHelper {
	
   
    public static boolean AccountQBOUpsert(List<Account> scope)
    {
        System.debug('Accounts to be updated : ' + scope);
   		List<Account> itemsToUpdateWithQBOId = new List<Account> ();
 
   		QBOCRUDHelper crudHelper = new QBOCRUDHelper();
   		for (Account so : scope)
   		{
             System.debug('current Account val : ' + so);

   			QBOCustomer customer = new QBOCustomer();
			if (so.Majik_AccountNo__c != null)
			{
				customer.CompanyName =  so.Majik_AccountNo__c ;
			}

			
			customer.PrimaryTaxIdentifier = so.ABN__c;
			customer.DisplayName = so.Name ;
            QBOCustomer.PrimaryPhone phone = new QBOCustomer.PrimaryPhone();
            phone.FreeFormNumber = so.Phone;
            customer.PrimaryPhone = phone  ; 
            
            
            QBOCustomer.BillAddr billAddr = new QBOCustomer.BillAddr();
            billAddr.Line1 = so.BillingStreet;
            billAddr.City = so.BillingCity;
            billAddr.CountrySubDivisionCode = so.BillingCountry  + ' ' + so.BillingState;
            billAddr.PostalCode = so.BillingPostalCode ;
            
            customer.BillAddr = billAddr  ; 
			QBOCustomerResponse customerResponse;
			
            if (so.QuickBooks_Id__c  == null){
                System.debug('NEW system.JSON.serialize(customer, true): ' + system.JSON.serialize(customer, true));
   				 customerResponse = (QBOCustomerResponse)crudHelper.upsertData( 'customer?minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
            }else{
                customer.Id =  so.QuickBooks_Id__c ;
                // need to get syncTocken
                customerResponse = (QBOCustomerResponse)crudHelper.read( 'customer', so.QuickBooks_Id__c , QBOCustomerResponse.class);
                System.debug('READ customerResponse: ' + customerResponse);
                customer.SyncToken = customerResponse.Customer.SyncToken;
                System.debug('UPDATE system.JSON.serialize(customer, true): ' + system.JSON.serialize(customer, true));
                customerResponse = (QBOCustomerResponse)crudHelper.upsertData( 'customer?operation=update&minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
            }
			System.debug('Quick books response : ' + customerResponse);
            System.debug('current object val : ' + so.QuickBooks_Id__c);
            
            


   			if (so.QuickBooks_Id__c == null)
   			{
   				Account acct = new Account(id=so.id,QuickBooks_Id__c=customerResponse.Customer.Id);   			
   				itemsToUpdateWithQBOId.add(acct);
   			}
   		}

   		if(itemsToUpdateWithQBOId.size()>0)
   			Update itemsToUpdateWithQBOId;
        
        return true;
        
    }  
       
        
}