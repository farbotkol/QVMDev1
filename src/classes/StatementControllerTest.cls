@isTest
public class StatementControllerTest 
{    
    static testMethod void Test_Constructor()
    {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        Test.setCurrentPage(Page.ViewStatement);        
        Account acc = TestDataFactory.createAccountSupplier();
       	insert acc;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('customerRef', '201');
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        Test.startTest();

        StatementController con = new StatementController(sc);
        String totalVal = con.total;
        String customerNameVal = con.customerName;
        String reportDate = con.reportDate;
        List<QBOStatement> qboStatements = con.getStatements();
        Test.stopTest();        
    }
    //   RESMI new changes..
    
      /*private class StatementTestMock implements HttpCalloutMock
      {
        public HTTPResponse respond(HTTPRequest req) 
        {            
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            String json = '{'+
		'	\"Header\": {'+
		'		\"Time\": \"2016-10-02T19:54:44-07:00\",'+
		'		\"ReportName\": \"CustomerBalanceDetail\",'+
		'		\"DateMacro\": \"all\",'+
		'		\"Currency\": \"AUD\",'+
		'		\"Customer\": \"614\",'+
		'		\"Option\": [{'+
		'			\"Name\": \"report_date\",'+
		'			\"Value\": \"2016-10-31\"'+
		'		}, {'+
		'			\"Name\": \"NoReportData\",'+
		'			\"Value\": \"false\"'+
		'		}]'+
		'	},'+
		'	\"Columns\": {'+
		'		\"Column\": [{'+
		'			\"ColTitle\": \"Date\",'+
		'			\"ColType\": \"tx_date\"'+
		'		}, {'+
		'			\"ColTitle\": \"Transaction Type\",'+
		'			\"ColType\": \"txn_type\"'+
		'		}, {'+
		'			\"ColTitle\": \"No.\",'+
		'			\"ColType\": \"doc_num\"'+
		'		}, {'+
		'			\"ColTitle\": \"Due Date\",'+
		'			\"ColType\": \"due_date\"'+
		'		}, {'+
		'			\"ColTitle\": \"Amount\",'+
		'			\"ColType\": \"subt_amount\"'+
		'		}, {'+
		'			\"ColTitle\": \"Open Balance\",'+
		'			\"ColType\": \"subt_open_bal\"'+
		'		}, {'+
		'			\"ColTitle\": \"Balance\",'+
		'			\"ColType\": \"rbal_open_bal\"'+
		'		}]'+
		'	},'+
		'	\"Rows\": {'+
		'		\"Row\": [{'+
		'			\"Header\": {'+
		'				\"ColData\": [{'+
		'					\"value\": \"Efim Golder\",'+
		'					\"id\": \"614\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}]'+
		'			},'+
		'			\"Rows\": {'+
		'				\"Row\": [{'+
		'					\"ColData\": [{'+
		'						\"value\": \"2016-11-01\"'+
		'					}, {'+
		'						\"value\": \"Invoice\",'+
		'						\"id\": \"31829\"'+
		'					}, {'+
		'						\"value\": \"9201\"'+
		'					}, {'+
		'						\"value\": \"2016-11-15\"'+
		'					}, {'+
		'						\"value\": \"2254.48\"'+
		'					}, {'+
		'						\"value\": \".00\"'+
		'					}, {'+
		'						\"value\": \".00\"'+
		'					}],'+
		'					\"type\": \"Data\"'+
		'				},  {'+
		'					\"ColData\": [{'+
		'						\"value\": \"2016-09-01\"'+
		'					}, {'+
		'						\"value\": \"Invoice\",'+
		'						\"id\": \"31573\"'+
		'					}, {'+
		'						\"value\": \"8848\"'+
		'					}, {'+
		'						\"value\": \"2016-09-15\"'+
		'					}, {'+
		'						\"value\": \"1502.43\"'+
		'					}, {'+
		'						\"value\": \".00\"'+
		'					}, {'+
		'						\"value\": \".00\"'+
		'					}],'+
		'					\"type\": \"Data\"'+
		'				}]'+
		'			},'+
		'			\"Summary\": {'+
		'				\"ColData\": [{'+
		'					\"value\": \"Total for Efim Golder\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \".00\"'+
		'				}, {'+
		'					\"value\": \".00\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}]'+
		'			},'+
		'			\"type\": \"Section\"'+
		'		}, {'+
		'			\"Summary\": {'+
		'				\"ColData\": [{'+
		'					\"value\": \"TOTAL\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}, {'+
		'					\"value\": \".00\"'+
		'				}, {'+
		'					\"value\": \".00\"'+
		'				}, {'+
		'					\"value\": \"\"'+
		'				}]'+
		'			},'+
		'			\"type\": \"Section\"'+
		'		}]'+
		'	}'+
		'}';
        
         res.setBody(json);           
         return res;
        }
    }
    
    private class StatementErrorTestMock implements HttpCalloutMock
      {
        public HTTPResponse respond(HTTPRequest req) 
        {            
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            String json = null;
        
         res.setBody(json);           
         return res;
        }
    }*/
    
    static testMethod void PositiveConditions()
    {
    	TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        
        Test.setCurrentPage(Page.ViewStatement);
        Account acc = TestDataFactory.createAccountSupplier();
       	insert acc;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('customerRef', '201');
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        StatementController con = new StatementController(sc);
        String totalVal = con.total;
        String customerNameVal = con.customerName;
        String reportDate = con.reportDate;
        List<QBOStatement> qboStatements = con.getStatements();
        system.debug('sdfdsfs22222222222' + con);
        Test.stopTest();
        //List<QBOStatement> statementList = new List<QBOStatement>();
        //statementList = con.getStatements();
        //system.debug('sdfdsfs' + statementList);
        system.assert(qboStatements.size()>0);
    }
    static testMethod void ErrorConditions()
    {
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockEngine());
        
        Test.setCurrentPage(Page.ViewStatement);
        Account acc = TestDataFactory.createAccountSupplier();
       	insert acc;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('customerRef', '201');
        ApexPages.currentPage().getParameters().put('accountId', acc.Id);
        Test.startTest();
        StatementController con = new StatementController(sc);
        String totalVal = con.total;
        String customerNameVal = con.customerName;
        String reportDate = con.reportDate;
        List<QBOStatement> qboStatements = con.getStatements();
        Test.stopTest();        
    }
    static testMethod void checkNullConditions()
    {
        QBOStatement.getQBOStatementFromJSON(null);
    }
}