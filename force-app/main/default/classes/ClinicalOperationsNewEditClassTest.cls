/*********************************************************************************************
* @author   
* @date     
* @description:This is the test class for ClinicalOperationsNewEditClass
**********************************************************************************************/

@isTest
public with sharing class ClinicalOperationsNewEditClassTest{
    static testmethod void clinicalOperationsNewEditClasstestMeth1()
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
            Clinical_Operations__c clinicalOprObj =  TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalOprObj;
            test.starttest();
            PageReference pageRef = Page.ClinicalOperationEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',clinicalOprObj.id);
            pageRef.getParameters().put(Label.ClinicalOperationLabel,clinicalOprObj.Faf_ID__c);
            
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalOprObj);
            clinicalOperationsNewEditClass controller = new clinicalOperationsNewEditClass(sc);
            /*clinicalOprObj.Client_Savings__c = True;*/
            clinicalOprObj.CSG_Basis__c = 'Percentage';
            clinicalOprObj.CSG_Percentage__c = 10;
            update clinicalOprObj;           
            
            controller.saveUpdateCO();
            controller.checkMandatory();
            controller.checkPercentageFlag();
                      
            test.stoptest();
        }
        
        
    }  
    
    static testmethod void clinicalOperationsNewEditClasstestMeth2()
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
            Clinical_Operations__c clinicalOprObj =  TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalOprObj;
            test.starttest();
            PageReference pageRef = Page.ClinicalOperationEditPage;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put(Label.ClinicalOperationLabel,clinicalOprObj.Faf_ID__c);
            
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalOprObj);
            clinicalOperationsNewEditClass controller = new clinicalOperationsNewEditClass(sc);
        
            controller.saveUpdateCO();
                    
            test.stoptest();
        }
        
        
    } 
    
    static testmethod void clinicalOperationsNewEditClasstestMeth3()
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
            Clinical_Operations__c clinicalOprObj =  TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            clinicalOprObj.Client_Savings__c = 'No';
            insert clinicalOprObj;
            test.starttest();
            PageReference pageRef = Page.ClinicalOperationEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',clinicalOprObj.id);
            pageRef.getParameters().put(Label.ClinicalOperationLabel,clinicalOprObj.Faf_ID__c);
            pageRef.getParameters().put('param1','True');
            pageRef.getParameters().put('param2','Percentage');
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalOprObj);
            clinicalOperationsNewEditClass controller = new clinicalOperationsNewEditClass(sc);
            /*clinicalOprObj.Client_Savings__c = false;*/
            update clinicalOprObj;
            
            controller.saveUpdateCO();
            controller.checkMandatory();
            controller.checkPercentageFlag();
                     
            test.stoptest();
        }
        
        
    }
    
    static testmethod void clinicalOperationsNewEditClasstestMeth4()
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
            
            Clinical_Operations__c clinicalOprObj =  TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            clinicalOprObj.Client_Savings__c = 'yes';
            clinicalOprObj.CSG_Basis__c = 'Flat Dollar';
            insert clinicalOprObj;
            
            /*clinicalOprObj.Client_Savings__c = false;*/
            update clinicalOprObj;
            test.starttest();
            PageReference pageRef = Page.ClinicalOperationEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',clinicalOprObj.id);
            pageRef.getParameters().put(Label.ClinicalOperationLabel,clinicalOprObj.Faf_ID__c);
            pageRef.getParameters().put('param1','Yes');
            pageRef.getParameters().put('param2','Flat Dollar');
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalOprObj);
            clinicalOperationsNewEditClass controller = new clinicalOperationsNewEditClass(sc);
            
            
            controller.saveUpdateCO();
            controller.checkMandatory();
            controller.checkPercentageFlag();
                     
            test.stoptest();
        }
        
        
    }   
}