global class PCD_GridObjectdata {
  
  
  
  @AuraEnabled
    public static String get_Task(String offerid){
        try {
            String tsksubtype;
            List<Task__c> lstTask= [select id,iUMSTaskSubtype__c from Task__c where Offer__c= :offerid order by CreatedDate DESC LIMIT 1];
            if (lstTask != null && !lstTask.IsEmpty())
            {
             tsksubtype = lstTask[0].iUMSTaskSubtype__c;
            }
            return tsksubtype; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
  
  
  
  
    @AuraEnabled
    public static List<Offer__c> get_Offer(String accountid){
        try {
            List<Offer__c> rtnOffer = new List<Offer__c>();
            List<Task__c> lstTask= [select id,Account__c,Offer__c from Task__c where Account__c= :accountid order by Name Desc];
            for (Task__c task: lstTask)
            {
              if(task.Offer__c != null)
              {
              Offer__c lstOffer = [Select Id,Account__c,PCD__c,Agreement_Name__c,Alert_Message__c,Name,OfferCategory__c,OfferDescriptor__c,
                                          Offer_Revenue_PCD__c,OfferTotalRevenue__c,PCD_Offer_link__c,iUMSTask__c from Offer__c where id= :task.Offer__c ];
              
              rtnOffer.add(lstOffer);
              }
            }
            return rtnOffer; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Apttus__AgreementLineItem__c> get_LOB(String offerid){
        try {
         
            List<Apttus__AgreementLineItem__c> rtnLOB = new List<Apttus__AgreementLineItem__c>();
            if (offerid != null && offerid != 'undefined')
            {
            List<Apttus__APTS_Agreement__c> lstagree=[select Id from Apttus__APTS_Agreement__c where Offer__c= :offerid];
            for (Apttus__APTS_Agreement__c agree : lstagree)
            {
             List<Apttus__AgreementLineItem__c> lstali= [select Id,Apttus__AgreementId__c,Agreement_Name_Text__c,LOB__c,LOB_Detail__c,Active__c,Market_Segment__c,Client_Sub_Type__c,
             LOB_Description__c,LOBSequence__c,FAF__c,PCD_FAF__c,FAF_Name__c,Template_Exclude__c,Component_Error__c,BAFO_Change__c,Previous_Task_SubType__c,Task_SubType__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c = :agree.id
             order by LOBSequence__c Asc];
             for (Apttus__AgreementLineItem__c agreeline : lstali)
              {
               rtnLOB.add(agreeline);
              }
           }}
            return rtnLOB; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static List<Apttus__DocumentVersionDetail__c> get_DocVersionDetail(String aliid){
        try {
         
            List<Apttus__DocumentVersionDetail__c> rtnDoc = new List<Apttus__DocumentVersionDetail__c>();
            if (aliid != null && aliid != 'undefined')
            {
            List<Apttus__DocumentVersionDetail__c> lstdoc=[Select Id,Apttus__View__c,PCD_Document_link__c,Apttus__ContentId__c,Apttus__FileType__c,Agreement__c,Apttus__Title__c ,LastModifiedDate,Apttus__Action2__c,Apttus__DocumentInfo__c,
                                                          Agreement_Line_Item__c,Task_SubType__c
                                                          from Apttus__DocumentVersionDetail__c where Agreement_Line_Item__c = :aliid and Deleted__c = false order by  Sequence__c Desc,CreatedDate  Desc];
            for (Apttus__DocumentVersionDetail__c doc: lstdoc)
            {
             
               rtnDoc.add(doc);
              
           }}
            return rtnDoc; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Apttus__DocumentVersionDetail__c get_worddoc(String aliid){
        try {
            Apttus__DocumentVersionDetail__c lstdoc;
            if (aliid != null && aliid != 'undefined')
            {
            lstdoc=[Select Id,Apttus__View__c,PCD_Document_link__c,Apttus__ContentId__c,Apttus__FileType__c,Agreement__c,Apttus__Title__c ,LastModifiedDate,Apttus__Action2__c,Apttus__DocumentInfo__c,Agreement_Line_Item__c
                                                          from Apttus__DocumentVersionDetail__c where Agreement_Line_Item__c = :aliid and Apttus__DocumentInfo__c = 'Draft' order by LastModifiedDate Desc LIMIT 1];
            
            }
             if (lstdoc != null)
             return lstdoc; 
             else
             return null;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   @AuraEnabled
   public static List<Attachment> get_Attachment(String docverionid){
        try {
         
            List<Attachment> rtnAtt = new List<Attachment>();
            if (docverionid != null && docverionid != 'undefined')
            {
            Apttus__DocumentVersionDetail__c Docversiondtlrtr = [
            select Id,Apttus__ContentId__c,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
            Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
            Apttus__FileType__c,Task_SubType__c
            from Apttus__DocumentVersionDetail__c where  Id = :docverionid and Deleted__c= false];
            if(Docversiondtlrtr != null)
            {
            List<Attachment> lstAtt=[Select Id,Name,ContentType,OwnerId,ParentId
                                     from Attachment where Id = :Docversiondtlrtr.Apttus__ContentId__c 
                                     Order by SystemModStamp Desc];
            for (Attachment att: lstAtt)
            {
             
               rtnAtt.add(att);
              
           }}}
            return rtnAtt; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    } 
    
     @AuraEnabled
   public static void delete_Attachment(String docverionid){
        try {
         
            List<Apttus__DocumentVersionDetail__c> rtnAtt = new List<Apttus__DocumentVersionDetail__c>();
            if (docverionid != null && docverionid != 'undefined')
            {
            List<Apttus__DocumentVersionDetail__c> Docversiondtlrtr = [
            select Id,Apttus__ContentId__c,Agreement__c,Agreement_Line_Item__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
            Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
            Apttus__FileType__c
            from Apttus__DocumentVersionDetail__c where  Id = :docverionid];
            if(Docversiondtlrtr != null)
            {    
            for (Apttus__DocumentVersionDetail__c att: Docversiondtlrtr)
            {
               att.Deleted__c= true;
               rtnAtt.add(att);
              
           }}
           
            if (Docversiondtlrtr != null && !Docversiondtlrtr.isEmpty())
           {
           
            Decimal sequence = Docversiondtlrtr[0].Sequence__c;
            String agreementlineItem = Docversiondtlrtr[0].Agreement_Line_Item__c;
            if (Docversiondtlrtr[0].Task_SubType__c != null)
            {
            List<Apttus__DocumentVersionDetail__c> Docversiondtlrtrupd = [
            select Id,Apttus__ContentId__c,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
            Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
            Apttus__FileType__c,Task_SubType__c,Sequence__c
            from Apttus__DocumentVersionDetail__c where  Sequence__c = :sequence and Agreement_Line_Item__c = :agreementlineItem  and Id != :docverionid  Order by CreatedDate Desc LIMIT 1];
            
            if(Docversiondtlrtrupd != null)
            {    
            for (Apttus__DocumentVersionDetail__c attupd: Docversiondtlrtrupd)
            {
               attupd.Task_SubType__c= Docversiondtlrtr[0].Task_SubType__c ;
               rtnAtt.add(attupd);
              
           }}}}
           
           
           
           }
           if (rtnAtt != null && !rtnAtt.IsEmpty())
           {
               List<Database.SaveResult> result = Database.Update(rtnAtt , false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
           }
           } 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    } 
    
    
    
    @AuraEnabled
    public static void update_priali(String agrid, String aliid){
        try {
            List<Apttus__APTS_Agreement__c> updagree = new List<Apttus__APTS_Agreement__c>();
            //List<Apttus__AgreementLineItem__c> updagreeline = new List<Apttus__AgreementLineItem__c>();
            if (agrid != null && aliid != null)
            {
            //List<Apttus__AgreementLineItem__c> lstagreeline=[select Id,BAFO_Change__c,Previous_Task_SubType__c,Task_SubType__c from Apttus__AgreementLineItem__c where Id= :aliid ];
            List<Apttus__APTS_Agreement__c> lstagree=[select Id,Primary_Agreement_Line_Item__c,PCD_Status__c,Status_In_Progress__c from Apttus__APTS_Agreement__c where Id= :agrid];
            
           /* for (Apttus__AgreementLineItem__c agreeline : lstagreeline)
            {
               if (agreeline.BAFO_Change__c == true)
               {
               agreeline.Previous_Task_SubType__c = agreeline.Task_SubType__c;    
               updagreeline.add(agreeline);
              }
           } */
            
            
            for (Apttus__APTS_Agreement__c agree : lstagree)
            {
               agree.Primary_Agreement_Line_Item__c = aliid;
               agree.PCD_Status__c = 'Setup Pricing';
               agree.Status_In_Progress__c ='Setup Pricing';
               updagree.add(agree);
              
           }
            List<Database.SaveResult> result = Database.Update(updagree, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
           }
             /* if (updagreeline != null && !updagreeline.IsEmpty())
              {
               List<Database.SaveResult> result1 = Database.Update(updagreeline, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
               } */
           
           } }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

 @AuraEnabled
    public static void update_prialigen(String agrid, String aliid){
        try {
            List<Apttus__APTS_Agreement__c> updagree = new List<Apttus__APTS_Agreement__c>();
            if (agrid != null && aliid != null)
            {
            List<Apttus__APTS_Agreement__c> lstagree=[select Id,Primary_Agreement_Line_Item__c,PCD_Status__c,Status_In_Progress__c from Apttus__APTS_Agreement__c where Id= :agrid];
            for (Apttus__APTS_Agreement__c agree : lstagree)
            {
               agree.Primary_Agreement_Line_Item__c = aliid;
               agree.PCD_Status__c = 'Generate Document';
           agree.Status_In_Progress__c ='Generate Document';
               updagree.add(agree);
              
           }
            List<Database.SaveResult> result = Database.Update(updagree, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
           }
        }} catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<LOB__c> get_lineofbusiness(String offerid){
        try {
         
            List<LOB__c> lstagree = new List<LOB__c>();
            if (offerid != null && offerid != 'undefined')
            {
             lstagree=[select Id,LobBusinessType__c,FAF__c,Lob__c,LobDescriptor__c,LOB_Description__c,LobId__c from LOB__c where Client_Pricing_Offer__c= :offerid];
            }
            return lstagree; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   @AuraEnabled
    public static void get_createpcd(String offerid,String baselobid,List<String> addlobs){
        try {
         
            List<PCD_Multiple_LOB__c> lstmultiplelob = new List<PCD_Multiple_LOB__c>();
            Offer__c lstoffer = new Offer__c();
            if (offerid != null && offerid != 'undefined')
            {
             lstoffer =[select Id,Alert_Acknowledgement__c,PCD__c,LaunchPB__c from Offer__c where Id= :offerid];
               lstoffer.LaunchPB__c = true;
               lstoffer.Alert_Acknowledgement__c = true; 
             List<LOB__c> lstlob = [select Id,Client_Pricing_Offer__c,FAF__c,LOB_Description__c,LobId__c,Lob__c from LOB__c  where Client_Pricing_Offer__c= :offerid];
             LOB__c baselob = [select Id,Client_Pricing_Offer__c,FAF__c,LOB_Description__c,LobId__c,Lob__c from LOB__c  where Client_Pricing_Offer__c= :offerid
             and LobId__c= :baselobid LIMIT 1];  
             for (LOB__c lob : lstlob)
              {
                Integer lobexist = 1;
                for (String s : addlobs)
                {
                 if (lob.LOB_Description__c == s)
                    lobexist = 0;
                }
                if (lobexist == 0)
                {
                PCD_Multiple_LOB__c multiplelob = new PCD_Multiple_LOB__c();
                multiplelob.Additional_FAF_ID__c = lob.FAF__c;
                multiplelob.Additional_LOB_ID__c = lob.LOB_Description__c;
                multiplelob.Additional_LOB__c = lob.Id;
                multiplelob.Base_FAF_ID__c = baselob.FAF__c;
                multiplelob.Base_LOB_ID__c = baselob.LOB_Description__c;
                multiplelob.Base_LOB__c = baselob.Id;
                lstmultiplelob.add(multiplelob);
                }
              }             
            }
               Database.SaveResult result = Database.Update(lstoffer, false);
                  if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                }
               List<Database.SaveResult> result1 = Database.Insert(lstmultiplelob, false);
                for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
              
        }
        catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Offer__c get_pcd(String offerid){
        try {
         
            Offer__c lstoffer;
            if (offerid != null && offerid != 'undefined')
            {
             lstoffer =[select Id,Alert_Acknowledgement__c,PCD__c,LaunchPB__c from Offer__c where Id= :offerid];
            }
            return lstoffer;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updatepriali(String agreeid, String lobid){
        try {
         
            Apttus__APTS_Agreement__c lstagree = new Apttus__APTS_Agreement__c();
            if (agreeid!= null && agreeid!= 'undefined' && lobid!= null)
            {
             List<Apttus__AgreementLineItem__c> lstali = [select Id from Apttus__AgreementLineItem__c where  Apttus__AgreementId__c= :agreeid and
                                                        LOBSequence__c = :Integer.valueOf(lobid)];
                             lstagree = [select Id,Primary_Agreement_Line_Item__c,PCD_Status__c,Status_In_Progress__c from Apttus__APTS_Agreement__c where Id = :agreeid];
               lstagree.Primary_Agreement_Line_Item__c = lstali[0].Id;
               lstagree.PCD_Status__c = 'Setup Pricing';
               lstagree.Status_In_Progress__c = 'Setup Pricing';
     
            }
                Database.SaveResult result = Database.Update(lstagree, false);
                if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                }
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}