/*********************************************************************************************
 * @Test Class Name   : BillingOtherPaymentNewEditClassTest
 * @author            : Deepanakar(Accenture)
 * @created date      : 1/08/2018
 * @Last modified by  : Deepanakar(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the testclass for the class BillingOtherPaymentNewEditClass
 **********************************************************************************************/
@isTest
public with sharing class BillingOtherPaymentsTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void BillingOtherPaymentsTriggerHelperTestMeth1()
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
            
           List<Contractual_Payments__c > billoplist=new List<Contractual_Payments__c>();
            
            
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            Billing_Operations__c bilOpsObj2 = TestDataFactory.createBillOps(FAFObj2.id);
            insert bilOpsObj2;
            
             // Create Billing Other Payments record            
            Contractual_Payments__c billOthrPayObj = TestDataFactory.createBillOthrPaymnts(FAFObj.id,bilOpsObj.id);
            Contractual_Payments__c billOthrPayObj1 = TestDataFactory.createBillOthrPaymnts(FAFObj1.id,bilOpsObj1.id);
            Contractual_Payments__c billOthrPayObj2 = TestDataFactory.createBillOthrPaymnts(FAFObj2.id,bilOpsObj2.id);
            billoplist.add(billOthrPayObj);
            billoplist.add(billOthrPayObj1);
            billoplist.add(billOthrPayObj2);
            insert billoplist; 
            BillingOtherPaymentsTriggerHelper.validateLobYearCombinalion(billoplist,true,false);
            BillingOtherPaymentsTriggerHelper.validateLobYearCombinalion(billoplist,false,true); 
            test.stoptest();
        }
    }
    
    
    @isTest(SeeAllData=true)
    static void BillingOtherPaymentsTriggerHelperTestMeth2()
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
           //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
             // Create Billing Other Payments record            
            Contractual_Payments__c billOthrPayObj = TestDataFactory.createBillOthrPaymnts(FAFObj.id,bilOpsObj.id); 
            insert billOthrPayObj;
            
            billOthrPayObj.LOB2__c='CAP';
            update billOthrPayObj;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Contractual_Payments__c=true;
            
            delete billOthrPayObj;
            test.stoptest();
        }
    }
}