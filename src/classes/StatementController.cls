public class StatementController {
    
    public String total {get;set;}
    public String customerName {get;set;}
    public String reportDate {get;set;}
    List<QBOStatement> statements;
    
    
    public  StatementController(ApexPages.StandardController controller)
    {
        
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        String customerRef = ApexPages.currentPage().getParameters().get('customerRef');
        if(customerRef != null){
            try{
                Object res =  crudHelper.report('CustomerBalanceDetail','customer=' + String.escapeSingleQuotes(customerRef) +'&arpaid=All&sort_by=tx_date&sort_order=descend',QBOCustomerBalanceDetail.class); 
                
                if (res instanceof QBOError)
                { 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error , 'Oops! We could not load your record.'); 
                    ApexPages.addMessage(myMsg); 
                }
                else 
                {
                    QBOCustomerBalanceDetail theReport = (QBOCustomerBalanceDetail)res; 
                    System.debug('theReport : '+theReport);
                    customerName = theReport.Rows.Row[0].Header.ColData[0].value;
                    total = theReport.Rows.Row[0].Summary.ColData[4].value;
                    reportDate = theReport.Header.Option[0].Value;
                    List<QBOCustomerBalanceDetail.Row> rows = theReport.Rows.Row[0].Rows.Row;
                    List<QBOStatement> listStatements = new List<QBOStatement>();
                    Integer i;
                    for(i=0;i<rows.size();i++){
                        listStatements.add(QBOStatement.getQBOStatementFromJSON(rows[i]));				
                    }
                    statements =  listStatements;
                }
            }
            catch(Exception e){
                ApexPages.addMessages(e);
            }
        }
    }
    
    public  List<QBOStatement> getStatements() {
        
        return statements;
    }
}