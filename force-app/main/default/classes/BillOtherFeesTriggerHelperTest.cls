@isTest
public class BillOtherFeesTriggerHelperTest {
    @isTest 
    static void BillingOperationsTestmethoud1() {
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';     
        insert acct;
        
        Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
        insert opp;     
        
        Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        faf1.Salesperson__c= null;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.Mail_Operations__c= true;
        insert faf1;
        
        Test.startTest();
        Billing_Operations__c bo = new Billing_Operations__c();
        bo.FAF_ID__c = faf1.id;
        bo.Billing_Admin_Payment_Terms__c='2 Days (Preferred)';
        bo.Billing_Claim_Payment_Terms__c='2 Days (Preferred)';
        insert bo;
        
        // Create Medicare part D Record
        Medicare_Part_D_Fees_Schedule__c MPDObj = TestDataFactory.createMedifeescheduled(bo.Id,faf1.id);
        insert MPDObj;
        
        //Create Fee Services record
        Fee_Services__c FeeServiceObj = TestDataFactory.createFeeService(faf1.id);
        insert FeeServiceObj;
        
        //Create Fee Services Template record 
        Fee_Service_Template__c FeeServiceTemplateObj = TestDataFactory.createFeeServiceTemplate();
        insert FeeServiceTemplateObj;
        
        //Create Retiree Drug Subsidy record  
        Retiree_Drug_Subsidy__c RetireDrugObj = TestDataFactory.createRetireeDrug(faf1.id,MPDObj.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
        insert RetireDrugObj;
        
        PBM_Services__c PBMObj = TestDataFactory.createPBM(faf1.id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
        insert PBMObj;
        
        Billing_Other_Fees__c BillOtherObj = TestDataFactory.createBillOtherFees(faf1.id,bo.Id,FeeServiceTemplateObj.Id,PBMObj.Id);
        insert BillOtherObj;
        
        delete BillOtherObj;
        Test.stopTest();
    }
    
}