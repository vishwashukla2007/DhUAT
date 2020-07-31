trigger NetworkPricingTrigger on Network_Pricing__c (before update, before insert,after insert, after update,before delete, after delete) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    
    if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
    //Fetching info from MetaData
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Network_Pricing' && sv.Enable_Trigger__c){    //Matching Object name and enable Trigger checkbox
            isRun = true;
            break;
        }
    }
    }
  
    if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER )
    {
    if(((trigger.IsUpdate && trigger.IsBefore ) || (trigger.IsInsert && trigger.IsBefore)) && ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK){
    
          NetworkPricingTriggerHelper.validateLobYearName(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
          NetworkPricingTriggerHelper.validateNoOfRecords(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
    }
    
     if(trigger.IsInsert && trigger.IsAfter) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean np = fht.Network_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean npbu = fhbu.Network_Pricing__c;
           Boolean bulkexclude = false;
           for (Network_Pricing__c nprecord : Trigger.new) 
            {
              if (nprecord.FAF_Data_Loading_Flag__c == true || nprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (np == true && (npbu ==false ||(npbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Network_Pricing__c','FAF_ID__c','Network Pricing','INSERT');
           }
            //added by sonal sharma
           NetworkPricingTriggerHelper.updateTpaForm(Trigger.NewMap,Trigger.OldMap,true);
     }
     if(trigger.IsDelete && trigger.IsBefore) 
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean np = fht.Network_Pricing__c;
           if (np == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Network_Pricing__c','FAF_ID__c','Network Pricing','DELETE');
           }
      }
   }
  
 if(isRun && Trigger.isAfter && Trigger.isUpdate && ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK){ // PCD Change
            NetworkPricingTriggerHelper.ProcessNetworkpricing(Trigger.OldMap,Trigger.NewMap,Trigger.New);
            
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean np = fht.Network_Pricing__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean npbu = fhbu.Network_Pricing__c;
           Boolean bulkexclude = false;
           for (Network_Pricing__c nprecord : Trigger.new) 
            {
              if (nprecord.FAF_Data_Loading_Flag__c == true || nprecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (np == true && (npbu ==false ||(npbu ==true && bulkexclude == false) ))
           {
            SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Network_Pricing__c','FAF_ID__c','Network Pricing');
           }
     }
    //added by sonal sharma  
    if(trigger.isUpdate && trigger.isAfter){
     // System.debug('is after update---');
        NetworkPricingTriggerHelper.updateTpaForm(Trigger.NewMap,Trigger.OldMap,false);
    }                        
    if(trigger.isAfter && trigger.isDelete){
        NetworkPricingTriggerHelper.updateTpaFormOnDelete(Trigger.OldMap);
    }                                       
}