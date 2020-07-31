@isTest
public with sharing class SpecialtyLegacyDrugLevelPricingTest{
    
     @isTest(SeeAllData=true)
    static void SpecialtyLegacyDrugLevelPricingTest1()
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
            
            Specialty_Legacy_Drug_Level_pricing__c  specLegacyDrugPr=TestDataFactory.createSpeciality(FAFObj.id,SpecOpsObj.id);
            insert specLegacyDrugPr;
            
            specLegacyDrugPr.LOB__c ='CAP';
            update specLegacyDrugPr;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Specialty_Legacy_Drug_Level_pricing__c=true;
            delete specLegacyDrugPr;
            test.stoptest();
        }
    }
}