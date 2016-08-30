public with sharing class QBOInvoiceList {
	public QBOInvoiceList() {
		
	}

	public class QueryResponse
	{
    	@AuraEnabled
	    public List<QBOInvoice> invoice;
        @AuraEnabled
	    public Integer startPosition;
        @AuraEnabled
	    public Integer maxResults;
	}	

    @AuraEnabled
    public QueryResponse queryResponse;
}