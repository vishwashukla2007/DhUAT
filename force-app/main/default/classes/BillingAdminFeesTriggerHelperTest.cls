@isTest
public with sharing class BillingAdminFeesTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void BillingAdminFeesTriggerHelperMeth1()
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
            
            List<Billing_Administrative_Fees__c> BillingAdminFeeslist=new List<Billing_Administrative_Fees__c>();
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            Billing_Operations__c bilOpsObj2 = TestDataFactory.createBillOps(FAFObj2.id);
            insert bilOpsObj2;
            
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
           
            
             // Create Billing Other Payments record            
            Billing_Administrative_Fees__c BillAdminFeeObj = TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            Billing_Administrative_Fees__c BillAdminFeeObj1 = TestDataFactoryForBilling.createBillAdminFees(FAFObj1.id,bilOpsObj1.id);
            Billing_Administrative_Fees__c BillAdminFeeObj2 = TestDataFactoryForBilling.createBillAdminFees(FAFObj2.id,bilOpsObj2.id);
            BillingAdminFeeslist.add(BillAdminFeeObj);
            BillingAdminFeeslist.add(BillAdminFeeObj1);
            BillingAdminFeeslist.add(BillAdminFeeObj2);
            insert BillingAdminFeeslist;
            BillingAdminFeesTriggerHelper.validateLobYearCombinalion(BillingAdminFeeslist,true,false);
            BillingAdminFeesTriggerHelper.validateLobYearCombinalion(BillingAdminFeeslist,false,true);
            BillingAdminFeesTriggerHelper.updateancillaryRec(BillingAdminFeeslist);
            test.stoptest();
        }
    }
    
    @isTest
    static void BillingAdminFeesTriggerHelperMeth2()
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
            List<Billing_Administrative_Fees__c> BillingAdminFeeslist=new List<Billing_Administrative_Fees__c>();
            //Create Rebate Operations Record 
            //Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            //insert rebOpsObj;
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Billing_Administrative_Fees__c RGCO = TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,bilOpsObj .id);
            Billing_Administrative_Fees__c RGCO1 = TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,bilOpsObj .id);

            
            BillingAdminFeeslist.add(RGCO);
            BillingAdminFeeslist.add(RGCO1);
            insert BillingAdminFeeslist;
            
              
            BillingAdminFeesTriggerHelper trhelperobj=new BillingAdminFeesTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            BillingAdminFeesTriggerHelper.validateLobYearCombinalion(BillingAdminFeeslist,true,false);
            BillingAdminFeesTriggerHelper.updateancillaryRec(BillingAdminFeeslist);
            test.stoptest();
        }
    }
    
    @isTest(SeeAllData=true)
    static void BillingAdminFeesTriggerHelperMeth3()
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Billing_Administrative_Fees__c RGCO = TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,bilOpsObj .id);
            insert RGCO;
            
            test.starttest();
            RGCO.LOB__c='CAP';
            update RGCO;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Billing_Administrative_Fees__c=true;
            
            delete RGCO;            
            test.stoptest();
        }
    }
}