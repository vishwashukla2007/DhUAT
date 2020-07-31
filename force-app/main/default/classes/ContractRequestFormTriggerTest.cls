@isTest
public class ContractRequestFormTriggerTest {

    @testSetup
    static void dataSetup(){
        //Create Account
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        accObj.Name = 'Crazy dog jump over the lazy fox';
        update accObj;

        //Create Opportunity
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;

        //Create CRF
        Contract_Request_Form__c crfObj = TestDataFactoryCLM.createCRF();
        crfObj.Account__c = accObj.id;
        crfObj.Opportunity_Name__c = oppObj.id;
        crfObj.Performance_Guarantees__c = 'Performance Guarantees';
        insert crfObj;
        System.debug('CRF Id: ' + crfObj.Id);
    }

    @isTest
    static void runTest(){
        Test.startTest();
        Contract_Request_Form__c crfRecord = [SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c LIMIT 1];
        crfRecord.CRF_Status__c = 'Submitted';
        update crfRecord;
        System.assertEquals(true, crfRecord.CRF_Status__c.contains('Submitted'));
        Test.stopTest();
    }

}