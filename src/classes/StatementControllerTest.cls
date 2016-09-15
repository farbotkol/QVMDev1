@isTest
public class StatementControllerTest {
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            
            system.debug('hi there');
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            
            system.debug('MOCK : ' + req.getEndpoint());
            
            String json = '';
            if (req.getEndpoint().contains('customer')){
                
                json = '{'+
                    '	\"Header\": {'+
                    '		\"Time\": \"2016-09-11T22:16:49-07:00\",'+
                    '		\"ReportName\": \"CustomerBalanceDetail\",'+
                    '		\"DateMacro\": \"all\",'+
                    '		\"Currency\": \"AUD\",'+
                    '		\"Customer\": \"67\",'+
                    '		\"Option\": [{'+
                    '			\"Name\": \"report_date\",'+
                    '			\"Value\": \"2016-09-30\"'+
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
                    '					\"value\": \"TEST DevMerge\",'+
                    '					\"id\": \"67\"'+
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
                    '						\"value\": \"2016-09-07\"'+
                    '					}, {'+
                    '						\"value\": \"Payment\",'+
                    '						\"id\": \"178\"'+
                    '					}, {'+
                    '						\"value\": \"xxxxxref123\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-07\"'+
                    '					}, {'+
                    '						\"value\": \"-4402.00\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"Adjustment Note\",'+
                    '						\"id\": \"173\"'+
                    '					}, {'+
                    '						\"value\": \"LCN--0000000014\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"-23.76\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"Invoice\",'+
                    '						\"id\": \"171\"'+
                    '					}, {'+
                    '						\"value\": \"101\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-21\"'+
                    '					}, {'+
                    '						\"value\": \"4400.00\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"Adjustment Note\",'+
                    '						\"id\": \"174\"'+
                    '					}, {'+
                    '						\"value\": \"LCN--0000000015\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"-23.76\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}, {'+
                    '						\"value\": \".00\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"Invoice\",'+
                    '						\"id\": \"175\"'+
                    '					}, {'+
                    '						\"value\": \"103\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-21\"'+
                    '					}, {'+
                    '						\"value\": \"23.76\"'+
                    '					}, {'+
                    '						\"value\": \"23.76\"'+
                    '					}, {'+
                    '						\"value\": \"23.76\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"Invoice\",'+
                    '						\"id\": \"176\"'+
                    '					}, {'+
                    '						\"value\": \"104\"'+
                    '					}, {'+
                    '						\"value\": \"2016-10-06\"'+
                    '					}, {'+
                    '						\"value\": \"12709.40\"'+
                    '					}, {'+
                    '						\"value\": \"12709.40\"'+
                    '					}, {'+
                    '						\"value\": \"12733.16\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"Payment\",'+
                    '						\"id\": \"177\"'+
                    '					}, {'+
                    '						\"value\": \"\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-06\"'+
                    '					}, {'+
                    '						\"value\": \"\"'+
                    '					}, {'+
                    '						\"value\": \"\"'+
                    '					}, {'+
                    '						\"value\": \"12733.16\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}, {'+
                    '					\"ColData\": [{'+
                    '						\"value\": \"2016-09-01\"'+
                    '					}, {'+
                    '						\"value\": \"Invoice\",'+
                    '						\"id\": \"172\"'+
                    '					}, {'+
                    '						\"value\": \"102\"'+
                    '					}, {'+
                    '						\"value\": \"2016-09-16\"'+
                    '					}, {'+
                    '						\"value\": \"1560.68\"'+
                    '					}, {'+
                    '						\"value\": \"1511.16\"'+
                    '					}, {'+
                    '						\"value\": \"14244.32\"'+
                    '					}],'+
                    '					\"type\": \"Data\"'+
                    '				}]'+
                    '			},'+
                    '			\"Summary\": {'+
                    '				\"ColData\": [{'+
                    '					\"value\": \"Total for TEST DevMerge\"'+
                    '				}, {'+
                    '					\"value\": \"\"'+
                    '				}, {'+
                    '					\"value\": \"\"'+
                    '				}, {'+
                    '					\"value\": \"\"'+
                    '				}, {'+
                    '					\"value\": \"14244.32\"'+
                    '				}, {'+
                    '					\"value\": \"14244.32\"'+
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
                    '					\"value\": \"14244.32\"'+
                    '				}, {'+
                    '					\"value\": \"14244.32\"'+
                    '				}, {'+
                    '					\"value\": \"\"'+
                    '				}]'+
                    '			},'+
                    '			\"type\": \"Section\"'+
                    '		}]'+
                    '	}'+
                    '}';
            }
            else if (req.getEndpoint().contains('query')){
                json = '{'+
                    ''+
                    '  \"QueryResponse\": {'+
                    ''+
                    '    \"Invoice\": ['+
                    ''+
                    '      {'+
                    ''+
                    '        \"sparse\": true,'+
                    ''+
                    '        \"Id\": \"224\",'+
                    ''+
                    '        \"DocNumber\": \"1029\",'+
                    ''+
                    '        \"TxnDate\": \"2016-08-11\",'+
                    ''+
                    '        \"LinkedTxn\": [],'+
                    ''+
                    '        \"Line\": [],'+
                    ''+
                    '        \"DueDate\": \"2016-09-10\",'+
                    ''+
                    '        \"TotalAmt\": 82.5,'+
                    ''+
                    '        \"Balance\": 82.5'+
                    ''+
                    '      },'+
                    ''+
                    '      {'+
                    ''+
                    '        \"sparse\": true,'+
                    ''+
                    '        \"Id\": \"8\",'+
                    ''+
                    '        \"DocNumber\": \"1004\",'+
                    ''+
                    '        \"TxnDate\": \"2016-07-19\",'+
                    ''+
                    '        \"LinkedTxn\": [],'+
                    ''+
                    '        \"Line\": [],'+
                    ''+
                    '        \"DueDate\": \"2016-08-07\",'+
                    ''+
                    '        \"TotalAmt\": 528.0,'+
                    ''+
                    '        \"Balance\": 0'+
                    ''+
                    '      }'+
                    ''+
                    '    ],'+
                    ''+
                    '    \"startPosition\": 1,'+
                    ''+
                    '    \"maxResults\": 2,'+
                    ''+
                    '    \"totalCount\": 2'+
                    ''+
                    '  },'+
                    ''+
                    '  \"time\": \"2016-09-01T22:34:11.245-07:00\"'+
                    ''+
                    '}';
                
            }
            
            res.setBody(json);            
            return res;
        }
    }
    
    @isTest static void Test_Constructor(){
        TestDataFactory.CreateOAuthServiceEntries();
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.setCurrentPage(Page.ViewStatement);
        ApexPages.currentPage().getParameters().put('customerRef', '201');
        Test.startTest();
        Account acc = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        StatementController con = new StatementController(sc);
        String totalVal = con.total;
        String customerNameVal = con.customerName;
        String reportDate = con.reportDate;
        List<QBOStatement> qboStatements = con.getStatements();
        Test.stopTest();
        
    }
}