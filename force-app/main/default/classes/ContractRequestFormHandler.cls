public without sharing class ContractRequestFormHandler implements TriggerInterface {

    public static void beforeInsert (List<sObject> newRecordsList, Map<id,sObject> oldRecordsMap){
        ContractRequestFormHelper.validateContractRequestForm(newRecordsList);
    }

    //Note: Implementation class should have same method body which has been defined at interface
    public static void beforeUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
        System.debug('ContractRequestFormHandler.beforeUpdate()');
    }

    //Note: Implementation class should have same method body which has been defined at interface
    public static void afterInsert (List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){
        System.debug('ContractRequestFormHandler.afterInsert()');
    }

    //Note: Implementation class should have same method body which has been defined at interface
    public static void afterUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
        System.debug('ContractRequestFormHandler.afterUpdate()');
    }
}