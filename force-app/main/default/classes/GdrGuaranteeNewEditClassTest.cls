/*********************************************************************************************
 * @ClassName         : GdrGuaranteeNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 07/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 07/08/2018
 * @Purpose           : Test class for GdrGuaranteeNewEditClass   
 **********************************************************************************************/
@isTest
public with sharing class GdrGuaranteeNewEditClassTest{
    @isTest 
    static void GdrGuaranteeNewEditClassTestMeth1()
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
            Guarantees_Information__c gurInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            //gurInfoObj.GDR_Guarantee_Payout__c = '$ for $ with Max. Cap';
            insert gurInfoObj;
            
            GDR_Guarantee__c gdrGurInfoObj = TestDataFactory.createGdrGuarantee(FAFObj.id, gurInfoObj.id);
            insert gdrGurInfoObj;
            
            test.starttest();
            PageReference pageRef = Page.GdrGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',gdrGurInfoObj.id);
            pageRef.getParameters().put(Label.GuarInfoIdInGdrGuarantee,FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(gdrGurInfoObj);
            GdrGuaranteeNewEditClass controller = new GdrGuaranteeNewEditClass(sc);
            controller.saveUpdateGdrGuaranteeObj();
            
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.GuarInfoIdInGdrGuarantee,gurInfoObj.id);
            ApexPages.StandardController sc1 = new ApexPages.standardController(gdrGurInfoObj);
            GdrGuaranteeNewEditClass controller1 = new GdrGuaranteeNewEditClass(sc1);
            controller1.saveUpdateGdrGuaranteeObj();
            controller1.operationType='CLONE';
            test.stoptest();
        }
    }
    @isTest 
    static void GdrGuaranteeNewEditClassTestMeth2()
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
            Guarantees_Information__c gurInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert gurInfoObj;
            
            GDR_Guarantee__c gdrGurInfoObj = TestDataFactory.createGdrGuarantee(FAFObj.id, gurInfoObj.id);
            insert gdrGurInfoObj;
            
            test.starttest();
            PageReference pageRef = Page.GdrGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);

            
            //pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.GuarInfoIdInGdrGuarantee,gurInfoObj.id);
            ApexPages.StandardController sc1 = new ApexPages.standardController(gurInfoObj);
            GdrGuaranteeNewEditClass controller1 = new GdrGuaranteeNewEditClass(sc1);
            controller1.operationType = 'clone';
            controller1.saveUpdateGdrGuaranteeObj();
          
            test.stoptest();
        }
    }
}