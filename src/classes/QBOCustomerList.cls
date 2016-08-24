public with sharing class QBOCustomerList {
	public QBOCustomerList() {
		
	}

	public class QueryResponse
	{
    
	    public List<QBOCustomer> Customer;
	    public Integer startPosition;
	    public Integer maxResults;
	}	

   
    public QueryResponse queryResponse;
    //public Date time;

}