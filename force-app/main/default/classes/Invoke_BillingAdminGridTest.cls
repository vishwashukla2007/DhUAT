/* =================================================================================
* @Class Name        : Invoke_BillingAdminGridTest
* @author            : Parvathi Chunduri (parvathi.chunduri@cvshealth.com)
* @created date      : 02/19/2020
* @Purpose           : Test coverage for Invoke_BillingAdminGrid
=======================================================================================*/
@isTest
public class Invoke_BillingAdminGridTest{
   
    Static testmethod Void BillingAdminGrid(){
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.RunAs(useObjNew) {
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            FAFObj.FAF_Status__c = 'Uploaded';
            FAFObj.Template_340B_Display__c = true;
            FAFObj.Template_EGWPPMPM_Display__c = True;
            FAFObj.Template_Master_Electronic_Fee_Text__c = '';
            FAFObj.Template_Master_Manual_Claim_Fee_Text__c = '';
            FAFObj.Template_Master_340B_Type_Text__c =' ';
            insert FAFObj;
           
            FAFObj.FAF_Status__c = 'Uploaded'; 
            Update FAFObj;
            
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
                                    
            Billing_Administrative_Fees__c  billingAdmin = TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billingOps.id);
            billingAdmin.Base_Amount__c = 0;
            billingAdmin.LOB__c = 'STD';
            //billingAdmin.FAF_ID__c = cInfo.Id;
            billingAdmin.FAF_ID__c = FAFObj.ID;
            billingAdmin.Broker_Amount__c=5;
            billingAdmin.PCD_Manual_Claim_Fee__c= true;
            billingAdmin.PCD_Unique_340B_Fee_Type__c = True;
            billingAdmin.PCD_Unique_EGWPPMPM_Fee_Type__c=true;
            billingAdmin.PCD_Unique_Fee_Type__c = true;
            billingAdmin.PCD_Unique_Manual_Fee_Type__c = true;
            billingAdmin.Show_in_Grid__c = true;
            billingAdmin.Template_340B_Type_Text__c='';
            billingAdmin.Template_Admin_Fee_Type_Text__c='';
            billingAdmin.Template_EGWPPMPM_Fee_Type_Text__c='';
            billingAdmin.Template_Manual_Claim_Admin_Text__c='';
            insert billingAdmin;
            
            Test.startTest();
            Invoke_BillingAdminGrid.BillingAdminGrid(new List<id>{FAFObj.id});
            Test.stopTest();
        }       
        
    }
}