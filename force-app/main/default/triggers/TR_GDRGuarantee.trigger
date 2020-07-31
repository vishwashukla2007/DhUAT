/* ==============================================================================================================
 * @Trigger Name      : TR_GDRGuarantee
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 05/09/2018
 * @Last modified by  : Priyanka Goyal(Accenture)
 * @Last modified date: 05/09/2018
 * @Purpose           : This trigger is to validate that the Type should not be same for multiple Trend Guarantee records         
==================================================================================================================*/
trigger TR_GDRGuarantee on GDR_Guarantee__c (before update, before insert, before delete, after update, after insert) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'GDR_Guarantee' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
       }
    
    if(isRun  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) || (trigger.IsInsert && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)){
                GDRGuaranteeTriggerHelper.validateTypeCombination(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gd = fht.GDR_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean gdbu = fhbu.GDR_Guarantee__c;
           Boolean bulkexclude = false;
           for (GDR_Guarantee__c gdrecord : Trigger.new)                                                                               
            {
              if (gdrecord.FAF_Data_Loading_Flag__c == true || gdrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (gd == true && (gdbu ==false ||(gdbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'GDR_Guarantee__c','FAF_ID__c','GDR Guarantee','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gd = fht.GDR_Guarantee__c;
           if (gd == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'GDR_Guarantee__c','FAF_ID__c','GDR Guarantee','DELETE');
           }
       }
    
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean gd = fht.GDR_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean gdbu = fhbu.GDR_Guarantee__c;
           Boolean bulkexclude = false;
           for (GDR_Guarantee__c gdrecord : Trigger.new) 
            {
              if (gdrecord.FAF_Data_Loading_Flag__c == true || gdrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (gd == true && (gdbu ==false ||(gdbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'GDR_Guarantee__c','FAF_ID__c','GDR Guarantee');
           }
       }
   }     
}