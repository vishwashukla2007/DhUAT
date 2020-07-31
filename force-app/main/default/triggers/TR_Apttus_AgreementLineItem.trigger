trigger TR_Apttus_AgreementLineItem on 
Apttus__AgreementLineItem__c (before insert,after insert,after update) {

List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
   
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Agreement_Line_Item' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
     If(trigger.isBefore && trigger.isInsert && isRun){
           AgreementLineItemHelper.FetchWizrdDesignId(Trigger.new);
     }
     If(trigger.isAfter && trigger.isInsert && isRun){
       AgreementLineItemTriggerHelperPCD.FAF_Data_Validate(Trigger.new,true);
     }

}