public with sharing class AgreementSyncErrorLWCController {
    @AuraEnabled (cacheable=true)
    public static Contract_Change_Summary__c getContractChangeSummary(Id recordId){
        return[SELECT Id, Name, Agreement_ID__c, Agreement_Extension_ID__c, FAF_ID__c
                FROM Contract_Change_Summary__c WHERE Agreement_ID__c=:recordId LIMIT 1];
    }
}