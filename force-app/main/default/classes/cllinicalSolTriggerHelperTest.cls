/*********************************************************************************************
* @author   
* @date     
* @description:This is the test class for cllinicalSolTriggerHelper
**********************************************************************************************/

@isTest
public with sharing class cllinicalSolTriggerHelperTest{
    static testmethod void cllinicalSolTriggerHelpertestMeth1()
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
            Clinical_Operations__c clinicalOprObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalOprObj;
            List<Clinical_Solutions__c> clinicalSolLIst = new List<Clinical_Solutions__c>();
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            Clinical_Solutions__c clinicalSolObj1 =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            clinicalSolObj1.Clinical_Solution_Type__c = 'Commercial';
            clinicalSolObj1.Clinical_Solution__c= '2nd Level Appeals';
            //clinicalSolObj.Year__c = 
            insert clinicalSolObj1;
            clinicalSolLIst.add(clinicalSolObj);
            clinicalSolLIst.add(clinicalSolObj1);
            test.starttest();
            cllinicalSolTriggerHelper.dulicateCheckSol(clinicalSolLIst);
                      
            test.stoptest();
        }
        
        
    }  
    
    static testmethod void cllinicalSolTriggerHelpertestMeth2()
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
            List<Clinical_Solutions__c> clinicalSolLIst = new List<Clinical_Solutions__c>();
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            clinicalSolObj.Clinical_Solution_Type__c = 'Commercial';
            clinicalSolObj.Clinical_Solution__c= '2nd Level Appeals';
            insert clinicalSolObj;
            clinicalSolLIst.add(clinicalSolObj);
            
            test.starttest();
            cllinicalSolTriggerHelper.dulicateCheckSol(clinicalSolLIst);
                    
            test.stoptest();
        }
        
        
    } 
    
    static testmethod void cllinicalSolTriggerHelpertestMeth3()
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
            
            List<Clinical_Solutions__c> clinicalSolLIst = new List<Clinical_Solutions__c>();
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            
            clinicalSolObj.Guarantee__c = 'Yes';
            clinicalSolObj.SOS__c= true;
            clinicalSolObj.Clinical_Solution_Type__c = 'Commercial';
            clinicalSolObj.Clinical_Solution__c= '2nd Level Appeals';
            clinicalSolObj.ROI_Metric__c = 'Percentage';
            update clinicalSolObj;
            clinicalSolLIst.add(clinicalSolObj);
            test.starttest();
            cllinicalSolTriggerHelper.dulicateCheckSol(clinicalSolLIst);
                      
            test.stoptest();
        }
        
        
    } 
    
    static testmethod void cllinicalSolTriggerHelpertestMeth4()
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
            //Create Fee Services record
            Fee_Services__c FeeServiceObj = TestDataFactory.createFeeService(FAFObj.id);
            insert FeeServiceObj;
            
            //Create Fee Services Template record 
            Fee_Service_Template__c FeeServiceTemplateObj = TestDataFactory.createFeeServiceTemplate();
            insert FeeServiceTemplateObj;
                  
            //Create Retiree PBM Services record 
            PBM_Services__c PBMObj = TestDataFactory.createPBM(FAFObj.Id,FeeServiceObj.Id,FeeServiceTemplateObj.Id);
            insert PBMObj;
            
            Clinical_Operations__c clinicalOprObj =  TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalOprObj;
            
            List<Clinical_Solutions__c> clinicalSolLIst = new List<Clinical_Solutions__c>();
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            insert clinicalSolObj;
            clinicalSolLIst.add(clinicalSolObj);
            
             Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            clientInfo.Pricing_Effective_Date__c = System.Today();
            insert clientInfo;
            
            test.starttest();
            
            cllinicalSolTriggerHelper.dulicateCheckSol(clinicalSolLIst); 
                delete clinicalSolLIst;      
            test.stoptest();
        }
        
        
    }
    
}