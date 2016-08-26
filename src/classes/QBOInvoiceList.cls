public with sharing class QBOInvoiceList {
	public QBOInvoiceList() {
		
	}

	public class QueryResponse
	{
    
	    public List<QBOInvoice> invoice;
	    public Integer startPosition;
	    public Integer maxResults;
	}	

   
    public QueryResponse queryResponse;
}