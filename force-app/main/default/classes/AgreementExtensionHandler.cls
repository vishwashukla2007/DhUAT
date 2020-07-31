public class AgreementExtensionHandler implements TriggerInterface {
    
    public static void beforeUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
        list<PBS_Agreement_Extension__c> inputObjList = (list<PBS_Agreement_Extension__c>) newRecordsMap.values();
        map<id,PBS_Agreement_Extension__c> oldinputObjMap = (map<id,PBS_Agreement_Extension__c>) oldRecordsMap;
        AgreementExtensionHelper.updateAgreementExt(inputObjList, false, true, true, false,oldinputObjMap);
    }
    public static void afterInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){
        AgreementExtensionHelper.populateAgreementSFSJunctionObject(newRecordsMap);
    }
    public static void beforeInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){
        AgreementExtensionHelper.updateAgreementExt(newRecordsList, false, true, false, true, null);
        AgreementExtensionHelper.populateAgreementExtSFSFields(newRecordsList);
    }
    public static void afterUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
        //AgreementExtensionHelper.populateAgreementSFSJunctionObject(newRecordsMap ,oldRecordsMap);
    }
}