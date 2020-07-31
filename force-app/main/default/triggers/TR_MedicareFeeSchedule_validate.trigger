trigger TR_MedicareFeeSchedule_validate on Medicare_Part_D_Fees_Schedule__c (after update, after insert,before delete,before update,before insert) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
        switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
        for (SwitchValidation__mdt sv : switchValidationList) {
            if(sv.DeveloperName == 'Medicare_Part_D_Fees_Schedule' && sv.Enable_Trigger__c){
                isRun = true;
                break;
            }
        }
    }
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
    {
        if(trigger.IsInsert && trigger.IsAfter) 
        {
            Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
            Boolean md = fht.Medicare_Part_D_Fees_Schedule__c;
            Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
            Boolean mdbu = fhbu.Medicare_Part_D_Fees_Schedule__c;
            Boolean bulkexclude = false;
            for (Medicare_Part_D_Fees_Schedule__c mdrecord : Trigger.new)                                                                               
            {
                if (mdrecord.FAF_Data_Loading_Flag__c == true || mdrecord.FAF_Copy_In_Progress__c == true)
                {
                    bulkexclude = true;
                    break;
                }                                                       
            }
            if (md == true && (mdbu ==false ||(mdbu ==true && bulkexclude == false) ))
            {
                SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Medicare_Part_D_Fees_Schedule__c','FAF_ID__c','Medicare Part D Fees Schedules','INSERT');
            }
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
            Boolean md = fht.Medicare_Part_D_Fees_Schedule__c;
            Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
            Boolean mdbu = fhbu.Medicare_Part_D_Fees_Schedule__c;
            Boolean bulkexclude = false;
            for (Medicare_Part_D_Fees_Schedule__c mdrecord : Trigger.new) 
            {
                if (mdrecord.FAF_Data_Loading_Flag__c == true || mdrecord.FAF_Copy_In_Progress__c == true)
                {
                    bulkexclude = true;
                    break;
                }
            }
            
            if (md == true && (mdbu ==false ||(mdbu ==true && bulkexclude == false) ))
            {
                SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Medicare_Part_D_Fees_Schedule__c','FAF_ID__c','Medicare PartD Fees Schedules');
            }
        }
        
        if(Trigger.isBefore && Trigger.isDelete){
            MedicareFeeScheduleTriggerHelper.checkElectionOnDelete(Trigger.Old);
            
            Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
            Boolean md = fht.Medicare_Part_D_Fees_Schedule__c;
            if (md == true)
            {
                SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Medicare_Part_D_Fees_Schedule__c','FAF_ID__c','Medicare Part D Fees Schedules','DELETE');
            }
        }
        if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore)){
            MedicareFeeScheduleTriggerHelper.validatePBMServices(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
    }
}