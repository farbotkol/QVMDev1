public class AccountQBOHelper {
	

    
  	// FUTURES TEND TO OCCURE FASTER THEN BATCHES, THERE IS ONLY A Small number of items use the furture
    @future  (callout=true)
    public static void AccountQBOUpsertFuture(List<Id> scope)
    {
        List<Account> accounts = [SELECT ABN__c,AccountNumber,AccountSource,BillingAddress,BillingCity
                                      ,BillingCountry,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude
                                      ,BillingPostalCode,BillingState,BillingStreet,CreatedById,CreatedDate
                                      ,Def_Payment_Type__c,Description,First_Date__c,How_did_you_hear_about_us__c
                                      ,Id,Industry,IsCustomerPortal,IsDeleted,Jigsaw,JigsawCompanyId,LastActivityDate
                                      ,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate
                                      ,Majik_AccountNo__c,MasterRecordId,Mobile_Phone__c,Name,NumberOfEmployees
                                      ,OwnerId,ParentId,Phone,PhotoUrl,Primary_Contact__c,QuickBooks_Id__c
                                      ,RecordTypeId,ShippingAddress,ShippingCity,ShippingCountry
                                      ,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState
                                      ,ShippingStreet,SicDesc,SystemModstamp,Trader_Status__c,Trading_Name__c,Type,Website 
                                  FROM Account
                                  WHERE Id IN :scope
                                 ];
       AccountQBOUpsert(accounts);    
    }


    // add Trader accounts to QBO
    public static boolean AccountQBOUpsert(List<Account> scope)
    {
        List<QBO_Payment_Type__mdt> paymentTypes =  [SELECT Label,QBO_Id__c FROM QBO_Payment_Type__mdt];
        Map<String ,String> paymentTypeMap = new Map<String ,String>();
        for (QBO_Payment_Type__mdt pt : paymentTypes)
        {
            paymentTypeMap.put(pt.Label, pt.QBO_Id__c);
        }
  
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
           
            string paymentType =  (String)paymentTypeMap.get(so.Def_Payment_Type__c );
            
            QBOCustomer.PaymentMethodRef paymentMethodRef = new QBOCustomer.PaymentMethodRef();
            if (paymentType != null && paymentType != '')
            {
                paymentMethodRef.value = paymentType;
                customer.PaymentMethodRef =  paymentMethodRef;
            }

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
        
        return true;//add handle exceptions and put value in a log
        
    }  
    
    
    
    @future  (callout=true)
    public static void SupplierQBOUpsertFuture(List<Id> scope)
    {
        List<Account> accounts = [SELECT ABN__c,AccountNumber,AccountSource,BillingAddress,BillingCity
                                      ,BillingCountry,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude
                                      ,BillingPostalCode,BillingState,BillingStreet,CreatedById,CreatedDate
                                      ,Def_Payment_Type__c,Description,First_Date__c,How_did_you_hear_about_us__c
                                      ,Id,Industry,IsCustomerPortal,IsDeleted,Jigsaw,JigsawCompanyId,LastActivityDate
                                      ,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate
                                      ,Majik_AccountNo__c,MasterRecordId,Mobile_Phone__c,Name,NumberOfEmployees
                                      ,OwnerId,ParentId,Phone,PhotoUrl,Primary_Contact__c,QuickBooks_Id__c
                                      ,RecordTypeId,ShippingAddress,ShippingCity,ShippingCountry
                                      ,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState
                                      ,ShippingStreet,SicDesc,SystemModstamp,Trader_Status__c,Trading_Name__c,Type,Website 
                                  FROM Account
                                  WHERE Id IN :scope
                                 ];
       SupplierQBOUpsert(accounts);    
    }
    
    
    // add Trader accounts to QBO
    public static boolean SupplierQBOUpsert(List<Account> scope)
    {
        List<QBO_Payment_Type__mdt> paymentTypes =  [SELECT Label,QBO_Id__c FROM QBO_Payment_Type__mdt];
        Map<String ,String> paymentTypeMap = new Map<String ,String>();
        for (QBO_Payment_Type__mdt pt : paymentTypes)
        {
            paymentTypeMap.put(pt.Label, pt.QBO_Id__c);
        }
  
        System.debug('Supplier to be updated : ' + scope);
   		List<Account> itemsToUpdateWithQBOId = new List<Account> ();
 
   		QBOCRUDHelper crudHelper = new QBOCRUDHelper();
   		for (Account so : scope)
   		{
             System.debug('current Account val : ' + so);

   			Supplier supplier = new Supplier();
			if (so.Majik_AccountNo__c != null)
			{
				supplier.CompanyName =  so.Majik_AccountNo__c ;
			}

			
			supplier.TaxIdentifier = so.ABN__c;
			supplier.DisplayName = so.Name ;
            Supplier.PrimaryPhone phone = new Supplier.PrimaryPhone();
            phone.FreeFormNumber = so.Phone;
            supplier.PrimaryPhone = phone  ; 
            
            
            Supplier.BillAddr billAddr = new Supplier.BillAddr();
            billAddr.Line1 = so.BillingStreet;
            billAddr.City = so.BillingCity;
            billAddr.CountrySubDivisionCode = so.BillingCountry  + ' ' + so.BillingState;
            billAddr.PostalCode = so.BillingPostalCode ;
            
            supplier.BillAddr = billAddr  ; 
			SupplierResponse supplierResp;
           
            //string paymentType =  (String)paymentTypeMap.get(so.Def_Payment_Type__c );

            if (so.QuickBooks_Id__c  == null){
                System.debug('NEW system.JSON.serialize(supplier, true): ' + system.JSON.serialize(supplier, true));
   				 supplierResp = (SupplierResponse)crudHelper.upsertData( 'vendor?minorversion=4',  system.JSON.serialize(supplier, true) , SupplierResponse.Class);
            }else{
                supplier.Id =  so.QuickBooks_Id__c ;
                // need to get syncTocken
                supplierResp = (SupplierResponse)crudHelper.read( 'vendor', so.QuickBooks_Id__c , SupplierResponse.class);
                System.debug('READ supplierResp: ' + supplierResp);
                supplier.SyncToken = supplierResp.Vendor.SyncToken;
                System.debug('UPDATE system.JSON.serialize(customer, true): ' + system.JSON.serialize(supplier, true));
                supplierResp = (SupplierResponse)crudHelper.upsertData( 'vendor?operation=update&minorversion=4',  system.JSON.serialize(supplier, true) , SupplierResponse.class);
            }
			System.debug('Quick books response : ' + supplierResp);
            System.debug('current object val : ' + so.QuickBooks_Id__c);
            
            


   			if (so.QuickBooks_Id__c == null)
   			{
   				Account acct = new Account(id=so.id,QuickBooks_Id__c=supplierResp.Vendor.Id);   			
   				itemsToUpdateWithQBOId.add(acct);
   			}
   		}

   		if(itemsToUpdateWithQBOId.size()>0)
   			Update itemsToUpdateWithQBOId;
        
        return true;//add handle exceptions and put value in a log
        
    }  
       
        
}