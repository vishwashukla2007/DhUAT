/*********************************************************************************************
 * @ClassName         : PrintFAFControllerTest
 * @author            : Anudeep Dale
 * @created date      : 22/10/2018
 * @Last modified by  : Anudeep Dale
 * @Last modified date: 29/08/2018
 * @Purpose           : For increase the PrintFAFController class coverage 
 **********************************************************************************************/
@isTest
public with sharing class PrintFAFControllerTest{

    // It will cover the if method
    static testMethod void PrintFAFControllerMethod1(){
        User useObj = TestDataFactory.createUser('Apttus Sales');
        insert useObj;
        
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
        
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c();
            temp.Name = 'Test Template';
            temp.Apttus__Type__c = 'FAF';
            temp.Apttus__ReferenceId__c = '0837d320-b63e-4924-ba63-7661a0f8f9d3';            
            insert temp;
            
            XAE_Manual_Share__c share = new XAE_Manual_Share__c();
            share.Share__c = true;
            Insert Share;
        
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            FAFObj.Print_Template__c = temp.id;
            insert FAFObj;
            
             Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            FAF_Instructions__c  InstructObj = new FAF_Instructions__c();
            InstructObj.Type__c = 'Instruction';
            InstructObj.Instruction__c = 'test';
            InstructObj.FAF_ID__c = FAFObj.id;
            insert InstructObj;
            
            FAF_Link__c LinkObj = new FAF_Link__c();
            LinkObj.Partial_FAF__c = FAFObj.id;
          //  LinkObj.FAF_ID__c = FAFObj.id;
            insert LinkObj;

            test.starttest();
            
            PageReference pageRef = Page.PrintFAFPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            PrintFAFController controller = new PrintFAFController(sc);
            controller.rebatBool = true;
            controller.guarBool = true;
            controller.PrintFAF();
            controller.Cancel();
            
            test.stoptest();
        }
    }
    // It will cover the if method
    static testMethod void PrintFAFControllerMethod2(){
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
            
            Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
            insert netOpsObj;
        
            Specialty_Operations__c spOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert spOpsObj;

            test.starttest();
            
            PageReference pageRef = Page.PrintFAFPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            PrintFAFController controller = new PrintFAFController(sc);
            controller.rebatBool = true;
            controller.guarBool = true;
             controller.PrintFAF();
            controller.Cancel();
            
            test.stoptest();
        }
    }   
    // It will cover the if method
    static testMethod void PrintFAFControllerMethod3(){
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
            
            Mail_Operations__c mailOpsObj = TestDataFactory.createMailOperation(FAFObj.id);
            insert mailOpsObj;              
            
            Guarantees_Information__c guarntObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert guarntObj;           

            Clinical_Operations__c clinicalObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalObj; 
            
            Legal_Information__c LegalInfoObj =  new Legal_Information__c();
            LegalInfoObj.FAF_ID__c= FAFObj.id;
            LegalInfoObj.Days_Written_Notice_Before_Termination__c='90';
            insert LegalInfoObj ;           
            
            test.starttest();
            
            PageReference pageRef = Page.PrintFAFPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            PrintFAFController controller = new PrintFAFController(sc);
            controller.rebatBool = true;
            controller.guarBool = true;
  //          controller.PrintFAF();
            controller.Cancel();
            
            test.stoptest();
        }
    }
    // It will cover the if method - Platform_Specifics__c
    static testMethod void PrintFAFControllerMethod4(){
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
            rebOpsObj.Non_Specialty_Formulary_Option__c = 'Client Choice';
            rebOpsObj.GSTP_Option__c = 'Choice';
            rebOpsObj.Specialty_Formulary_Option__c = 'Client Choice';
            insert rebOpsObj;
            CAG__c cag = new CAG__c();
            cag.Record_Type__c = 'c';
            cag.CAG_ID__c = '657657';
            insert cag;
            
            Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAFObj.Id);
            ClientInformation.Pricing_Effective_Date__c = null;
            Insert ClientInformation;           
            
            Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
            ps.FAF_Client_Information__c = ClientInformation.Id;
            ps.Level_1_Record_ID__c = cag.id; 
            ps.FAF_ID__c = FAFObj.Id;
            ps.Rebate_Operations__c = rebOpsObj.id;
            ps.LOB__c = 'ACT';
           //insert ps;          
            
            test.starttest();
            
            PageReference pageRef = Page.PrintFAFPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            PrintFAFController controller = new PrintFAFController(sc);
     //       controller.PrintFAF();
            controller.Cancel();            
            test.stoptest();
        }
    }   
    // It will cover the else method
    static testMethod void PrintFAFControllerMethod5(){
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
            
            test.starttest();
            
            PageReference pageRef = Page.PrintFAFPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            PrintFAFController controller = new PrintFAFController(sc);         
            test.stoptest();
        }
    }   
}