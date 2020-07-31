/* ================================================
 * @Class Name : SpecialtyOpsNewEditClassTest
 * @author : Accenture
 * @Purpose: Test Class for Handler class of SpecialtyOpsNewEditClassTest
 * @created date:08/09/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class SpecialtyOpsNewEditClassTest{


   /* ================================================
     * @Method Name : SpecialtyOpsNewEditClassTestMethod1
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/09/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void SpecialtyOpsNewEditClassTestMethod1(){
    
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
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            specOpsObj.Pharmacy_Benefit__c = 'Client Choice';
            insert specOpsObj;
            
            Specialty_Drug_Level_Pricing__c specDrugObj= TestDataFactory.createspecDrugObject(FAFObj.id, specOpsObj.id);
            insert specDrugObj;
            
            Specialty_Pricing__c specPricObj= TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            insert specPricObj;
            
            test.starttest();
            PageReference pageRef = Page.SpecialtyOpsNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specOpsObj.id);
            pageRef.getParameters().put(Label.FafIdSpecOpsLabel,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specOpsObj);
            SpecialtyOpsNewEditClass controller = new SpecialtyOpsNewEditClass(sc);
            controller.pharmBenValue = 'Client Choice';
            controller.pharmBenChangeAction();
            controller.saveUpdateSpecInfo();  

            ApexPages.StandardController sc1 = new ApexPages.standardController(specOpsObj);
            SpecialtyOpsNewEditClass controller1 = new SpecialtyOpsNewEditClass(sc1);
            specOpsObj.Pharmacy_Benefit__c = 'Open';
            update specOpsObj;
            controller1.pharmBenValue = 'Open';
            controller1.pharmBenChangeAction();
            controller1.saveUpdateSpecInfo();  
            
            test.stoptest();
        }
    
    }
     @isTest
    static void SpecialtyOpsNewEditClassTestMethod2(){
    
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
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            test.starttest();
            PageReference pageRef = Page.SpecialtyOpsNewEditPage;
            Test.setCurrentPage(pageRef);
            //pageRef.getParameters().put('id',specOpsObj.id);
            pageRef.getParameters().put(Label.FafIdSpecOpsLabel,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specOpsObj);
            SpecialtyOpsNewEditClass controller = new SpecialtyOpsNewEditClass(sc);
            specOpsObj.Pharmacy_Benefit__c = 'Open';
            update specOpsObj;
            controller.pharmBenValue = 'Open';
            controller.pharmBenChangeAction();
            controller.saveUpdateSpecInfo();
            test.stoptest();
        }
    
    }
     @isTest
    static void SpecialtyOpsDeleteClassMethod(){
    
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
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            test.starttest();
			delete specOpsObj;
            test.stoptest();
        }
    
    }	
}