trigger TR_Agreement on Apttus__APTS_Agreement__c (after insert,before update) 
{
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) 
    {
      if(sv.DeveloperName == 'Agreement' && sv.Enable_Trigger__c)
        {
                    isRun = true;
                    break;
        }
    }
    if(Trigger.isInsert && Trigger.isAfter){ 
      AgreementTriggerHelper.onAfterInsert(Trigger.new);
    }
    if((Trigger.isBefore && Trigger.isUpdate) )
    {
      AgreementTriggerHelper.CaptureSessionId(Trigger.new);
    }
 }