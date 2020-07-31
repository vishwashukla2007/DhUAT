/* ================================================
 * @Trigger Name      : TR_FAFLink_validate
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Priyanka Goyal(Accenture)
 * @Last modified date: 09/10/2018
 * @Purpose           : Trigger for Updation on FAF
================================================*/
trigger TR_FAFLink_validate on FAF_Link__c (before update, before insert, after Update, after Insert, after delete, before delete) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.FAF_Link && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }

    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        if((trigger.IsUpdate && trigger.IsAfter) || (trigger.IsInsert && trigger.IsAfter)){
            FAFLinkTriggerHelper.updateUserInfoOnParent(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
            
        }
        if(trigger.IsDelete && trigger.IsAfter){
            
            FAFLinkTriggerHelper.updateUserInfoOnParentForDelete(Trigger.Old, trigger.IsDelete);
        }
    }
    if(isRun){
        if(Trigger.isInsert && Trigger.isAfter)
        {
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean fl = fht.FAF_Link__c;
               Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
               Boolean flbu = fhbu.FAF_Link__c;
               Boolean bulkexclude = false;
               for (FAF_Link__c flrecord : Trigger.new) 
                {
                  if (flrecord.FAF_Data_Loading_Flag__c == true || flrecord.FAF_Copy_In_Progress__c == true)
                  {
                   bulkexclude = true;
                   break;
                  }
                } 
                 
               if (fl == true && (flbu ==false ||(flbu ==true && bulkexclude == false) ))
               {            
                 SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'FAF_Link__c','Partial_FAF__c','FAF Link','INSERT');
               }
        }
        if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean fl = fht.FAF_Link__c;
           if (fl == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'FAF_Link__c','Partial_FAF__c','FAF Link','DELETE');
           }
        }
     }
  }