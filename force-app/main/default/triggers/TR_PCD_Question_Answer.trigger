/* ==============================================================================================================
 * @Trigger Name      : TR_PCD_Question_Answer
 * @author            : Soumendu Chowdhury
 * @created date      : 05/06/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Last modified date: 05/06/2019
 * @Purpose           : This trigger is to create Network Pricing record based on PCD Question Answer record created at Agreement Line Item
==================================================================================================================*/
trigger TR_PCD_Question_Answer on PCD_Question_Answer__c (before insert,after insert,after update) {
/*
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'PCD_Question_Answer' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }

    if(isRun){
        
        If(trigger.isinsert && trigger.isBefore){
           //PCDQuestionAnswerTriggerHandler1.FetchAgreementLineItem(Trigger.new);
        }
        
        if(trigger.isinsert && trigger.isAfter){
             //PCDQuestionAnswerTriggerHandler.FAFupdateafterinsert(Trigger.new); 
            
        }
        if(trigger.isupdate && trigger.isAfter){
            //PCDQuestionAnswerTriggerHandler.FAFupdateafterinsert(Trigger.new); 
            //PCDQuestionAnswerTriggerHandler1.PCDQuestionAnswerAgreementIdupdateafterinsert();
        }
        
    } */ 
}