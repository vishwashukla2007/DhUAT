/* ====================================================================
 * @Trigger Name      : TR_RebtGtesSpecClass_validate
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 12 07 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Trigger on Rebate Gtess Speciality Class Carve Out
========================================================================*/

trigger TR_RebtGtesSpecClass_validate on Rebate_Gtees_Specialty_Class_Carve_Outs__c(before update, before insert, before delete, after Update, after Insert) {
 List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Rebate_Gtees_Specialty_Class_Carve_Outs && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    if(isRun ){
      if((trigger.IsUpdate && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER) || (trigger.IsInsert && trigger.IsBefore && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER)){
    
        //method used to validate thae combination of year, LOb and Drug Theraphy should be unique for one rebate operation
        RebtGtesSpecClassTriggerHelper.validateLobYearDrugTheraphyCombinalion(Trigger.New, trigger.IsInsert, trigger.IsUpdate);
      }
      if(trigger.IsInsert && trigger.IsAfter) 
      {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean rc = fht.Rebate_Gtees_Specia_Class_Carve_Outs__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean rcbu = fhbu.Rebate_Gtees_Specia_Class_Carve_Outs__c;
           Boolean bulkexclude = false;
           for (Rebate_Gtees_Specialty_Class_Carve_Outs__c rcrecord : Trigger.new) 
            {
              if (rcrecord.FAF_Data_Loading_Flag__c == true || rcrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (rc == true && (rcbu ==false ||(rcbu ==true && bulkexclude == false) ))
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Rebate_Gtees_Specialty_Class_Carve_Outs__c','FAF_ID__c','Rebate Gtees Specialty Class Carve Outs','INSERT');
           }
      }
        
      if(trigger.IsDelete && trigger.IsBefore) 
      {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean rc = fht.Rebate_Gtees_Specia_Class_Carve_Outs__c;
           if (rc == true)
           {
             SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Rebate_Gtees_Specialty_Class_Carve_Outs__c','FAF_ID__c','Rebate Gtees Specialty Class Carve Outs','DELETE');
           }
      }
      if(trigger.IsUpdate && trigger.IsAfter) {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean rc = fht.Rebate_Gtees_Specia_Class_Carve_Outs__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean rcbu = fhbu.Rebate_Gtees_Specia_Class_Carve_Outs__c;
           Boolean bulkexclude = false;
           for (Rebate_Gtees_Specialty_Class_Carve_Outs__c rcrecord : Trigger.new) 
            {
              if (rcrecord.FAF_Data_Loading_Flag__c == true || rcrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
             
           if (rc == true && (rcbu ==false ||(rcbu ==true && bulkexclude == false) ))
           {            
          SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Rebate_Gtees_Specialty_Class_Carve_Outs__c','FAF_ID__c','Rebate Gtees Specialty Class Carve Outs');
         }
     }
  }
}