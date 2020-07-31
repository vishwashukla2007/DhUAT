trigger PBMServicesTrigger on PBM_Services__c (before insert,before update,before delete, after delete) {
    
    if(Trigger.isDelete && Trigger.isBefore){
        PBMServiceTriggerHandler.handleBeforeDelete(Trigger.old);
        //PBMServiceTriggerHandler.handleBeforeDelete(Trigger.oldMap,Trigger.new);
    }
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        if(!PBMServiceTriggerHandler.firstcall) {
            PBMServiceTriggerHandler.firstcall = true;
            PBMServiceTriggerHandler.handleBeforeInsertUpdate(Trigger.new, Trigger.oldmap, Trigger.isInsert);
        }
    }
}