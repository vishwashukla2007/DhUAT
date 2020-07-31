trigger PBMQuestAnsTrigger on PBM_Questions_Answers__c (after insert, after update, before insert, before update) {
    TriggerDispatcher.run(new PBMQuestAnsHandler(), Trigger.OperationType);
}