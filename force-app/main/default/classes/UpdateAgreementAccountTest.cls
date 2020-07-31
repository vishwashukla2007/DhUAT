@isTest
 private class UpdateAgreementAccountTest {
    /* 
    @TestSetup
    static void setData(){
        list<Apttus__APTS_Agreement__c> agreementList = TestDataFactoryCLM.createAgreementData();
        insert agreementList;
    }
    @isTest static void updateAgreementAccountSuccess(){
      
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());
        
       System.runAs(u) {
           Test.startTest();
               Apttus__APTS_Agreement__c agreement = [Select id, Apttus__Account__c, Apttus__Account__r.Name from Apttus__APTS_Agreement__c LIMIT 1];
               String agreementAcctString = agreement.id + '-' + agreement.Apttus__Account__c;
               string acctname = agreement.Apttus__Account__r.Name.toUpperCase();
               if(acctname.length() > 20){
                   acctname = agreement.Apttus__Account__r.Name.substring(0,20).toUpperCase();
               }
               List<string> agreementAcctList =new List<string>();
               agreementAcctList.add(agreementAcctString);
               
               List<List<string>> testDataParam = New List<List<string>>();
               testDataParam.add(agreementAcctList);
               updateAgreementAccount.updateAgreeAcct(testDataParam);
               agreement = [Select Name from Apttus__APTS_Agreement__c LIMIT 1];
               System.assertEquals(true, agreement.Name.toUpperCase().contains(acctname));             
           Test.stopTest();
       }   
    }
	*/
}