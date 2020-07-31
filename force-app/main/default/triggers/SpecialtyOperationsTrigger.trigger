trigger SpecialtyOperationsTrigger on Specialty_Operations__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Specialty_Operations' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun){
        if(Trigger.isInsert && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            SpecialtyOperationsTriggerHelper.updateFAFOnInsert(Trigger.new);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean so = fht.Specialty_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sobu = fhbu.Specialty_Operations__c;
           Boolean bulkexclude = false;
           for (Specialty_Operations__c sorecord : Trigger.new)                                                                               
            {
              if (sorecord.FAF_Data_Loading_Flag__c == true || sorecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (so == true && (sobu ==false ||(sobu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Specialty_Operations__c','FAF_ID__c','Specialty Operations','INSERT');
           }
        }
        
        if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean so = fht.Specialty_Operations__c;
           if (so == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Specialty_Operations__c','FAF_ID__c','Specialty Operations','DELETE');
           }
         }  
    
        if(Trigger.isDelete && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            SpecialtyOperationsTriggerHelper.updateFAFOnDelete(Trigger.old);
        }
    
        if(Trigger.isInsert && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            SpecialtyOperationsTriggerHelper.checkCountOnBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            SpecialtyOperationsTriggerHelper.updatePlatfrmSpecific(Trigger.new,Trigger.oldMap);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean so = fht.Specialty_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sobu = fhbu.Specialty_Operations__c;
           Boolean bulkexclude = false;
           for (Specialty_Operations__c sorecord : Trigger.new) 
            {
              if (sorecord.FAF_Data_Loading_Flag__c == true || sorecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (so == true && (sobu ==false ||(sobu ==true && bulkexclude == false) ))
           {
                SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Specialty_Operations__c','FAF_ID__c','Specialty Operations');
           }
       }
    }    
}