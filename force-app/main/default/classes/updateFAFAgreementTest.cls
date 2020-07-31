@isTest
public class updateFAFAgreementTest {
	@testSetup 
    static void dataSetup() {
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = userInfo.getUserName();
        salesperson.Manager_Level_3__c = userInfo.getUserName();
        salesperson.Manager_Level_4__c = userInfo.getUserName();
        salesperson.Manager_Level_5__c = userInfo.getUserName();
        salesperson.ManagerId = userInfo.getUserId();
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        list<Apttus__APTS_Agreement__c> agreementList = TestDataFactoryCLM.createAgreementData();
        Apttus__APTS_Agreement__c agreement = agreementList[0];
        agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('SFS').getRecordTypeId();
        agreement.SFS_Path__c = 'Draft';
        agreement.PBM_FAF__c = fafObj.id;
        insert agreement;
        
        list<Apttus__APTS_Agreement__c> agreementList2 = TestDataFactoryCLM.createAgreementData();
        Apttus__APTS_Agreement__c agreement2 = agreementList2[0];
        agreement2.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
        agreement2.PBM_FAF__c = fafObj.id;
        insert agreement2;

        Client_Information__c clientInfoObj = TestDataFactory.createClientInfo(fafObj.id); 
        insert clientInfoObj;
        List<Apttus__APTS_Agreement__c> agreeementList = TestDataFactoryCLM.createAgreementData();
        For (Apttus__APTS_Agreement__c agreeement: agreeementList) {
            agreeement.PBM_FAF__c = fafObj.Id;
        }
        insert agreeementList;

    }
   //Commented out the method due to SFS not being moved to production for jun 4 deployment - JP Revilla 25/05/202
    // @isTest 
    // static void updateFAFAgreementTestMethod() {
    //     Test.startTest();
    //         Central_Hub__c updtFAF = [SELECT id, Master_Agreement__c FROM Central_Hub__c LIMIT 1];
    //         Apttus__APTS_Agreement__c updtAgree = [SELECT id FROM Apttus__APTS_Agreement__c WHERE recordType.Name = 'Legal' LIMIT 1];
    //         if(updtFAF != null && updtAgree != null){
    //             String FAFagreement_str = updtFAF.id + '-' + updtAgree.id;
    //             List<string> FAFagreementList = new List<string>();
    //             FAFagreementList.add(FAFagreement_str);
                
    //             List<List<string>> testDataParam = New List<List<string>>();
    //             testDataParam.add(FAFagreementList);
                
    //             updateFAFAgreement.updateFAFAgree(testDataParam);
    //         }           
    //     Test.stopTest();
    // }
}