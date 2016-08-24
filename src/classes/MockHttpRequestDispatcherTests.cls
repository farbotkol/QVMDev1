@isTest
class MockHttpRequestDispatcherTests {


	@isTest
	static void simpleTest()
	{
		MockHttpRequestDispatcherTestFuxture test= new MockHttpRequestDispatcherTestFuxture().initialize();
		test.send('http://test.com/bad-request').statusCodeIs(400);

		test.send('http://test.com/one-time-only').statusCodeIs(200).hasHeader('Content-Type').contentIs('{"name":"value"}');
		test.send('http://test.com/one-time-only').statusCodeIs(404);

		//this one should respond each time
		test.send('http://test.com/xml-response').statusCodeIs(200);
		test.send('http://test.com/xml-response').statusCodeIs(200);

	}
}