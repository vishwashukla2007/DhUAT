@isTest
public class FAFInfoEditButtonTest {
    @testSetup 
    static void dataSetup() {
        
        
        
      	User salesperson1 = ClientTestRef.createUser('Apttus Sales');
        salesperson1.FirstName = 'salesperson1';
        salesperson1.alias = 'FAFInfoE';
        insert salesperson1;
        
        User salesperson2 = ClientTestRef.createUser('Apttus Sales');
        salesperson2.firstName = 'salesperson2';
        salesperson2.alias = 'FAFInfoE';
        salesperson2.ManagerId = salesperson1.id;
        insert salesperson2;
        
        
       
        String S1Name = [SELECT Name FROM user WHERE id =:salesperson1.id].name;
        list<user> userList = new list<user>();
        User salesperson3 = ClientTestRef.createUser('Apttus Sales');
        salesperson3.firstName = 'salesperson3';
        salesperson3.alias = 'FAFInfoE';
        salesperson3.Manager_Level_2__c = S1Name;
        userList.add(salesperson3);
        
        
        User salesperson4 = ClientTestRef.createUser('Apttus Sales');
        salesperson4.firstName = 'salesperson4';
        salesperson4.alias = 'FAFInfoE';
        salesperson4.Manager_Level_3__c = S1Name;
        userList.add(salesperson4);
        
        User salesperson5 = ClientTestRef.createUser('Apttus Sales');
        salesperson5.firstName = 'salesperson5';
        salesperson5.alias = 'FAFInfoE';
        salesperson5.Manager_Level_4__c = S1Name;
        userList.add(salesperson5);
        
        User salesperson6 = ClientTestRef.createUser('Apttus Sales');
        salesperson6.firstName = 'salesperson6';
        salesperson6.alias = 'FAFInfoE';
        salesperson6.Manager_Level_5__c = S1Name;
        userList.add(salesperson6);
        
        User salesperson7 = ClientTestRef.createUser('Apttus Sales');
        salesperson7.firstName = 'salesperson7';
        salesperson7.alias = 'FAFInfoE';
        salesperson7.Manager_Level_6__c = S1Name;
        userList.add(salesperson7);
        
        User salesperson8 = ClientTestRef.createUser('Apttus Sales');
        salesperson8.firstName = 'salesperson8';
        salesperson8.alias = 'FAFInfoE';
        salesperson8.Manager_Level_7__c = S1Name;
        userList.add(salesperson8);
        
        insert userList;
        /*
        User salesperson5 = ClientTestRef.createUser('Apttus Sales');
        salesperson5.Manager_Level_4__c = S2Name;
        insert salesperson5;
        
        User salesperson6 = ClientTestRef.createUser('Apttus Sales');
        salesperson6.Manager_Level_5__c = S2Name;
        insert salesperson6;
        
        User salesperson7 = ClientTestRef.createUser('Apttus Sales');
        salesperson7.Manager_Level_6__c = S2Name;
        insert salesperson7;
        
        User salesperson8 = ClientTestRef.createUser('Apttus Sales');
        salesperson8.Manager_Level_7__c = S2Name;
        insert salesperson8;
                
        boolean result = false;
		*/
        
    }
	@isTest 
    static void checkPBMCustomPermission() {
        //String fafId = [SELECT id FROM Central_Hub__c LIMIT 1 ].id;
        list<User> users = [SELECT id, Name FROM user WHERE alias = 'FAFInfoE' ORDER BY FirstName ASC];
        //User u2 = [SELECT id, Name FROM user WHERE FirstName = 'salesperson2'];
        //User u3 = [SELECT id, Name FROM user WHERE FirstName = 'salesperson3'];
        //User u4 = [SELECT id, Name FROM user WHERE FirstName = 'salesperson4'];
        
        Test.startTest(); 
        	//result = FAFInfoEditButton.checkPBMCustomPermission(fafId);
        	FAFInfoEditButton fafinfo = new FAFInfoEditButton();
        	fafinfo.flag = false;
        	System.runas(users[0]){
                Account accObj =  ClientTestRef.createAccount();
                insert accObj;
                
                Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
                insert oppObj;
                
                list<Central_Hub__c> fafObjList = new list<Central_Hub__c>();
                Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[0].Id);
                fafObjList.add(fafObj);
                Central_Hub__c fafObj1 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[1].Id);
                fafObjList.add(fafObj1);
                Central_Hub__c fafObj2 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[2].Id);
                fafObjList.add(fafObj2);
                Central_Hub__c fafObj3 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[3].Id);
                fafObjList.add(fafObj3);
                Central_Hub__c fafObj4 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[4].Id);
                fafObjList.add(fafObj4);
                Central_Hub__c fafObj5 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[5].Id);
                fafObjList.add(fafObj5);
                Central_Hub__c fafObj6 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[6].Id);
                fafObjList.add(fafObj6);
                Central_Hub__c fafObj7 = ClientTestRef.createFAF(accObj.id, oppObj.Id, users[7].Id);
                fafObjList.add(fafObj7);
                
                insert fafObjList;
                
            	Boolean result = FAFInfoEditButton.createapproval(fafObjList[0].id);
            	Boolean result1 = FAFInfoEditButton.createapproval(fafObjList[1].id);
            	Boolean result2 = FAFInfoEditButton.createapproval(fafObjList[2].id);
            	Boolean result3 = FAFInfoEditButton.createapproval(fafObjList[3].id);
            	Boolean result4 = FAFInfoEditButton.createapproval(fafObjList[4].id);
            	Boolean result5 = FAFInfoEditButton.createapproval(fafObjList[5].id);
            	Boolean result6 = FAFInfoEditButton.createapproval(fafObjList[6].id);
            	Boolean result7 = FAFInfoEditButton.createapproval(fafObjList[7].id);
                Boolean result8 = FAFInfoEditButton.checkPBMCustomPermission(fafObjList[7].id);
        	}
        	
        Test.stopTest();
    }
}