trigger pbmRequestTrigger on PBMRequest__c (before update, after update, before insert, after insert) {
     TriggerDispatcher.run(new pbmRequestHandler(), Trigger.OperationType);
}