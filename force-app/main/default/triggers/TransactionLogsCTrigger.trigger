trigger TransactionLogsCTrigger on TransactionLogsC__c (before insert) {
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
            Boolean isRun = false;
            //Fetching info from MetaData
            switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
            for (SwitchValidation__mdt sv : switchValidationList) {
                if(sv.DeveloperName == 'TransactionLogsC' && sv.Enable_Trigger__c){
                    isRun = true;
                    break;
            }
        }
    if(isRun)
    {
  if(trigger.IsInsert && trigger.IsBefore){
      TransactionLogsCTriggerHelper.updateUserNameOnInsert(Trigger.New);
    }
  }
}