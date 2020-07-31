trigger BillingOperationsTrigger on Billing_Operations__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    
        switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
        for (SwitchValidation__mdt sv : switchValidationList) {
            if(sv.DeveloperName == ConstantsUtil.Billing_Operations && sv.Enable_Trigger__c){
                isRun = true;
                break;
            }
        }
    
    if(isRun)
    {
       // system.debug('DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER =='+DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER);
        //preventParentTriggerExecution.avoidParentTriggerExecution();
        if(Trigger.isInsert && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            BillingOperationsTriggerHelper.updateFAFOnInsert(Trigger.new);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean bo = fht.Billing_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean bobu = fhbu.Billing_Operations__c;
           Boolean bulkexclude = false;
           for (Billing_Operations__c borecord : Trigger.new) 
            {
              if (borecord.FAF_Data_Loading_Flag__c == true || borecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (bo == true && (bobu ==false ||(bobu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Billing_Operations__c','FAF_ID__c','Billing Operations','INSERT');
           }
        }
       
        if(Trigger.isDelete && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            BillingOperationsTriggerHelper.updateFAFOnDelete(Trigger.old);
        }
        
        if(Trigger.isDelete && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
            BillingOperationsTriggerHelper.checkElectionOnDelete(Trigger.old);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean bo = fht.Billing_Operations__c;
           if (bo == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Billing_Operations__c','FAF_ID__c','Billing Operations','DELETE');
           }
        }
        
        //    if(Trigger.isInsert && Trigger.isBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        //        BillingOperationsTriggerHelper.checkCountOnBeforeInsert(Trigger.new);
        //    }
        if(Trigger.isUpdate && Trigger.isAfter){
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean bo = fht.Billing_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean bobu = fhbu.Billing_Operations__c;
           Boolean bulkexclude = false;
           for (Billing_Operations__c borecord : Trigger.new) 
            {
              if (borecord.FAF_Data_Loading_Flag__c == true || borecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (bo == true && (bobu ==false ||(bobu ==true && bulkexclude == false) ))
           {            
                SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Billing_Operations__c','FAF_ID__c','Billing Operations');
           }
        }
    }
}