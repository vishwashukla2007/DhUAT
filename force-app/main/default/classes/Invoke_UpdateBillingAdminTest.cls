/* =================================================================================
* @Class Name        : Invoke_UpdateBillingAdminTest
* @author            : Parvathi Chunduri (parvathi.chunduri@cvshealth.com)
* @created date      : 02/18/2020
* @Purpose           : Test coverage for Invoke_UpdateBillingAdmin
=======================================================================================*/
@isTest
public class Invoke_UpdateBillingAdminTest {
    
    Static testmethod Void UpdateBillingAdmin(){
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.RunAs(useObjNew) {
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            FAFObj.FAF_Status__c = 'Uploaded';
            insert FAFObj;
            
            Client_Information__c cInfo = TestDataFactory.createClientInfo(FAFObj.id);
            cInfo.Escalating_Pricing__c = true;
            cInfo.Year_1__c = '1';
            cInfo.Year_1_Begin_Date__c = System.today();
            cInfo.Year_1_End_Date__c = System.today()+10;
            cInfo.Year_2__c = '2';
            cInfo.Year_2_Begin_Date__c = cInfo.Year_1_End_Date__c+1;
            cInfo.Year_2_End_Date__c = cInfo.Year_1_End_Date__c+10;        
            cInfo.Year_3__c = '3';
            cInfo.Year_3_Begin_Date__c =cInfo.Year_2_End_Date__c+1;
            cInfo.Year_3_End_Date__c = cInfo.Year_2_End_Date__c+10;        
            cInfo.Year_4__c = '4';
            cInfo.Year_4_Begin_Date__c = cInfo.Year_3_End_Date__c+1;
            cInfo.Year_4_End_Date__c = cInfo.Year_3_End_Date__c+10;        
            cInfo.Year_5__c = '5';
            cInfo.Year_5_Begin_Date__c = cInfo.Year_4_End_Date__c+1;
            cInfo.Year_5_End_Date__c = cInfo.Year_4_End_Date__c+10;
            cInfo.Contract_Effective_Date__c = System.today();
            cInfo.Contract_End_Date__c = System.today()+100;
            insert cInfo;
            
            Test.startTest();
            
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            System.debug('Value of billingOps from Test Class is ' + billingOps);
            
            List<Billing_Administrative_Fees__c> lstBillingAdminFees = new List<Billing_Administrative_Fees__c>();
            Billing_Administrative_Fees__c  billingAdmin = TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billingOps.id);
            
            billingAdmin.Admin_Fee_Type__c= 'Retail Per Claim' ;
            // billingAdmin.Total__c = 0;
            billingAdmin.Base_Amount__c = 0;
            billingAdmin.LOB__c = 'STD';
            //billingAdmin.FAF_ID__c = cInfo.Id;
            billingAdmin.FAF_ID__c = FAFObj.ID;
            billingAdmin.Broker_Amount__c=5;
            billingAdmin.PCD_Manual_Claim_Fee__c=false;
            billingAdmin.PCD_Unique_340B_Fee_Type__c=false;
            billingAdmin.PCD_Unique_EGWPPMPM_Fee_Type__c=false;
            billingAdmin.PCD_Unique_Fee_Type__c=false;
            billingAdmin.PCD_Unique_Manual_Fee_Type__c=false;
            billingAdmin.PCD_Unique_340B_Fee_Type__c = true;
            billingAdmin.PCD_Unique_EGWPPMPM_Fee_Type__c = true;
            billingAdmin.Template_EGWPPMPM_Fee_Type_Text__c = billingAdmin.Admin_Fee_Type__c;
            billingAdmin.Show_in_Grid__c=true;
            billingAdmin.Template_340B_Type_Text__c='';
            billingAdmin.Template_Admin_Fee_Type_Text__c='';
            billingAdmin.Template_EGWPPMPM_Fee_Type_Text__c='';
            billingAdmin.Template_Manual_Claim_Admin_Text__c='';
            billingAdmin.Year_Start_Date__c=Date.newInstance(2020, 01, 01);
            billingAdmin.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            insert billingAdmin;
            
            Billing_Administrative_Fees__c objBAF1 = billingAdmin.clone(false,true);
            objBAF1.LOB__c = 'STCOB';
            objBAF1.Year__c = '1';
            lstBillingAdminFees.Add(objBAF1);
            
            Billing_Administrative_Fees__c objBAF2 = billingAdmin.clone(false,true);
            objBAF2.LOB__c = 'SUBS';
            objBAF2.Year__c = '2';
            lstBillingAdminFees.Add(objBAF2);
            
            Billing_Administrative_Fees__c objBAF3 = billingAdmin.clone(false,true);
            objBAF3.LOB__c = 'WRAP';
            objBAF3.Year__c = '3';
            lstBillingAdminFees.Add(objBAF3);
            
            Billing_Administrative_Fees__c objBAF4 = billingAdmin.clone(false,true);
            objBAF4.LOB__c = 'PDP';
            objBAF4.Year__c = '4';
            lstBillingAdminFees.Add(objBAF4);
            
            Billing_Administrative_Fees__c objBAF5 = billingAdmin.clone(false,true);
            objBAF5.LOB__c = 'PDP';
            objBAF5.Year__c = '5';
            lstBillingAdminFees.Add(objBAF5);
            
            if(lstBillingAdminFees != null && lstBillingAdminFees.size() > 0)
            insert lstBillingAdminFees;
           
            
            if(string.isNotBlank(billingAdmin.Billing_Operations__c))
                Invoke_UpdateBillingAdmin.UpdateBillingAdmin(new List<id>{billingAdmin.Billing_Operations__c});
            Test.stopTest();
            
        } 
    }  
}