/* ====================================================================
 * @Trigger Name      : TR_BillBrokTPA_validate
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 12 07 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : trigger on Billing Broker TPA
========================================================================*/
trigger TR_BillBrokTPA_validate on Billing_Broker_TPA_Payments__c (before update, before insert, before delete, after update, after insert) {
 List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Billing_Broker_TPA && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    }
    if(isRun )
    {
      if((trigger.IsUpdate && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) || (trigger.IsInsert && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)){
    
        //method to validate the combination of year and LOB is unique
        billingBrokerTPATriggerHelper.validateLobYearCombinalion(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
      }
        
      if(trigger.IsInsert && trigger.IsAfter) 
      {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean bt = fht.Billing_Broker_TPA_Payments__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean btbu = fhbu.Billing_Broker_TPA_Payments__c;
           Boolean bulkexclude = false;
           for (Billing_Broker_TPA_Payments__c btrecord : Trigger.new) 
            {
              if (btrecord.FAF_Data_Loading_Flag__c == true || btrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (bt == true && (btbu ==false ||(btbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Billing_Administrative_Fees__c','FAF_ID__c','Billing Broker TPA Payments','INSERT');
           }
       }
            
       if(trigger.IsDelete && trigger.IsBefore) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean bt = fht.Billing_Broker_TPA_Payments__c;
           if (bt == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Billing_Broker_TPA_Payments__c','FAF_ID__c','Billing Broker TPA Payments','DELETE');
           }
       }
        
       if(Trigger.isUpdate && Trigger.isAfter){
             Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
             Boolean bt = fht.Billing_Broker_TPA_Payments__c;
             Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
             Boolean btbu = fhbu.Billing_Broker_TPA_Payments__c;
             Boolean bulkexclude = false;
             for (Billing_Broker_TPA_Payments__c btrecord : Trigger.new) 
             {
              if (btrecord.FAF_Data_Loading_Flag__c == true || btrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
             }
            if (bt == true && (btbu ==false ||(btbu ==true && bulkexclude == false) ))
             {
              SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Billing_Broker_TPA_Payments__c','FAF_ID__c','Billing Broker TPA Payments');
             }
        }
    }
}