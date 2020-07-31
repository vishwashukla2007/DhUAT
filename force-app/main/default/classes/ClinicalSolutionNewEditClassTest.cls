/*********************************************************************************************
* @author   
* @date     
* @description:This is the test class for ClinicalSolutionNewEditClass
**********************************************************************************************/

@isTest
public with sharing class ClinicalSolutionNewEditClassTest{
    static testmethod void ClinicalSolutionNewEditClasstestMeth1()
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
            
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            
            test.starttest();
            PageReference pageRef = Page.ClinicalSolutionNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',clinicalSolObj.id);
            pageRef.getParameters().put(Label.ClinicalSolutionLabel,clinicalSolObj.Clinical_Operations__c);
            
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalSolObj);
            ClinicalSolutionNewEditClass controller = new ClinicalSolutionNewEditClass(sc);
            
            controller.saveUpdateCS();
         
                      
            test.stoptest();
        }
        
        
    }  
    
    static testmethod void ClinicalSolutionNewEditClasstestMeth2()
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
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            
            test.starttest();
            PageReference pageRef = Page.ClinicalSolutionNewEditPage;
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put(Label.ClinicalSolutionLabel,clinicalSolObj.Clinical_Operations__c);
            
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalSolObj);
            ClinicalSolutionNewEditClass controller = new ClinicalSolutionNewEditClass(sc);
        
            controller.saveUpdateCS();
                    
            test.stoptest();
        }
        
        
    } 
    
    static testmethod void ClinicalSolutionNewEditClasstestMeth3()
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
            
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            clinicalSolObj.Guarantee__c = 'Yes';
            clinicalSolObj.SOS__c= true;
            clinicalSolObj.Clinical_Solution_Type__c = 'Commercial';
            clinicalSolObj.Clinical_Solution__c= '2nd Level Appeals';
            clinicalSolObj.ROI_Metric__c = 'Percentage';
            update clinicalSolObj;
            test.starttest();
            PageReference pageRef = Page.ClinicalSolutionNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',clinicalSolObj.id);
            pageRef.getParameters().put(Label.ClinicalSolutionLabel,clinicalSolObj.Clinical_Operations__c);
            pageRef.getParameters().put('param1','Yes');
            pageRef.getParameters().put('param2','Percentage');
            pageRef.getParameters().put('param3','True');
            pageRef.getParameters().put('param4','Yes');
            pageRef.getParameters().put('param6','Accordant');
            
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalSolObj);
            ClinicalSolutionNewEditClass controller = new ClinicalSolutionNewEditClass(sc);
            
            controller.saveUpdateCS();
            controller.roiMetricFlagCheck(); 
            controller.sosFlagCheck(); 
            controller.guaranteeCheck(); 
            controller.solutionCheckOptIn(); 
            controller.amountPercetageCheck(); 
                      
            test.stoptest();
        }
        
        
    } 
    
    static testmethod void ClinicalSolutionNewEditClasstestMeth4()
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
            
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            
             Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            clientInfo.Pricing_Effective_Date__c = System.Today();
            insert clientInfo;
            
            test.starttest();
            PageReference pageRef = Page.ClinicalSolutionNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',clinicalSolObj.id);
            pageRef.getParameters().put(Label.ClinicalSolutionLabel,clinicalSolObj.Clinical_Operations__c);
            pageRef.getParameters().put('param1','flase');
            pageRef.getParameters().put('param2','Flat Dollar');
            pageRef.getParameters().put('param3','false');
            pageRef.getParameters().put('param4','false');
            pageRef.getParameters().put('param6','test');
            
            ApexPages.StandardController sc = new ApexPages.standardController(clinicalSolObj);
            ClinicalSolutionNewEditClass controller = new ClinicalSolutionNewEditClass(sc);
            
            controller.saveUpdateCS();
            controller.roiMetricFlagCheck(); 
            controller.sosFlagCheck(); 
            controller.guaranteeCheck(); 
            controller.solutionCheckOptIn(); 
            controller.amountPercetageCheck(); 
                      
            test.stoptest();
        }
        
        
    }
    
}