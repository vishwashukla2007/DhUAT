global class IUMSDeleteObjectrecords10 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
     
      // Delete Specialty Operation Information if no User created record
      Specialty_Operations__c[] lstspecops = [Select id from Specialty_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
       //delete lstspecops;
       if (!lstspecops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstspecops, false);
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
        IUMSDeleteObjectrecords11 iumsfaf11=new IUMSDeleteObjectrecords11();
            iumsfaf11.query = query;
            Database.executeBatch(iumsfaf11); 
    }
   }