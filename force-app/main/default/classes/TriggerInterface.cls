public interface TriggerInterface {
    void beforeUpdate(Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap);
    void afterInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap);
    void afterUpdate(Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap);
    void beforeInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap);

}