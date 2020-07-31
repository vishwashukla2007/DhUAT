/* ===================================================================================================
     * @Class Name          : CentralHubShareModifyTriggerTest
     * @author              : Accenture
     * @Purpose             : Test Class to cover CentralHubShareModifyTriggerHelper class
     * @created date        : 12/10/2018
     * @Last modified date  : 12/10/2018
     * @Last modified by    : Accenture
    ==================================================================================================*/
@isTest
public class CentralHubShareModifyTriggerTest{
    @testSetup static void dataSetup(){
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        List<User> userList = new List<User>();
        for(Integer i = 1;i<3;i++){
            User userObject = TestDataFactory.createUser('Apttus Underwriting');
            userObject.LastName = 'TestUser' + i;
            userObject.Email  = 'TestUser' + i + '@test.com';
            userList.add(userObject);
        }
        insert userList;
        
        List<User> userListOpp = new List<User>();
        for(Integer i = 1;i<3;i++){
            User userObject = TestDataFactory.createUser('Apttus Sales');
            userObject.LastName = 'TestUserOpp' + i;
            userObject.Email  = 'TestUserOpp' + i + '@test.com';
            userListOpp.add(userObject);
        }
        insert userListOpp;
    
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            accObj.iUMS_Client_Subtype__c = 'Stand-alone';
            insert accObj;
            
            Opportunity oppObj1 = TestDataFactory.createOpportunity(accObj.id);
            oppObj1.Oppty_Winner__c = '';
            oppObj1.Med_D_Sales_Lead__c = '';
            insert oppObj1;
            
            Opportunity oppObj2 = TestDataFactory.createOpportunity(accObj.id);
            oppObj2.Oppty_Winner__c = 'TestUserOpp1';
            oppObj2.Med_D_Sales_Lead__c = 'TestUserOpp2';
            insert oppObj2;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj1.Id, useObjNew.id);
            insert FAFObj;
            
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj2.Id, useObjNew.id);
            insert FAFObj1;
            
            central_Hub__share insertFAFShareObj = new central_Hub__share();
            insertFAFShareObj.AccessLevel = 'Edit';
            insertFAFShareObj.ParentId = FAFObj.id;
            insertFAFShareObj.RowCause = ConstantsUtil.Manual;
            insertFAFShareObj.UserOrGroupId = userListOpp[0].id;
            insert insertFAFShareObj;
        }
    }
    
    /* ===============================================================================================
     * @Method Name         : centralHubShareModifyMethod1
     * @author              : Accenture
     * @Purpose             : Test method to cover helper class
     * @created date        : 12/10/2018
     * @Last modified date  : 12/10/2018
     * @Last modified by    : Accenture
    ==================================================================================================*/
    @isTest
    static void centralHubShareModifyMethod1(){
        test.starttest();
        central_hub__c fafObj = [select id, FAF_Status__c from central_hub__c where Med_D_Sales_Lead_Formula__c = '' limit 1];
        User useObj = [select id from user where name= 'TestUserOpp1'];
        Central_Hub_share_Modify__c chsm = new Central_Hub_share_Modify__c();
        chsm.FAF__c = fafObj.id;
        chsm.User__c = useObj.id;
        chsm.Record_Type__c = ConstantsUtil.DeleteStr;
        chsm.FAFShareId__c = 'Test';
        chsm.Name = 'Test';
        insert chsm;
        test.stoptest();
        system.assertEquals(fafObj.FAF_Status__c, 'Draft');
    }
    
    @isTest
    static void centralHubShareModifyMethod2(){
        test.starttest();
        central_hub__c fafObj = [select id, Med_D_Sales_Lead_Formula__c, Oppty_Winner_Formula__c, FAF_Status__c from central_hub__c where Med_D_Sales_Lead_Formula__c ='TestUserOpp2' limit 1];
        User useObj = [select id from user where name= 'TestUserOpp1'];
        User useObj1 = [select id from user where name= 'TestUserOpp2'];
        Central_Hub_share_Modify__c chsm = new Central_Hub_share_Modify__c();
        chsm.FAF__c = fafObj.id;
        chsm.User__c = useObj.id;
        chsm.Record_Type__c = ConstantsUtil.DeleteStr;
        chsm.FAFShareId__c = 'Test';
        chsm.Name = 'Test';
        insert chsm;
        
        Central_Hub_share_Modify__c chsm2 = new Central_Hub_share_Modify__c();
        chsm2.FAF__c = fafObj.id;
        chsm2.User__c = useObj1.id;
        chsm2.Record_Type__c = ConstantsUtil.DeleteStr;
        chsm2.FAFShareId__c = 'Test';
        chsm2.Name = 'Test';
        insert chsm2;
        test.stoptest();
        system.assertEquals(fafObj.FAF_Status__c, 'Draft');
    }
    
}