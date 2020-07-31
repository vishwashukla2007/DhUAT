trigger TR_FAF_Copy_Request on FAF_Copy_Request__c (before update, after update) {
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.FAF_Copy_Request && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
if(isRun)
 {
     if(Trigger.isUpdate && Trigger.isAfter)
     {
        for (FAF_Copy_Request__c c :trigger.new) {
         FAFCopyRequestTriggerHelper.Permissionsetaddition(c.Status__c);
         FAFCopyRequestTriggerHelper.Permissionsetremoval(c.Status__c);
         }
     }
  }
}