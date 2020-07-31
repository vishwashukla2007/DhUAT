global class IUMSDeleteObjectrecords12 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
      // Delete Rebate Operation Information if no User created record
      Rebate_Operations__c[] lstrops = [Select id from Rebate_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1 FOR UPDATE];
      
      
      List<Rebate_Sequence_Setting__c> newMRebSeq = new List<Rebate_Sequence_Setting__c>();
      List<Rebate_Sequence_Setting__c> delRebSeq = new List<Rebate_Sequence_Setting__c>();
      if (!lstrops .isEmpty())
      {
      delRebSeq = [Select id from Rebate_Sequence_Setting__c where FAFID__c = :lstrops[0].id];
      List<Rebate_Guarantees__c> RebAgreegate = new List<Rebate_Guarantees__c>([SELECT FAF_ID__c,LOB2__c,Agreement_Line_Item__c,Modeled_Non_Specialty_Formulary_Name__c,
                                        Plan_Design__c,GSTP__c,Sequence_Number__c,Composite_Key__c
                                        FROM Rebate_Guarantees__c 
                                        WHERE  Rebate_Operations__c = :lstrops[0].id 
                                        AND Grid_flag__c = true]);
      for(Rebate_Guarantees__c rebate: RebAgreegate)
       {
          Rebate_Sequence_Setting__c newSeq = new Rebate_Sequence_Setting__c();  
          newSeq.Agreement_Line_Item_ID__c = rebate.Agreement_Line_Item__c;
          newSeq.FAFID__c = rebate.FAF_ID__c;
          newSeq.LOB__c=rebate.LOB2__c;
          newSeq.Key__c = rebate.Composite_Key__c;
          newSeq.Sequence_Number__c = rebate.Sequence_Number__c;
          newMRebSeq .add(newSeq);
       } 
       }       
      
      
      
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstrops;
      if (!lstrops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstrops, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }  
              
              
        //delete oldrebateseq;      
        if (!delRebSeq.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(delRebSeq, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }  
         
        //Insert new rebateseq;      
        if (!newMRebSeq.isEmpty())
                {
                List<Database.SaveResult> result2 = Database.insert(newMRebSeq, false);
                for(Integer i=0;i<result2.size();i++){
                    if(!result2.get(i).isSuccess()) {
                        Database.Error error = result2.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }                
              
              
                 
   }
     
    global void finish(Database.BatchableContext BC) 
    {
         IUMSDeleteObjectrecords13 iumsfaf13=new IUMSDeleteObjectrecords13();
            iumsfaf13.query = query;
            Database.executeBatch(iumsfaf13); 
    }
   }