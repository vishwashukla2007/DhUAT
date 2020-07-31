trigger TransactionFeeSharingTrigger on Transaction_Fee_Sharing_Tier__c ( after update, before delete, before insert, after insert) {
    
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    //Fetching info from MetaData
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Transaction_Fee_Sharing_Tier' && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
    if(isRun){
        if(trigger.IsInsert && trigger.IsAfter) 
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean tf = fht.Transaction_Fee_Sharing_Tier__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean tfbu = fhbu.Transaction_Fee_Sharing_Tier__c;
           Boolean bulkexclude = false;
           for (Transaction_Fee_Sharing_Tier__c tfrecord : Trigger.new)                                                                               
            {
              if (tfrecord.FAF_Data_Loading_Flag__c == true || tfrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (tf == true && (tfbu ==false ||(tfbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Transaction_Fee_Sharing_Tier__c','FAF_ID__c','Transaction Fee Sharing Tier','INSERT');
           }
        }
        
        if(trigger.isbefore && trigger.isdelete){
            //TransactionFeeSharingTriggerHandler.onbeforeDelete(trigger.old);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean tf = fht.Transaction_Fee_Sharing_Tier__c;
           if (tf == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Transaction_Fee_Sharing_Tier__c','FAF_ID__c','Transaction Fee Sharing Tier','DELETE');
           }
        }
        
        if(trigger.isinsert && trigger.isBefore){ 
            TransactionFeeSharingTriggerHandler.onbeforeInsert(trigger.new);
        }
        
        if(Trigger.isUpdate && Trigger.isAfter)
        {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean tf = fht.Transaction_Fee_Sharing_Tier__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean tfbu = fhbu.Transaction_Fee_Sharing_Tier__c;
           Boolean bulkexclude = false;
           for (Transaction_Fee_Sharing_Tier__c tfrecord : Trigger.new) 
            {
              if (tfrecord.FAF_Data_Loading_Flag__c == true || tfrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (tf == true && (tfbu ==false ||(tfbu ==true && bulkexclude == false) ))
              {
                SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Transaction_Fee_Sharing_Tier__c','FAF_ID__c','Transaction Fee Sharing Tier');
              }
        }
    }
}