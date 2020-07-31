/*********************************************************************************************
* @author   Deepankar
* @date     08  01 2018
* @description:This is the testclass for the classRebateGteesCarveOutsNewEditClassTest        
 **********************************************************************************************/
@isTest
public with sharing class RebtGtesSpecClassTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void RebtGtesSpecClassTriggerHelperTestMeth1()
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
            
           /*Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            //Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            //insert FAFObj2;
            
            //FAFObj2.LOB2__c='EGFI';
            //Update FAFObj2;
            */
             test.starttest();
            List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> gterssCarveOutList=new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            //Rebate_Operations__c rebOpsObj1 = TestDataFactory.createRebOps(FAFObj1.id);
            //insert rebOpsObj1;
            
            //Rebate_Operations__c rebOpsObj2 = TestDataFactory.createRebOps(FAFObj2.id);
            //insert rebOpsObj2;
                      
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO1 = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            //Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO2 = TestDataFactory.createGtees(rebOpsObj2.id,FAFObj2.id);
            //insert RGCO;
            
            gterssCarveOutList.add(RGCO);
            gterssCarveOutList.add(RGCO1);
            //gterssCarveOutList.add(RGCO2);
            insert gterssCarveOutList;
            
            //Central_Hub__c FAFObj2a= TestDataFactory.createFAF2(accObj.id, oppObj.Id, useObjNew.id);
            //insert FAFObj2a;
            
    
            //Pass the parameters from the VF page
            
              
            RebtGtesSpecClassTriggerHelper trhelperobj=new RebtGtesSpecClassTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            RebtGtesSpecClassTriggerHelper.validateLobYearDrugTheraphyCombinalion(gterssCarveOutList,true,false);
            test.stoptest();
        }
    }

    //Method 2 to pass the parameters
    @isTest
    static void RebtGtesSpecClassTriggerHelperTestMeth2()
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
            
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
            
             test.starttest();
            List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> gterssCarveOutList=new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            Rebate_Operations__c rebOpsObj1 = TestDataFactory.createRebOps(FAFObj1.id);
            insert rebOpsObj1;
            
            Rebate_Operations__c rebOpsObj2 = TestDataFactory.createRebOps(FAFObj2.id);
            insert rebOpsObj2;
                      
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO1 = TestDataFactory.createGtees(rebOpsObj1.id,FAFObj1.id);
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO2 = TestDataFactory.createGtees(rebOpsObj2.id,FAFObj2.id);
           // insert RGCO;
            
            gterssCarveOutList.add(RGCO);
            gterssCarveOutList.add(RGCO1);
            gterssCarveOutList.add(RGCO2);
            insert gterssCarveOutList;
            
            //Central_Hub__c FAFObj2a= TestDataFactory.createFAF2(accObj.id, oppObj.Id, useObjNew.id);
            //insert FAFObj2a;
            
    
            //Pass the parameters from the VF page
            
              
            RebtGtesSpecClassTriggerHelper trhelperobj=new RebtGtesSpecClassTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            RebtGtesSpecClassTriggerHelper.validateLobYearDrugTheraphyCombinalion(gterssCarveOutList,true,false);
            RebtGtesSpecClassTriggerHelper.validateLobYearDrugTheraphyCombinalion(gterssCarveOutList,false,true);
            test.stoptest();
        }
    }


}