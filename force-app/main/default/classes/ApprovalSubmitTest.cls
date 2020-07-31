@isTest
private class ApprovalSubmitTest{
    @isTest static void ApprovalSubmitTestMethod() {
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
            
            List<id> idList = new List<id>();
            idList.add(FAFObj.id);
            
            ApprovalSubmit.ApprovalSubmit(idList);
            }
    }
}