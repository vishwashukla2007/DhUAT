global class IUMSDeleteObjectrecords2 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
      
     
      // Delete Legal Information
      Legal_Information__c[] lstlinfo = [Select id from Legal_Information__c where FAF_ID__c IN : scope LIMIT 1];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstlinfo;
        if (!lstlinfo.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstlinfo, false);
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
           IUMSDeleteObjectrecords3 iumsfaf3=new IUMSDeleteObjectrecords3();
            iumsfaf3.query =query;
            Database.executeBatch(iumsfaf3);  
    }
   }