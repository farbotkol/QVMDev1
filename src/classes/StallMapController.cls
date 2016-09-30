public class StallMapController {
    
    @RemoteAction
    public static void UpdateAttributes(){
        String stallid = ApexPages.CurrentPage().getParameters().get('stallid');
		String width = ApexPages.CurrentPage().getParameters().get('width');
        String height = ApexPages.CurrentPage().getParameters().get('height');
        String left = ApexPages.CurrentPage().getParameters().get('left');
        String top = ApexPages.CurrentPage().getParameters().get('top');
        
        Stall__c stall = [SELECT Height__c,Id,Left__c,Line_Height__c,Top__c,Width__c FROM Stall__c where Id = :stallid];
        
        if (height == '') 
            height = '10px';
        if (width == '') 
            width = '10px';
        if (left == '') 
            left = '0px';
        if (top == '') 
            top = '0px';
        
        stall.Height__c = double.valueOf(height.remove('px')).intValue() ; 
        stall.Line_Height__c = double.valueOf(height.remove('px')).intValue() ; 
        stall.Width__c = double.valueOf(width.remove('px')).intValue();
        stall.Left__c = double.valueOf(left.remove('px')).intValue();
        stall.Top__c = double.valueOf(top.remove('px')).intValue();
        update stall;
        
        
        return ;
        
    }
    
    public String getbuildTable(){
        
        String tmp;
        
        List<Stall__c> stalls = [SELECT Name,Height__c,Left__c,Line_Height__c,Top__c,Width__c,FridayTrader__r.Permitted_Use__c FROM Stall__c 
                                 WHERE RecordType.Name = 'Casual' ];
        
        
        tmp = '<div class=\'floorplan\' id=\'dropzone\'>';
        For (integer i = 0; i <stalls.size(); i++){
            String permittedUse = stalls.get(i).FridayTrader__r.Permitted_Use__c;
            System.debug('YY Permitted Use '+permittedUse);
            if(permittedUse != null){
                if(permittedUse.equals('Apparel')){
                    tmp += '<a class=\'room draggable js-drag\' style=\' background-color: #FF0000; width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                        'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\'  data-x='+stalls.get(i).Left__c+' data-y='+stalls.get(i).Top__c+' id='+stalls.get(i).id+'>' +
                        stalls.get(i).Name +'</a>' ;
                }
                else{
                    tmp += '<a class=\'room draggable js-drag\' style=\' background-color: #FFFF00; width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                        'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\' data-x='+stalls.get(i).Left__c+' data-y='+stalls.get(i).Top__c+' id='+stalls.get(i).id+'>' +
                        stalls.get(i).Name +'</a>' ;                
                }
            }
            else{
                tmp += '<a class=\'room draggable js-drag\' style=\' width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                    'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\' data-x='+stalls.get(i).Left__c+' data-y='+stalls.get(i).Top__c+' id='+stalls.get(i).id+'>' +
                    stalls.get(i).Name +'</a>' ;
            }
        }
        
        tmp += '</div>';
         System.debug('TABLE '+tmp);
        return tmp;
    }
    

}