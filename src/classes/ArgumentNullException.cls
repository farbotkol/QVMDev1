//TODO: remove this class and replace with built in InvalidParameterValueException 
public class ArgumentNullException extends ArgumentException {
	public static ArgumentNullException create(String argument){
		String message;
		if (String.isEmpty(argument)){
			message ='Argument is null'; 
		} else {
			message ='\''+argument+'\' is null';
		} 
        ArgumentNullException instance = new ArgumentNullException(message);
        instance.argument(argument);
		return instance;
		
	}
    
}