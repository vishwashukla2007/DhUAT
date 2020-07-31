global class IUMSDeleteObjectrecords implements Database.Batchable<sObject> {
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
   
     
      // Delete Legal Information
      Legal_Information__c[] lstlinfo = [Select id from Legal_Information__c where FAF_ID__c IN : scope LIMIT 1];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstlinfo;
        if (!lstlinfo.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstlinfo, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }

  
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

       
        
      // Delete Guarantee Information
      Guarantees_Information__c[] lstginfo = [Select id from Guarantees_Information__c where FAF_ID__c IN : scope LIMIT 1];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
     // delete lstginfo;
       if (!lstginfo.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstginfo, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
 
     
        
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
              
   
      // Delete Network Operation Information if no User created record
      Network_Operations__c[] lstnops = [Select id from Network_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
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
       
      // Delete Mail Operation Information if no User created record
      Mail_Operations__c[] lstmailops = [Select id from Mail_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
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
      
   
      // Delete Billing Operation Information if no User created record
      Billing_Operations__c[] lstbillops = [Select id from Billing_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
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
      
   
      // Delete Rebate Operation Information if no User created record
      Rebate_Operations__c[] lstrops = [Select id from Rebate_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
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
      
    
      // Delete Clinical Operation Information if no User created record
      Clinical_Operations__c[] lstcops = [Select id from Clinical_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c IN : scope LIMIT 1];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstcops;
      if (!lstcops.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstcops, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
      
   
      
      // Delete Network Pricing Information for records uploaded from Model
      Network_Pricing__c[] lstnpri = [Select id from Network_Pricing__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
     // delete lstnpri;
      if (!lstnpri.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstnpri, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
              
       
      
       // Delete Mail Pricing Information for records uploaded from Model
      Mail_Pricing__c[] lstmpri = [Select id from Mail_Pricing__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstmpri;
      if (!lstmpri.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstmpri, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
     
     
      // Delete Specialty Pricing Information for records uploaded from Model
      Specialty_Pricing__c[] lstspri = [Select id from Specialty_Pricing__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstspri;
      if (!lstspri.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstspri, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
       
       
       
      // Delete Rebate Guarantee Information for records uploaded from Model
      Rebate_Guarantees__c[] lstrgee = [Select id from Rebate_Guarantees__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstrgee;
      if (!lstrgee.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstrgee, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
      
      
       // Delete Billing Admin Information for records uploaded from Model
      Billing_Administrative_Fees__c[] lstbadm = [Select id from Billing_Administrative_Fees__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstbadm;
      if (!lstbadm.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstbadm, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
       
     
      // Delete Clinical Solution Information for records uploaded from Model
      Clinical_Solutions__c[] lstcs = [Select id from Clinical_Solutions__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstcs;
      if (!lstcs.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstcs, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
      
      
   }
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
   }