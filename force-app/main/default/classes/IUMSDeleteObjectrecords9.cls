global class IUMSDeleteObjectrecords9 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
       
      // Delete Mail Operation Information if no User created record
      Mail_Operations__c[] lstmailops = [Select id,FAF_ID__c from Mail_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
      List<Mail_Sequence_Setting__c> newMailSeq = new List<Mail_Sequence_Setting__c>();
      List<Mail_Sequence_Setting__c> delMailSeq = new List<Mail_Sequence_Setting__c>();
      if (!lstmailops.isEmpty())
      {
      delMailSeq = [Select id from Mail_Sequence_Setting__c where FAF_ID__c = :lstmailops[0].id];
      List<Mail_Pricing__c> MailAgreegate = new List<Mail_Pricing__c>([SELECT FAF_ID__c,LOB__c,Agreement_Line_Item__c,Sequence_Number__c
                                        FROM Mail_Pricing__c 
                                        WHERE  FAF_Mail_Operations__c = :lstmailops[0].id 
                                        AND Show_in_Grid__c = true]);
      for(Mail_Pricing__c mail : MailAgreegate)
       {
          Mail_Sequence_Setting__c newSeq = new Mail_Sequence_Setting__c();  
          newSeq.Agreement_Line_Item_ID__c = mail.Agreement_Line_Item__c;
          newSeq.FAF_ID__c = mail.FAF_ID__c;
          newSeq.LOB__c=mail.LOB__c;
          newSeq.Sequence_Number__c = mail.Sequence_Number__c;
          newMailSeq.add(newSeq);
       } 
       }                                 
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstmailops;
       if (!lstmailops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstmailops, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              } 
        //delete oldmailseq;      
        if (!delMailSeq.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(delMailSeq, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }  
         
        //Insert new mailseq;      
        if (!newMailSeq.isEmpty())
                {
                List<Database.SaveResult> result2 = Database.insert(newMailSeq, false);
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
         IUMSDeleteObjectrecords10 iumsfaf10=new IUMSDeleteObjectrecords10();
            iumsfaf10.query =query;
            Database.executeBatch(iumsfaf10); 
    }
   }