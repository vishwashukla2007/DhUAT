@isTest
public class lookupfieldControllerTest {
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
    }
    
    @isTest 
    static void GetRecentRecords() {
        List<sObject> retObj = new List<sObject>();
        String ObjectName = 'Account';
        List<String> ReturnFields = new list<String>{'Name'};
        Integer MaxResults = 1;
        Test.startTest(); 
        	retObj = lookupfieldController.GetRecentRecords(ObjectName,ReturnFields,MaxResults);
        Test.stopTest();
    }
    
    @isTest 
    static void SearchRecords() {
        List<sObject> retObj = new List<sObject>();
        String ObjectName = 'Account';
        List<String> ReturnFields = new list<String>{'Name'}; 
        List<String> QueryFields = new list<String>{'Name'};
        String SearchText = 'Test';
        String SortColumn = 'Name';
        String SortOrder = 'ASC';
        Integer MaxResult = 1;
        Test.startTest(); 
        	retObj = lookupfieldController.SearchRecords(ObjectName,ReturnFields,QueryFields,SearchText,SortColumn,SortOrder,MaxResult);
        Test.stopTest();
    }
    
     @isTest 
    static void GetRecord() {
        List<sObject> retObj = new List<sObject>();
        String ObjectName = 'Account';
        List<String> ReturnFields = new list<String>{'Name'};
        Account accOBj = [SELECT id FROM Account LIMIT 1]; 
        String Id =  accObj.Id;
        Test.startTest(); 
        	retObj = lookupfieldController.GetRecord(ObjectName,ReturnFields,Id);
        Test.stopTest();
    }
    
    @isTest 
    static void getObjectDetails() {
        String ObjectName = 'Account'; 
        lookupfieldController.objectDetails retObj =  new lookupfieldController.objectDetails();
        Test.startTest(); 
        	retObj = lookupfieldController.getObjectDetails(ObjectName);
        Test.stopTest();
    }
}