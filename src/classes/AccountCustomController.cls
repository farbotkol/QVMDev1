public with sharing class AccountCustomController {

	public ApexPages.StandardController myAccountController {get; set;}
	public Account Account {get; set;}
	
	public ApexPages.StandardController myUserController {get; set;}
	public User User {get; set;}
	
	public ApexPages.StandardController standardContactController;
		
	public AccountCustomController(ApexPages.StandardController cntrl) {
		
		standardContactController = cntrl;
		
		Case con = (Case)cntrl.getRecord();
		Account = [select Name from Account where id = :con.AccountId][0];
		User = [select FirstName from User where id=:con.OwnerId][0];
		
		myAccountController = new ApexPages.StandardController(Account);
		myUserController = new ApexPages.StandardController(User);
	}
	public pageReference doSaveAll() {
        standardContactController.save();
		myAccountController.save();
		myUserController.save();
		return null;
	}
}