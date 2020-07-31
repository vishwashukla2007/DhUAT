trigger FAFTrigger on Central_Hub__c(before insert, after insert, before update, after update, before delete, after delete, after undelete){
    
    public static boolean BeforeUpdate = true;
    Boolean isRun = false;
    //execute only if the update is not coming from account future changes
    if(!AccountTriggerFutureHandler.ExecutingAccountFutureUpdates){ 
    
      //  if(DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER){
        List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
        switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
        for (SwitchValidation__mdt sv : switchValidationList) {
            if(sv.DeveloperName == 'FAF' && sv.Enable_Trigger__c){
                isRun = true;
                break;
            }
        } 
        
       List<Disable_Validation_AccountSubtype__c> disablevalidation  = new List<Disable_Validation_AccountSubtype__c>();
        disablevalidation = [SELECT Disable_Validation__c FROM Disable_Validation_AccountSubtype__c];
           for (Disable_Validation_AccountSubtype__c dv : disablevalidation) {
            if(dv.Disable_Validation__c==true){
                isRun = false;
                break;
            }
        }
          
        //public static boolean BeforeInsert = true; 
        //public static boolean AfterUpdate = true; 
        //public static boolean AfterInsert = true; 
        
        
       
        
       
        
        if(isRun && DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER && !Test.isRunningTest()){//&& AvoidParentTriggerExecOnChildUpdate.avoidParentTriggerExecution()
            system.debug('@@Testing Bypass@@@');
            // added condition to avoid recursive call #FAFTriggerCheckRecursive.runBeforeUpdate()
            if(Trigger.isUpdate && Trigger.isBefore && FAFTriggerCheckRecursive.runBeforeUpdate() ){
                if(BeforeUpdate){
                 if (FAFTriggerHelper.BulkUpdate(Trigger.new) == false) {
                    // W Martin. - Disabled to test Process Builder        
                    //         
                    /*   List<Central_Hub__c> fafList = new List<Central_Hub__c>();
    for(Central_Hub__c hub:Trigger.new) {
    if(!hub.BypassTrigger__c)
    fafList.add(hub);
    }*/ 

                    List<Central_Hub__c> fafList = new List<Central_Hub__c>();
                 if (FAFTriggerHelper.DisableValidations(Trigger.oldMap,Trigger.new) != true) {
                    FAFTriggerHelper.FromandTodatespopulate(Trigger.new);          
                    FAFTriggerHelper.populateMarketSegment(Trigger.new);               
                    FAFTriggerHelper.populateUnderwriterCreatedBy(Trigger.new);            
                    FAFTriggerHelper.updateOpsBeforeUpdate(Trigger.new);       
                    FAFTriggerHelper.validateLinkFAF(Trigger.new);
                    // Added by Kiranmai for Rqe BR 33, 34, 1.2.1
                    FAFTriggerHelper.validateFAFStatus(trigger.newMap, trigger.oldMap); 
                    FAFTriggerHelper.peerReviewCheck(Trigger.oldMap,Trigger.new);
                    FAFTriggerHelper.underwriterCheck(Trigger.oldMap,Trigger.new);
                    //I-9 Requirement 1.15.8
                    //FAFTriggerHelper.CrossComponentValidations(fafList); 
                   }
                   }
                    BeforeUpdate = false; 
                         
                }   
            }
            
            if(Trigger.isinsert && Trigger.isBefore && FAFTriggerCheckRecursive.runAfterUpdate() ){    
                FAFTriggerHelper.FromandTodatespopulate(Trigger.new);
                FAFTriggerHelper.populateMarketSegment(Trigger.new);
                FAFTriggerHelper.updateOpsBeforeUpdate(Trigger.new);
                FAFTriggerHelper.populateUnderwriter(Trigger.new);
                FAFTriggerHelper.underwriterCheck(Trigger.oldMap,Trigger.new);
                FAFTriggerHelper.peerReviewCheck(Trigger.oldMap,Trigger.new);        
            }
            // added condition to avoid recursive call #FAFTriggerCheckRecursive.runAfterUpdate();
            if(Trigger.IsUpdate && Trigger.IsAfter && FAFTriggerCheckRecursive.runAfterUpdate()){
                //It will validate the FAF error messages and it will populate the From and Todates
                if (FAFTriggerHelper.BulkUpdate(Trigger.new) == false) {
                FAFTriggerHelper.FAFErrorValidator(Trigger.new);
                FAFTriggerHelper.UpdateFafstatusOnClient(Trigger.new, Trigger.oldMap); 
                
                //Added by Sridevi for Req. BR 33, 34, 1.8 in I-7
                FAFTriggerAccessHelper.accountUserAccessOnFAF(Trigger.new, Trigger.oldMap); // Added by Preetham for updating the new account team user access on FAF
                FAFTriggerHelper.updateClientInfoEffectiveDate(trigger.newMap, trigger.oldMap);
                //I-9 Requirement 1.15.8
                //FAFTriggerHelper.isRunAfter=false;
                FAFTriggerHelper.CrossComponentValidations(Trigger.oldMap,Trigger.new);  
                //Added by Sai Sivamgula - Apttus IPI
                FAFTriggerHelper.updateFAFIDonIPIWAs(Trigger.new, Trigger.oldMap);
                
             }      
            }
            
            if(Trigger.IsAfter && Trigger.IsInsert){
                system.debug(' coming inside&&&& faf ');
                FAFTriggerHelper.LinkToLOB(Trigger.new);
                FAFTriggerHelper.CreateClientAndLegalInfo(Trigger.new);
                FAFTriggerAccessHelper.accountUserAccessOnFAF(Trigger.new, Trigger.oldMap);
                // Added by Preetham for creating  the new account team user access on FAF
                
            }
            
            }else if(isRun && !Test.isRunningTest()){
            if(Trigger.IsAfter && Trigger.IsInsert){
                system.debug('@@Testing Bypass@@@');
                
                FAFTriggerAccessHelper.accountUserAccessOnFAF(Trigger.new, Trigger.oldMap);
                // Added by Preetham for creating  the new FAF via copy 
            }
        }
   // }
    if(isRun){
        if( (Trigger.isInsert || Trigger.ISUpdate) && Trigger.ISAfter  && !Test.isRunningTest())
        {
            //Added by Kiranmai to log transaction history
            
            Set<ID> fafId = new Set<ID>();
                for (Central_Hub__c chrecord : Trigger.new)                                                                               
                {    
                  if (chrecord.Bulk_Update__c == false)     
                   fafId.add(chrecord.Id);                                                         
                }
                
                if( UtilClass.logTransactionHistoryFlag && !fafId.IsEmpty())
                { 
                   UtilClass.fafMap = new map<Id,AggregateResult>([SELECT Related_FAF__c Id, count(Id)  cnt
                                                                    FROM Apttus_Approval__Approval_Request__c  
                                                                    where Related_FAF__c != NULL and Related_FAF__c IN :fafId Group By Related_FAF__c  ]); 
                
                UtilClass.logTransactionHistory( JSON.serialize(trigger.newmap), JSON.serialize(trigger.oldmap), 'Central_Hub__c', 'Id', 
                                                new list<string>{'faf_status__c','Approved_By_Sales__c','Peer_Reviewed__c','Clone_Source_FAF_ID__c','FAF_Released_Date__c'}, 
                                                trigger.isInsert ? 'insert' : 'update' );                
            }
        }
        
      /*  if( isRun && Test.isRunningTest()){// added condition to cover  the method code coverage by Preetham Padala
            FAFTriggerAccessHelper.accountUserAccessOnFAF(Trigger.new, Trigger.oldMap); 
        } */
        if(Trigger.IsAfter && Trigger.IsInsert){
        //History tracking for record creation
                    Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
                       Boolean ch = fht.Central_Hub__c;
                       Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
                       Boolean chbu = fhbu.Central_Hub__c;
                       Boolean bulkexclude = false;
                       for (Central_Hub__c chrecord : Trigger.new)                                                                               
                        {
                          if (chrecord.Data_Loading__c == true || chrecord.FAF_Copy_In_Progress__c == true)
                          {
                           bulkexclude = true;
                           break;
                          }                                                       
                        }
                       if (ch == true && (chbu ==false ||(chbu ==true && bulkexclude == false) ))
                       {
                         SObjectFieldHistoryTrackingInsDelete.FieldHistoryTrackingInsDelete(Trigger.New,Trigger.OldMap, 'Central_Hub__c','Id','FAF','INSERT');
                       }
                     }
                  if(Trigger.IsUpdate && Trigger.IsAfter){   
                  if (FAFTriggerHelper.BulkUpdate(Trigger.New) == true)
                        return; 
                     Field_History_Tracking__c fht = Field_History_Tracking__c.getInstance(userinfo.getProfileId());
                       Boolean ch = fht.Central_Hub__c;
                       Field_History_Bulk_Upload_Exclude__c fhbu = Field_History_Bulk_Upload_Exclude__c.getInstance(userinfo.getProfileId());
                       Boolean chbu = fhbu.Central_Hub__c;
                       Boolean bulkexclude = false;
                       for (Central_Hub__c chrecord : Trigger.new) 
                        {
                          if (chrecord.Data_Loading__c == true || chrecord.FAF_Copy_In_Progress__c == true || chrecord.Bulk_Update__c == true)
                          {
                           bulkexclude = true;
                           break;
                          }
                        }
                         
                       if (ch == true && (chbu ==false ||(chbu ==true && bulkexclude == false) ))
                       {
                         SObjectFieldHistoryTracking.FieldHistoryTracking(Trigger.New,Trigger.OldMap,'Central_Hub__c','Id','FAF');
                       }
                    }
                    
                  }
                   
    }
 }