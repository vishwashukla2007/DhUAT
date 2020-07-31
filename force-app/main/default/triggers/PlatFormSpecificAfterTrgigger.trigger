trigger PlatFormSpecificAfterTrgigger on Platform_Specifics__c ( after insert, after update, after delete,before update, before insert, before delete) 
{
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
   {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Platform_Specifics' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
   }
    if(isRun || DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER== false){
    if( trigger.IsAfter && UtilClass.logTransactionHistoryFlag )
    {
        if(trigger.IsUpdate){
        if (PlatformSpecificTriggerHelper.BulkUpdate(Trigger.New) == true)
           return;
          }  
        UtilClass.logTransactionHistory( JSON.serialize(trigger.newmap), JSON.serialize(trigger.oldmap), 
        'Platform_Specifics__c', 'FAF_ID__c', 
                                new list<string>{'Level_1_Record_ID__c','Level_2_record_ID__c','Level_3_record_ID__c',
                                'Platform__c','Instruction__c'}, trigger.isInsert ? 'insert' : trigger.isUpdate ? 'update' : 'delete');
                              
      }
   }
   if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
     if(((trigger.IsUpdate && trigger.IsBefore ) || (trigger.IsInsert && trigger.IsBefore))){
         if (PlatformSpecificTriggerHelper.BulkUpdate(Trigger.New) == true)
        return; 
       PlatformSpecificTriggerHelper.validateXAERecords(Trigger.New, trigger.IsInsert, trigger.IsUpdate);    
       PlatformSpecificTriggerHelper.validatduplicateRecords(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
     }
     if((trigger.IsUpdate && trigger.IsAfter) || (trigger.IsInsert && trigger.IsAfter)){
             if (PlatformSpecificTriggerHelper.BulkUpdate(Trigger.New) == true)
            return; 
        system.debug('+++ Invoking DeleteXAE'); 
        PlatformSpecificTriggerHelper.DeleteXAE(Trigger.New, trigger.IsInsert, trigger.IsUpdate);   
        
        //close IPIWA task
        PlatformSpecificTriggerHelper.UpdateIPIWAstatus(trigger.new,trigger.old,trigger.isUpdate); 
     }
    
     if(trigger.IsInsert && trigger.IsAfter) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ps = fht.Platform_Specifics__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean psbu = fhbu.Platform_Specifics__c;
           Boolean bulkexclude = false;
           for (Platform_Specifics__c psrecord : Trigger.new)                                                                               
            {
              if (psrecord.FAF_Data_Loading_Flag__c == true || psrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (ps == true && (psbu ==false ||(psbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Platform_Specifics__c','FAF_ID__c','Platform Specifics','INSERT');
           }
     }
        
     if(trigger.IsDelete && trigger.IsBefore) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ps = fht.Platform_Specifics__c;
           if (ps == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Platform_Specifics__c','FAF_ID__c','Platform Specifics','DELETE');
           }
     }
     if(Trigger.isUpdate && Trigger.isAfter)
     {
           if (PlatformSpecificTriggerHelper.BulkUpdate(Trigger.New) == true)
            return; 
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ps = fht.Platform_Specifics__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean psbu = fhbu.Platform_Specifics__c;
           Boolean bulkexclude = false;
           for (Platform_Specifics__c psrecord : Trigger.new) 
            {
              if (psrecord.FAF_Data_Loading_Flag__c == true || psrecord.FAF_Copy_In_Progress__c == true || psrecord.Bulk_Update__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (ps == true && (psbu ==false ||(psbu ==true && bulkexclude == false) ))
           {
            SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Platform_Specifics__c','FAF_ID__c','Platform Specifics');
           }
     }
   }
}