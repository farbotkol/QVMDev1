/*
  **********************************************************************************************
  * @author       : Resmi Ramakrishnan
  * @date         : 23/08/2016
  * @description  : Utility class for test data creation.
  **********************************************************************************************
*/


public without sharing class DataFactoryForTestClass
{

    /*
      * @description       Test method to create a Lead.                       
      * @param             NA 
      * @return            Lead Object
      * @throws            NA
    */  
    public static Lead CreateLead()
    {
        Lead leadRecord = new Lead();
        leadRecord.LastName='TestLastName';
        leadRecord.FirstName='TestFirstName';
        leadRecord.Company='TestCompany';
        leadRecord.Status='New Application';             
        return leadRecord ;   
    }
    
    /*
      * @description       Test method to create a Lead for ApplicationSubmissionExtensionTest class.                       
      * @param             NA 
      * @return            Lead Object
      * @throws            NA
    */  
    public static Lead createLeadForApplicationSubmission()
    {
        Lead leadRecord = new Lead();
        leadRecord.LastName='TestLastName';
        leadRecord.FirstName='TestFirstName';
        leadRecord.Company='TestCompany';
        leadRecord.Status='New Application';             
        return leadRecord ;   
    }
    
    /*
      * @description       This method creates test user for unit testing.                           
      * @param             lastName , profileId, roleId, emailAddress    
      * @return            User - Returns the user object
      * @throws            NA
    */
    public static User createUser(String lastName,Id profileId,String emailAddress)
    {
        User usr = new User(alias = lastName, email= emailAddress,
                            emailencodingkey = Constants.ENCODE_KEY, lastname = lastName,
                            timezonesidkey = Constants.TIME_ZONE,
                            languagelocalekey = Constants.LOCALE_KEY,
                            localesidkey = Constants.LOCALE_KEY, profileid = profileId,
                            username = lastName + System.currentTimeMillis() + Constants.USER_POSTFIX );
        return usr;      
    }    


}