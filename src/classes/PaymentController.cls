public class PaymentController {

    public QBOPaymentResponse paymentResponse {get;set;}
    public String paymentMethod {get;set;}
    public String paymentDate{get;set;}
    List<QBOPaymentResponse.Line> lines {get;set;}
    public string myId {get;set;}
    public Account account {get;set;}
    
    public PaymentController(ApexPages.StandardController controller){
        try{
            QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        	myId = ApexPages.currentPage().getParameters().get('paymentRef');
        	String accountId = ApexPages.currentPage().getParameters().get('accountId');
            Object response = crudHelper.read('payment', myId, QBOPaymentResponse.class);
            if (response instanceof QBOError)
            {
                //log the error and move to next account
                system.debug('Opp error :');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error , 'Oops! We could not load your record.'); 
                ApexPages.addMessage(myMsg); 
            }
            else
            {
                paymentResponse = (QBOPaymentResponse)response;
                if(accountId != null){
                    Account[] accounts = [SELECT Id, 
                       Name, 
                       Majik_AccountNo__c,
                       AccountNumber, 
                       BillingCity, 
                       BillingCountry, 
                       BillingPostalCode, 
                       BillingState, 
                       BillingStreet  
                       FROM Account 
                       WHERE Id = :accountId];
                    if(accounts.size() > 0){
                        Account = accounts[0];
                    }
                }
                
                
                if(paymentResponse.Payment.PaymentMethodRef != null){
                    QBO_Payment_Type__mdt[] paymentTypes = [Select QBO_Id__c, DeveloperName From QBO_Payment_Type__mdt Where QBO_Id__c = :paymentResponse.Payment.PaymentMethodRef.value];
                    if(paymentTypes.size()>0){
                	paymentMethod = paymentTypes[0].DeveloperName;    
                    }else{
                        paymentMethod = 'EFT';
                    }
                }else{
                    paymentMethod = 'EFT';
                }
                String[] strDate = paymentResponse.Payment.TxnDate.split('-');
                String myIntYear = strDate[0];
                String myIntMonth = strDate[1];
                String myIntDate = strDate[2];
                paymentDate = String.format('{0}-{1}-{2}', new String[]{myIntDate,myIntMonth,myIntYear});
                lines = paymentResponse.Payment.Line;
            }
        }
        catch(Exception ex){
                ApexPages.addMessages(ex);
            system.debug(''+ex);
        }
    }
    
    public List<QBOPaymentResponse.Line> getLines() {
        return lines;
    }
}