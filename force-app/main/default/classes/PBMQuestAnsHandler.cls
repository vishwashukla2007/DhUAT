public class PBMQuestAnsHandler implements TriggerInterface {
    
    public static void beforeUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
  
    }
    
    public static void afterInsert (List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){
        
    }
    
    public static void afterUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
        list<PBM_Questions_Answers__c> inputObjList = (list<PBM_Questions_Answers__c>) newRecordsMap.values();
        PBMQuestAnsHelper.updateObjects(inputObjList);
    }
    public static void beforeInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){
        
    }
}