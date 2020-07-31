/*********************************************************************************************
 * @Test Class Name   : BillingOtherPaymentTriggerHelperTest
 * @author            : Deepankar(Accenture)
 * @created date      : 1/08/2018
 * @Last modified by  : Deepankar(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the testclass for the class BillingOtherPaymentTriggerHelper
 **********************************************************************************************/
@isTest
public with sharing class BillingOtherPaymentTriggerHelperTest{
    
    //Method 1 to pass the parameters
    @isTest
    static void BillingOtherPaymentTriggerHelperMeth1()
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
            
            List<Contractual_Payments__c> BillingOtherPaymentlist=new List<Contractual_Payments__c>();
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            Billing_Operations__c bilOpsObj2 = TestDataFactory.createBillOps(FAFObj2.id);
            insert bilOpsObj2;
            
            Broker_TPA_Name_Support__c  BillingOtherPaymentName=TestDataFactoryForBilling.createBrokersupport();
            insert BillingOtherPaymentName;
            
            
             // Create Billing Other Payments record            
            Contractual_Payments__c billOthrPayObj = TestDataFactoryForBilling.createBillOthrPaymnts(FAFObj.id,bilOpsObj .id,BillingOtherPaymentName.id);
            Contractual_Payments__c billOthrPayObj1 = TestDataFactoryForBilling.createBillOthrPaymnts(FAFObj1.id,bilOpsObj1.id,BillingOtherPaymentName.id);
            Contractual_Payments__c billOthrPayObj2 = TestDataFactoryForBilling.createBillOthrPaymnts(FAFObj2.id,bilOpsObj2.id,BillingOtherPaymentName.id);
            BillingOtherPaymentlist.add(billOthrPayObj);
            BillingOtherPaymentlist.add(billOthrPayObj1);
            BillingOtherPaymentlist.add(billOthrPayObj2);
            insert BillingOtherPaymentlist;
            BillingOtherPaymentsTriggerHelper.validateLobYearCombinalion(BillingOtherPaymentlist,true,false);
            BillingOtherPaymentsTriggerHelper.validateLobYearCombinalion(BillingOtherPaymentlist,false,true);
            test.stoptest();
        }
    }
    
    @isTest
    static void BillingOtherPaymentTriggerHelperMeth2()
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
            List<Contractual_Payments__c> billngotherPaymentList=new List<Contractual_Payments__c>();
            //Create Rebate Operations Record 
            //Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            //insert rebOpsObj;
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Broker_TPA_Name_Support__c  BillingOtherPaymentName=TestDataFactoryForBilling.createBrokersupport();
            insert BillingOtherPaymentName;
            
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Contractual_Payments__c RGCO = TestDataFactoryForBilling.createBillOthrPaymnts(FAFObj.id,bilOpsObj .id,BillingOtherPaymentName.id);
            Contractual_Payments__c RGCO1 = TestDataFactoryForBilling.createBillOthrPaymnts(FAFObj.id,bilOpsObj .id,BillingOtherPaymentName.id);

            
            billngotherPaymentList.add(RGCO);
            billngotherPaymentList.add(RGCO1);
            insert billngotherPaymentList; 
            
              
            BillingOtherPaymentsTriggerHelper trhelperobj=new BillingOtherPaymentsTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            BillingOtherPaymentsTriggerHelper.validateLobYearCombinalion(billngotherPaymentList,true,false);
            test.stoptest();
        }
    }
}