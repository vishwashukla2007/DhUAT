public class AttachmentTriggerHandler {
    //Commented out the method due to SFS not being moved to production for jun 4 deployment - JP Revilla 25/05/202
    //modified by John Paul Revilla 11/02/2020 for US28526
    //handles the on before insert feature of the handler to segragate and execute actions related to the different process of SFS, PCD and FAF
    public static void onBeforeInsert(List<Attachment> Attachments){
        //creates a list attachment for SFS
        list<Attachment> sfsAttachments = new list<Attachment>();
        //creates a list attachment for PCD and FAF
        list<Attachment> fafAttachments = new list<Attachment>();
        list<Attachment> pcdAttachments = new list<Attachment>();
        //iterates through the attachments and check if the attachment has an SFS in the name if yes add to SFS list else add it to the PCD and FAF list
        for(attachment attch : Attachments)
        {
            //split the name using the _ and getting the first instance of the array
            string attchName = attch.name.split('-')[0];
            // string attchSFSName = attch.name.split('_')[0];
            // if(attchSFSName.toUpperCase() == Label.Speciality_Fees_Schedule){
            //     sfsAttachments.add(attch);
            // }
            if(attch.name.contains('PCD_')== true) // changed from attchName.trim().toUpperCase() == Label.PCD
            {
                pcdAttachments.add(attch);
            }
            else{
                fafAttachments.add(attch);
            }
        }
        //checks if the list is empty and calls the  upsertAgreementAttachment method 
        // if(!sfsAttachments.isEmpty()){
        //     upsertAgreementAttachment(sfsAttachments);
        // }
        //checks if the list is empty and calls the PCDDocbeforeInsert method 
        if(!pcdAttachments.isEmpty()){
            PCDDocbeforeInsert(pcdAttachments);
        }
        if(!fafAttachments.isEmpty()){
            fafHeaderFooter(fafAttachments);
        }

    }

    //Commented out the method due to SFS not being moved to production for jun 4 deployment - JP Revilla 25/05/202
    //modified by John Paul Revilla 11/02/2020 for US28526
    //Upserts the generated SFS from the Pricing Model to the Related Agreement based on the SFS agreement field if no record is existing create one
    // public static void upsertAgreementAttachment(List<Attachment> Attachments){
    //     //gets the custom label for SFS
    //     string SFS = Label.Speciality_Fees_Schedule;
    //     //creates a set to store the unique iUms Task Setup Record Ids
    //     set<Id> parentIdSet = new set<id>();
    //     set<Id> parentIdErrorSet = new set<id>();
    //     //iterates throught the new attachments for SFS
    //     for(Attachment attachment: Attachments){
    //         parentIdSet.add(attachment.parentId);
    //     }
    //     //gets the list of iUms Task Records filtering using the unique ids from the attachment
    //     list<iUMS_Task_Setup__c> iUmsTaskSetupList = [Select id, SFS_Agreement__c, Status__c, Salesperson__c, Underwriter__c, Account__c, Account__r.Name from iUMS_Task_Setup__c where id in: parentIdSet];
    //     //create a map that would hold the  iums taks record as a value and iums task setup record id as the key 
    //     map<id, iUMS_Task_Setup__c> taskSetupUpdateMap = new map<id, iUMS_Task_Setup__c>();
    //     ////create a map that would hold the  aggrement record as value and iums task setup record id as the key, would hold all the attachments without agreement records
    //     map<id, Apttus__APTS_Agreement__c> taskSetupIdAgreementAddMap = new map<id, Apttus__APTS_Agreement__c>();
    //     boolean error = false;
    //     //iterates over the iumstasksetuplist
    //     for(iUMS_Task_Setup__c iUmsTaskSetup :  iUmsTaskSetupList){
    //         iUmsTaskSetup.Status__c = 'Complete';
    //         //checks if the record has an SFS agreement and then adds it to the taskSetupUpdateMap
    //         if(!String.isBlank(iUmsTaskSetup.SFS_Agreement__c)){
    //             taskSetupUpdateMap.put(iUmsTaskSetup.id, iUmsTaskSetup);
    //         }
    //         //else create an agreement and add it to the  taskSetupIdAgreementAddMap and taskSetupUpdateMap
    //         else{
    //             Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
    //             //assign SFS name of account name-SFS-date today(yyyy-mm-dd)
    //             agreement.name= iUmsTaskSetup.Account__r.Name + '-'+ SFS +'-' + string.valueOf(date.today());
    //             //modified by Symon Bucay 05/03/2020 for AC#2 of US34377: Remove SFS_Status__c
    //             if(iUmsTaskSetup.Account__c != null){
    //                 agreement.Apttus__Account__c = iUmsTaskSetup.Account__c;
    //             }
    //             else{
    //                 parentIdErrorSet.add(iUmsTaskSetup.id);
    //             }
    //             //create a code here to throw exception 
    //             if(iUmsTaskSetup.Salesperson__c != null){
    //                 agreement.Sales_Approver__c = iUmsTaskSetup.Salesperson__c;
    //             }
    //             if(iUmsTaskSetup.Underwriter__c != null){
    //                 agreement.UW_Approver__c = iUmsTaskSetup.Underwriter__c;
    //             }
    //             agreement.SFS_Path__c = 'SFS Upload Completed';
    //             agreement.Apttus__Contract_Start_Date__c =date.today();
    //             //get assign the SFS record id to the agreement
    //             agreement.recordtypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(SFS).getRecordTypeId();
    //             //sets the account base on the task setup record
    //             agreement.Apttus__Account__c = iUmsTaskSetup.Account__c;
    //             taskSetupIdAgreementAddMap.put(iUmsTaskSetup.id, agreement);
    //             taskSetupUpdateMap.put(iUmsTaskSetup.id, iUmsTaskSetup);
    //         }
    //     }
    //     if(!taskSetupIdAgreementAddMap.isEmpty()){
    //         //inserts the values of the taskSetupIdAgreementAddMap to get the new agreement ids
    //         insert taskSetupIdAgreementAddMap.values();
            
    //         list<iUMS_Task_Setup__c> iumsTaskSetupListUpdate = new List<iUMS_Task_Setup__c>();
    //         //iterates over the taskSetupIdAgreementAddMap keys if key is in taskSetupUpdateMap then update the SFS Agreement field
    //         for(Id key : taskSetupIdAgreementAddMap.keySet()){
    //             if(taskSetupUpdateMap.containsKey(key)){
    //                 taskSetupUpdateMap.get(key).SFS_Agreement__c = taskSetupIdAgreementAddMap.get(key).Id;
    //             }
    //         }
    //         //updates the values of the taskSetupUpdateMap to assign the correct agreement to the iums task
    //         update taskSetupUpdateMap.values();
    //     }
    //     if(!taskSetupUpdateMap.isEmpty()){
    //         //iterates over the new list and updates the parent ids base on the proper agreement;
    //         for(Attachment attachment: Attachments){
    //             if(!parentIdErrorSet.contains(attachment.parentId))
    //             {
    //                 if(taskSetupUpdateMap.containsKey(attachment.parentId)){
    //                     Attachment.parentId = taskSetupUpdateMap.get(attachment.parentId).SFS_Agreement__c;
    //                 }
    //             }
    //             else {
    //                 String acctError = label.AgreementCreationAccountError;
    //                 attachment.addError(acctError);
    //             }
                    
    //         }
    //     }
    // }
    @future(callout=true)
    public static void callApttusservice(Id attId, String printHeader, String printFooter, String sessionId, String serverUrl, String OwnerId, String ParentId) {
        try{
            Id vattId = attId;
            String vprintHeader = printHeader;
            String vprintFooter = printFooter;
            String vParentId = ParentId;
            String vOwnerId = OwnerId;
            String vaccess = 'Full Access';
            //String vsessionId = sessionId;
            String vsessionId = UserInfo.getSessionId(); 
            String vserverUrl = serverUrl;
            system.debug('FINAL FINAL CHECK');
            system.debug('Attachment ID' + vattId);
            system.debug('Print Header' + vprintHeader);
            system.debug('Print Footer' + vprintFooter);
            system.debug('Url - ' + vserverUrl);
            if(!Test.isRunningTest())
            Apttus.MergeWebService.appendToHeaderFooter(vattId, vprintHeader, vprintFooter, vsessionId, vserverUrl);
            
            //Code to find out Temporary Manual Sharing record created to delete. Also Revert back if change in Access level
                XAE_Manual_Share__c cs = XAE_Manual_Share__c.getInstance();
                Boolean Manshare= cs.Share__c;
                user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];  
                system.debug('***Debug**'+u.profile.Id+'**' + Label.Apttus_sales_Profile+'**' + Manshare );
                if (((u.profile.Id ==Label.Apttus_sales_Profile || u.profile.Id ==Label.Apttus_Operations_Profile_Id) && Manshare == true) || Test.isRunningTest()  )
                    {
                    List <Central_Hub__Share> fafShare = [Select id,UserOrGroupId,ParentId,AccessLevel  from Central_Hub__Share where ParentId= :vParentId and UserOrGroupId = :vOwnerId ];
                    for (Central_Hub__Share fafs : fafShare )
                        {
                                List<Central_Hub_Share_Modify__c> fafSharemdt = [select FAFShareId__c,FAFId__c,Old_AccessLevel__c,New_Accesslevel__c,UserOrGroupId__c from Central_Hub_Share_Modify__c where FAFShareId__c = :fafs.Id];
                                if(fafSharemdt.size() >= 0 )
                                    {
                                    for (Central_Hub_Share_Modify__c fafmdt : fafSharemdt )
                                        {
                                            List <Central_Hub__Share> fafupdate = [Select Id,UserOrGroupId,ParentId,AccessLevel  from Central_Hub__Share where Id = :fafmdt.FAFShareId__c  ];
                                            if (fafupdate.size() >= 0 && (fafupdate[0].AccessLevel != fafmdt.Old_AccessLevel__c) )
                                            {
                                                fafupdate[0].AccessLevel  = fafmdt.Old_AccessLevel__c;
                                                update fafupdate;
                                            }
                                            delete fafmdt;
                                        }  
                                    }
                                if(fafSharemdt.size() == 0 )
                                    {
                                    delete fafs;
                                    }
                        }
                    }
            
        
            }
            
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
    }
    /*   
    @future(callout=true)
    public static void callApttusMergePDFservice(ID[] docIds, String sessionId, String serverUrl, String OwnerId, String ParentId) {
        try{
    //           Id vattId = attId;
            String vParentId = ParentId;
            String vOwnerId = OwnerId;
    //          ID[] docIds = new ID[]{'a0Y61000002K6IR','a0Y61000003K7jR'};           
            String vsessionId = UserInfo.getSessionId();
            String docFileName = 'FAF-Print.pdf';            
            String vserverUrl = serverUrl;
            system.debug('FINAL FINAL CHECK');
    //           system.debug('Attachment ID' + vattId);
            system.debug('Url - ' + vserverUrl);
            if(!Test.isRunningTest())
            ID docId = Apttus.MergeWebService.mergeDocsToPDF(vParentId,docIds,docFileName,vsessionId,vserverUrl);
            
            //Code to find out Temporary Manual Sharing record created to delete. Also Revert back if change in Access level
                XAE_Manual_Share__c cs = XAE_Manual_Share__c.getInstance();
                Boolean Manshare= cs.Share__c;
                user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];  
                system.debug('***Debug**'+u.profile.Id+'**' + Label.Apttus_sales_Profile+'**' + Manshare );
                if (((u.profile.Id ==Label.Apttus_sales_Profile || u.profile.Id ==Label.Apttus_Operations_Profile_Id) && Manshare == true) || Test.isRunningTest()  )
                    {
                    List <Central_Hub__Share> fafShare = [Select id,UserOrGroupId,ParentId,AccessLevel  from Central_Hub__Share where ParentId= :vParentId and UserOrGroupId = :vOwnerId ];
                    for (Central_Hub__Share fafs : fafShare )
                        {
                                List<Central_Hub_Share_Modify__c> fafSharemdt = [select FAFShareId__c,FAFId__c,Old_AccessLevel__c,New_Accesslevel__c,UserOrGroupId__c from Central_Hub_Share_Modify__c where FAFShareId__c = :fafs.Id];
                                if(fafSharemdt.size() >= 0 )
                                    {
                                    for (Central_Hub_Share_Modify__c fafmdt : fafSharemdt )
                                        {
                                            List <Central_Hub__Share> fafupdate = [Select Id,UserOrGroupId,ParentId,AccessLevel  from Central_Hub__Share where Id = :fafmdt.FAFShareId__c  ];
                                            if (fafupdate.size() >= 0 && (fafupdate[0].AccessLevel != fafmdt.Old_AccessLevel__c) )
                                            {
                                                fafupdate[0].AccessLevel  = fafmdt.Old_AccessLevel__c;
                                                update fafupdate;
                                            }
                                            delete fafmdt;
                                        }  
                                    }
                                if(fafSharemdt.size() == 0 )
                                    {
                                    delete fafs;
                                    }
                        }
                    }
            
        
            }
            
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
    } 
    */
    public static void onAfterInsert(List<Attachment> AttachList) {
        //modified by John Paul Revilla 04/15/2020 for US47108
        //checks if there was any documents updated
        if(attachList.size() > 0)
        {
            map<id, Datetime> agreementIdCreatedDateMap = new map<id, Datetime>();
            map<id, Attachment> docVerDetailAttachmentMap = new map<id, Attachment>();
            //iterates through each attachment record 
            for(Attachment attch : AttachList){
                //check if the parent id of the attachment record is from agreement object
                if( string.valueOf(attch.ParentId.getsobjecttype()) == 'Apttus__APTS_Agreement__c'){
                    //check if the  agreementIdCreatedDateMap map already contains the parent id as key 
                    if(agreementIdCreatedDateMap.containsKey(attch.ParentId)){
                        //checks and updates the stored date value if the value of the stored date is less than the new created date
                        if(agreementIdCreatedDateMap.get(attch.ParentId) < attch.CreatedDate)
                            agreementIdCreatedDateMap.put(attch.parentId, attch.CreatedDate);
                            
                    }
                    //if parent id key is not yet present in agreementIdCreatedDateMap map add the record
                    else{
                        agreementIdCreatedDateMap.put(attch.ParentId, attch.CreatedDate);
                    }
                }
                if( string.valueOf(attch.ParentId.getsobjecttype()) =='Apttus__DocumentVersionDetail__c'){
                    if(docVerDetailAttachmentMap.containsKey(attch.ParentId)){
                        if(docVerDetailAttachmentMap.get(attch.ParentId).CreatedDate < attch.CreatedDate)
                            docVerDetailAttachmentMap.put(attch.ParentId, attch);
                    }
                    else{
                        docVerDetailAttachmentMap.put(attch.ParentId, attch);
                    }
                }
            }
            //checks if the keyset of agreementIdCreatedDateMap is empty
            if(agreementIdCreatedDateMap.keyset().size() >0 || docVerDetailAttachmentMap.keySet().size()> 0){
                //calls the updateAgreementGenerationDate method to update the Master Generation date field 
                updateAgreementGenerationDate(agreementIdCreatedDateMap, docVerDetailAttachmentMap);
            }
        }
        try{
            list<Attachment> pcdAttachments = new list<Attachment>();
            for(Attachment Attachrecords : AttachList){
                if(Attachrecords.ParentId  != null ){
                List<Central_Hub__c> faf = [Select id, Name,Account_Name_1__c, Pricing_Effective_Date__c, LOB2__c, LOB_Descriptor__r.Name, Print_Template__c, FAF_Print_Header__c,FAF_Print_Footer__c  from Central_Hub__c where id = :Attachrecords.ParentId];
                Id attId = Attachrecords.Id;
                system.debug('Attachment ID' + attId);
                system.debug('Attachment Name' + Attachrecords.Name);
                system.debug('Attachment Body' + Attachrecords.Body);
                system.debug('Attachment Body Length' + Attachrecords.BodyLength);
                system.debug('Attachment ContentType' + Attachrecords.ContentType);
                system.debug('Attachment Description' + Attachrecords.Description);
                system.debug('Attachment IsPrivate' + Attachrecords.IsPrivate);
                system.debug('Attachment OwnerId' + Attachrecords.OwnerId);
                system.debug('Attachment ParentId' + Attachrecords.ParentId);
                String sessionId = UserInfo.getSessionId(); 
                system.debug('Session Id' + sessionId);
                String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId(); 
                system.debug('Url - ' + serverUrl);               
                
                if (attId != null && sessionId != null && serverUrl != null && faf != null && faf.size()>0 || Test.isRunningTest())
                {               
                    String printHeader = faf[0].FAF_Print_Header__c;
                    if (faf[0].Pricing_Effective_Date__c != null)
                        printHeader = 'Account: ' + faf[0].Account_Name_1__c + ', FAF# ' + faf[0].Name+ ' LOB: ' + CheckNull(faf[0].LOB2__c) +' - ' + CheckNull(faf[0].LOB_Descriptor__r.Name) + ' Pricing Effective: '+ faf[0].Pricing_Effective_Date__c.format();
                        else
                        printHeader = 'Account: ' + faf[0].Account_Name_1__c + ', FAF# ' + faf[0].Name + ' LOB: ' + CheckNull(faf[0].LOB2__c) +' - ' + CheckNull(faf[0].LOB_Descriptor__r.Name) + ' Pricing Effective: ';                
                        
                        system.debug('Print Header' + printHeader);
                    String printFooter = faf[0].FAF_Print_Footer__c;
                    
                    if (printFooter == null && Label.Print_Document_Footer != 'NONE')
                        printFooter = Label.Print_Document_Footer;
                        system.debug('Print Footer' + printFooter);
                
                    system.debug('FINAL CHECK');
    //                   if(!Test.isRunningTest()) {

                        String sTemplateString = Attachrecords.Name;  
                        String [] em = sTemplateString.split('\\_');                   
                        String TemplateName = em[1];                    
                    
                    for (Apttus__APTS_Template__c template : [Select id, Name, Apttus__BusinessObject__c, Next_Template__c, Apply_Header__c from Apttus__APTS_Template__c where Name = :TemplateName] ) {        
                        
                        if (template.Apply_Header__c)
                            if(!Test.isRunningTest())                       
                                callApttusservice(attId, printHeader, printFooter, sessionId,serverUrl,Attachrecords.OwnerId,Attachrecords.ParentId);                       
                            
                    }
    //                   }
                } 
                else { system.debug('========Problem in Append Header-Footer==========');
                    
                        }
            }
            // PCD Project chnage to ensure Generated Document linked with Document Version and Document Version Details
             string attchName = Attachrecords.name.split('-')[0];
             if(attchName.trim().toUpperCase() == Label.PCD)
                {
                 pcdAttachments.add(Attachrecords);
                }  
                
            }
            
           if(!pcdAttachments.isEmpty())
            {
              for(Attachment Attachpcd : AttachList)
               {
                       List<Apttus__DocumentVersionDetail__c> Docversiondtl = [
                        select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                        Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                        from Apttus__DocumentVersionDetail__c where Agreement__c= :Attachpcd.ParentId and Apttus__ContentId__c = null
                        order by Apttus__VersionMajor__c desc
                        Limit 1
                        ];
                        if (Docversiondtl != null && !Docversiondtl.isEmpty()) 
                        {

                          Docversiondtl[0].Apttus__ContentId__c = Attachpcd.Id;
                           List<Database.SaveResult> result = Database.update(Docversiondtl, false);
                         for(Integer i=0;i<result.size();i++)
                         {
                           if(!result.get(i).isSuccess()) 
                         {
                           Database.Error error = result.get(i).getErrors().get(0);
                           String failedDML = error.getMessage();
                           throw new AuraHandledException(failedDML);
                          }
                        }  
                        }
            }
            }
            }
        // End of PCD Change
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
        }  


    /*       
    public static void onafterInsert2(List<Attachment> AttachList) {
        try{
            system.debug('TEST LOOP');
            for(Attachment Attachrecords : AttachList){
                if(Attachrecords.ParentId  != null ){
                List<Central_Hub__c> faf = [Select id, Name,Account_Name_1__c, Pricing_Effective_Date__c, LOB2__c, LOB_Descriptor__r.Name, Print_Template__c, FAF_Print_Header__c,FAF_Print_Footer__c  from Central_Hub__c where id = :Attachrecords.ParentId];
                Id attId = Attachrecords.Id;
                system.debug('Attachment ID' + attId);
                system.debug('Attachment Name' + Attachrecords.Name);
                system.debug('Attachment Body' + Attachrecords.Body);
                system.debug('Attachment Body Length' + Attachrecords.BodyLength);
                system.debug('Attachment ContentType' + Attachrecords.ContentType);
                system.debug('Attachment Description' + Attachrecords.Description);
                system.debug('Attachment IsPrivate' + Attachrecords.IsPrivate);
                system.debug('Attachment OwnerId' + Attachrecords.OwnerId);
                system.debug('Attachment ParentId' + Attachrecords.ParentId);
                String sessionId = UserInfo.getSessionId(); 
                system.debug('Session Id' + sessionId);
                String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId(); 
                system.debug('Url - ' + serverUrl);               
                
                if (attId != null && sessionId != null && serverUrl != null && faf[0].id != null)
                {               
                    String printHeader = faf[0].FAF_Print_Header__c;
                    if (faf[0].Pricing_Effective_Date__c != null)
                        printHeader = 'Account: ' + faf[0].Account_Name_1__c + ', FAF# ' + faf[0].Name+ ' LOB: ' + CheckNull(faf[0].LOB2__c) +' - ' + CheckNull(faf[0].LOB_Descriptor__r.Name) + ' Pricing Effective: '+ faf[0].Pricing_Effective_Date__c.format();
                        else
                        printHeader = 'Account: ' + faf[0].Account_Name_1__c + ', FAF# ' + faf[0].Name + ' LOB: ' + CheckNull(faf[0].LOB2__c) +' - ' + CheckNull(faf[0].LOB_Descriptor__r.Name) + ' Pricing Effective: ';                
                        
                        system.debug('Print Header' + printHeader);
                    String printFooter = faf[0].FAF_Print_Footer__c;
                    
                    if (printFooter == null && Label.Print_Document_Footer != 'NONE')
                        printFooter = Label.Print_Document_Footer;
                        system.debug('Print Footer' + printFooter);
                
                    system.debug('FINAL CHECK');
                    if(!Test.isRunningTest()) {

                        String sTemplateString = Attachrecords.Name;  
                        if (sTemplateString.IndexOF('_') >= 0) {  
                        String [] em = sTemplateString.split('\\_');                   
                        String TemplateName = em[1];                    
                    
                    for (Apttus__APTS_Template__c template : [Select id, Name, Apttus__BusinessObject__c, Next_Template__c, Apply_Header__c from Apttus__APTS_Template__c where Name = :TemplateName] ) {        
                                                
                        if (template.Next_Template__c != null) {
                                ID templateId = template.Next_Template__c;
                                ID sObjectId = faf[0].id;                
                                system.debug('::sObjectId::'+sObjectId);
                                String sObjectType = template.Apttus__BusinessObject__c;  
                                String pLevel = 'Full Access';
                                String docFormat = 'PDF';
                                Boolean isDraft = false; 
                                callApttusMergeservice(templateId, sObjectId , sObjectType, sessionId, serverUrl);                           
                        }
                            
                    }
                    }
                    }
                } 
                else { system.debug('========Problem in Append Header-Footer==========');
                    
                        }
            }
                
            }}
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
        }
    */    
    public static string CheckNull(string sValue) {
        string sRet= sValue;
        if (sValue == null)
            sRet ='';

        return sRet;           
    }
        
    public static void fafHeaderFooter(List<Attachment> AttachList) { 

        try{

            user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];
            for(Attachment Attachrecords : AttachList){
                String sTemplateString = Attachrecords.Name;
                if (sTemplateString.IndexOF('_') >= 0) {  
                    String [] em = sTemplateString.split('\\_');                   
                    String TemplateName = em[1];                    
                    
                    for (Apttus__APTS_Template__c template : [Select id, Name, Private_Output__c from Apttus__APTS_Template__c where Name = :TemplateName and Private_Output__c = TRUE] ) {        
                        Attachrecords.IsPrivate = true;
                    }
                }
                if (sTemplateString.IndexOF('-') >= 0) {  
                    String [] em1 = sTemplateString.split('\\-');                   
                    String FileName= em1[0];
                    String FileList = label.Print_Set_Attachment_Private;
                    system.debug('==FileList FileName=='+FileList + ':' + FileName);
                    if (FileList.contains(FileName))                   
                        Attachrecords.IsPrivate = true;
                }                     
            }        
            }
        
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
        
    }
  /*  public static void PCDOnbeforeInsert(List<Attachment> AttachList) { 

        try{
            Set<String> str=new Set<String>();
            Set<String> ids=new Set<String>();
            List<String> idList=new List<String>();
            String AccountName;
            String AgreemntID;
            String LOBDetail;
            map<String, String>agreemap=new map<String,String>();
            for(Attachment Attachrecords : AttachList){
                String sTemplateString = Attachrecords.Name;
                String TemplateName;
                    if (sTemplateString.IndexOF('_') >= 0) {  
                        String [] em = sTemplateString.split('\\_');                   
                        TemplateName = em[1]; 
                        str.add(em[0]);
                    }
                    System.debug('strstrstr'+str);
            }
            for (Apttus__APTS_Agreement__c agrree:[Select id,Primary_Agreement_Line_Item__c,Account_Name__c from Apttus__APTS_Agreement__c where Name IN:str]){
                    //LastPCD=agrree.Primary_Agreement_Line_Item__c;
                    ids.add(agrree.id);
                    AccountName = agrree.Account_Name__c;
            }
        
        List<Apttus__AgreementLineItem__c> agrLineList=[Select ID,Agreement_Name_Text__c,LOB_Detail__c from Apttus__AgreementLineItem__c where  Initial_Document_Generation__c=true and Apttus__AgreementId__c IN: ids LIMIT 1];
            
            for(Apttus__AgreementLineItem__c agreementLine:agrLineList){
                agreemap.put(agreementLine.Agreement_Name_Text__c,agreementLine.LOB_Detail__c);
                idList.add(agreementLine.id);
                AgreemntID= agreementLine.Agreement_Name_Text__c;
                LOBDetail=agreementLine.LOB_Detail__c;
            }
            for(Attachment Attachrecords : AttachList){
                String sTemplateString = Attachrecords.Name;
                String LastPCD;
                String TemplateName;
                    if (sTemplateString.IndexOF('_') >= 0) {  
                        String [] em = sTemplateString.split('\\_');                   
                        TemplateName = em[1]; 
                    }
                    if(TemplateName.contains('Client Facing PCD')){
                    String [] em1 = sTemplateString.split('\\-');                   
                    String FileName= em1[0];   
                            
                    Attachrecords.Name =AccountName +'__'+ LOBDetail + '_PCD_'+ DateTime.Now();
                    
                    }        
            }
            //PCDWordDocToPDFGeneratorTrigger.convertWordToPDF(idList);
            
        }
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
        
    } */
    
    
    
    public static void PCDDocbeforeInsert(List<Attachment> AttachList) { 

        try{
            Set<String> str=new Set<String>();
            Set<String> ids=new Set<String>();
            List<String> idList=new List<String>();
            String AccountName;
            String AgreemntID;
            String LOBDetail;
            map<String, String>agreemap=new map<String,String>();
            List<Apttus__DocumentVersionDetail__c> Docversiondtlupd = new List<Apttus__DocumentVersionDetail__c>();
            for(Attachment Attachrecords : AttachList){
                String sTemplateString = Attachrecords.Name;
                String TemplateName;
                str.add(Attachrecords.ParentId);
                    if (sTemplateString.IndexOF('_') >= 0) {  
                        String [] em = sTemplateString.split('\\_');                   
                        TemplateName = em[1]; 
                         //str.add(em[0]);
                        
                    }
            }
            for (Apttus__APTS_Agreement__c agrree:[Select id,Primary_Agreement_Line_Item__c,Account_Name__c,Task_SubType__c from Apttus__APTS_Agreement__c where Id IN:str])
            {// updated for US48361
                    ids.add(agrree.id);
                    AccountName = agrree.Account_Name__c;
                    //LOBDetail=agrree.LOB_Name__c;
                    List<Apttus__DocumentVersionDetail__c> Docversiondtlrtr = [select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                                                                Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
                                                                Apttus__FileType__c
                                                                from Apttus__DocumentVersionDetail__c where  Agreement__c = :agrree.id and Apttus__ContentId__c = null order by Apttus__VersionMajor__c desc
                                                                Limit 1];   
                                                                
                for(Attachment Attachrecords : AttachList)
                {
                    if (Docversiondtlrtr != null && !Docversiondtlrtr.isEmpty())
                    {
                    Attachrecords.Name = Docversiondtlrtr[0].Apttus__Title__c;
                    //Attachrecords.ParentId = Docversiondtlrtr.id;
                    //Attachrecords.ContentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
                    
                    Docversiondtlrtr[0].Apttus__ContentId__c = Attachrecords.Id;
                    List<Database.SaveResult> result = Database.update(Docversiondtlrtr, false);
                    for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                     }  
                    
                    }
                    else
                    {
                      
                      Apttus__DocumentVersionDetail__c Docversiondtlnew = new Apttus__DocumentVersionDetail__c();
                      List<Apttus__DocumentVersion__c> Docvrs = [select id,Apttus__LatestVersion__c from Apttus__DocumentVersion__c where Apttus__AgreementId__c = :Attachrecords.ParentId];
                      Apttus__APTS_Agreement__c agreement = [select id,Name,Primary_Agreement_Line_Item__c from Apttus__APTS_Agreement__c where Id= :Attachrecords.ParentId LIMIT 1];
                      Apttus__APTS_Template__c tpl = [
                      Select Id,Next_Template__c, Apttus__IsActive__c,Apttus__BusinessObject__c,Apttus__ActiveVersionId__c,Apttus__ReferenceId__c from Apttus__APTS_Template__c 
                        where Apttus__IsActive__c = True and Name= :Label.PCD_Template_Name LIMIT 1
                        ];    
                      Decimal maj = 1;
                      Decimal minor = 1;
                      Decimal revision =0;
                      String nm;
                      if (Docvrs == null || Docvrs.isEmpty()) 
                      {
                         Apttus__DocumentVersion__c Docversion = new Apttus__DocumentVersion__c();
                         Docversion.Name = 'Generate Agreement';
                         Docversion.Apttus__AgreementId__c = Attachrecords.ParentId;  
                         Docversion.Apttus__LatestVersion__c = '1.0.0';
                         Docversion.Apttus__ReferenceId__c = tpl.Apttus__ReferenceId__c;
                         Docversion.Apttus__TemplateId__c = tpl.Id;
                         Docversion.Apttus__Title__c = Attachrecords.Name;   
                         Database.SaveResult result = Database.insert(Docversion, false);
                          if(!result.isSuccess()) {
                                throw new AuraHandledException(result.getErrors()[0].getMessage());
                                    }   
                         Docvrs = [select id,Apttus__LatestVersion__c from Apttus__DocumentVersion__c where Apttus__AgreementId__c = :Attachrecords.ParentId ];   
                        }
                        if (Docvrs != null && !Docvrs.isEmpty()) 
                        {
                        List<Apttus__DocumentVersionDetail__c> Docversiondtl = [
                        select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                        Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                        from Apttus__DocumentVersionDetail__c where Apttus__DocumentVersionId__c= :Docvrs[0].Id and Apttus__ContentId__c = null
                        order by Name desc
                        Limit 1
                        ];
                        List<Apttus__DocumentVersionDetail__c> Docversionversion = [
                        select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                        Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                        from Apttus__DocumentVersionDetail__c where Apttus__DocumentVersionId__c= :Docvrs[0].Id 
                        order by Name desc
                        Limit 1
                        ];
                        if (Docversiondtl != null && !Docversiondtl.isEmpty()) 
                        {
                            maj = Docversiondtl[0].Apttus__VersionMajor__c;
                            minor = Docversiondtl[0].Apttus__VersionMinor__c;
                            revision = Docversiondtl[0].Apttus__VersionRevision__c;
                            revision = revision + 1;
                        }
                        else
                        {
                        if (Docversionversion != null && !Docversionversion.isEmpty()) 
                        {
                            maj = Docversionversion[0].Apttus__VersionMajor__c;
                            minor = Docversionversion[0].Apttus__VersionMinor__c;
                            revision = Docversionversion[0].Apttus__VersionRevision__c;
                            revision = revision + 1;
                        }
                        }
                        nm = maj + '.' + minor + '.' + revision;
                        String docinfo;
                        docinfo = 'Draft';   
                        
                        List<Apttus__DocumentVersionDetail__c> Docversiondtlsubtype = [
                        select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                        Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                        from Apttus__DocumentVersionDetail__c where Apttus__DocumentVersionId__c= :Docvrs[0].Id
                        and Task_SubType__c=:agrree.Task_SubType__c  and Agreement_Line_Item__c= :agreement.Primary_Agreement_Line_Item__c];
                          
                     
                        for (Apttus__DocumentVersionDetail__c doccstlupd : Docversiondtlsubtype )
                        {
                           doccstlupd.Task_SubType__c = null;
                           Docversiondtlupd.add(doccstlupd);
                   
                        }    
                        
                        
                        Docversiondtlnew.Name = nm;
                        Docversiondtlnew.Agreement__c = Attachrecords.ParentId;
                        if (agreement != null)
                        {
                        Docversiondtlnew.Agreement_Line_Item__c = agreement.Primary_Agreement_Line_Item__c; 
                        }
                        Docversiondtlnew.Apttus__Title__c= Attachrecords.Name;
                        Docversiondtlnew.Task_SubType__c = agrree.Task_SubType__c; // updated for US48361
                        Docversiondtlnew.Apttus__DocumentInfo__c= docinfo;
                        Docversiondtlnew.Apttus__VersionMajor__c = maj;
                        Docversiondtlnew.Apttus__VersionMinor__c = minor; 
                        Docversiondtlnew.Apttus__VersionRevision__c = revision;
                        Docversiondtlnew.Apttus__DocumentVersionId__c=Docvrs[0].Id;
                        Docversiondtlnew.Apttus__Action2__c = 'Generate Agreement';
                        Docversiondtlnew.Apttus__Comment__c = 'Generate Agreement';
                        Docversiondtlnew.Apttus__FileType__c = 'Attachment';
                        Docversiondtlnew.Apttus__IsTransient__c = false;
                        Docversiondtlnew.Apttus__TemplateVersionId__c = tpl.Apttus__ActiveVersionId__c;
                        Docversiondtlnew.Apttus__ContentId__c = Attachrecords.Id;
                        
                        if (agrree.Task_SubType__c =='Initial')
                        Docversiondtlnew.Sequence__c = 1;
                        if (agrree.Task_SubType__c =='BAFO I')
                        Docversiondtlnew.Sequence__c = 2;
                        if (agrree.Task_SubType__c ==' BAFO II')
                        Docversiondtlnew.Sequence__c = 3;
                        if (agrree.Task_SubType__c =='BAFO III')
                        Docversiondtlnew.Sequence__c = 4;
                        if (agrree.Task_SubType__c =='BAFO IV')
                        Docversiondtlnew.Sequence__c = 5;
                        if (agrree.Task_SubType__c =='BAFO V')
                        Docversiondtlnew.Sequence__c = 6;
                        if (agrree.Task_SubType__c ==' BAFO VI')
                        Docversiondtlnew.Sequence__c = 7;
                        if (agrree.Task_SubType__c =='BAFO VII')
                        Docversiondtlnew.Sequence__c = 8; 
                        if (agrree.Task_SubType__c =='BAFO VIII')
                        Docversiondtlnew.Sequence__c = 9; 
                        
                        Database.SaveResult result = Database.insert(Docversiondtlnew, false);
                        if(!result.isSuccess()) {
                            throw new AuraHandledException(result.getErrors()[0].getMessage());
                            } 
                        Docvrs[0].Apttus__LatestVersion__c = nm;     
                        List<Database.SaveResult> result1 = Database.update(Docvrs, false);
                        for(Integer i=0;i<result1.size();i++)
                         {
                           if(!result1.get(i).isSuccess()) 
                         {
                           Database.Error error = result1.get(i).getErrors().get(0);
                           String failedDML = error.getMessage();
                           throw new AuraHandledException(failedDML);
                          }
                        }  
                       
                        List<Database.SaveResult> result2 = Database.update(Docversiondtlupd, false);
                        for(Integer i=0;i<result2.size();i++)
                         {
                           if(!result2.get(i).isSuccess()) 
                         {
                           Database.Error error = result2.get(i).getErrors().get(0);
                           String failedDML = error.getMessage();
                           throw new AuraHandledException(failedDML);
                          }
                        }       
                            
                      }
                    
                    }
                    }                                                  
                                                                
                                                                
            }
        
            
            
        
            }
        
    
        catch(exception e){
            system.debug('========Exception=========='+e);
        }
        
    }
    
   /*=================================================================================================================================
     * @Method Name       : updateAgreementGenerationDate
     * @author            : John Paul Revilla
     * @Last modified by  : 
     * @Last modified date: 04/15/2020
     * @Purpose           : Method that updates the Master Generation Date field in Agreement for US47108
     * @Parameters        : map<id, Datetime> agreementIdCreatedDateMap
    ==================================================================================================================================*/
    public static void updateAgreementGenerationDate(map<id, Datetime> agreementIdCreatedDateMap, map<id, Attachment> docVerDetailAttachmentMap){
        if(docVerDetailAttachmentMap.keySet().size() >0){
            List<Apttus__DocumentVersionDetail__c> docVerDetailList = [Select id,   Agreement__c from Apttus__DocumentVersionDetail__c where id in: docVerDetailAttachmentMap.keySet()];
            for(Apttus__DocumentVersionDetail__c docVerDetail : docVerDetailList){
                if(agreementIdCreatedDateMap.containsKey(docVerDetail.Agreement__c)){
                    if(agreementIdCreatedDateMap.get(docVerDetail.Agreement__c) < docVerDetailAttachmentMap.get(docVerDetail.Id).CreatedDate){
                        agreementIdCreatedDateMap.put(docVerDetail.Agreement__c, docVerDetailAttachmentMap.get(docVerDetail.Id).CreatedDate);
                    }
                }
                else{
                    agreementIdCreatedDateMap.put(docVerDetail.Agreement__c, docVerDetailAttachmentMap.get(docVerDetail.Id).CreatedDate);
                }
            }
        }
        //gets all of the agreement that are in the agreementIdCreatedDateMap using its keyset
        List<Apttus__APTS_Agreement__c> agreementRecs = [select id, Master_Document_Generation_Date__c from Apttus__APTS_Agreement__c where id in: agreementIdCreatedDateMap.keySet()];
        //checks updates each record with the new date from the agreementIdCreatedDateMap using the record id as the key
        for(Apttus__APTS_Agreement__c agreementRec : agreementRecs){
            agreementRec.Master_Document_Generation_Date__c = agreementIdCreatedDateMap.get(agreementRec.Id);
        }
        update agreementRecs;
    }
 
}