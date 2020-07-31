trigger NetworkOperationsTrigger on Network_Operations__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    
   //Fetching info from MetaData
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Network_Operations' && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
    
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
   {
    if(Trigger.isInsert && Trigger.isAfter)
    {
           NetworkOperationsTriggerHelper.updateFAFOnInsert(Trigger.new);
        
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean no = fht.Network_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean nobu = fhbu.Network_Operations__c;
           Boolean bulkexclude = false;
           for (Network_Operations__c norecord : Trigger.new) 
            {
              if (norecord.FAF_Data_Loading_Flag__c == true || norecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (no == true && (nobu ==false ||(nobu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Network_Operations__c','FAF_ID__c','Network Operations','INSERT');
           }
     }
        
    if(Trigger.isDelete && Trigger.isAfter){
        NetworkOperationsTriggerHelper.updateFAFOnDelete(Trigger.old);
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        NetworkOperationsTriggerHelper.checkCountOnBeforeInsert(Trigger.new);
    }
      
    if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean no = fht.Network_Operations__c;
           if (no == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Network_Operations__c','FAF_ID__c','Network Operations','DELETE');
           }
    }  
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        NetworkOperationsTriggerHelper.clientValueUpdateOnPricing(Trigger.oldmap,Trigger.newmap);
        
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean no = fht.Network_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean nobu = fhbu.Network_Operations__c;
           Boolean bulkexclude = false;
           for (Network_Operations__c norecord : Trigger.new) 
            {
              if (norecord.FAF_Data_Loading_Flag__c == true || norecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (no == true && (nobu ==false ||(nobu ==true && bulkexclude == false) ))
           {
            SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Network_Operations__c','FAF_ID__c','Network Operations');
           }
     }
   }  
}