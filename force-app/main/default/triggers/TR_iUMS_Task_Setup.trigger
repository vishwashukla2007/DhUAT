trigger TR_iUMS_Task_Setup on iUMS_Task_Setup__c (before update, after update) {
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.iUMS_Task_Setup && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
if(isRun)
 {
     if(Trigger.isUpdate && Trigger.isAfter)
     {
        for (iums_task_setup__c c :trigger.new) {
         iUMSTaskTriggerHelper.Permissionsetaddition(c.Status__c);
         iUMSTaskTriggerHelper.Permissionsetremoval(c.Status__c);
         }
     }
  }
}