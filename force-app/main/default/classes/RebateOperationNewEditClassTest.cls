@isTest
public with sharing class RebateOperationNewEditClassTest{
    @isTest 
    static void RebateOperationNewEditClassTestMeth1()
    {
        string fieldName = Label.rebateOperationLabel;
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //UserRole roleObj = TestDataFactory.createRole();
        //insert roleObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        //useObjNew.userroleId = roleObj.id;
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            test.starttest();
            PageReference pageRef = Page.RebateOperationNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',rebOpsObj.id);
            pageRef.getParameters().put(Label.rebateOperationLabel,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controller = new RebateOperationNewEditClass(sc);
            rebOpsObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            update rebOpsObj;
            ApexPages.StandardController sc1 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew = new RebateOperationNewEditClass(sc1);
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Guarantee Only';
            update rebOpsObj;
            ApexPages.StandardController sc2 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew1 = new RebateOperationNewEditClass(sc2);
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            update rebOpsObj;
            ApexPages.StandardController sc3 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew2 = new RebateOperationNewEditClass(sc3);
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO+MAF)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Client_MAF_Share__c = 20;
            update rebOpsObj;
            ApexPages.StandardController sc4 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew3 = new RebateOperationNewEditClass(sc4);
            controllerNew3.oncheckspecialityAction();
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Reinvested Rebates (GPO) w/Recon';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Client_MAF_Share__c = 20;
            update rebOpsObj;
            ApexPages.StandardController sc6 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew5 = new RebateOperationNewEditClass(sc6);
            controllerNew5.oncheckspecialityAction();
            rebOpsObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO+PP)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Client_PP_Share__c = 20;
            update rebOpsObj;
            ApexPages.StandardController sc5 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew4 = new RebateOperationNewEditClass(sc5);
            controllerNew4.changeSpecialityRebateAction();
            controllerNew4.saveUpdateRO();
            test.stoptest();
        }
    }
    @isTest 
    static void RebateOperationNewEditClassTestMeth2()
    {
        string fieldName = Label.rebateOperationLabel;
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
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            test.starttest();
            PageReference pageRef = Page.RebateOperationNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',rebOpsObj.id);
            pageRef.getParameters().put(Label.rebateOperationLabel,FAFObj.id);            
            rebOpsObj.Specialty_Rebates__c = 'Do Not Pass to Client';
            rebOpsObj.Specialty_Rebate_Contract_Type__c = '';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = '';
            rebOpsObj.Specialty_Client_PP_Share__c = 20;
            update rebOpsObj;
            ApexPages.StandardController sc = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controller = new RebateOperationNewEditClass(sc);
            controller.changeSpecialityRebateAction();
            controller.saveUpdateRO();
            test.stoptest();
        }
    }
    @isTest 
    static void RebateOperationNewEditClassTestMeth3()
    {
        string fieldName = Label.rebateOperationLabel;
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
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            test.starttest();
            PageReference pageRef = Page.RebateOperationNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.rebateOperationLabel,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controller = new RebateOperationNewEditClass(sc);
            controller.saveUpdateRO();
            test.stoptest();
        }
    }
    
    @isTest 
    static void RebateOperationNewEditClassTestMeth4()
    {
        string fieldName = Label.rebateOperationLabel;
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
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            rebOpsObj.Percentage_Guarantee__c = false;
            insert rebOpsObj;
            Rebate_Gtees_Specialty_Class_Carve_Outs__c rebtGtessObj =  TestDataFactory.createGtees(rebOpsObj.id, FAFObj.id);
            insert rebtGtessObj;
            Rebate_Guarantees__c rebtGuarant = TestDataFactory.createRebateGuarantee(FAFObj.id, rebOpsObj.id);
            insert rebtGuarant;
            test.starttest();
            PageReference pageRef = Page.RebateOperationNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',rebOpsObj.id);
            pageRef.getParameters().put(Label.rebateOperationLabel,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controller = new RebateOperationNewEditClass(sc);
            
            /*rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            update rebOpsObj;
            ApexPages.StandardController sc1 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew = new RebateOperationNewEditClass(sc1);
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Guarantee Only';
            update rebOpsObj;
            ApexPages.StandardController sc2 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew1 = new RebateOperationNewEditClass(sc2);
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            update rebOpsObj;
            ApexPages.StandardController sc3 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew2 = new RebateOperationNewEditClass(sc3);
            
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO+MAF)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Client_MAF_Share__c = 20;
            update rebOpsObj;

            ApexPages.StandardController sc4 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew3 = new RebateOperationNewEditClass(sc4);
            controllerNew3.oncheckspecialityAction();*/
            rebOpsObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO+PP)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            //rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            //rebOpsObj.Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Client_PP_Share__c = 20;
            rebOpsObj.Class_Carve_Out_Guarantee_Percentage__c = true;
            rebOpsObj.Percentage_Guarantee__c = true;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            update rebOpsObj;
            ApexPages.StandardController sc5 = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controllerNew4 = new RebateOperationNewEditClass(sc5);
            //18th March 2018   Prakarsh Jain
            //Added code to increase code coverage - W-000621
            controllerNew4.changeSpecialityRebateAction();
            controllerNew4.oncheckspecialityPmntTermAction();
            controllerNew4.changeGSTPOptionAction();
            controllerNew4.changeGSTPAction();
            controllerNew4.changeNonSpecOptionAction();
            controllerNew4.changeSpecFormOptionAction();
            controllerNew4.saveUpdateRO();
            delete rebOpsObj;
            test.stoptest();
            
        }
    }
    
     @isTest 
    static void RebateOperationNewEditClassTestMeth5()
    {
        string fieldName = Label.rebateOperationLabel;
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
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            
            
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Percentage_Guarantee__c = true;
            insert rebOpsObj;
            
            Rebate_Guarantees__c rebtGuarObj =  TestDataFactory.createRebateGuarantee(FAFObj.id, rebOpsObj.id);
            insert rebtGuarObj;
            test.starttest();
            rebOpsObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
            rebOpsObj.Specialty_Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)';
            rebOpsObj.Specialty_Rebate_Offering_Type__c = 'Split Only';
            update rebOpsObj;
            
            PageReference pageRef = Page.RebateOperationNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.rebateOperationLabel,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebOpsObj);
            RebateOperationNewEditClass controller = new RebateOperationNewEditClass(sc);
            
            controller.rebatePassMAFCheck = true;
            controller.rebatePassPPCheck = true;
            controller.specPassPPCheck = true;
            controller.specPassMAFCheck = true;
            controller.retailSupplyFlag = true;
            controller.retailDaysSupplyAction();
            controller.specPassMAFAction();
            controller.specPassPPAction();
            controller.rebatePassMAFAction();
            controller.rebatePassPPAction();
            

            test.stoptest();
            
        }
    }
}