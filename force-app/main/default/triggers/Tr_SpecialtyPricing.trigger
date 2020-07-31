/* ====================================================================
 * @Trigger Name      : Tr_SpecialtyPricing
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 02/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 02/08/2018
 * @Purpose           : Trigger on Specialty Pricing
========================================================================*/
trigger Tr_SpecialtyPricing on Specialty_Pricing__c (before update, before insert, before delete, after update, after insert) {
    
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    
    //Fetching info from MetaData
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName.equals(ConstantsUtil.Specialty_Pricing) && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if(((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore )) && ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK ){
        
            //method to validate the combination of year and LOB is unique
            specialtyPricingTriggerHelper.validateLobYearCombinalion(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
            // Below method call added by Ajay.
            
        }
        if((trigger.IsUpdate && trigger.IsBefore)){
            specialtyPricingTriggerHelper.onUpdateSpecialtyPricing(Trigger.New,Trigger.oldMap,Trigger.newMap, trigger.IsDelete, trigger.IsUpdate);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(Trigger.New,trigger.IsUpdate,trigger.IsDelete,Trigger.oldMap,Trigger.old);
        }
        if(trigger.IsAfter){
            if(trigger.IsUpdate ){
                for(Specialty_Pricing__c s:Trigger.new){
                    if( (s.Pharmacy_Benefit__c!=Trigger.oldMap.get(s.id).Pharmacy_Benefit__c) || (s.Price_List__c !=Trigger.oldMap.get(s.id).Price_List__c ) ){
                            specialtyPricingTriggerHelper.PBANDPLChanged=true;
                             specialtyPricingTriggerHelper.validateSpciality(Trigger.New, trigger.IsDelete, trigger.IsUpdate,s.Pharmacy_Benefit__c+'-'+s.Price_List__c,true);
                    }
                }
               
            }
            else if(trigger.IsDelete){
              specialtyPricingTriggerHelper.PBANDPLChanged=true;
               // specialtyPricingTriggerHelper.validateSpciality(Trigger.old, trigger.IsDelete, trigger.IsUpdate,true);
            }
        }
        }
        if(isRun){
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sp = fht.Specialty_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean spbu = fhbu.Specialty_Pricing__c;
           Boolean bulkexclude = false;
           for (Specialty_Pricing__c sprecord : Trigger.new)                                                                               
            {
              if (sprecord.FAF_Data_Loading_Flag__c == true || sprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (sp == true && (spbu ==false ||(spbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Specialty_Pricing__c','FAF_ID__c','Specialty Pricing','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sp = fht.Specialty_Pricing__c;
           if (sp == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Specialty_Pricing__c','FAF_ID__c','Specialty Pricing','DELETE');
           }
       } 
    
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sp = fht.Specialty_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean spbu = fhbu.Specialty_Pricing__c;
           Boolean bulkexclude = false;
           for (Specialty_Pricing__c sprecord : Trigger.new) 
            {
              if (sprecord.FAF_Data_Loading_Flag__c == true || sprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (sp == true && (spbu ==false ||(spbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Specialty_Pricing__c','FAF_ID__c','Specialty Pricing');
           }
      }
   }
}