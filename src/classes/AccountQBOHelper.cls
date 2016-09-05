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
                                      ,OwnerId,ParentId,Phone,PhotoUrl,Primary_Contact__c,
                                      Primary_Contact__r.Salutation,Primary_Contact__r.FirstName,Primary_Contact__r.MiddleName, 
                                      Primary_Contact__r.LastName,Primary_Contact__r.Suffix,  
                                      Primary_Contact__r.Email,QuickBooks_Id__c
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
            else// new change
            {
               customer.CompanyName =  ''; 
            }

			
			customer.PrimaryTaxIdentifier = so.ABN__c;
			customer.DisplayName = so.Name ;
            QBOCustomer.Phone phone = new QBOCustomer.Phone();
            phone.FreeFormNumber = so.Phone;
            customer.PrimaryPhone = phone  ;
            
            // Name details
            customer.Title = so.Primary_Contact__r.Salutation;
            customer.GivenName = so.Primary_Contact__r.FirstName;
            customer.MiddleName = so.Primary_Contact__r.MiddleName;
            customer.FamilyName = so.Primary_Contact__r.LastName;
            customer.Suffix = so.Primary_Contact__r.Suffix;
            
            // mobile
            QBOCustomer.Phone mobile = new QBOCustomer.Phone();
            mobile.FreeFormNumber = so.Mobile_Phone__c;
            customer.Mobile = mobile  ; 
            
            //Primary EmailAddress
            QBOCustomer.PrimaryEmailAddr pEmail = new QBOCustomer.PrimaryEmailAddr();
            pEmail.Address = so.Primary_Contact__r.Email;
            customer.PrimaryEmailAddr = pEmail  ; 
            
            //WebAddress
            QBOCustomer.WebAddr webAddress = new QBOCustomer.WebAddr();
            webAddress.URI = so.Website;
            customer.WebAddr = webAddress  ; 
        
            
            // Billing Address
            QBOCustomer.Address billAddr = new QBOCustomer.Address();
            billAddr.Line1 = so.BillingStreet;
            billAddr.City = so.BillingCity;
            billAddr.CountrySubDivisionCode =  so.BillingState;
            billAddr.country = so.BillingCountry;
            billAddr.PostalCode = so.BillingPostalCode ;            
            customer.BillAddr = billAddr  ;
            
            //Shipping Address
            QBOCustomer.Address ShipAddr = new QBOCustomer.Address();
            ShipAddr.Line1 = so.ShippingStreet;
            ShipAddr.City = so.ShippingCity;
            ShipAddr.CountrySubDivisionCode =  so.ShippingState;
            ShipAddr.PostalCode = so.ShippingPostalCode  ;            
            ShipAddr.country = so.ShippingCountry ;
            customer.ShipAddr = ShipAddr;
            
            
            
         
            
			QBOCustomerResponse customerResponse;
           
            string paymentType =  (String)paymentTypeMap.get(so.Def_Payment_Type__c );
            Object response;
            QBOCustomer.PaymentMethodRef paymentMethodRef = new QBOCustomer.PaymentMethodRef();
            if (paymentType != null && paymentType != '')
            {
                paymentMethodRef.value = paymentType;
                customer.PaymentMethodRef =  paymentMethodRef;
            }

            if (so.QuickBooks_Id__c  == null){
                System.debug('NEW system.JSON.serialize(customer, true): ' + system.JSON.serialize(customer, true));
                response = crudHelper.upsertData( 'customer?minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
                if (response instanceof QBOError){
                    //log the error and move to next account
                    ErrorLogHelper.LogAccountError(so, (QBOError)response);
                    continue;
                }else{
                    customerResponse = (QBOCustomerResponse)response;//crudHelper.upsertData( 'customer?minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
                }
                 
   				 
            }else{
                customer.Id =  so.QuickBooks_Id__c ;
                // need to get syncTocken
                customerResponse = (QBOCustomerResponse)crudHelper.read( 'customer', so.QuickBooks_Id__c , QBOCustomerResponse.class);
                System.debug('READ customerResponse: ' + customerResponse);
                customer.SyncToken = customerResponse.Customer.SyncToken;
                System.debug('UPDATE system.JSON.serialize(customer, true): ' + system.JSON.serialize(customer, true));
                //customerResponse = (QBOCustomerResponse)crudHelper.upsertData( 'customer?operation=update&minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
            
            	response = crudHelper.upsertData( 'customer?operation=update&minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
                if (response instanceof QBOError){
                    //log the error and move to next account
                    ErrorLogHelper.LogAccountError(so, (QBOError)response);
                    continue;
                }else{
                    customerResponse = (QBOCustomerResponse)response;//crudHelper.upsertData( 'customer?minorversion=4',  system.JSON.serialize(customer, true) , QBOCustomerResponse.class);
                }
            
            
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
                                      ,OwnerId,ParentId,Phone,PhotoUrl,Primary_Contact__c,
                                      Primary_Contact__r.Salutation,Primary_Contact__r.FirstName,Primary_Contact__r.MiddleName, 
                                      Primary_Contact__r.LastName,Primary_Contact__r.Suffix, 
                                      Primary_Contact__r.Email,QuickBooks_Id__c
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
            else// new change
            {
               supplier.CompanyName =  ''; 
            }
			
			supplier.TaxIdentifier = so.ABN__c;
			supplier.DisplayName = so.Name ;
            Supplier.PrimaryPhone phone = new Supplier.PrimaryPhone();
            phone.FreeFormNumber = so.Phone;
            supplier.PrimaryPhone = phone  ;
            
             // Name details
            supplier.Title = so.Primary_Contact__r.Salutation;
            supplier.GivenName = so.Primary_Contact__r.FirstName;
            supplier.MiddleName = so.Primary_Contact__r.MiddleName;
            supplier.FamilyName = so.Primary_Contact__r.LastName;
            supplier.Suffix = so.Primary_Contact__r.Suffix;
            
             // mobile
            Supplier.PrimaryPhone mobile = new Supplier.PrimaryPhone();
            mobile.FreeFormNumber = so.Mobile_Phone__c;
            Supplier.Mobile = mobile;
            
            //Primary EmailAddress
            Supplier.PrimaryEmailAddr pEmail = new Supplier.PrimaryEmailAddr();
            pEmail.Address = so.Primary_Contact__r.Email;
            Supplier.PrimaryEmailAddr = pEmail  ;
            
            //WebAddress
            Supplier.WebAddr webAddress = new Supplier.WebAddr();
            webAddress.URI = so.Website;
            Supplier.WebAddr = webAddress  ;
            
             //Shipping Address
            Supplier.ShipAddr ShipAddr = new Supplier.ShipAddr();
            ShipAddr.Line1 = so.ShippingStreet;
            ShipAddr.City = so.ShippingCity;
            ShipAddr.CountrySubDivisionCode = so.ShippingState;
            ShipAddr.country = so.ShippingCountry;
            ShipAddr.PostalCode = so.ShippingPostalCode  ;            
            Supplier.ShipAddr = ShipAddr;
            
            //billing
            Supplier.BillAddr billAddr = new Supplier.BillAddr();
            billAddr.Line1 = so.BillingStreet;
            billAddr.City = so.BillingCity;
            billAddr.CountrySubDivisionCode =    so.BillingState;
            billAddr.country = so.BillingCountry;
            billAddr.PostalCode = so.BillingPostalCode ;
            
            supplier.BillAddr = billAddr  ; 
			SupplierResponse supplierResp;
            Object response;
            //string paymentType =  (String)paymentTypeMap.get(so.Def_Payment_Type__c );

            if (so.QuickBooks_Id__c  == null){
                System.debug('NEW system.JSON.serialize(supplier, true): ' + system.JSON.serialize(supplier, true));
   				//supplierResp = (SupplierResponse)crudHelper.upsertData( 'vendor?minorversion=4',  system.JSON.serialize(supplier, true) , SupplierResponse.Class);

                response = crudHelper.upsertData( 'vendor?minorversion=4',  system.JSON.serialize(supplier, true) , SupplierResponse.Class);
                if (response instanceof QBOError){
                    //log the error and move to next account
                    ErrorLogHelper.LogAccountError(so, (QBOError)response);
                    continue;
                }else{
                    supplierResp = (SupplierResponse)response;
                }
            }else{
                supplier.Id =  so.QuickBooks_Id__c ;
                // need to get syncTocken
                supplierResp = (SupplierResponse)crudHelper.read( 'vendor', so.QuickBooks_Id__c , SupplierResponse.class);
                System.debug('READ supplierResp: ' + supplierResp);
                supplier.SyncToken = supplierResp.Vendor.SyncToken;
                System.debug('UPDATE system.JSON.serialize(customer, true): ' + system.JSON.serialize(supplier, true));
                //supplierResp = (SupplierResponse)crudHelper.upsertData( 'vendor?operation=update&minorversion=4',  system.JSON.serialize(supplier, true) , SupplierResponse.class);
                
                response = crudHelper.upsertData( 'vendor?operation=update&minorversion=4',  system.JSON.serialize(supplier, true) , SupplierResponse.class);
                if (response instanceof QBOError){
                    //log the error and move to next account
                    ErrorLogHelper.LogAccountError(so, (QBOError)response);
                    continue;
                }else{
                    supplierResp = (SupplierResponse)response;
                }
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