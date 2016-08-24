public class TestHelpers {

    public static void runToStringTest(string input, string expectedResult){
        
        Assert.areEqual(expectedResult, new HttpContentType(input).toString());
    }
    
    public static void runConstructorTest(string input, string expectedMediaType){
        HttpContentType instance = new HttpContentType(input);
        Assert.areEqual( expectedMediaType, instance.getMediaType());
    }
    
    public static void isMediaType(String input){
        HttpContentType instance= new HttpContentType(input);
         Assert.isTrue( instance.is(MediaType.json));
         Assert.isFalse( instance.is(MediaType.formUrlEncoded));
         Assert.isFalse( instance.is(null));
    }
    
    
    public static void assertContentType(String expectedMediaType, HttpContentType actual){
        System.assert(actual!=null,'Content type should always be a non null value');
        Assert.AreEqual(expectedMediaType,actual.getMediaType());
    }
}