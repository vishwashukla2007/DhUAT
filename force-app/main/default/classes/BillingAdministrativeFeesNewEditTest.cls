/*********************************************************************************************
* @author   Priyanka Goyal
* @date     18 07 2018
* @description:This is the test class for BillingAdministrativeFeesNewEditClass        
**********************************************************************************************/

@isTest
public with sharing class BillingAdministrativeFeesNewEditTest{
    static testmethod void BillingAdministrativeFeesNewEditTestMeth1()
    {
        User useObj = TestDataFactoryForBilling.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactoryForBilling.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            Account accObj =  TestDataFactoryForBilling.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactoryForBilling.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactoryForBilling.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Billing_Operations__c billOpsObj =  TestDataFactoryForBilling.createBillOps(FAFObj.id);
            insert billOpsObj;
            Billing_Administrative_Fees__c billAdmObj =  TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert billAdmObj;
            //test.starttest();
            PageReference pageRef = Page.BillingAdministrativeFeesNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',billAdmObj.id);
            pageRef.getParameters().put(Label.BillingAdminFeesBillOps,billOpsObj.id);
            
            
            Rebate_Operations__c rebOpsObj = TestDataFactoryForBilling.createRebOps(FAFObj.id);
            rebOpsObj.Rebate_RTMD__c = true;
            insert rebOpsObj;
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            //Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
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
            
            insert clientINFO;
            
            ApexPages.StandardController sc = new ApexPages.standardController(billAdmObj);
            BillingAdministrativeFeesNewEditClass controller = new BillingAdministrativeFeesNewEditClass(sc);
            
            controller.saveUpdatebaf();
          //  controller.typeChangeAction();
            controller.FeeAdditiveAction();

            
      //test.stoptest();
        }
    }

    static testmethod void BillingAdministrativeFeesNewEditTestMeth2()
    {
        User useObj = TestDataFactoryForBilling.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactoryForBilling.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            Account accObj =  TestDataFactoryForBilling.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactoryForBilling.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactoryForBilling.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Billing_Operations__c billOpsObj =  TestDataFactoryForBilling.createBillOps(FAFObj.id);
            insert billOpsObj;
            Broker_TPA_Name_Support__c  brokertpaName=TestDataFactoryForBilling.createBrokersupport();
            insert brokertpaName;
            
            Billing_Broker_TPA_Payments__c brokerTPA =  TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,billOpsObj.id,brokertpaName.id);
            insert brokerTPA;
            
            Billing_Administrative_Fees__c billAdmObj =  TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert billAdmObj;
            
            Rebate_Operations__c rebOpsObj = TestDataFactoryForBilling.createRebOps(FAFObj.id);
            rebOpsObj.Rebate_RTMD__c = true;
            insert rebOpsObj;
            
            
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            //Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
            //                                 Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
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
            
            insert clientINFO;
            update billAdmObj;
            
            //test.starttest();
            PageReference pageRef = Page.BillingAdministrativeFeesNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.BillingAdminFeesBillOps,billOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(billAdmObj);
            BillingAdministrativeFeesNewEditClass controller = new BillingAdministrativeFeesNewEditClass(sc);

            //billOpsObj.Pharmacy_Audit_Retention__c = 'Premier (Custom)';
            //billOpsObj.Billing_Claim_Payment_Terms__c = '2 Days (Preferred)';
            //billOpsObj.Billing_Admin_Payment_Terms__c = '2 Days (Preferred)';
            //update billOpsObj;
            controller.saveUpdatebaf();
           // controller.typeChangeAction();
            controller.FeeAdditiveAction();
            controller.changeYearMeth();



            
            //test.stoptest();
        }
    }
    
    static testmethod void BillingAdministrativeFeesNewEditTestMeth3()
    {
        User useObj = TestDataFactoryForBilling.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactoryForBilling.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            Account accObj =  TestDataFactoryForBilling.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactoryForBilling.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactoryForBilling.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Billing_Operations__c billOpsObj =  TestDataFactoryForBilling.createBillOps(FAFObj.id);
            insert billOpsObj;
            
            Broker_TPA_Name_Support__c  brokertpaName=TestDataFactoryForBilling.createBrokersupport();
            insert brokertpaName;
            
            Billing_Broker_TPA_Payments__c brokerTPA =  TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,billOpsObj.id,brokertpaName.id);
            insert brokerTPA;
            
            Client_Information__c clientINFO= TestDataFactory.createClientInfo1(FAFObj.id);
            //Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
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
            insert clientINFO;
            
            clientINFO.Escalating_Pricing__c=false;
            update clientINFO;
            
            Billing_Administrative_Fees__c billAdmObj =  TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billOpsObj.id);
            insert billAdmObj;
            
            test.starttest();
            
            PageReference pageRef = Page.BillingAdministrativeFeesNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',billAdmObj.id);
            pageRef.getParameters().put(Label.BillingAdminFeesBillOps,billOpsObj.id);
            
            
           
            ApexPages.StandardController sc = new ApexPages.standardController(billAdmObj);
            BillingAdministrativeFeesNewEditClass controller = new BillingAdministrativeFeesNewEditClass(sc);
            system.debug('------------------checkClientYearCount---------------'+controller.checkClientYearCount);
            controller.saveUpdatebaf();
            controller.checkClientYearCount=null;
            //  controller.typeChangeAction();
            controller.FeeAdditiveAction();
            
            
          test.stoptest();
        }
    }
}