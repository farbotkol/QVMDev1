//helper methods for logging to the system log 
public class Log {
	public static void debug(Object message)
	{
		write(LoggingLevel.DEBUG, message);
	}

	public static void debug(String pattern, Object arg)
	{
		write(LoggingLevel.DEBUG, MessageFormat.format(pattern, Debug.describe(arg)));
	}
    public static void debug(String pattern, Object arg1, Object arg2)
	{
		write(LoggingLevel.DEBUG, MessageFormat.format(pattern, Debug.describe(arg1), Debug.describe(arg2)));
	}
	public static void info(Object message)
	{
		write(LoggingLevel.INFO, message);
	}
	public static void warn(Object message)
	{
		write(LoggingLevel.WARN, message);
	}
    public static void warn(String pattern, Object arg)
	{
		write(LoggingLevel.WARN, MessageFormat.format(pattern, Debug.describe(arg)));
	}
 	public static void warn(String pattern, Object arg1, Object arg2)
	{
		write(LoggingLevel.DEBUG, MessageFormat.format(pattern, Debug.describe(arg1), Debug.describe(arg2)));
	}
	public static void warn(String pattern, Object arg1, Object arg2, Object arg3)
	{
		write(LoggingLevel.DEBUG, MessageFormat.format(pattern, Debug.describe(arg1), Debug.describe(arg2), Debug.describe(arg3)));
	}
	public static void error(Object message)
	{
		write(LoggingLevel.ERROR, message);
	}
     public static void error(String pattern, Object arg)
	{
		write(LoggingLevel.ERROR, MessageFormat.format(pattern, Debug.describe(arg)));
	}
 	public static void error(String pattern, Object arg1, Object arg2)
	{
		write(LoggingLevel.ERROR, MessageFormat.format(pattern, Debug.describe(arg1), Debug.describe(arg2)));
	}
	public static void error(String pattern, Object arg1, Object arg2, Object arg3)
	{
		write(LoggingLevel.ERROR, MessageFormat.format(pattern, Debug.describe(arg1), Debug.describe(arg2), Debug.describe(arg3)));
	}
	public static void write(LoggingLevel level,Object messageObject ){
		System.debug(level, messageObject);
	}
}