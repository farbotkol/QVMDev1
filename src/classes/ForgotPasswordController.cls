/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;}   
       
    public ForgotPasswordController() {}
	
  	public PageReference forgotPassword() {
  		boolean success = Site.forgotPassword(username);
  		PageReference pr = Page.ForgotPasswordConfirm;
  		pr.setRedirect(true);
  		
            System.debug('<>< '+username);
            System.debug('<>< '+success);
            System.debug('<>< '+pr);
  		if (success) {  
  			return pr;
  		}
  		return null;
  	}
}