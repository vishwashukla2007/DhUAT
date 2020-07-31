/*********************************************************************************************
* @author   Sanket Saxena
* @date     19 10 2018
* @description:This is the test class for BillingAdminDeleteClass        
**********************************************************************************************/

@isTest
public with sharing class BillingAdminDeleteClasstest{
    static testmethod void BillingAdminDeleteClasstestMeth1()
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
                   
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,billOpsObj.id);
            ancObj.Fee_Amount__c = 960;
            insert ancObj;
            ancObj.Ancillary_Fee_Description__c='Single Transaction Coordination of Benefits (STCOB) – Retail';
            ancObj.Fee_Basis__c=  'Match Retail Per Claim Admin Fee (both primary and secondary claim)';
            update ancObj;
                        
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert admObj;
            admObj.Admin_Fee_Type__c= 'Retail Per Claim';
            update admObj;
            delete admObj;
            
            PageReference pageRef = Page.BillingAdminDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',admObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(admObj);
            BillingAdminDeleteClass controller = new BillingAdminDeleteClass(sc);
            controller.checkRecord();
            controller.deleteRecord();
            
            test.stoptest();
        }
    }
        
    static testmethod void BillingAdminDeleteClasstestMeth2()
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
                   
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,billOpsObj.id);
            ancObj.Fee_Amount__c = 960;
            insert ancObj;
            ancObj.Ancillary_Fee_Description__c='Single Transaction Coordination of Benefits (STCOB) – Retail';
            ancObj.Fee_Basis__c=  'Match Retail Per Claim Admin Fee (both primary and secondary claim)';
            update ancObj;
                        
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert admObj;
            admObj.Admin_Fee_Type__c= 'Retail Per Claim';
            update admObj;
            
            PageReference pageRef = Page.BillingAdminDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',admObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(admObj);
            BillingAdminDeleteClass controller = new BillingAdminDeleteClass(sc);
            controller.checkRecord();
            controller.deleteRecord();
            
            test.stoptest();
        }
    }
    static testmethod void BillingAdminDeleteClasstestMeth3()
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
                   
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,billOpsObj.id);
            ancObj.Fee_Amount__c = 960;
            insert ancObj;
            ancObj.Ancillary_Fee_Description__c='Single Transaction Coordination of Benefits (STCOB) – Mail';
            ancObj.Fee_Basis__c=  'Match Mail Per Claim Admin Fee (both primary and secondary claim)';
            update ancObj;
                        
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert admObj;            
            
            PageReference pageRef = Page.BillingAdminDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',admObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(admObj);
            BillingAdminDeleteClass controller = new BillingAdminDeleteClass(sc);
            controller.checkRecord();
            controller.deleteRecord();
            
            test.stoptest();
        }
    }
    static testmethod void BillingAdminDeleteClasstestMeth4()
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
                   
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,billOpsObj.id);
            ancObj.Fee_Amount__c = 960;
            insert ancObj;
            ancObj.Ancillary_Fee_Description__c='Coordination of Benefits – Paper';
            ancObj.Fee_Basis__c=  'Match Paper Per Claim Admin Fee';
            update ancObj;
                        
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert admObj;
            admObj.Admin_Fee_Type__c= ' Paper Per Claim';
            update admObj;
            
            PageReference pageRef = Page.BillingAdminDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',admObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(admObj);
            BillingAdminDeleteClass controller = new BillingAdminDeleteClass(sc);
            controller.checkRecord();
            controller.deleteRecord();
            
            test.stoptest();
        }
    }
    static testmethod void BillingAdminDeleteClasstestMeth5()
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
                   
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,billOpsObj.id);
            ancObj.Fee_Amount__c = 960;
            insert ancObj;
            ancObj.Ancillary_Fee_Description__c='Single Transaction Coordination of Benefits (STCOB) – Retail';
            ancObj.Fee_Basis__c=  'Match Retail Per Claim Admin Fee (both primary and secondary claim)';
            update ancObj;
                        
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert admObj;
            
            PageReference pageRef = Page.BillingAdminDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',admObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(admObj);
            BillingAdminDeleteClass controller = new BillingAdminDeleteClass(sc);
            controller.checkRecord();
            controller.deleteRecord();
            
            test.stoptest();
        }
    }
            
}