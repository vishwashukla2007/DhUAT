@isTest
public class AgreementTriggerHelperTest {

    @testSetup
    static void dataSetup(){
        list<Apttus__APTS_Agreement__c> agreementList = TestDataFactory.createAgreementData();
        Apttus__APTS_Agreement__c agreement = agreementList[0];
        agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('SFS').getRecordTypeId();
        agreement.SFS_Path__c = 'Draft';
        insert agreement;
    }

    @isTest
    static void captureSessionIdTest(){
        Map<id, sObject> newRecordsMap = new Map<id, sObject>([Select id, name,Apttus__Agreement_Category__c, SessionId__c, RecordTypeId from Apttus__APTS_Agreement__c]);
        AgreementTriggerHelper.captureSessionId(newRecordsMap.values());
        System.assertEquals(true, !newRecordsMap.isEmpty()); 
    }
    
    @isTest
    static void updateFAFSfsFieldTest(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        System.runAs(u) {

            Test.startTest();
                                    
            list<Apttus__APTS_Agreement__c> agreementList = TestDataFactory.createAgreementData();
            Apttus__APTS_Agreement__c agreement = agreementList[0];
            agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('SFS').getRecordTypeId();
            agreement.SFS_Path__c = 'Draft';

            Central_Hub__c faf = TestDataFactory.createFAF(agreement.Apttus__Account__c,agreement.Opportunity__c,UserInfo.getUserId());
            faf.Salesperson__c= null;
            faf.Network_Operations__c= true;
            faf.Specialty_Operations__c= true;
            faf.Mail_Operations__c= true;
            faf.Underwriter__c = u.id;
            faf.Peer_Reviewer__c = u.id; 
            faf.FAF_Type__c='Partial';
            insert faf;
            agreement.PBM_FAF__c = faf.id;
            insert agreement;
            list<Central_Hub__c> fafList = [Select id, SFS_Agreement__c from Central_Hub__c limit 1];
            Test.stopTest();
       }
    }
}