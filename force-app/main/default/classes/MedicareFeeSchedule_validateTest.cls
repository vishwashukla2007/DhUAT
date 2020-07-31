/*********************************************************************************************
 * @Test Class Name   : BillingOtherPaymentNewEditClassTest
 * @author            : Deepanakar(Accenture)
 * @created date      : 1/08/2018
 * @Last modified by  : Deepanakar(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the testclass for the class BillingOtherPaymentNewEditClass
 **********************************************************************************************/
@isTest
public with sharing class MedicareFeeSchedule_validateTest{
    @isTest(SeeAllData=true)
    static void MedicareFeeSchedule_validateTestM1()
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
            Medicare_Part_D_Fees_Schedule__c   medD = TestDataFactory.createMedifeescheduled(bilOpsObj.id, FAFObj.id); 
            insert medD;
            
            medD.PATH__c='Test v1';
            update medD;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Medicare_Part_D_Fees_Schedule__c=true;
            
            delete medD;
            test.stoptest();
        }
    }
}