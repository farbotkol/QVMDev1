public class StatementController {
    
    public String total {get;set;}
    public String customerName {get;set;}
    public String reportDate {get;set;}
    List<QBOStatement> statements;
    public Account account{get;set;}
        
    public StatementController(ApexPages.StandardController controller)
    {
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        String customerRef = ApexPages.currentPage().getParameters().get('customerRef');
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        account = (Account)controller.getRecord();
        if(account.Majik_AccountNo__c == null){
            system.debug('ID<:' + customerRef);
            system.debug('ID<>:' + account);
            system.debug('ID<><:' + accountId);
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
                account = accounts[0];
            }
        }
        if(customerRef != null){
            try{//sales_cust1
                Object res =  crudHelper.report('CustomerBalanceDetail','customer=' + String.escapeSingleQuotes(customerRef) +'&arpaid=All&sort_by=tx_date&sort_order=descend&columns=tx_date,txn_type,doc_num,due_date,subt_amount,subt_open_bal,rbal_open_bal,sales_cust1',QBOCustomerBalanceDetail.class); 
                
                if (res instanceof QBOError)
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error , 'Oops! We could not load your record.'); 
                    ApexPages.addMessage(myMsg);
                }
                else 
                {
                    QBOCustomerBalanceDetail theReport = (QBOCustomerBalanceDetail)res;                    


                    System.debug('theAccount : ' + account);
                     System.debug('theReport : ' + theReport);
                    customerName = theReport.Rows.Row[0].Header.ColData[0].value;
                    total = theReport.Rows.Row[0].Summary.ColData[4].value;
                    reportDate = formatDate(theReport.Header.Option[0].Value);
                    List<QBOCustomerBalanceDetail.Row> rows = theReport.Rows.Row[0].Rows.Row;
                    List<QBOStatement> listStatements = new List<QBOStatement>();
                    Integer i;
                    for(i=0;i<rows.size();i++){
                        QBOStatement statement = QBOStatement.getQBOStatementFromJSON(rows[i]);
                        //Note: This is shit. If you want to debug you need to remove one of these lines.
                        //If you can figure out why that works then tell S alesforce to sort their life out.
                        //If its my fault. I will be long gone SUCKER!!!
                        //Works in the Tests? What is this!
                        statement.tx_date = formatDate(statement.tx_date);
                        statement.due_date = formatDate(statement.due_date);
                      
                        listStatements.add(statement);
                    }
                    statements = listStatements;
                }
            }
            catch(Exception e){
                ApexPages.addMessages(e);
            }
        }
    }
    
    public String formatDate(String oldDate){
                String[] strDate = oldDate.split('-');
                String myIntYear = strDate[0];
                String myIntMonth = strDate[1];
                String myIntDate = strDate[2];
                return String.format('{0}-{1}-{2}', new String[]{myIntDate,myIntMonth,myIntYear});
    }
    
    public  List<QBOStatement> getStatements() {
        return statements;
    }
}