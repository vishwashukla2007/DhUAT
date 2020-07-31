Global with sharing class TriggersEnable {
    
    @InvocableMethod             
    public static void TriggersEnable () {
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=true;
   // DeepCloneUtility.OFF_INVOCABLE_CLASS = true;                               
}
}