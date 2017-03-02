public with sharing class TransitionMapController {
    
    @RemoteAction
    
    public String imageURL{get;set;}
    public Decimal rotationValue{get;set;} //stores rotation decimal value in degrees
    public String rotationValueString{get;set;}	//stores {rotation}deg
    
   
    
    public TransitionMapController() {
        updateURL();
        
    }
     
    
    public static void UpdateAttributes(){
        String stallid = ApexPages.CurrentPage().getParameters().get('stallid');
		String width = ApexPages.CurrentPage().getParameters().get('width');
        String height = ApexPages.CurrentPage().getParameters().get('height');
        String left = ApexPages.CurrentPage().getParameters().get('left');
        String top = ApexPages.CurrentPage().getParameters().get('top');
        
        /*
        String rotation = ApexPages.CurrentPage().getParameters().get('rotation');
        
        Decimal rotationdeg = 0;
        
        if (decimal.valueOf(rotation) != null)
        {
            rotationdeg = decimal.valueOf(rotation);
        }
		*/
        
        TransitionStall__c stall = [SELECT Height__c,Id,Left__c,Line_Height__c,Top__c,Width__c FROM TransitionStall__c where Id = :stallid];
        
        if (height == '') 
            height = '10mm';
        if (width == '') 
            width = '10mm';
        if (left == '') 
            left = '0mm';
        if (top == '') 
            top = '0mm';
        
        stall.Height__c = double.valueOf(height.remove('mm')).intValue() ; 
        stall.Line_Height__c = double.valueOf(height.remove('mm')).intValue() ; 
        stall.Width__c = double.valueOf(width.remove('mm')).intValue();
        stall.Left__c = double.valueOf(left.remove('mm')).intValue();
        stall.Top__c = double.valueOf(top.remove('mm')).intValue();
        //stall.Rotationdeg__c = rotationValue;
        update stall;

        return ;
        
    }
    
    public static void UpdateRotation(){
        String stallid = ApexPages.CurrentPage().getParameters().get('stallidrotation');
        String rotation = ApexPages.CurrentPage().getParameters().get('rotation');
        
        System.debug('STALLID IS: '+stallid);	//stallid is returning null, WHY???
        System.debug('ROTATION IS: '+rotation);
        
        Decimal rotationdeg = 0;
        
        if (rotation == '')		//set rotation to zero if unset 
        {
            rotation = '0';
        }
        rotationdeg = decimal.valueOf(rotation);
        System.debug('ROTATIONDEG IS: '+rotationdeg);
        
        TransitionStall__c[] stall = [SELECT Rotationdeg__c, Id FROM TransitionStall__c where Id = :stallid];		//query not returning any rows
        
        /*
        if (stall[0].Rotationdeg__c == null)
        {
            rotation = '0';
        }
		*/
        
        if (stall.size() > 0)
        {
            stall[0].Rotationdeg__c = rotationdeg;
            System.debug('UPDATING STALL');
            update stall;
        }
        else
        {
            System.debug('STALL LIST IS EMPTY');
        }
        

        return ;
        
    }
    
    public String selectedWeekdayRefresh {get; set;}
    
    /**
     * Returns the select option list of weekdays 
     **/
    public List<SelectOption> getWeekdayRefreshOptions() {
        List<SelectOption> weekdays = new List<SelectOption>();
         weekdays.add(new selectOption('Friday','Friday'));
        weekdays.add(new selectOption('Saturday','Saturday'));
        weekdays.add(new selectOption('Sunday','Sunday'));       
      //  weekdays.add(new selectOption('Mon','Monday'));
        weekdays.add(new selectOption('Tuesday','Tuesday'));
     //   weekdays.add(new selectOption('Wed','Wednesday'));
        weekdays.add(new selectOption('Thursday','Thursday'));

        return weekdays;
    }
    
    public Integer isEditable {get; set;}
    
    public String getbuildTable(){
        
        if(selectedWeekdayRefresh == null)
        {
            selectedWeekdayRefresh= 'Friday';
        }
        String tmp;
               
        List<TransitionStall__c> stalls = [SELECT Name,Height__c,Left__c,Line_Height__c,Top__c,Width__c, Rotationdeg__c, IsActive__c,
                                 FridayTrader__r.Permitted_Use__c,FridayTrader__r.Name, FridayTrader__r.Permitted_Use_Color__c, FridayTrader__r.Permitted_Use_Sub_Category__c,
                                 SaturdayTrader__r.Permitted_Use__c,SaturdayTrader__r.Name,SaturdayTrader__r.Permitted_Use_Color__c, SaturdayTrader__r.Permitted_Use_Sub_Category__c,
                                 SundayTrader__r.Permitted_Use__c,SundayTrader__r.Name,SundayTrader__r.Permitted_Use_Color__c, SundayTrader__r.Permitted_Use_Sub_Category__c,
                                 TuesdayTrader__r.Permitted_Use__c,TuesdayTrader__r.Name,TuesdayTrader__r.Permitted_Use_Color__c, TuesdayTrader__r.Permitted_Use_Sub_Category__c,
                                 ThursdayTrader__r.Permitted_Use__c,ThursdayTrader__r.Name,ThursdayTrader__r.Permitted_Use_Color__c,  ThursdayTrader__r.Permitted_Use_Sub_Category__c
                                 FROM TransitionStall__c 
                                 WHERE RecordType.DeveloperName  = 'Casual' and Height__c <> null ];
        
        
        tmp = '<div class=\'floorplan\' id=\'dropzone\'>';
     	
        For (integer i = 0; i <stalls.size(); i++){
            
            String permittedUse = '';
            String subUse = '';
            String TraderName = '';
            String backColor ='#E2E2E5';
            string textToShowOnStall = '<b>'+stalls.get(i).Name+'</b>';
            String textColor = '#000';
            String rotation='';
            
            if(selectedWeekdayRefresh == 'Friday')
            {
                permittedUse = stalls.get(i).FridayTrader__r.Permitted_Use__c;
                subUse = stalls.get(i).FridayTrader__r.Permitted_Use_Sub_Category__c;
                TraderName = stalls.get(i).FridayTrader__r.Name;
                backColor = stalls.get(i).FridayTrader__r.Permitted_Use_Color__c;    
            }
            else if(selectedWeekdayRefresh == 'Saturday')
            {
                permittedUse = stalls.get(i).SaturdayTrader__r.Permitted_Use__c;
                subUse = stalls.get(i).SaturdayTrader__r.Permitted_Use_Sub_Category__c;
                TraderName = stalls.get(i).SaturdayTrader__r.Name;
                backColor = stalls.get(i).SaturdayTrader__r.Permitted_Use_Color__c;
                
            }
            else if(selectedWeekdayRefresh == 'Sunday')
            {
                permittedUse = stalls.get(i).SundayTrader__r.Permitted_Use__c;
                subUse = stalls.get(i).SundayTrader__r.Permitted_Use_Sub_Category__c;
                TraderName = stalls.get(i).SundayTrader__r.Name;
                backColor = stalls.get(i).SundayTrader__r.Permitted_Use_Color__c;
              
            }
            else if(selectedWeekdayRefresh == 'Tuesday')
            {
                permittedUse = stalls.get(i).TuesdayTrader__r.Permitted_Use__c;
                subUse = stalls.get(i).TuesdayTrader__r.Permitted_Use_Sub_Category__c;
                TraderName = stalls.get(i).TuesdayTrader__r.Name;
                backColor = stalls.get(i).TuesdayTrader__r.Permitted_Use_Color__c;
                 
            }
            else if(selectedWeekdayRefresh == 'Thursday')
            {
                permittedUse = stalls.get(i).ThursdayTrader__r.Permitted_Use__c;
                subUse = stalls.get(i).ThursdayTrader__r.Permitted_Use_Sub_Category__c;
                TraderName = stalls.get(i).ThursdayTrader__r.Name;
                backColor = stalls.get(i).ThursdayTrader__r.Permitted_Use_Color__c;
                
             
            }
            
            if (stalls.get(i).Rotationdeg__c == null)
            {
                rotation = 'rotation0';
                rotationValue = 0;
            }
            else
            {
                rotationValue = stalls.get(i).Rotationdeg__c;
            }
            rotationValueString = rotationValue.toPlainString()+'deg';
            System.debug('ROTATIONVALUESTRING IS '+rotationValueString);
            
            
            System.debug('YY Permitted Use '+permittedUse);
           
            String textToShow = '<h2>'+stalls.get(i).Name+'</h2>';
       		
            /** Checking if stall is active **/
            if (stalls.get(i).IsActive__c){
                
                /** Checking if stall has been assigned to any account business (Checking permittedUse field not to be null) **/
                if(permittedUse != null){
                    
                    textToShow += '<p>'+TraderName+'<br/>'+permittedUse+'<br/>'+subUse+'<br/><a  target="_blank" href="/'+stalls.get(i).id+'" >See more</a></p>';
                    textToShowOnStall += '<br/><span style="font-size:11px;line-height:10px;">'+TraderName+ '<br/>'+subUse+'</span>';
    
                }
                else{
                    textToShow += '<p>No trader assigned for this day.<br/><a  target="_blank" href="/'+stalls.get(i).id+'" >See more</a></p>';
                    backColor = '#767676'; 
                    
                }
            }
            else{
                /** If stall isnot active, make the backColor black **/
                 textToShow += '<p >This stall is not active.<br/><a  target="_blank" href="/'+stalls.get(i).id+'" >See more</a></p>';
                 backColor = '#000'; 
                 textColor ='#767676';
                }
            string draggable = '';
            if (isEditable ==1){
                draggable ='draggable';
            }
            
            /*
            tmp += '<div class=\'ui-widget-content room rotation '+draggable+' resize-drag container \' style=\' background-color:'+ backColor+'; width:'+stalls.get(i).Width__c+'mm; height:'+stalls.get(i).Height__c+
                   'mm;  top:'+stalls.get(i).Top__c+'mm; left:'+stalls.get(i).Left__c+'mm;\'  data-x='+stalls.get(i).Left__c+' data-y='+stalls.get(i).Top__c+' id='+stalls.get(i).id+'>'+
                    '<span class="trigger" style=\' color:'+ textColor+';\'>'+textToShowOnStall+'</span><div id="tooltip"><div class="info">'+textToShow+'</div><a class="close">×</a>	</div></div>' ;
          */
            if (stalls.get(i).IsActive__c){
            tmp += '<div class=\'ui-widget-content room rotation'+stalls.get(i).Rotationdeg__c+' '+draggable+' resize-drag container \' style=\' background-color:'+ backColor+'; width:'+stalls.get(i).Width__c+'mm; height:'+stalls.get(i).Height__c+
                   'mm;  top:'+stalls.get(i).Top__c+'mm; left:'+stalls.get(i).Left__c+'mm;\'  data-x='+stalls.get(i).Left__c+' data-y='+stalls.get(i).Top__c+' id='+stalls.get(i).id+'>'+
                    '<span class="trigger" style=\' color:'+ textColor+';\'>'+textToShowOnStall+'</span><div id="tooltip"><div class="info">'+textToShow+'</div><a class="close">×</a>	</div></div>' ;
            }    
            
            
        }
        /** Adding Legend table **/
        tmp+='<div class=\' legendColor\' ><table >';
        tmp+='<tr><td style="vertical-align: bottom;">Apparel</td><td><div style="background-color:#FF0000;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Hardware</td><td><div   style="background-color:#00FF00;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Botantical</td><td><div   style="background-color:#0000FF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Footwear</td><td><div   style="background-color:#800000;">&nrebsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Fashion Accessories</td><td><div  style="background-color:#FFFF00;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td>';
        tmp+='<tr><td style="vertical-align: bottom;">Paper Products</td><td><div  style="background-color:#808000;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Souvenirs</td><td><div  style="background-color:#008000;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Technology</td><td><div  style="background-color:#00FFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Livestock/Pets</td><td><div  style="background-color:#000080;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Personal Care/Health</td><td><div  style="background-color:#FF00FF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Toys</td><td><div  style="background-color:#800080;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Homewares</td><td><div  style="background-color:#808080;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Materials/Craft Products</td><td><div  style="background-color:#C0C0C0;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Fresh Food</td><td><div style="background-color:#454545;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Prepared Food</td><td><div style="background-color:#454545;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Non-Consumables</td><td><div style="background-color:#999999;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Travel</td><td><div style="background-color:#CD5C5C;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Services</td><td><div style="background-color:#F08080;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Artists-Self Designed and Made</td><td><div style="background-color:#FA8072;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Events</td><td><div style="background-color:#E9967A;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Other</td><td><div style="background-color:#FFA07A;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='<tr><td style="vertical-align: bottom;">Inactive</td><td><div style="background-color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
         tmp+='<tr><td style="vertical-align: bottom;">Not assigned</td><td><div style="background-color:#767676;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>';
        tmp+='</table></div>';
 
        //This is an emty div to calcuate dpi for conversion
        tmp += '</div><div id=\'dpidiv\' style=\'height: 1in; left: -100%; position: absolute; top: -100%; width: 1in;\'></div>';
        
         System.debug('TABLE '+tmp);
        return tmp;
    }
    
 	public pageReference refresh(){
        getbuildTable();
        return null; 
    }
    
	public pageReference edit(){
        isEditable = 1;
         getbuildTable();
        return null;
    }
    
    //File upload code below
    public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }
 
  public void upload() 
  {
 
    document.AuthorId = UserInfo.getUserId();
    
    //Retrieve the id of the shared documents folder
    Folder sharedFolder = [select id from Folder where name='Shared Documents' LIMIT 1];
    document.Name = 'TransitionMapTemplate';
    document.FolderId = sharedFolder.Id; // put it in the shared documents folder
      
    List<document> existingImages = [select id from document where Name='TransitionMapTemplate'];
 	//Delete past map images if a new one is uploaded - effectively overwriting
    if(existingImages.size() > 0)
    {
        delete existingImages;
    }
 
    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      
    } finally {
      document.body = null; // clears the viewstate
      document = new Document();
    }
 
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
      
      updateURL();
   
  }
    
  
    public void updateURL()
    {
        imageURL='/servlet/servlet.FileDownload?file=';
        List< document > documentList=[select name, id from document where 
                                        Name='TransitionMapTemplate'];
    
          if (documentList.size()>0)
          {
              imageURL=imageURL+documentList[documentList.size()-1].id;
          }
     }    

}