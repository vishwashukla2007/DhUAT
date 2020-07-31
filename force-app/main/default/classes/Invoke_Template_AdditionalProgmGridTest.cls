@isTest
public class Invoke_Template_AdditionalProgmGridTest{
    
    static testMethod void Invoke_Template_AdditionalProgramGridTest1(){
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
            insert cInfo; 
            
            test.startTest();
            
            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            agr.Status_In_Progress__c='Setup Pricing';
            agr.PCD_Status__c='Setup Pricing';
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Async_Mode__c=false;
            agrline.Component_Error__c='';
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            agrline.LOB_Description__c='';
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c =agrline.id;
            update agr;
             
            Clinical_Operations__c clinicOps= TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicOps;
            
            //Clinical_Solutions__c data
            Clinical_Solutions__c clinicSol =TestDataFactory.createGClinicalSolution(FAFObj.id,clinicOps.id);
            clinicSol.Show_in_Grid__c=true;
            clinicSol.Year_Start_Date__c=Date.newInstance(2019, 2, 1);
            clinicSol.Year_End_Date__c=Date.newInstance(2019, 2, 31);
            clinicSol.Clinical_Solution__c='1st Level Appeals';
            clinicSol.Clinical_Solution_Type__c='Commercial';
            clinicSol.Fee_Basis__c='Across Retail Claims';
            clinicSol.Fee_Amount__c=15;
            clinicSol.Year__c='1';
            clinicSol.Template_Fee_Basis_Text__c='';
            clinicSol.Template_Fee_Basis_Display__c=false; 
            clinicSol.Agreement__c=agr.id;
            clinicSol.Agreement_Line_Item__c=agrline.id;
            insert clinicSol;
            
            List<id> clinicOpsList =new List<id>();
            clinicOpsList.add(clinicOps.id);
           
            Invoke_Template_AdditionalProgramGrid.Template_AdditionalProgramGrid(clinicOpsList);
            
            Test.stopTest();
            //System.assertEquals(null,ntwrkPriceObj.id,'network pricing is empty');
        
        }
    }
}