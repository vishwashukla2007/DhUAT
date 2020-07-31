/*********************************************************************************************
* @author   Deepankar
* @date     08 01 2018
* @description:This is the testclass for RebateGuaranteeTriggerHelper         
 **********************************************************************************************/
 
@isTest
public with sharing class RebateGuaranteeTriggerHelperTest{
    
     @isTest
    static void RebateGuaranteeTriggerHelperMeth1()
    {    string fieldName = Label.rebateOperationLabel;
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            //Create CentralHub Record 
             Central_Hub__c FAFObj= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
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
            
            
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            Rebate_Operations__c rebOpsObj1 = TestDataFactory.createRebOps(FAFObj1.id);
            insert rebOpsObj1;
            
            Rebate_Operations__c rebOpsObj2 = TestDataFactory.createRebOps(FAFObj2.id);
            insert rebOpsObj2;
            
            
             
            List<Rebate_Guarantees__c> rbglist= new List<Rebate_Guarantees__c>();
            Rebate_Guarantees__c rebateGuarantees1 = TestDataFactory.createRebateGuarantee(FAFObj.id,rebOpsObj.id);
            Rebate_Guarantees__c rebateGuaranteesSame = TestDataFactory.createRebateGuarantee(FAFObj.id,rebOpsObj.id);
            Rebate_Guarantees__c rebateGuarantees2 = TestDataFactory.createRebateGuarantee(FAFObj1.id,rebOpsObj1.id);
            Rebate_Guarantees__c rebateGuarantees3 = TestDataFactory.createRebateGuarantee(FAFObj2.id,rebOpsObj2.id);
            rbglist.add(rebateGuarantees1);
            rbglist.add(rebateGuarantees2);
            rbglist.add(rebateGuarantees3);
            rbglist.add(rebateGuaranteesSame);
            insert rbglist;
            test.starttest(); 
            List<Rebate_Guarantees__c> rbglist1  =[select ID,FAF_ID__c,Rebate_Operations__c,Year__c,Basis__c,LOB2__c,GSTP__c,Non_Specialty_Formulary_2__c,
                     Plan_Design__c,Specialty_Formulary__c from Rebate_Guarantees__c];
            //rebateGuaranteeTriggerHelper tprObject=new RebateGuaranteeTriggerHelper();
            RebateGuaranteeTriggerHelper.validateLobYearBasisCombination(rbglist1,true,false);
            RebateGuaranteeTriggerHelper.validateLobYearBasisCombination(rbglist1,false,true);
            test.stoptest();
                //System.assertEquals(FAFObj.LOB2__c, 'EGFI');
                System.assertNotEquals(rbglist1.isEmpty(), true);
        }
    }
    
     @isTest(seeAllData=true)
     static void RebateGuaranteeTriggerHelperMeth2()  
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
            //Create CentralHub Record 
             Central_Hub__c FAFObj= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
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
            
            
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            List<Rebate_Guarantees__c> rbglist= new List<Rebate_Guarantees__c>();
            Rebate_Guarantees__c rebateGuarantees1 = TestDataFactory.createRebateGuarantee(FAFObj.id,rebOpsObj.id);
            insert rebateGuarantees1;
            
            
            
            rebateGuarantees1.LOB2__c ='CAP';
            update rebateGuarantees1;
            
            Field_History_Tracking__c fht= new Field_History_Tracking__c();
            fht.Rebate_Guarantees__c=true;
            
            delete rebateGuarantees1;
            
        }
    }
    
}