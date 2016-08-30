public without sharing class InvoicesController {
    @AuraEnabled
    public static List<QBOInvoice> getInvoices() {
        
        
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        
        String customerRef = [SELECT QuickBooks_Id__c FROM Account
     				WHERE ID in
     				(SELECT AccountId FROM User WHERE Id = '005p0000000uK5d')].QuickBooks_Id__c;
        // : userinfo.getUserId()
        String queryString = 'select Id,DocNumber,TxnDate,DueDate,TotalAmt,Balance from INVOICE where CustomerRef =\'' + String.escapeSingleQuotes(customerRef)+'\'';
        
        System.debug(queryString);
        
        QBOInvoiceList qbo = new QBOInvoiceList();
        
        Object res =  crudHelper.query(queryString, QBOInvoiceList.Class); 
        
        if (res instanceof QBOError)
        {
            System.debug('error : '  + (QBOError)res); 
            return null;
        }
        else 
        {
            System.debug('Yah!! : '  + (QBOInvoiceList)res); 
            System.debug('PP Yah!! : '  + ((QBOInvoiceList)res).queryResponse.invoice);
            return ((QBOInvoiceList)res).queryResponse.invoice;
        }               
    }
    
    //@AuraEnabled
    /*public static PageReference viewInvoicePDF(String objectType, String invoiceId) {
        
        PageReference viewPdf = new PageReference('/apex/ViewPDF');
        viewPdf.getParameters().put('objectType',objectType);
        viewPdf.getParameters().put('invoiceId',invoiceId);
        viewPdf.setRedirect(true); 
        return viewPdf;
    }*/
    
 
}