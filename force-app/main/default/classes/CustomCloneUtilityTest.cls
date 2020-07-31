@isTest
public with sharing class CustomCloneUtilityTest{
    static testmethod void CustomCloneUtilityTestMeth1()
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
            Test.StartTest();
            CustomCloneUtility.customCloneMethod(billAdmObj);
            Test.StopTest();
        }
    }
}