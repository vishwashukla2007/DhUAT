trigger RDSTrigger on Retiree_Drug_Subsidy__c (before insert, before update, before delete, after delete) {
    
    if(Trigger.isDelete && Trigger.isBefore){
        RDSTriggerHandler.handleBeforeDelete(Trigger.old);
    }
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        if(!RDSTriggerHandler.firstcall) {
            RDSTriggerHandler.firstcall = true;
            RDSTriggerHandler.handleBeforeInsertUpdate(Trigger.new, Trigger.oldmap, Trigger.isInsert);
        }
    }
}