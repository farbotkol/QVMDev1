public class CustomerBalanceVFPController {
    
    private final Account acct;
    
    public CustomerBalanceVFPController(ApexPages.StandardController stdController) {
        System.debug('test');
    }

    public void onLoad()
	{
		System.debug('test');
	}
}