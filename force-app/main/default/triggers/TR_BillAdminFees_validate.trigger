/* ================================================
 * @Trigger Name      : TR_BillAdminFees_validate
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Priyanka Goyal(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Trigger for LOB Year & Admin Fee Validation
================================================*/ 

trigger TR_BillAdminFees_validate on Billing_Administrative_Fees__c (before update, before insert, before delete, after insert, after update) {
 List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Billing_Administrative_Fees && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    }
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore ) || (trigger.IsInsert && trigger.IsBefore)){
            billingAdminFeesTriggerHelper.validateLobYearCombinalion(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        
        if((trigger.IsUpdate && trigger.IsAfter ) || (trigger.IsInsert && trigger.IsAfter)){
            billingAdminFeesTriggerHelper.updateancillaryRec(Trigger.New);
        }
    
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ba = fht.Billing_Administrative_Fees__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean babu = fhbu.Billing_Administrative_Fees__c;
           Boolean bulkexclude = false;
           for (Billing_Administrative_Fees__c barecord : Trigger.new) 
            {
              if (barecord.FAF_Data_Loading_Flag__c == true || barecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (ba == true && (babu ==false ||(babu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Billing_Administrative_Fees__c','FAF_ID__c','Billing Administrative Fees','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ba = fht.Billing_Administrative_Fees__c;
           if (ba == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Billing_Administrative_Fees__c','FAF_ID__c','Billing Administrative Fees','DELETE');
           }
       }
    
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ba = fht.Billing_Administrative_Fees__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean babu = fhbu.Billing_Administrative_Fees__c;
           Boolean bulkexclude = false;
           for (Billing_Administrative_Fees__c barecord : Trigger.new) 
            {
              if (barecord.FAF_Data_Loading_Flag__c == true || barecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (ba == true && (babu ==false ||(babu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Billing_Administrative_Fees__c','FAF_ID__c','Billing Administrative Fees');
           }
       }
   }
}