@isTest
class HttpContentFactoryTests {
    /*
    private class TestClass
    {
    	public TestClass(){
    		this.numbers = new List<Decimal>();

    	}
    	public String name {get;set;}
    	public List<Decimal> numbers{get;protected set;}
    }
    @isTest static void makeJsonContent(){
    	TestClass testObject = new TestClass();
    	testObject.name='My name';
    	testObject.numbers.add(12);
    	testObject.numbers.add(5);
    	JsonContent content = new JsonContent(testObject);
    	HttpRequest request = new HttpRequest();
    	content.writeTo(request);

    	System.debug(request.getBody());

    	Assert.areEqual('application/json', request.getHeader('Content-Type'))	;
    	TestClass newObject= (TestClass) content.deserializeAs(TestClass.class);
    	Assert.areEqual(testObject.name, newObject.name);
    	Assert.areEqual(testObject.numbers.size(), newObject.numbers.size());
    	Assert.areEqual(testObject.numbers[0], newObject.numbers[0]);
   	  	Assert.areEqual(testObject.numbers[1], newObject.numbers[1]);
    }
    @isTest static void jsonContent(){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"myThing":[{"prop":"value1"},{"prop":"value2"}]}');
        HttpContent content = HttpContentFactory.fromResponse(response);
        Assert.isNotNull(content,'Content');
        Assert.areEqual(content instanceof JsonContent,true,'Content type should be JsonContent');
    	JsonContent jsonContent = (JsonContent)content;

    	Object myObject= JSON.deserializeUntyped(jsonContent.getContent());
    	System.debug(myObject);
    }
    */
}