//test class for doing assertions and giving reasnoble messages
public class Assert {
    private abstract class Constraint 
    {
        private List<Object> formatArgs;
        private String message;
   

        protected Constraint(){
        
        }

        public Constraint withMessage(String message){
            this.message = message;
            return this;
        }
        public Constraint formatArg(Object value){
            if (formatArgs==null){
                formatArgs = new List<Object>();
            }
            formatArgs.add(value);
            return this;
        }
        
        public void assertIsValid(Object value){
            if (!isValid(value)){
                String details=MessageFormat.format('Expected: {0}\nActual  : {1}', expectedMessage(), Debug.describe(value));
                String message = exceptionMessage(details);
                throw new AssertException(message);
            }
        }
        protected abstract String expectedMessage();
        public abstract Boolean isValid(Object value);

        private  String exceptionMessage(String details){
            String retVal= failureMessage();
            if (!String.isBlank(details)){
                if (String.isBlank(retVal)){
                    retVal = details;
                } else {
                    //indent the detail lines so they appear separate to the other
                    //message
                    retVal += '\n    '+details.replace('\n', '\n    ');
                }
            }
            return retVal;
        }

        //runs the formatting on the current state and caches the result
        private String failureMessage(){
            if (formatArgs!=null && !formatArgs.isEmpty()){
                List<String> values = new List<String>();
                for(Object item:formatArgs){
                    values.add(Debug.describe(item));
                }
                message =String.format(message, values);
                formatArgs.clear();
             }
              
             return message;
        }
        
    }
    private class RegexConstraint extends Constraint
    {
        private final String regex;
        public RegexConstraint(String regex){
            this.regex=regex;
        }
        protected override String expectedMessage(){
            return 'string matching \''+regex+'\'';
        }
        public override Boolean isValid(Object value){
            return (value!=null && Pattern.matches(regex, String.valueOf(value)));
        }
    }
    private class EqualConstraint extends Constraint{
        private final Object expected;
        public EqualConstraint(Object expected){
            this.expected = expected;
        }
        protected override String expectedMessage(){
            return Debug.describe(expected);
        }
        public override Boolean isValid(Object value){
            if (value === (Object) null) {
                return (this.expected ===  (Object) null);
            }
            return System.equals(value,expected);
        }
    }
    private class NotEqualConstraint extends Constraint{
        private final Object expected;
        public NotEqualConstraint(Object expected){
            this.expected = expected;
        }
        protected override String expectedMessage(){
            return 'not equal to ' + Debug.describe(expected);
        }
        public override Boolean isValid(Object value){
            return (value!=expected);
        }
    }
    private class AreSameConstraint extends Constraint {
        private final Object expected;
     
        public AreSameConstraint(Object expected){
            this.expected = expected;
        }

        protected override String expectedMessage(){
            return 'the same instance as ' + Debug.describe(expected);
        }
        public override Boolean isValid(Object value){
            return (value===expected);
        }
    }
    
    private class NullConstraint extends Constraint{
       
        public NullConstraint(){
            
        }
        protected override String expectedMessage(){
            return '<NULL>';
        }
        public override Boolean isValid(Object value){
            return (value==null);
        }
    }
    private class NotNullConstraint extends Constraint{
       
        public NotNullConstraint(){
            
        }
        protected override String expectedMessage(){
            return 'non null value';
        }
        public override Boolean isValid(Object value){
            return (value!=null);
        }
    }
    
    public static void isMatch(String regex, String input){
    	  new RegexConstraint(regex).assertIsValid(input);
    } 
    //describes a value for inclusing in an assert failure message
    public static void isMatch(String regex, String input, String message){
        new RegexConstraint(regex).withMessage(message).assertIsValid(input);
    }     
     //describes a value for inclusing in an assert failure message
    public static void isMatch(String regex, String input, String messageFormat, Object arg1){
        new RegexConstraint(regex)
                .withMessage(messageFormat)
                .formatArg(arg1)
                .assertIsValid(input);
    }     
     
    public static void isTrue(Boolean actual){
        areEqual(true, actual);
    }
    public static void isTrue(Boolean actual, String message){
        new EqualConstraint(true).withMessage(message).assertIsValid(actual);
    }
    public static void isTrue(Boolean actual, String messageFormat, Object arg1){
        new EqualConstraint(true)
            .withMessage(messageFormat)
            .formatArg(arg1)
            .assertIsValid(actual);
    }
    public static void isFalse(Boolean actual){
        areEqual(false, actual);
    }
    
    
    public static void that(Boolean condition, String message, Object arg1) {
        if (!condition){
            throw new AssertException(MessageFormat.format(message, Debug.describe( arg1)));
        }
    }
    public static void that(Boolean condition, String message) {
        if (!condition){
            throw new AssertException(message);
        }
    }

    public static void that(Boolean condition) {
        System.assert(condition);
    }
    public static void fail(String message){
        throw new AssertException(message);
    }
    public static void isNotNull(Object value) {
        new NotNullConstraint().assertIsValid(value);
    }
    public static void isNotNull(Object value, String message) {
        new NotNullConstraint().withMessage(message).assertIsValid(value);
    }
     public static void isNotNull(Object value, String pattern, Object arg1) {
        new NotNullConstraint()
            .withMessage(pattern)
            .formatArg(arg1)
            .assertIsValid(value);
    }
	 public static void isNotNull(Object value, String pattern, Object arg1, Object arg2) {
        new NotNullConstraint()
            .withMessage(pattern)
            .formatArg(arg1)
            .formatArg(arg2)
            .assertIsValid(value);
    }
    public static void isNull(Object value) {
        new NullConstraint().assertIsValid(value);
    }

    public static void areEqual(Object expected, Object actual) {
        new EqualConstraint(expected).assertIsValid(actual);
    }

    public static void areEqual(Object expected, Object actual, String messageFormat, Object arg1, Object arg2) {
        new EqualConstraint(expected)
                .withMessage(messageFormat)
                .formatArg(arg1)
                .formatArg(arg2)
                .assertIsValid(actual);
    }
    public static void areEqual(Object expected, Object actual, String messageFormat, Object arg1) {
        new EqualConstraint(expected)
                .withMessage(messageFormat)
                .formatArg(arg1)
                .assertIsValid(actual);
    }
    public static void areEqual(Object expected, Object actual, String message) {
        new EqualConstraint(expected).withMessage(message).assertIsValid(actual);
    }
    public static void areNotEqual(Object expected, Object actual) {
        new NotEqualConstraint(expected).assertIsValid(actual);
        
    }
   
    public static void areNotEqual(Object expected, Object actual, String message) {
        new NotEqualConstraint(expected).withMessage(message).assertIsValid(actual);
    }

    public static void areSame(Object expected, Object actual){
        new AreSameConstraint(expected).assertIsValid(actual);
    }
     public static void areSame(Object expected, Object actual, String message){
        new AreSameConstraint(expected).withMessage(message).assertIsValid(actual);
    }
}