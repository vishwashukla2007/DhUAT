/*********************************************************************************************
 * @Test Class Name   : BillingOtherPaymentNewEditClassTest
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 18/07/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the testclass for the class BillingOtherPaymentNewEditClass
 **********************************************************************************************/
@isTest
public with sharing class BillingOtherPaymentNewEditClassTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void BillingOtherPaymentNewEditClassTestMeth1()
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
             // Create Billing Other Payments record            
            Contractual_Payments__c billOthrPayObj = TestDataFactory.createBillOthrPaymnts(FAFObj.id,bilOpsObj.id);
            insert billOthrPayObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAdministrativeFeesNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',billOthrPayObj.id);
            pageRef.getParameters().put(Label.BillingOthrPaymentBillingOp,bilOpsObj.id);
                        
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            
            clientINFO.Contract_End_Date__c = date.today() + 1;
            insert clientINFO;
            
            system.debug(' clientINFO.Contract_End_Date__c = date.today() + 1'+clientINFO.Contract_End_Date__c);
    
            ApexPages.StandardController sc = new ApexPages.standardController(bilOpsObj);
            BillingOtherPaymentNewEditClass  controller = new BillingOtherPaymentNewEditClass (sc);
            controller.checkClientYearCount.clear();
            ApexPages.StandardController sc1 = new ApexPages.standardController(bilOpsObj);
            BillingOtherPaymentNewEditClass  controller1 = new BillingOtherPaymentNewEditClass (sc1);
            controller1.operationType='CLONE'; 
            controller.saveUpdateBOP();
            test.stoptest();
        }
    }
    
     //Method 2 to pass the parameters
    @isTest
    
     static void BillingOtherPaymentNewEditClassTestMeth2()
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
             // Create Billing Other Payments record            
            Contractual_Payments__c billOthrPayObj = TestDataFactory.createBillOthrPaymnts(FAFObj.id,bilOpsObj.id);
            insert billOthrPayObj;
            
            Central_Hub__c FAFObj2= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            Client_Information__c clientINFO = TestDataFactory.createClientInfo(FAFObj.id);
            //Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Contract_End_Date__c from
             //                                Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            
            clientINFO.Contract_End_Date__c = date.today() + 1;
            insert clientINFO;
    
            //Pass the parameters from the VF page
           // test.starttest();
            PageReference pageRef = Page.BillingOtherPaymentNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.BillingOthrPaymentBillingOp,bilOpsObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(bilOpsObj);
            BillingOtherPaymentNewEditClass  controller1 = new BillingOtherPaymentNewEditClass (sc);
                  
            controller1.saveUpdateBOP();
            controller1.cancel();
           // test.stoptest();
        }
    } 
     @isTest
    static void BillingOtherPaymentsTriggerHelperTestMeth3()
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
            
             Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
             insert clientINFO;
            
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
            
            ApexPages.StandardController sc = new ApexPages.standardController(bilOpsObj);
            BillingOtherPaymentNewEditClass  controller = new BillingOtherPaymentNewEditClass (sc);
            controller.operationType = 'clone';

            controller.saveUpdateBOP();
            test.stoptest();
        }
    }  

    }