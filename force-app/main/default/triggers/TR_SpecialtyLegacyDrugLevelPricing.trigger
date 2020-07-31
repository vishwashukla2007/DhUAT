/*********************************************************************************************
* @Trigger Name      : TR_SpecialtyLegacyDrugLevelPricing
* @author :   Sanket Saxena (Accenture)
* @Created date     03 08 2018
* @description:vThis trigger is to validate that the combination of year, LOB, Pharmacy Benefit, Price List Type and  Path should not be same for multiple ASP Guarantee records         
**********************************************************************************************/
trigger TR_SpecialtyLegacyDrugLevelPricing on Specialty_Legacy_Drug_Level_pricing__c (before update, before insert, before delete, after update, after insert) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName.equals(ConstantsUtil.Specialty_Legacy_Drug_Level_Pricing) && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    }
    if(isRun  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore)){
        SpecLegacyDrugLevelPricingTriggerHelper.validatePricingFieldsCombination(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
    
        if(trigger.IsBefore){
            if(trigger.IsDelete){
                SpecLegacyDrugLevelPricingTriggerHelper.validateSpciality(Trigger.old, trigger.IsDelete, trigger.IsUpdate);
            }
        }
     
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sld = fht.Specialty_Legacy_Drug_Level_pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sldbu = fhbu.Specialty_Legacy_Drug_Level_pricing__c;
           Boolean bulkexclude = false;
           for (Specialty_Legacy_Drug_Level_pricing__c sldrecord : Trigger.new)                                                                               
            {
              if (sldrecord.FAF_Data_Loading_Flag__c == true || sldrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (sld == true && (sldbu ==false ||(sldbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Specialty_Legacy_Drug_Level_pricing__c','FAF_ID__c','Specialty Legacy Drug Level Pricing','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sld = fht.Specialty_Legacy_Drug_Level_pricing__c;
           if (sld == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Specialty_Legacy_Drug_Level_pricing__c','FAF_ID__c','Specialty Legacy Drug Level Pricing','DELETE');
           }
       } 
        
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sld = fht.Specialty_Legacy_Drug_Level_pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sldbu = fhbu.Specialty_Legacy_Drug_Level_pricing__c;
           Boolean bulkexclude = false;
           for (Specialty_Legacy_Drug_Level_pricing__c sldrecord : Trigger.new) 
            {
              if (sldrecord.FAF_Data_Loading_Flag__c == true || sldrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (sld == true && (sldbu ==false ||(sldbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Specialty_Legacy_Drug_Level_pricing__c','FAF_ID__c','Specialty Legacy Drug Level Pricing');
           }
       }
    }
}