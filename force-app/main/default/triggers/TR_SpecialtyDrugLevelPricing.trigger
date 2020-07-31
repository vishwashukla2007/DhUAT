/* =================================================================================
 * @Trigger Name      : TR_SpecialtyDrugLevelPricing
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 03/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 03/08/2018
 * @Purpose           : Trigger on Specialty Drug level Pricing for check Duplicacy
======================================================================================*/
trigger TR_SpecialtyDrugLevelPricing on Specialty_Drug_Level_Pricing__c (before update, before insert, before delete, after update, after insert) {
    
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName.equals(ConstantsUtil.Specialty_Drug_Level_Pricing) && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore)){
        
            //method to validate the combination of year, LOB, Pharmacy Benefit, Drug Therapy and Drug Name is unique
            if (Label.Use_Specialty_Drug_Level_Pricing_Unique_Id == 'True') 
                SpecDrugLevlPricingTriggerHelper.SetUniqueId(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
            else
                SpecDrugLevlPricingTriggerHelper.validatedupComb(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        }
        if(isRun){
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sdl = fht.Specialty_Drug_Level_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sdlbu = fhbu.Specialty_Drug_Level_Pricing__c;
           Boolean bulkexclude = false;
           for (Specialty_Drug_Level_Pricing__c sdlrecord : Trigger.new)                                                                               
            {
              if (sdlrecord.FAF_Data_Loading_Flag__c == true || sdlrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (sdl == true && (sdlbu ==false ||(sdlbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Specialty_Drug_Level_Pricing__c','FAF_ID__c','Specialty Drug Level Pricing','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sdl = fht.Specialty_Drug_Level_Pricing__c;
           if (sdl == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Specialty_Drug_Level_Pricing__c','FAF_ID__c','Specialty Drug Level Pricing','DELETE');
           }
       } 
    
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sdl = fht.Specialty_Drug_Level_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sdlbu = fhbu.Specialty_Drug_Level_Pricing__c;
           Boolean bulkexclude = false;
           for (Specialty_Drug_Level_Pricing__c sdlrecord : Trigger.new) 
            {
              if (sdlrecord.FAF_Data_Loading_Flag__c == true || sdlrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (sdl == true && (sdlbu ==false ||(sdlbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Specialty_Drug_Level_Pricing__c','FAF_ID__c','Specialty Drug Level Pricing');
           }
      }
   }
}