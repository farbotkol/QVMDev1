//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class QBOPurchaseOrderResponse_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"PurchaseOrder\": {'+
		'    \"VendorAddr\": {'+
		'      \"Id\": \"604\",'+
		'      \"Line1\": \"SU00304\",'+
		'      \"Line2\": \"null null\"'+
		'    },'+
		'    \"ShipAddr\": {'+
		'      \"Id\": \"605\",'+
		'      \"Line1\": \"Sandbox Company_AU_3\",'+
		'      \"Line2\": \"2500 Garcia Ave\",'+
		'      \"Line3\": \"Sydney NSW  2050\"'+
		'    },'+
		'    \"ShipMethodRef\": {'+
		'      \"value\": \"shipvia\",'+
		'      \"name\": \"shipvia\"'+
		'    },'+
		'    \"POStatus\": \"Open\",'+
		'    \"domain\": \"QBO\",'+
		'    \"sparse\": false,'+
		'    \"Id\": \"791\",'+
		'    \"SyncToken\": \"3\",'+
		'    \"MetaData\": {'+
		'      \"CreateTime\": \"2016-08-30T21:38:24-07:00\",'+
		'      \"LastUpdatedTime\": \"2016-08-30T21:42:06-07:00\"'+
		'    },'+
		'    \"CustomField\": [],'+
		'    \"DocNumber\": \"1006\",'+
		'    \"TxnDate\": \"2016-08-31\",'+
		'    \"CurrencyRef\": {'+
		'      \"value\": \"AUD\",'+
		'      \"name\": \"Australian Dollar\"'+
		'    },'+
		'    \"ExchangeRate\": 1,'+
		'    \"PrivateNote\": \"test memo\",'+
		'    \"Line\": ['+
		'      {'+
		'        \"Id\": \"1\",'+
		'        \"Description\": \"Catering -- food & beverage\",'+
		'        \"Amount\": 500.0,'+
		'        \"DetailType\": \"ItemBasedExpenseLineDetail\",'+
		'        \"ItemBasedExpenseLineDetail\": {'+
		'          \"BillableStatus\": \"NotBillable\",'+
		'          \"ItemRef\": {'+
		'            \"value\": \"3\",'+
		'            \"name\": \"Catering\"'+
		'          },'+
		'          \"UnitPrice\": 500,'+
		'          \"Qty\": 1,'+
		'          \"TaxCodeRef\": {'+
		'            \"value\": \"2\"'+
		'          }'+
		'        }'+
		'      }'+
		'    ],'+
		'    \"TxnTaxDetail\": {'+
		'      \"TaxLine\": ['+
		'        {'+
		'          \"Amount\": 50.0,'+
		'          \"DetailType\": \"TaxLineDetail\",'+
		'          \"TaxLineDetail\": {'+
		'            \"TaxRateRef\": {'+
		'              \"value\": \"1\"'+
		'            },'+
		'            \"PercentBased\": true,'+
		'            \"TaxPercent\": 10,'+
		'            \"NetAmountTaxable\": 500.0'+
		'          }'+
		'        }'+
		'      ]'+
		'    },'+
		'    \"VendorRef\": {'+
		'      \"value\": \"211\",'+
		'      \"name\": \"The BIG Supplier\"'+
		'    },'+
		'    \"APAccountRef\": {'+
		'      \"value\": \"92\",'+
		'      \"name\": \"Accounts Payable (A/P)\"'+
		'    },'+
		'    \"TotalAmt\": 550.0,'+
		'    \"Memo\": \"test message\",'+
		'    \"GlobalTaxCalculation\": \"TaxExcluded\"'+
		'  }'+
		'}';
		QBOPurchaseOrderResponse obj = QBOPurchaseOrderResponse.parse(json);
		System.assert(obj != null);
	}
}