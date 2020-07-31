@isTest
public class UpdateEscalationDaysTriggerTest {
	@testSetup 
    static void dataSetup() {
        //Create Account
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        
        Case cs = new Case(Status ='Draft', Priority = 'Medium', Origin = 'Email', AccountId=accObj.id, Request_Due_Date__c = system.today().addDays(7), Business_Type__c = 'New', CAG__c = 'test'); 
        insert cs;
    }
    
    @isTest 
    static void UpdateEscalationDaysTriggerTestMethod() {
        case tcase = [SELECT id FROM case LIMIT 1];
        Test.startTest();
        	update tcase;
        Test.stopTest();
    }
}