//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are reserved words in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.
global class QBOPaymentResponse
{
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

	public class Any_Z {
		public String name {get;set;} 
		public String declaredType {get;set;} 
		public String scope {get;set;} 
		public Value value {get;set;} 
		public Boolean nil {get;set;} 
		public Boolean globalScope {get;set;} 
		public Boolean typeSubstituted {get;set;} 

		public Any_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'declaredType') {
							declaredType = parser.getText();
						} else if (text == 'scope') {
							scope = parser.getText();
						} else if (text == 'value') {
							value = new Value(parser);
						} else if (text == 'nil') {
							nil = parser.getBooleanValue();
						} else if (text == 'globalScope') {
							globalScope = parser.getBooleanValue();
						} else if (text == 'typeSubstituted') {
							typeSubstituted = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Any_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Line {
		public Double Amount {get;set;} 
		public List<LinkedTxn> LinkedTxn {get;set;} 
		public LineEx LineEx {get;set;} 
        
        public Line(){}

		public Line(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Amount') {
							Amount = parser.getDoubleValue();
						} else if (text == 'LinkedTxn') {
							LinkedTxn = new List<LinkedTxn>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								LinkedTxn.add(new LinkedTxn(parser));
							}
						} else if (text == 'LineEx') {
							LineEx = new LineEx(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Line consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	global class Payment {
		public CustomerRef CustomerRef {get;set;} 
		public DepositToAccountRef DepositToAccountRef {get;set;} 
		public DepositToAccountRef PaymentMethodRef {get;set;} 
		public String PaymentRefNum {get;set;} 
		public Double TotalAmt {get;set;} 
		public Double UnappliedAmt {get;set;} 
		public Boolean ProcessPayment {get;set;} 
		public String domain {get;set;} 
		public Boolean sparse {get;set;} 
		public String Id {get;set;} 
		public String SyncToken {get;set;} 
		public MetaData MetaData {get;set;} 
		public String TxnDate {get;set;} 
		public CustomerRef CurrencyRef {get;set;} 
		public String PrivateNote {get;set;} 
		public List<Line> Line {get;set;} 
        
         public Payment() {}

		public Payment(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'CustomerRef') {
							CustomerRef = new CustomerRef(parser);
						} else if (text == 'DepositToAccountRef') {
							DepositToAccountRef = new DepositToAccountRef(parser);
						} else if (text == 'PaymentMethodRef') {
							PaymentMethodRef = new DepositToAccountRef(parser);
						} else if (text == 'PaymentRefNum') {
							PaymentRefNum = parser.getText();
						} else if (text == 'TotalAmt') {
							TotalAmt = parser.getDoubleValue();
						} else if (text == 'UnappliedAmt') {
							UnappliedAmt = parser.getIntegerValue();
						} else if (text == 'ProcessPayment') {
							ProcessPayment = parser.getBooleanValue();
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
						} else if (text == 'TxnDate') {
							TxnDate = parser.getText();
						} else if (text == 'CurrencyRef') {
							CurrencyRef = new CustomerRef(parser);
						} else if (text == 'PrivateNote') {
							PrivateNote = parser.getText();
						} else if (text == 'Line') {
							Line = new List<Line>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								Line.add(new Line(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'Payment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DepositToAccountRef {
        
        public DepositToAccountRef(){}
		public String value {get;set;} 

		public DepositToAccountRef(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DepositToAccountRef consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Payment Payment {get;set;} 
	
	public QBOPaymentResponse(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'Payment') {
						Payment = new Payment(parser);
					}  else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class MetaData {
		public String CreateTime {get;set;} 
		public String LastUpdatedTime {get;set;} 

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
	
	public class Value {
		public String Name {get;set;} 
		public String Value {get;set;} 

		public Value(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'Value') {
							Value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Value consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CustomerRef {
		public String value {get;set;} 
		public String name {get;set;} 
        
        public CustomerRef(){}

		public CustomerRef(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomerRef consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LineEx {
		public List<Any_Z> any_Z {get;set;} // in json: any

		public LineEx(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'any') {
							any_Z = new List<Any_Z>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								any_Z.add(new Any_Z(parser));  
							}
						} else {
							System.debug(LoggingLevel.WARN, 'LineEx consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class LinkedTxn {
		public String TxnId {get;set;} 
		public String TxnType {get;set;} 
        
        public LinkedTxn()
        {
            
        }

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
	
	public static QBOPaymentResponse parse(String json) {
		return new QBOPaymentResponse(System.JSON.createParser(json));
	}
}