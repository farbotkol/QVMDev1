//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class QBOPaymentResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
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
		QBOPaymentResponse r = QBOPaymentResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.Any_Z objAny_Z = new QBOPaymentResponse.Any_Z(System.JSON.createParser(json));
		System.assert(objAny_Z != null);
		System.assert(objAny_Z.name == null);
		System.assert(objAny_Z.declaredType == null);
		System.assert(objAny_Z.scope == null);
		System.assert(objAny_Z.value == null);
		System.assert(objAny_Z.nil == null);
		System.assert(objAny_Z.globalScope == null);
		System.assert(objAny_Z.typeSubstituted == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.Line objLine = new QBOPaymentResponse.Line(System.JSON.createParser(json));
		System.assert(objLine != null);
		System.assert(objLine.Amount == null);
		System.assert(objLine.LinkedTxn == null);
		System.assert(objLine.LineEx == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.Payment objPayment = new QBOPaymentResponse.Payment(System.JSON.createParser(json));
		System.assert(objPayment != null);
		System.assert(objPayment.CustomerRef == null);
		System.assert(objPayment.DepositToAccountRef == null);
		System.assert(objPayment.PaymentMethodRef == null);
		System.assert(objPayment.PaymentRefNum == null);
		System.assert(objPayment.TotalAmt == null);
		System.assert(objPayment.UnappliedAmt == null);
		System.assert(objPayment.ProcessPayment == null);
		System.assert(objPayment.domain == null);
		System.assert(objPayment.sparse == null);
		System.assert(objPayment.Id == null);
		System.assert(objPayment.SyncToken == null);
		System.assert(objPayment.MetaData == null);
		System.assert(objPayment.TxnDate == null);
		System.assert(objPayment.CurrencyRef == null);
		System.assert(objPayment.PrivateNote == null);
		System.assert(objPayment.Line == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.DepositToAccountRef objDepositToAccountRef = new QBOPaymentResponse.DepositToAccountRef(System.JSON.createParser(json));
		System.assert(objDepositToAccountRef != null);
		System.assert(objDepositToAccountRef.value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse objRoot = new QBOPaymentResponse(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.Payment == null);
	

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.MetaData objMetaData = new QBOPaymentResponse.MetaData(System.JSON.createParser(json));
		System.assert(objMetaData != null);
		System.assert(objMetaData.CreateTime == null);
		System.assert(objMetaData.LastUpdatedTime == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.Value objValue = new QBOPaymentResponse.Value(System.JSON.createParser(json));
		System.assert(objValue != null);
		System.assert(objValue.Name == null);
		System.assert(objValue.Value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.CustomerRef objCustomerRef = new QBOPaymentResponse.CustomerRef(System.JSON.createParser(json));
		System.assert(objCustomerRef != null);
		System.assert(objCustomerRef.value == null);
		System.assert(objCustomerRef.name == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.LineEx objLineEx = new QBOPaymentResponse.LineEx(System.JSON.createParser(json));
		System.assert(objLineEx != null);
		System.assert(objLineEx.any_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOPaymentResponse.LinkedTxn objLinkedTxn = new QBOPaymentResponse.LinkedTxn(System.JSON.createParser(json));
		System.assert(objLinkedTxn != null);
		System.assert(objLinkedTxn.TxnId == null);
		System.assert(objLinkedTxn.TxnType == null);
	}
}