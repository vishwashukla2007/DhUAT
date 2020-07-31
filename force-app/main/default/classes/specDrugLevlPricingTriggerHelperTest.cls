/*********************************************************************************************
 * @Test Class Name   : specDrugLevlPricingTriggerHelperTest
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 07/08/2018
 * @Purpose           : This is the testclass for the class specDrugLevlPricingTriggerHelper
 **********************************************************************************************/
@isTest
public with sharing class specDrugLevlPricingTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void specDrugLevlPricingTriggerHelperMeth1()
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
            
           /*Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
            */
            test.starttest();
            
            List<Specialty_Drug_Level_Pricing__c> specDrugLevellist=new List<Specialty_Drug_Level_Pricing__c>();
            //Create Specialty Drug Level Pricing Record 
            Specialty_Operations__c specDrugLevelObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specDrugLevelObj;
            /*
            Specialty_Operations__c specDrugLevelObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert specDrugLevelObj1;
            
            Specialty_Operations__c specDrugLevelObj2 = TestDataFactory.createSpeciality(FAFObj2.id);
            insert specDrugLevelObj2;
            */
            
             // Create Specialty Drug Level Pricing record            
            Specialty_Drug_Level_Pricing__c specDrugLevel = TestDataFactory.createspecDrugObject(FAFObj.id,specDrugLevelObj .id);
            Specialty_Drug_Level_Pricing__c specDrugLevel1 = TestDataFactory.createspecDrugObject(FAFObj.id,specDrugLevelObj.id);
            //Specialty_Drug_Level_Pricing__c specDrugLevel2 = TestDataFactory.createspecDrugObject(FAFObj2.id,specDrugLevelObj2.id);
            specDrugLevellist.add(specDrugLevel);
            specDrugLevellist.add(specDrugLevel1);
            //specDrugLevellist.add(specDrugLevel2);
            insert specDrugLevellist;
            specDrugLevlPricingTriggerHelper.validatedupComb(specDrugLevellist,true,false);
            specDrugLevlPricingTriggerHelper.validatedupComb(specDrugLevellist,false,true);
            test.stoptest();
        }
    }
    
    //Method 1 to pass the parameters
    @isTest
    static void specDrugLevlPricingTriggerHelperMeth2()
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
            
            List<Specialty_Drug_Level_Pricing__c> specDrugLevellist=new List<Specialty_Drug_Level_Pricing__c>();
            
            //Create Specialty Drug Level Pricing Record 
            Specialty_Operations__c specDrugLevelObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specDrugLevelObj;
            Specialty_Operations__c specDrugLevelObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert specDrugLevelObj1;
            
            
             // Create Specialty Drug Level Pricing record            
            Specialty_Drug_Level_Pricing__c specDrugLevel = TestDataFactory.createspecDrugObject(FAFObj.id,specDrugLevelObj .id);
            Specialty_Drug_Level_Pricing__c specDrugLevel1 = TestDataFactory.createspecDrugObject(FAFObj1.id,specDrugLevelObj1.id);
            
            specDrugLevellist.add(specDrugLevel);
            specDrugLevellist.add(specDrugLevel1);
            
            
            insert specDrugLevellist;
            specDrugLevlPricingTriggerHelper.validatedupComb(specDrugLevellist,true,false);
            //specDrugLevlPricingTriggerHelper.validatedupComb(specDrugLevellist,false,true);
            test.stoptest();
        }
    }
}