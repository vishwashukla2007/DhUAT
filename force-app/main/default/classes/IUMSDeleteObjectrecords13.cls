global class IUMSDeleteObjectrecords13 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
    
      // Delete Clinical Operation Information if no User created record
      Clinical_Operations__c[] lstcops = [Select id from Clinical_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1 FOR UPDATE];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstcops;
      if (!lstcops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstcops, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
   
      
   }
     
    global void finish(Database.BatchableContext BC) 
    {
         IUMSDeleteObjectrecords14 iumsfaf14=new IUMSDeleteObjectrecords14();
            iumsfaf14.query =query;
            Database.executeBatch(iumsfaf14);  
    }
   }