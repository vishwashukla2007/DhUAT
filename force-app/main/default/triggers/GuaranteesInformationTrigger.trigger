trigger GuaranteesInformationTrigger on Guarantees_Information__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Guarantees_Information' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    }
    if(isRun){
       if(Trigger.isInsert && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            GuaranteesInformationTriggerHelper.updateFAFOnInsert(Trigger.new);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gi = fht.Guarantees_Information__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean gibu = fhbu.Guarantees_Information__c;
           Boolean bulkexclude = false;
           for (Guarantees_Information__c girecord : Trigger.new)                                                                               
            {
              if (girecord.FAF_Data_Loading_Flag__c == true || girecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (gi == true && (gibu ==false ||(gibu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Guarantees_Information__c','FAF_ID__c','Guarantees Information','INSERT');
           }
       }
    
       if(Trigger.isDelete && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            GuaranteesInformationTriggerHelper.updateFAFOnDelete(Trigger.old);
       }
    
       if(Trigger.isInsert && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            GuaranteesInformationTriggerHelper.checkCountOnBeforeInsert(Trigger.new);           
       }
        
       if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gi = fht.Guarantees_Information__c;
           if (gi == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Guarantees_Information__c','FAF_ID__c','Guarantees Information','DELETE');
           }
       } 
        
       if(Trigger.isUpdate && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            GuaranteesInformationTriggerHelper.updateRiskAmount(Trigger.new);
            GuaranteesInformationTriggerHelper.deleteGNCChildRecords(Trigger.oldmap,Trigger.newmap);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gi = fht.Guarantees_Information__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean gibu = fhbu.Guarantees_Information__c;
           Boolean bulkexclude = false;
           for (Guarantees_Information__c girecord : Trigger.new) 
            {
              if (girecord.FAF_Data_Loading_Flag__c == true || girecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (gi == true && (gibu ==false ||(gibu ==true && bulkexclude == false) ))
           {
                SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Guarantees_Information__c','FAF_ID__c','Guarantee Information');
           }
       }
    }    
}