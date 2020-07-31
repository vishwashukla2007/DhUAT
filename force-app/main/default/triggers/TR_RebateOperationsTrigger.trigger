trigger TR_RebateOperationsTrigger on Rebate_Operations__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
 List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    DeepCloneUtility cloneObj= new DeepCloneUtility();
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Rebate_Operations' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun )
    {    
    if(Trigger.isInsert && Trigger.isAfter  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
           RebateOperationsTriggerHelper.updateFAFOnInsert(Trigger.new);  
           DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = true; 
           RebateOperationsTriggerHelper.populateGNC(Trigger.new);
        
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ro = fht.Rebate_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean robu = fhbu.Rebate_Operations__c;
           Boolean bulkexclude = false;
           for (Rebate_Operations__c rorecord : Trigger.new) 
            {
              if (rorecord.FAF_Data_Loading_Flag__c == true || rorecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (ro == true && (robu ==false ||(robu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Rebate_Operations__c','FAF_ID__c','Rebate Operations','INSERT');
           }
    }
        
    if(Trigger.isDelete && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
         RebateOperationsTriggerHelper.updateFAFOnDelete(Trigger.old);
    }
    
    if(Trigger.isInsert && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
         RebateOperationsTriggerHelper.checkCountOnBeforeInsert(Trigger.new);
    }
   // if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
   //     RebateOperationsTriggerHelper.checkAdminfeebeforeinsert(Trigger.new);
   // }
   
    if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ro = fht.Rebate_Operations__c;
           if (ro == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Rebate_Operations__c','FAF_ID__c','Rebate Operations','DELETE');
           }
    }
        
    if(Trigger.isUpdate && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER ) 
    {       
           RebateOperationsTriggerHelper.RebateGuaranteeMirroringOptions(Trigger.new,Trigger.old, Trigger.oldMap); 
           RebateOperationsTriggerHelper.deleteChildGuaranteerecords(Trigger.new); 
           RebateOperationsTriggerHelper.updateplatformspec(Trigger.newMap,Trigger.oldMap);
           RebateOperationsTriggerHelper.populateGNC(Trigger.new);
           RebateOperationsTriggerHelper.deleteRebgChildRecords(Trigger.oldmap,Trigger.newmap);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ro = fht.Rebate_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean robu = fhbu.Rebate_Operations__c;
           Boolean bulkexclude = false;
           for (Rebate_Operations__c rorecord : Trigger.new) 
            {
              if (rorecord.FAF_Data_Loading_Flag__c == true || rorecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (ro == true && (robu ==false ||(robu ==true && bulkexclude == false) ))
           {            
            SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Rebate_Operations__c','FAF_ID__c', 'Rebate Operations');
           }
     }
   }
}