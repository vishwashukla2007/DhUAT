global class IUMSDeleteObjectrecords7 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
    
      // Delete Contractual_Payments Information
      Contractual_Payments__c[] lstcp = [Select id from Contractual_Payments__c where FAF_ID__c IN : scope];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstcp;
       if (!lstcp.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstcp, false);
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
         IUMSDeleteObjectrecords8 iumsfaf8=new IUMSDeleteObjectrecords8();
         iumsfaf8.query =query;
         Database.executeBatch(iumsfaf8); 
    }
   }