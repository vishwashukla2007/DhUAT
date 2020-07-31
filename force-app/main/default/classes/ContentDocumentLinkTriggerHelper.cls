/* ==================================================================================
 * @Class Name      : ContentDocumentLinkTriggerHelper
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 30/07/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 30/07/2018
 * @Purpose           : Trigger Helper Class to limit only one record Insertion on File Object
=======================================================================================*/
public with sharing class ContentDocumentLinkTriggerHelper{
    //modified by John Paul Revilla 11/02/2020 for US28526
    //handles the on before insert feature of the handler to segragate and execute actions related to the different process of SFS, PCD and FAF
    public static void onBeforeInsert(List<ContentDocumentLink> ContentDocumentLink){
        //creates a list attachment for SFS
        list<ContentDocumentLink> sfsDocuments = new list<ContentDocumentLink>();
        list<ContentDocumentLink> conDocuments = new list<ContentDocumentLink>();
        set<id> contentDocumentIdSet = new set<id>();
        map<id , ContentDocumentLink>  mapConDocId = new map<id , ContentDocumentLink>();
        //iterates through the attachments and check if the attachment has an SFS in the name if yes add to SFS list else add it to the PCD and FAF list
        for(ContentDocumentLink doc : ContentDocumentLink)
        {
            mapConDocId.put(doc.ContentDocumentId, doc);
        }
        list<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId, Title FROM ContentVersion where ContentDocumentId in: mapConDocId.keySet()];
        for(ContentVersion conTitle : contentVersionList){
             //split the name using the _ and getting the first instance of the array
            string docSFSName = conTitle.Title.split('_')[0];
            if(docSFSName.toUpperCase() == Label.Speciality_Fees_Schedule){
                sfsDocuments.add(mapConDocId.get(conTitle.ContentDocumentId));
            }
            else{
                conDocuments.add(mapConDocId.get(conTitle.ContentDocumentId));
            }
        }
        
        //checks if the list is empty and calls the  upsertAgreementAttachment method 
        if(!sfsDocuments.isEmpty()){
            upsertAgreementAttachment(sfsDocuments);
        }
        if(!conDocuments.isEmpty()){
            blockmultipleRecordInsertion(conDocuments);
        }
    }
     //modified by John Paul Revilla 11/02/2020 for US28526
    //Upserts the generated SFS from the Pricing Model to the Related Agreement based on the SFS agreement field if no record is existing create one
    public static void upsertAgreementAttachment(List<ContentDocumentLink> ContentDocumentLink){
        //gets the custom label for SFS
        string SFS = Label.Speciality_Fees_Schedule;
        //creates a set to store the unique iUms Task Setup Record Ids
        set<Id> parentIdSet = new set<id>();
        set<Id> parentIdErrorSet = new set<id>();
        //iterates throught the new attachments for SFS
        for(ContentDocumentLink conDocument: ContentDocumentLink){
            parentIdSet.add(conDocument.LinkedEntityId);
        }
        system.debug('=========parentIdSet============'+parentIdSet);
        //gets the list of iUms Task Records filtering using the unique ids from the attachment
        list<iUMS_Task_Setup__c> iUmsTaskSetupList = [Select id, SFS_Agreement__c, Status__c, Salesperson__c, Underwriter__c, Account__c, Account__r.Name from iUMS_Task_Setup__c where id in: parentIdSet];
        //create a map that would hold the  iums taks record as a value and iums task setup record id as the key 
        map<id, iUMS_Task_Setup__c> taskSetupUpdateMap = new map<id, iUMS_Task_Setup__c>();
        ////create a map that would hold the  aggrement record as value and iums task setup record id as the key, would hold all the attachments without agreement records
        map<id, Apttus__APTS_Agreement__c> taskSetupIdAgreementAddMap = new map<id, Apttus__APTS_Agreement__c>();
        boolean error = false;
        //iterates over the iumstasksetuplist
        system.debug('=========iUmsTaskSetupList============'+iUmsTaskSetupList);
        for(iUMS_Task_Setup__c iUmsTaskSetup :  iUmsTaskSetupList){
            iUmsTaskSetup.Status__c = 'Complete';
            //checks if the record has an SFS agreement and then adds it to the taskSetupUpdateMap
            if(!String.isBlank(iUmsTaskSetup.SFS_Agreement__c)){
                taskSetupUpdateMap.put(iUmsTaskSetup.id, iUmsTaskSetup);
            }
            //else create an agreement and add it to the  taskSetupIdAgreementAddMap and taskSetupUpdateMap
            else{
                Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
                //assign SFS name of account name-SFS-date today(yyyy-mm-dd)
                agreement.name= iUmsTaskSetup.Account__r.Name + '-'+ SFS +'-' + string.valueOf(date.today());
                //modified by Symon Bucay 05/03/2020 for AC#2 of US34377: Remove SFS_Status__c
                if(iUmsTaskSetup.Account__c != null){
                    agreement.Apttus__Account__c = iUmsTaskSetup.Account__c;
                }
                else{
                    parentIdErrorSet.add(iUmsTaskSetup.id);
                }
                //create a code here to throw exception 
                if(iUmsTaskSetup.Salesperson__c != null){
                    agreement.Sales_Approver__c = iUmsTaskSetup.Salesperson__c;
                }
                if(iUmsTaskSetup.Underwriter__c != null){
                    agreement.UW_Approver__c = iUmsTaskSetup.Underwriter__c;
                }
                
                
                agreement.Apttus__Contract_Start_Date__c =date.today();
                //get assign the SFS record id to the agreement
                agreement.recordtypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(SFS).getRecordTypeId();
                //sets the account base on the task setup record
                agreement.Apttus__Account__c = iUmsTaskSetup.Account__c;
                agreement.SFS_Path__c = 'SFS Upload Completed';
                taskSetupIdAgreementAddMap.put(iUmsTaskSetup.id, agreement);
                taskSetupUpdateMap.put(iUmsTaskSetup.id, iUmsTaskSetup);
            }
        }
        if(!taskSetupIdAgreementAddMap.isEmpty()){
            //inserts the values of the taskSetupIdAgreementAddMap to get the new agreement ids
            insert taskSetupIdAgreementAddMap.values();
            
            list<iUMS_Task_Setup__c> iumsTaskSetupListUpdate = new List<iUMS_Task_Setup__c>();
            //iterates over the taskSetupIdAgreementAddMap keys if key is in taskSetupUpdateMap then update the SFS Agreement field
            for(Id key : taskSetupIdAgreementAddMap.keySet()){
                if(taskSetupUpdateMap.containsKey(key)){
                    taskSetupUpdateMap.get(key).SFS_Agreement__c = taskSetupIdAgreementAddMap.get(key).Id;
                }
            }
            //updates the values of the taskSetupUpdateMap to assign the correct agreement to the iums task
            update taskSetupUpdateMap.values();
        }
        if(!taskSetupUpdateMap.isEmpty()){
            //iterates over the new list and updates the parent ids base on the proper agreement;
            for(ContentDocumentLink conDocument: ContentDocumentLink){
                if(!parentIdErrorSet.contains(conDocument.LinkedEntityId))
                {
                    if(taskSetupUpdateMap.containsKey(conDocument.LinkedEntityId)){
                        conDocument.LinkedEntityId = taskSetupUpdateMap.get(conDocument.LinkedEntityId).SFS_Agreement__c;
                    }
                }
                else {
                    String acctError = label.AgreementCreationAccountError;
                    conDocument.addError(acctError);
                }
                    
            }
        }
    }

    //Method used to check only one record of File can be inserted on Guarantee Information Object
    public static void blockmultipleRecordInsertion(List<ContentDocumentLink> conDocLnkList) {
        Set<Id> linkRecIdSet = new Set<Id>();   // Set to hold the Parent id(Guarantee Information) of inserted records
        Set<Id> feeSchedRecIdSet = new Set<Id>();   // Set to hold the Parent id(Med D fee Schedule)  of inserted records
        Set<Id> existLinkRecIdSet = new Set<Id>();      // Set to hold the Parent id(Guarantee Information) of Existing records in the environment
        Set<Id> existfeeSchedRecIdSet = new Set<Id>();     // Set to hold the Parent id (Med D fee Schedule) of Existing records in the environment
        List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
        Map<Id,Integer> existLinkRecCountMap = new Map<Id,Integer>();   // Map to hold the id of Parent(Guarantee Information)) and their associated Files Records COunt
        Map<Id,Integer> existfeeSchedRecCountMap = new Map<Id,Integer>();   // Map to hold the id of Parent(Med D fee Schedule) and their associated Files Records COunt
        try{
            for(ContentDocumentLink cdl : conDocLnkList){
                system.debug('=========cdl============'+cdl);
                //Checking the object type  for which we need to implement the limit
                if(String.ValueOf(cdl.LinkedEntityId.getsobjecttype()) == 'Guarantees_Information__c'){
                    linkRecIdSet.add(cdl.LinkedEntityId);
                    contentDocumentLinkList.add(cdl);
                }
                if(String.ValueOf(cdl.LinkedEntityId.getsobjecttype()) == 'Medicare_Part_D_Fees_Schedule__c'){
                    feeSchedRecIdSet.add(cdl.LinkedEntityId);
                    contentDocumentLinkList.add(cdl);
                }
                
            }
            
            if(!feeSchedRecIdSet.isEmpty()){                
                //Query the existing record from the environment
                List<ContentDocumentLink> existfeeSchedConDocLinkRec = [select id, LinkedEntityId from ContentDocumentLink where LinkedEntityId in: feeSchedRecIdSet];
                if(!existfeeSchedConDocLinkRec.isEmpty()){
                    for(ContentDocumentLink cdl: existfeeSchedConDocLinkRec){
                        Integer temInt = 0;
                        
                        //For check Map is Empty
                        if(existfeeSchedRecCountMap.isEmpty()){
                            existfeeSchedRecCountMap.put(cdl.LinkedEntityId,1); 
                        }else{
                            //if Map is not empty and set contains Id means recod should be already present in the Map 
                            if(existfeeSchedRecIdSet.Contains(cdl.LinkedEntityId)){
                                temInt = existfeeSchedRecCountMap.get(cdl.LinkedEntityId)+1;
                                existfeeSchedRecCountMap.put(cdl.LinkedEntityId, temInt);
                            }else{
                                existfeeSchedRecCountMap.put(cdl.LinkedEntityId,1); 
                            }
                        }
                        existfeeSchedRecIdSet.add(cdl.LinkedEntityId);
                    }
                }
                for(ContentDocumentLink cdl: contentDocumentLinkList){
                    if(existfeeSchedRecIdSet.Contains(cdl.LinkedEntityId)){
                        
                        //For check if File already exist in the system
                        if(existfeeSchedRecCountMap.get(cdl.LinkedEntityId)>=1){
                            cdl.addError('User can attach only single File');   //For display error
                        }
                    }
                }
            }
            
            system.debug('=========linkRecIdSet============'+linkRecIdSet);
            if(!linkRecIdSet.isEmpty()){
                
                //Query the existing record from the environment
                List<ContentDocumentLink> existConDocLinkRec = [select id, LinkedEntityId from ContentDocumentLink where LinkedEntityId in: linkRecIdSet];
                if(!existConDocLinkRec.isEmpty()){
                    for(ContentDocumentLink cdl: existConDocLinkRec){
                        Integer temInt = 0;
                        
                        //For check Map is Empty
                        if(existLinkRecCountMap.isEmpty()){
                            existLinkRecCountMap.put(cdl.LinkedEntityId,1); 
                        }else{
                            //if Map is not empty and set contains Id means recod should be already present in the Map 
                            if(existLinkRecIdSet.Contains(cdl.LinkedEntityId)){
                                temInt = existLinkRecCountMap.get(cdl.LinkedEntityId)+1;
                                existLinkRecCountMap.put(cdl.LinkedEntityId, temInt);
                            }else{
                                existLinkRecCountMap.put(cdl.LinkedEntityId,1); 
                            }
                        }
                        existLinkRecIdSet.add(cdl.LinkedEntityId);
                    }
                }
                for(ContentDocumentLink cdl: contentDocumentLinkList){
                    if(existLinkRecIdSet.Contains(cdl.LinkedEntityId)){
                        
                        //For check if File already exist in the system
                        if(existLinkRecCountMap.get(cdl.LinkedEntityId)>=1){
                            system.debug('=========existLinkRecCountMap.get(cdl.LinkedEntityId)============='+existLinkRecCountMap.get(cdl.LinkedEntityId));
                            cdl.addError('User can attach only single File');   //For display error
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('========Exception=========='+e);
        }
    }
}