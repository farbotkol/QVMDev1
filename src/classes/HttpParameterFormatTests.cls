@isTest
class HttpParameterFormatTests {
	
    private virtual class TestFixture {
       protected HttpParameterFormat instance;
       protected String testDescription;
       public EncodeTestFixture run(String name, String value){
            return run(new HttpParameter(name, value));
        }
        protected virtual void reset(){
         
            testDescription = null;
        }
        public TestFixture with(HttpParameterFormat instance){
            this.instance = instance;
            reset();
            return this;
        }
        public TestFixture withFormUrl(){
            return with(HttpParameterFormat.FormUrl);
        }
        public TestFixture withUrl(){
            return with(HttpParameterFormat.Url);
        }
		public TestFixture withAuthHeader(){
            return with(HttpParameterFormat.AuthorizationHeader);
        }
        public virtual ReadTestFixture runRead(String value){
            return new ReadTestFixture(this).runRead(value);
        }
        public virtual EncodeTestFixture run(HttpParameter value){
			return new EncodeTestFixture(this).run(value);
            
        }
    }
    private class ReadTestFixture extends TestFixture {
        List<HttpParameter> result;
        Integer selectedItem;
        
        public ReadTestFixture(TestFixture testFixture){
            this.instance = testFixture.instance;
            
        }
        protected override void reset(){
            super.reset();
            selectedItem = -1;
            result = null;
        }
    
        private String describeResult(){
            Integer count = result.size();
            String retVal =MessageFormat.format('result contains {0} item(s)',count);
            for(Integer index=0;index<count;index++){
                retVal=MessageFormat.format('{0}\n\n{1})  Name: {2}',retVal,index, result[index].name);
                retVal=MessageFormat.format('{0}\n    Value: {1}',retVal, result[index].value);
            }
            return retVal;
        }
        public override ReadTestFixture runRead(String value) {
            reset();
            this.testDescription = MessageFormat.format('Using [{0}]: reading("{1}")',instance.getName(), value);
          	Iterator<HttpParameter> reader= instance.getValueReader(value);
            result  = new List<HttpParameter>( );
            while(reader.hasNext()){
                result.add(reader.next());
            }
            this.testDescription = this.testDescription +'\n\n' + describeResult();
            return this;
        }
        public ReadTestFixture countShouldBe(Integer expected){
            Assert.areEqual(expected, result.size(), 'Incorrect count.  '+ testDescription);
            return this;
        }
        public ReadTestFixture shouldHaveNoNullItems(){
            for(Integer index=0;index<result.size();index++){
                Assert.isNotNull(result[index],'Item {0} is null.{1}', index, testDescription);
            }
            return this;
        }
        
        public ReadTestFixture item(Integer index){
           	
            selectedItem =index;
            return this;
        }
        public ReadTestFixture valueIs(String expected){
            assert.areEqual(expected, result[selectedItem].value, 'Item {0} value {1}', selectedItem, testDescription);
        	return this;
        }
        public ReadTestFixture nameIs(String expected){
            assert.areEqual(expected, result[selectedItem].name, 'Item {0} name {1} ', selectedItem, testDescription);
        	return this;
        }
    }
    private class EncodeTestFixture extends TestFixture {
        
        String result;
        
        public EncodeTestFixture(TestFixture testFixture){
            this.instance = testFixture.instance;
            
        }
        
     	public override EncodeTestFixture run(HttpParameter value) {
            this.testDescription = MessageFormat.format('Using [{0}]: format({1})',instance.getName(), describeParameter(value));
          	
            this.result = instance.format(value);
            return this;  
        }
        private String describeParameter(HttpParameter value){
            if (value==null){
                return '<NULL>';
            }
            return MessageFormat.format('(name:{0}, value:{1})', value.name, value.value);
        }
        
        public EncodeTestFixture shouldBe(String expected){
            Assert.areEqual(expected, result, testDescription);
            return this;
        }
    }
   
    static TestFixture test(){
        return new TestFixture();
    }
    @isTest
    static void nullInput(){
        test().withUrl().run(null).shouldBe('');
        test().withFormUrl().run(null).shouldBe('');
        test().withAuthHeader().run(null).shouldBe('');
    }
    @isTest
    static void urlFormat(){ 
        test().withUrl().run('name',null).shouldBe('name=');
		test().withUrl().run('has space','&&&').shouldBe('has%20space=%26%26%26');	
        test().withUrl().run(null,'&&&').shouldBe('%26%26%26');	
    }
     @isTest
    static void formUrlFormat(){
        test().withFormUrl().run('name',null).shouldBe('name=');
		test().withFormUrl().run('has space','&&&').shouldBe('has+space=%26%26%26');	
        test().withFormUrl().run(null,'&&&').shouldBe('%26%26%26');	
    }
    
     @isTest
    static void authHeaderFormat(){
        test().withAuthHeader().run('name',null).shouldBe('name=""');
		test().withAuthHeader().run('has space','&&&').shouldBe('has%20space="%26%26%26"');	
        test().withAuthHeader().run(null,'&&&').shouldBe('&&&');	
    }
    
    @isTest
    static void readUrlEmpty(){
        test().withUrl()
            .runRead(null).countShouldBe(0)
            .runRead('').countShouldBe(0);
            //TODO: what should this really do?
            //.runRead('    ').countShouldBe(1).item(0).nameIs(null).valueIs('    ')
            //.runRead('&').countShouldBe(1).item(0).nameIs(null).valueIs('&');
    }
    @isTest
    static void readUrlOneItem(){
    
         test().withUrl().runRead('has+space=%26%26%26').countShouldBe(1)
                .item(0).nameIs('has space').valueIs('&&&');
    }
    private static void readUrlOneItemOneOddValue(String testCase, String expectedValue){
        test().withUrl().runRead(testCase).countShouldBe(2)
                .item(0).nameIs('has space').valueIs('&&&')
                .item(1).nameIs(null).valueIs(expectedValue);   
    }
    @isTest
    static void readUrlOneItemOneOddValue()
    {
        readUrlOneItemOneOddValue('has+space=%26%26%26&A','A');
        //TODO: this isn't working right - bit of an edge case
        readUrlOneItemOneOddValue('has+space=%26%26%26&','');
        readUrlOneItemOneOddValue('has+space=%26%26%26& ',' ');
        
        
    }
    @isTest
    static void normalize(){
        String result= HttpParameterFormat.Url.normalize('query=Select * from Customer&v=3');
        Assert.areEqual('query=Select%20*%20from%20Customer&v=3',result);
    }
    @isTest
    static void readUrlTwoItems(){
       //different variants all meaning the same
        test().withUrl().runRead('name=some%20value&other=%26another%20value')
            .countShouldBe(2)
            .item(0).nameIs('name').valueIs('some value')
            .item(1).nameIs('other').valueIs('&another value');
    }
    
}