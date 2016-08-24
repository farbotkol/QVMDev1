//Replicates the functionality of the java class with the same name
//at this time has only a limited subset of the java capabilities
public class MessageFormat {
	private final String pattern;
	public MessageFormat(String pattern) {
		this.pattern = pattern;
	}

	public String format(List<Object> arguments){
		List<String> stringArgs = new List<String>();
		for(Object item : arguments){
			stringArgs.add(String.valueOf(item));
		}
		return String.format(pattern,stringArgs);
	}

	//convenience routine
	public static String format(String pattern, Object arg){
        return String.format(pattern, new List<String>{String.valueOf(arg)} );
    }
	//convenience routine
    public static String format(String pattern, Object arg1, Object arg2){
        return String.format(pattern, new List<String>{String.valueOf(arg1),String.valueOf(arg2)});
    }
	//convenience routine
    public static String format(String pattern, Object arg1, Object arg2, Object arg3){
        return String.format(pattern, new List<String>{String.valueOf(arg1),String.valueOf(arg2),String.valueOf(arg3)});
    }
}