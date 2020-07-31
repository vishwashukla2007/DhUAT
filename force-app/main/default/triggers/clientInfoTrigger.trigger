trigger clientInfoTrigger on Client_Information__c (Before Insert, Before Update, Before Delete, After Update, After Insert) {
 List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Billing_Operations && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
  List<Disable_Validation_AccountSubtype__c> disablevalidation  = new List<Disable_Validation_AccountSubtype__c>();
    disablevalidation = [SELECT Disable_Validation__c FROM Disable_Validation_AccountSubtype__c];
       for (Disable_Validation_AccountSubtype__c dv : disablevalidation ) {
        if(dv.Disable_Validation__c  == true){
            isRun = false;
            break;
        }
    } 
 if(isRun){   
    if(Trigger.isbefore){
      if(Trigger.isinsert && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
         //clientInfoTriggerHelper.updateRebateBeforeInsert(trigger.new);
         clientInfoTriggerHelper.checkCountOnBeforeInsert(trigger.new);
         }
       if(Trigger.isupdate && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
         //clientInfoTriggerHelper.updateRebateBeforeInsert(trigger.new);
         
         if (clientInfoTriggerHelper.BulkUpdate(trigger.new) == false) {
         clientInfoTriggerHelper.clientInfoPricingEffectiveDateCheck(trigger.new,trigger.oldMap);
         clientInfoTriggerHelper.clientInfoContractEndDateCheck(trigger.new,trigger.oldMap);
         }  
         }
    }
    
    if(Trigger.isafter)
    { 
      if (clientInfoTriggerHelper.BulkUpdate(trigger.new) == false)
      clientInfoTriggerHelper.afterupdateclientinfo(Trigger.New);
     
    }  
    
    if(Trigger.isAfter && Trigger.isUpdate && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)
    {
        if (clientInfoTriggerHelper.BulkUpdate(trigger.new) == true)   
        return;  
        if( UtilClass.logTransactionHistoryFlag )
        {
             
            UtilClass.logTransactionHistory( JSON.serialize(trigger.newmap), JSON.serialize(trigger.oldmap), 'Client_Information__c', 'FAF_ID__c', 
                new list<string>{'Approval_Option__c'}, 'update' );
               
          }
          
        clientInfoTriggerHelper.updatePlatformSpefics  (trigger.new,trigger.oldMap);
    }
  
    if(trigger.IsInsert && trigger.IsAfter) 
    {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean cl = fht.Client_Information__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean clbu = fhbu.Client_Information__c;
           Boolean bulkexclude = false;
           for (Client_Information__c clrecord : Trigger.new)                                                                               
            {
              if (clrecord.FAF_Data_Loading_Flag__c == true || clrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }                                                       
            }
           if (cl == true && (clbu ==false ||(clbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Client_Information__c','FAF_ID__c','Client Information','INSERT');
           }
     }
        
     if(trigger.IsDelete && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean cl = fht.Client_Information__c;
           if (cl == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Client_Information__c','FAF_ID__c','Client Information','DELETE');
           }
     } 
     if(Trigger.isUpdate && Trigger.isAfter){
     
           if (clientInfoTriggerHelper.BulkUpdate(trigger.new) == true)
            return;
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean cl = fht.Client_Information__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean clbu = fhbu.Client_Information__c;
           Boolean bulkexclude = false;
           for (Client_Information__c clrecord : Trigger.new) 
            {
              if (clrecord.FAF_Data_Loading_Flag__c == true || clrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (cl == true && (clbu ==false ||(clbu ==true && bulkexclude == false) ))
           {
           SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Client_Information__c','FAF_ID__c','Client Information');
           }
     } 
   }
}