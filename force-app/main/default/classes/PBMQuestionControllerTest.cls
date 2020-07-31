@isTest
public class PBMQuestionControllerTest {

    @testSetup 
    static void dataSetup() {
        List<PBM_Questions__c> pbmQuestions = TestDataFactoryCLM.createPBMQuestions();
        insert pbmQuestions;
    }

    @isTest 
    static void getQuestion() {
        PBM_Questions__c result = new PBM_Questions__c();
        PBM_Questions__c pbmQuestion = [SELECT Id FROM PBM_Questions__c WHERE Data_Type__c = 'Text' LIMIT 1];
        Test.startTest(); 
        result = pbmQuestionController.getQuestion(pbmQuestion.Id);
        Test.stopTest();
        System.assert(result.Field_API__c == 'ERISA_NON_ERISA__c');
    }

    @isTest 
    static void getPicklistOptions() {
        List<String> result = new List<String>();
        PBM_Questions__c pbmQuestion = [SELECT Id, Field_API__c, Object_API__c, Data_Type__c FROM PBM_Questions__c WHERE Data_Type__c = 'Picklist' LIMIT 1];
        Test.startTest(); 
        result = pbmQuestionController.getPicklistOptions(pbmQuestion.Field_API__c, pbmQuestion.Object_API__c);
        Test.stopTest();
        System.assert(!result.isEmpty());
    }
 
}