/* =================================================================================
* @Class Name        :Invoke_UpdateAdditionalProgramGridTest
* @author            : Parvathi Chunduri (parvathi.chunduri@cvshealth.com)
* @created date      : 02/21/2020
* @Purpose           : Test coverage for Invoke_UpdateAdditionalProgramGrid
=======================================================================================*/
@isTest
public class Invoke_UpdateAdditionalProgramGridTest {
    
    Static testmethod Void UpdateAdditionalProgramGrid(){
        
            User useObjNew = TestDataFactory.createUser('Apttus Sales');
            insert useObjNew;
        
        System.RunAs(useObjNew) {
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj; 
            
            Client_Information__c cInfo = TestDataFactory.createClientInfo(FAFObj.id);
            cInfo.FAF_ID__c = FAFObj.id;
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
            
            Clinical_Operations__c  clinicOps= TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicOps;
           
            Test.startTest();  
            Clinical_Solutions__c clinicSol =TestDataFactory.createGClinicalSolution(FAFObj.id,clinicOps.id);
            clinicSol.Year__c = '1';
            clinicSol.Template_Fee_Basis_Text__c='';
            clinicSol.Show_in_Grid__c=true;
            clinicSol.FAF_ID__c = FAFObj.id;
            clinicSol.Clinical_Operations__c = clinicOps.id;
            clinicSol.Year_Start_Date__c = cInfo.Year_1_Begin_Date__c;
            clinicSol.Year_End_Date__c = cInfo.Year_1_End_Date__c;
            insert clinicSol;
			
            clinicSol.Year__c = 'All';
            clinicSol.Show_in_Grid__c = false;
            Update clinicSol;
            
            Clinical_Solutions__c clinicSol2 =TestDataFactory.createGClinicalSolution(FAFObj.id,clinicOps.id);
            clinicSol2.Year__c = '2';
            clinicSol2.Template_Fee_Basis_Text__c='';
            clinicSol2.Show_in_Grid__c=true;
            clinicSol2.FAF_ID__c = FAFObj.id;
            clinicSol2.Clinical_Operations__c = clinicOps.id;
            clinicSol2.Year_Start_Date__c = cInfo.Year_2_Begin_Date__c;
            clinicSol2.Year_End_Date__c = cInfo.Year_2_End_Date__c;
            insert clinicSol2;
            
			/*List<Clinical_Solutions__c> lstCSOL = new List<Clinical_Solutions__c>();            
            Clinical_Solutions__c clinicSOL1 = clinicSol.clone(false,true);
            clinicSOL1.Year__c = '2';
            lstCSOL.Add(clinicSOL1);
            
            Clinical_Solutions__c clinicSOL2 = clinicSol.clone(false,true);
            clinicSOL2.Year__c = '3';
            lstCSOL.Add(clinicSOL2);
            
            Clinical_Solutions__c clinicSOL3 = clinicSol.clone(false,true);
            clinicSOL3.Year__c = '4';
            lstCSOL.Add(clinicSOL3);
            
            Clinical_Solutions__c clinicSOL4 = clinicSol.clone(false,true);
            clinicSOL4.Year__c = '5';
            lstCSOL.Add(clinicSOL4);
            
            if(lstCSOL != null && lstCSOL.size() > 0)
                insert lstCSOL;*/
         
                   
            if(clinicSol != null && clinicSol.Clinical_Operations__c != null && string.isNotBlank(clinicsol.Clinical_Operations__c))
                Invoke_UpdateAdditionalProgramGrid.UpdateAdditionalProgramGrid(new List<Id>{clinicsol.Clinical_Operations__c});
             else
            	Invoke_UpdateAdditionalProgramGrid.UpdateAdditionalProgramGrid(new List<Id>{clinicSol.id});
            Test.StopTest();
        } 
    }
}