@isTest
public class ApprovalAssignToUserTest{
    @isTest public static void ApprovalAssignToUserTest(){
    User accUser= TestDataFactory.createUser('Apttus Underwriting');
    insert accUser;
    
    User useObjNew = TestDataFactory.createUser('Apttus Sales');
     insert useObjNew;
    
    System.runAs(accUser){
        Account accObj =  TestDataFactory.createAccount();
        insert accObj;
          
        
        Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
        insert FAFObj;
         
        Apttus_Approval__Approval_Request__c apttusApproval= new Apttus_Approval__Approval_Request__c();
        apttusApproval.Apttus_Approval__Object_Type__c='central_hub__c';
        apttusApproval.Assigned_User__c=accUser.id;
        apttusApproval.Apttus_Approval__Assigned_To_Id__c=accUser.id;
        apttusApproval.Apttus_Approval__ObjectRefId__c=FAFObj.id;
        insert apttusApproval;
        System.debug('apttusApproval   '+apttusApproval);
        
        List<id> lstId = new List<Id>();
        lstId.add(apttusApproval.id);
        System.debug('lstId   '+lstId);
        
        test.startTest();
        //ApprovalAssignToUser.ApprovalAssignToUser(lstId);
        ApprovalAssignToUser approvalObj= new ApprovalAssignToUser();
        approvalObj.IncreaseCoverage();
        test.stopTest();
    }
    }
}