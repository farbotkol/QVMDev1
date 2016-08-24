@isTest
private class HttpClientTests {
   

    @isTest
    static void getContentTypeNoHeader() {
    	HttpRequest request = new HttpRequest();
        //no header
        TestHelpers.assertContentType('',HttpClient.getContentType(request));
        
    }
  
    @isTest
    static void getContentTypeEmptyValue() {
    	HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', '');
        //has header, value is empty
        TestHelpers.assertContentType('',HttpClient.getContentType(request));

    }
    @isTest
    public static void getContentTypeSimple() {
    	HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        TestHelpers.assertContentType('application/json',HttpClient.getContentType(request));
    }
}