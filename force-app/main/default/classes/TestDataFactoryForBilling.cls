@isTest
public class TestDataFactoryForBilling {
    //Create Account Record
    public static Account createAccount() {
        Account accObj = new Account();
        accObj.Name = 'testAccount---Anthem';
        accObj.Market_Segment__c = 'Anthem';
        accObj.status__c = 'Active';
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
        FAFObj.LOB2__c = 'MAPD';
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
        FAFObj1.FAF_Status__c='Sales Approved';
        FAFObj1.LOB2__c = 'CC';
        FAFObj1.Business_Type__c='New';
        FAFObj1.LOB_Subtype__c='Transparent';
        FAFObj1.Network_Operations__c=true;
        FAFObj1.Salesperson__c= userId;
        
        return FAFObj1;
    }
     //Create CentralHub Record 
    public static Central_Hub__c createFAF2(Id acId, Id oppId, Id userId) {
        Central_Hub__c FAFObj2 = new Central_Hub__c();
        FAFObj2.Account_Name__c = acId;
        FAFObj2.Opportunity_Name__c= oppId;
        FAFObj2.FAF_Status__c='Sales Review';
        FAFObj2.LOB2__c = 'RU';
        FAFObj2.Business_Type__c='New';
        FAFObj2.LOB_Subtype__c='Transparent';
        FAFObj2.Network_Operations__c=true;
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
    
      // Create Rebate Guarantee Record
        public static Rebate_Guarantees__c createRebateGuarantee(Id FAFId,Id rebOpsObj) {
        Rebate_Guarantees__c rebateGuarantees = new Rebate_Guarantees__c();
        rebateGuarantees.FAF_ID__c = FAFId;
        rebateGuarantees.Rebate_Operations__c = rebOpsObj;
        rebateGuarantees.Year__c = '2';
        rebateGuarantees.Basis__c = 'All Rx';
        rebateGuarantees.LOB2__c = 'ACT';
        return rebateGuarantees;
    }
     /* ================================================
     * @Method Name : createGtees
     * @author : Accenture
     * @Purpose: Used to create data for Rebate_Gtees_Specialty_Class_Carve_Outs__c  object
     * @Parameters: NA
     * @return: Rebate_Gtees_Specialty_Class_Carve_Outs__c obj
     * @created date:06/11/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    public static Rebate_Gtees_Specialty_Class_Carve_Outs__c  createGtees(Id rebOpsObjID,Id FAFId) {
        Rebate_Gtees_Specialty_Class_Carve_Outs__c rgcoObj = new Rebate_Gtees_Specialty_Class_Carve_Outs__c();
        rgcoObj.Rebate_Operations__c =rebOpsObjID;
        rgcoObj.FAF_ID__c =FAFId;
        rgcoObj.Drug_Therapy_Class_2__c ='Acromegaly';
        rgcoObj.Specialty_Dollar_Amount__c=20;
        rgcoObj.Specialty_Retail_Dollar_Amt__c=20;
        rgcoObj.Specialty_Retail_Percentage_Amount__c=null;
        rgcoObj.Year__c='1';
        rgcoObj.Specialty_Percentage_Amount__c=null;
        return rgcoObj;
    }
    
    
     /* ================================================
     * @Method Name : createClientInfo
     * @author : Accenture
     * @Purpose: Used to create data for createClientInfo  object
     * @Parameters: NA
     * @return: createClientInfo object
     * @created date:06/11/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    public static Client_Information__c  createClientInfo(Id FAFId) {
        Client_Information__c clientObj = new Client_Information__c();
        clientObj.year_1__c ='1';
        clientObj.year_2__c ='2';
        clientObj.year_3__c='3';
        clientObj.year_4__c='4';
        clientObj.year_5__c='5';
        clientObj.year_5__c='5';
        clientObj.FAF_ID__c=FAFId;
        return clientObj;
    }
    
         /* ================================================
     * @Method Name : createUserWithoutSegment
     * @author : Accenture
     * @Purpose: Used to create data for User Trigger handler class
     * @Parameters: NA
     * @return: User obj
     * @created date:06/11/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
      public static User createUserWithoutSegment(string ProfileName) { User useObj = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = :ProfileName].Id,
        
        LastName = 'last',
        Email = 'abc1@test.com',
        Username = 'abc1@test.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        isActive=false,
        Title = 'title',
        Alias = 'alias1',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        Aetna_NDA__c=true,
        Market_Segment__c = 'Aetna');
        
        return useObj;
    }
    
    //Create User
    public static User createUser(string ProfileName) {
        User useObj = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = :ProfileName].Id,
        userRoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Apttus_Underwriting'].Id,
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
        //Aetna_NDA__c=true,
        Market_Segment__c = 'Anthem');
        return useObj;
    }
    
     //Create Billing Administrative Fees Record 
        public static Billing_Administrative_Fees__c createBillAdminFees(Id FAFId,Id billOpsId) {
        Billing_Administrative_Fees__c billAdmObj = new Billing_Administrative_Fees__c();
        billAdmObj .FAF_ID__c = FAFId;
        billAdmObj.Billing_Operations__c = billOpsId;
        billAdmObj.Year__c = 'All';
        billAdmObj.LOB__c = 'ACT';
        billAdmObj.Admin_Fee_Type__c = 'Mail Per Claim';
        billAdmObj.Base_Amount__c = 75;
        return billAdmObj;
    }
     //Create Broker TPA Record
        public static Broker_TPA_Name_Support__c createBrokersupport() {
        Broker_TPA_Name_Support__c  brokeTapobj = new Broker_TPA_Name_Support__c();
        brokeTapobj .Name = 'test';
        return brokeTapobj;
    }
    
    //Create Billing Broker TPA Record 
        public static Billing_Broker_TPA_Payments__c createBrokerTPA(Id FAFId,Id billOpsId, Id brokerTpaname) {
        Billing_Broker_TPA_Payments__c brokerTPA = new Billing_Broker_TPA_Payments__c();
        brokerTPA.FAF_ID__c = FAFId;
        brokerTPA.Billing_Operations__c = billOpsId;
        brokerTPA.Year__c = 'All';
        brokerTPA.LOB2__c = 'ACT';
        brokerTPA.BrokerTPA_Name__c=brokerTpaname;
        brokerTPA.Metric__c = '$';
        brokerTPA.Type__c = 'All Rx';
        brokerTPA.Pay_on__c = 'Flat';
        brokerTPA.Frequency__c = 'One Time';
        return brokerTPA;
    }
    
    // Create Billing Ancillary record
    public static Billing_Ancillary_Fee__c createBillAncillary(Id FAFId,Id billOpsId) {
        Billing_Ancillary_Fee__c billAncObj = new Billing_Ancillary_Fee__c();
        billAncObj .FAF_ID__c = FAFId;
        billAncObj.Billing_Operations__c = billOpsId;
        billAncObj.Year__c = 'All';
        billAncObj.LOB2__c = 'ACT';
        billAncObj.Ancillary_Fee_Type__c = 'Claim Fees';
        billAncObj.Ancillary_Fee_Description__c = 'Pre-Processed Direct Claims';
        billAncObj.Fee_Basis__c = 'Match Paper Per Claim Admin Fee';
        return billAncObj;
     }   
     
    // Create Billing Other Payments record
        public static Contractual_Payments__c createBillOthrPaymnts(Id FAFId,Id billOpsId, Id BillingOtherPaymentName) {
        Contractual_Payments__c billOthrPaymntObj = new Contractual_Payments__c();
        billOthrPaymntObj .FAF_ID__c = FAFId;
        billOthrPaymntObj.Billing_Operations__c = billOpsId;
        billOthrPaymntObj.Years__c = 'All';
        billOthrPaymntObj.LOB2__c = 'ACT';
        billOthrPaymntObj.Basis__c = 'Per Member';
        billOthrPaymntObj.Payment_Terms__c = 'Monthly';
        billOthrPaymntObj.Type__c = 'Coupon Allowance';
    //  billOthrPaymntObj.Frequency__c = 'Quarterly';
        billOthrPaymntObj.Amount__c = 89;
        billOthrPaymntObj.Expiration__c = Date.today();
        return billOthrPaymntObj;
    }
}