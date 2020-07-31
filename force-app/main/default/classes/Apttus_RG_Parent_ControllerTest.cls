@isTest
public class Apttus_RG_Parent_ControllerTest {
  
      static testmethod void RebateGuaranteeNewEditClassTestMeth1()
    {
         string fieldName = Label.rebateOperationLabel;
        User useObj = ClientTestRef.createuwUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = ClientTestRef.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;

            Rebate_Operations__c rebOpsObj1 = ClientTestRef.createRebOps1(FAFObj.id);
            insert rebOpsObj1;
            
            Rebate_Guarantees__c rebateGuarantees = ClientTestRef.createRebateGuarantee(FAFObj.id,rebOpsObj1.id);
            insert rebateGuarantees;
          	
            List<Rebate_Guarantees__c> rebateList = new List<Rebate_Guarantees__c>();
            rebateList.add(rebateGuarantees);
            
            test.starttest();
            Apttus_RG_Parent_Controller.getRebateGuarantee(rebOpsObj1.id);
            Apttus_RG_Parent_Controller.avoidAccessForSalesUser();
            Apttus_RG_Parent_Controller.deleteSelectedRecords(rebateList);
            test.stoptest();
        }
    }
    
    

}