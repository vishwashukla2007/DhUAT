trigger ContractRequestFormTrigger on Contract_Request_Form__c (before insert,before update,after update) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) 
    {
      if(sv.DeveloperName == 'Contract_Request_Form' && sv.Enable_Trigger__c)
      {
        isRun = true;
        break;
      }
    }

    if(isRun)
    {
      TriggerDispatcher.run(new ContractRequestFormHandler(), Trigger.OperationType);
    }
}