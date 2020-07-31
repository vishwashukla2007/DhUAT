trigger TR_FAFInstructions on FAF_Instructions__c (after update, after insert, before delete) {
      List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
            Boolean isRun = false;
            //Fetching info from MetaData
            switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
            for (SwitchValidation__mdt sv : switchValidationList) {
                if(sv.DeveloperName == 'FAF_Instructions' && sv.Enable_Trigger__c){
                    isRun = true;
                    break;
            }
        }
    if(isRun)
    {
     if(trigger.IsInsert && trigger.IsAfter) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean fi = fht.FAF_Instructions__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean fibu = fhbu.FAF_Instructions__c;
           Boolean bulkexclude = false;
           for (FAF_Instructions__c firecord : Trigger.new)                                                                               
            {
              if (firecord.FAF_Data_Loading_Flag__c == true || firecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (fi == true && (fibu ==false ||(fibu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'FAF_Instructions__c','FAF_ID__c','FAF Instructions','INSERT');
       	   }
     }
     
     if(trigger.IsDelete && trigger.IsBefore) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean fi = fht.FAF_Instructions__c;
           if (fi == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'FAF_Instructions__c','FAF_ID__c','FAF Instructions','DELETE');
           }
     }
    
     if(Trigger.isUpdate && Trigger.isAfter)
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean fi = fht.FAF_Instructions__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean fibu = fhbu.FAF_Instructions__c;
           Boolean bulkexclude = false;
           for (FAF_Instructions__c firecord : Trigger.new) 
            {
              if (firecord.FAF_Data_Loading_Flag__c == true || firecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (fi == true && (fibu ==false ||(fibu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'FAF_Instructions__c','FAF_ID__c','FAF Instructions');
           }
      }
    }
}