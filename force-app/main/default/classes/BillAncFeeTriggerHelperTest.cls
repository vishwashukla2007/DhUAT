/*********************************************************************************************
* @Test Class Name   : BillAncFeeTriggerHelperTest
* @author            : Deepankar(Accenture)
* @created date      : 1/08/2018
* @Last modified by  : Deepankar(Accenture)
* @Last modified date: 25/07/2018
* @Purpose           : This is the testclass for the class BillAncFeeTriggerHelper
**********************************************************************************************/
@isTest
public with sharing class BillAncFeeTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void BillAncFeeTriggerHelperMeth1()
    {
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
            
            test.starttest();
            
            List<Billing_Ancillary_Fee__c> billancfeeList=new List<Billing_Ancillary_Fee__c>();
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            Billing_Operations__c bilOpsObj2 = TestDataFactory.createBillOps(FAFObj2.id);
            insert bilOpsObj2;
            
            // Billing_Ancillary_Fee__c  BillingAncillaryName=TestDataFactory.createBillAncillary();
            // insert BillingAncillaryName;
            
            
            // Create Billing Ancillary Fee record            
            Billing_Ancillary_Fee__c BILLANCFEE1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            Billing_Ancillary_Fee__c BILLANCFEE2 = TestDataFactory.createBillAncillary(FAFObj1.id,bilOpsObj1.id);
            Billing_Ancillary_Fee__c BILLANCFEE3 = TestDataFactory.createBillAncillary(FAFObj2.id,bilOpsObj2.id);
            billancfeeList.add(BILLANCFEE1);
            billancfeeList.add(BILLANCFEE2);
            billancfeeList.add(BILLANCFEE3);
            insert billancfeeList;
            BillingAncFeeTriggerHelper.validateLobYearCombinalion(billancfeeList,true,false);
            BillingAncFeeTriggerHelper.validateLobYearCombinalion(billancfeeList,false,true);
            test.stoptest();
        }
    }
    
    @isTest
    static void BillAncFeeTriggerHelperMeth2()
    {
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){                      
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
            test.starttest();
            List<Billing_Ancillary_Fee__c> billancfeeList=new List<Billing_Ancillary_Fee__c>();
            
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //  Billing_Ancillary_Fee__c  BillingAncillaryName=TestDataFactory.createBillAncillary();
            //  insert BillingAncillaryName;
            
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
            Retiree_Drug_Subsidy__c RetireDrugObj = TestDataFactory.createRetireeDrug(FAFObj.Id,MPDObj.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
            insert RetireDrugObj;
            
            //Create Retiree PBM Services record 
            PBM_Services__c PBMObj = TestDataFactory.createPBM(FAFObj.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
            insert PBMObj;
            
            //Create Billing Ancillary Record 
            Billing_Ancillary_Fee__c BILLANCFEE1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            Billing_Ancillary_Fee__c BILLANCFEE2 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            
            
            billancfeeList.add(BILLANCFEE1);
            billancfeeList.add(BILLANCFEE2);
            insert billancfeeList;
            
            
            BillingAncFeeTriggerHelper trhelperobj=new BillingAncFeeTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            BillingAncFeeTriggerHelper.validateLobYearCombinalion(billancfeeList,true,false);
            BillingAncFeeTriggerHelper.BillAncillaryFeeAmountUpdateXAE(billancfeeList);
            delete BILLANCFEE1;
            //	BillingAncFeeTriggerHelper.checkElectionOnDelete(billancfeeList);
            test.stoptest();
        }
    }
}