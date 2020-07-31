global class IUMSDeleteObjectrecords11 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
      // Delete Billing Operation Information if no User created record
      Billing_Operations__c[] lstbillops = [Select id from Billing_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1 FOR UPDATE];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstbillops;
      if (!lstbillops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstbillops, false);
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
        IUMSDeleteObjectrecords12 iumsfaf12=new IUMSDeleteObjectrecords12();
            iumsfaf12.query = query;
            Database.executeBatch(iumsfaf12); 
    }
   }