/*********************************************************************************************
 * @Test Class Name   : SpecialtyGuaranteeTriggerHelperTest
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 21/08/2018
 * @Purpose           : This is the testclass for the class SpecialtyGuaranteeTriggerHelper
 **********************************************************************************************/
@isTest
public with sharing class SpecialtyGuaranteeTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void SpecialtyGuaranteeTriggerHelperMeth1()
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
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;

            test.starttest();
            
            List<Specialty_Guarantee__c> specGuarlist=new List<Specialty_Guarantee__c>();
            //Create Guarantee Information Record 
            Specialty_Operations__c SpecOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert SpecOpsObj;
            Specialty_Operations__c SpecOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert SpecOpsObj1;
            Specialty_Operations__c SpecOpsObj2 = TestDataFactory.createSpeciality(FAFObj2.id);
            insert SpecOpsObj2;

            Specialty_Pricing__c SpecPricObj = TestDataFactory.createspecPricingObject(FAFObj.id,SpecOpsObj.id);
            insert SpecPricObj;
            Specialty_Pricing__c SpecPricObj1 = TestDataFactory.createspecPricingObject(FAFObj1.id,SpecOpsObj1.id);
            insert SpecPricObj1;
            Specialty_Pricing__c SpecPricObj2 = TestDataFactory.createspecPricingObject(FAFObj2.id,SpecOpsObj2.id);
            insert SpecPricObj2;

            
             // Create Trend Guarantee record            
            Specialty_Guarantee__c SpecGuarObj = TestDataFactory.createspecGuarnt(FAFObj.id,SpecPricObj.id);
            Specialty_Guarantee__c SpecGuarObj1 = TestDataFactory.createspecGuarnt(FAFObj1.id,SpecPricObj1.id);
            //Specialty_Guarantee__c SpecGuarObj2 = TestDataFactory.createspecGuarnt(FAFObj2.id,SpecPricObj2.id);
            specGuarlist.add(SpecGuarObj);
            specGuarlist.add(SpecGuarObj1);
            //specGuarlist.add(SpecGuarObj2);
            insert specGuarlist;
            SpecialtyGuaranteeTriggerHelper.validateTypeSubtypeCombination(specGuarlist,true,false);
            SpecialtyGuaranteeTriggerHelper.validateTypeSubtypeCombination(specGuarlist,false,true);
            test.stoptest();
        }
    }
    
     @isTest
    static void SpecialtyGuaranteeTriggerHelperMeth2()
    {
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
            Central_Hub__c FAFObj= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
             test.starttest();
            List<Specialty_Guarantee__c> specGuarlist=new List<Specialty_Guarantee__c>();
            //Create Guarantee Information Record 
            Specialty_Operations__c SpecOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert SpecOpsObj;
            
            Specialty_Pricing__c SpecPricObj = TestDataFactory.createspecPricingObject(FAFObj.id,SpecOpsObj.id);
            insert SpecPricObj;

            
            //Create Specialty Guarantee Record 
            Specialty_Guarantee__c SpecGuarObj = TestDataFactory.createspecGuarnt(FAFObj.id,SpecPricObj.id);
            Specialty_Guarantee__c SpecGuarObj1 = TestDataFactory.createspecGuarnt(FAFObj.id,SpecPricObj.id);

            
            specGuarlist.add(SpecGuarObj);
            specGuarlist.add(SpecGuarObj1);
            insert specGuarlist;
            
              
            SpecialtyGuaranteeTriggerHelper trhelperobj=new SpecialtyGuaranteeTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            SpecialtyGuaranteeTriggerHelper.validateTypeSubtypeCombination(specGuarlist,true,false);
            test.stoptest();
        }
    }
    
        
    //Method 1 to pass the parameters
    @isTest(SeeAllData=true)
    static void SpecialtyGuaranteeTriggerHelperMeth3()
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
            
            SpecGuarObj.Type__c='MER';
            update SpecGuarObj;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Specialty_Guarantee__c=true;
            delete SpecGuarObj;
            test.stoptest();
        }
    }
}