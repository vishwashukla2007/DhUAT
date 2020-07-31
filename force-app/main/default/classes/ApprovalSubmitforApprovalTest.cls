@isTest
private class ApprovalSubmitforApprovalTest{
    @isTest static void ApprovalSubmitforApprovalMethod() {
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Apttus_Approval__Approval_Request__c apttusApproval= new Apttus_Approval__Approval_Request__c();
            apttusApproval.Apttus_Approval__Object_Type__c='central_hub__c';
            apttusApproval.Assigned_User__c=useObj.id;
            //apttusApproval.Related_Account_LOB__c=FAFObj.LOB2__c;
            //apttusApproval.Related_Account__c=accObj; 005f4000002oJbJAAU 0050x000003gwcLAAQ 005f4000002oJbJAAU
            apttusApproval.Apttus_Approval__Assigned_To_Id__c=useObj.id;
            apttusApproval.Apttus_Approval__ObjectRefId__c=FAFObj.id;
            insert apttusApproval;
            
            List<id> idList = new List<id>();
            idList.add(apttusApproval.id);
            
            ApprovalSubmitforApproval.ApprovalSubmitforApproval(idList);
        }
    }
}