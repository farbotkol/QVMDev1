public class Debug {
	private static List<ValueFormatter> formatters = getFormatters();
	
    private static List<ValueFormatter> getFormatters(){
		List<ValueFormatter> items = new List<ValueFormatter>();
		items.add(new NullValueFormatter());
		items.add(new IdFormatter());
		items.add(new StringFormatter());
 
		items.add(new DateFormatter());
		items.add(new TimeFormatter());
		items.add(new DateTimeFormatter());
		
		items.add(new IntegerFormatter());
		items.add(new DecimalFormatter());
		items.add(new LongFormatter());
		items.add(new DecimalFormatter());
		items.add(new DoubleFormatter());
		items.add(new BooleanFormatter());
		
		items.add(new BlobFormatter());
		items.add(new ExceptionFormatter());
		items.add(new HttpResponseFormatter());
		
		return items;
	}
	private class HttpResponseFormatter extends ValueFormatter
	{
		public override Boolean canDescribe(Object value){
			return (value instanceof HttpResponse);
		}
		public override String describeValue(Object value){
			HttpResponse response = (HttpResponse) value;
			String retVal = MessageFormat.format('Status Code : {0} ({1})',response.getStatusCode(), response.getStatus());
			for(String header: response.getHeaderKeys())
			{
				retVal=retVal+ '\n'+header+' : ' + response.getHeader(header);
			}
			retVal = retVal+'\n'+ response.getBody();
	        return retVal;
		}
	}
	
	private abstract class ValueFormatter
	{
		public abstract Boolean canDescribe(Object value );
		public abstract String describeValue(Object value);
	}
    private class DateFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Date);
		}
		public override String describeValue(Object value){
			Date theValue = (Date) value;
	        return theValue.format();
		}
	}

    private class DoubleFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Double);
		}
		public override String describeValue(Object value){
			Double theValue = (Double) value;
	        return theValue.format();
		}
	}

    private class IntegerFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Integer);
		}
		public override String describeValue(Object value){
			Integer theValue = (Integer) value;
	        return theValue.format();
		}
	}
	private class DecimalFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Decimal);
		}
		public override String describeValue(Object value){
			Decimal theValue = (Decimal) value;
	        return theValue.format();
		}
	}

    private class BooleanFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Boolean);
		}
		public override String describeValue(Object value){
			Boolean theValue = (Boolean) value;
	        return String.valueOf(theValue);
		}
	}

    private class TimeFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Time);
		}
		public override String describeValue(Object value){
			Time theValue = (Time) value;

	        return String.valueOf(theValue);
		}
	}
	private class DateTimeFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof DateTime);
		}
		public override String describeValue(Object value){
			DateTime theValue = (DateTime) value;

	        return theValue.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
		}
	}
	private class LongFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Long);
		}
		public override String describeValue(Object value){
			Long theValue = (Long) value;
	        return theValue.format();
		}
	}
	private class BlobFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Blob);
		}
		public override String describeValue(Object value){
			Blob theValue = (Blob) value;
	        return String.valueOf(theValue);
		}
	}
	private class IdFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Id);
		}
		public override String describeValue(Object value){
			ID theValue =(ID) value;
			Schema.SObjectType metaData= theValue.getSobjectType();
        	Schema.DescribeSObjectResult describe = metaData.getDescribe();
        	return '[ID] '+ String.valueOf(theValue) +' (' + describe.name +')';
		}
	}
	private class ExceptionFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof Exception);
		}
		public override String describeValue(Object value){
			Exception ex = (Exception) value;
	        return '[' + ex.getTypeName() + '] ' + ex.getMessage(); 
		}
	}
	private class StringFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return (value instanceof String);
		}
		public override String describeValue(Object value){
			String text = (String) value;
			if (String.isEmpty(text)){
	            return '[String] length: 0';
	        } 
	        Integer length = text.length();

	        if (String.isBlank(text)){
	            return '[String] length: '+ length +' (white space)';
	        }
	        return '\''+text+'\'';
		}
	}
	private class NullValueFormatter extends ValueFormatter{
		public override Boolean canDescribe(Object value){
			return value==null;
		}
		public override String describeValue(Object value){
			return '<NULL>';
		}
	}
	//FOR DIAGNOSTICS AND EXCEPTION MESSAGES 
	//given any object will convert it to a string representation
    public static String describe(Object value) {
        for(ValueFormatter item:formatters)
        {
        	if (item.canDescribe(value))
        	{
        		return item.describeValue(value);
        	}
        }

	    //could not describe the value so just use a string equivelant
	    String valueString= String.valueOf(value);
	    return '[Object] '+valueString;
    }
}