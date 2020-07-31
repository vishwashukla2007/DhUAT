/* ====================================================================
 * @Trigger Name      : TR_BillOthrPay_validate 
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 12 07 2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : trigger on Billing Other Payment
========================================================================*/
trigger TR_BillOthrPay_validate on Contractual_Payments__c (after update, after insert, before delete) {
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Billing_Other_Payments && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    }
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER && !trigger.isDelete){                                                                                                                                                                                                     
        BillingOtherPaymentsTriggerHelper.validateLobYearCombinalion(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
    }
    if(isRun){
    if(trigger.IsInsert && trigger.IsAfter) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean cp = fht.Contractual_Payments__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean cpbu = fhbu.Contractual_Payments__c;
           Boolean bulkexclude = false;
           for (Contractual_Payments__c cprecord : Trigger.new)                                                                               
            {
              if (cprecord.FAF_Data_Loading_Flag__c == true || cprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (cp == true && (cpbu ==false ||(cpbu ==true && bulkexclude == false) ))
           {
            SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Contractual_Payments__c','FAF_ID__c','Contractual Payments','INSERT');
           }
     }
        
     if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean cp = fht.Contractual_Payments__c;
           if (cp == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Contractual_Payments__c','FAF_ID__c','Contractual Payments','DELETE');
           }
     }    
    
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean cp = fht.Contractual_Payments__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean cpbu = fhbu.Contractual_Payments__c;
           Boolean bulkexclude = false;
           for (Contractual_Payments__c cprecord : Trigger.new) 
            {
              if (cprecord.FAF_Data_Loading_Flag__c == true || cprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (cp == true && (cpbu ==false ||(cpbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Contractual_Payments__c','FAF_ID__c','Contractual Payments');
           }
     }
  }
}