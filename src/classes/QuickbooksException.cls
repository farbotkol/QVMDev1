public class QuickbooksException extends Exception {
	
	
	public QuickbooksException causedBy(Exception ex){
		this.initCause(ex);
		return this;
	}
	public QuickbooksException withMessage(String message){
        setMessage(message);
        return this;
    }
    public QuickbooksException withMessage(String pattern, Object arg){
        setMessage(MessageFormat.format(pattern, arg));
        return this;
    }
}