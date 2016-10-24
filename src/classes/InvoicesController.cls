public without sharing class InvoicesController {
    @AuraEnabled
    public static String getCustomerReference(){
        
        String customerRef = [SELECT QuickBooks_Id__c FROM Account
                    WHERE ID in
                    (SELECT AccountId FROM User WHERE Id = :userinfo.getUserId())].QuickBooks_Id__c;
        system.debug('xxxxxx: ' + customerRef);
        return customerRef;
    }
    
    
    @AuraEnabled
    public static List<QBOInvoice> getInvoices() {
        
        
        QBOCRUDHelper crudHelper = new QBOCRUDHelper();
        
        String customerRef = InvoicesController.getCustomerReference();
        //  '005p0000000uK5d'
        String queryString = 'select Id,DocNumber,TxnDate,DueDate,TotalAmt,Balance from INVOICE where CustomerRef =\'' + String.escapeSingleQuotes(customerRef)+'\' OrderBy TxnDate DESC';
        
        System.debug('InvoicesController queryString :' + queryString);
        
        //QBOInvoiceList qbo = new QBOInvoiceList();
        
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
            List<QBOInvoice> invs = ((QBOInvoiceList)res).queryResponse.invoice;
            List<QBOInvoice> invsToShow = new List<QBOInvoice>();
            for (QBOInvoice item : invs)
            {
                if(Date.today() > Date.valueOf(item.DueDate.substring(0,10)) && item.Balance > 0)
                {
                    item.overdue = true; 
                }
                invsToShow.add(item);
            }
            return invsToShow;
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