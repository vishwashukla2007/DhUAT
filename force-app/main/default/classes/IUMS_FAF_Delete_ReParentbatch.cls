global class IUMS_FAF_Delete_ReParentbatch implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope)
   {
    
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
        DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
        Network_Operations__c[] newnops = [Select id from Network_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c = :scope];
             Network_Operations__c[] oldnops = [Select id from Network_Operations__c where iUMS_Record_Count__c> 0 and FAF_ID__c = :scope];
             Network_Pricing__c[] lstnpri = [Select id from Network_Pricing__c where IUMS_Upload__c= false and FAF_ID__c = :scope];
             
             Mail_Operations__c[] newmops = [Select id from Mail_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c = :scope];
             Mail_Operations__c[] oldmops = [Select id from Mail_Operations__c where iUMS_Record_Count__c> 0 and FAF_ID__c = :scope];
             Mail_Pricing__c[] lstmpri = [Select id from Mail_Pricing__c where IUMS_Upload__c= false and FAF_ID__c = :scope];
             
             Specialty_Operations__c[] newsops = [Select id from Specialty_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c = :scope];
             Specialty_Operations__c[] oldsops = [Select id from Specialty_Operations__c where iUMS_Record_Count__c> 0 and FAF_ID__c = :scope];
             Specialty_Pricing__c[] lstspri = [Select id from Specialty_Pricing__c where IUMS_Upload__c= false and FAF_ID__c = :scope];
             
             Rebate_Operations__c[] newrops = [Select id from Rebate_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c = :scope];
             Rebate_Operations__c[] oldrops = [Select id from Rebate_Operations__c where iUMS_Record_Count__c> 0 and FAF_ID__c = :scope];
             Rebate_Guarantees__c[] lstrpri = [Select id from Rebate_Guarantees__c where IUMS_Upload__c= false and FAF_ID__c = :scope];
             
             Clinical_Operations__c[] newcops = [Select id from Clinical_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c = :scope];
             Clinical_Operations__c[] oldcops = [Select id from Clinical_Operations__c where iUMS_Record_Count__c> 0 and FAF_ID__c = :scope];
             Clinical_Solutions__c[] lstcpri = [Select id from Clinical_Solutions__c where IUMS_Upload__c= false and FAF_ID__c = :scope];
             
             Billing_Operations__c[] newbops = [Select id from Billing_Operations__c where iUMS_Record_Count__c= 0 and FAF_ID__c = :scope];
             Billing_Operations__c[] oldbops = [Select id from Billing_Operations__c where iUMS_Record_Count__c> 0 and FAF_ID__c = :scope];
             Billing_Administrative_Fees__c[] lstbpri = [Select id from Billing_Administrative_Fees__c where IUMS_Upload__c= false and FAF_ID__c = :scope];
             
            // Network Re-Parenting
             if (!newnops.isEmpty() && !oldnops.isEmpty() && !lstnpri.isEmpty())
             {
              List<Network_Pricing__c> np = new List<Network_Pricing__c>();
              for (Network_Pricing__c npri : lstnpri)
               {
                 npri.FAF_Network_Ops__c = newnops[0].Id;
                 np.add(npri);
               }
               if (!np.isEmpty())
                {
                  List<Database.SaveResult> result = Database.update(np, false);
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                if (!oldnops.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(oldnops, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                }  
            // Mail Re-Parenting
            if (!newmops.isEmpty() && !oldmops.isEmpty() && !lstmpri.isEmpty())
             {
              List<Mail_Pricing__c> mp = new List<Mail_Pricing__c>();
              for (Mail_Pricing__c mpri : lstmpri)
               {
                 mpri.FAF_Mail_Operations__c = newmops[0].Id;
                 mp.add(mpri);
               }
               if (!mp.isEmpty())
                {
                  List<Database.SaveResult> result = Database.update(mp, false);
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                if (!oldmops.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(oldmops, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                }  
                
           // Specialty Re-Parenting
            if (!newsops.isEmpty() && !oldsops.isEmpty() && !lstspri.isEmpty())
             {
              List<Specialty_Pricing__c> sp = new List<Specialty_Pricing__c>();
              for (Specialty_Pricing__c spri : lstspri)
               {
                 spri.Specialty_Operations__c = newsops[0].Id;
                 sp.add(spri);
               }
               if (!sp.isEmpty())
                {
                  List<Database.SaveResult> result = Database.update(sp, false);
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                if (!oldsops.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(oldsops, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                }  
             
             // Rebate Re-Parenting
            if (!newrops.isEmpty() && !oldrops.isEmpty() && !lstrpri.isEmpty())
             {
              List<Rebate_Guarantees__c> rp = new List<Rebate_Guarantees__c>();
              for (Rebate_Guarantees__c rpri : lstrpri)
               {
                 rpri.Rebate_Operations__c = newrops[0].Id;
                 rp.add(rpri);
               }
               if (!rp.isEmpty())
                {
                  List<Database.SaveResult> result = Database.update(rp, false);
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                if (!oldrops.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(oldrops, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                }  
             
             
           //Clinical Re-Parenting
            if (!newcops.isEmpty() && !oldcops.isEmpty() && !lstcpri.isEmpty())
             {
              List<Clinical_Solutions__c> cp = new List<Clinical_Solutions__c>();
              for (Clinical_Solutions__c cpri : lstcpri)
               {
                 cpri.Clinical_Operations__c = newcops[0].Id;
                 cp.add(cpri);
               }
               if (!cp.isEmpty())
                {
                  List<Database.SaveResult> result = Database.update(cp, false);
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                if (!oldcops.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(oldcops, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                }  
             
             
            //Billing Re-Parenting
            if (!newbops.isEmpty() && !oldbops.isEmpty() && !lstbpri.isEmpty())
             {
              List<Billing_Administrative_Fees__c> bp = new List<Billing_Administrative_Fees__c>();
              for (Billing_Administrative_Fees__c bpri : lstbpri)
               {
                 bpri.Billing_Operations__c = newbops[0].Id;
                 bp.add(bpri);
               }
               if (!bp.isEmpty())
                {
                  List<Database.SaveResult> result = Database.update(bp, false);
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                if (!oldbops.isEmpty())
                {
                List<Database.DeleteResult> result1 = Database.delete(oldbops, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
                }
                
                }  
         
         if (!newnops.isEmpty() && newnops != null)
         {
             List<id> objId = new List<id>();
             objId.add(newnops[0].Id);
             Invoke_UpdateNetworkPricing.UpdateNetworkPricing(objId);
             Invoke_Template_BrandGenericRate.Template_BrandGenericRate(objId);
             Invoke_Template_BrandGenericRate_All.UpdateNetworkPricingBrandRate_All(objId);
             Invoke_Template_BERGuaranteeRate.Template_BERGuaranteeRate(objId);
             Invoke_Template_BERGuaranteeRate_All.Template_BERGuaranteeRate_All(objId);
             
             NetworkSequenceBatch Nonj = new NetworkSequenceBatch(new Set<string>{String.valueOf(objId[0])});
             Database.executeBatch(Nonj);
         }
         
         if (!newmops.isEmpty() && newmops != null)
         {
             List<id> objId = new List<id>();
             objId.add(newmops[0].id);
             Invoke_UpdateMailPricing.UpdateMailPricing(objId);
             Invoke_Template_Mail_Rate.Template_Mail_Rate(objId);

             MailSequenceBatch onj = new MailSequenceBatch(new Set<string>{String.valueOf(objId[0])});
             Database.executeBatch(onj);
         }

         if (!newrops.isEmpty() && newrops != null)
         {
             List<id> objId = new List<id>();
             objId.add(newrops[0].Id);
             Invoke_UpdateRebateGuarantee.UpdateRebateGuarantee(objId);
             Invoke_Template_Rebate_Grid.Template_Rebate_Grid(objId);
             Invoke_Template_Rebate_Denorm.Template_Rebate_Denorm(objId);
             
             RebateSequenceBatch  Ronj = new RebateSequenceBatch (new Set<string>{String.valueOf(objId[0])});
             Database.executeBatch(Ronj);
         }
         
         if (!newsops.isEmpty() && newsops != null)
         {
             List<id> objId = new List<id>();
             objId.add(newsops[0].Id);
             Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(objId);
             UpdateSpecialtyPricingSequence_1.updateSequence(objId);
         }
         
         if (!newbops.isEmpty() && newbops != null)
         {
             List<id> objId = new List<id>();
             objId.add(newbops[0].Id);
             Invoke_UpdateBillingAdmin.UpdateBillingAdmin(objId);
             Invoke_BillingAdminGrid.BillingAdminGrid(objId);
         }
         
         if (!newcops.isEmpty() && newcops != null)
         {
             List<id> objId = new List<id>();
             objId.add(newcops[0].Id);
             Invoke_UpdateAdditionalProgramGrid.UpdateAdditionalProgramGrid(objId);
             Invoke_Template_AdditionalProgramGrid.Template_AdditionalProgramGrid(objId);
         }
      
      
   }
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
   }