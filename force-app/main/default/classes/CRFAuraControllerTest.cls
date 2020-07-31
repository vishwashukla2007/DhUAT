@isTest 
public class CRFAuraControllerTest {
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
        accObj.Name = 'Crazy dog jump over the lazy fox';
        update accObj;
        
        //Create Opportunity
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
         //Create FAF
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        
        //Create Agreement 1.
        List<Apttus__APTS_Agreement__c> agreementList = TestDataFactoryCLM.createAgreementData();
        For (Apttus__APTS_Agreement__c agreement: agreementList) {
            agreement.PBM_FAF__c = fafObj.Id;
            agreement.Attorney__c = atty.id;
            agreement.Paralegal__c = paralegal.id;
            agreement.Name = 'test agreement for batch job test class';
            agreement.FAF_Data_Sync__c = true;
            agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
        }
        insert agreementList;
        
        //Create CRF
        Contract_Request_Form__c CRFObj = TestDataFactoryCLM.createCRF();
        CRFObj.Account__c = accObj.id;
        CRFObj.Attorney__c = atty.id;
        CRFObj.Paralegal__c = paralegal.id;
        CRFObj.Legal_Agreement__c = agreementList[0].id;
        CRFObj.Opportunity_Name__c = oppObj.id;
        
        CRFObj.Performance_Guarantees__c = 'Performance Guarantees';
        insert CRFObj;
    }
    
    @isTest 
    static void getCRFAuraWrapperMethod() {
        Opportunity opp = [SELECT id FROM Opportunity LIMIT 1];
        Contract_Request_Form__c CRF = [SELECT id FROM Contract_Request_Form__c LIMIT 1];
        Test.startTest();
        	CRFAuraController.CRFAuraWrapper CRFwrapperTest = CRFAuraController.getCRFAuraWrapper(opp.id);
        	CRFAuraController.submitCRFRequest(CRF.id);
        
        	
            CRF.CRF_Status__c = 'Submitted';
        	CRF.Effective_Date_of_Contract_or_Amendment__c = null;
        	CRF.Term_of_Contract__c = null;
        	CRF.Attorney__c = null;
        	CRF.Paralegal__c = null;
        	CRFAuraController.submitCRFRequest(CRF.id);
        	CRFAuraController.validateCRFRequiredFields(CRF);
        Test.stopTest();
    }
    
}