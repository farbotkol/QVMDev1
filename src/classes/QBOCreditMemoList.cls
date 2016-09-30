public class QBOCreditMemoList {
    public QBOCreditMemoList() {
        
    }

    public class QueryResponse
    {
        @AuraEnabled
        public List<QBOInvoice> CreditMemo;
        @AuraEnabled
        public Integer startPosition;
        @AuraEnabled
        public Integer maxResults;
    }   

    @AuraEnabled
    public QueryResponse queryResponse;
}