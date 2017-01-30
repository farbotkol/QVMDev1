public class HttpCalloutMockEngine implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req) {
        
        system.debug('hi there');
        HTTPResponse res = new HTTPResponse();
        res.setStatusCode(200);
         
        system.debug('EndPoint = :' + req.getEndpoint());
        if (req.getEndpoint().endsWith('vendor?minorversion=4') || req.getEndpoint().endsWith('vendor/89?minorversion=4') ) {
                       String json = '{'+
                '  \"Vendor\": {'+
                '    \"Taxable\": false,'+
                '    \"Job\": false,'+
                '    \"BillWithParent\": false,'+
                '    \"Balance\": 0,'+
                '    \"BalanceWithJobs\": 0,'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"PreferredDeliveryMethod\": \"None\",'+
                '    \"PrimaryTaxIdentifier\": \"XXXX2352345\",'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"89\",'+
                '    \"SyncToken\": \"0\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-08-23T20:57:44-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-08-23T20:57:44-07:00\"'+
                '    },'+
                '    \"FullyQualifiedName\": \"www1\",'+
                '    \"CompanyName\": \"www1\",'+
                '    \"DisplayName\": \"www1\",'+
                '    \"PrintOnCheckName\": \"www1\",'+
                '    \"Active\": true'+
                '  },'+
                '  \"time\": \"2016-08-23T20:57:44.496-07:00\"'+
                '}';
            res.setBody(json);           
  
        }
        if (req.getEndpoint().endsWith('customer?minorversion=4') 
            || req.getEndpoint().endsWith('customer/3?minorversion=4')
            || req.getEndpoint().endsWith('customer/100?minorversion=4')
            || req.getEndpoint().endsWith('customer?operation=update&minorversion=4')
           	|| req.getEndpoint().endsWith('customer/201?minorversion=4'))
        {
            String json = '{'+
                '  \"Customer\": {'+
                '    \"Taxable\": false,'+
                '    \"Job\": false,' +
                '    \"BillWithParent\": false,'+
                '    \"Balance\": 0,'+
                '    \"BalanceWithJobs\": 0,'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"PreferredDeliveryMethod\": \"None\",'+
                '    \"PrimaryTaxIdentifier\": \"XXXX2352345\",'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"3\",'+
                '    \"SyncToken\": \"0\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-08-23T20:57:44-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-08-23T20:57:44-07:00\"'+
                '    },'+
                '    \"FullyQualifiedName\": \"www1\",'+
                '    \"CompanyName\": \"www1\",'+
                '    \"DisplayName\": \"www1\",'+
                '    \"PrintOnCheckName\": \"www1\",'+
                '    \"Active\": true'+
                '  },'+
                '  \"time\": \"2016-08-23T20:57:44.496-07:00\"'+
                '}';
            res.setBody(json);
        }
        if(req.getEndpoint().contains('query?query=SELECT%20%2A%20FROM%20ITEM'))
        {
            String json = '{'+
                '  \"QueryResponse\": {'+
                '    \"Item\": ['+
                '      {'+
                '        \"SalesTaxCodeRef\": {'+
                '          \"value\": \"10\",'+
                '          \"name\": \"SalesTaxCodeRef\"'+
                '        },'+
                '        \"sparse\": true,'+
                '        \"Id\": \"20\"'+
                '      },'+
                '      {'+
                '        \"SalesTaxCodeRef\": {'+
                '          \"value\": \"10\",'+
                '          \"name\": \"SalesTaxCodeRef\"'+
                '        },'+
                '        \"sparse\": true,'+
                '        \"Id\": \"1\"'+
                '      }'+
                '    ],'+
                '    \"startPosition\": 1,'+
                '    \"maxResults\": 2'+
                '  }' + 
                '}';
            res.setBody(json);
        }
        if(req.getEndpoint().contains('query?query=select%20Id%2CDocNumber'))
        {
            String json = '{'+
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
            res.setBody(json);
        }
        if(req.getEndpoint().endsWith('invoice')
           || req.getEndpoint().endsWith('invoice/201/pdf')){
            String json = '{\"Invoice\": '+
            '{'+
            '    \"Deposit\": 0,'+
            '    \"AllowIPNPayment\": false,'+
            '    \"AllowOnlinePayment\": false,'+
            '    \"AllowOnlineCreditCardPayment\": false,'+
            '    \"AllowOnlineACHPayment\": false,'+
            '    \"domain\": \"QBO\",'+
            '    \"sparse\": false,'+
            '    \"Id\": \"731\",'+
            '    \"SyncToken\": \"3\",'+
            '    \"MetaData\": {'+
            '      \"CreateTime\": \"2016-08-25T18:55:32-07:00\",'+
            '      \"LastUpdatedTime\": \"2016-08-25T19:04:36-07:00\"'+
            '    },'+
            '    \"CustomField\": ['+
            '      {'+
            '        \"DefinitionId\": \"1\",'+
            '        \"Name\": \"Event Rep\",'+
            '        \"Type\": \"StringType\",'+
            '        \"StringValue\": \"2345\"'+
            '      }'+
            '    ],'+
            '    \"DocNumber\": \"1018\",'+
            '    \"TxnDate\": \"2016-08-26\",'+
            '    \"CurrencyRef\": {'+
            '      \"value\": \"AUD\",'+
            '      \"name\": \"Australian Dollar\"'+
            '    },'+
            '    \"ExchangeRate\": 1,'+
            '    \"PrivateNote\": \"Statement memo\",'+
            '    \"LinkedTxn\": ['+
            '      {'+
            '        \"TxnId\": \"734\",'+
            '        \"TxnType\": \"Payment\"'+
            '      }'+
            '    ],'+
            '    \"Line\": ['+
            '      {'+
            '        \"Id\": \"1\",'+
            '        \"LineNum\": 1,'+
            '        \"Description\": \"Employee training off site\",'+
            '        \"Amount\": 1500.0,'+
            '        \"DetailType\": \"SalesItemLineDetail\",'+
            '        \"SalesItemLineDetail\": {'+
            '          \"ItemRef\": {'+
            '            \"value\": \"5\",'+
            '            \"name\": \"Employee Training\"'+
            '          },'+
            '          \"ClassRef\": {'+
            '            \"value\": \"200200000000000016358\",'+
            '            \"name\": \"Administrative\"'+
            '          },'+
            '          \"UnitPrice\": 1500,'+
            '          \"Qty\": 1,'+
            '          \"TaxCodeRef\": {'+
            '            \"value\": \"10\"'+
            '          }'+
            '        }'+
            '      },'+
            '      {'+
            '        \"Amount\": 1500.0,'+
            '        \"DetailType\": \"SubTotalLineDetail\",'+
            '        \"SubTotalLineDetail\": {}'+
            '      },'+
            '      {'+
            '        \"Amount\": 15.0,'+
            '        \"DetailType\": \"DiscountLineDetail\",'+
            '        \"DiscountLineDetail\": {'+
            '          \"PercentBased\": true,'+
            '          \"DiscountPercent\": 1,'+
            '          \"DiscountAccountRef\": {'+
            '            \"value\": \"67\",'+
            '            \"name\": \"Discounts given\"'+
            '          }'+
            '        }'+
            '      }'+
            '    ],'+
            '    \"TxnTaxDetail\": {'+
            '      \"TotalTax\": 148.5,'+
            '      \"TaxLine\": ['+
            '        {'+
            '          \"Amount\": 148.5,'+
            '          \"DetailType\": \"TaxLineDetail\",'+
            '          \"TaxLineDetail\": {'+
            '            \"TaxRateRef\": {'+
            '              \"value\": \"20\"'+
            '            },'+
            '            \"PercentBased\": true,'+
            '            \"TaxPercent\": 10,'+
            '            \"NetAmountTaxable\": 1485.0'+
            '          }'+
            '        }'+
            '      ]'+
            '    },'+
            '    \"CustomerRef\": {'+
            '      \"value\": \"201\",'+
            '      \"name\": \"Adam Milosz\"'+
            '    },'+
            '    \"CustomerMemo\": {'+
            '      \"value\": \"Thanks for your business!  We appreciate referrals!\"'+
            '    },'+
            '    \"BillAddr\": {'+
            '      \"Id\": \"591\",'+
            '      \"CountrySubDivisionCode\": \"null null\"'+
            '    },'+
            '    \"ShipAddr\": {'+
            '      \"Id\": \"591\",'+
            '      \"CountrySubDivisionCode\": \"null null\"'+
            '    },'+
            '    \"SalesTermRef\": {'+
            '      \"value\": \"3\"'+
            '    },'+
            '    \"DueDate\": \"2016-09-25\",'+
            '    \"GlobalTaxCalculation\": \"TaxExcluded\",'+
            '    \"TotalAmt\": 1633.5,'+
            '    \"HomeTotalAmt\": 1633.5,'+
            '    \"PrintStatus\": \"NotSet\",'+
            '    \"EmailStatus\": \"NotSet\",'+
            '    \"BillEmail\": {'+
            '      \"Address\": \"luke.farbotko@rxpservices.com\"'+
            '    },'+
            '    \"Balance\": 1133.5,'+
            '    \"HomeBalance\": 1133.5'+
                '  }}'; 
            res.setBody(json);
        }
        if(req.getEndpoint().endsWith('vendor?minorversion=4') ||
          	req.getEndpoint().endsWith('vendor/101?minorversion=4')){
            String json = '{\"Vendor\":'+
                '{'+
                '    \"BillAddr\": {'+
                '      \"Id\": \"486\",'+
                '      \"Line1\": \"34 malakoff st\",'+
                '      \"City\": \"St Kilda\",'+
                '      \"Country\": \"aus\",'+
                '      \"CountrySubDivisionCode\": \"vic\",'+
                '      \"PostalCode\": \"3183\"'+
                '    },'+
                '    \"TaxIdentifier\": \"XXXXXXX4553\",'+
                '    \"TermRef\": {'+
                '      \"value\": \"2\"'+
                '    },'+
                '    \"Balance\": 30.0,'+
                '    \"AcctNum\": \"432534254235\",'+
                '    \"Vendor1099\": false,'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"58\",'+
                '    \"SyncToken\": \"1\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-06-17T22:17:05-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-08-24T22:29:51-07:00\"'+
                '    },'+
                '    \"Title\": \"mr\",'+
                '    \"GivenName\": \"Venue\",'+
                '    \"MiddleName\": \"a\",'+
                '    \"FamilyName\": \"Rental\",'+
                '    \"Suffix\": \"dr\",'+
                '    \"CompanyName\": \"Venue Rental\",'+
                '    \"DisplayName\": \"Venue Rental\",'+
                '    \"PrintOnCheckName\": \"Venue Rental\",'+
                '    \"Active\": true,'+
                '    \"PrimaryPhone\": {'+
                '      \"FreeFormNumber\": \"35324\"'+
                '    },'+
                '    \"AlternatePhone\": {'+
                '      \"FreeFormNumber\": \"test other\"'+
                '    },'+
                '    \"Mobile\": {'+
                '      \"FreeFormNumber\": \"345435\"'+
                '    },'+
                '    \"Fax\": {'+
                '      \"FreeFormNumber\": \"314435\"'+
                '    },'+
                '    \"PrimaryEmailAddr\": {'+
                '      \"Address\": \"luke@luke.com\"'+
                '    },'+
                '    \"WebAddr\": {'+
                '      \"URI\": \"http://google.com\"'+
                '    }'+
                '  }' + 
                '}'; 
            res.setBody(json);
        }
        if(req.getEndpoint().endsWith('/vendor/58?minorversion=4') || req.getEndpoint().endsWith('vendor?operation=update&minorversion=4')){
            String json = '{\"Vendor\":'+
                '{'+
                '    \"BillAddr\": {'+
                '      \"Id\": \"486\",'+
                '      \"Line1\": \"34 malakoff st\",'+
                '      \"City\": \"St Kilda\",'+
                '      \"Country\": \"aus\",'+
                '      \"CountrySubDivisionCode\": \"vic\",'+
                '      \"PostalCode\": \"3183\"'+
                '    },'+
                '    \"TaxIdentifier\": \"XXXXXXX4553\",'+
                '    \"TermRef\": {'+
                '      \"value\": \"2\"'+
                '    },'+
                '    \"Balance\": 30.0,'+
                '    \"AcctNum\": \"432534254235\",'+
                '    \"Vendor1099\": false,'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"58\",'+
                '    \"SyncToken\": \"1\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-06-17T22:17:05-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-08-24T22:29:51-07:00\"'+
                '    },'+
                '    \"Title\": \"mr\",'+
                '    \"GivenName\": \"Venue\",'+
                '    \"MiddleName\": \"a\",'+
                '    \"FamilyName\": \"Rental\",'+
                '    \"Suffix\": \"dr\",'+
                '    \"CompanyName\": \"Venue Rental\",'+
                '    \"DisplayName\": \"Venue Rental\",'+
                '    \"PrintOnCheckName\": \"Venue Rental\",'+
                '    \"Active\": true,'+
                '    \"PrimaryPhone\": {'+
                '      \"FreeFormNumber\": \"35324\"'+
                '    },'+
                '    \"AlternatePhone\": {'+
                '      \"FreeFormNumber\": \"test other\"'+
                '    },'+
                '    \"Mobile\": {'+
                '      \"FreeFormNumber\": \"345435\"'+
                '    },'+
                '    \"Fax\": {'+
                '      \"FreeFormNumber\": \"314435\"'+
                '    },'+
                '    \"PrimaryEmailAddr\": {'+
                '      \"Address\": \"luke@luke.com\"'+
                '    },'+
                '    \"WebAddr\": {'+
                '      \"URI\": \"http://google.com\"'+
                '    }'+
                '  }' + 
                '}'; 
            res.setBody(json);
        }
        if(req.getEndpoint().contains('query?query=select%20Id%2CDocNumber%2CTxnDate%2CDueDate%2CTotalAmt%2CBalance%20%2C%20CustomerRef%20from%20INVOICE'))
        {
            String json = '{'+
                '  \"QueryResponse\": {'+
                '    \"Invoice\": ['+
                '      {'+
                '        \"sparse\": true,'+
                '        \"Id\": \"224\",'+
                '        \"DocNumber\": \"1029\",'+
                '        \"TxnDate\": \"2016-08-11\",'+
                '        \"LinkedTxn\": [],'+
                '        \"Line\": [],'+
                '        \"CustomerRef\": {'+
                '          \"value\": \"3\",'+
                '          \"name\": \"Alex Blakey\"'+
                '        },'+
                '        \"DueDate\": \"2016-09-10\",'+
                '        \"TotalAmt\": 82.5,'+
                '        \"Balance\": 82.5'+
                '      },'+
                '      {'+
                '        \"sparse\": true,'+
                '        \"Id\": \"218\",'+
                '        \"DocNumber\": \"1026\",'+
                '        \"TxnDate\": \"2016-08-11\",'+
                '        \"LinkedTxn\": [],'+
                '        \"Line\": [],'+
                '        \"CustomerRef\": {'+
                '          \"value\": \"3\",'+
                '          \"name\": \"Alex Blakey\"'+
                '        },'+
                '        \"DueDate\": \"2016-09-10\",'+
                '        \"TotalAmt\": 4555.4,'+
                '        \"Balance\": 445.4'+
                '      },'+
                '      {'+
                '        \"sparse\": true,'+
                '        \"Id\": \"208\",'+
                '        \"DocNumber\": \"1021\",'+
                '        \"TxnDate\": \"2016-08-11\",'+
                '        \"LinkedTxn\": [],'+
                '        \"Line\": [],'+
                '        \"CustomerRef\": {'+
                '          \"value\": \"3\",'+
                '          \"name\": \"workato 2\"'+
                '        },'+
                '        \"DueDate\": \"2016-08-11\",'+
                '        \"TotalAmt\": 10000.0,'+
                '        \"Balance\": 10000.0'+
                '      }'+
                '    ],'+
                '    \"startPosition\": 1,'+
                '    \"maxResults\": 3,'+
                '    \"totalCount\": 3'+
                '  },'+
                '  \"time\": \"2016-09-15T03:57:45.527-07:00\"'+
                '}';
                 res.setBody(json);
        }
        if(req.getEndpoint().contains('query?query=select%20Id%2CDocNumber%2CTxnDate%2CTotalAmt%2CBalance%2CCustomerRef%20from%20CreditMemo'))
        {
            String json = '{'+
        '  \"QueryResponse\": {'+
        '    \"CreditMemo\": ['+
        '      {'+
        '        \"RemainingCredit\": 23.76,'+
        '        \"sparse\": true,'+
        '        \"Id\": \"2324\",'+
        '        \"SyncToken\": \"0\",'+
        '        \"DocNumber\": \"LCN--0000015089d\",'+
        '        \"TxnDate\": \"2016-09-14\",'+
        '        \"Line\": [],'+
        '        \"CustomerRef\": {'+
        '          \"value\": \"3\",'+
        '          \"name\": \"Philip Wong\"'+
        '        },'+
        '        \"TotalAmt\": 23.76,'+
        '        \"Balance\": 23.76'+
        '      },'+
        '      {'+
        '        \"RemainingCredit\": 23.76,'+
        '        \"sparse\": true,'+
        '        \"Id\": \"2323\",'+
        '        \"SyncToken\": \"0\",'+
        '        \"DocNumber\": \"LCN--0000015088d\",'+
        '        \"TxnDate\": \"2016-09-14\",'+
        '        \"Line\": [],'+
        '        \"CustomerRef\": {'+
        '          \"value\": \"3\",'+
        '          \"name\": \"Philip Wong\"'+
        '        },'+
        '        \"TotalAmt\": 23.76,'+
        '        \"Balance\": 23.76'+
        '      }'+
        '    ],'+
        '    \"startPosition\": 1,'+
        '    \"maxResults\": 2'+
        '  },'+
        '  \"time\": \"2016-09-15T05:14:24.872-07:00\"'+
        '}';
         res.setBody(json);
        }
        if(req.getEndpoint().contains('query?query=select%20line%20from%20payment%20where%20Id%20IN'))
        {
            String json = '{'+
		'  \"QueryResponse\": {'+
		'    \"Payment\": ['+
		'      {'+
		'        \"CustomerRef\": {'+
		'          \"value\": \"1423\",'+
		'          \"name\": \"Commonwealth Bank of Australia\"'+
		'        },'+
		'        \"DepositToAccountRef\": {'+
		'          \"value\": \"185\"'+
		'        },'+
		'        \"TotalAmt\": 1311.08,'+
		'        \"UnappliedAmt\": 0,'+
		'        \"ProcessPayment\": false,'+
		'        \"domain\": \"QBO\",'+
		'        \"sparse\": false,'+
		'        \"Id\": \"33898\",'+
		'        \"SyncToken\": \"0\",'+
		'        \"MetaData\": {'+
		'          \"CreateTime\": \"2016-10-03T11:42:04-07:00\",'+
		'          \"LastUpdatedTime\": \"2016-10-03T11:42:04-07:00\"'+
		'        },'+
		'        \"TxnDate\": \"2016-10-04\",'+
		'        \"CurrencyRef\": {'+
		'          \"value\": \"AUD\",'+
		'          \"name\": \"Australian Dollar\"'+
		'        },'+
		'        \"Line\": ['+
		'          {'+
		'            \"Amount\": 1311.08,'+
		'            \"LinkedTxn\": ['+
		'              {'+
		'                \"TxnId\": \"29656\",'+
		'                \"TxnType\": \"Invoice\"'+
		'              }'+
		'            ],'+
		'            \"LineEx\": {'+
		'              \"any\": ['+
		'                {'+
		'                  \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
		'                  \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
		'                  \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
		'                  \"value\": {'+
		'                    \"Name\": \"txnId\",'+
		'                    \"Value\": \"29656\"'+
		'                  },'+
		'                  \"nil\": false,'+
		'                  \"globalScope\": true,'+
		'                  \"typeSubstituted\": false'+
		'                },'+
		'                {'+
		'                  \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
		'                  \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
		'                  \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
		'                  \"value\": {'+
		'                    \"Name\": \"txnOpenBalance\",'+
		'                    \"Value\": \"1311.08\"'+
		'                  },'+
		'                  \"nil\": false,'+
		'                  \"globalScope\": true,'+
		'                  \"typeSubstituted\": false'+
		'                },'+
		'                {'+
		'                  \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
		'                  \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
		'                  \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
		'                  \"value\": {'+
		'                    \"Name\": \"txnReferenceNumber\",'+
		'                    \"Value\": \"00006359\"'+
		'                  },'+
		'                  \"nil\": false,'+
		'                  \"globalScope\": true,'+
		'                  \"typeSubstituted\": false'+
		'                }'+
		'              ]'+
		'            }'+
		'          }'+
		'        ]'+
		'      }'+
		'    ],'+
		'    \"startPosition\": 1,'+
		'    \"maxResults\": 1'+
		'  },'+
		'  \"time\": \"2016-10-04T18:05:15.848-07:00\"'+
		'}';
            res.setBody(json);
        }
        if(req.getEndpoint().contains('query?query=select%20Id%2CTotalAmt%2CBalance%20from%20INVOICE%20where%20Id%20IN'))
        {
            String json = '{'+
		'  \"QueryResponse\": {'+
		'    \"Invoice\": ['+
		'      {'+
		'        \"Deposit\": 0,'+
		'        \"AllowIPNPayment\": false,'+
		'        \"AllowOnlinePayment\": false,'+
		'        \"AllowOnlineCreditCardPayment\": false,'+
		'        \"AllowOnlineACHPayment\": false,'+
		'        \"domain\": \"QBO\",'+
		'        \"sparse\": false,'+
		'        \"Id\": \"33876\",'+
		'        \"SyncToken\": \"1\",'+
		'        \"MetaData\": {'+
		'          \"CreateTime\": \"2016-09-27T22:37:07-07:00\",'+
		'          \"LastUpdatedTime\": \"2016-09-28T22:25:15-07:00\"'+
		'        },'+
		'        \"CustomField\": ['+
		'          {'+
		'            \"DefinitionId\": \"1\",'+
		'            \"Name\": \"Event Rep\",'+
		'            \"Type\": \"StringType\"'+
		'          }'+
		'        ],'+
		'        \"DocNumber\": \"00010973\",'+
		'        \"TxnDate\": \"2016-09-28\",'+
		'        \"CurrencyRef\": {'+
		'          \"value\": \"AUD\",'+
		'          \"name\": \"Australian Dollar\"'+
		'        },'+
		'        \"LinkedTxn\": ['+
		'          {'+
		'            \"TxnId\": \"33896\",'+
		'            \"TxnType\": \"Payment\"'+
		'          }'+
		'        ],'+
		'        \"Line\": ['+
		'          {'+
		'            \"Id\": \"1\",'+
		'            \"LineNum\": 1,'+
		'            \"Description\": \"Friday L              81\",'+
		'            \"Amount\": 42.7,'+
		'            \"DetailType\": \"SalesItemLineDetail\",'+
		'            \"SalesItemLineDetail\": {'+
		'              \"ServiceDate\": \"2016-09-28\",'+
		'              \"ItemRef\": {'+
		'                \"value\": \"71\",'+
		'                \"name\": \"Open Stands - PE F&V Fees Fri\"'+
		'              },'+
		'              \"UnitPrice\": 42.7,'+
		'              \"Qty\": 1,'+
		'              \"TaxCodeRef\": {'+
		'                \"value\": \"20\"'+
		'              }'+
		'            }'+
		'          },'+
		'          {'+
		'            \"Amount\": 42.7,'+
		'            \"DetailType\": \"SubTotalLineDetail\",'+
		'            \"SubTotalLineDetail\": {}'+
		'          }'+
		'        ],'+
		'        \"TxnTaxDetail\": {'+
		'          \"TotalTax\": 4.27,'+
		'          \"TaxLine\": ['+
		'            {'+
		'              \"Amount\": 4.27,'+
		'              \"DetailType\": \"TaxLineDetail\",'+
		'              \"TaxLineDetail\": {'+
		'                \"TaxRateRef\": {'+
		'                  \"value\": \"40\"'+
		'                },'+
		'                \"PercentBased\": true,'+
		'                \"TaxPercent\": 10,'+
		'                \"NetAmountTaxable\": 42.7'+
		'              }'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"CustomerRef\": {'+
		'          \"value\": \"1522\",'+
		'          \"name\": \"Test AccBusiness\"'+
		'        },'+
		'        \"DueDate\": \"2016-09-28\",'+
		'        \"GlobalTaxCalculation\": \"TaxExcluded\",'+
		'        \"TotalAmt\": 46.97,'+
		'        \"PrintStatus\": \"NeedToPrint\",'+
		'        \"EmailStatus\": \"NotSet\",'+
		'        \"Balance\": 0'+
		'      }'+
		'    ],'+
		'    \"startPosition\": 1,'+
		'    \"maxResults\": 1,'+
		'    \"totalCount\": 1'+
		'  },'+
		'  \"time\": \"2016-10-04T17:57:59.235-07:00\"'+
		'}';
            res.setBody(json);
        }
        if(req.getEndpoint().endsWith('payment')){
            String json = '{'+
                '  \"Payment\": {'+
                '    \"CustomerRef\": {'+
                '      \"value\": \"67\",'+
                '      \"name\": \"TEST DevMerge\"'+
                '    },'+
                '    \"DepositToAccountRef\": {'+
                '      \"value\": \"128\"'+
                '    },'+
                '    \"PaymentMethodRef\": {'+
                '      \"value\": \"8\"'+
                '    },'+
                '    \"PaymentRefNum\": \"xxxxxref123\",'+
                '    \"TotalAmt\": 2.0,'+
                '    \"UnappliedAmt\": 0,'+
                '    \"ProcessPayment\": false,'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"178\",'+
                '    \"SyncToken\": \"0\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-09-06T23:07:23-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-09-06T23:07:23-07:00\"'+
                '    },'+
                '    \"TxnDate\": \"2016-09-07\",'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"PrivateNote\": \"test memo\",'+
                '    \"Line\": ['+
                '      {'+
                '        \"Amount\": 2.0,'+
                '        \"LinkedTxn\": ['+
                '          {'+
                '            \"TxnId\": \"172\",'+
                '            \"TxnType\": \"Invoice\"'+
                '          }'+
                '        ],'+
                '        \"LineEx\": {'+
                '          \"any\": ['+
                '            {'+
                '              \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
                '              \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
                '              \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
                '              \"value\": {'+
                '                \"Name\": \"txnId\",'+
                '                \"Value\": \"172\"'+
                '              },'+
                '              \"nil\": false,'+
                '              \"globalScope\": true,'+
                '              \"typeSubstituted\": false'+
                '            },'+
                '            {'+
                '              \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
                '              \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
                '              \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
                '              \"value\": {'+
                '                \"Name\": \"txnOpenBalance\",'+
                '                \"Value\": \"1513.16\"'+
                '              },'+
                '              \"nil\": false,'+
                '              \"globalScope\": true,'+
                '              \"typeSubstituted\": false'+
                '            },'+
                '            {'+
                '              \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
                '              \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
                '              \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
                '              \"value\": {'+
                '                \"Name\": \"txnReferenceNumber\",'+
                '                \"Value\": \"00000102\"'+
                '              },'+
                '              \"nil\": false,'+
                '              \"globalScope\": true,'+
                '              \"typeSubstituted\": false'+
                '            }'+
                '          ]'+
                '        }'+
                '      }'+
                '    ]'+
                '  },'+
                '  \"time\": \"2016-09-06T23:07:55.211-07:00\"'+
                '}';
            res.setBody(json);
        }
        if(req.getEndpoint().endsWith('payment/201?minorversion=4')){
            String json = '{'+
                '  \"Payment\": {'+
                '    \"CustomerRef\": {'+
                '      \"value\": \"67\",'+
                '      \"name\": \"TEST DevMerge\"'+
                '    },'+
                '    \"DepositToAccountRef\": {'+
                '      \"value\": \"128\"'+
                '    },'+
                '    \"PaymentMethodRef\": {'+
                '      \"value\": \"8\"'+
                '    },'+
                '    \"PaymentRefNum\": \"xxxxxref123\",'+
                '    \"TotalAmt\": 2.0,'+
                '    \"UnappliedAmt\": 0,'+
                '    \"ProcessPayment\": false,'+
                '    \"domain\": \"QBO\",'+
                '    \"sparse\": false,'+
                '    \"Id\": \"178\",'+
                '    \"SyncToken\": \"0\",'+
                '    \"MetaData\": {'+
                '      \"CreateTime\": \"2016-09-06T23:07:23-07:00\",'+
                '      \"LastUpdatedTime\": \"2016-09-06T23:07:23-07:00\"'+
                '    },'+
                '    \"TxnDate\": \"2016-09-07\",'+
                '    \"CurrencyRef\": {'+
                '      \"value\": \"AUD\",'+
                '      \"name\": \"Australian Dollar\"'+
                '    },'+
                '    \"PrivateNote\": \"test memo\",'+
                '    \"Line\": ['+
                '      {'+
                '        \"Amount\": 2.0,'+
                '        \"LinkedTxn\": ['+
                '          {'+
                '            \"TxnId\": \"172\",'+
                '            \"TxnType\": \"Invoice\"'+
                '          }'+
                '        ],'+
                '        \"LineEx\": {'+
                '          \"any\": ['+
                '            {'+
                '              \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
                '              \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
                '              \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
                '              \"value\": {'+
                '                \"Name\": \"txnId\",'+
                '                \"Value\": \"172\"'+
                '              },'+
                '              \"nil\": false,'+
                '              \"globalScope\": true,'+
                '              \"typeSubstituted\": false'+
                '            },'+
                '            {'+
                '              \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
                '              \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
                '              \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
                '              \"value\": {'+
                '                \"Name\": \"txnOpenBalance\",'+
                '                \"Value\": \"1513.16\"'+
                '              },'+
                '              \"nil\": false,'+
                '              \"globalScope\": true,'+
                '              \"typeSubstituted\": false'+
                '            },'+
                '            {'+
                '              \"name\": \"{http://schema.intuit.com/finance/v3}NameValue\",'+
                '              \"declaredType\": \"com.intuit.schema.finance.v3.NameValue\",'+
                '              \"scope\": \"javax.xml.bind.JAXBElement$GlobalScope\",'+
                '              \"value\": {'+
                '                \"Name\": \"txnReferenceNumber\",'+
                '                \"Value\": \"00000102\"'+
                '              },'+
                '              \"nil\": false,'+
                '              \"globalScope\": true,'+
                '              \"typeSubstituted\": false'+
                '            }'+
                '          ]'+
                '        }'+
                '      }'+
                '    ]'+
                '  },'+
                '  \"time\": \"2016-09-06T23:07:55.211-07:00\"'+
                '}';
            res.setBody(json);
        }
        if (req.getEndpoint().contains('CustomerBalanceDetail?customer=201')){
             String json = '{'+
                '   \"Header\": {'+
                '       \"Time\": \"2016-10-02T19:54:44-07:00\",'+
                '       \"ReportName\": \"CustomerBalanceDetail\",'+
                '       \"DateMacro\": \"all\",'+
                '       \"Currency\": \"AUD\",'+
                '       \"Customer\": \"614\",'+
                '       \"Option\": [{'+
                '           \"Name\": \"report_date\",'+
                '           \"Value\": \"2016-10-31\"'+
                '       }, {'+
                '           \"Name\": \"NoReportData\",'+
                '           \"Value\": \"false\"'+
                '       }]'+
                '   },'+
                '   \"Columns\": {'+
                '       \"Column\": [{'+
                '           \"ColTitle\": \"Date\",'+
                '           \"ColType\": \"tx_date\"'+
                '       }, {'+
                '           \"ColTitle\": \"Transaction Type\",'+
                '           \"ColType\": \"txn_type\"'+
                '       }, {'+
                '           \"ColTitle\": \"No.\",'+
                '           \"ColType\": \"doc_num\"'+
                '       }, {'+
                '           \"ColTitle\": \"accountBusiness\",'+
                '           \"ColType\": \"sales_cust1\"'+
                '       }, {'+
                '           \"ColTitle\": \"Due Date\",'+
                '           \"ColType\": \"due_date\"'+
                '       }, {'+
                '           \"ColTitle\": \"Amount\",'+
                '           \"ColType\": \"subt_amount\"'+
                '       }, {'+
                '           \"ColTitle\": \"Open Balance\",'+
                '           \"ColType\": \"subt_open_bal\"'+
                '       }, {'+
                '           \"ColTitle\": \"Balance\",'+
                '           \"ColType\": \"rbal_open_bal\"'+
                '       }]'+
                '   },'+
                '   \"Rows\": {'+
                '       \"Row\": [{'+
                '           \"Header\": {'+
                '               \"ColData\": [{'+
                '                   \"value\": \"Efim Golder\",'+
                '                   \"id\": \"614\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }]'+
                '           },'+
                '           \"Rows\": {'+
                '               \"Row\": [{'+
                '                   \"ColData\": [{'+
                '                       \"value\": \"2016-11-01\"'+
                '                   }, {'+
                '                       \"value\": \"Invoice\",'+
                '                       \"id\": \"31829\"'+
                '                   }, {'+
                '                       \"value\": \"9201\"'+
                '                   }, {'+
                '                       \"value\": \"9201\"'+
                '                   }, {'+
                '                       \"value\": \"2016-11-15\"'+
                '                   }, {'+
                '                       \"value\": \"2254.48\"'+
                '                   }, {'+
                '                       \"value\": \".00\"'+
                '                   }, {'+
                '                       \"value\": \".00\"'+
                '                   }],'+
                '                   \"type\": \"Data\"'+
                '               },  {'+
                '                   \"ColData\": [{'+
                '                       \"value\": \"2016-09-01\"'+
                '                   }, {'+
                '                       \"value\": \"Invoice\",'+
                '                       \"id\": \"31573\"'+
                '                   }, {'+
                '                       \"value\": \"8848\"'+
                '                   }, {'+
                '                       \"value\": \"8848\"'+
                '                   }, {'+
                '                       \"value\": \"2016-09-15\"'+
                '                   }, {'+
                '                       \"value\": \"1502.43\"'+
                '                   }, {'+
                '                       \"value\": \".00\"'+
                '                   }, {'+
                '                       \"value\": \".00\"'+
                '                   }],'+
                '                   \"type\": \"Data\"'+
                '               }]'+
                '           },'+
                '           \"Summary\": {'+
                '               \"ColData\": [{'+
                '                   \"value\": \"Total for Efim Golder\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \".00\"'+
                '               }, {'+
                '                   \"value\": \".00\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }]'+
                '           },'+
                '           \"type\": \"Section\"'+
                '       }, {'+
                '           \"Summary\": {'+
                '               \"ColData\": [{'+
                '                   \"value\": \"TOTAL\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }, {'+
                '                   \"value\": \".00\"'+
                '               }, {'+
                '                   \"value\": \".00\"'+
                '               }, {'+
                '                   \"value\": \"\"'+
                '               }]'+
                '           },'+
                '           \"type\": \"Section\"'+
                '       }]'+
                '   }'+
                '}';
            res.setBody(json);
        }
           
        system.debug('Mock res : ' + res.getBody());
        system.debug('Mock res : ' + req.getEndpoint());
        
        return res;
        
    }
}