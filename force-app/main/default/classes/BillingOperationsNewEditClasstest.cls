/*********************************************************************************************
* @author   Akanksha Singh
* @date     27 06 2018
* @description:This is the test class for BillingOperationsNewEditClass        
**********************************************************************************************/

@isTest
public with sharing class BillingOperationsNewEditClasstest{
    static testmethod void BillingOperationsNewEditClasstestMeth1()
    {
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Billing_Operations__c billOpsObj =  TestDataFactory.createBillOps(FAFObj.id);
            insert billOpsObj;
            test.starttest();
            PageReference pageRef = Page.BillingOperationEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',billOpsObj.id);
            pageRef.getParameters().put(Label.billingOperationLabel,billOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller = new BillingOperationsNewEditClass(sc);

            billOpsObj.Pharmacy_Audit_Retention__c = 'Base (Custom)';
            billOpsObj.Billing_Claim_Payment_Terms__c = 'Non-Standard';
            billOpsObj.Billing_Admin_Payment_Terms__c = 'Non-Standard';
            update billOpsObj;
            controller.saveUpdateBillOp();
            controller.billingAuditRetenAct();
            controller.changePaymentTerms();

            ApexPages.StandardController sc1 = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller1 = new BillingOperationsNewEditClass(sc);

            billOpsObj.Pharmacy_Audit_Retention__c = 'Base (100/0)';
            billOpsObj.Billing_Claim_Payment_Terms__c = '15 Days';
            billOpsObj.Billing_Admin_Payment_Terms__c = '15 Days';
            update billOpsObj;
            controller1.saveUpdateBillOp();
            controller1.billingAuditRetenAct();
            controller1.changePaymentTerms();
            
            billOpsObj.Pharmacy_Audit_Retention__c = ConstantsUtil.PHARMACYAUDITRET_PREMIER75;
            billOpsObj.Billing_Claim_Payment_Terms__c = '15 Days';
            billOpsObj.Billing_Admin_Payment_Terms__c = '15 Days';
            update billOpsObj;
            ApexPages.StandardController sc11 = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller11 = new BillingOperationsNewEditClass(sc11);            
            controller11.billingAuditRetenAct();
            
            billOpsObj.Pharmacy_Audit_Retention__c = ConstantsUtil.PHARMACYAUDITRET_BASE100;
            billOpsObj.Billing_Claim_Payment_Terms__c = '15 Days';
            billOpsObj.Billing_Admin_Payment_Terms__c = '15 Days';
            update billOpsObj;
            ApexPages.StandardController sc12 = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller12 = new BillingOperationsNewEditClass(sc12);            
            controller12.billingAuditRetenAct();
            
            billOpsObj.Pharmacy_Audit_Retention__c = ConstantsUtil.PHARMACYAUDITRET_BASE80;
            billOpsObj.Billing_Claim_Payment_Terms__c = '15 Days';
            billOpsObj.Billing_Admin_Payment_Terms__c = '15 Days';
            update billOpsObj;
            ApexPages.StandardController sc13 = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller13 = new BillingOperationsNewEditClass(sc13);            
            controller13.billingAuditRetenAct();
            
            billOpsObj.Pharmacy_Audit_Retention__c = null;
            billOpsObj.client_share__c = 50;
            billOpsObj.Billing_Claim_Payment_Terms__c = '15 Days';
            billOpsObj.Billing_Admin_Payment_Terms__c = '15 Days';
            update billOpsObj;
            ApexPages.StandardController sc14 = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller14 = new BillingOperationsNewEditClass(sc14);            
            controller14.billingAuditRetenAct();
            test.stoptest();
        }
    }

    static testmethod void BillingOperationsNewEditClasstestMeth2()
    {
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Billing_Operations__c billOpsObj =  TestDataFactory.createBillOps(FAFObj.id);
            insert billOpsObj;

            test.starttest();
            PageReference pageRef = Page.BillingOperationEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.billingOperationLabel,billOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(billOpsObj);
            BillingOperationsNewEditClass controller = new BillingOperationsNewEditClass(sc);
            controller.saveUpdateBillOp();
            
            test.stoptest();
        }
    }
}