//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class QBOReconnect_Test {
	
	static testMethod void testParse() {
		String json = '{\"OAuthToken\":null,\"OAuthTokenSecret\":null,\"ErrorMessage\":\"Token Refresh Window Out of Bounds\",\"ErrorCode\":212,\"ServerTime\":\"\\/Date(1476057923704)\\/\",\"IsFci\":true}';
		QBOReconnect obj = QBOReconnect.parse(json);
		System.assert(obj != null);
	}
}