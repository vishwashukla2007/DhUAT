public with sharing class Level2customLookUpController {
@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String platform, String Carrier) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String vPlatform = platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        List < CAG__c > lstOfRecords = [Select id,Account_Id__c, Account_Name__c from CAG__c where 
                                        Carrier_Id__c = :Carrier AND Platform_Name__c = :platform AND Account_Id__c LIKE: searchKey 
                                        AND Status__c in('A','N') AND Record_Type__c = 'A' ];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
        return returnList;
    }
    @AuraEnabled
    public static List < CAG__c > fetchinitialCValues(String platform, String Carrier) {
        String vplatform = platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        List < CAG__c > lstOfRecords = [Select id,Account_Id__c, Account_Name__c from CAG__c where 
                                         Platform_Name__c = :platform AND Status__c in('A','N') AND Record_Type__c = 'A'
                                        AND Carrier_Id__c= :Carrier];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                              }                 
        return returnList;
    }
  @AuraEnabled
    public static List < CAG__c > fetchsearchkeyCValues(String searchkey, String platform, String Carrier) {
        String vsearchkey = searchkey + '%';
        String vplatform = platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        List < CAG__c > lstOfRecords = [Select id, Account_Id__c, Account_Name__c from CAG__c where 
                                         Platform_Name__c = :platform AND Status__c in('A','N') 
                                        AND Record_Type__c = 'A' AND Account_Id__c LIKE: vsearchkey AND  Carrier_Id__c= :Carrier];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
                                   
        return returnList;
    }
    
/* @AuraEnabled
    public static void UpdatePlatformSpecAccountID(String PlatformID, String AccountID, String PlatformName)
    {
     
            Platform_Specifics__c ps = [SELECT Id, Level_2_record_ID__c  FROM Platform_Specifics__c WHERE Id = :PlatformID];
            ps.Level_2_record_ID__c = AccountID;
            if (Schema.sObjectType.Platform_Specifics__c.fields.Level_2_record_ID__c.isUpdateable()) {
            update ps;
            }

    }*/
   
    
    
}