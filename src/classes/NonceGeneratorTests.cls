@isTest
class NonceGeneratorTests {
    @isTest
    static void testDefault(){
        NonceGenerator instance = new NonceGenerator();
        //make a heap of values.. they should all be 42 characters long
        //and match the regex
        for(Integer i=0;i<500;i++){
           String nonce= instance.generateNonce();
           Assert.isMatch('^\\w{42}$', nonce);
        }
        
    }	
    @isTest
    static void emptyStingConstructor(){
    	try
        {
            new NonceGenerator('',100);
        	Assert.fail('Error was not thrown');
	
        }catch(Exception ex){
            Assert.areEqual('ArgumentException', ex.getTypeName() );
            Assert.areEqual('\'validValues\' is invalid', ex.getMessage());
        }
    }
    @isTest
    static void nullStringConstructor(){
    	try
        {
            new NonceGenerator((String)null,100);
        	Assert.fail('Error was not thrown');
	
        }catch(Exception ex){
            Assert.areEqual('ArgumentNullException', ex.getTypeName() );
            Assert.areEqual('\'validValues\' is null', ex.getMessage());
        }
    }
    @isTest
    static void nullListConstructor(){
    	try
        {
            new NonceGenerator((List<Integer>)null,100);
        	Assert.fail('Error was not thrown');
	
        }catch(Exception ex){
            Assert.areEqual('ArgumentNullException', ex.getTypeName() );
            Assert.areEqual('\'validValues\' is null', ex.getMessage());
        }
    }
    
    @isTest
    static void invalidLengthConstructor(){
    	try
        {
            new NonceGenerator('abc123',0);
        	Assert.fail('Error was not thrown');
	
        }catch(Exception ex){
            Assert.areEqual('ArgumentException', ex.getTypeName() );
            Assert.areEqual('nonceLength must be greater than 0', ex.getMessage());
        }
    }
    @isTest
    static void oneValidValue(){
        NonceGenerator generator= new NonceGenerator('a'.getChars(),100);
    	String nonce = generator.generateNonce();
        Assert.areEqual(100, nonce.length());
        Assert.isMatch('^a{100}$', nonce);
    }
}