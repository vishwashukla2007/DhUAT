/* ==============================================================================================================
 * @Trigger Name      : TR_TrendGuarantee
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 12/07/2018
 * @Last modified by  : Sanket Saxena(Accenture)
 * @Last modified date: 12/07/2018
 * @Purpose           : This trigger is to validate that the combination of LOB, Year, Guarantee Type and Drug Type should not be same for multiple Trend Guarantee records         
==================================================================================================================*/
trigger TR_TrendGuarantee on Trend_Guarantee__c (before update, before insert, before delete, after update, after insert) {
     List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Trend_Guarantee' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsBefore  && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) || (trigger.IsInsert && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)){
                TrendGuaranteeTriggerHelper.validateLobYearCombination(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
        }
        
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean tg = fht.Trend_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean tgbu = fhbu.Trend_Guarantee__c;
           Boolean bulkexclude = false;
           for (Trend_Guarantee__c tgrecord : Trigger.new)                                                                               
            {
              if (tgrecord.FAF_Data_Loading_Flag__c == true || tgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (tg == true && (tgbu ==false ||(tgbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Trend_Guarantee__c','FAF_ID__c','Trend Guarantee','INSERT');
           }
       }
        
       if(trigger.IsDelete && trigger.IsBefore) 
       {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean tg = fht.Trend_Guarantee__c;
           if (tg == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Trend_Guarantee__c','FAF_ID__c','Trend Guarantee','DELETE');
           }
       } 
    
       if(Trigger.isUpdate && Trigger.isAfter){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean tg = fht.Trend_Guarantee__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean tgbu = fhbu.Trend_Guarantee__c;
           Boolean bulkexclude = false;
           for (Trend_Guarantee__c tgrecord : Trigger.new) 
            {
              if (tgrecord.FAF_Data_Loading_Flag__c == true || tgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (tg == true && (tgbu ==false ||(tgbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Trend_Guarantee__c','FAF_ID__c','Trend Guarantee');
           }
       }
  }
}