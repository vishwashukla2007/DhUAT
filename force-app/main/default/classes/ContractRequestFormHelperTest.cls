@isTest
public class ContractRequestFormHelperTest {

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
        Contract_Request_Form__c draftCrfObj = TestDataFactoryCLM.createCRF();
        draftCrfObj.Account__c = accObj.id;
        draftCrfObj.Opportunity_Name__c = oppObj.id;
        draftCrfObj.Performance_Guarantees__c = 'Performance Guarantees';
        draftCrfObj.CRF_Status__c = 'Draft';
        insert draftCrfObj;
        System.debug('draftCrfObj Id: ' + draftCrfObj.Id);
    }

    @isTest
    static void validateDraftContractRequestFormTest() {
        Account accObj =  [SELECT Id, Name FROM Account LIMIT 1];
        Opportunity oppObj = [SELECT Id, Name FROM Opportunity LIMIT 1];
        
        Contract_Request_Form__c submittedCrfObj = TestDataFactoryCLM.createCRF();
        submittedCrfObj.Account__c = accObj.id;
        submittedCrfObj.Opportunity_Name__c = oppObj.id;
        submittedCrfObj.Performance_Guarantees__c = 'Performance Guarantees';
        submittedCrfObj.CRF_Status__c = 'Draft';

        try {
            insert submittedCrfObj;
            System.debug('submittedCrfObj Id: ' + submittedCrfObj.Id);
        }catch(Exception error) {
            Boolean expectedExceptionThrown = error.getMessage().contains(System.Label.createCRFValidationCRFAlreadyCreated) ? true:false;
            System.assertEquals(true, expectedExceptionThrown);
        }
    }

    @isTest
    static void validateSubmittedContractRequestFormTest() {
        Account accObj =  [SELECT Id, Name FROM Account LIMIT 1];
        Opportunity oppObj = [SELECT Id, Name FROM Opportunity LIMIT 1];

        Contract_Request_Form__c updateCrfObj = [SELECT Id, Name, Opportunity_Name__c, CRF_Status__c FROM Contract_Request_Form__c];
        updateCrfObj.CRF_Status__c = 'Submitted';
        update updateCrfObj;

        Contract_Request_Form__c submittedCrfObj = TestDataFactoryCLM.createCRF();
        submittedCrfObj.Account__c = accObj.id;
        submittedCrfObj.Opportunity_Name__c = oppObj.id;
        submittedCrfObj.Performance_Guarantees__c = 'Performance Guarantees';
        submittedCrfObj.CRF_Status__c = 'Draft';

        try {
            insert submittedCrfObj;
            System.debug('submittedCrfObj Id: ' + submittedCrfObj.Id);
        }catch(Exception error) {
            Boolean expectedExceptionThrown = error.getMessage().contains(System.Label.createCRFValidationCRFAlreadySubmitted) ? true:false;
            System.assertEquals(true, expectedExceptionThrown);
        }
    }

}