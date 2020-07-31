/* ==============================================================================================================
 * @Trigger Name      : TR_ASPGuarantee
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 12/07/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 12/07/2018
 * @Purpose           : This trigger is to validate that the combination of LOB, Year should not be same for multiple ASP Guarantee records         
==================================================================================================================*/
trigger TR_ASPGuarantee on Gnc_Guarantee__c (before update, before insert, before delete, after update, after insert) {

    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'ASP_Guarantee' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore) || (trigger.IsInsert && trigger.IsBefore )){
        ASPGuaranteeTriggerHelper.validateLobYearCombination(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gn = fht.Gnc_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean gnbu = fhbu.Gnc_Guarantee__c;
           Boolean bulkexclude = false;
           for (Gnc_Guarantee__c gnrecord : Trigger.new)                                                                               
            {
              if (gnrecord.FAF_Data_Loading_Flag__c == true || gnrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (gn == true && (gnbu ==false ||(gnbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Gnc_Guarantee__c','FAF_ID__c','Gnc Guarantee','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gn = fht.Gnc_Guarantee__c;
           if (gn == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Gnc_Guarantee__c','FAF_ID__c','Gnc Guarantee','DELETE');
           }
       }
    
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gn = fht.Gnc_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean gnbu = fhbu.Gnc_Guarantee__c;
           Boolean bulkexclude = false;
           for (Gnc_Guarantee__c gnrecord : Trigger.new) 
            {
              if (gnrecord.FAF_Data_Loading_Flag__c == true || gnrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (gn == true && (gnbu ==false ||(gnbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Gnc_Guarantee__c','FAF_ID__c','Gnc Guarantee');
           }
       }
    }
}