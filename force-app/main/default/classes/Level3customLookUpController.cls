public with sharing class Level3customLookUpController {
@AuraEnabled
    public static List < CAG__c> fetchLookUpValues(String searchKeyWord, String AccountId, String CarrierId, String Platform) {
        String searchKey = searchKeyWord + '%';
        String vPlatform = platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        List < CAG__c > lstOfRecords = [Select id,Group_Id__c, Group_Name__c from CAG__c where 
                                        Carrier_Id__c = :CarrierId AND Account_Id__c = :AccountId AND Platform_Name__c = :platform AND Group_Id__c LIKE: searchKey 
                                        AND Status__c in('A','N') AND Record_Type__c = 'G' ];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
        return returnList;
    }
    @AuraEnabled
    public static List < CAG__c > fetchinitialCValues(String AccountId, String CarrierId, String Platform) {
        String vplatform = platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        List < CAG__c > lstOfRecords = [Select id,Group_Id__c, Group_Name__c from CAG__c where 
                                        Carrier_Id__c = :CarrierId AND Account_Id__c = :AccountId AND Platform_Name__c = :platform  
                                        AND Status__c in('A','N') AND Record_Type__c = 'G' ];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                              }                 
        return returnList;
    }
  @AuraEnabled
    public static List < CAG__c > fetchsearchkeyCValues(String searchKey, String AccountId, String CarrierId, String Platform) {
        String vsearchkey = searchkey + '%';
        String vplatform = platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        List < CAG__c > lstOfRecords = [Select id,Group_Id__c, Group_Name__c from CAG__c where 
                                        Carrier_Id__c = :CarrierId AND Account_Id__c = :AccountId AND Platform_Name__c = :platform AND Group_Id__c LIKE: searchKey 
                                        AND Status__c in('A','N') AND Record_Type__c = 'G' ];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
                                   
        return returnList;
    }
    
/* @AuraEnabled   - Not in Use to update Group ID information
    public static void UpdatePlatformSpecGroupID(String PlatformID, String GroupID, String PlatformName)
    {

            Platform_Specifics__c ps = [SELECT Id, Level_3_record_ID__c  FROM Platform_Specifics__c WHERE Id = :PlatformID];
            ps.Level_3_record_ID__c = GroupID;
            if (Schema.sObjectType.Platform_Specifics__c.fields.Level_3_record_ID__c.isUpdateable()) {
            update ps;
            }
        
    } */
   
    
    
}