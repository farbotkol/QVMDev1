public with sharing class QBOCustomerResponse {
	public QBOCustomerResponse() {
		
	}

	@AuraEnabled
	public QBOCustomer Customer {get;set;} 
}