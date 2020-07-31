global class IUMSDeleteObjectrecords3 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
     
  
      // Delete Specialty Drug Level Information
      Specialty_Drug_Level_Pricing__c[] lstsdl = [Select id from Specialty_Drug_Level_Pricing__c where FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstsdl;
       if (!lstsdl.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstsdl, false);
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
        IUMSDeleteObjectrecords4 iumsfaf4=new IUMSDeleteObjectrecords4();
        iumsfaf4.query =query;
        Database.executeBatch(iumsfaf4);  
    }
   }