@isTest
public class AccountTriggertest {

   static testMethod void validateNewAccount() {
           
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Coalition Member';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        	test.starttest();
        Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        insert clientINFO;      
        accObj.iUMS_Client_Subtype__c = 'Coalition Master';
        update accObj;
        test.stoptest();
    }
	
	/* ================================================
     * @Method Name : dataSetup
     * @author : Accenture
     * @Purpose: Test data setup 
     * @Parameters: NA
     * @return: Void
     * @created date:30/11/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
	@testSetup static void dataSetup(){
		User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
		
		List<User> userList = new List<User>();
		for(Integer i = 1;i<10;i++){
			User userObject = TestDataFactory.createUser('Apttus Underwriting');
			userObject.LastName = 'TestUser' + i;
			userObject.Email  = 'TestUser' + i + '@test.com';
			userList.add(userObject);
		}
        insert userList;
		
		List<User> userListOpp = new List<User>();
		for(Integer i = 1;i<5;i++){
			User userObject = TestDataFactory.createUser('Apttus Underwriting');
			userObject.LastName = 'TestUserOpp' + i;
			userObject.Email  = 'TestUserOpp' + i + '@test.com';
			userObject.Manager_Level_2__c = 'TestUser2';
			userObject.Manager_Level_3__c = 'TestUser3';
			userObject.Manager_Level_4__c = 'TestUser4';
			userObject.Manager_Level_5__c = 'TestUser5';
			userObject.Manager_Level_6__c = 'TestUser6';
			userObject.Manager_Level_7__c = 'TestUser7';
			userListOpp.add(userObject);
		}
        insert userListOpp;
		
		List<User> userListTeam = new List<User>();
		for(Integer i = 1;i<5;i++){
			User userObject = TestDataFactory.createUser('Apttus Sales');
			userObject.LastName = 'TestUserTeam' + i;
			userObject.Email  = 'TestUserTeam' + i + '@test.com';
			
			userListTeam.add(userObject);
		}
        insert userListTeam;
		
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
			accObj.iUMS_Client_Subtype__c = 'Stand-alone';
            insert accObj;
			List<AccountTeamMember> members = new list<AccountTeamMember>();
			Id teamId;
			
			for(Integer i = 1;i<5;i++){
				String lastname = 'TestUserTeam' + i;
				User user = [select id from User where LastName =: lastname];
				String teamMemberRole = 'Account Manager';
				members.add(New AccountTeamMember(AccountId = accObj.id, TeamMemberRole = teamMemberRole, UserId= user.id));
				teamId = user.id;
			}
			
			insert members;
			
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
			oppObj.Oppty_Winner__c = 'TestUserOpp1';
			oppObj.Med_D_Sales_Lead__c = 'TestUserOpp2';
            insert oppObj;
			
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
			Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
			
			central_Hub__share insertFAFShareObj = new central_Hub__share();
                                        insertFAFShareObj.AccessLevel = 'Edit';
                                        insertFAFShareObj.ParentId = FAFObj.id;
                                        insertFAFShareObj.RowCause = ConstantsUtil.Manual;
                                        insertFAFShareObj.UserOrGroupId = teamId;
                                        insert insertFAFShareObj;
		}
	}
	
	/* ================================================
     * @Method Name : AccountTriggertestMethod1
     * @author : Accenture
     * @Purpose: Test method to cover helper class
     * @Parameters: NA
     * @return: Void
     * @created date:30/11/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
	
	@isTest
    static void AccountTriggertestMethod1(){
		test.starttest();
		Account accObj = [select id,iUMS_Client_Subtype__c from Account where iUMS_Client_Subtype__c = 'Stand-alone'];
		accObj.iUMS_Client_Subtype__c = 'Coalition Master';
		update accObj;
		accObj.iUMS_Client_Subtype__c = 'Coalition Member';
		update accObj;
		test.stoptest();
		System.assertEquals(accObj.iUMS_Client_Subtype__c , 'Coalition Member'); 
	}
	
	/* ================================================
     * @Method Name : AccountTriggertestMethod2
     * @author : Accenture
     * @Purpose: Test method to cover helper class
     * @Parameters: NA
     * @return: Void
     * @created date:30/11/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
	@isTest
    static void AccountTriggertestMethod2(){
		test.starttest();
		Account accObj = [select id,iUMS_Client_Subtype__c from Account where iUMS_Client_Subtype__c = 'Stand-alone'];
		List<AccountTeamMember> members = [select id from AccountTeamMember where AccountId =: accObj.id]; 
		delete members;
		accObj.iUMS_Client_Subtype__c = 'Coalition Master';
		update accObj;
		accObj.iUMS_Client_Subtype__c = 'Coalition Member';
		update accObj;
		test.stoptest();
		System.assertEquals(accObj.iUMS_Client_Subtype__c , 'Coalition Member'); 
	}
}