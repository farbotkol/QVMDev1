public with sharing class AccountBusinessStallsListingExt 
{

    private final Opportunity accountBusiness;

    public Id aStall {get;set;}
    public Boolean monday {get;set;}
    public Boolean tuesday {get;set;}
    public Boolean wednesday {get;set;}
    public Boolean thursday {get;set;}
    public Boolean friday {get;set;}
    public Boolean saturday {get;set;}
    public Boolean sunday {get;set;}
    public String day {get;set;}


    public AccountBusinessStallsListingExt(ApexPages.StandardController stdController) 
    {
        this.accountBusiness = (Opportunity)stdController.getRecord();


     
    }


    public List<Stall__c> getStallsFromQuery()
    {
       return [SELECT FridayTrader__c,MondayTrader__c,Name,SaturdayTrader__c
                                        ,SundayTrader__c,ThursdayTrader__c,TuesdayTrader__c,WednesdayTrader__c FROM Stall__c
                                where MondayTrader__c=  :accountBusiness.Id    or
                                TuesdayTrader__c=   :accountBusiness.Id    or
                                WednesdayTrader__c =    :accountBusiness.Id    or
                                ThursdayTrader__c=  :accountBusiness.Id    or
                                FridayTrader__c =   :accountBusiness.Id    or
                                SaturdayTrader__c =  :accountBusiness.Id    or
                                SundayTrader__c =  :accountBusiness.Id]; 

    }


    public List<Stall__c> getPermStallsFromQuery()
    {
       return [SELECT Id, Name, Annual_Rent__c,Area_Square_Meters__c ,IsActive__c FROM Stall__c
                                where Tenant__c = :accountBusiness.Id]; 

    }


    public PageReference Add()
    {

        aStall = accountBusiness.Stall__c;

        if ( accountBusiness.Stall__c != null) 
        {

            Stall__c stall = [SELECT FridayTrader__c,MondayTrader__c,Name,SaturdayTrader__c
                                    ,SundayTrader__c,ThursdayTrader__c,TuesdayTrader__c,WednesdayTrader__c FROM Stall__c
                              WHERE  id = :aStall];

            if (stall != null)
            {
                if(stall.MondayTrader__c == null && monday == true)
                {
                    stall.MondayTrader__c = this.accountBusiness.Id;
                }
                if(stall.TuesdayTrader__c == null && tuesday == true)
                {
                    stall.TuesdayTrader__c = this.accountBusiness.Id;
                }
                if(stall.WednesdayTrader__c == null && wednesday == true)
                {
                    stall.WednesdayTrader__c = this.accountBusiness.Id;
                }
                if(stall.ThursdayTrader__c == null && thursday == true)
                {
                    stall.ThursdayTrader__c = this.accountBusiness.Id;
                }
                if(stall.FridayTrader__c == null && friday == true)
                {
                    stall.FridayTrader__c = this.accountBusiness.Id;
                }
                if(stall.SaturdayTrader__c == null && saturday == true)
                {
                    stall.SaturdayTrader__c = this.accountBusiness.Id;
                }
                if(stall.SundayTrader__c == null && sunday == true)
                {
                    stall.SundayTrader__c = this.accountBusiness.Id;
                }
            }

            Update stall;
        
            ResetUpdater();
        }    

        return null;
    }

    public PageReference AddPerm()
    {

        aStall = accountBusiness.Perm_Stall__c;

        if ( accountBusiness.Perm_Stall__c != null) 
        {

            Stall__c stall = [SELECT Name, Tenant__c , Id FROM Stall__c
                              WHERE  id = :aStall];

            if (stall != null)
            {
                stall.Tenant__c = this.accountBusiness.Id;               
            }

            Update stall;
        
            ResetUpdater();
        }    

        return null;
    }

    public void UpdateStall()
    {
        //aStall = accountBusiness.Stall__c;

        Stall__c stall = [SELECT FridayTrader__c,MondayTrader__c,Name,SaturdayTrader__c
                                ,SundayTrader__c,ThursdayTrader__c,TuesdayTrader__c,WednesdayTrader__c FROM Stall__c
                          WHERE  id = :aStall];

        if (stall != null)
        {
            if (day == 'Sunday' && stall.SundayTrader__c == null )
            {
                stall.SundayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'Sunday' && stall.SundayTrader__c == this.accountBusiness.Id ){

                stall.SundayTrader__c = null ;
            }
            if (day == 'saturday' && stall.SaturdayTrader__c == null )
            {
                stall.SaturdayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'Saturday' && stall.SaturdayTrader__c == this.accountBusiness.Id ){

                stall.SaturdayTrader__c = null ;
            }
            if (day == 'Friday' && stall.FridayTrader__c == null )
            {
                stall.FridayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'Friday' && stall.FridayTrader__c == this.accountBusiness.Id ){

                stall.FridayTrader__c = null ;
            }
            if (day == 'Thursday' && stall.ThursdayTrader__c == null )
            {
                stall.ThursdayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'Thursday' && stall.ThursdayTrader__c == this.accountBusiness.Id ){

                stall.ThursdayTrader__c = null ;
            }
            if (day == 'wednesday' && stall.WednesdayTrader__c == null )
            {
                stall.WednesdayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'wednesday' && stall.WednesdayTrader__c == this.accountBusiness.Id ){

                stall.WednesdayTrader__c = null ;
            }
            if (day == 'tuesday' && stall.TuesdayTrader__c == null )
            {
                stall.TuesdayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'tuesday' && stall.TuesdayTrader__c == this.accountBusiness.Id ){

                stall.TuesdayTrader__c = null ;
            }
            if (day == 'monday' && stall.MondayTrader__c == null )
            {
                stall.MondayTrader__c = this.accountBusiness.Id ;

            }else if (day == 'monday' && stall.MondayTrader__c == this.accountBusiness.Id ){

                stall.MondayTrader__c = null ;
            }
        }
        update stall;

        
    }


    public void SetOppStall(Stall__c stall)
    {
        accountBusiness.Stall__c = stall.Id;
    } 

    public void SetPermOppStall(Stall__c stall)
    {
        accountBusiness.Perm_Stall__c = stall.Id;
    } 

    public void ResetUpdater()
    {
        accountBusiness.Stall__c = null;
        accountBusiness.Perm_Stall__c = null;
        monday = null;
        tuesday = null;
        wednesday = null;
        thursday = null;
        friday = null;
        saturday = null;
        sunday = null;
    } 
   
   
}