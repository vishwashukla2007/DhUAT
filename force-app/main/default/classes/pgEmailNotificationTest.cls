@istest
public without sharing class pgEmailNotificationTest {
    @testSetup 
    static void dataSetup() {
        //Create users
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = userInfo.getUserName();
        salesperson.Manager_Level_3__c = userInfo.getUserName();
        salesperson.Manager_Level_4__c = userInfo.getUserName();
        salesperson.Manager_Level_5__c = userInfo.getUserName();
        salesperson.ManagerId = userInfo.getUserId();
        update salesperson;
        User paralegal = ClientTestRef.createUser('Apttus Operations');
        paralegal.User_Grouping__c = 'Paralegal';
        insert paralegal;
        User atty = ClientTestRef.createUser('Apttus Operations');
        atty.User_Grouping__c = 'Attorney';
        insert atty;
        
        //Create Account
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        
        //Create Opportunity
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        //Create FAF
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        
        //Create billing ops
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(fafObj.id);
        insert billOpsObj;
        
        list<Billing_Operations__c> billlist = fafObj.Billing_Ops__r;
        
        List<Apttus__APTS_Agreement__c> agreeementList = TestDataFactoryCLM.createAgreementData();
        insert agreeementList;    
      
        Performance_Guarantees__c pgObj = new Performance_Guarantees__c();
        pgObj.Client_Agreement_Name__c  = 'test';
        pgObj.Total_Amount_at_Risk__c = 0;
        pgObj.FAF__c = fafObj.id;
        insert pgObj;
    }
    @isTest 
    static void pgEmailTest() {
        Performance_Guarantees__c pg = [select id from Performance_Guarantees__c limit 1];
        list<id> pgList = new List<id>();
        pgList.add(pg.id);
        Test.startTest(); 
        pgEmailNotification.pgEmail(pgList);
        System.assertNotEquals(null, pg.id);
        Test.stopTest();
    }
    
}