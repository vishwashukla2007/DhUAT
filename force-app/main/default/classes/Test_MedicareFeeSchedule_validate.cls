@isTest
public with sharing class Test_MedicareFeeSchedule_validate {
    //Method 1 to pass the parameters
    @isTest
    static void MedicareFeeScheduleTestMeth1()
    {
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';     
        insert acct;
        
        Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
        insert opp;     
        
        Central_Hub__c FAFObj = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        FAFObj.Salesperson__c= null;
        FAFObj.Network_Operations__c= true;
        FAFObj.Specialty_Operations__c= true;
        FAFObj.Mail_Operations__c= true;
        insert FAFObj;
        
        Test.startTest();
        //Create Billing Operations Record 
        Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
        insert bilOpsObj;
        
        // Create Medicare part D Record
        Medicare_Part_D_Fees_Schedule__c MPDObj = TestDataFactory.createMedifeescheduled(bilOpsObj.Id,FAFObj.id);
        insert MPDObj;
        
        //Create Fee Services record
        Fee_Services__c FeeServiceObj = TestDataFactory.createFeeService(FAFObj.id);
        insert FeeServiceObj;
        
        //Create Fee Services Template record 
        Fee_Service_Template__c FeeServiceTemplateObj = TestDataFactory.createFeeServiceTemplate();
        insert FeeServiceTemplateObj;
        
        //Create Retiree Drug Subsidy record  
        Retiree_Drug_Subsidy__c RetireDrugObj = TestDataFactory.createRetireeDrug(FAFObj.id,MPDObj.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
        insert RetireDrugObj;
        
        delete MPDObj;
        Test.stopTest();
    }
}