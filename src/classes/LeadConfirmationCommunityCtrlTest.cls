@isTest
public class LeadConfirmationCommunityCtrlTest
{
   @isTest static void checkDoContinue() 
   {
       LeadConfirmationCommunityController newObj = new LeadConfirmationCommunityController();
       PageReference p = newObj.doContinue();
       System.assertNotEquals(p,null);
   }
}