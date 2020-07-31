trigger ApttusApprovalRequestTrigger on Apttus_Approval__Approval_Request__c (before insert, after insert, after update){ 
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Approval_Request' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }

    if(isRun){
    ApttusApprovalRequestTriggerHelper aarHelper = new ApttusApprovalRequestTriggerHelper();
       
    if (trigger.isBefore && trigger.isInsert) {        
        //we need to update the Related_FAF__c field with Apttus_Approval__Object_Id__c field value
        //if field Apttus_Approval__Assigned_To_Id__c is not null   
        aarHelper.RelatedFAF(trigger.new);      
    }
    
  if( (Trigger.isInsert || Trigger.ISUpdate) && Trigger.ISAfter  && !Test.isRunningTest())
      {
    //Added by Kiranmai to log transaction history

       if( UtilClass.logTransactionHistoryFlagAppReq )
       { 
           UtilClass.logTransactionHistory( JSON.serialize(trigger.newmap), JSON.serialize(trigger.oldmap), 
           'Apttus_Approval__Approval_Request__c', 'Related_FAF__c', 
            new list<string>{'Approval_Status__c', 'Apttus_Approval__DateAssigned__c ',
            'Apttus_Approval__Step_Name__c'}, trigger.isInsert ? 'insert' : 'update' );                
       }    
    }
  }
}