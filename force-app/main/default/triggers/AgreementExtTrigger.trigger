trigger AgreementExtTrigger on PBS_Agreement_Extension__c (before update, after update, before insert, after insert) {
    TriggerDispatcher.run(new AgreementExtensionHandler(), Trigger.OperationType);
}