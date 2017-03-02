public class QBOClassHelper {
    
 
	public static void InsertQBOClasses(List<QBO_Class__c> qboClasses)
	{
       // QBOClassResponse.Class_Z class_z
       List<QBO_Class__c> qboClassesToUpdate = new List<QBO_Class__c> ();
       for (QBO_Class__c qboClass : qboClasses)
       {
           QBOClassResponse.Class_Z class_z = new QBOClassResponse.Class_Z();
           
           class_z.Name = qboClass.Name;
           object response;
           QBOCRUDHelper crudHelper = new QBOCRUDHelper();
           System.debug('NEW system.JSON.serialize(class_z, true): ' + system.JSON.serialize(class_z, true));
           response = crudHelper.upsertData( 'class?minorversion=4',  system.JSON.serialize(class_z, true) , QBOClassResponse.class);
           if (response instanceof QBOError){
             
               //errorsToInsert.addAll(ErrorLogHelper.LogAccountError(so, (QBOError)response));
               continue;
           }else{
               QBOClassResponse classRes = (QBOClassResponse)response; 
               System.debug('classRes : ' + classRes);
              // classRes
               class_z = classRes.Class_Z;
               qboClass.QBOId__c = class_z.Id;
               qboClass.Active__c = true;
               qboClassesToUpdate.add(qboClass);
           }
       }
        
       Update qboClassesToUpdate;
       
    }

    @future  (callout=true)
    public static void QBOClassInsertFuture(List<Id> scope)
    {
        List<QBO_Class__c> classes = [SELECT Name, Id, Active__c
                                  FROM QBO_Class__c
                                  WHERE Id IN :scope
                                 ];
       InsertQBOClasses(classes);    
    }
    
     
    public static void UpdateQBOClasses(List<QBO_Class__c> qboClasses)
	{
        
        
       // QBOClassResponse.Class_Z class_z
       List<QBO_Class__c> qboClassesToUpdate = new List<QBO_Class__c> ();
       for (QBO_Class__c qboClass : qboClasses)
       {
            QBOCRUDHelper crudHelper = new QBOCRUDHelper();
           
            // need to get syncTocken
			QBOClassResponse classResponse = (QBOClassResponse)crudHelper.read( 'class', qboClass.QBOId__c , QBOClassResponse.class);
			System.debug('READ classResponse: ' + classResponse);
       		QBOClassResponse.Class_Z  class_z = classResponse.Class_Z;
            class_z.Name = qboClass.Name;
            class_z.Active = qboClass.Active__c;
           
            object response;
           
            System.debug('NEW system.JSON.serialize(class_z, true): ' + system.JSON.serialize(class_z, true));
            response = crudHelper.upsertData( 'class?minorversion=4',  system.JSON.serialize(class_z, true) , QBOClassResponse.class);
            if (response instanceof QBOError){
             
               //errorsToInsert.addAll(ErrorLogHelper.LogAccountError(so, (QBOError)response));
               continue;
            }else{
               /*QBOClassResponse classRes = (QBOClassResponse)response; 
               System.debug('classRes : ' + classRes);
              // classRes
               class_z = classRes.Class_Z;
               qboClass.QBOId__c = class_z.Id;
               qboClass.Active__c = true;
               qboClassesToUpdate.add(qboClass);*/
           }
       }
        
      // Update qboClassesToUpdate;
       
    }
    
     @future  (callout=true)
    public static void QBOClassUpdateFuture(List<Id> scope)
    {
        List<QBO_Class__c> classes = [SELECT Name, Id, QBOId__c, Active__c
                                  FROM QBO_Class__c
                                  WHERE Id IN :scope
                                 ];
       UpdateQBOClasses(classes);    
    }
}