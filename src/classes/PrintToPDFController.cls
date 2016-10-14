public class PrintToPDFController {

    public String orderId {get;set;}
    public List<OrderItem> orderItems {get;set;}
    public PrintToPDFController(ApexPages.StandardController controller){
        orderId = ApexPages.currentPage().getParameters().get('Id');
        orderItems = [SELECT PricebookEntry.Product2.Name,Stall__r.Name,Date__c,Description,Quantity,
                                      UnitPrice,Formula_Total__c, Total__c
                                      FROM OrderItem 
        							  WHERE Order.Id = :orderId];
        
        /*for(OrderItem oi : orderItems){
            
        }*/
    }
    /*TotalPrice
    public String orderId {get;set;}
    public PrintToPDFController() {
        orderId = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public String PrintableView {
        get{
        Id myid = ApexPages.currentPage().getParameters().get('Id');
        String html = new PageReference('/' + myid + '/p').getContent().toString();
        System.debug('Yay '+html.substringAfter('</head>').substringBefore('</html>'));
        return html.substringAfter('</head>').substringBefore('</html>');
        }
    }
	*/

}