/**
* An apex page controller that takes the user to the right start page based on credentials or lack thereof
*/
@IsTest global with sharing class CommunitiesTest {
    @IsTest(SeeAllData=true) global static void testCommunitiesLandingController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        PageReference pageRef = controller.forwardToStartPage();
      }
    
    
     @IsTest(SeeAllData=true)
    global static void testCommunitiesLoginController () {
        CommunitiesLoginController controller = new CommunitiesLoginController ();
        PageReference pageRef = controller.forwardToAuthPage();
    }   
    
     @IsTest(SeeAllData=true)
    global static void testLightningLoginFormController () {
        LightningLoginFormController controller = new LightningLoginFormController ();
        Boolean b = LightningLoginFormController.getIsUsernamePasswordEnabled();
        Boolean b2 = LightningLoginFormController.getIsSelfRegistrationEnabled();
        string  s1 = LightningLoginFormController.getSelfRegistrationUrl();
        string  s2 = LightningLoginFormController.getForgotPasswordUrl();    
        string  s3 =  LightningLoginFormController.login('sdfg', 'sdfg', 'sfdh');
        
    }   
}