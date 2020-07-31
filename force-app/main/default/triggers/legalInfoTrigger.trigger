trigger legalInfoTrigger on Legal_Information__c (Before Insert, Before Update, Before Delete, After Update, After Insert) {
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Legal_Information' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    
    if(isRun){
        if(Trigger.isbefore){
            if(Trigger.isinsert && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
                legalInfoTriggerHelper.checkCountOnBeforeInsert(trigger.new);
         }        
    }
        
    if(trigger.IsInsert && trigger.IsAfter) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean lg = fht.Legal_Information__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean lgbu = fhbu.Legal_Information__c;
           Boolean bulkexclude = false;
           for (Legal_Information__c lgrecord : Trigger.new)                                                                               
            {
              if (lgrecord.FAF_Data_Loading_Flag__c == true || lgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (lg == true && (lgbu ==false ||(lgbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Legal_Information__c','FAF_ID__c','Legal Information','INSERT');
           }
    }
        
    if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean lg = fht.Legal_Information__c;
           if (lg == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Legal_Information__c','FAF_ID__c','Legal Information','DELETE');
           }
    }    
     
    if(Trigger.isUpdate && Trigger.isAfter)
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean lg = fht.Legal_Information__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean lgbu = fhbu.Legal_Information__c;
           Boolean bulkexclude = false;
           for (Legal_Information__c lgrecord : Trigger.new) 
            {
              if (lgrecord.FAF_Data_Loading_Flag__c == true || lgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (lg == true && (lgbu ==false ||(lgbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Legal_Information__c','FAF_ID__c','Legal Information');
           }
     }
   }
}