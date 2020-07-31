/* ====================================================================
 * @Trigger Name      : TR_Attachment 
 * @created date      : 11/12/2018
 * @Last modified date: 11/12/2018
 * @Purpose           : Trigger on Attachment object after Insert, this will call Apttus webservice to append HeaderFooter
 * Modifications:
 * John Paul Revilla US28526 - 11/02/2020 - commented out the PCDonbeforeInsert and moved it inside AttachmentTriggerHandler
========================================================================*/
trigger TR_Attachment on Attachment (before insert, after insert,after update,before delete) {
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    //Fetching info from MetaData
   switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Attachment' && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
    if(isRun){
        if(Trigger.isinsert && Trigger.isAfter){
           AttachmentTriggerHandler.onAfterInsert(Trigger.new);
//           AttachmentTriggerHandler.onafterInsert2(Trigger.new);           
        }
        if(Trigger.isinsert && Trigger.isBefore){ 
           AttachmentTriggerHandler.onBeforeInsert(Trigger.new);
           //AttachmentTriggerHandler.PCDonbeforeInsert(Trigger.new);
           //AttachmentTriggerHandler.PCDDocbeforeInsert(Trigger.new);
        }
        
        //log attachment upload/edit/delete history
        if(trigger.isDelete){
            FilesHistoryTracking.InsertAttachmentHistory(trigger.old,'DELETE');
        }
        if( trigger.isInsert && trigger.isAfter){
            FilesHistoryTracking.InsertAttachmentHistory(trigger.new,'INSERT');
        }
        if( trigger.isUpdate && trigger.isAfter){
            FilesHistoryTracking.InsertAttachmentHistory(trigger.new,'UPDATE');
        }
    }
}