//the extension 
public with sharing class ApiConnectController extends CustomController {

	 public String getTitle(){
        if (oauthConfig==null){
            return 'Bad request';
        }
        return oauthConfig.getApiDescription();
    }
    private final PageReference currentPage;
    private OAuth1.IConfiguration oauthConfig;
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public ApiConnectController() {
       this.currentPage =  ApexPages.currentPage();
    }

    public PageReference init(){
       
      return null;

    }

    
}