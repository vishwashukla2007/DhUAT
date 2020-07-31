public with sharing class AccountHelper_test_PCD {
    @AuraEnabled (cacheable=true)
    public static List<Offer__c > getAccountLocations(){
        return[SELECT Id, Name,Agreement_Name__c 
                FROM Offer__c limit 7];
    }
}