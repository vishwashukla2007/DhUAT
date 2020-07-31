public class TriggerDispatcher {
    public static void run (TriggerInterface handler, System.TriggerOperation operationType){
        switch on operationType {
            when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
            when AFTER_INSERT {
                System.debug('after insert');
                handler.afterInsert(Trigger.New, Trigger.newMap);
            }
            when BEFORE_INSERT {
                
                System.debug('before insert');
                handler.beforeInsert(Trigger.New, Trigger.newMap);
            }
            when AFTER_UPDATE{
                handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
            }
        }
    }
}