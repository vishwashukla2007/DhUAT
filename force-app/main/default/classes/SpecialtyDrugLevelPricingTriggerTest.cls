@isTest
public with sharing class SpecialtyDrugLevelPricingTriggerTest{
    
     @isTest(SeeAllData=true)
    static void SpecialtyDrugLevelPricingTriggerTest1()
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
            

            test.starttest();
            
            //Create Guarantee Information Record 
            Specialty_Operations__c SpecOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert SpecOpsObj;

            Specialty_Pricing__c SpecPricObj = TestDataFactory.createspecPricingObject(FAFObj.id,SpecOpsObj.id);
            insert SpecPricObj;
            
             // Create Trend Guarantee record            
            Specialty_Guarantee__c SpecGuarObj = TestDataFactory.createspecGuarnt(FAFObj.id,SpecPricObj.id);
            insert SpecGuarObj;
            
            Specialty_Drug_Level_Pricing__c  specDrugPr=TestDataFactory.createspecDrugObject(FAFObj.id,SpecOpsObj.id);
            insert specDrugPr;
            
            specDrugPr.Drug_Therapy__c ='Amyloidosis';
            update specDrugPr;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Specialty_Guarantee__c=true;
            delete specDrugPr;
            test.stoptest();
        }
    }
}