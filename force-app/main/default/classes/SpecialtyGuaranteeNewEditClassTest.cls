/*********************************************************************************************
 * @ClassName         : SpecialtyGuaranteeNewEditClassTest
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 16/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 16/08/2018
 * @Purpose           : This is the Test class for SpecialtyGuaranteeNewEditClassTest
 **********************************************************************************************/
@isTest
public with sharing class SpecialtyGuaranteeNewEditClassTest{
    @isTest 
    static void SpecialtyGuaranteeNewEditClassTestMeth1()
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
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            insert specpricObj;
            Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            insert specGuaranObj;
            
            test.starttest();
            PageReference pageRef = Page.SpecialtyGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.SpecPricOnGuaranteeLabel,specpricObj.id);
            pageRef.getParameters().put('lightning','test');
            ApexPages.StandardController sc = new ApexPages.standardController(specGuaranObj);
            SpecialtyGuaranteeNewEditClass controller = new SpecialtyGuaranteeNewEditClass(sc);
            controller.SaveUpdateSpecGuarantee();
            controller.cancel();
            PageReference pageRef1 = Page.SpecialtyGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef1);
            pageRef1.getParameters().put('id',specGuaranObj.id);
            pageRef1.getParameters().put(Label.SpecPricOnGuaranteeLabel,specpricObj.id);
            //pageRef1.getParameters().put('lightning','test');
            ApexPages.StandardController sc1 = new ApexPages.standardController(specGuaranObj);
            SpecialtyGuaranteeNewEditClass controller1 = new SpecialtyGuaranteeNewEditClass(sc1);
            controller1.SaveUpdateSpecGuarantee();
            controller1.cancel();
            test.stoptest();
        }
    }
    @isTest 
    static void SpecialtyGuaranteeNewEditClassTestMeth2()
    {

        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
        try{
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
             Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert specOpsObj1;
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            insert specpricObj;
            Specialty_Pricing__c specpricObj1 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
            insert specpricObj1;
            Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            //insert specGuaranObj;
            list<Specialty_Guarantee__c> specGuaranObjlist = new list<Specialty_Guarantee__c>();
            
            test.starttest();
            specGuaranObjlist = [Select id,Specialty_Pricing__c  from Specialty_Guarantee__c where Specialty_Pricing__c =:specOpsObj1.id];
            insert specGuaranObjlist;
            //system.assertequals(specGuaranObjlist,null);
            system.debug('@@specGuaranObjlist'+specGuaranObjlist);
             PageReference pageRef = Page.SpecialtyGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            //pageRef.getParameters().put('id',specOpsObj.id);
            pageRef.getParameters().put(Label.SpecPricOnGuaranteeLabel,'');
            ApexPages.StandardController sc1 = new ApexPages.standardController(specpricObj);
             SpecialtyGuaranteeNewEditClass controller1 = new SpecialtyGuaranteeNewEditClass(sc1);
            test.stoptest();
            }catch(Exception excp){
        ApexPages.addMessages(excp);
    }
            
        }
        
    }
}