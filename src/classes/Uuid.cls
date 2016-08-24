public class  Uuid {

	private final String value;
	
	private static final Pattern isValidHyphens = Pattern.compile('^([A-F0-9a-f]{8})-([A-F0-9a-f]{4})-([A-F0-9a-f]{4})-([A-F0-9a-f]{4})-([A-F0-9a-f]{12})$');
	private static final Pattern isValidNoHtphens = Pattern.compile('^[A-F0-9a-f]{32}$');
	public static final Uuid EMPTY = new Uuid('00000000-0000-0000-0000-000000000000');

	private static String removeUuidBrackets(String uuidString){
		if (uuidString.length()==38){
			if ( (uuidString.startsWith('{') && uuidString.endsWith('}') ) ||(uuidString.startsWith('(') && uuidString.endsWith(')'))) {
				uuidString = uuidString.substring(1,37);
			}
		}
		return uuidString;	
	}
	private static String addHyphens(String uuidString){
		uuidString = uuidString.toUpperCase();

		return String.join(new List<String>{
			uuidString.substring(0,8),
			uuidString.substring(9,12),
			uuidString.substring(13,16),
			uuidString.substring(17,20),
			uuidString.substring(21,32)
		 }, '-');
	}
	public Uuid(String uuidString){
		if (uuidString==null){
			throw ArgumentNullException.create('uuidString');
		}
		
		if (uuidString.length()==32 && isValidNoHtphens.matcher(uuidString).matches()){
			value = addHyphens(uuidString);
			return;
		}
		
		uuidString = removeUuidBrackets(uuidString);
		if (!isValidHyphens.matcher(uuidString).matches()) {
			throw ArgumentException.forArgument('uuidString');
		}

		value=uuidString.toUpperCase();
	}
	public Uuid(Uuid other){
		value = other.value;
	}
	
	public Boolean equals(Uuid otherUuid){
		return otherUuid!=null && otherUuid.value==this.value;
	}
	public Boolean equals(Object obj) {
    	if (obj instanceof Uuid){
			return equals((Uuid) obj);
    	}
    	return false;
	}
	public Integer hashCode(){
		return value.hashCode();
	}
	public String toString(String format){
		if (format==null)
		{
			throw ArgumentNullException.create('format');
		}
		
		if (format=='n' || format=='N'){
			return value.replace('-','');
		}
		if (format=='d' || format=='D'){

			return value;
		}
		if (format=='b' || format=='B'){

			return '{'+value+'}';
		}
		if (format=='p' || format=='P'){

			return '('+value+')';
		}
		throw ArgumentException.forArgument('format').withMessage('Invalid format, allowed values N, D, B, P');
	}
	public override String toString(){
		return toString('B');
	}
	public static Uuid newUuid(){

		return new Uuid(EncodingUtil.convertToHex(Crypto.generateAesKey(128)));
	}
}