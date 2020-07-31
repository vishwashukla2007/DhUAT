@isTest
public class Apptus_Grid_Edit_AddProgramTest {

     static testmethod void AddProgramTestMeth1() {
        string fieldName = Label.SpecialtyOpsLabel;
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
            
            
            
            Client_Information__c cInfo = TestDataFactory.createClientInfo(FAFObj.id);
            cInfo.Escalating_Pricing__c = true;
            cInfo.Year_1__c = '1';
            cInfo.Year_1_Begin_Date__c = System.today();
            cInfo.Year_1_End_Date__c = System.today()+10;
            cInfo.Year_2__c = '2';
            cInfo.Year_2_Begin_Date__c = cInfo.Year_1_End_Date__c+1;
            cInfo.Year_2_End_Date__c = cInfo.Year_1_End_Date__c+10;        
            cInfo.Year_3__c = '3';
            cInfo.Year_3_Begin_Date__c = cInfo.Year_2_End_Date__c+1;
            cInfo.Year_3_End_Date__c = cInfo.Year_2_End_Date__c+10;        
            cInfo.Year_4__c = '4';
            cInfo.Year_4_Begin_Date__c = cInfo.Year_3_End_Date__c+1;
            cInfo.Year_4_End_Date__c = cInfo.Year_3_End_Date__c+10;        
            cInfo.Year_5__c = '5';
            cInfo.Year_5_Begin_Date__c = cInfo.Year_4_End_Date__c+1;
            cInfo.Year_5_End_Date__c = cInfo.Year_4_End_Date__c+10;        
            insert cInfo; 
            
            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            insert agrline;
            
            
            //billing operation records
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            
            
            //Added by sonal Sharma
           
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            //mail operation
            Mail_Operations__c  mailOps = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
            //rebate operation record
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            insert rebateOps;
            
            test.startTest();
            
            //Clinical_Operations__c  data
            Clinical_Operations__c  clinicOps= TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicOps;
            
            //Clinical_Solutions__c data
            Clinical_Solutions__c clinicSol =TestDataFactory.createGClinicalSolution(FAFObj.id,clinicOps.id);
            clinicSol.Template_Fee_Basis_Display__c=false;
            clinicSol.Template_Fee_Basis_Text__c='';
            clinicSol.Show_in_Grid__c=true;
            clinicSol.Agreement_Line_Item__c=agrline.id;
            insert clinicSol;
            
            
            Apptus_Grid_Edit_AddProgramController.findPicklistOptions('Network_Pricing__c','Year__c');
            Apptus_Grid_Edit_AddProgramController.get_yearcount(FAFObj.id);
            Apptus_Grid_Edit_AddProgramController.get_AddProgramData(FAFObj.id);
            Apptus_Grid_Edit_AddProgramController.saveAddProg(clinicSol);
            Apptus_Grid_Edit_AddProgramController.isDup(clinicSol , clinicSol.Clinical_Solution_Type__c, FAFObj.id);
            Apptus_Grid_Edit_AddProgramController.delAddProg(clinicSol.Id);            

            
            
            Test.StopTest();
        }
    }
}