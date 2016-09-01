public with sharing class QBOCRUDHelper {
       
    public QuickBooksConnector qbConnector { get; set; }
    
    public QBOCRUDHelper() {
        qbConnector = new QuickBooksConnector();       
        qbConnector.fixToken();
    }
    
    
    /*
    eg
    QBOCRUDHelper h = new QBOCRUDHelper();
    QBOCustomerList cl = (QBOCustomerList)h.query('select * from Customer', QBOCustomerList.class);
    system.debug('QBOCustomerList: ' + cl);
    */
     public object query(string query, type apexType) {
         
        query = query.replace(' ', '%20');
        query = query.replace('*', '%2A');
        query = query.replace('\'', '%27');
        query = query.replace('=', '%3D');
        query = query.replace(',', '%2C'); 
        query = query.replace('!', '%21'); 
        query = query.replace('<', '%3C');

         system.debug('query: ' + query);
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/query?query=' + query + '&minorversion=4');

        req.setHeader('Accept', 'application/json;charset=UTF-8');
        qbConnector.sign(req);
       
        HttpResponse res;
         if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req); 
        }
        
        string responseString = res.getBody();
         
        System.debug('::::: Response = (' + res.getStatusCode() + ')' + res.getBody());
        //return System.JSON.deserialize(responseString, apexType);
         
        if (res.getStatusCode() == 200) {
            System.debug(':::::System.JSON.deserialize(responseString, apexType)' + System.JSON.deserialize(responseString, apexType));
            return System.JSON.deserialize(responseString, apexType);
        }else{
            return System.JSON.deserialize(responseString, QBOError.class);
        }
       
    }

    public object read(string objType, string objId, type apexType) {
         
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/' + objType + '/' + objId + '?minorversion=4');

        req.setHeader('Accept', 'application/json;charset=UTF-8');
        qbConnector.sign(req);

        HttpResponse res;
         //if(Test.isRunningTest()) {
        //    res = new HttpResponse();
        //} else {
            res = h.send(req); 
        //}
        
        string responseString = res.getBody();
         
        System.debug('::::: Response = (' + res.getStatusCode() + ')' + res.getBody());
        
        if (res.getStatusCode() == 200) {
            return System.JSON.deserialize(responseString, apexType);
        }else{
            return System.JSON.deserialize(responseString, QBOError.class);
        }
        //return System.JSON.deserialize(responseString, apexType);
       
    }
    
    public blob pdf1(string objType, string invoiceId) {
        System.debug('PP objType  '+objType);
        System.debug('PP invoiceId  '+invoiceId);
        //QuickBooksConnector qbConnector = new QuickBooksConnector();
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/' + objType + '/' + invoiceId + '/pdf');

        req.setHeader('Accept', 'application/pdf');
        qbConnector.sign(req);
        

        HttpResponse res;
        res = h.send(req); 
        
        blob responseBlob = res.getBodyAsBlob(); //Blob.valueOf(res.getBody());
         
        System.debug('::::: Response = (' + res.getStatusCode() + ')' + res.getBody());
        System.debug('PP resp  '+res);
        //System.debug('PP resp string '+responseString);
        return responseBlob;
       
    }
	
    /*
    eg

    String json = '{'+
    '    \"BillAddr\": {'+
    '        \"Line1\": \"123 Main Street\",'+
    '        \"City\": \"Mountain View\",'+
    '        \"Country\": \"USA\",'+
    '        \"CountrySubDivisionCode\": \"CA\",'+
    '        \"PostalCode\": \"94042\"'+
    '    },'+
    '    \"Notes\": \"Here are other details.\",'+
    '    \"Title\": \"Mr\",'+
    '    \"GivenName\": \"James13342\",'+
    '    \"MiddleName\": \"B\",'+
    '    \"FamilyName\": \"King13342\",'+
    '    \"Suffix\": \"Jr\",'+
    '    \"FullyQualifiedName\": \"King Groceries134\",'+
    '    \"CompanyName\": \"King Groceries12333\",'+
    '    \"DisplayName\": \"King\'s Groceries33333\",'+
    '    \"PrimaryPhone\": {'+
    '        \"FreeFormNumber\": \"(555) 555-5555\"'+
    '    },'+
    '    \"PrimaryEmailAddr\": {'+
    '        \"Address\": \"jdrew13ww4@myemail.com\"'+
    '    }'+
    '}';
    QBOCustomer obj = QBOCustomer.parse(json);
    system.debug('customer: ' + system.JSON.serialize(obj, true));

    QBOCRUDHelper h = new QBOCRUDHelper();
    QBOCustomer cl = (QBOCustomer)h.upsert('Customer',system.JSON.serialize(obj, true) ,QBOCustomer.class);
    system.debug('QBOCustomerList: ' + cl);
    */
    public object upsertData(string objTable, string jsonObj, type apexType)
    {
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        ///company/:companyId/customer
        //req.setEndpoint('https://qbo.intuit.com/qbo1/resource/customer/v2/' + oaToken.Realm_Id__c);
        req.setEndPoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/' + objTable);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        //application/json;charset=UTF-8
      
       
        qbConnector.sign(req);
        req.setBody(jsonObj);
        System.debug('::::: Request = ' + req);
        
        HttpResponse res;
        //if(Test.isRunningTest()) {
        //    res = new HttpResponse();
        //} else { 
            res = h.send(req);
       // }
        
        String responseString = res.getBody();
        
        system.debug('$$$$$'+res);
        System.debug('::::: response = ' + res.getbody());
		
        // Check if for errors, if there are errors then return a QBOError instead of expected apexType
		if (res.getStatusCode() == 200) {
            return System.JSON.deserialize(responseString, apexType);
        }else{
            return System.JSON.deserialize(responseString, QBOError.class);
        }
          
        
    }
}