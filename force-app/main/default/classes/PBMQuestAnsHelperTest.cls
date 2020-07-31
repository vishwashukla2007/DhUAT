@isTest 
public class PBMQuestAnsHelperTest {

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
        Client_Information__c clientInfoObj = TestDataFactory.createClientInfo(fafObj.id); 
        insert clientInfoObj;
        List<Apttus__APTS_Agreement__c> agreeementList = TestDataFactoryCLM.createAgreementData();
        For (Apttus__APTS_Agreement__c agreeement: agreeementList) {
            agreeement.PBM_FAF__c = fafObj.Id;
        }
        insert agreeementList;
        PBS_Agreement_Extension__c agreementExtension = TestDataFactoryCLM.createAgreementExtension(agreeementList[0].Id);
        insert agreementExtension;
        
        //Create Questions
        List<PBM_Questions__c> pbmQuestions = TestDataFactoryCLM.createPBMQuestions();
        insert pbmQuestions;
        
        
        //Create Questions Answer
        List<PBM_Questions_Answers__c> questionsAnswers = TestDataFactoryCLM.createQuestionsAnswers(agreeementList[0].Id);
        questionsAnswers[0].Field_API__c = 'Pharmacy_Audit_Retention__c';
        insert questionsAnswers;
        
    }

    @isTest 
    static void updatePBMExtensionNullAnswer() {
        List<PBM_Questions_Answers__c> arguments = [SELECT Id, Agreement__c, Answer__c, PBM_Question__c, Field_API__c FROM PBM_Questions_Answers__c];
      
        Test.startTest(); 
            
        	arguments[0].Field_API__c = 'Pharmacy_Audit_Retention__c';
            arguments[0].Answer__c = 'Base (80/20)';
        	PBMQuestAnsHelper.updateObjects(arguments);
        
        	arguments[0].Field_API__c = 'Client_Share__c';
            arguments[0].Answer__c = '20';
        	PBMQuestAnsHelper.updateObjects(arguments);
        
        	arguments[0].Field_API__c = 'Pharmacy_Audit_Retention__c';
            arguments[0].Answer__c = 'Base (100/0)';
        	PBMQuestAnsHelper.updateObjects(arguments);
        
        	arguments[0].Field_API__c = 'Pharmacy_Audit_Retention__c';
            arguments[0].Answer__c = 'Premier (75/25)';
        	PBMQuestAnsHelper.updateObjects(arguments);
        
        	arguments[0].Field_API__c = 'Pharmacy_Audit_Retention__c';
            arguments[0].Answer__c = 'Premier (75/25)';
        	PBMQuestAnsHelper.updateObjects(arguments);
        	
       		arguments[0].Field_API__c = 'Contract_Effective_Date__c';
        	arguments[0].Answer__c = string.valueOf(system.today());
        	PBMQuestAnsHelper.updateObjects(arguments);
        
        	arguments[0].Field_API__c = 'Contract_End_Date__c';
        	arguments[0].Answer__c = string.valueOf(system.today());
        	PBMQuestAnsHelper.updateObjects(arguments);
        
        	update arguments;
        Test.stopTest();
        
    }
	
}