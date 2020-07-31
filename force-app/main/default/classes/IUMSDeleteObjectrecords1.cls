global class IUMSDeleteObjectrecords1 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
      
      // Delete Client Information
      Client_Information__c[] lstcinfo = [Select id from Client_Information__c where FAF_ID__c IN : scope LIMIT 1];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstcinfo;
      if (!lstcinfo.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstcinfo, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) 
                    {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                  
                }  
              }    
      
   }
     
    global void finish(Database.BatchableContext BC)
     {
         IUMSDeleteObjectrecords2 iumsfaf2=new IUMSDeleteObjectrecords2();
         iumsfaf2.query =query;
         Database.executeBatch(iumsfaf2); 
    }
   }