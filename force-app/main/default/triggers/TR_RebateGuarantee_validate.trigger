/*********************************************************************************************
* @Trigger Name      : TR_RebateGuarantee_validate
* @author :   Sanket Saxena (Accenture)
* @Created date     12 07 2018
* @description:This trigger is to validate that the LOB, Year and Basis combination should not be same for multiple Rebate Guarantee records         
 **********************************************************************************************/
trigger TR_RebateGuarantee_validate on Rebate_Guarantees__c (before update, before insert, before delete, after Update, after Insert) {
 List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Rebate_Guarantees && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun ){
    system.debug('==========DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER============='+DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER);
     if((trigger.IsUpdate && trigger.IsBefore  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) || (trigger.IsInsert && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)){
        RebateGuaranteeTriggerHelper.validateLobYearBasisCombination(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
     }   
     if(trigger.IsInsert && trigger.IsAfter) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean rg = fht.Rebate_Guarantees__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean rgbu = fhbu.Rebate_Guarantees__c;
           Boolean bulkexclude = false;
           for (Rebate_Guarantees__c rgrecord : Trigger.new) 
            {
              if (rgrecord.FAF_Data_Loading_Flag__c == true || rgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (rg == true && (rgbu ==false ||(rgbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Rebate_Guarantees__c','FAF_ID__c','Rebate Guarantees','INSERT');
           }
     }
        
     if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean rg = fht.Rebate_Guarantees__c;
           if (rg == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Rebate_Guarantees__c','FAF_ID__c','Rebate Guarantees','DELETE');
           }
     }
        
     if(Trigger.isUpdate && Trigger.isAfter)
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean rg = fht.Rebate_Guarantees__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean rgbu = fhbu.Rebate_Guarantees__c;
           Boolean bulkexclude = false;
           for (Rebate_Guarantees__c rgrecord : Trigger.new) 
            {
              if (rgrecord.FAF_Data_Loading_Flag__c == true || rgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (rg == true && (rgbu ==false ||(rgbu ==true && bulkexclude == false) ))
           {            
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Rebate_Guarantees__c','FAF_ID__c', 'Rebate Guarantees');
           }
     }
  }
}