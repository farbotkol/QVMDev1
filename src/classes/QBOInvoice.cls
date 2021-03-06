//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are reserved words in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class QBOInvoice {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class BillAddr {
		@AuraEnabled public String Id {get;set;} 
		@AuraEnabled public String CountrySubDivisionCode {get;set;} 
		@AuraEnabled public String Line1 {get;set;} 
		@AuraEnabled public String Line2 {get;set;} 
		@AuraEnabled public String Line3 {get;set;} 


		public BillAddr() {}

		public BillAddr(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'CountrySubDivisionCode') {
							CountrySubDivisionCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BillAddr consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Reference {
		@AuraEnabled public String value {get;set;} 
		@AuraEnabled public String name {get;set;} 

        public Reference() {}
        
		public Reference(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Reference consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
    @AuraEnabled public Integer Deposit {get;set;} 
    @AuraEnabled public Boolean AllowIPNPayment {get;set;} 
    @AuraEnabled public Boolean AllowOnlinePayment {get;set;} 
    @AuraEnabled public Boolean AllowOnlineCreditCardPayment {get;set;}
    @AuraEnabled public Boolean AllowOnlineACHPayment {get;set;} 
    @AuraEnabled public String domain {get;set;} 
    @AuraEnabled public Boolean sparse {get;set;} 
	@AuraEnabled public String Id {get;set;} 
	@AuraEnabled public String SyncToken {get;set;} 
	@AuraEnabled public MetaData MetaData {get;set;} 
	@AuraEnabled public List<CustomField> CustomField {get;set;} 
	@AuraEnabled public String DocNumber {get;set;} 
	@AuraEnabled public String TxnDate {get;set;} 
	@AuraEnabled public Reference CurrencyRef {get;set;} 
	@AuraEnabled public Integer ExchangeRate {get;set;} 
	@AuraEnabled public String PrivateNote {get;set;} 
	@AuraEnabled public List<LinkedTxn> LinkedTxn {get;set;} 
	@AuraEnabled public List<Line> Line {get;set;} 
	@AuraEnabled public TxnTaxDetail TxnTaxDetail {get;set;} 
	@AuraEnabled public Reference CustomerRef {get;set;} 
	@AuraEnabled public TaxCodeRef CustomerMemo {get;set;} 
	@AuraEnabled public BillAddr BillAddr {get;set;} 
	@AuraEnabled public BillAddr ShipAddr {get;set;} 
	@AuraEnabled public TaxCodeRef SalesTermRef {get;set;} 
	@AuraEnabled public String DueDate {get;set;} 
	@AuraEnabled public String GlobalTaxCalculation {get;set;} 
	@AuraEnabled public Double TotalAmt {get;set;} 
	@AuraEnabled public Double HomeTotalAmt {get;set;} 
	@AuraEnabled public String PrintStatus {get;set;} 
	@AuraEnabled public String EmailStatus {get;set;} 
	@AuraEnabled public BillEmail BillEmail {get;set;} 
	@AuraEnabled public Double Balance {get;set;} 
	@AuraEnabled public Double HomeBalance {get;set;} 
    @AuraEnabled public boolean overdue {get;set;} 


    public QBOInvoice() {}
    
	public QBOInvoice(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'Deposit') {
						Deposit = parser.getIntegerValue();
					} else if (text == 'AllowIPNPayment') {
						AllowIPNPayment = parser.getBooleanValue();
					} else if (text == 'AllowOnlinePayment') {
						AllowOnlinePayment = parser.getBooleanValue();
					} else if (text == 'AllowOnlineCreditCardPayment') {
						AllowOnlineCreditCardPayment = parser.getBooleanValue();
					} else if (text == 'AllowOnlineACHPayment') {
						AllowOnlineACHPayment = parser.getBooleanValue();
					} else if (text == 'domain') {
						domain = parser.getText();
					} else if (text == 'sparse') {
						sparse = parser.getBooleanValue();
					} else if (text == 'Id') {
						Id = parser.getText();
					} else if (text == 'SyncToken') {
						SyncToken = parser.getText();
					} else if (text == 'MetaData') {
						MetaData = new MetaData(parser);
					} else if (text == 'CustomField') {
						CustomField = new List<CustomField>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							CustomField.add(new CustomField(parser));
						}
					} else if (text == 'DocNumber') {
						DocNumber = parser.getText();
					} else if (text == 'TxnDate') {
						TxnDate = parser.getText();
					} else if (text == 'CurrencyRef') {
						CurrencyRef = new Reference(parser);
					} else if (text == 'ExchangeRate') {
						ExchangeRate = parser.getIntegerValue();
					} else if (text == 'PrivateNote') {
						PrivateNote = parser.getText();
					} else if (text == 'LinkedTxn') {
						LinkedTxn = new List<LinkedTxn>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							LinkedTxn.add(new LinkedTxn(parser));
						}
					} else if (text == 'Line') {
						Line = new List<Line>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							Line.add(new Line(parser));
						}
					} else if (text == 'TxnTaxDetail') {
						TxnTaxDetail = new TxnTaxDetail(parser);
					} else if (text == 'CustomerRef') {
						CustomerRef = new Reference(parser);
					} else if (text == 'CustomerMemo') {
						CustomerMemo = new TaxCodeRef(parser);
					} else if (text == 'BillAddr') {
						BillAddr = new BillAddr(parser);
					} else if (text == 'ShipAddr') {
						ShipAddr = new BillAddr(parser);
					} else if (text == 'SalesTermRef') {
						SalesTermRef = new TaxCodeRef(parser);
					} else if (text == 'DueDate') {
						DueDate = parser.getText();
					} else if (text == 'GlobalTaxCalculation') {
						GlobalTaxCalculation = parser.getText();
					} else if (text == 'TotalAmt') {
						TotalAmt = parser.getDoubleValue();
					} else if (text == 'HomeTotalAmt') {
						HomeTotalAmt = parser.getDoubleValue();
					} else if (text == 'PrintStatus') {
						PrintStatus = parser.getText();
					} else if (text == 'EmailStatus') {
						EmailStatus = parser.getText();
					} else if (text == 'BillEmail') {
						BillEmail = new BillEmail(parser);
					} else if (text == 'Balance') {
						Balance = parser.getDoubleValue();
					} else if (text == 'HomeBalance') {
						HomeBalance = parser.getDoubleValue();
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class SalesItemLineDetail {
		@AuraEnabled public Reference ItemRef {get;set;} 
		@AuraEnabled public Reference ClassRef {get;set;} 
		@AuraEnabled public Decimal UnitPrice {get;set;} 
		@AuraEnabled public Decimal Qty {get;set;} 
		@AuraEnabled public TaxCodeRef TaxCodeRef {get;set;} 
        @AuraEnabled public String ServiceDate {get;set;}

        public SalesItemLineDetail() {}
        
		public SalesItemLineDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'ItemRef') {
							ItemRef = new Reference(parser);
						} else if (text == 'ClassRef') {
							ClassRef = new Reference(parser);
						} else if (text == 'UnitPrice') {
							UnitPrice = parser.getDecimalValue();
						} else if (text == 'Qty') {
							Qty = parser.getDecimalValue();
						} else if (text == 'TaxCodeRef') {
							TaxCodeRef = new TaxCodeRef(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'SalesItemLineDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TaxLine {
		@AuraEnabled public Double Amount {get;set;} 
		@AuraEnabled public String DetailType {get;set;} 
		@AuraEnabled public TaxLineDetail TaxLineDetail {get;set;} 

		public TaxLine(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Amount') {
							Amount = parser.getDoubleValue();
						} else if (text == 'DetailType') {
							DetailType = parser.getText();
						} else if (text == 'TaxLineDetail') {
							TaxLineDetail = new TaxLineDetail(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TaxLine consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Line {
		@AuraEnabled public String Id {get;set;} 
		@AuraEnabled public Integer LineNum {get;set;} 
		@AuraEnabled public String Description {get;set;} 
		@AuraEnabled public Double Amount {get;set;} 
		@AuraEnabled public String DetailType {get;set;} 
		@AuraEnabled public SalesItemLineDetail SalesItemLineDetail {get;set;} 
		@AuraEnabled public SubTotalLineDetail SubTotalLineDetail {get;set;} 
		@AuraEnabled public DiscountLineDetail DiscountLineDetail {get;set;} 

        public Line() {}
        
        public Line(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'LineNum') {
							LineNum = parser.getIntegerValue();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'Amount') {
							Amount = parser.getDoubleValue();
						} else if (text == 'DetailType') {
							DetailType = parser.getText();
						} else if (text == 'SalesItemLineDetail') {
							SalesItemLineDetail = new SalesItemLineDetail(parser);
						} else if (text == 'SubTotalLineDetail') {
							SubTotalLineDetail = new SubTotalLineDetail(parser);
						} else if (text == 'DiscountLineDetail') {
							DiscountLineDetail = new DiscountLineDetail(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Line consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DiscountLineDetail {
		@AuraEnabled public Boolean PercentBased {get;set;} 
		@AuraEnabled public Integer DiscountPercent {get;set;} 
		@AuraEnabled public Reference DiscountAccountRef {get;set;} 

		public DiscountLineDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'PercentBased') {
							PercentBased = parser.getBooleanValue();
						} else if (text == 'DiscountPercent') {
							DiscountPercent = parser.getIntegerValue();
						} else if (text == 'DiscountAccountRef') {
							DiscountAccountRef = new Reference(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DiscountLineDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TaxCodeRef {
		@AuraEnabled public String value {get;set;} 

        public TaxCodeRef() {}
		public TaxCodeRef(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'TaxCodeRef consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SubTotalLineDetail {

		public SubTotalLineDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'SubTotalLineDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class MetaData {
		@AuraEnabled public String CreateTime {get;set;} 
		@AuraEnabled public String LastUpdatedTime {get;set;} 

		public MetaData(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'CreateTime') {
							CreateTime = parser.getText();
						} else if (text == 'LastUpdatedTime') {
							LastUpdatedTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MetaData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TaxLineDetail {
		@AuraEnabled public TaxCodeRef TaxRateRef {get;set;} 
		@AuraEnabled public Boolean PercentBased {get;set;} 
		@AuraEnabled public Integer TaxPercent {get;set;} 
		@AuraEnabled public Double NetAmountTaxable {get;set;} 

		public TaxLineDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'TaxRateRef') {
							TaxRateRef = new TaxCodeRef(parser);
						} else if (text == 'PercentBased') {
							PercentBased = parser.getBooleanValue();
						} else if (text == 'TaxPercent') {
							TaxPercent = parser.getIntegerValue();
						} else if (text == 'NetAmountTaxable') {
							NetAmountTaxable = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'TaxLineDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomField {
		@AuraEnabled public String DefinitionId {get;set;} 
		@AuraEnabled public String Name {get;set;} 
		@AuraEnabled public String Type_Z {get;set;} // in json: Type
		@AuraEnabled public String StringValue {get;set;} 

        public CustomField(){}
        
		public CustomField(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'DefinitionId') {
							DefinitionId = parser.getText();
						} else if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Type') {
							Type_Z = parser.getText();
						} else if (text == 'StringValue') {
							StringValue = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomField consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class BillEmail {
		@AuraEnabled public String Address {get;set;} 

		public BillEmail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Address') {
							Address = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BillEmail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LinkedTxn {
		@AuraEnabled public String TxnId {get;set;} 
		@AuraEnabled public String TxnType {get;set;} 

		public LinkedTxn(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'TxnId') {
							TxnId = parser.getText();
						} else if (text == 'TxnType') {
							TxnType = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'LinkedTxn consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class TxnTaxDetail {
		@AuraEnabled public Double TotalTax {get;set;} 
		@AuraEnabled public List<TaxLine> TaxLine {get;set;} 

		public TxnTaxDetail(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'TotalTax') {
							TotalTax = parser.getDoubleValue();
						} else if (text == 'TaxLine') {
							TaxLine = new List<TaxLine>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								TaxLine.add(new TaxLine(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'TxnTaxDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static QBOInvoice parse(String json) {
		return new QBOInvoice(System.JSON.createParser(json));
	}
}