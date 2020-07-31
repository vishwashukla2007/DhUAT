@isTest
private class ClinicalOperationsTriggerTest{
    @isTest(SeeAllData=true)
    static void ClinicalOperationsm1() {
        
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
        //Create Billing Operations Record 
        Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(faf1.id);
        insert bilOpsObj;
        
        // Create Medicare part D Record
        Medicare_Part_D_Fees_Schedule__c MPDObj = TestDataFactory.createMedifeescheduled(bilOpsObj.Id,faf1.id);
        insert MPDObj;
        
        //Create Fee Services record
        Fee_Services__c FeeServiceObj = TestDataFactory.createFeeService(faf1.id);
        insert FeeServiceObj;
        
        //Create Fee Services Template record 
        Fee_Service_Template__c FeeServiceTemplateObj = TestDataFactory.createFeeServiceTemplate();
        FeeServiceTemplateObj.Item_Section__c='test';
        insert FeeServiceTemplateObj;
        
        //Create Retiree Drug Subsidy record  
        Retiree_Drug_Subsidy__c RetireDrugObj = TestDataFactory.createRetireeDrug(faf1.Id,MPDObj.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
        RetireDrugObj.Election__c= false;
        insert RetireDrugObj;
        
        PBM_Services__c PBMObj = TestDataFactory.createPBM(faf1.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
        PBMObj.Election__c= false;
        insert PBMObj;
        
        Clinical_Operations__c co = TestDataFactory.createGClinicalOperaiton(faf1.id);
        insert co;
        
        co.Client_Savings__c ='No';
        update co;
        
        Field_History_Tracking__c fht=new Field_History_Tracking__c();
        fht.Clinical_Operations__c=true;
        delete co;
        Test.stopTest();
    }
    // }
    
}