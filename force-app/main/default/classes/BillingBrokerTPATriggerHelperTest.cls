/*********************************************************************************************
 * @Test Class Name   : BillingBrokerTPATriggerHelperTest
 * @author            : Deepanakar(Accenture)
 * @created date      : 1/08/2018
 * @Last modified by  : Deepanakar(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the testclass for the class BillingBrokerTPATriggerHelper
 **********************************************************************************************/
    @isTest
    public with sharing class BillingBrokerTPATriggerHelperTest{
        
        
        //Method 1 to pass the parameters
        @isTest
        static void BillingBrokerTPATriggerHelperMeth1()
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
                
                List<Billing_Broker_TPA_Payments__c > billBrokList=new List<Billing_Broker_TPA_Payments__c >();
                //Create Billing Operations Record 
                Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
                insert bilOpsObj;
                
                Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
                insert bilOpsObj1;
                
                Billing_Operations__c bilOpsObj2 = TestDataFactory.createBillOps(FAFObj2.id);
                insert bilOpsObj2;
                
                Broker_TPA_Name_Support__c  brokertpaName=TestDataFactoryForBilling.createBrokersupport();
                insert brokertpaName;
                
                
                 // Create Billing Other Payments record            
                Billing_Broker_TPA_Payments__c  billbrokerTPAObj = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,bilOpsObj .id,brokertpaName.id);
                Billing_Broker_TPA_Payments__c  billbrokerTPAObj1 = TestDataFactoryForBilling.createBrokerTPA(FAFObj1.id,bilOpsObj1.id,brokertpaName.id);
                Billing_Broker_TPA_Payments__c  billbrokerTPAObj2 = TestDataFactoryForBilling.createBrokerTPA(FAFObj2.id,bilOpsObj2.id,brokertpaName.id);
                billBrokList.add(billbrokerTPAObj);
                billBrokList.add(billbrokerTPAObj1);
                billBrokList.add(billbrokerTPAObj2);
                insert billBrokList;
                BillingBrokerTPATriggerHelper.validateLobYearCombinalion(billBrokList,true,false);
                BillingBrokerTPATriggerHelper.validateLobYearCombinalion(billBrokList,false,true);
                test.stoptest();
            }
        }
        
        @isTest
        static void BillingBrokerTPATriggerHelperMeth2()
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
                List<Billing_Broker_TPA_Payments__c > billBrokList=new List<Billing_Broker_TPA_Payments__c >();
                //Create Rebate Operations Record 
                //Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
                //insert rebOpsObj;
                
                //Create Billing Operations Record 
                Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
                insert bilOpsObj;
                
                Broker_TPA_Name_Support__c  brokertpaName=TestDataFactoryForBilling.createBrokersupport();
                insert brokertpaName;
                
                //Create Rebate Gtees Specialty Class Carve Outs Record 
                Billing_Broker_TPA_Payments__c  RGCO = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,bilOpsObj .id,brokertpaName.id);
                Billing_Broker_TPA_Payments__c  RGCO1 = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,bilOpsObj .id,brokertpaName.id);

                
                billBrokList.add(RGCO);
                billBrokList.add(RGCO1);
                insert billBrokList;
                
                  
                BillingBrokerTPATriggerHelper trhelperobj=new BillingBrokerTPATriggerHelper();
                //trhelperobj.rebateOpsIdSet.add();
                BillingBrokerTPATriggerHelper.validateLobYearCombinalion(billBrokList,true,false);
                test.stoptest();
            }
        }
        
         @isTest(SeeAllData=true)
        static void BillingBrokerTPATriggerHelperMeth3()
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
                //Create Rebate Operations Record 
                //Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
                //insert rebOpsObj;
                
                //Create Billing Operations Record 
                Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
                insert bilOpsObj;
                
                Broker_TPA_Name_Support__c  brokertpaName=TestDataFactoryForBilling.createBrokersupport();
                insert brokertpaName;
                
                //Create Rebate Gtees Specialty Class Carve Outs Record 
                Billing_Broker_TPA_Payments__c  RGCO = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,bilOpsObj .id,brokertpaName.id);
                insert RGCO;
                
                RGCO.LOB2__c='CAP';
                update RGCO;
                
                Field_History_Tracking__c fht=new Field_History_Tracking__c();
                fht.Retail_Network_Guarantees__c=true;
                
                delete RGCO;
                test.stoptest();
            }
        }
    }