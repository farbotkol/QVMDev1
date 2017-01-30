public class QBOStatement {
	@AuraEnabled
    public String tx_date {get;set;}
    @AuraEnabled
    public String txn_type {get;set;}
    @AuraEnabled
    public String doc_num {get;set;}
    @AuraEnabled
    public String due_date {get;set;}
    @AuraEnabled
    public String subt_home_amount {get;set;}
    @AuraEnabled
    public String subt_home_open_bal {get;set;}
    @AuraEnabled
    public String rbal_home_open_bal {get;set;}
    @AuraEnabled
    public String accountBusiness {get;set;}
    
    public QBOStatement() {
        
    }
    
    public static QBOStatement getQBOStatementFromJSON(QBOCustomerBalanceDetail.Row row) {
        
        
        system.debug('row:::' + row);
        if(row!=null){
            QBOStatement obj = new QBOStatement();            
            obj.tx_date = row.ColData[0].value;
            obj.txn_type = row.ColData[1].value;
            obj.doc_num = row.ColData[2].value;
            obj.accountBusiness = row.ColData[3].value;
            obj.due_date = row.ColData[4].value;
            obj.subt_home_amount = row.ColData[5].value;
            obj.subt_home_open_bal = row.ColData[6].value;
            obj.rbal_home_open_bal = row.ColData[7].value;
            
            return obj;
        }
        return null;
    }
}