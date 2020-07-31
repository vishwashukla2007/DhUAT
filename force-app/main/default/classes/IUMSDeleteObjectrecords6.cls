global class IUMSDeleteObjectrecords6 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
     
      // Delete Broker TPA Information
      Billing_Broker_TPA_Payments__c[] lstbtpa = [Select id from Billing_Broker_TPA_Payments__c where FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstbtpa;
      if (!lstbtpa.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstbtpa, false);
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
        IUMSDeleteObjectrecords7 iumsfaf7=new IUMSDeleteObjectrecords7();
        iumsfaf7.query =query;
        Database.executeBatch(iumsfaf7);
    }
   }