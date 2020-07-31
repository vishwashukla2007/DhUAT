/*********************************************************************************************
 * @Test Class Name   : ASPGuaranteeTriggerHelperTest
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 07/08/2018
 * @Purpose           : This is the testclass for the class ASPGuaranteeTriggerHelper
 **********************************************************************************************/
@isTest
public with sharing class ASPGuaranteeTriggerHelperTest{
    
    //Method 1 to pass the parameters
    @isTest
    static void ASPGuaranteeTriggerHelperMeth1()
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
            List<Gnc_Guarantee__c> GuarInfolist=new List<Gnc_Guarantee__c>();
            //Create Guarantee Information Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj; 
            /*
            Guarantees_Information__c GuarInfoObj1 = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj1;
            
            Guarantees_Information__c GuarInfoObj2 = TestDataFactory.createGuaranteeInfo(FAFObj2.id);
            insert GuarInfoObj2;            
            */ 
             // Create ASP Guarantee record            
            Gnc_Guarantee__c ASPGuarObj = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,GuarInfoObj .id);
            Gnc_Guarantee__c ASPGuarObj1 = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,GuarInfoObj.id);
            //Gnc_Guarantee__c ASPGuarObj2 = TestDataFactory.createASPGuaranteeInfo(FAFObj2.id,GuarInfoObj2.id);
            GuarInfolist.add(ASPGuarObj);
            GuarInfolist.add(ASPGuarObj1);
            //GuarInfolist.add(ASPGuarObj2);
            insert GuarInfolist;
            
            ASPGuaranteeTriggerHelper.validateLobYearCombination(GuarInfolist,true,false);
            ASPGuaranteeTriggerHelper.validateLobYearCombination(GuarInfolist,false,true);
            test.stoptest();
            
        }
    } 
    
     @isTest(SeeAllData=true)
    static void ASPGuaranteeTriggerHelperMeth2()
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
            List<Gnc_Guarantee__c> GuarInfolist=new List<Gnc_Guarantee__c>();
            //Create Guarantee Information Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj; 
            
             // Create ASP Guarantee record            
            Gnc_Guarantee__c ASPGuarObj = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,GuarInfoObj .id);
            insert ASPGuarObj;
            
            ASPGuarObj.LOB__c='CAP';
            update ASPGuarObj;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Gnc_Guarantee__c=true;
            delete ASPGuarObj;
            test.stoptest();
            
        }
    } 
}