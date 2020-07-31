@isTest
public class AssignSalesPermissionTest {
    
    static testmethod void AssignSalesPermissionTestMethod(){
        //user and faf insert
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        
       //To insert permission set
        PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
        system.runAs(salesperson){
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = salesperson.Id;
        psa.PermissionSetId = pss.Id;
        insert psa;
        }
        //start test
        test.startTest();
        AssignSalesPermission batchAssign =new AssignSalesPermission();
        database.executeBatch(batchAssign);
        test.stopTest();
        //end of test


    }
    //another method
    static testmethod void AssignSalesPermissionTestMethod1(){
        //user and faf insert
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        
       //insert permission set
        PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
        system.runAs(salesperson){
        PermissionSetAssignment psa = new PermissionSetAssignment();
      
        }
        //start test
        test.startTest();
        AssignSalesPermission batchAssign =new AssignSalesPermission();
        database.executeBatch(batchAssign);
        AssignSalesPermissionSchedule sb=new AssignSalesPermissionSchedule();
        String sch = '0 0 2 * * ?';

        system.schedule('Test Territory Check', sch, sb);

        test.stopTest();
        //end of test
    }
}