/*********************************************************************************************
 * @Test Class Name   : SpecLegacyDrugLevelTriggerHelperTest
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 07/08/2018
 * @Purpose           : This is the testclass for the class SpecLegacyDrugLevelTriggerHelper
 **********************************************************************************************/
@isTest
public with sharing class SpecLegacyDrugLevelTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void SpecLegacyDrugLevelTriggerHelperMeth1()
    {
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
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
            /*
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
            */
            test.starttest();
            
            List<Specialty_Legacy_Drug_Level_pricing__c> SpecLegDrugLevellist=new List<Specialty_Legacy_Drug_Level_pricing__c>();
            //Create Specialty Drug Level Pricing Record 
            Specialty_Operations__c SpecLegDrugLevelObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert SpecLegDrugLevelObj;
            /*
            Specialty_Operations__c SpecLegDrugLevelObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert SpecLegDrugLevelObj1;
            
            Specialty_Operations__c SpecLegDrugLevelObj2 = TestDataFactory.createSpeciality(FAFObj2.id);
            insert SpecLegDrugLevelObj2;
            */
            
             // Create ASP Guarantee record            
            Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel = TestDataFactory.createSpeciality(FAFObj.id,SpecLegDrugLevelObj .id);
            Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel1 = TestDataFactory.createSpeciality(FAFObj.id,SpecLegDrugLevelObj.id);
            //Specialty_Legacy_Drug_Level_pricing__c specLegDrugLevel2 = TestDataFactory.createSpeciality(FAFObj2.id,SpecLegDrugLevelObj2.id);
            SpecLegDrugLevellist.add(specLegDrugLevel);
            SpecLegDrugLevellist.add(specLegDrugLevel1);
            //SpecLegDrugLevellist.add(specLegDrugLevel2);
            insert SpecLegDrugLevellist;
            SpecLegacyDrugLevelPricingTriggerHelper.validatePricingFieldsCombination(SpecLegDrugLevellist,true,false);
            SpecLegacyDrugLevelPricingTriggerHelper.validatePricingFieldsCombination(SpecLegDrugLevellist,false,true);
            test.stoptest();
        }
    }
    
    //Method 1 to pass the parameters
    @isTest
    static void SpecLegacyDrugLevelTriggerHelperMeth2()
    {
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
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
            SpecLegacyDrugLevelPricingTriggerHelper.validatePricingFieldsCombination(SpecLegDrugLevellist,true,false);
            
            test.stoptest();
        }
    }
}