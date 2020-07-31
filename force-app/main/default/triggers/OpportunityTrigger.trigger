trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Opportunity' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    } 
    if(isRun){   // is custom metadatatype is true for Opportunity
        if(Trigger.isUpdate && Trigger.isBefore ){  
        }
        if(Trigger.isinsert && Trigger.isBefore ){  
        }
         if(Trigger.IsDelete && Trigger.IsAfter ){ 
            OpportunityTriggerHelper.deleteSalespersonAccessOnFaf(Trigger.old); //Added By Preetham Padala this will remove faf visibility from Oppty winner and Med D sales lead,  if we delete Opportunity
        }
        if(Trigger.IsUpdate && Trigger.IsAfter ){   //Added By Preetham Padala this will add and  remove faf visibility to Oppty winner and Med D sales lead, 
            //if we update Oppty winner and Med D sales lead on  Opportunity
            OpportunityTriggerHelper.salespersonAccessOnFaf(Trigger.new, Trigger.oldMap); 
        }
        if(Trigger.IsAfter && Trigger.IsInsert){
            //Added By Preetham Padala this will add faf visibility to Oppty winner and Med D sales lead, 
            //if we insert  Oppty winner and Med D sales lead on  Opportunity
            OpportunityTriggerHelper.salespersonAccessOnFaf(Trigger.new, Trigger.oldMap); 
        }
        
        
    }
    
}