/******
Test Class: Test_FilesManagmentHelper
******/
trigger ContentVersionTrigger on ContentVersion (after insert) {
   //check trigger is enabled or not 
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'ContentVersion' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    //if enabled run loigc
    if(isRun){
        
        if(Trigger.isInsert && Trigger.isAfter)
           FilesManagmentHelper.shareCDTOUnderwriters(trigger.new);
    }
}