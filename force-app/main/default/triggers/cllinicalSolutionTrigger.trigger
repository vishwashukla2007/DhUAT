trigger cllinicalSolutionTrigger on Clinical_Solutions__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Clinical_Solutions' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    if(isRun){
        if(trigger.isinsert && trigger.isbefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            cllinicalSolTriggerHelper.dulicateCheckSol(trigger.new); 
        }
        
        if(Trigger.isInsert && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
        {
            Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
            Boolean cs = fht.Clinical_Solutions__c;
            Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
            Boolean csbu = fhbu.Clinical_Solutions__c;
            Boolean bulkexclude = false;
            for (Clinical_Solutions__c corecord : Trigger.new)                                                                               
            {
                if (corecord.FAF_Data_Loading_Flag__c == true || corecord.FAF_Copy_In_Progress__c == true)
                {
                    bulkexclude = true;
                    break;
                }                                                       
            }
            if (cs == true && (csbu ==false ||(csbu ==true && bulkexclude == false) ))
            {
                SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Clinical_Solutions__c','FAF_ID__c','Clinical Solutions','INSERT');
            }
        }
        
        if(trigger.IsUpdate && trigger.IsAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // PCD Change to update Batch Update Flag
        {
            
            Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
            Boolean cs = fht.Clinical_Solutions__c;
            Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
            Boolean csbu = fhbu.Clinical_Solutions__c;
            Boolean bulkexclude = false;
            for (Clinical_Solutions__c csrecord : Trigger.new) 
            {
                if (csrecord.FAF_Data_Loading_Flag__c == true || csrecord.FAF_Copy_In_Progress__c == true)
                {
                    bulkexclude = true;
                    break;
                }
            }
            if (cs == true && (csbu ==false ||(csbu ==true && bulkexclude == false) ))
            {
                SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Clinical_Solutions__c','FAF_ID__c','Clinical Solutions');
            }
        }
        
        if(Trigger.isDelete && Trigger.isbefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            cllinicalSolTriggerHelper.updateElectionOnDelete(Trigger.old);
            
            Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
            Boolean cs = fht.Clinical_Solutions__c;
            if (cs == true)
            {
                SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Clinical_Solutions__c','FAF_ID__c','Clinical Solutions','DELETE');
            }
        }
        
        if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isbefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            cllinicalSolTriggerHelper.validatePBMServices(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
    }
}