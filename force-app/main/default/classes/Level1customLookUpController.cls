public with sharing class Level1customLookUpController {
@AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String AccountId, String Platform) {
         system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String vAccountId = AccountId;
        String vPlatform = Platform;
        List < CAG__c > returnList = new List < CAG__c > ();
        // Remove to eliminate Account Filter
        //List < Account > AccountList = [Select Id, Client_ID__c from Account where ( Id = :AccountId)];
        //for (Account obj: AccountList) {
            //String vCarrierid = obj.Client_ID__c;
        List < CAG__c > lstOfRecords = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                         Platform_Name__c = :vPlatform AND Carrier_Id__c LIKE: searchKey 
                                        AND Status__c in('A','N') AND Record_Type__c = 'C' LIMIT 5];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
                                     //}
        // Remove to eliminate Account Filter
        //List < Account > AccountListch = [Select Id, Client_ID__c from Account where (ParentId = :AccountId or SuperClient_Account__c= :AccountId)];
        //for (Account obj: AccountListch) {
            //String vCarrierid = obj.Client_ID__c;
       /* List < CAG__c > lstOfRecordsch = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                         Platform_Name__c = :vPlatform AND Carrier_Id__c LIKE: searchKey 
                                        AND Status__c in('A','N') AND Record_Type__c = 'C'];
            for (CAG__c cagch: lstOfRecordsch) {
                     returnList.add(cagch);
                                           }
                                    // } */
                    // Fetch for Non-Validated Carriers as they will not be linked to Account - Platform ID
           List < CAG__c > lstOfnvRecords = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                         Platform_Name__c = :vPlatform AND Status__c in('A','N') 
                                        AND Record_Type__c = 'C' AND Carrier_Name__c = 'Non-Validated'
                                        AND Non_Validated_CAG__c = true AND Carrier_Id__c LIKE: searchKey LIMIT 5];
            
           for (CAG__c nvcag: lstOfnvRecords) {
                     returnList.add(nvcag);
                                           }

        return returnList;
    }
    @AuraEnabled
    public static List < CAG__c > fetchinitialCValues(String platform, String lob, String fafid, String AccountId) {
        String vplatform = platform;
        String vlob = lob;
        String vfafid = fafid;
        String vAccountid = AccountId;
        List < CAG__c > returnList = new List < CAG__c > ();
        system.debug('acc-->' + AccountId);
        List < Account > AccountListpar = [Select Id, Client_ID__c from Account where 
                                           (ParentId = :vAccountid OR Id = :vAccountid ) 
                                       ];
        for (Account obj: AccountListpar) {
            String vCarrierid = obj.Client_ID__c;
            system.debug('carr-->' + vCarrierid);
            List < CAG__c > lstOfRecords = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                        Carrier_Id__c = :vCarrierid AND Platform_Name__c = :vPlatform AND Status__c in('A','N') AND Record_Type__c = 'C' LIMIT 100];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
                                     }
        /*  List < Account > AccountList = [Select Id, Client_ID__c from Account where (Id = :vAccountid)
                                       ];
        for (Account obj: AccountList) {
            String vCarrierid = obj.Client_ID__c;
            system.debug('carr-->' + vCarrierid);
        List < CAG__c > lstOfRecordschd = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                        Carrier_Id__c = :vCarrierid AND Platform_Name__c = :vPlatform AND Status__c in('A','N') AND Record_Type__c = 'C' LIMIT 100];
            for (CAG__c cagc: lstOfRecordschd) {
                     returnList.add(cagc);
                                           }
                                     } */
                  // Fetch for Non-Validated Carriers as they will not be linked to Account - Platform ID
         List < CAG__c > lstOfnvRecords = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                        Platform_Name__c = :vPlatform AND Status__c in('A','N') 
                                        AND Record_Type__c = 'C' AND Carrier_Name__c = 'Non-Validated'
                                        AND Non_Validated_CAG__c = true];
            
           for (CAG__c nvcag: lstOfnvRecords) {
                     returnList.add(nvcag);
                                           } 
                                     
        
        return returnList;
    }
    
   public class wrapperClass {
   @AuraEnabled public Integer total {get;set;}
   @AuraEnabled public List < CAG__c > CAGS {get;set;}
 }
   @AuraEnabled
    public static wrapperClass fetchclearFilterValues(String platform, String lob, String fafid, String AccountId) {
        String vplatform = platform;
        String vlob = lob;
        String vfafid = fafid;
        String vAccountid = AccountId;
        wrapperClass wc = new wrapperClass();

        wc.total = [Select COUNT() from CAG__c where 
                                       Platform_Name__c = :vPlatform AND Status__c in('A','N') AND Record_Type__c = 'C'];

        wc.CAGS = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                       Platform_Name__c = :vPlatform AND Status__c in('A','N') AND Record_Type__c = 'C' LIMIT 100];
        
        system.debug('total' + wc.total);
        return wc;
    }  
    
   @AuraEnabled
    public static wrapperClass fetchclearFilterSearchValues(String searchkey, String platform, String lob, String fafid, String AccountId) {
        String vsearchkey = searchkey + '%';
        String vplatform = platform;
        String vlob = lob;
        String vfafid = fafid;
        wrapperClass wc = new wrapperClass();
      
          wc.total = [Select COUNT() from CAG__c where 
                                         Platform_Name__c = :vPlatform AND Status__c in('A','N')
                                        AND Record_Type__c = 'C' AND Carrier_Id__c LIKE: vsearchkey];
          wc.CAGS = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                         Platform_Name__c = :vPlatform AND Status__c in('A','N') 
                                        AND Record_Type__c = 'C' AND Carrier_Id__c LIKE: vsearchkey];

        return wc;
    }
  
  @AuraEnabled
    public static List < CAG__c > fetchsearchkeyCValues(String searchkey, String platform, String lob, String fafid, String AccountId) {
        String vsearchkey = searchkey + '%';
        String vplatform = platform;
        String vlob = lob;
        String vfafid = fafid;
        List < CAG__c > returnList = new List < CAG__c > ();
      
        // Match to FAF Account with Account Object to Derive List of associated Carrier
        
        List < Account > AccountList = [Select Id, Client_ID__c from Account where  Id = :AccountId ];
        
        //List of Associated Carrier with Accounts
        for (Account obj: AccountList) {
            String vCarrierid = obj.Client_ID__c;
          List < CAG__c > lstOfRecords = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                        Carrier_Id__c = :vCarrierid AND Platform_Name__c = :vPlatform AND Status__c in('A','N') 
                                        AND Record_Type__c = 'C' AND Carrier_Id__c LIKE: vsearchkey];
            for (CAG__c cag: lstOfRecords) {
                     returnList.add(cag);
                                           }
                                     }
        
          List < Account > AccountListch = [Select Id, Client_ID__c from Account where ParentId = :AccountId  or SuperClient_Account__c= :AccountId];
        
        //List of Associated Carrier with Accounts
        for (Account obj: AccountListch) {
            String vCarrierid = obj.Client_ID__c;
          List < CAG__c > lstOfRecordsch = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                        Carrier_Id__c = :vCarrierid AND Platform_Name__c = :vPlatform AND Status__c in('A','N')
                                        AND Record_Type__c = 'C' AND Carrier_Id__c LIKE: vsearchkey];
            for (CAG__c cagch: lstOfRecordsch) {
                     returnList.add(cagch);
                                           }
                                     }

        
            // Fetch for Non-Validated Carriers as they will not be linked to Account - Platform ID
           List < CAG__c > lstOfnvRecords = [Select id,Carrier_Id__c, Carrier_Name__c from CAG__c where 
                                         Platform_Name__c = :vPlatform AND Status__c in('A','N') 
                                        AND Record_Type__c = 'C' AND Carrier_Name__c = 'Non-Validated'
                                        AND Non_Validated_CAG__c = true AND Carrier_Id__c LIKE: vsearchkey];
            
           for (CAG__c nvcag: lstOfnvRecords) {
                     returnList.add(nvcag);
                                           }
                                     
        
        
        return returnList;
    }
    
    @AuraEnabled
    public static void UpdatePlatformSpecCarrierID(String PlatformID, String CarrierID, String PlatformName)
    {

            Platform_Specifics__c ps = [SELECT Id, Level_1_Record_ID__c  FROM Platform_Specifics__c WHERE Id = :PlatformID];
            ps.Level_1_Record_ID__c = CarrierID;
            if (Schema.sObjectType.Platform_Specifics__c.fields.Level_1_Record_ID__c.isUpdateable()) {
            update ps;
            }
    }
}