public class NonceGenerator implements INonceGenerator{
	private final Integer[] validValues;
	private final Integer validValuesCount;
	private final Integer nonceLength;
	private static final NonceGenerator defaultInstance = new NonceGenerator();
    
    public static NonceGenerator getDefault()
    {
        return defaultInstance;
    }
	public NonceGenerator(){
		this('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',42);
	}
	public NonceGenerator(String validValues, Integer nonceLength){

		this(validValues==null?null: validValues.getChars(), nonceLength);
	}
	public NonceGenerator(List<Integer> validValues, Integer nonceLength){
		if (validValues==null){ throw ArgumentNullException.create('validValues');}
		if (nonceLength<=0){throw ArgumentException.forArgument('nonceLength')
								.withMessage('nonceLength must be greater than 0') ;}
		this.nonceLength = nonceLength;
		this.validValues = validValues;
		this.validValuesCount = validValues.size();
		if (validValuesCount<=0){
			throw ArgumentException.forArgument('validValues');
		}
	}
	public Integer nextValue(){
		Double index =   Math.floor(Math.random() * validValuesCount);

		return validValues[index.intValue()];
	}

	public String generateNonce(){
		Integer[] chars =new Integer[nonceLength];
		for(Integer index=0;index<nonceLength;index++){
			chars[index] = nextValue();
		}
		return String.fromCharArray(chars);
	}
}