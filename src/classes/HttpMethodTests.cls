@isTest 
private class HttpMethodTests {
	@isTest
	static void testConstructor() {
		//should normalize to upper case
		Assert.areEqual('GET', new HttpMethod('Get').toString());
		//should trim white space
		Assert.areEqual('GET', new HttpMethod(' get').toString());

	}

	@isTest
	static void checkDefinedValues()
	{
		Assert.areEqual(HttpMethod.GET.toString(),'GET');
		Assert.areEqual(HttpMethod.POST.toString(),'POST');
		Assert.areEqual(HttpMethod.PUT.toString(),'PUT');
		Assert.areEqual(HttpMethod.PATCH.toString(),'PATCH');
		Assert.areEqual(HttpMethod.HTTP_DELETE.toString(),'DELETE');
		Assert.areEqual(HttpMethod.TRACE.toString(),'TRACE');
		Assert.areEqual(HttpMethod.HEAD.toString(),'HEAD');
	}
	@isTest
	static void invalidConstructor(){
        String expectedMessage = 'HttpMethod cannot be created from an empty string';
		runInvalidConstructorTest(null,expectedMessage );
		runInvalidConstructorTest('', expectedMessage);
		runInvalidConstructorTest('   ', expectedMessage);
	}

    @isTest
	static void parse(){
        Assert.areEqual(null, HttpMethod.parse(null));
		Assert.areEqual(null, HttpMethod.parse(' '));
        Assert.areEqual('POST', HttpMethod.parse('post ').toString());
	}
    @isTest
    static void testEquals() {
        Object thing = HttpMethod.POST;
        Assert.that(thing =='post');
        Assert.that(thing !='Get');
        Assert.that(thing == HttpMethod.POST);
        Assert.that(thing != HttpMethod.GET);
        Assert.that(thing == HttpMethod.parse('post'));
    }
    @isTest
    static void testEqualsMethod(){
        HttpMethod instance = HttpMethod.POST;
        Object testValue;
        Assert.isFalse(instance.equals(testValue));
        testValue=666;
        Assert.isFalse(instance.equals(testValue));
        
    }
    @isTest
    static void twoInstancesHaveSameHashCode(){
        HttpMethod instanceA = new HttpMethod('get');
        HttpMethod instanceB = new HttpMethod('GET');
        Assert.areNotEqual(0, instanceA.hashCode());
        Assert.areEqual(instanceA.hashCode(), instanceB.hashCode()); 
    }
	static void runInvalidConstructorTest(String input, String expectedMessage)
	{
		try
		{
			 new HttpMethod(input);
            Assert.fail('Exception was not thrown for '+Debug.describe(input));
		} catch (ArgumentException ex){
			Assert.areEqual(expectedMessage, ex.getMessage(), 'Exception message incorrect');
            
		} 
		
	}
	
	
	
}