/* ================================================
 * @Trigger Name      : MailPricingTrigger 
 * @author            : Kiran
 * @Purpose           : Trigger for LOB Year  Validation
================================================*/ 

trigger MailPricingTrigger on Mail_Pricing__c(before update,after update, before insert,before delete, after insert) {
    
     List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    //Fetching info from MetaData
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Mail_Pricing' && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
    }
   if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
   { 
    if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore)){
      if(ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK){
        MailPricingTriggerHelper.validateLobYearName(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
         MailPricingTriggerHelper.validateNoOfRecords(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
     }
     if(trigger.IsInsert && trigger.IsAfter) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mp = fht.Mail_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean mpbu = fhbu.Mail_Pricing__c;
           Boolean bulkexclude = false;
           for (Mail_Pricing__c mprecord : Trigger.new) 
            {
              if (mprecord.FAF_Data_Loading_Flag__c == true || mprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (mp == true && (mpbu ==false ||(mpbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Mail_Pricing__c','FAF_ID__c','Mail Pricing','INSERT');
           }
     }
     if(trigger.IsDelete && trigger.IsBefore) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mp = fht.Mail_Pricing__c;
           if (mp == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Mail_Pricing__c','FAF_ID__c','Mail Pricing','DELETE');
           }
     }
   }
     if(Trigger.isUpdate && Trigger.isAfter && isRun){ // PCD Change
        MailPricingTriggerHelper.ProcessMailpricing(Trigger.OldMap,Trigger.NewMap,Trigger.New);
       
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mp = fht.Mail_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean mpbu = fhbu.Mail_Pricing__c;
           Boolean bulkexclude = false;
           for (Mail_Pricing__c mprecord : Trigger.new) 
            {
              if (mprecord.FAF_Data_Loading_Flag__c == true || mprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (mp == true && (mpbu ==false ||(mpbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Mail_Pricing__c','FAF_ID__c','Mail Pricing');
           }
     }
}