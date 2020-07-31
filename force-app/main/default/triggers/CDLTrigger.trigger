/******
Test Class: Test_FilesManagmentHelper
******/
trigger CDLTrigger on ContentDocumentLink (before insert,before update,after insert) {
    
    //cehck trigger is enabled or not 
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'ContentDocumentLink' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    //if enabled run loigc
    if(isRun){
         boolean checkValidation=false;
         set<string> objectset=new set<string>();
         for(FileUploadRestrictObjectList__c f:FileUploadRestrictObjectList__c.getAll().Values()){
             objectset.add(f.name);
         }
         //check if linked object is FAF or realted components that we would need to restrict
         for(ContentDocumentLink cdl:trigger.new){
              if(!checkValidation){
                  String sObjName = cdl.LinkedEntityId.getSObjectType().getDescribe().getName();
                  if(objectset.contains(sObjName )){
                      checkValidation=true;
                      break;
                  }
               }
         }
            if(checkValidation && Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
                FilesManagmentHelper.displayFileRestrictionError(trigger.new[0],label.PreventFileUploadError);
            //log history tracking for files/notes
            if(Trigger.isAfter && Trigger.isInsert){
                FilesHistoryTracking.InsertFileHistory(trigger.new,'INSERT');
            }
             
        }
}