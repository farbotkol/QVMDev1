public class StallMapController {
    
    
    public String getbuildTable(){
        
        String tmp;
        
        List<Stall__c> stalls = [SELECT Name,Height__c,Left__c,Line_Height__c,Top__c,Width__c,FridayTrader__r.Permitted_Use__c FROM Stall__c 
                                 WHERE RecordType.Name = 'Casual'];
        
        
        tmp = '<div class=\'floorplan\'>';
        For (integer i = 0; i <stalls.size(); i++){
            String permittedUse = stalls.get(i).FridayTrader__r.Permitted_Use__c;
            System.debug('YY Permitted Use '+permittedUse);
            if(permittedUse != null){
                if(permittedUse.equals('Apparel')){
                    tmp += '<a class=\'room\' style=\' background-color: #FF0000; width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                        'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\'>' +
                        stalls.get(i).Name +'</a>' ;
                }
                else{
                    tmp += '<a class=\'room\' style=\' background-color: #FFFF00; width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                        'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\'>' +
                        stalls.get(i).Name +'</a>' ;                
                }
            }
            else{
                tmp += '<a class=\'room\' style=\' width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                    'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\'>' +
                    stalls.get(i).Name +'</a>' ;
            }
        }
        
        tmp += '</div>';
        System.debug('TABLE '+tmp);
        return tmp;
    }
}