/*
*****************************************************************************************
Author: Resmi Ramakrishnan
Date  : 07/09/2016
Description : This class is using for generating payments from invoices and creditmemo.                  

****************************************************************************************
*/

global class PaymentBuilder 
{ 
    public static List<Transaction__c> transactionListToInsert = new List<Transaction__c>(); 
    public static integer MAXRESULTS = 300;

    //---------------------- Changing Record Type to Finding Transactions record type ----------------------------------------//    
    Webservice static void UpdateBatchObject( Id batchJobId )
    {   
         try
         {
            ID findingRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Finding Transactions').getRecordTypeId();
         	Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
         	batchJobObj.RecordTypeId =  findingRecordTypeID;
         	update batchJobObj; 
         }
         catch( Exception Ex )
         {
            System.debug('Exception in UpdateBatchObject():' + Ex.getMessage());
         }         
    }
    //---------------------- Processing transactions -Invoices and credit memo ----------------------------------------//
    @future  
    Webservice static void processTransactions( Id batchJobId )
    {
        try
        {
            getInvoices(batchJobId); 
       		getCredits( batchJobId );        
         
        	if( !transactionListToInsert.isEmpty())
        	{
            	TransactionBuilderBatch batch = new TransactionBuilderBatch( transactionListToInsert,batchJobId); 
            	database.executebatch(batch,50);
        	}    
        }
        catch( Exception Ex )
        {
            System.debug('Exception in processTransactions():' + Ex.getMessage());
        }  
    } 
    //---------------------- Getting overdue Invoices from quickbook ----------------------------------------//
     public static void getInvoices( Id batchJobId)
     {
         try
         {
         	QBOCRUDHelper crudHelper = new QBOCRUDHelper();         
         	Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
         	integer position = 1;   
         	System.debug('RESMI:TTTT position' + position );
		 	while (position != 0)
        	{
             	system.debug('Inside While');
              	System.debug('RESMI:TTTT position' + position );
            	Date dueBeforeDate = batchJobObj.Due_Before__c;
             	String strDueBeforeDate = DateTime.newInstance(dueBeforeDate.year(),dueBeforeDate.month(),dueBeforeDate.day()).format('YYYY-MM-dd');
             
             	Integer newStartingPosition;
             	if( position == 1)
             	{
                 	newStartingPosition = 1;
             	}
             	else
             	{
                	newStartingPosition =(position  * MAXRESULTS ) - MAXRESULTS + 1; 
             	}             
             	String queryString = 'select Id,DocNumber,TxnDate,DueDate,TotalAmt,Balance , CustomerRef from INVOICE where Balance != \'0\' and DueDate < \'' + String.escapeSingleQuotes(strDueBeforeDate)+'\' STARTPOSITION ' + newStartingPosition.format().Replace(',', '') +' MAXRESULTS ' + MAXRESULTS.format();
             	System.debug('RESMI:TTTT qs' + queryString );
             	Object res =  crudHelper.query(queryString, QBOInvoiceList.Class);
                     
             	if (res instanceof QBOError)
             	{
                	System.debug('RESMI:TTTT:-error'  + (QBOError)res); 
               		position = 0;
             	}
             	else 
            	{   
                	List<QBOInvoice> invs = ((QBOInvoiceList)res).queryResponse.invoice;
                 	if (invs == null || invs.size() == 0 )
                 	{
                    	system.debug('exit loop: ');
                    	position = 0;
                    	break;  
                	}
                 	if (invs.size() == MAXRESULTS)
                 	{
                     	system.debug('position defore :' + position);
                     	position++;
                     	system.debug('position after :' + position);
                 	}
                 	else if  (invs.size()  > 0)
                 	{
                     	system.debug('setting position to 0 its currenty:' + position);
                     	position = 0;
                 	}
                                    
                 	List<Account> accList = new List<Account>();
                 	List<Order> orderList = new List<Order>();
                 
                 	// Set and Map declaration for getting AccountId from Quickbook's Customer Ref's value field.
                 	Set<String> setQuickBookID = new Set<String>();
                 	Map<String, ID > mapAccountDetails = new Map<String, ID>();
                 	Map <String,String> mapAccountDefPaymentType = new Map<String,String>();
                 
                 	// Set and Map declaration for getting OrderId from QuickBook's Id field 
                 	Set<String> setInvoiceQuickBookId = new Set<String>();
                 	Map<String, ID > mapOrderDetails = new map<String, ID>();
                
                 	for( QBOInvoice item : invs )
                	{                  
                    	if( item != null )
                     	{
                        	setQuickBookID.add( item.CustomerRef.value ); 
                        	setInvoiceQuickBookId.add( item.Id);
                     	}                 
                 	}
                 	// getting AccountList
                 	if(!setQuickBookID.isEmpty())
                	{
                    	accList = [SELECT id, QuickBooks_Id__c,Def_Payment_Type__c FROM Account where QuickBooks_Id__c IN: setQuickBookID];
                	}
                 	for( Account accObj: accList )
                 	{
                     	mapAccountDetails.put( accObj.QuickBooks_Id__c, accObj.Id);
                     	mapAccountDefPaymentType.put( accObj.QuickBooks_Id__c,accObj.Def_Payment_Type__c );
                 	}
                 	// getting order list
                 	if( !setInvoiceQuickBookId.isEmpty())
                 	{
                    	orderList = [SELECT id, QuickBooksId__c from Order where QuickBooksId__c IN:setInvoiceQuickBookId];
                 	}
                 	for( Order ordrObj: orderList )
                 	{
                    	mapOrderDetails.put(ordrObj.QuickBooksId__c,ordrObj.Id);
                 	}
              
                 	for (QBOInvoice item : invs)
                 	{
                    	if( item != null )
                     	{
                        	Transaction__c transObj = new Transaction__c	();
                        	transObj.Invoice_QuickBookId__c = item.Id; 
                        	transObj.Balance__c = item.Balance;
                        	transObj.DocNumber__c = item.DocNumber;
                  
                        	//transObj.DueDate__c = date.valueOf(item.DueDate);
                        	transObj.TotalAmount__c = item.TotalAmt;
                        	transObj.Batch_Jobs__c = batchJobId;
                        	transObj.TxnDate__c = date.valueOf(item.TxnDate);
                        	transObj.Type__c	= 'Invoice';
                                                                                    
                        	transObj.Customer_Reference__c = item.CustomerRef.value;
                        	//Getting Account id and Order id from maps.
                        	transObj.Account__c = mapAccountDetails.get( item.CustomerRef.value );
                       	    transObj.Order__c =  mapOrderDetails.get( item.id);

                        	if( mapAccountDefPaymentType.get(item.CustomerRef.value) == 'EFT')
                        	{
                        		transactionListToInsert.add( transObj );  
                        	}                        
                     	}               
                 	}                 
            	}       
        	 }         
         }
         catch( Exception Ex )
         {
            System.debug('Exception in getInvoices():' + Ex.getMessage());
         }
         
     }
     //---------------------- Getting Credits from quickbook  ----------------------------------------//
     public static void getCredits( Id batchJobId)
     {
         integer position = 1;              
         QBOCRUDHelper crudHelper = new QBOCRUDHelper();
         
         try
         {
         	Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
           
		 	while (position != 0)
         	{
             	Date dueBeforeDate = batchJobObj.Due_Before__c;
             	String strDueBeforeDate = DateTime.newInstance(dueBeforeDate.year(),dueBeforeDate.month(),dueBeforeDate.day()).format('YYYY-MM-dd');
            
             	Integer newStartingPosition;
             	if( position == 1)
             	{
                 	newStartingPosition = 1;
             	}
             	else
             	{
                	newStartingPosition =(position  * MAXRESULTS ) - MAXRESULTS + 1; 
             	}       
             
             	String queryString = 'select Id,DocNumber,TxnDate,TotalAmt,Balance,CustomerRef from CreditMemo where Balance != \'0\'  STARTPOSITION ' + newStartingPosition.format().Replace(',', '') +' MAXRESULTS ' + MAXRESULTS.format();
             	System.debug('RESMI:CCCC' + queryString );
             	Object res =  crudHelper.query(queryString, QBOCreditMemoList.Class);
                     
             	if (res instanceof QBOError)
             	{
                	System.debug('RESMI:CCC:-error'  + (QBOError)res); 
                	position = 0;
             	}
             	else 
             	{   
                 	List<QBOInvoice> invs = ((QBOCreditMemoList)res).queryResponse.CreditMemo;
                 	if (invs == null || invs.size() == 0 )
                 	{
                    	system.debug('exit loop: ');
                    	position = 0;
                    	break;  
                	}
                 	if (invs.size() == MAXRESULTS)
                 	{
                    	system.debug('position before :' + position);
                     	position++;
                     	system.debug('position after :' + position);
                 	}
                 	else if  (invs.size()  > 0)
                 	{
                    	system.debug('setting position to 0 its currenty:' + position);
                     	position = 0;
                 	}
                                    
                 	List<Account> accList = new List<Account>();
                 	List<Order> orderList = new List<Order>();
                 
                 	// Set and Map declaration for getting AccountId from Quickbook's Customer Ref's value field.
                 	Set<String> setQuickBookID = new Set<String>();
                 	Map<String, ID > mapAccountDetails = new Map<String, ID>();
                	Map <String,String> mapAccountDefPaymentType = new Map<String,String>();
                 
                 	// Set and Map declaration for getting OrderId from QuickBook's Id field 
                 	Set<String> setInvoiceQuickBookId = new Set<String>();
                 	Map<String, ID > mapOrderDetails = new map<String, ID>();
                
                 	for( QBOInvoice item : invs )
                 	{                  
                     	if( item != null )
                     	{
                        	setQuickBookID.add( item.CustomerRef.value ); 
                        	setInvoiceQuickBookId.add( item.Id);
                    	}                 
                 	}
                 	// getting AccountList
                 	if(!setQuickBookID.isEmpty())
                 	{
                    	accList = [SELECT id, QuickBooks_Id__c,Def_Payment_Type__c FROM Account where QuickBooks_Id__c IN: setQuickBookID];
                	}
                 	for( Account accObj: accList )
                 	{
                     	mapAccountDetails.put( accObj.QuickBooks_Id__c, accObj.Id);
                     	mapAccountDefPaymentType.put( accObj.QuickBooks_Id__c,accObj.Def_Payment_Type__c );
                 	}
                 	// getting order list
                 	if( !setInvoiceQuickBookId.isEmpty())
                 	{
                     	orderList = [SELECT id, QuickBooksId__c from Order where QuickBooksId__c IN:setInvoiceQuickBookId];
                 	}
                 	for( Order ordrObj: orderList )
                 	{
                    	mapOrderDetails.put(ordrObj.QuickBooksId__c,ordrObj.Id);
                 	}
              
                 	for (QBOInvoice item : invs)
                 	{
                     	if( item != null )
                     	{
                        	Transaction__c transObj = new Transaction__c	();
                        	transObj.Invoice_QuickBookId__c = item.Id; 
                        	transObj.Balance__c = item.Balance;
                        	transObj.DocNumber__c = item.DocNumber;
                         
                        	transObj.Type__c	= 'CreditMemo';
                  
                        	//transObj.DueDate__c = date.valueOf(item.DueDate);
                        	transObj.TotalAmount__c = item.TotalAmt;
                        	transObj.Batch_Jobs__c = batchJobId;
                        	transObj.TxnDate__c = date.valueOf(item.TxnDate);                                                 
                                     
                        	transObj.Customer_Reference__c = item.CustomerRef.value;
                        	//Getting Account id and Order id from maps.
                        	transObj.Account__c = mapAccountDetails.get( item.CustomerRef.value );
                        	transObj.Order__c =  mapOrderDetails.get( item.id);

                        	if( mapAccountDefPaymentType.get(item.CustomerRef.value) == 'EFT')
                        	{
                        		transactionListToInsert.add( transObj );  
                        	}                        
                     	}               
                	 }                 
            	}       
        	 }
         }
         catch( Exception Ex )
         {
            System.debug('Exception in getCredits():' + Ex.getMessage());
         }
     }
   
     //---------------------Changing Record Type to processing payments----------------------------------------//
     Webservice static void changeRecordTypegeneratePayments( Id batchJobId )
     {
         try
         {
            ID processingRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Processing Payment').getRecordTypeId();
         	Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
         	batchJobObj.RecordTypeId =  processingRecordTypeID;
         	update batchJobObj;
         }
         catch( Exception Ex )
         {
            System.debug('Exception in changeRecordTypegeneratePayments():' + Ex.getMessage());
         }
     }
    
    //----------------------       Generating  payments --------------------------------------------------------//
     Webservice static void generatePayments( Id batchJobId )
     {
        try
        {
     		Map< ID, QBOPaymentResponse.Payment> paymentMap = new map< ID, QBOPaymentResponse.Payment>();// Used to build the paymnet 
        	List<Payment__c> payments = new List<Payment__c>();// used to hold the payments in an SObject which can be passsed to a batch for processing 
       		List<Transaction__c	> listOftransactions = new List<Transaction__c>();
              
       		listOftransactions = [SELECT id,Account__c,Customer_Reference__c,DocNumber__c,TotalAmount__c,Invoice_QuickBookId__c,Type__c from Transaction__c	 where Batch_Jobs__c =: batchJobId];
       
        	Map<String, Id>  accountMap =  new Map<String, Id>();
         
        	for( Transaction__c transObj : listOftransactions )
       		{
           		accountMap.put(transObj.Customer_Reference__c, transObj.Account__c); 
           		if ( paymentMap.containsKey( transObj.Account__c ) == false )// adding header and line item to payment object.
           		{
                	QBOPaymentResponse.Payment paymentInstance = new QBOPaymentResponse.Payment();
                	QBOPaymentResponse.CustomerRef  custref = new QBOPaymentResponse.CustomerRef();
                	custref.value = transObj.Customer_Reference__c;
                	paymentInstance.CustomerRef  = custref; 
                	paymentInstance.TotalAmt = transObj.TotalAmount__c;
                	//paymentInstance.PaymentRefNum = 
               
                	List<QBOPaymentResponse.Line> invLines = new List<QBOPaymentResponse.Line>();
                	QBOPaymentResponse.Line line = new QBOPaymentResponse.Line();
                
                	line.Amount = transObj.TotalAmount__c;
               
                	List<QBOPaymentResponse.LinkedTxn> LinkedTxnLines = new List<QBOPaymentResponse.LinkedTxn> ();
                
                	QBOPaymentResponse.LinkedTxn linkedTxnObj = new QBOPaymentResponse.LinkedTxn();
                	linkedTxnObj.TxnId = transObj.Invoice_QuickBookId__c;
                	linkedTxnObj.TxnType = transObj.Type__c;
               
                	LinkedTxnLines.add(linkedTxnObj);
                	line.LinkedTxn = LinkedTxnLines;
                	invLines.add(line); 
                	paymentInstance.line = invLines;
               		paymentMap.put(transObj.Account__c, paymentInstance);
           		}
           		else// updating payment object with new line items
           		{
                	QBOPaymentResponse.Payment paymentInstance = paymentMap.get( transObj.Account__c );               
               		if (transObj.Type__c == 'Invoice') 
                    {
                   		paymentInstance.TotalAmt += transObj.TotalAmount__c;
              		}
               		else
                    {
                   		paymentInstance.TotalAmt -= transObj.TotalAmount__c;
               		}                              
               		List<QBOPaymentResponse.Line> invLines = new List<QBOPaymentResponse.Line>();
                	QBOPaymentResponse.Line line = new QBOPaymentResponse.Line();                                              
                	line.Amount = transObj.TotalAmount__c;                               
               		List<QBOPaymentResponse.LinkedTxn> LinkedTxnLines = new List<QBOPaymentResponse.LinkedTxn> (); 
               
                	QBOPaymentResponse.LinkedTxn linkedTxnObj = new QBOPaymentResponse.LinkedTxn();
                	linkedTxnObj.TxnId = transObj.Invoice_QuickBookId__c;
                	linkedTxnObj.TxnType = transObj.Type__c;  
               
                	LinkedTxnLines.add(linkedTxnObj);
                	line.LinkedTxn = LinkedTxnLines;
                             
                	paymentInstance.line.add(line);
                	paymentMap.put(transObj.Account__c,paymentInstance);               
           		}//else closing
       		}// for loop closing
         
        	List< QBOPaymentResponse.Payment> paymentList =  paymentMap.values();    
        	for (QBOPaymentResponse.Payment pmtQbo : paymentList)
        	{
            	Payment__c pmt = new Payment__c();
            	pmt.Batch_Jobs__c  = batchJobId;
            	pmt.Customer_Reference__c = pmtQbo.CustomerRef.value;
            	pmt.Total_Amount__c = pmtQbo.TotalAmt;
            	pmt.Account__c = accountMap.get(pmtQbo.CustomerRef.value);
            	pmt.PaymentJson__c =  system.JSON.serialize(pmtQbo, true);
            	payments.add(pmt); 
        	}         
        	if( !payments.isEmpty())
        	{
            	PaymentBuilderBatch batch = new PaymentBuilderBatch( payments,batchJobId); 
            	database.executebatch(batch,35);
        	}     
        }
        catch( Exception Ex )
        {
            System.debug('Exception in generatePayments():' + Ex.getMessage());
        }                 
     }
}