global class IUMSDeleteObjectrecords5 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope)
   {
    
     
      // Delete FAF Information
      FAF_Instructions__c[] lstfafinfo = [Select id from FAF_Instructions__c where FAF_ID__c IN : scope LIMIT 1];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstfafinfo;
      if (!lstfafinfo.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstfafinfo, false);
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
            IUMSDeleteObjectrecords6 iumsfaf6=new IUMSDeleteObjectrecords6();
            iumsfaf6.query =query;
            Database.executeBatch(iumsfaf6); 
    }
   }