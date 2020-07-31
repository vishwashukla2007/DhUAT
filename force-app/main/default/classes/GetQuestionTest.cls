/* ================================================
     * @Class Name : GetQuestionTest
     * @author : John Paul Revilla
     * @Purpose: test class for getQuestions Class
     * @Parameters: NA
     * @return: Specialty Guarantee Object
     * @created date:01/18/2019
    ================================================*/
@isTest
 private class GetQuestionTest {
    @TestSetup
    static void setData(){
        list<PBM_Questions__c> pbmQuestionList = TestDataFactoryCLM.createPBMQuestions();
        insert pbmQuestionList;
    }
     
    @isTest static void getQuestionsPositive(){
      
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());
        
       System.runAs(u) {
            Test.startTest();
            List<string> questionsAPIName =new List<string>();
            for(PBM_Questions__c apiName : [Select Field_API__c from PBM_Questions__c]){
                questionsAPIName.add(apiName.Field_API__c+'-Empty');
            }
            system.debug(questionsAPIName);
            List<List<string>> testDataParam = New List<List<string>>();
            testDataParam.add(questionsAPIName);
            list<list<PBM_Questions__c>> getQuestOutput = getQuestion.getQuest(testDataParam);
            list<list<PBM_Questions__c>> getQuestOutput2 = getQuestionReq.getQuest(testDataParam);
            System.assertNotEquals(0, getQuestOutput.size());

            Test.stopTest();
       }   
    }
}