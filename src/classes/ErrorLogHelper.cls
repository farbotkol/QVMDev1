public class ErrorLogHelper {

    // Log account errors
    public static List<Error_Log__c>  LogAccountError(Account account, QBOError errors){
        
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        for (QBOError.Error err : errors.Fault.Error){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Message__c = err.Message;
            errorLog.Detail__c = err.Detail;
            errorLog.Code__c = err.code;
            errorLog.Type__c = errors.Fault.type_Z;
            errorLog.Account__c = account.Id;
            
            errorLogs.add(errorLog);
        }
        //
        return  errorLogs;
        
    }
    
    // Log Order errors
    public static List<Error_Log__c> LogOrderError(Order order, QBOError errors){
        
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        for (QBOError.Error err : errors.Fault.Error){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Message__c = err.Message;
            errorLog.Detail__c = err.Detail;
            errorLog.Code__c = err.code;
            errorLog.Type__c = errors.Fault.type_Z;
            errorLog.Order__c = order.Id;
            
            errorLogs.add(errorLog);
        }
        
        return errorLogs;
        
    }
    
    // Log Order errors
    public static List<Error_Log__c> LogOrderItemError(OrderItem orderItem, QBOError errors){
        
        List<Error_Log__c> errorLogs = new List<Error_Log__c>();
        for (QBOError.Error err : errors.Fault.Error){
            Error_Log__c errorLog = new Error_Log__c();
            errorLog.Message__c = err.Message;
            errorLog.Detail__c = err.Detail;
            errorLog.Code__c = err.code;
            errorLog.Type__c = errors.Fault.type_Z;
            errorLog.Order_Item__c = orderItem.Id;
            
            errorLogs.add(errorLog);
        }
        
        return errorLogs;
        
    }
    
    
    public static Error_Log__c LogOrderError(Order order, Exception error){
        
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Message__c = error.getMessage();
        errorLog.Detail__c = error.getStackTraceString();
        errorLog.Code__c = error.getLineNumber().format();
        errorLog.Type__c = 'SF Exception';
        errorLog.Order__c = order.Id;
       

        return errorLog;
        
    }
    
    public static Error_Log__c LogBatchJobError(ID jobId, Exception error){
        
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Message__c = error.getMessage();
        errorLog.Detail__c = error.getStackTraceString();
        errorLog.Code__c = error.getLineNumber().format();
        errorLog.Type__c = 'SF Exception';
        errorLog.Batch_Jobs__c = jobId;
       

        return errorLog;
        
    }
    
       // Log OrderItem errors
    public static Error_Log__c LogOrderItemError(OrderItem orderItem, Exception error){
        
        Error_Log__c errorLog = new Error_Log__c();
        errorLog.Message__c = error.getMessage();
        errorLog.Detail__c = error.getStackTraceString();
        errorLog.Code__c = error.getLineNumber().format();
        errorLog.Type__c = 'SF Exception';
        errorLog.Order_Item__c = orderItem.Id;
       

        return errorLog;
        
    }
    
    
    
}