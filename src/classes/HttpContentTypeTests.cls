@isTest
private class HttpContentTypeTests {
	@isTest
    public static void constructorEmpty()
    {
    
        TestHelpers.runConstructorTest('','');
        TestHelpers.runConstructorTest('  ','');
        TestHelpers.runConstructorTest(';','');
    }
    @isTest
    static void constructorMediaType(){
        HttpContentType instance = new HttpContentType(MediaType.html);
        Assert.areEqual('text/html', instance.getMediaType());
        Assert.areEqual('text/html', instance.toString());
    } 

    @isTest
    static void constructorMediaTypeWithCharset(){
       
        HttpContentType instance = new HttpContentType(MediaType.html, 'utf-8');

        Assert.areEqual('text/html', instance.getMediaType(),'Media type incorrect');
        Assert.areEqual('text/html; charset=utf-8', instance.toString(), 'toString incorrect');
    } 

    @isTest
    static void constructorNull()
    {
        TestHelpers.runConstructorTest(null,'');
    }
    @isTest
    static void isMediaType(){
        TestHelpers.isMediaType('application/json;charset=utf-8');
        TestHelpers.isMediaType('application/json;');
        TestHelpers.isMediaType('application/json; charset=utf-8');
        TestHelpers.isMediaType('application/json; charset=UTF-8');
    }
    
    @isTest
    static void constructorValue()
    {
         TestHelpers.runConstructorTest('application/json','application/json');
    }
    @isTest
    static void constructorValue2()
    {
         TestHelpers.runConstructorTest('application/json;charset=utf-8','application/json');
    }
   
    @isTest
    static void constructorValue3()
    {
        TestHelpers.runConstructorTest('application/json; charset=utf-8','application/json');
    }
    @isTest
    static void constructorValue4()
    {
        TestHelpers.runConstructorTest('application/json ;charset=utf-8','application/json');
    }
    @isTest
    static void toStringNoValue()
    {
        TestHelpers.runToStringTest('  ','');
        TestHelpers.runToStringTest(null,'');
    }
    @isTest
    static void toStringWithValue()
    {
        TestHelpers.runToStringTest('application/json','application/json');
        TestHelpers.runToStringTest('application/json;','application/json');
    }
    @isTest static void toStringWithWhiteSpace()
    {
        TestHelpers.runToStringTest('application/json ;charset=utf-8','application/json; charset=utf-8');
        TestHelpers.runToStringTest('application/json ; charset =  utf-8; ','application/json; charset=utf-8');
    }
    

}