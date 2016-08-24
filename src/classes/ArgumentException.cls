//TODO: remove this class and replace with built in InvalidParameterValueException
public virtual class ArgumentException extends Exception {
	private String argument;
	
    public ArgumentException argument(String argument){
		this.argument = argument;
        return this;
	}

	public String getArgument()
	{
		return argument;
	}
    public ArgumentException withMessage(String message){
        setMessage(message);
        return this;
    }
     public ArgumentException withMessage(String pattern, Object arg){
        setMessage(MessageFormat.format(pattern, arg));
        return this;
    }
	public static ArgumentException forArgument(String argument){
		String message;
		if (String.isEmpty(argument)){
			message ='an argument is invalid'; 
		} else {
			message ='\''+argument+'\' is invalid';
		} 
		return new ArgumentException(message).argument(argument);
	}
    

	public static ArgumentException create(String argument, String message){
		return forArgument(argument).withMessage(message);

	}
}