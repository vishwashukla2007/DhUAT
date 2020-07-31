/* ================================================
 * @Helper Class      : MailGuaranteesTriggerHandler 
 * @author            : Kiran
 * @Purpose           : Trigger for updating SSG into brands on the go
 ===================================================
 * @Modified          : To fix SSG Exclusion List and SSG Exclusivity Period values are set to'null'  ***Sneha Inturi****
    Test_Class        : Test_MailGuaranteesTriggerHandler
================================================*/ 

trigger MailGuaranteestrigger on Mail_Guarantees__c ( after update, after delete, after insert, before delete ) 
{
    //Fetching info from MetaData
    List<SwitchValidation__mdt> switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt where DeveloperName='Mail_Guarantees' and Enable_Trigger__c=true limit 1 ];
    
    If(switchValidationList!=null && switchValidationList.size()>0){
       if (trigger.isDelete) {
          MailGuaranteesTriggerHandler.mgAfterDeleteHandler( trigger.old );
     }
    
     if(Trigger.isInsert && Trigger.isAfter)
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mg = fht.Mail_Guarantees__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean mgbu = fhbu.Mail_Guarantees__c;
           Boolean bulkexclude = false;
           for (Mail_Guarantees__c mgrecord : Trigger.new) 
            {
              if (mgrecord.FAF_Data_Loading_Flag__c == true || mgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (mg == true && (mgbu ==false ||(mgbu ==true && bulkexclude == false) ))
           {
            SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Mail_Guarantees__c','FAF_ID__c','Mail Guarantees','INSERT');
           }
      }
      
      if(trigger.IsDelete && trigger.IsBefore){
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mg = fht.Mail_Guarantees__c;
           if (mg == true)
           {
            SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Mail_Guarantees__c','FAF_ID__c','Mail Guarantees','DELETE');
           }
      }
     
     if(Trigger.isUpdate && Trigger.isAfter)
     {
           Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
           Boolean mg = fht.Mail_Guarantees__c;
           Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
           Boolean mgbu = fhbu.Mail_Guarantees__c;
           Boolean bulkexclude = false;
           for (Mail_Guarantees__c mgrecord : Trigger.new) 
            {
              if (mgrecord.FAF_Data_Loading_Flag__c == true || mgrecord.FAF_Copy_In_Progress__c == true)
              {
               bulkexclude = true;
               break;
              }
            }
           if (mg == true && (mgbu ==false ||(mgbu ==true && bulkexclude == false) ))
           {
          SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Mail_Guarantees__c','FAF_ID__c','Mail Guarantees');
           }
     }
  }
}