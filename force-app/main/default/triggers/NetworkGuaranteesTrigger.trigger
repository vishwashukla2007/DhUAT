/*************************************************************************************
    Purpose   : Trigger for updating SSG Exclusion List and SSG Exclusivity Period
    Test_Class: Test_NetworkGuaranteesTriggerHelper
**************************************************************************************/
trigger NetworkGuaranteesTrigger on Retail_Network_Guarantees__c (after insert,after update,before delete,after delete) {
    
    //Fetching info from MetaData
    List<SwitchValidation__mdt> switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt where DeveloperName='Retail_Network_Guarantees' and Enable_Trigger__c=true limit 1 ];
    
    If(switchValidationList!=null && switchValidationList.size()>0){
        if (trigger.isDelete) {
           NetworkGuaranteesTriggerHelper.resetNPSSGS(Trigger.old);
        }
        if(trigger.IsInsert && trigger.IsAfter) 
        {
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean ng = fht.Retail_Network_Guarantees__c;
               Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
               Boolean ngbu = fhbu.Retail_Network_Guarantees__c;
               Boolean bulkexclude = false;
               for (Retail_Network_Guarantees__c ngrecord : Trigger.new) 
                {
                  if (ngrecord.FAF_Data_Loading_Flag__c == true || ngrecord.FAF_Copy_In_Progress__c == true)
                  {
                   bulkexclude = true;
                   break;
                  }
                }
               if (ng == true && (ngbu ==false ||(ngbu ==true && bulkexclude == false) ))
               {
                 SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Retail_Network_Guarantees__c','FAF_ID__c','Retail Network Guarantees','INSERT');
               }
       }
       if(trigger.IsDelete && trigger.IsBefore) 
       {
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean ng = fht.Retail_Network_Guarantees__c;
               if (ng == true)
               {
                 SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.Old,Trigger.OldMap, 'Retail_Network_Guarantees__c','FAF_ID__c','Retail Network Guarantees','DELETE');
               }
       }
       if(Trigger.isUpdate && Trigger.isAfter)
       {
               Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
               Boolean ng = fht.Retail_Network_Guarantees__c;
               Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
               Boolean ngbu = fhbu.Retail_Network_Guarantees__c;
               Boolean bulkexclude = false;
               for (Retail_Network_Guarantees__c ngrecord : Trigger.new) 
                {
                  if (ngrecord.FAF_Data_Loading_Flag__c == true || ngrecord.FAF_Copy_In_Progress__c == true)
                  {
                   bulkexclude = true;
                   break;
                  }
                }
         
               if (ng == true && (ngbu ==false ||(ngbu ==true && bulkexclude == false) ))
               {
               SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap, 'Retail_Network_Guarantees__c','FAF_ID__c','Retail Network Guarantees');
               }
    	}
     }
   }