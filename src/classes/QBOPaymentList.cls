public with sharing class QBOPaymentList {
	public QBOPaymentList() {
		
	}

	public class QueryResponse
	{
    	public List<QBOPaymentResponse.Payment> payment;
	    public Integer startPosition;
	    public Integer maxResults;
	}	

    public QueryResponse queryResponse;
}