public class ViewPdfController {
   
    public String pdf {
        get {
            String objectType = ApexPages.currentPage().getParameters().get('objectType');
            String invoiceId = ApexPages.currentPage().getParameters().get('invoiceId');
            QBOCRUDHelper crudHelper = new QBOCRUDHelper();
            blob result = crudHelper.pdf1('invoice', '735'); 
            
            return EncodingUtil.Base64Encode(result);
        }
    }
    
    public blob pdfblob {
        get {
            QBOCRUDHelper crudHelper = new QBOCRUDHelper();
            blob result = crudHelper.pdf1('invoice', '735'); 
            
            return result;
        }
    }
}