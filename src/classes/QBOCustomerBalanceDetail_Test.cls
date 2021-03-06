//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class QBOCustomerBalanceDetail_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Time\": \"2016-09-02T13:39:35-07:00\",'+
		'    \"ReportName\": \"QBOCustomerBalanceDetail\",'+
		'    \"DateMacro\": \"all\",'+
		'    \"Currency\": \"AUD\",'+
		'    \"Customer\": \"207\",'+
		'    \"Option\": ['+
		'      {'+
		'        \"Name\": \"report_date\",'+
		'        \"Value\": \"2016-09-30\"'+
		'      },'+
		'      {'+
		'        \"Name\": \"NoReportData\",'+
		'        \"Value\": \"false\"'+
		'      }'+
		'    ]'+
		'  },'+
		'  \"Columns\": {'+
		'    \"Column\": ['+
		'      {'+
		'        \"ColTitle\": \"Date\",'+
		'        \"ColType\": \"tx_date\"'+
		'      },'+
		'      {'+
		'        \"ColTitle\": \"Transaction Type\",'+
		'        \"ColType\": \"txn_type\"'+
		'      },'+
		'      {'+
		'        \"ColTitle\": \"No.\",'+
		'        \"ColType\": \"doc_num\"'+
		'      },'+
		'      {'+
		'        \"ColTitle\": \"Due Date\",'+
		'        \"ColType\": \"due_date\"'+
		'      },'+
		'      {'+
		'        \"ColTitle\": \"Amount\",'+
		'        \"ColType\": \"subt_home_amount\"'+
		'      },'+
		'      {'+
		'        \"ColTitle\": \"Open Balance\",'+
		'        \"ColType\": \"subt_home_open_bal\"'+
		'      },'+
		'      {'+
		'        \"ColTitle\": \"Balance\",'+
		'        \"ColType\": \"rbal_home_open_bal\"'+
		'      }'+
		'    ]'+
		'  },'+
		'  \"Rows\": {'+
		'    \"Row\": ['+
		'      {'+
		'        \"Header\": {'+
		'          \"ColData\": ['+
		'            {'+
		'              \"value\": \"8ree 2\",'+
		'              \"id\": \"207\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"Rows\": {'+
		'          \"Row\": ['+
		'            {'+
		'              \"ColData\": ['+
		'                {'+
		'                  \"value\": \"2016-08-01\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"Invoice\",'+
		'                  \"id\": \"757\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"315\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"2016-08-16\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"476.74\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"476.74\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"476.74\"'+
		'                }'+
		'              ],'+
		'              \"type\": \"Data\"'+
		'            },'+
		'            {'+
		'              \"ColData\": ['+
		'                {'+
		'                  \"value\": \"2016-09-01\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"Invoice\",'+
		'                  \"id\": \"977\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"370\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"2016-09-16\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"478.50\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"478.50\"'+
		'                },'+
		'                {'+
		'                  \"value\": \"955.24\"'+
		'                }'+
		'              ],'+
		'              \"type\": \"Data\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"Summary\": {'+
		'          \"ColData\": ['+
		'            {'+
		'              \"value\": \"Total for 8ree 2\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"955.24\"'+
		'            },'+
		'            {'+
		'              \"value\": \"955.24\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"type\": \"Section\"'+
		'      },'+
		'      {'+
		'        \"Summary\": {'+
		'          \"ColData\": ['+
		'            {'+
		'              \"value\": \"TOTAL\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            },'+
		'            {'+
		'              \"value\": \"955.24\"'+
		'            },'+
		'            {'+
		'              \"value\": \"955.24\"'+
		'            },'+
		'            {'+
		'              \"value\": \"\"'+
		'            }'+
		'          ]'+
		'        },'+
		'        \"type\": \"Section\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
		QBOCustomerBalanceDetail r = QBOCustomerBalanceDetail.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Row_Z objRow_Z = new QBOCustomerBalanceDetail.Row_Z(System.JSON.createParser(json));
		System.assert(objRow_Z != null);
		System.assert(objRow_Z.Header == null);
		System.assert(objRow_Z.Rows == null);
		System.assert(objRow_Z.Summary == null);
		System.assert(objRow_Z.type_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail objRoot = new QBOCustomerBalanceDetail(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.Header == null);
		System.assert(objRoot.Columns == null);
		System.assert(objRoot.Rows == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.ColData_Z objColData_Z = new QBOCustomerBalanceDetail.ColData_Z(System.JSON.createParser(json));
		System.assert(objColData_Z != null);
		System.assert(objColData_Z.value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Header_Z objHeader_Z = new QBOCustomerBalanceDetail.Header_Z(System.JSON.createParser(json));
		System.assert(objHeader_Z != null);
		System.assert(objHeader_Z.ColData == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Columns objColumns = new QBOCustomerBalanceDetail.Columns(System.JSON.createParser(json));
		System.assert(objColumns != null);
		System.assert(objColumns.Column == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Header objHeader = new QBOCustomerBalanceDetail.Header(System.JSON.createParser(json));
		System.assert(objHeader != null);
		//System.assert(objHeader.Time == null);
		System.assert(objHeader.ReportName == null);
		System.assert(objHeader.DateMacro == null);
		//System.assert(objHeader.Currency == null);
		System.assert(objHeader.Customer == null);
		System.assert(objHeader.Option == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Column objColumn = new QBOCustomerBalanceDetail.Column(System.JSON.createParser(json));
		System.assert(objColumn != null);
		System.assert(objColumn.ColTitle == null);
		System.assert(objColumn.ColType == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Rows_Z objRows_Z = new QBOCustomerBalanceDetail.Rows_Z(System.JSON.createParser(json));
		System.assert(objRows_Z != null);
		System.assert(objRows_Z.Row == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.ColData objColData = new QBOCustomerBalanceDetail.ColData(System.JSON.createParser(json));
		System.assert(objColData != null);
		System.assert(objColData.value == null);
		System.assert(objColData.id == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Summary objSummary = new QBOCustomerBalanceDetail.Summary(System.JSON.createParser(json));
		System.assert(objSummary != null);
		System.assert(objSummary.ColData == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Option objOption = new QBOCustomerBalanceDetail.Option(System.JSON.createParser(json));
		System.assert(objOption != null);
		System.assert(objOption.Name == null);
		System.assert(objOption.Value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Row objRow = new QBOCustomerBalanceDetail.Row(System.JSON.createParser(json));
		System.assert(objRow != null);
		System.assert(objRow.ColData == null);
		System.assert(objRow.type_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		QBOCustomerBalanceDetail.Rows objRows = new QBOCustomerBalanceDetail.Rows(System.JSON.createParser(json));
		System.assert(objRows != null);
		System.assert(objRows.Row == null);
	}
}