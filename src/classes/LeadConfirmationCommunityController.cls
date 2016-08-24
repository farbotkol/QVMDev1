public with sharing class LeadConfirmationCommunityController
{
 	String urlVal;
	public LeadConfirmationCommunityController()
    {
		
	}
	public PageReference doContinue()
	{
		 PageReference pr = new PageReference('http://developer-qvm.cs31.force.com/ApplicationSubmission');
	     pr.setRedirect(true);
	     return pr;
		
    }
}