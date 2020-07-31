/******
Test Class: Test_FilesManagmentHelper
******/
trigger ContentDocumentTrigger on ContentDocument (before delete,before update,after update) {
    //check trigger is enabled or not 
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'ContentDocument' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    //if enabled run loigc
    if(isRun){
         
         //verify files edited/deleted are relared to FAF or realted objects.
         set<id> cdIds=new set<id>();
         if(trigger.isdelete){
             cdIds=trigger.oldMap.keySet();
         }
         
         if(trigger.isupdate){
             cdIds=trigger.newMap.keySet();
         }
         
         boolean checkValidation=false;
         set<string> objectset=new set<string>();
         for(FileUploadRestrictObjectList__c f:FileUploadRestrictObjectList__c.getAll().Values()){
             objectset.add(f.name);
         }
        
        List<contentDocumentLink> cdllist=[select id,LinkedEntityId,contentdocumentid from ContentDocumentLink where contentdocumentid in:cdIds];
        for(ContentDocumentLink cdl:cdllist){
                if(!checkValidation){
                  String sObjName = cdl.LinkedEntityId.getSObjectType().getDescribe().getName();
                  if(objectset.contains(sObjName )){
                      checkValidation=true;
                      break;
                  }
               }
        }
        
        if(checkValidation){
            if(Trigger.isUpdate && Trigger.isBefore)
                    FilesManagmentHelper.displayFileRestrictionError(trigger.new[0],label.PreventFileEditError);
            if(Trigger.isDelete)
                    FilesManagmentHelper.displayFileRestrictionError(trigger.old[0],label.PreventFileDeleteError);
        }
        //log history tracking for files/notes
         if(Trigger.isBefore && Trigger.isDelete){
             FilesHistoryTracking.InsertFileHistory(cdllist,'DELETE');
         }
         if(Trigger.isAfter &&  Trigger.isUpdate){
             FilesHistoryTracking.InsertFileHistory(cdllist,'UPDATE');
         }
    }         
           
}