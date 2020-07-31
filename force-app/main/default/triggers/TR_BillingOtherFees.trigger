trigger TR_BillingOtherFees on Billing_Other_Fees__c (after update, after insert,before insert,before update,before delete) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
        switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
        for (SwitchValidation__mdt sv : switchValidationList) {
            if(sv.DeveloperName == 'Billing_Other_Fees' && sv.Enable_Trigger__c){
                isRun = true;
                break;
            }
        }
    }
    
    //    if(Trigger.isUpdate && Trigger.isAfter && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
    //        SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Billing_Other_Fees__c','FAF_ID__c','Billing Other Fees');
    //    }
  if(isRun){
    if(Trigger.isBefore && Trigger.isDelete && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        BillOtherFeesTriggerHelper.checkElectionOnDelete(Trigger.Old);
    }
    
    if(((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore)) && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        BillOtherFeesTriggerHelper.validatePBMServices(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
    }
    
    //history tracking code for after Insert
    if(trigger.IsInsert && trigger.IsAfter) 
    {
        Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
        Boolean bo = fht.Billing_Other_Fees__c;
        Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
        Boolean bobu = fhbu.Billing_Other_Fees__c;
        Boolean bulkexclude = false;
        for (Billing_Other_Fees__c BillOtherObj : Trigger.new) 
        {
            if (BillOtherObj.FAF_Data_Loading_Flag__c == true || BillOtherObj.FAF_Copy_In_Progress__c == true)
            {
                bulkexclude = true;
                break;
            }
        }
        if (bo == true && (bobu ==false ||(bobu ==true && bulkexclude == false) ))
        {
            SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Billing_Other_Fees__c','FAF_ID__c','Billing Other Fees','INSERT');
        }
    }
    //history traking code for field updates
    if(Trigger.isUpdate && trigger.isAfter){
        
        Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
        Boolean bo = fht.Billing_Other_Fees__c;
        Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
        Boolean bobu = fhbu.Billing_Other_Fees__c;
        Boolean bulkexclude = false;
        for (Billing_Other_Fees__c BillOtherObj : Trigger.new) 
        {
            if (BillOtherObj.FAF_Data_Loading_Flag__c == true || BillOtherObj.FAF_Copy_In_Progress__c == true)
            {
                bulkexclude = true;
                break;
            }
        }
        
        if (bo == true && (bobu ==false ||(bobu ==true && bulkexclude == false) ))
        {
            SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Billing_Other_Fees__c','FAF_ID__c','Billing Other Fees');
        }
    }
    
    //history traking code for before delete
    if(trigger.IsDelete && trigger.IsBefore) 
    {
        Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
        Boolean bo = fht.Billing_Other_Fees__c;
        if (bo == true)
        {
            SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Billing_Other_Fees__c','FAF_ID__c','Billing Other Fees','DELETE');
        }
    }
   }
}