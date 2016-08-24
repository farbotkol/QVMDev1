public class InvalidOperationException extends Exception{
	
	public InvalidOperationException withMessage(String message) {
        setMessage(message);
        return this;
    }
    public InvalidOperationException causedBy(Exception cause){

    	initCause(cause);
    	return this;
    }
    public static InvalidOperationException create(){
    	InvalidOperationException instance = new InvalidOperationException();
    	instance.setMessage('Invalid operation');
    	return instance;
    }
}