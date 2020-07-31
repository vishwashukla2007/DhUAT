/* ====================================================================
 * @Trigger Name      : TR_CentralHubShareModify
 * @author            : Accenture
 * @created date      : 12/07/2018
 * @Last modified by  : Accenture
 * @Last modified date: 12/10/2018
 * @Purpose           : trigger on Central_Hub_Share_Modify__c 
========================================================================*/
trigger TR_CentralHubShareModify on Central_Hub_Share_Modify__c (after insert) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == ConstantsUtil.Central_Hub_Share_Modify && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    if(isRun ){
        if(Trigger.isAfter && Trigger.isInsert){
            //for delete the faf share and central hub modify conditionally
            CentralHubShareModifyTriggerHelper.deleteFAFShare(trigger.new, trigger.old, trigger.NewMap, trigger.OldMap); // Deleted record which are already present in FAF share object
        }
    }
}