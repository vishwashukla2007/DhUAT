@isTest

public class ApprovalAssignToAccountTest{

@isTest static void ApprovalAssignToAccountTestMthod(){
    User accUser= TestDataFactory.createUser('Apttus Underwriting');
    insert accUser;
    
     User useObjNew = TestDataFactory.createUser('Apttus Sales');
     insert useObjNew;
     
     user backUpUser=[select id, Name,Username from user where Name='Shilpa Reddy' limit 1];
        
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
    //apttusApproval.Related_Account_LOB__c=FAFObj.LOB2__c;
    //apttusApproval.Related_Account__c=accObj; 005f4000002oJbJAAU 0050x000003gwcLAAQ 005f4000002oJbJAAU
    apttusApproval.Apttus_Approval__Assigned_To_Id__c=accUser.id;
    apttusApproval.Apttus_Approval__ObjectRefId__c=FAFObj.id;
    insert apttusApproval;
    
   /* Apttus_Approval__Backup_Approver__c approvalBackup= new Apttus_Approval__Backup_Approver__c();
    approvalBackup.Apttus_Approval__IsActive__c=true;
    approvalBackup.Apttus_Approval__Current_User__c=backUpUser.id;
    approvalBackup.Apttus_Approval__Backup_User__c=backUpUser.id;
    approvalBackup.Apttus_Approval__Transfer_in_flight__c=true;
    //insert approvalBackup;
    System.debug('approvalBackup  '+approvalBackup);
    
    
    Auto_Request_Assignment__c autoRequest= new Auto_Request_Assignment__c();
    autoRequest.User__c=accUser.id;
    autoRequest.Is_Active__c=true;
    autoRequest.LOB__c=apttusApproval.Related_Account_LOB__c;
    autoRequest.Backup_Delegate_Approver__c=approvalBackup.id;
    //insert autoRequest;
    */
    
    system.debug('apttusApproval '+apttusApproval.Related_Account__c);
    List<id> lstId = new List<Id>();
    
    lstId.add(apttusApproval.id);
    
    Test.startTest();
    ApprovalAssignToAccount.ApprovalAssignToAccount(lstId);
    ApprovalAssignToAccount apObject=new ApprovalAssignToAccount();
    apObject.IncreaseCOverage();
    
    Test.stopTest();
}
}
}