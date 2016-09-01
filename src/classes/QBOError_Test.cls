//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class QBOError_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'	\"Fault\": {'+
		'		\"Error\": [{'+
		'			\"Message\": \"Request has invalid or unsupported property\",'+
		'			\"Detail\": \"Property Name:Unrecognized token \'gdhjfghj\': was expecting (\'true\', \'false\' or \'null\')\\n  specified is unsupported or invalid\",'+
		'			\"code\": \"2010\"'+
		'		}],'+
		'		\"type\": \"ValidationFault\"'+
		'	},'+
		'	\"time\": \"2016-08-25T17:02:42.843-07:00\"'+
		'}';
		QBOError r = QBOError.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOError objRoot = new QBOError(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.Fault == null);
	

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOError.Error objError = new QBOError.Error(System.JSON.createParser(json));
		System.assert(objError != null);
		System.assert(objError.Message == null);
		System.assert(objError.Detail == null);
		System.assert(objError.code == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOError.Fault objFault = new QBOError.Fault(System.JSON.createParser(json));
		System.assert(objFault != null);
		System.assert(objFault.Error == null);
		System.assert(objFault.type_Z == null);
	}
}