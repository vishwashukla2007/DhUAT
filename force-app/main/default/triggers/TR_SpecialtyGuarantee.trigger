/* ==============================================================================================================
 * @Trigger Name      : TR_SpecialtyGuarantee
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 10/08/2018
 * @Last modified by  : 
 * @Last modified date: 
 * @Purpose           : This trigger is to validate that the combination of Type, Subtype should not be same for multiple Spc Guarantee records         
==================================================================================================================*/
trigger TR_SpecialtyGuarantee on Specialty_Guarantee__c (before update, before insert, before delete, after update, after insert) {

    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) // Exclude During Copy FAF
    {
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName.equals(ConstantsUtil.Specialty_Guarantee) && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    }
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore )){
            SpecialtyGuaranteeTriggerHelper.validateTypeSubtypeCombination(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sg = fht.Specialty_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sgbu = fhbu.Specialty_Guarantee__c;
           Boolean bulkexclude = false;
           for (Specialty_Guarantee__c sgrecord : Trigger.new)                                                                               
            {
              if (sgrecord.FAF_Data_Loading_Flag__c == true || sgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (sg == true && (sgbu ==false ||(sgbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Specialty_Guarantee__c','FAF_ID__c','Specialty Guarantee','INSERT');
           }
        }
        
        if(trigger.IsDelete && trigger.IsBefore) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sg = fht.Specialty_Guarantee__c;
           if (sg == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Specialty_Guarantee__c','FAF_ID__c','Specialty Guarantee','DELETE');
           }
        } 
    
        if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean sg = fht.Specialty_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean sgbu = fhbu.Specialty_Guarantee__c;
           Boolean bulkexclude = false;
           for (Specialty_Guarantee__c sgrecord : Trigger.new) 
            {
              if (sgrecord.FAF_Data_Loading_Flag__c == true || sgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (sg == true && (sgbu ==false ||(sgbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Specialty_Guarantee__c','FAF_ID__c','Specialty Guarantee');
           }
        }
    }
}