trigger ClinicalOperationsTrigger on Clinical_Operations__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Clinical_Operations' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun){
       if(Trigger.isInsert && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
               ClinicalOperationsTriggerHelper.updateFAFOnInsert(Trigger.new);
            
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean co = fht.Clinical_Operations__c;
               Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
               Boolean cobu = fhbu.Clinical_Operations__c;
               Boolean bulkexclude = false;
               for (Clinical_Operations__c corecord : Trigger.new)                                                                               
                {
                  if (corecord.FAF_Data_Loading_Flag__c == true || corecord.FAF_Copy_In_Progress__c == true)
                  {
                   bulkexclude = true;
                   break;
                  }                                                       
                }
               if (co == true && (cobu ==false ||(cobu ==true && bulkexclude == false) ))
               {
                 SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Clinical_Operations__c','FAF_ID__c','Clinical Operations','INSERT');
               }
        }
    
        if(Trigger.isDelete && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            ClinicalOperationsTriggerHelper.updateFAFOnDelete(Trigger.old);
        }
        
        if(Trigger.isInsert && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            ClinicalOperationsTriggerHelper.checkCountOnBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isDelete && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            ClinicalOperationsTriggerHelper.checkElectionOnDelete(Trigger.old);
            
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean co = fht.Clinical_Operations__c;
               if (co == true)
               {
                 SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Clinical_Operations__c','FAF_ID__c','Clinical Operations','DELETE');
               }
        }
        
        if(Trigger.isUpdate && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
        {
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean co = fht.Clinical_Operations__c;
               Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
               Boolean cobu = fhbu.Clinical_Operations__c;
               Boolean bulkexclude = false;
               for (Clinical_Operations__c corecord : Trigger.new) 
                {
                  if (corecord.FAF_Data_Loading_Flag__c == true || corecord.FAF_Copy_In_Progress__c == true)
                  {
                   bulkexclude = true;
                   break;
                  }
                }
                 
               if (co == true && (cobu ==false ||(cobu ==true && bulkexclude == false) ))
               {
                 SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Clinical_Operations__c','FAF_ID__c','Clinical Operations');
               }
        }
    }
}