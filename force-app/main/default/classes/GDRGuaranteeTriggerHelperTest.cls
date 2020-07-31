/*********************************************************************************************
 * @Test Class Name   : GDRGuaranteeTriggerHelperTest
 * @author            : Shivani Saxena(Accenture)
 * @created date      : 09/14/2018
 * @Purpose           : This is the testclass for the class GDRGuaranteeTriggerHelper
 **********************************************************************************************/
 @isTest
public with sharing class GDRGuaranteeTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void GDRGuaranteeTriggerHelperMeth1()
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
            List<GDR_Guarantee__c> GDRGuarInfolist=new List<GDR_Guarantee__c>();
            //Create Guarantee Information Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj;
            /*
            Guarantees_Information__c GuarInfoObj1 = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj1;
            
            Guarantees_Information__c GuarInfoObj2 = TestDataFactory.createGuaranteeInfo(FAFObj2.id);
            insert GuarInfoObj2;            
            */
             // Create GDR Guarantee record            
            GDR_Guarantee__c GDRGuarObj = TestDataFactory.createGdrGuarantee(FAFObj.id,GuarInfoObj.id);
            GDR_Guarantee__c GDRGuarObj1 = TestDataFactory.createGdrGuarantee(FAFObj.id,GuarInfoObj.id);
            //ASP_Guarantee__c ASPGuarObj2 = TestDataFactory.createASPGuaranteeInfo(FAFObj2.id,GuarInfoObj2.id);
            GDRGuarInfolist.add(GDRGuarObj);
            GDRGuarInfolist.add(GDRGuarObj1);
            //GDRGuarInfolist.add(GDRGuarObj2);
            insert GDRGuarInfolist;
            
            GDRGuaranteeTriggerHelper.validateTypeCombination(GDRGuarInfolist,true,false);
            GDRGuaranteeTriggerHelper.validateTypeCombination(GDRGuarInfolist,false,true);
            test.stoptest();
            
        }
    }



 //Method 2 to pass the parameters
    @isTest
    static void GDRGuaranteeTriggerHelperMeth2()
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
            
            List<GDR_Guarantee__c> GDRGuarInfolist=new List<GDR_Guarantee__c>();
            //Create Billing Operations Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj;
            
            Guarantees_Information__c GuarInfoObj1 = TestDataFactory.createGuaranteeInfo(FAFObj1.id);
            insert GuarInfoObj1;
            
            Guarantees_Information__c GuarInfoObj2 = TestDataFactory.createGuaranteeInfo(FAFObj2.id);
            insert GuarInfoObj2;
            
            // Broker_TPA_Name_Support__c  BillingOtherPaymentName=TestDataFactoryForBilling.createBrokersupport();
            //insert BillingOtherPaymentName;
            
            
             // Create Billing Other Payments record            
            GDR_Guarantee__c GDRGuarObj = TestDataFactory.createGdrGuarantee(FAFObj.id,GuarInfoObj.id);
            GDR_Guarantee__c GDRGuarObj1 = TestDataFactory.createGdrGuarantee(FAFObj1.id,GuarInfoObj1.id);
            GDR_Guarantee__c GDRGuarObj2 = TestDataFactory.createGdrGuarantee(FAFObj2.id,GuarInfoObj2.id);
            GDRGuarInfolist.add(GDRGuarObj);
            GDRGuarInfolist.add(GDRGuarObj1);
            GDRGuarInfolist.add(GDRGuarObj2);
            insert GDRGuarInfolist;
            GDRGuaranteeTriggerHelper.validateTypeCombination(GDRGuarInfolist,true,false);
            //GDRGuaranteeTriggerHelper.validateTypeCombination(BillingOtherPaymentlist,false,true);
            test.stoptest();
        }
    }
    
     @isTest(seeAllData=true)
    static void GDRGuaranteeTriggerHelperMeth3()
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
            
            List<GDR_Guarantee__c> GDRGuarInfolist=new List<GDR_Guarantee__c>();
            //Create Billing Operations Record 
            Guarantees_Information__c GuarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuarInfoObj;
            
             // Create Billing Other Payments record            
            GDR_Guarantee__c GDRGuarObj = TestDataFactory.createGdrGuarantee(FAFObj.id,GuarInfoObj.id);
            insert GDRGuarObj;
            
            GDRGuarObj.Guarantee_Type__c='Retail';
            update GDRGuarObj;
            
            Field_History_Tracking__c fht= new Field_History_Tracking__c();
            fht.GDR_Guarantee__c=true;
            delete GDRGuarObj;
            //GDRGuaranteeTriggerHelper.validateTypeCombination(BillingOtherPaymentlist,false,true);
            test.stoptest();
        }
    }
}