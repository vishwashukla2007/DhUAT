@isTest
public with sharing class LegalOverrideEditNewClassTest{
    static testmethod void LegalOverrideEditNewClassMeth()
    {
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj)
        
        {
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Legal_Information__c LegalInfoObj =  new Legal_Information__c();
            LegalInfoObj.FAF_ID__c= FAFObj.id;
            LegalInfoObj.Days_Written_Notice_Before_Termination__c='90';
            LegalInfoObj.Term_Without_Cause__c='Yes';
            LegalInfoObj.Frequency_1__c='Anytime';
            LegalInfoObj.Contract_Review_Completed__c=true;
            insert LegalInfoObj ;
            //create standard contoller
            ApexPages.StandardController sc= new Apexpages.StandardController(LegalInfoObj);
            //set page parameter id value with legal info id
            Test.setCurrentPageReference(new PageReference('Page.myPage')); 
            System.currentPageReference().getParameters().put('id', LegalInfoObj.id);
            //initialize the controller constructor 
            LegalOverrideEditNewClass C1 = new LegalOverrideEditNewClass(sc);
           
             c1.DaysWrittenNotice=null;
            c1.LegalInfoChangeTypeField();
            c1.TermWithoutCause='No';
            c1.LegalInfoChangeTypeField();
            c1.changeContractReview();
        }
    }
}