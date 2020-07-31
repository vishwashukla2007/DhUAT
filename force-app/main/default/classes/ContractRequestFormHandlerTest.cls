@isTest
public class ContractRequestFormHandlerTest {

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
    static void beforeInsertTest(){
        Map<id, sObject> newRecordsMap = new Map<id, sObject>([SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c]);
        ContractRequestFormHandler.beforeInsert(newRecordsMap.values(), newRecordsMap);
        System.assertEquals(true, !newRecordsMap.isEmpty()); 
    }

    @isTest
    static void afterInsertTest(){
        Map<id, sObject> newRecordsMap = new Map<id, sObject>([SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c]);
        ContractRequestFormHandler.afterInsert(newRecordsMap.values(), newRecordsMap);
        System.assertEquals(true, !newRecordsMap.isEmpty()); 
    }

    @isTest
    static void beforeUpdateTest(){
        Map<id, sObject> newRecordsMap = new Map<id, sObject>([SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c]);
        Map<id, sObject> oldRecordsMap = new Map<id, sObject>([SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c]);
        ContractRequestFormHandler.beforeUpdate(newRecordsMap, oldRecordsMap);
        System.assertEquals(true, !newRecordsMap.isEmpty()); 
        System.assertEquals(true, !oldRecordsMap.isEmpty()); 
    }

    @isTest
    static void afterUpdateTest(){
        Map<id, sObject> newRecordsMap = new Map<id, sObject>([SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c]);
        Map<id, sObject> oldRecordsMap = new Map<id, sObject>([SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c]);
        ContractRequestFormHandler.afterUpdate(newRecordsMap, oldRecordsMap);
        System.assertEquals(true, !newRecordsMap.isEmpty()); 
        System.assertEquals(true, !oldRecordsMap.isEmpty()); 
    }

}