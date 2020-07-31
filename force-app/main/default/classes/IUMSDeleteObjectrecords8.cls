global class IUMSDeleteObjectrecords8 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
      // Delete Network Operation Information if no User created record
      Network_Operations__c[] lstnops = [Select id from Network_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
      List<Network_Sequence_Setting__c> newNetSeq = new List<Network_Sequence_Setting__c>();
      List<Network_Sequence_Setting__c> delNetSeq = new List<Network_Sequence_Setting__c>();
      if (!lstnops.isEmpty())
      {
      delnetSeq = [Select id from Network_Sequence_Setting__c where FAFID__c = :lstnops[0].id];
      List<Network_Pricing__c> NetAgreegate = new List<Network_Pricing__c>([SELECT FAF_ID__c,LOB__c,Agreement_Line_Item__c,Composite_Key__c,
                                        Sequence_Number__c
                                        FROM Network_Pricing__c 
                                        WHERE  FAF_Network_Ops__c = :lstnops[0].id 
                                        AND Show_in_Grid__c = true]);
      for(Network_Pricing__c network: NetAgreegate)
       {
          Network_Sequence_Setting__c newSeq = new Network_Sequence_Setting__c();  
          newSeq.Agreement_Line_Item_ID__c = network.Agreement_Line_Item__c;
          newSeq.FAFID__c = network.FAF_ID__c;
          newSeq.Key__c = network.Composite_Key__c;
          newSeq.Sequence_Number__c = network.Sequence_Number__c;
          newNetSeq.add(newSeq);
       } 
       }   
      
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstnops;
       if (!lstnops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstnops, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
      
       //delete oldnetworkseq;      
        if (!delnetSeq.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(delnetSeq, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }  
        //Insert new networkseq;      
        if (!newNetSeq.isEmpty())
                {
                List<Database.SaveResult> result2 = Database.insert(newNetSeq, false);
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
       IUMSDeleteObjectrecords9 iumsfaf9=new IUMSDeleteObjectrecords9();
            iumsfaf9.query = query;
            Database.executeBatch(iumsfaf9); 
    }
   }