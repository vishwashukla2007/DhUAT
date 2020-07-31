/*********************************************************************************************
 * @Test Class Name   : TrendGuaranteeTriggerHelperTest
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 08/08/2018
 * @Purpose           : This is the testclass for the class TrendGuaranteeTriggerHelper
 **********************************************************************************************/
 @isTest
public with sharing class TrendGuaranteeTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void TrendGuaranteeTriggerHelperMeth1()
    {
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            //test.starttest();
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
            //test.stoptest();
            /*
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
           
            
            //test.stoptest();*/
            test.starttest();
            List<Trend_Guarantee__c> TrendGuarInfolist=new List<Trend_Guarantee__c>();
            //Create Guarantee Information Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj;
            /*
            Guarantees_Information__c GuarInfoObj1 = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj1;
            
            Guarantees_Information__c GuarInfoObj2 = TestDataFactory.createGuaranteeInfo(FAFObj2.id);
            insert GuarInfoObj2;            
            */
             // Create Trend Guarantee record            
            Trend_Guarantee__c TrendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,GuarInfoObj.id);
            Trend_Guarantee__c TrendGuarObj1 = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,GuarInfoObj.id);
            //ASP_Guarantee__c ASPGuarObj2 = TestDataFactory.createASPGuaranteeInfo(FAFObj2.id,GuarInfoObj2.id);
            TrendGuarInfolist.add(TrendGuarObj);
            TrendGuarInfolist.add(TrendGuarObj1);
            //TrendGuarInfolist.add(TrendGuarObj2);
            insert TrendGuarInfolist;
            
            TrendGuaranteeTriggerHelper.validateLobYearCombination(TrendGuarInfolist,true,false);
            TrendGuaranteeTriggerHelper.validateLobYearCombination(TrendGuarInfolist,false,true);
            test.stoptest();
            
        }
    }



 //Method 2 to pass the parameters
    @isTest
    static void TrendGuaranteeTriggerHelperMeth2()
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
            
            List<Trend_Guarantee__c> TrendGuarInfolist=new List<Trend_Guarantee__c>();
            //Create Guarantee Information Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj;
            
            Guarantees_Information__c GuarInfoObj1 = TestDataFactory.createGuaranteeInfo(FAFObj1.id);
            insert GuarInfoObj1;
            
            Guarantees_Information__c GuarInfoObj2 = TestDataFactory.createGuaranteeInfo(FAFObj2.id);
            insert GuarInfoObj2;
            
             // Trend Guarantee record            
            Trend_Guarantee__c TrendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,GuarInfoObj.id);
            Trend_Guarantee__c TrendGuarObj1 = TestDataFactory.createTrendGuaranteeInfo(FAFObj1.id,GuarInfoObj1.id);
            Trend_Guarantee__c TrendGuarObj2 = TestDataFactory.createTrendGuaranteeInfo(FAFObj2.id,GuarInfoObj2.id);
            TrendGuarInfolist.add(TrendGuarObj);
            TrendGuarInfolist.add(TrendGuarObj1);
            TrendGuarInfolist.add(TrendGuarObj2);
            insert TrendGuarInfolist;
            TrendGuaranteeTriggerHelper.validateLobYearCombination(TrendGuarInfolist,true,false);
            test.stoptest();
        }
    }
    
     //Method 2 to pass the parameters
    @isTest(SeeAllData=true)
    static void TrendGuaranteeTriggerHelperMeth3()
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
            
            List<Trend_Guarantee__c> TrendGuarInfolist=new List<Trend_Guarantee__c>();
            //Create Guarantee Information Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj;
            
             // Trend Guarantee record            
            Trend_Guarantee__c TrendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,GuarInfoObj.id);
            insert TrendGuarObj;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Trend_Guarantee__c=true;
            
            delete TrendGuarObj;
            test.stoptest();
        }
    }
}