trigger MailOperationsTrigger on Mail_Operations__c(before insert, after insert, before update, after update, before delete, after delete, after undelete)
{
   List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
   {
    //Fetching info from MetaData
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Mail_Guarantees' && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
   }
    if(isRun  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
    {    
    if(Trigger.isInsert && Trigger.isAfter){
           mailOperationsTriggerHelper.updateFAFOnInsert(Trigger.new);
           mailOperationsTriggerHelper.UpdateNetworkPricing(Trigger.OldMap,Trigger.NewMap, true);
        
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mo = fht.Mail_Operations__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean mobu = fhbu.Mail_Operations__c;
           Boolean bulkexclude = false;
           for (Mail_Operations__c morecord : Trigger.new) 
            {
              if (morecord.FAF_Data_Loading_Flag__c == true || morecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (mo == true && (mobu ==false ||(mobu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Mail_Operations__c','FAF_ID__c','Mail Operations','INSERT');
           }
    }
       
    if(Trigger.isDelete && Trigger.isAfter){
        mailOperationsTriggerHelper.updateFAFOnDelete(Trigger.old);
        //added by sonal sharma
        mailOperationsTriggerHelper.updateNetworkPricingOnDelete(Trigger.old);
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        mailOperationsTriggerHelper.checkCountOnBeforeInsert(Trigger.new);

    }
           
    if(trigger.IsDelete && trigger.IsBefore) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mo = fht.Mail_Operations__c;
           if (mo == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Mail_Operations__c','FAF_ID__c','Mail Operations','DELETE');
           }
     }
   
     if(Trigger.isUpdate && Trigger.isAfter)
     {
          Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mo = fht.Mail_Operations__c;
          Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean mobu = fhbu.Mail_Operations__c;
           Boolean bulkexclude = false;
           for (Mail_Operations__c morecord : Trigger.new) 
            {
              if (morecord.FAF_Data_Loading_Flag__c == true || morecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (mo == true && (mobu ==false ||(mobu ==true && bulkexclude == false) ))
           {            
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Mail_Operations__c','FAF_ID__c','Mail Operations');
           }
           //added by sonal Sharma
           
           mailOperationsTriggerHelper.UpdateNetworkPricing(Trigger.OldMap,Trigger.NewMap,false);
      }
   }
}