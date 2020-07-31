@isTest(seeAllData=true)
public with sharing class legalInfoTriggerHelperTest{
    static testmethod void legalInfoTriggerHelperMeth()
    {
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Legal_Information__c LegalInfoObj =  new Legal_Information__c();
            LegalInfoObj.FAF_ID__c= FAFObj.id;
            LegalInfoObj.Days_Written_Notice_Before_Termination__c='90';
            insert LegalInfoObj ;
            LegalInfoObj.Days_Written_Notice_Before_Termination__c='30';
            update LegalInfoObj;
            
            
            List<Legal_Information__c> LegalInfolist=new List<Legal_Information__c>();           
            LegalInfolist = [Select Id,FAF_ID__c,Days_Written_Notice_Before_Termination__c from Legal_Information__c];
            
            test.starttest();            
            legalInfoTriggerHelper.checkCountOnBeforeInsert(LegalInfolist);   
            
            Field_History_Tracking__c  fht= new Field_History_Tracking__c();
            fht.Legal_Information__c=true;
            delete LegalInfoObj;
            test.stoptest();
        }
    }
}