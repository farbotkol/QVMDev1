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
        query = query.replace('>', '%3E');
        query = query.replace('(', '%28');
        query = query.replace(')', '%29');
        query = query.replace('\\', '%5C'); 
        query = query.replace('/', '%2F'); 
         query = query.replace('&', '%26');
          query = query.replace('@', '%40');

         system.debug('query: ' + query);
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/query?query=' + query + '&minorversion=4');

        req.setHeader('Accept', 'application/json;charset=UTF-8');
         req.setTimeOut(120000);
        qbConnector.sign(req);
       
        HttpResponse res;
        //if(Test.isRunningTest()) {
        //    res = new HttpResponse();
        //} else {
            res = h.send(req); 
        //}
        
        string responseString = res.getBody();
         system.debug('responseString ' + responseString);
         
        System.debug('::::: Response = (' + res.getStatusCode() + ')' + res.getBody());
        //return System.JSON.deserialize(responseString, apexType);
         
        if (res.getStatusCode() == 200) 
        {
            system.debug('before1');
            System.debug(':::::System.JSON.deserialize(responseString, apexType)' + System.JSON.deserialize(responseString, apexType));
            system.debug('after1');
            return System.JSON.deserialize(responseString, apexType);
        }
         else
         {
             system.debug('before2');
            return System.JSON.deserialize(responseString, QBOError.class);
        }
       
    }
    
    /*
     * 
     * QBOCRUDHelper h = new QBOCRUDHelper();
     * h.report('CustomerBalanceDetail','customer=207&arpaid=All',QBOCustomerBalanceDetail.class);
     */
    public object report(string reportType, string paramSting, type apexType) {
         
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/reports/' + reportType + '?' + paramSting + '&minorversion=4');

        req.setHeader('Accept', 'application/json;charset=UTF-8');
        req.setTimeOut(120000);
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

    public object read(string objType, string objId, type apexType) {
         
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        
        req.setEndpoint(qbConnector.service.BaseURL__c + qbConnector.oaToken.Realm_Id__c + '/' + objType + '/' + objId + '?minorversion=4');

        req.setHeader('Accept', 'application/json;charset=UTF-8');
        req.setTimeOut(120000);
        
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
            if (objType == 'Payment'){
                return QBOPaymentResponse.parse(responseString);
            }
            else{
                return System.JSON.deserialize(responseString, apexType);
            }
                
            
        }else{
            //return System.JSON.deserialize(responseString, QBOError.class);
            if (res.getBody().contains('The request limit was reached'))
                {
                    QBOCRUDHelper.sleep(30);
                    return read( objType, objId, apexType);
                }
                else 
                {
                     return System.JSON.deserialize(responseString, QBOError.class);
                }
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
        req.setTimeOut(120000);
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
        try
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
            req.setTimeOut(120000);
           
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
                if (res.getBody().contains('The request limit was reached'))
                {
                    QBOCRUDHelper.sleep(30);
                    return upsertData( objTable,  jsonObj,  apexType);
                }
                else 
                {
                     return System.JSON.deserialize(responseString, QBOError.class);
                }
               
            }
        }
        catch(Exception ex)
        {
            return System.JSON.deserialize(ex.getMessage(), QBOError.class);
        }
          
        
    }
    
    public static void sleep(Integer sleepSeconds) {
        Long startTS = System.currentTimeMillis();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://1.cuzillion.com/bin/resource.cgi?sleep=' + (sleepSeconds));
        req.setMethod('GET');
        Http http = new Http();
        req.setTimeOut(120000);
        HTTPResponse res = http.send(req);
        
    } 
    
    @future(callout=true)
    public static void callReconnectTocken()
    {
        try
        {
			QBOCRUDHelper ch = new QBOCRUDHelper();
			ch.reconnectTocken();            
        }
        catch (Exception ex)
        {
            // ??????
        }
        
    }
    
    public boolean reconnectTocken()
    {
        //https://appcenter.intuit.com/api/v1/Connection/Reconnect 
         try
        {
            Http h = new Http();
            
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
            req.setEndPoint('https://appcenter.intuit.com/api/v1/Connection/Reconnect');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json;charset=UTF-8');
            req.setTimeOut(120000);
           
            qbConnector.sign(req);
            //req.setBody(jsonObj);
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
                QBOReconnect recon = QBOReconnect.parse(responseString);
                System.debug('::::: response class= ' + recon);
                if (recon.ErrorCode == 0){
                    // update current tocken in return true
                    System.debug('::::: SHOULD UPDATE CURRENT CONNECTED TOCKEN HERE');
                	OAuth_Token__c  tocken = [SELECT Token__c, Secret__c, Is_Access__c, Realm_Id__c
                        FROM OAuth_Token__c 
                        where OAuthService__r.Name = 'QuickBooksAU'                     
                        Order by CreatedDate DESC
                        LIMIT 1];
                   tocken.Token__c = recon.OAuthToken;
                   tocken.Secret__c = recon.OAuthTokenSecret;
                 
                   update tocken;
                    
                   System.debug('::::: TOCKEN UPDATED');
                   return true; 
                }
                else{
                    System.debug('::::: DO NOTHING');
                    return false;                
                }
                
					
                 
            }else{
                return false;
               
            }
            
        }
        catch(Exception ex)
        {
            return false;
        }
    }
}