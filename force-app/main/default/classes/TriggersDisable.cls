Global with sharing class TriggersDisable {
    
    @InvocableMethod             
    public static void TriggersDisable () {
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
   // DeepCloneUtility.OFF_INVOCABLE_CLASS = false;                               
}
}