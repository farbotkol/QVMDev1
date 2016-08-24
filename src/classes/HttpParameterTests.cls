@isTest 
private class HttpParameterTests {
	@isTest
	static void simpleTest()
	{
		HttpParameter instance= new HttpParameter('my name', 'the value');
		Assert.areEqual('my name', instance.name);
		Assert.areEqual('the value', instance.value);
		Assert.areEqual('my%20name=the%20value', instance.toString());
	}

	@isTest
	static void nullValueTest()
	{
		HttpParameter instance= new HttpParameter('cat&dog',  null);
		assert.isNull(instance.value);
		Assert.areEqual('cat%26dog=', instance.toString());
	}
	
	@isTest
    static void compareTestName(){
        List<HttpParameter> items = new List<HttpParameter>();
        items.add(new HttpParameter('before',''));
        items.add(new HttpParameter('after',''));
        items.sort();
        Assert.areEqual('after', items[0].name);
    }

    @isTest
    static void compareTestValue(){
        List<HttpParameter> items = new List<HttpParameter>();
        items.add(new HttpParameter('Same','before'));
        items.add(new HttpParameter('Same','after'));
        items.sort();
        Assert.areEqual('after', items[0].value);
    }
}