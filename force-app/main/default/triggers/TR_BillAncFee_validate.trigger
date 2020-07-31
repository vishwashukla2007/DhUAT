/* ====================================================================
* @Trigger Name      : TR_BillAncFee_validate 
* @author            : Akanksha Singh(Accenture)
* @created date      : 12 07 2018
* @Last modified by  : Akanksha Singh(Accenture)
* @Last modified date: 25/07/2018
* @Purpose           : trigger on Billing Ancillary Fee
* @Modification : 11/18 - Logic to update Total Amount Fee for matching Billing Admin records inserted through XAE   
========================================================================*/
trigger TR_BillAncFee_validate on Billing_Ancillary_Fee__c (before update, before insert, after insert, after update, before delete) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
        switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
        for (SwitchValidation__mdt sv : switchValidationList) {
            if(sv.DeveloperName == ConstantsUtil.Billing_Ancillary_Fees && sv.Enable_Trigger__c){
                isRun = true;
                break;
            }
        }
    }
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
    {
        if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore)){
            BillingAncFeeTriggerHelper.validateXAE(Trigger.New, trigger.IsInsert, trigger.IsUpdate);    
            BillingAncFeeTriggerHelper.validateLobYearCombinalion(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
            BillingAncFeeTriggerHelper.validatePBMServices(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        
        if((trigger.IsUpdate && trigger.IsAfter) || (trigger.IsInsert && trigger.IsAfter)){
           // system.debug('+++ Invoking DeleteXAE'); 
            BillingAncFeeTriggerHelper.DeleteXAE(Trigger.New, trigger.IsInsert, trigger.IsUpdate);    
        }
        
        // 11/18 - Below logic to update Total Amount Fee for matching Billing Admin records (Retail, Mail, Paper) inserted through XAE   
        if(Trigger.IsInsert && Trigger.IsBefore ){   
            
            //for(Billing_Ancillary_Fee__c bafxae:Trigger.new) {
            
            BillingAncFeeTriggerHelper.BillAncillaryFeeAmountUpdateXAE(Trigger.New);
            // }
            // }
        }
        
        if(trigger.IsInsert && trigger.IsAfter) 
        {
             Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
             Boolean ba = fht.Billing_Ancillary_Fee__c;
             Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
             Boolean babu = fhbu.Billing_Ancillary_Fee__c;
             Boolean bulkexclude = false;
            for (Billing_Ancillary_Fee__c barecord : Trigger.new) 
            {
              if (barecord.FAF_Data_Loading_Flag__c == true || barecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
          if (ba == true && (babu ==false ||(babu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Billing_Ancillary_Fee__c','FAF_ID__c','Billing Ancillary Fees','INSERT');
           }
      }
        
      if(Trigger.isDelete && Trigger.isBefore){
            BillingAncFeeTriggerHelper.checkElectionOnDelete(Trigger.old);
          
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean ba = fht.Billing_Ancillary_Fee__c;
           if (ba == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Billing_Ancillary_Fee__c','FAF_ID__c','Billing Ancillary Fees','DELETE');
           }
      }
        
      if(Trigger.isUpdate && Trigger.isAfter)
      {
             Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
             Boolean ba = fht.Billing_Ancillary_Fee__c;
             Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
             Boolean babu = fhbu.Billing_Ancillary_Fee__c;
             Boolean bulkexclude = false;
             for (Billing_Ancillary_Fee__c barecord : Trigger.new) 
             {
              if (barecord.FAF_Data_Loading_Flag__c == true || barecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
             }
            if (ba == true && (babu ==false ||(babu ==true && bulkexclude == false) ))
             {
              SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Billing_Ancillary_Fee__c','FAF_ID__c','Billing Ancillary Fees');
             }
        }
     }
}