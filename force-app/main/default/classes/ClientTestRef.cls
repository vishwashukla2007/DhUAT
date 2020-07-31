@isTest
public class ClientTestRef{
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
        FAFObj.LOB2__c= 'ACT';
        FAFObj.Business_Type__c='Existing';
        FAFObj.LOB_Subtype__c='Transparent';
        FAFObj.Salesperson__c= userId;
        return FAFObj;
    }
    
    //Create CentralHub Record 
    public static Central_Hub__c createFAF1(Id acId, Id oppId, Id userId) {
        Central_Hub__c FAFObj1 = new Central_Hub__c();
        FAFObj1.Account_Name__c = acId;
        FAFObj1.Opportunity_Name__c= oppId;
        FAFObj1.FAF_Status__c='Draft';
        FAFObj1.LOB2__c= 'EGWP';
        FAFObj1.Business_Type__c='Existing';
        FAFObj1.LOB_Subtype__c='Transparent';
        FAFObj1.Salesperson__c= userId;
        return FAFObj1;
    }
    
     //Create CentralHub Record 
    public static Central_Hub__c createFAF2(Id acId, Id oppId, Id userId) {
        Central_Hub__c FAFObj2 = new Central_Hub__c();
        FAFObj2.Account_Name__c = acId;
        FAFObj2.Opportunity_Name__c= oppId;
        FAFObj2.FAF_Status__c='Draft';
        FAFObj2.Business_Type__c='Existing';
        FAFObj2.LOB_Subtype__c='Transparent';
        FAFObj2.Salesperson__c= userId;
        return FAFObj2;
    }
    
     //Create Rebate Operations Record 
    public static Rebate_Operations__c createRebOps(Id FAFId) {
        Rebate_Operations__c rebOpsObj = new Rebate_Operations__c();
        rebOpsObj.FAF_ID__c = FAFId;
        rebOpsObj.Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
        rebOpsObj.Rebate_Offering_Type__c = 'Minimum Guarantee with Split of Over Performance';
        rebOpsObj.Specialty_Rebates__c = 'Pass to Client';
        rebOpsObj.Specialty_Rebate_Setup_different_than__c = false;
        rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Reinvested Rebates (GPO) w/Recon';
        rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Guarantee Only';
        rebOpsObj.Specialty_Client_Share__c =100;
        rebOpsObj.X340B__c = 'No';
        rebOpsObj.LDD__c = 'No' ;
        rebOpsObj.Percentage_Guarantee__c=true;
        return rebOpsObj;
    } 
    
     //Create Rebate Operations Record 
    public static Rebate_Operations__c createRebOps1(Id FAFId) {
        Rebate_Operations__c rebOpsObj1 = new Rebate_Operations__c();
        rebOpsObj1.FAF_ID__c = FAFId;
        rebOpsObj1.Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
        rebOpsObj1.Rebate_Offering_Type__c = 'Minimum Guarantee with Split of Over Performance';
        rebOpsObj1.Specialty_Rebates__c = 'Pass to Client';
        rebOpsObj1.Specialty_Rebate_Setup_different_than__c = false;
        rebOpsObj1.Specialty_Rebate_Contract_Type__c = 'Reinvested Rebates (GPO) w/Recon';
        rebOpsObj1.Specialty_Rebate_Offering_Type__c = 'Guarantee Only';
        rebOpsObj1.Specialty_Client_Share__c =100;
        rebOpsObj1.X340B__c = 'No';
        rebOpsObj1.LDD__c = 'No' ;
        rebOpsObj1.Percentage_Guarantee__c=true;
        return rebOpsObj1;
    } 
    
         // Create Rebate Guarantee Record
        public static Rebate_Guarantees__c createRebateGuarantee(Id FAFId,Id rebOpsObj1) {
        Rebate_Guarantees__c rebateGuarantees = new Rebate_Guarantees__c();
        rebateGuarantees.FAF_ID__c = FAFId;
        rebateGuarantees.Rebate_Operations__c = rebOpsObj1;
        rebateGuarantees.Year__c = '2';
        rebateGuarantees.Basis__c = 'All Rx';
        rebateGuarantees.LOB2__c = 'ACT';
        return rebateGuarantees;
    }
    
    
     //Create Billing Operations Record 
        public static Billing_Operations__c createBillOps(Id FAFId) {
        Billing_Operations__c billOpsObj = new Billing_Operations__c();
        billOpsObj .FAF_ID__c = FAFId;
        billOpsObj.Pharmacy_Audit_Retention__c = 'Premier (Custom)';
        billOpsObj.Billing_Admin_Payment_Terms__c = '5 Days';
        billOpsObj.Billing_Claim_Payment_Terms__c = '10 Days';
        billOpsObj.Client_Share__c = 75;
        return billOpsObj;
    }
    
    //Create User
    public static User createUser(string ProfileName) {
        User useObj = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = :ProfileName].Id,
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
    
    //Create User
    public static User createuwUser(string ProfileName) {
         UserRole ur = new UserRole(Name = 'Apttus Underwriting');
        insert ur;
        User useObj = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = :ProfileName].Id,
        LastName = 'last',
        Email = 'abc1@test.com',
        UserRoleId = ur.Id,
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
    
    
}