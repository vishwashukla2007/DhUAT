/* ================================================
 * @Class Name : SpecialtyLDLPricingDeleteClassTest
 * @author : Vinitha
 * @Purpose: Test Class for SpecialtyLDLPricingDeleteClass
 * @created date:26/03/2019
 * @Last modified date:
 * @Last modified by : 
================================================*/
@isTest
public with sharing class SpecialtyLDLPricingDeleteClassTest{

     @isTest
    static void SpecialtyLDLPricingDeleteClassTestMethod1(){
    
        string fieldName = Label.rebateOperationLabel;
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
           
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            
            Platform_Specifics__c platForm = new Platform_Specifics__c();
            platForm.FAF_Client_Information__c =  ClinInfo.Id;
            platForm.Level_1_Record_ID__c = cag.Id;
            platForm.Termed__c = false;
            platForm.DifferentGSTPFormularyEffectiveDates__c = false;
            platForm.FAF_ID__c = FAFObj.id; 
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'Exclusive (Retail Lockout)';
        //    insert platForm;
            
            test.starttest();
           
            List<Specialty_Legacy_Drug_Level_pricing__c> SpecLegDrugLevellist=new List<Specialty_Legacy_Drug_Level_pricing__c>();
            //Create Specialty Drug Level Pricing Record 
            Specialty_Operations__c SpecLegDrugLevelObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert SpecLegDrugLevelObj;
            
            Specialty_Operations__c SpecLegDrugLevelObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert SpecLegDrugLevelObj1;
            
            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,SpecLegDrugLevelObj.id);
            specPricingObj.Pharmacy_Benefit__c = 'Exclusive (Retail Lockout)';
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj1.id,SpecLegDrugLevelObj.id);
            specPricingObj1.Pharmacy_Benefit__c = 'None';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
             insert specPricingList;
            
             // Create ASP Guarantee record            
            Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel = TestDataFactory.createSpeciality(FAFObj.id,SpecLegDrugLevelObj .id);
            Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel1 = TestDataFactory.createSpeciality(FAFObj1.id,SpecLegDrugLevelObj1.id);
            
            SpecLegDrugLevellist.add(specLegDrugLevel);
            SpecLegDrugLevellist.add(specLegDrugLevel1);
            
            insert SpecLegDrugLevellist;
           
            PageReference pageRef = Page.SpecialtyLDLPricingDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(ConstantsUtil.ID ,SpecLegDrugLevellist[0].id);
            ApexPages.StandardController sc = new ApexPages.standardController(SpecLegDrugLevellist[0]);
            SpecialtyLDLPricingDeleteClass controller = new SpecialtyLDLPricingDeleteClass(sc);
            controller.deleteRecord();
            test.stoptest();
        }
    
    }
    
    @isTest
    static void SpecialtyLDLPricingDeleteClassTestMethod2(){
    
        string fieldName = Label.rebateOperationLabel;
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
           
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            
            
            test.starttest();
           
            List<Specialty_Legacy_Drug_Level_pricing__c> SpecLegDrugLevellist=new List<Specialty_Legacy_Drug_Level_pricing__c>();
            //Create Specialty Drug Level Pricing Record 
            Specialty_Operations__c SpecLegDrugLevelObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert SpecLegDrugLevelObj;
            
            Specialty_Operations__c SpecLegDrugLevelObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert SpecLegDrugLevelObj1;
                                  
             // Create ASP Guarantee record            
            Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel = TestDataFactory.createSpeciality(FAFObj.id,SpecLegDrugLevelObj .id);
            Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel1 = TestDataFactory.createSpeciality(FAFObj1.id,SpecLegDrugLevelObj1.id);
            
            SpecLegDrugLevellist.add(specLegDrugLevel);
            SpecLegDrugLevellist.add(specLegDrugLevel1);
            
            insert SpecLegDrugLevellist;
           
            PageReference pageRef = Page.SpecialtyLDLPricingDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(ConstantsUtil.ID ,SpecLegDrugLevellist[0].id);
            ApexPages.StandardController sc = new ApexPages.standardController(SpecLegDrugLevellist[0]);
            SpecialtyLDLPricingDeleteClass controller = new SpecialtyLDLPricingDeleteClass(sc);
            controller.deleteRecord();
            test.stoptest();
        }
    
    }
}