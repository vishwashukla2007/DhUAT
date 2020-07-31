@isTest
public class CAGTestClassRecords{

 public static User createUser(string ProfileName) {
        UserRole ur = new UserRole(Name = 'Apttus Underwriting');
        insert ur;
        User useObj = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = :ProfileName].Id,
        UserRoleId = ur.Id,
        LastName = 'last',
        Email = 'abc1@test.com',
        Username = 'abc1@test.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias1',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        Market_Segment__c = 'Anthem');
        return useObj;
    }

    //Create Account Record
    public static Account createAccount() {
        Account accObj = new Account();
        accObj.Name = 'testAccount---Anthem';
        accObj.Market_Segment__c = 'Anthem';
        accObj.iUMS_Client_Subtype__c = 'Coalition Member';
        accObj.Status__c = 'Active';
        return accObj;
    }
    
    //Create Opportunity Record 
    public static Opportunity createOpportunity(Id accId) {
        Opportunity oppObj = new Opportunity();
        oppObj.name = 'testOpp';
        oppObj.AccountId = accId;
        oppObj.CloseDate = Date.today();
        oppObj.StageName='Proposal';
        return oppObj;
    }
    
   //Create CentralHub Record 
    public static Central_Hub__c createFAF(Id acId, Id oppId, Id userId) {
        Central_Hub__c FAFObj = new Central_Hub__c();
        FAFObj.Account_Name__c = acId;
        FAFObj.Opportunity_Name__c= oppId;
        FAFObj.FAF_Status__c='Draft';
        FAFObj.LOB2__c= 'EGWP';
        FAFObj.Business_Type__c='Existing';
        FAFObj.FAF_External_ID__c ='12345';
        FAFObj.LOB_Subtype__c='Transparent';
        FAFObj.Underwriter__c= userId;
        return FAFObj;
    }


   //Create CAG Record with Type C
    public static CAG__c createCAGC(Id acId) {
        CAG__c CAGObjC = new   CAG__c();
        CAGObjC.CAG_ID__c = '12345';
        CAGObjC.Carrier_ID__c = 'CA12345';
        CAGObjC.Carrier_Name__c = 'CATESTNAME';
		CAGObjC.PBM_Level1_Account__c = acId;
		CAGObjC.PBM_Level0_Account__c = acId;
        CAGObjC.Record_Type__c = 'C';
        return CAGObjC;
    }

      //Create CAG Record with Type A
    public static CAG__c createCAGA(Id acId) {
        CAG__c CAGObjC = new   CAG__c();
        CAGObjC.CAG_ID__c = '123456';
        CAGObjC.Carrier_ID__c = 'CA12345';
        CAGObjC.Carrier_Name__c = 'CATESTNAME';
        CAGObjC.Account_ID__c = 'AC123456';
        CAGObjC.Account_Name__c = 'ACTESTNAME';
		CAGObjC.PBM_Level1_Account__c = acId;
		CAGObjC.PBM_Level0_Account__c = acId;
        CAGObjC.Record_Type__c = 'A';
        return CAGObjC;
    }

     //Create CAG Record with Type G
    public static CAG__c createCAGG(Id acId) {
        CAG__c CAGObjC = new   CAG__c();
        CAGObjC.CAG_ID__c = '1234567';
        CAGObjC.Carrier_ID__c = 'CA12345';
        CAGObjC.Carrier_Name__c = 'CATESTNAME';
        CAGObjC.Account_ID__c = 'AC123456';
        CAGObjC.Account_Name__c = 'ACTESTNAME';
        CAGObjC.Group_ID__c = 'GP1234567';
        CAGObjC.Group_Name__c = 'GPTESTNAME';
		CAGObjC.PBM_Level1_Account__c = acId;
		CAGObjC.PBM_Level0_Account__c = acId;
        CAGObjC.Record_Type__c = 'G';
        return CAGObjC;
    }
    
       //Create CAG Record with Type G
    public static CAG__c createCAGInG(Id acId) {
        CAG__c CAGObjC = new   CAG__c();
        CAGObjC.CAG_ID__c = '12345678';
        CAGObjC.Carrier_ID__c = 'CA123456';
        CAGObjC.Carrier_Name__c = 'CATESTNAME7';
        CAGObjC.Account_ID__c = 'AC1234566';
        CAGObjC.Account_Name__c = 'ACTESTNAME6';
        CAGObjC.Group_ID__c = 'GP12345678';
        CAGObjC.Group_Name__c = 'GPTESTNAMETEST';
		CAGObjC.PBM_Level1_Account__c = acId;
		CAGObjC.PBM_Level0_Account__c = acId;
        CAGObjC.Record_Type__c = 'G';
        return CAGObjC;
    }
    
    
}