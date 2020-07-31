/* ==================================================================================
 * @Trigger Name      : TR_ContDocLink
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 30/07/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 30/07/2018
 * @Purpose           : Trigger to limit only one record Insertion on File Object
=======================================================================================*/
trigger TR_ContDocLink on ContentDocumentLink (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Content_Document_Link' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    if(isRun){
        if(Trigger.isInsert && Trigger.isBefore){   
            ContentDocumentLinkTriggerHelper.onBeforeInsert(Trigger.new);
           // ContentDocumentLinkTriggerHelper.blockmultipleRecordInsertion(Trigger.New);
        }
    }
}