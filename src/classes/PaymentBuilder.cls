/*
*****************************************************************************************
Author: Resmi Ramakrishnan
Date  : 07/09/2016
Description : This class is using for processing payments.                  

****************************************************************************************
*/

global class PaymentBuilder 
{ 
    public static List<Transaction__c> transactionListToInsert = new List<Transaction__c>(); 
    public static integer MAXRESULTS = 300;
    public static integer position = 1;
    
    
    Webservice static void UpdateBatchObject( Id batchJobId )
    {   
         //Changing Record Type to Finding Invoices record type id.
         ID findingRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Finding Invoices').getRecordTypeId();
         Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
         batchJobObj.RecordTypeId =  findingRecordTypeID;
         update batchJobObj;
    }
    @future
    Webservice static void processTransactions( Id batchJobId )
    {
        getTransactions( batchJobId );        
    }
    
      
     public static void getTransactions( Id batchJobId)
     {         
         getInvoices(batchJobId); 
         getCredits( batchJobId );
         
         if( !transactionListToInsert.isEmpty())
         {
         	PaymentBuilderBatch batch = new PaymentBuilderBatch( transactionListToInsert,batchJobId); 
            database.executebatch(batch,50);
         } 
     }
     public static void getInvoices( Id batchJobId)
     {
         QBOCRUDHelper crudHelper = new QBOCRUDHelper();
         
         Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
                 
		 while (position != 0)
         {
             Date dueBeforeDate = batchJobObj.Due_Before__c;
             String strDueBeforeDate = DateTime.newInstance(dueBeforeDate.year(),dueBeforeDate.month(),dueBeforeDate.day()).format('YYYY-MM-dd');
            
             String queryString = 'select Id,DocNumber,TxnDate,DueDate,TotalAmt,Balance , CustomerRef from INVOICE where Balance != \'0\' and DueDate < \'' + String.escapeSingleQuotes(strDueBeforeDate)+'\' STARTPOSITION ' + (position*MAXRESULTS-MAXRESULTS+1).format() +' MAXRESULTS ' + MAXRESULTS.format();
             System.debug('RESMI:TTTT' + queryString );
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
                  
                        transObj.DueDate__c = date.valueOf(item.DueDate);
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
         }//while loop ending         
     }
     public static void getCredits( Id batchJobId)
     {
         
         
     }
    
    
    
    
    
    
    //------- Generate payment section----------//
     /*Webservice static void changeRecordTypegeneratePayments( Id batchJobId )
     {
         //Changing Record Type to processing payments record type id.
         ID processingRecordTypeID = Schema.SObjectType.Batch_Jobs__c.getRecordTypeInfosByName().get('Processing Payment').getRecordTypeId();
         Batch_Jobs__c batchJobObj = [SELECT id, Due_Before__c  FROM Batch_Jobs__c where id =:batchJobId LIMIT 1];
         batchJobObj.RecordTypeId =  processingRecordTypeID;
         update batchJobObj;
     }
 
     Webservice static void generatePayments( Id batchJobId )
     {
       	Map< ID, QBOPaymentResponse.Payment> paymentMap = new map< ID, QBOPaymentResponse.Payment>();
       	List<Transaction__c	> listOfInvoicesForPay = new List<Transaction__c	>();
        
        // Query all 
       	listOfInvoicesForPay = [SELECT id,Account__c,Customer_Reference__c,DocNumber__c,TotalAmount__c from Transaction__c	 where Batch_Jobs__c =: batchJobId ];
       
         for( Transaction__c paymentObj : listOfInvoicesForPay )
       	{
           if ( paymentMap.containsKey( paymentObj.Account__c ) == false )
           {
                QBOPaymentResponse.Payment paymentInstance = new QBOPaymentResponse.Payment();
                QBOPaymentResponse.CustomerRef  custref = new QBOPaymentResponse.CustomerRef();
                custref.value = paymentObj.Customer_Reference__c;
                paymentInstance.CustomerRef  = custref; 
                paymentInstance.TotalAmt = paymentObj.TotalAmount__c;
                paymentInstance.PaymentRefNum = paymentObj.Name;
               
                List<QBOPaymentResponse.Line> invLines = new List<QBOPaymentResponse.Line>();
                QBOPaymentResponse.Line line = new QBOPaymentResponse.Line();
                
                paymentMap.put(paymentObj.Account__c, paymentInstance);
           }
          
       	}
        
        //object response = qbo.upsertData('payment', system.JSON.serialize(paymentMap.values(), true), );         
     }*/
}