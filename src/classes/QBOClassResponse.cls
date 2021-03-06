//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are reserved words in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class QBOClassResponse {
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

	public QueryResponse QueryResponse {get;set;} 
    public Class_Z Class_Z {get;set;} // in json: Class
	//public String time {get;set;} 

	public QBOClassResponse(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'QueryResponse') {
						QueryResponse = new QueryResponse(parser);
					} else if (text == 'time') {
						//time = parser.getText();
					} else {
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
	
	public class QueryResponse {
		public List<Class_Z> Class_Z {get;set;} // in json: Class
		public Integer startPosition {get;set;} 
		public Integer maxResults {get;set;} 
		public Integer totalCount {get;set;} 

		public QueryResponse(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Class') {
							Class_Z = new List<Class_Z>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								Class_Z.add(new Class_Z(parser));
							}
						} else if (text == 'startPosition') {
							startPosition = parser.getIntegerValue();
						} else if (text == 'maxResults') {
							maxResults = parser.getIntegerValue();
						} else if (text == 'totalCount') {
							totalCount = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'QueryResponse consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Class_Z {
		public String Name {get;set;} 
		public Boolean SubClass {get;set;} 
		public String FullyQualifiedName {get;set;} 
		public Boolean Active {get;set;} 
		public String domain {get;set;} 
		public Boolean sparse {get;set;} 
		public String Id {get;set;} 
		public String SyncToken {get;set;} 
		public MetaData MetaData {get;set;} 
		
        public Class_Z()
        {}
        
		public Class_Z(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							Name = parser.getText();
						} else if (text == 'SubClass') {
							SubClass = parser.getBooleanValue();
						} else if (text == 'FullyQualifiedName') {
							FullyQualifiedName = parser.getText();
						} else if (text == 'Active') {
							Active = parser.getBooleanValue();
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
						} else {
							System.debug(LoggingLevel.WARN, 'Class_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static QBOClassResponse parse(String json) {
		return new QBOClassResponse(System.JSON.createParser(json));
	}
}