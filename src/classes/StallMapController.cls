public class StallMapController {

    
    public String getbuildTable(){
        
        String tmp;
        
        List<Stall__c> stalls = [SELECT Name,Height__c,Left__c,Line_Height__c,Top__c,Width__c FROM Stall__c 
                                 WHERE RecordType.Name = 'Casual'];
        System.debug('ZZ '+stalls);
        System.debug('ZZ '+stalls.size());
        
        tmp = '<div class=\'floorplan\'>';
        For (integer i = 0; i <stalls.size(); i++){ 
            tmp += '<a class=\'room\' style=\' width:'+stalls.get(i).Width__c+'px; height:'+stalls.get(i).Height__c+
                'px; line-height:'+stalls.get(i).Line_Height__c+'px; top:'+stalls.get(i).Top__c+'px; left:'+stalls.get(i).Left__c+'px;\'>' +
                stalls.get(i).Name +'</a>' ;
        }
        
        tmp += '</div>';
        System.debug('TABLE '+tmp);
        return tmp;
    }
}