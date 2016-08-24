public with sharing class PriceBookUtils {
	public PriceBookUtils() {
		
	}


	private static Pricebook2 stdPriceBook;  // Singleton, remember when first referenced

	//  ------------------------------------------------------
	//  getStdPricebookId : as of V31, testmethods can locate std pricebook wo seeAlldata=true
	//  ------------------------------------------------------
	public static ID getStdPricebookId() {
	    if (Test.isRunningTest())   return Test.getStandardPricebookId();
	    return getStdPricebook().id;    
	} 

	//  -------------------------------------------------------
	//  getStdPriceBook: Singleton
	//  -------------------------------------------------------
	public static Pricebook2    getStdPriceBook () {
	    if (stdPriceBook == null) 
	        stdPriceBook    = [select id, name from Pricebook2 where isStandard = true limit 1];
	    return stdPriceBook;    
	}
}