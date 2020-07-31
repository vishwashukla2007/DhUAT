/*********************************************************************************************
* @ClassName         : TestDataFactory
* @author            : Abhishek Tiwari(Accenture)
* @created date      : 18/07/2018
* @Last modified by  : 
* @Last modified date: 
* @Purpose           : This class is use to create data for Test class        
**********************************************************************************************/
@isTest
public class TestDataFactory {
    //Create Account Record
    
    public static Account createAccount() {
        Account accObj = new Account();
        accObj.Name = 'testAccount---Anthem';
        accObj.Market_Segment__c = 'Anthem';
        accObj.status__c = 'Active';
        return accObj;
    }
    
    public static Platform_Specifics__c createPlatFormSpecifics(){
        Platform_Specifics__c ps= new Platform_Specifics__c();
        
        return ps;
    }
    
    public static Platform_Specifics__c createPlatFormSpecificManagement(){
        Platform_Specifics__c newPlatformSpecific=new Platform_Specifics__c(Platform__c = 'RxCLAIM');
        
        return newPlatformSpecific;
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
    
    
    public static CAG__c createCAG(String recordTypeName, String platformName){
        CAG__c cag = new CAG__c();
        //cag.Name = 'TestCag';
        cag.CAG_ID__c = '1234567890';
        cag.Carrier_ID__c = '1234567890';
        cag.Non_Validated_CAG__c = true;
        cag.Platform_Name__c = platformName;
        cag.RecordTypeId = [select id from RecordType where Name =:recordTypeName].Id;
        
        return cag;
    }
    // Create Specialty Record
    public static Specialty_Operations__c createSpeciality(Id fafid) {
        Specialty_Operations__c specObj = new Specialty_Operations__c();
        specObj.FAF_ID__c = fafid;
        specObj.Discount_Basis__c ='ASP';
        specObj.Pharmacy_Benefit__c ='Client Choice';
        specObj.Medical_Benefit__c='Open';
        specObj.Billing_Type__c='Automatic';
        specObj.Exclude_Specialty_Class__c=true;
        specObj.Select_Specialty_Exclusion__c='Acromegaly';
        specObj.Specialty_Pricing_Additional_Information__c='test';
        return specObj;
    }
    
    // Create Specialty Legacy Drug Record
    public static Specialty_Legacy_Drug_Level_pricing__c  createSpeciality(Id fafid,Id specID) {
        Specialty_Legacy_Drug_Level_pricing__c  specLegacyobj = new Specialty_Legacy_Drug_Level_pricing__c();
        specLegacyobj.FAF_ID__c = fafid;
        specLegacyobj.Specialty_Ops__c =specID;
        specLegacyobj.year__c ='3';
        specLegacyobj.Price_List_Type__c='Custom';
        specLegacyobj.Path__c='P2';
        specLegacyobj.Pharmacy_Benefit__c='Open';
        specLegacyobj.Dispensing_Fee__c=99;
        specLegacyobj.LOB__c='ACT';
        specLegacyobj.Additional_Speciality_Operations_Inf__c='test';
        return specLegacyobj;
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
        FAFObj.Copy_Pending__c = false;
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
    
    public static Central_Hub__c createFAF3(Id acId, Id oppId, Id userId) {
        Central_Hub__c FAFObj1 = new Central_Hub__c();
        FAFObj1.Account_Name__c = acId;
        FAFObj1.Opportunity_Name__c= oppId;
        FAFObj1.FAF_Status__c='Sales Approved';
        FAFObj1.LOB2__c = 'EGFI';
        FAFObj1.Business_Type__c='New';
        FAFObj1.LOB_Subtype__c='Transparent';
        FAFObj1.Network_Operations__c=true;
        FAFObj1.Salesperson__c= userId;
        FAFObj1.Clone_Flag__c=true;
        FAFObj1.Clone_Source_FAF_ID__c='true';
        
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
        FAFObj2.Clone_Flag__c=true;
        FAFObj2.Clone_Source_FAF_ID__c='true';
        return FAFObj2;
    }
    
    //Create Rebate Operations Record 
    public static Rebate_Operations__c createRebOps(Id FAFId) {
        Rebate_Operations__c rebOpsObj = new Rebate_Operations__c();        
        rebOpsObj.FAF_ID__c = FAFId;
        rebOpsObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
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
        billOpsObj.FAF_ID__c = FAFId;
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
        rebateGuarantees.GSTP__c = 'HPGST';
        //18th March 2018   Prakarsh Jain
        //Updated Non_Specialty_Formulary_2__c field value to "Custom" to remove test class failure - W-000621
        //rebateGuarantees.Non_Specialty_Formulary_2__c = 'Custom Formulary';
        rebateGuarantees.Non_Specialty_Formulary_2__c = 'Custom';
        rebateGuarantees.Plan_Design__c = '3 Tier Q';
        rebateGuarantees.Specialty_Formulary__c = 'Custom Formulary';
        return rebateGuarantees;
    }
    
    // Create Network Operation Record
    public static Network_Operations__c createNetworkOperation(Id FAFId) {
        Network_Operations__c NetworkOps = new Network_Operations__c();
        NetworkOps.client__c = 'No MAC with U&C';
        NetworkOps.member__c = 'Lower of U&C or Copay - Standard Copay Logic On';
        NetworkOps.Retail_90_Days_Supply_84__c = true;
        NetworkOps.Days_Supply__c = 45;
        NetworkOps.FAF_ID__c = FAFId;
        return NetworkOps;
    }
    
    // Create Mail Operation Record
    public static Mail_Operations__c createMailOperation(Id FAFId) {
        Mail_Operations__c mailOps = new Mail_Operations__c();
        mailOps.Client__c = 'MAC Prevails then Discount';
        mailOps.Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off';
        mailOps.FAF_ID__c = FAFId;
        return mailOps;
    }
    
    /* ================================================
* @Method Name : createMedifeescheduled
* @author : Accenture
* @Purpose: Used to create data for Medicare_Part_D_Fees_Schedule__c  object
* @Parameters: NA
* @return: Medicare_Part_D_Fees_Schedule__c obj
* @created date:07/25/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
    public static Medicare_Part_D_Fees_Schedule__c  createMedifeescheduled(Id billingOpsObjID,Id FAFId) {
        Medicare_Part_D_Fees_Schedule__c mediObj = new Medicare_Part_D_Fees_Schedule__c();
        mediObj.Billing_Operations__c =billingOpsObjID;
        mediObj.FAF_ID__c =FAFId;
        mediObj.Year__c ='2018';
        mediObj.Type__c='EGWP';
        mediObj.PMPM_Fee__c=200;
        mediObj.Effective__c=Date.newInstance(2018,7, 1);
        mediObj.Fee_Description__c = 'TestService';
        mediObj.PATH__c='test';
        mediObj.Additional_Information__c='test';
        return mediObj;
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
* @Method Name : createRebOpsOfferIngType
* @author : Accenture
* @Purpose: Used to create data for Rebate_Operations__c object for Different picklist value
* @Parameters: NA
* @return: Rebate_Operations__c obj
* @created date:06/11/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
    public static Rebate_Operations__c createRebOpsOfferIngType(Id FAFId) {
        Rebate_Operations__c rebOpsObj = new Rebate_Operations__c();
        rebOpsObj.FAF_ID__c = FAFId;
        rebOpsObj.Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
        rebOpsObj.Rebate_Offering_Type__c = 'Split Only';
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
    
    /* ================================================
* @Method Name : createRebOpsOfferIngTypeGuaranteee
* @author : Accenture
* @Purpose: Used to create data for Rebate_Operations__c object for Different picklist value
* @Parameters: NA
* @return: Rebate_Operations__c obj
* @created date:06/11/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
    public static Rebate_Operations__c createRebOpsOfferIngTypeGuaranteee(Id FAFId) {
        Rebate_Operations__c rebOpsObj = new Rebate_Operations__c();
        rebOpsObj.FAF_ID__c = FAFId;
        rebOpsObj.Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
        rebOpsObj.Rebate_Offering_Type__c ='Minimum Guarantee with Split of Over Performance';
        rebOpsObj.Specialty_Rebates__c = 'Pass to Client';
        rebOpsObj.Specialty_Rebate_Setup_different_than__c = false;
        rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Reinvested Rebates (GPO) w/Recon';
        rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Guarantee Only';
        rebOpsObj.Specialty_Client_Share__c =100;
        rebOpsObj.X340B__c = 'No';
        rebOpsObj.LDD__c = 'No' ;
        rebOpsObj.Percentage_Guarantee__c=false;
        return rebOpsObj;
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
        clientObj.Year_1_Begin_Date__c = Date.newInstance(2018,1, 1);
        clientObj.Year_1_End_Date__c = Date.newInstance(2018,12, 31);
        clientObj.Year_2_Begin_Date__c = Date.newInstance(2019,1, 1);
        clientObj.Year_2_End_Date__c = Date.newInstance(2019,12, 31);
        clientObj.Year_3_Begin_Date__c = Date.newInstance(2020,1, 1);
        clientObj.Year_3_End_Date__c = Date.newInstance(2020,12, 31);
        clientObj.Year_4_Begin_Date__c = Date.newInstance(2021,1, 1);
        clientObj.Year_4_End_Date__c = Date.newInstance(2021,12, 31);
        clientObj.Year_5_Begin_Date__c = Date.newInstance(2022,1, 1);
        clientObj.Year_5_End_Date__c = Date.newInstance(2022,12, 31);
        clientObj.FAF_ID__c=FAFId;
        return clientObj;
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
    public static Client_Information__c  createClientInfo1(Id FAFId) {
        Client_Information__c clientObj = new Client_Information__c();
        clientObj.FAF_ID__c=FAFId;
        clientObj.Escalating_Pricing__c=false;
        return clientObj;
    }
    
    
    /* @Method Name : createRole
* @author : Accenture
* @Purpose: Used to create data for User Trigger handler class
* @Parameters: NA
* @return: UserRole obj
* @created date:30/08/2018
* @Last modified date:
* @Last modified by : Accenture
================================================*/
    public static UserRole createRole() {
        UserRole r = new UserRole(DeveloperName = 'Apttus_Underwriting', Name = 'Apttus Underwriting');
        return r;
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
            ManagerId = UserInfo.getUserId(),
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
    
    //Create Fee Services record
    public static Fee_Services__c createFeeService(Id FAFId){
        Fee_Services__c feeObj = new Fee_Services__c();
        feeObj.FAF_ID__c = FAFId;
        return feeObj;
    }
    
    //Create Fee Services Template record
    public static Fee_Service_Template__c createFeeServiceTemplate(){
        Fee_Service_Template__c feeTemplateObj = new Fee_Service_Template__c();
        feeTemplateObj.Sequence__c = 2;
        feeTemplateObj.Template_Type__c = 'RDS Services';
        feeTemplateObj.Item__c = 'Test Item';
        feeTemplateObj.FAF_Component__c = 'Billing Ops.Medicare Part D Fees Schedules';
        return feeTemplateObj;
    }
    
    //Create Retiree Drug Subsidy record
    public static Retiree_Drug_Subsidy__c createRetireeDrug(Id FAFId,Id MPFId,Id FSID,Id FSTID){
        Retiree_Drug_Subsidy__c rdsObj = new Retiree_Drug_Subsidy__c();
        rdsObj.Fee_Services__c = FSID;
        rdsObj.Election__c = true;
        rdsObj.Medicare_Part_D_Fees_Schedule__c = MPFId;
        rdsObj.Fee_Service_Template__c = FSTID;
        rdsObj.FAF_ID__c = FAFId;
        rdsObj.Service__c = 'TestService';
        rdsObj.Basis__c = 'PMPM';
        rdsObj.Basis2__c = 'PMPM';
        rdsObj.Sequence__c = 2;
        return rdsObj;
    }
    
    
    //Create PBM Services record
    public static PBM_Services__c createPBM(Id FAFId,Id FSID,Id FSTID){
        PBM_Services__c pbmServiceObj = new PBM_Services__c();
        pbmServiceObj.Fee_Services__c = FSID;
        pbmServiceObj.Election__c = true;
        pbmServiceObj.FAF_ID__c = FAFId;
        pbmServiceObj.Fee_Service_Template__c = FSTID;
        pbmServiceObj.Amount__c=100;
        pbmServiceObj.Basis2__c='Per Card';
        pbmServiceObj.Service__c='TestService';
        return pbmServiceObj;
    }
    
    // Create Billing Other Fees
    public static Billing_Other_Fees__c createBillOtherFees(Id FAFId,Id BOID,Id FSTID,Id PBMID){
        Billing_Other_Fees__c BOFObj = new Billing_Other_Fees__c();
        BOFObj.FAF__c = FAFId;
        BOFObj.Billing_Operations__c = BOID;
        BOFObj.Fee_Service_Template__c = FSTID;
        BOFObj.PBM_Services__c = PBMID;
        BOFObj.Year__c = '1';
        BOFObj.LOB__c = 'ACT';
        BOFObj.Other_Fee_Type__c = 'Enrollment Materials';
        BOFObj.Other_Fee_Description__c = 'Claims History upon Termination';
        BOFObj.Basis__c = '> 1 million members';
        return BOFObj;
    }
    
    // Create Billing Ancillary record
    public static Billing_Ancillary_Fee__c createBillAncillary(Id FAFId,Id billOpsId) {
        Billing_Ancillary_Fee__c billAncObj = new Billing_Ancillary_Fee__c();
        billAncObj .FAF_ID__c = FAFId;
        billAncObj.Billing_Operations__c = billOpsId;
        billAncObj.Year__c = 'All';
        billAncObj.LOB2__c = 'ACT';
        billAncObj.XAE__c = true;
        billAncObj.Ancillary_Fee_Type__c = 'Claim Fees';
        billAncObj.Ancillary_Fee_Description__c = 'Pre-Processed Direct Claims';
        billAncObj.Fee_Basis__c = 'Match Paper Per Claim Admin Fee';
        return billAncObj;
    }   
    
    // Create Billing Other Payments record
    public static Contractual_Payments__c createBillOthrPaymnts(Id FAFId,Id billOpsId) {
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
    
    /* ================================================
* @Method Name : createGuaranteeInfo
* @author : Accenture
* @Purpose: Used to create data for Guarantee Information  object
* @Parameters: NA
* @return: createClientInfo object
* @created date:08/02/2018
* @Last modified date:
================================================*/
    public static Guarantees_Information__c  createGuaranteeInfo(Id FAFId) {
        Guarantees_Information__c GuaranteeObj = new Guarantees_Information__c();
        GuaranteeObj.FAF_Id__c = FAFId;
        return GuaranteeObj;
    }
    
    /* ================================================
* @Method Name : createGdrGuarantee
* @author : Accenture
* @Purpose: Used to create data for GDR Guarantee Information  object
* @Parameters: NA
* @return: GDR_Guarantee__c object
* @created date:08/02/2018
* @Last modified date:
================================================*/
    public static GDR_Guarantee__c createGdrGuarantee(Id FAFId, Id GrntInfoId) {
        GDR_Guarantee__c gdrGuaranteeObj = new GDR_Guarantee__c();
        gdrGuaranteeObj.FAF_Id__c = FAFId;
        gdrGuaranteeObj.Guarantee_Information__c = GrntInfoId;
        gdrGuaranteeObj.year_1__c = 10;
        return gdrGuaranteeObj;
    }
    
    
    /* ================================================
* @Method Name : createTrendGuaranteeInfo
* @author : Accenture
* @Purpose: Used to create data for Trend Guarantee Information  object
* @Parameters: NA
* @return: createClientInfo object
* @created date:08/02/2018
* @Last modified date:
================================================*/
    public static Trend_Guarantee__c  createTrendGuaranteeInfo(Id FAFId, Id GuaranteeInfoId) {
        Trend_Guarantee__c TrendGuaranteeObj = new Trend_Guarantee__c();
        TrendGuaranteeObj.FAF_ID__c = FAFId;
        TrendGuaranteeObj.Guarantee_Information__c = GuaranteeInfoId;
        TrendGuaranteeObj.Year__c = 'All';
        TrendGuaranteeObj.Guarantee_Type__c = 'Retail';
        TrendGuaranteeObj.Drug_Type__c = 'Brand';
        TrendGuaranteeObj.Trend__c= 50;
        TrendGuaranteeObj.At_Risk_Amount__c = 100;
        return TrendGuaranteeObj;
    }
    
    /* ================================================
* @Method Name : createASPGuaranteeInfo
* @author : Accenture
* @Purpose: Used to create data for ASP Guarantee Information  object
* @Parameters: NA
* @return: createClientInfo object
* @created date:08/07/2018
================================================*/
    public static Gnc_Guarantee__c  createASPGuaranteeInfo(Id FAFId, Id GuaranteeInfoId) {
        Gnc_Guarantee__c ASPGuaranteeObj = new Gnc_Guarantee__c();
        ASPGuaranteeObj.FAF_ID__c = FAFId;
        ASPGuaranteeObj.Guarantee_Information__c = GuaranteeInfoId;
        ASPGuaranteeObj.Year__c = 'All';
        ASPGuaranteeObj.LOB__c= 'CC';
        ASPGuaranteeObj.Per_Claim__c = 100;
        return ASPGuaranteeObj;
    }
    
    public static Clinical_Solutions__c createGClinicalSolution(Id FAFId,Id clinicalOperationId) {
        Clinical_Solutions__c clinicalSolObj = new Clinical_Solutions__c();
        clinicalSolObj.Faf_ID__c = FAFId;
        clinicalSolObj.Clinical_Operations__c = clinicalOperationId;
        return clinicalSolObj;
    }
    
    public static Clinical_Operations__c createGClinicalOperaiton(Id FAFId) {
        Clinical_Operations__c clinicalOprObj = new Clinical_Operations__c();
        clinicalOprObj.Faf_ID__c = FAFId;
        clinicalOprObj.Client_Savings__c = 'Yes';
        
        return clinicalOprObj;
    }
    
    /* ================================================
* @Method Name : Speciality Pricing
* @author : Accenture
* @Purpose: Used to create data for Speciality Pricing Object
* @Parameters: NA
* @return: specialty Pricing object
* @created date:08/07/2018
================================================*/
    public static Specialty_Pricing__c createspecPricingObject(Id FAFId, Id specOpsId) {
        Specialty_Pricing__c specPricingObj = new Specialty_Pricing__c();
        specPricingObj.FAF_ID__c = FAFId;
        specPricingObj.Specialty_Operations__c = specOpsId;
        specPricingObj.Year__c = 'All';
        specPricingObj.LOB__c= 'CC';
        specPricingObj.Pharmacy_Benefit__c = 'Open';
        specPricingObj.Price_List__c = 'Standard w/o Enhancements';
        specPricingObj.Brand_Basis__c = 'Flat Discount';
        specPricingObj.Brand_Dispensing_Fee__c = 100;
        specPricingObj.Brand_Rate__c = 100;
        specPricingObj.Generic_Basis__c = 'Product Level';
        specPricingObj.Generic_Dispensing_Fee__c = 100;
        specPricingObj.Generic_Rate__c = 100;
        specPricingObj.MAC_Modeled__c = 'MAC 550';
        specPricingObj.Non_MAC_Rate__c = 100;
        specPricingObj.New_to_Market_Generic_Rate__c = 100;
        specPricingObj.Limited_Distribution_Drug_LDD_Rate__c = 100;
        specPricingObj.LDD_No_Access_Rate__c = 100;
        specPricingObj.Biosimilar_Rate__c = 100;
        specPricingObj.Method__c = 'In Aggregate';
        specPricingObj.Timeframe__c = 'Quarterly';
        specPricingObj.Level__c = 'Group';
        return specPricingObj;
    }
    
    /* ================================================
* @Method Name : Specialty Drug Level Pricing
* @author : Accenture
* @Purpose: Used to create data for Specialty Drug Level Pricing Object
* @Parameters: NA
* @return: Specialty Drug Level Pricing Object
* @created date:08/07/2018
================================================*/
    public static Specialty_Drug_Level_Pricing__c createspecDrugObject(Id FAFId, Id specOpsId) {
        Specialty_Drug_Level_Pricing__c specDrugLevelObj = new Specialty_Drug_Level_Pricing__c();
        specDrugLevelObj.FAF_ID__c = FAFId;
        specDrugLevelObj.Specialty_Operations__c = specOpsId;
        specDrugLevelObj.Year__c = 'All';
        specDrugLevelObj.LOB__c= 'CC';
        specDrugLevelObj.Pharmacy_Benefit__c = 'Open';
        specDrugLevelObj.Drug_Therapy__c = 'Anemia';
        specDrugLevelObj.Drug_Name__c = 'test';
        specDrugLevelObj.Rate__c = 100;     
        return specDrugLevelObj;
    }  
    /* ================================================
* @Method Name : createspecGuarnt
* @author : Accenture
* @Purpose: Used to create data for Specialty Guarantee Object
* @Parameters: NA
* @return: Specialty Guarantee Object
* @created date:08/07/2018
================================================*/
    public static Specialty_Guarantee__c createspecGuarnt(Id FAFId, Id specPricId) {
        Specialty_Guarantee__c specGuanteeObj = new Specialty_Guarantee__c();
        specGuanteeObj.FAF_ID__c = FAFId;
        specGuanteeObj.Specialty_Pricing__c = specPricId;
        specGuanteeObj.Type__c = 'OED';
        specGuanteeObj.Subtype__c= 'Flat';
        specGuanteeObj.Biosimilars__c = 'Yes';
        specGuanteeObj.OTC__c = 'Yes';
        return specGuanteeObj;
    } 
    
    /* ================================================
* @Method Name : createmailOperatns
* @author : Accenture
* @Purpose: Used to create data for Mail Operations Object
* @Parameters: NA
* @return: Mail Operations Object
* @created date:08/07/2018
================================================*/
    public static Mail_Operations__c createmailOperatns(Id FAFId) {
        Mail_Operations__c mailOpsObj = new Mail_Operations__c();
        mailOpsObj.Client__c = 'MAC Prevails then Discount';
        mailOpsObj.Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off';
        mailOpsObj.FAF_ID__c = FAFId;
        return mailOpsObj;
    }
    /* ================================================
* @Method Name : createmailPricing
* @author : Accenture
* @Purpose: Used to create data for Mail Pricing Object
* @Parameters: NA
* @return: Mail Pricing Object
* @created date:08/07/2018
================================================*/
    public static Mail_Pricing__c createmailPricing(Id FAFId, Id mailOpsId) {
        Mail_Pricing__c mailPricObj = new Mail_Pricing__c();
        mailPricObj.FAF_ID__c = FAFId;
        mailPricObj.FAF_Mail_Operations__c = mailOpsId;
        mailPricObj.Generic_Basis__c = 'Flat Generic Discount';
        mailPricObj.MAC_Modeled__c = 'MAC 2' ;                                                            
        return mailPricObj;
    }  
    /* ================================================
     * @Method Name : createmailGuarantee
     * @author : Accenture
     * @Purpose: Used to create data for Mail Guarantee Object
     * @Parameters: NA
     * @return: Mail Pricing Object
    * @created date:08/07/2018
    ================================================*/
    public static Mail_Guarantees__c  createmailGuarantee(Id FAFId, Id mailPricId) {
        Mail_Guarantees__c  mailGuarnObj = new Mail_Guarantees__c ();
        mailGuarnObj.FAF_ID__c = FAFId;
        mailGuarnObj.Mail_Pricing__c  = mailPricId;
        mailGuarnObj.SSG__c  = 'Flat Generic Discount';
        mailGuarnObj.Type__c  = 'MAC 2' ; 
        mailGuarnObj.Rate__c = 200; 
        return mailGuarnObj;
    }
    /* ================================================
* @Method Name : createntwrkOperatns
* @author : Accenture
* @Purpose: Used to create data for Network Operations Object
* @Parameters: NA
* @return: Network Operations Object
* @created date:08/07/2018
================================================*/
    public static Network_Operations__c createntwrkOperatns(Id FAFId) {
        Network_Operations__c ntwrkOpsObj = new Network_Operations__c();
        ntwrkOpsObj.Client__c = 'Lower of Discount or U&C or MAC';
        ntwrkOpsObj.FAF_ID__c = FAFId;
        return ntwrkOpsObj;
    }
    /* ================================================
* @Method Name : createntwrkPricing
* @author : Accenture
* @Purpose: Used to create data for Network Pricing Object
* @Parameters: NA
* @return: Mail Pricing Object
* @created date:08/07/2018
================================================*/
    public static Network_Pricing__c createntwrkPricing(Id FAFId, Id ntwrkOpsId) {
        Network_Pricing__c ntwrkPricObj = new Network_Pricing__c();
        ntwrkPricObj.FAF_ID__c = FAFId;
        ntwrkPricObj.FAF_Network_Ops__c = ntwrkOpsId;
        ntwrkPricObj.Retail_Network_Ordinal__c = 'Primary';
        ntwrkPricObj.Year__c = 'All';
        ntwrkPricObj.LOB__c = 'ACT';
        ntwrkPricObj.Network_Name__c = 'MC(84-90)CP';
        ntwrkPricObj.Brand_Rate__c = 5;  
        //  ntwrkPricObj.SSG__c = 'No';
        return ntwrkPricObj;
    }       
    /* ================================================
* @Method Name : createretntwrkGuarnt
* @author : Accenture
* @Purpose: Used to create data for Network Retail Guarantee Object
* @Parameters: NA
* @return: Network Retail Guarantee Object
* @created date:08/07/2018
================================================*/
    public static Retail_Network_Guarantees__c createretntwrkGuarnt(Id FAFId, Id ntwrkPricId) {
        Retail_Network_Guarantees__c retntwrkGuanteeObj = new Retail_Network_Guarantees__c();
        retntwrkGuanteeObj.FAF_ID__c = FAFId;
        retntwrkGuanteeObj.Network_Pricing__c  = ntwrkPricId;
        return retntwrkGuanteeObj;
    }    
    /* ================================================
* @Method Name : createspecGuarnt
* @author : Accenture
* @Purpose: Used to create data for Specialty Guarantee Object
* @Parameters: NA
* @return: Specialty Guarantee Object
* @created date:08/07/2018
================================================*/
    public static List<Specialty_Guarantee__c> listRebateGuartInsert(Id FAFId, Id specPricId1, Id specPricId2) {
        List<Specialty_Guarantee__c> specGuanteeList = new List<Specialty_Guarantee__c>();
        for(Integer i=0; i<=3; i++){
            Specialty_Guarantee__c specGuanteeObj = new Specialty_Guarantee__c();
            specGuanteeObj.FAF_ID__c = FAFId;
            specGuanteeObj.Biosimilars__c = 'Yes';
            specGuanteeObj.OTC__c = 'Yes';
            if(i==0){
                specGuanteeObj.Type__c = 'GER';
                specGuanteeObj.Subtype__c= null;
                specGuanteeObj.Specialty_Pricing__c = specPricId1;
            }else if(i==1){
                specGuanteeObj.Type__c = 'OED';
                specGuanteeObj.Subtype__c= 'Reconciled';
                specGuanteeObj.Specialty_Pricing__c = specPricId1;
            }else if(i==2){
                specGuanteeObj.Type__c = 'MER';
                specGuanteeObj.Subtype__c= null;
                specGuanteeObj.Specialty_Pricing__c = specPricId2;
            }else if(i==3){
                specGuanteeObj.Type__c = 'GER';
                specGuanteeObj.Subtype__c= null;
                specGuanteeObj.Specialty_Pricing__c = specPricId2;
            }
            specGuanteeList.add(specGuanteeObj);
        }
        system.debug('============specGuanteeList======'+specGuanteeList);
        return specGuanteeList;
    }    
    /* ================================================
* @Method Name : createPBMQuestions
* @author : John Paul Revilla
* @Purpose: used to create Test createPBMQuestions data
* @Parameters: NA
* @return: list of PBM_Questions__c 
* @created date:16/01/2020
================================================*/
    public static list<PBM_Questions__c> createPBMQuestions(){
        list<PBM_Questions__c> pbmQuestionList = New List<PBM_Questions__c>();
        PBM_Questions__c pbmQuestion = new PBM_Questions__c();
        
        pbmQuestion.Data_Type__c = 'Text';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'ERISA_NON_ERISA__c';
        pbmQuestion.Object_API__c = 'Account';
        pbmQuestion.Question__c='ERISA/NON-ERISA';
        pbmQuestion.Sort_Order__c = 1.1;
        pbmQuestion.Section_Header__c = 'Account Info.';
        pbmQuestion.Required__c = true;
        
        pbmQuestionList.add(pbmQuestion);
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Date';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Contract_End_Date__c';
        pbmQuestion.Object_API__c = 'Client_Information__c';
        pbmQuestion.Question__c='Contract End Date';
        pbmQuestion.Sort_Order__c = 4.1;
        pbmQuestion.Section_Header__c = 'Client Info.';
        
        pbmQuestionList.add(pbmQuestion);
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Number';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Client_Share__c';
        pbmQuestion.Object_API__c = 'Billing_Operations__c';
        pbmQuestion.Question__c='Client Share';
        pbmQuestion.Sort_Order__c = 2.1;
        pbmQuestion.Section_Header__c = 'Billing Operation Info.';
        
        pbmQuestionList.add(pbmQuestion);
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'iUMS_Client_Subtype__c';
        pbmQuestion.Object_API__c = 'Account';
        pbmQuestion.Question__c='iUMS Client Subtype';
        pbmQuestion.Sort_Order__c = 1;
        pbmQuestion.Section_Header__c = 'Account Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Pharmacy_Audit_Retention__c';
        pbmQuestion.Object_API__c = 'Billing_Operations__c';
        pbmQuestion.Question__c='Pharmacy Audit Retention';
        pbmQuestion.Sort_Order__c = 2.0;
        pbmQuestion.Section_Header__c = 'Billing Operation Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Text';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Client_Name__c';
        pbmQuestion.Object_API__c = 'Central_Hub__c';
        pbmQuestion.Question__c='Client Name';
        pbmQuestion.Sort_Order__c = 3.0;
        pbmQuestion.Section_Header__c = 'FAF Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Segment__c';
        pbmQuestion.Object_API__c = 'Central_Hub__c';
        pbmQuestion.Question__c='Market Segment';
        pbmQuestion.Sort_Order__c = 3.1;
        pbmQuestion.Section_Header__c = 'FAF Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Specialty_Rebates__c';
        pbmQuestion.Object_API__c = 'Rebate_Operations__c';
        pbmQuestion.Question__c='Specialty Rebate';
        pbmQuestion.Sort_Order__c = 6.1;
        pbmQuestion.Section_Header__c = 'Rebate Operations Info.';
        pbmQuestionList.add(pbmQuestion);
        
        return pbmQuestionList;
    }
    /* ================================================
* @Method Name : createAgreementData
* @author : John Paul Revilla
* @Purpose: used to create Test Agreement data
* @Parameters: NA
* @return: list of Agreement 
* @created date:21/01/2020
================================================*/
    public static list<Apttus__APTS_Agreement__c> createAgreementData(){
        Account accObj = createAccount();
        insert accObj;
        Opportunity oppObj = createOpportunity(accObj.id);
        insert oppObj;
        
        list<Apttus__APTS_Agreement__c> agreementList = new List<Apttus__APTS_Agreement__c>();
        Apttus__APTS_Agreement__c aggreement=new Apttus__APTS_Agreement__c();
        aggreement.Apttus__Account__c=accObj.id;
        aggreement.Opportunity__c=oppObj.id;
        aggreement.Apttus__Contract_Start_Date__c = system.today();
        agreementList.add(aggreement);
        
        return agreementList;
    }
    /* ================================================
* @Method Name : createiUMSTaskSetup
* @author : John Paul Revilla
* @Purpose: used to create Test iUMS Task Setup data
* @Parameters: NA
* @return: list of iUMS Task Setup 
* @created date:19/02/2020
================================================*/
    public static list<iUMS_Task_Setup__c> createiUMSTaskSetup(){
        List<iUMS_Task_Setup__c> iUmsTaskSetupList = new List<iUMS_Task_Setup__c>();
        Account accObj = createAccount();
        insert accObj;
        iUMS_Task_Setup__c iUmsTaskSetupRec = new iUMS_Task_Setup__c();
        iUmsTaskSetupRec.Task_Id__c = '1234';
        iUmsTaskSetupRec.SRX_Offer__c = 1234;
        iUmsTaskSetupRec.Account__c = accObj.Id;
        iUmsTaskSetupList.add(iUmsTaskSetupRec);
        iUmsTaskSetupRec = new iUMS_Task_Setup__c();
        iUmsTaskSetupRec.Task_Id__c = '12345';
        iUmsTaskSetupRec.SRX_Offer__c = 12345;
        iUmsTaskSetupList.add(iUmsTaskSetupRec);
        
        return iUmsTaskSetupList;
    }
    /* ================================================
* @Method Name : createContentDocumentLink
* @author : John Paul Revilla
* @Purpose: used to create Test Content Document Link data
* @Parameters: name1 = document name 1 , name2 = document name 2
* @return: map of string and Content Document Link <document name , documentlink>
* @created date:19/02/2020
================================================*/
    public static  List<ContentDocumentLink> createContentDocumentLink(string name1, string name2){
        Map<String, ContentVersion> contentVersionMap= new Map<String, ContentVersion>();
        ContentVersion content=new ContentVersion(); 
        content.Title=name1; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        contentVersionMap.put(content.Title, content);
        
        content=new ContentVersion();  
        content.Title=name2; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob1=Blob.valueOf('Unit Test Content123Version Body'); 
        content.VersionData=bodyBlob1;
        content.origin = 'H';
        contentVersionMap.put(content.Title, content);
        insert contentVersionMap.values();
        
        List<ContentDocumentLink> contentDocList = new List<ContentDocumentLink>();
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.ShareType= 'v';
        contentlink.ContentDocumentId= contentVersionMap.get(name1).id;
        contentlink.Visibility = 'AllUsers'; 
        contentDocList.add(contentlink);
        
        contentlink = new ContentDocumentLink();
        contentlink.ShareType= 'v'; 
        contentlink.ContentDocumentId= contentVersionMap.get(name2).id;
        contentlink.Visibility = 'AllUsers'; 
        contentDocList.add(contentlink);
        return contentDocList;
        
    }
    /* ================================================
* @Method Name : createAgreementExtension
* @author : Symon Bucay
* @Purpose: used to create Test Agreement Extension data
* @Parameters: NA
* @return: PBS_Agreement_Extension__c object 
* @created date:23/01/2020
================================================*/
    public static PBS_Agreement_Extension__c createAgreementExtension(Id agreementId){
        PBS_Agreement_Extension__c result = new PBS_Agreement_Extension__c();
        result.Client_Name__c='ClientTest';
        result.Agreement__c=agreementId;
        return result;
    }
    
    /* ================================================
* @Method Name : createQuestionsAnswers
* @author : Symon Bucay
* @Purpose: used to create Test Questions Answers data
* @Parameters: NA
* @return: List of PBM_Questions_Answers__c
* @created date:23/01/2020
================================================*/
    public static List<PBM_Questions_Answers__c> createQuestionsAnswers(Id agreementId){
        List<PBM_Questions_Answers__c> result = New List<PBM_Questions_Answers__c>();
        List<PBM_Questions__c> pbmQuestions = createPBMQuestions();
        insert pbmQuestions;
        for (PBM_Questions__c question : pbmQuestions) {
            result.add(New PBM_Questions_Answers__c(PBM_Question__c=question.Id, Agreement__c=agreementId));
        }
        return result;
    }
    
    /* ================================================
* @Method Name : createDeepCloneCustSettng
* @author : Accenture
* @Purpose: Used to create deep Clone Custom Setting
* @Parameters: NA
* @return: FAFDeepClone custom Setting
* @created date:29/08/2018
================================================*/
    public static List<FAFDeepClone__c> createDeepCloneCustSettng() {
        List<FAFDeepClone__c> fafDeepCloneList = new List<FAFDeepClone__c>();
        
        FAFDeepClone__c fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Pricing_Effective_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClientInfoPricingEffective';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Pricing_Effective_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClientInforebateEffectiveDateN';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'RebateSourceOps';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Rebate_Operations__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'MailpricingSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Mail_Pricing__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'MailOpsSourceiD';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Mail_Operations__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'NetworkOpsSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Network_Operations__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Contract_Effective_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClientInfoContractEffectiveDate';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Contract_End_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClientInfoContractEndDate';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Rebate_Effective_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClientInforebateEffective Date';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'BillingOpsSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Billing_Operations__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'LegalsourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Legal_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'NetworkPricingSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Network_Pricing__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'TransactionfeesharingsourceiD';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Transaction_Fee_Sharing_Tier__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'NetworkGuranteeSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Retail_Network_Guarantees__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'SpecialityDrugLevelPricingSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Specialty_Drug_Level_Pricing__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ReabteGteesSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Rebate_Gtees_Specialty_Class_Carve_Outs__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'GuranteeSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Guarantees_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'RebateGuaranteeSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Rebate_Guarantees__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClinicalSolutionSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Clinical_Solutions__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'TrendSourceRecordID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Trend_Guarantee__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'BillingAdminFeeSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Billing_Administrative_Fees__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'BillingBrrokerRecordId';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Billing_Broker_TPA_Payments__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'PlatformSpecificSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Platform_Specifics__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'AspSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Gnc_Guarantee__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'SpecialPricingSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Specialty_Pricing__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'SpecialityGuranteeSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Specialty_Guarantee__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'SpecialityLegacyDrugSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Specialty_Legacy_Drug_Level_pricing__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'GDRSourceRecordID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'GDR_Guarantee__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAFINstructionSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'FAF_Instructions__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'SpecialitySourceRecordID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Specialty_Operations__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'BillingAncillarySourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Billing_Ancillary_Fee__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClinicalSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Clinical_Operations__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'MedicareSourceId';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Medicare_Part_D_Fees_Schedule__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAFSourceID';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'FAF_Link__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Source_Record_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'ClientInforebateEffective';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Peer_Reviewed_By__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Peer Reviewed by';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Manual_Task_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF MANUAL TASK ID';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Approved_On__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Approved On N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Peer_Reviewed_By__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Peer Approved By N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Manual_Task_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF MANUAL TASK ID N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Peer_Reviewer__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Peer Review N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Manual_Offer_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF MANUAL OFFER ID';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Manual_LOB_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF MAUAL LOB';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Peer_Reviewer__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Peer Review';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Manual_Offer_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF MANUAL OFFER ID N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Manual_LOB_ID__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF MAUAL LOB N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'FAF_Close_On_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF close on Date N';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Pricing_Effective_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'Client INFO';
        fafDeepCloneObj.Selection__c = FALSE;
        fafDeepCloneObj.sObjectType__c = 'Client_Information__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'FAF_Close_On_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Close On';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Sales_Approver__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Sales Person';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Approved_On__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Approved On';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Effective_Date__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'BillingBrokerTpaEffectiveDate';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Billing_Broker_TPA_Payments__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        fafDeepCloneObj = new FAFDeepClone__c();
        fafDeepCloneObj.FieldName__c = 'Segment__c';
        fafDeepCloneObj.Field_Value__c = Null;
        fafDeepCloneObj.Name = 'FAF Market Segment';
        fafDeepCloneObj.Selection__c = TRUE;
        fafDeepCloneObj.sObjectType__c = 'Central_Hub__c';
        fafDeepCloneList.add(fafDeepCloneObj);
        
        return fafDeepCloneList;
    } 
    /* ================================================
     * @Method Name : createRebateDenorm
     * @author : Mohit Srivastava
     * @Purpose: Used to create data for Rebate RebateDenorm Object
     * @Parameters: NA
     * @return: Rebate Denorm Object
    * @created date:05/01/2020
    ================================================*/
    public static Rebate_Guarantee_Denorm__c  createRebateDenorm(Id FAFId) {
        Rebate_Guarantee_Denorm__c  Denorm = new Rebate_Guarantee_Denorm__c ();
        Denorm.FAF__c = FAFId;
        Denorm.LOB__c  = 'STD';
        //Denorm.Basis__c  = 'Flat Generic Discount';
        Denorm.GSTP__c  = 'HPGST' ; 
        Denorm.Plan_Design__c ='2 Tier Q'; 
        Denorm.Non_Specialty_Formulary__c  ='Med D 6-Tier Standard';
        Denorm.Non_Specialty_Grid__c=true; 
        Denorm.Specialty_Formulary__c='Advanced Control Specialty Formulary'; 
        Denorm.Non_Specialty_Formulary__c='Med D 6-Tier Standard';
        Denorm.SORT__c=4.0; 
        Denorm.RETAIL_Y1__c=1; 
        Denorm.RETAIL_Y2__c=1; 
        Denorm.RETAIL_Y3__c=1; 
        Denorm.RETAIL_Y4__c=1; 
        Denorm.RETAIL_Y5__c=1; 
        Denorm.RETAIL_Y6__c=1;
        Denorm.RETAIL30_Y1__c=1; 
        Denorm.RETAIL30_Y2__c=1; 
        Denorm.RETAIL30_Y3__c=1; 
        Denorm.RETAIL30_Y4__c=1; 
        Denorm.RETAIL30_Y5__c=1; 
        Denorm.RETAIL30_Y6__c=1; 
        Denorm.RETAIL90_Y1__c=1; 
        Denorm.RETAIL90_Y2__c=1; 
        Denorm.RETAIL90_Y3__c=1; 
        Denorm.RETAIL90_Y4__c=1; 
        Denorm.Specialty_Grid__c=true;
        Denorm.SPECIALTY_RETAIL_Y1__c=1;
        Denorm.SPECIALTY_RETAIL_Y2__c=1;
        return Denorm;
    }   
    
}