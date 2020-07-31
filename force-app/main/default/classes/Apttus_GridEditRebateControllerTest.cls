@isTest
public class Apttus_GridEditRebateControllerTest {
     
    Static testmethod void GridEditRebatemethod(){
        
       User useObj = TestDataFactory.createUser('Apttus Underwriting');
      insert useObj;
         User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
     
        
        System.RunAs(useObj) {
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
            
            
            //rebate operation record
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            insert rebateOps;
            
            List<Rebate_Guarantees__c> rebList = new List<Rebate_Guarantees__c>();
            Rebate_Guarantees__c rebateG= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG.FAF_ID__c = FAFObj.id;
            rebateG.Retail_30_1__c=5;
            rebateG.Retail_90_1__c=5;
            rebateG.Mchoice_1__c=5;
            rebateG.Mail_1__c=5;
            rebateG.Specialty_1__c=5;
            rebateG.Specialty_Retail_1__c=5;
            rebateG.Client_Owned_90_1__c=5; rebateG.Percentage_Guarantee__c=false;
            rebateG.Show_in_Non_Specialty_Grid__c=true;
            rebateG.Show_in_Specialty_Grid__c=true;
            rebateG.Year_Begin_Date__c=Date.newInstance(2020, 01, 01);
            rebateG.Template_SpecialtyatCVS_Display__c=True;
            rebateG.Template_Rcurve_Display__c=true;
            rebateG.Template_Mail_Display__c=false;
            rebateG.Template_Retail_Display__c=false;
            rebateG.Template_Mchoice_Display__c=false;
            //rebateG.Template_Mail_Label__c='';
            rebateG.Plan_Design__c ='2 Tier Q';
            rebateG.Basis__c = 'All Rx'; 
            rebateG.GSTP__c = 'HPGST';
            rebateG.Specialty_Formulary__c = 'Custom Formulary';
            rebateG.Non_Specialty_Formulary_2__c = 'Custom';
            rebateG.LOB2__c ='ACT';
            rebateG.Agreement_Line_Item__c =    agrline.id; 
            //rebList.add(rebateG);
            insert rebateG;
            rebateG.Plan_Design__c = '3 Tier Q';
            rebateG.Year__c = '1';
            update rebateG;
            rebateG.Plan_Design__c = '3 Tier NQ';
            update rebateG; 
            rebateG.Plan_Design__c = 'Closed';
            update rebateG; 
           // rebateG = [select id,GSTP__c from Rebate_Guarantees__c where rebateG.Basis__c = 'All Rx' Limit 1]; 
           // rebateG.GSTP__c='Yes';
           // rebateG.GSTP_Option__c='Choice';
            upsert rebateG;

            
            Apttus_GridEditRebateController.get_yearcount(FAFObj.id);
          //  Apttus_GridEditRebateController.get_Rebatedata(FAFObj.id,rebateG.Plan_Design__c,rebateG.Basis__c,rebateG.Non_Specialty_Formulary_2__c,rebateG.GSTP__c,rebateG.Specialty_Formulary__c);
         //   Apttus_GridEditRebateController.get_RebatedataSpec(FAFObj.id,rebateG.Plan_Design__c,rebateG.Basis__c,rebateG.Non_Specialty_Formulary_2__c,rebateG.GSTP__c,rebateG.Specialty_Formulary__c);
            Apttus_GridEditRebateController.get_RebatedataNonSpec(FAFObj.id,rebateG.Plan_Design__c,rebateG.Basis__c,rebateG.Non_Specialty_Formulary_2__c,rebateG.GSTP__c,rebateG.LOB2__c);
          //  Apttus_GridEditRebateController.get_saveRebatedata(rebateG);
          // Apttus_GridEditRebateController.get_InsertRebatedata(rebateG);
          //  Apttus_GridEditRebateController.get_UpdateRebatedata(FAFObj.id,rebateG.Non_Specialty_Formulary_Option__c,rebateG.Specialty_Formulary_Option__c,rebateG.GSTP__c);
            //    get_InsertRebatedata();
          
        }  
    }
    
    Static testmethod void GridEditRebatemethod2(){
    
     User useObj = TestDataFactory.createUser('Apttus Underwriting');
      insert useObj;
         User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
     
        
        System.RunAs(useObj) {
           
     
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
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
        
            
            //rebate operation record
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            insert rebateOps;
            
            List<Rebate_Guarantees__c> rebList = new List<Rebate_Guarantees__c>();
            Rebate_Guarantees__c rebateG= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG.FAF_ID__c = FAFObj.id;
            rebateG.Retail_30_1__c=5;
            rebateG.Retail_90_1__c=5;
            rebateG.Mchoice_1__c=5;
            rebateG.Mail_1__c=5;
            rebateG.Specialty_1__c=5;
            rebateG.Specialty_Retail_1__c=5;
            rebateG.Client_Owned_90_1__c=5; rebateG.Percentage_Guarantee__c=false;
            rebateG.Show_in_Non_Specialty_Grid__c=true;
            rebateG.Show_in_Specialty_Grid__c=true;
            rebateG.Year_Begin_Date__c=Date.newInstance(2020, 01, 01);
            rebateG.Template_SpecialtyatCVS_Display__c=True;
            rebateG.Template_Rcurve_Display__c=true;
            rebateG.Template_Mail_Display__c=false;
            rebateG.Template_Retail_Display__c=false;
            rebateG.Template_Mchoice_Display__c=false;
            //rebateG.Template_Mail_Label__c='';
            rebateG.Plan_Design__c ='2 Tier Q';
            rebateG.Basis__c = 'All Rx'; 
            rebateG.GSTP__c = 'HPGST';
            rebateG.Specialty_Formulary__c = 'Custom Formulary';
            rebateG.Non_Specialty_Formulary_2__c = 'Custom';
            rebateG.LOB2__c ='ACT';
         //   rebateG.Non_Specialty_Formulary_Option__c = 'Client Choice';
        //    rebateG.GSTP_Option__c = 'Choice';
        //   rebateG.Specialty_Formulary_Option__c = 'Client Choice';
            rebateG.Agreement_Line_Item__c =    agrline.id; 
            rebList.add(rebateG);
            insert rebList;
            
            
            
            rebateG.Plan_Design__c = '3 Tier Q';
            rebateG.Year__c = '1';
            update rebateG;
            rebateG.Plan_Design__c = '3 Tier NQ';
            update rebateG; 
            rebateG.Plan_Design__c = 'Closed';
            update rebateG; 
           // rebateG = [select id,GSTP__c from Rebate_Guarantees__c where rebateG.Basis__c = 'All Rx' Limit 1]; 
           // rebateG.GSTP__c='Yes';
           // rebateG.GSTP_Option__c='Choice';
            upsert rebateG;
            Test.startTest();
            Apttus_GridEditRebateController.RebateWrapper rw = new Apttus_GridEditRebateController.RebateWrapper();
            rw.rg2TQ = new List<Rebate_Guarantees__c>{rebateG};
            rw.rg3TQ = new List<Rebate_Guarantees__c>{rebateG};
            rw.rg3TNQ = new List<Rebate_Guarantees__c>{rebateG};
            rw.closed = new List<Rebate_Guarantees__c>{rebateG};      
            String wrapper = JSON.serialize(rw);    
            Apttus_GridEditRebateController.deleteRG('2 Tier Q', wrapper);
            Apttus_GridEditRebateController.deleteRG('3 Tier Q', wrapper);
            Apttus_GridEditRebateController.deleteRG('3 Tier NQ', wrapper);
            Apttus_GridEditRebateController.deleteRG('closed', wrapper); 
            try{
            Apttus_GridEditRebateController.saveRG(wrapper, 'fafid', 'plan', 'basis', 'nonspecForm', 'gstp', 'lob','test');
            }catch(Exception e){}
           
           /* try{
            Apttus_GridEditRebateController.get_saveRebatedata(new Rebate_Guarantees__c());
            }catch(Exception e){}
            try{
            Apttus_GridEditRebateController.get_saveRebatedata(null);
            }catch(Exception e){}
            try{
            Apttus_GridEditRebateController.get_InsertRebatedata(rebateG);
            }catch(Exception e){}
            try{
            Apttus_GridEditRebateController.get_InsertRebatedata(null);
            }catch(Exception e){}*/
            
         //   Apttus_GridEditRebateController.get_UpdateRebatedata(FAFObj.id, true, true, true);
    
            Apttus_GridEditRebateController.findPicklistOptions('Billing_Administrative_Fees__c', 'Admin_Fee_Type__c');
            
            Rebate_Guarantees__c rebateG2= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG2.FAF_ID__c = FAFObj.id;
            rebateG2.Retail_30_1__c=5;
            rebateG2.Retail_90_1__c=5;
            rebateG2.Mchoice_1__c=5;
            rebateG2.Mail_1__c=5;
            rebateG2.Specialty_1__c=5;
            rebateG2.Specialty_Retail_1__c=5;
            rebateG2.Client_Owned_90_1__c=5; rebateG.Percentage_Guarantee__c=false;
            rebateG2.Show_in_Non_Specialty_Grid__c=true;
            rebateG2.Show_in_Specialty_Grid__c=true;
            rebateG2.Year_Begin_Date__c=Date.newInstance(2020, 01, 01);
            rebateG2.Template_SpecialtyatCVS_Display__c=True;
            rebateG2.Template_Rcurve_Display__c=true;
            rebateG2.Template_Mail_Display__c=false;
            rebateG2.Template_Retail_Display__c=false;
            rebateG2.Template_Mchoice_Display__c=false;
            //rebateG.Template_Mail_Label__c='';
            rebateG2.Plan_Design__c ='2 Tier Q';
            rebateG2.Basis__c = 'All Rx'; 
            rebateG2.GSTP__c = 'HPGST';
            rebateG2.Specialty_Formulary__c = 'Custom Formulary';
            rebateG2.Non_Specialty_Formulary_2__c = 'Custom';
            rebateG2.LOB2__c ='ACT';
            rebateG2.Agreement_Line_Item__c = agrline.id;
            rebateG2.GSTP__c = 'Custom';
            rebateG2.Plan_Design__c = '2 Tier Q';
            upsert rebateG2;
            
            
            Apttus_GridEditRebateController.processMatchToLogic('2TQ', '2TQ', 'planDesignOption', wrapper, FAFObj.id, 'basis', rebateG2.Non_Specialty_Formulary_2__c, 'Custom', 'ACT');
            Rebate_Guarantees__c rebateG3= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG3.Specialty_Formulary__c = 'Custom Formulary';
            rebateG3.Agreement_Line_Item__c = agrline.id;
            rebateG3.Plan_Design__c = '3 Tier Q';
            rebateG3.LOB2__c ='ACT';
            rebateG3.GSTP__c = 'Custom';
            rebateG3.FAF_ID__c = FAFObj.id;
            upsert rebateG3;
            Apttus_GridEditRebateController.processMatchToLogic('3TQ', '3TQ', 'planDesignOption', wrapper, FAFObj.id, 'basis', rebateG3.Non_Specialty_Formulary_2__c, 'Custom', 'ACT');
            

            Test.stopTest();
        }  
    }
    
    Static testmethod void GridEditRebatemethod3(){
        
              User useObj = TestDataFactory.createUser('Apttus Underwriting');
            insert useObj;
           User useObjNew = TestDataFactory.createUser('Apttus Sales');
          insert useObjNew;
     
        
        System.RunAs(useObj) {
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
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
          
             //mail operation
            Mail_Operations__c  mailOps = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
            //rebate operation record
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            rebateOps.Percentage_Guarantee__c=false;
            insert rebateOps;
            test.starttest();
        Rebate_Guarantees__c rg = new Rebate_Guarantees__c();
        rg.Rebate_Operations__c = rebateOps.Id;
        rg.FAF_ID__c =FAFObj.Id;
        rg.Show_in_Specialty_Grid__c=true;
        rg.Show_in_Non_Specialty_Grid__c=true;
        rg.Year__c='1';
        rg.LOB2__c = 'ACT';
        rg.GSTP__C='HPGST';
        rg.Plan_Design__c = '2 Tier Q';
        rg.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        
        rg.Retail_30__c = 1;
        rg.Retail_90__c = 1;
        rg.Client_Owned_30__c = 1;
        rg.Client_Owned_90__c = 1;
        rg.Mail__c = 1;
        rg.Mchoice__c = 1;
        rg.Specialty_Retail__c = 1;
        rg.UniqueCheck__c=true;
        rg.PCD_Aggregate_Rate__c='1111111';
        rg.Template_ClientOwned_Display__c=true;
        rg.Template_Retail30_Display__c =true;   
        rg.Template_Retail90_Display__c=true;
        rg.Template_Rcurve_Display__c=true;
        rg.Template_Mail_Display__c=true;
        rg.Template_Mail_Display__c=true;
        insert rg;
            
            Apttus_GridEditRebateController.RebateWrapper rw = new Apttus_GridEditRebateController.RebateWrapper();
            rw.rg2TQ = new List<Rebate_Guarantees__c>{rg};
            rw.rg3TQ = new List<Rebate_Guarantees__c>{rg};
            rw.rg3TNQ = new List<Rebate_Guarantees__c>{rg};
            rw.closed = new List<Rebate_Guarantees__c>{rg};      
            String wrapper = JSON.serialize(rw);    
            Apttus_GridEditRebateController.deleteRG('2 Tier Q', wrapper);
            Apttus_GridEditRebateController.deleteRG('3 Tier Q', wrapper);
            Apttus_GridEditRebateController.deleteRG('3 Tier NQ', wrapper);
            Apttus_GridEditRebateController.deleteRG('closed', wrapper); 
            
            Apttus_GridEditRebateController.isCopyDup(rg, 'Custom', 'Custom', 'ACT', false, new Rebate_Guarantees__c(), false,FAFObj.id);
           try{
            Apttus_GridEditRebateController.saveCopyRGs(rg,'All Rx','Exchange Custom', 'Custom', 'ACT',false,new Rebate_Guarantees__c(),true,'test',false);
           }
           catch(Exception e){
           
           }
             try{
            Apttus_GridEditRebateController.saveRGs(rg, 'basis', 'nonspecForm', 'gstp', 'lob', false, new Rebate_Guarantees__c(), true,'test');
            }catch(Exception e){}
            Apttus_GridEditRebateController.IncreaseCoverage();
             try{
            Apttus_GridEditRebateController.saveRGs(rg, 'basis', 'nonspecForm', 'gstp', 'lob', true, new Rebate_Guarantees__c(), true,'test');
            }catch(Exception e){}
            try{
            Apttus_GridEditRebateController.saveRGs(new Rebate_Guarantees__c(), 'basis', 'nonspecForm', 'gstp', 'lob', false, new Rebate_Guarantees__c(), true,'test');
            }catch(Exception e){}
            try{
            Apttus_GridEditRebateController.saveRGs(new Rebate_Guarantees__c(), 'basis', 'nonspecForm', 'gstp', 'lob', false, new Rebate_Guarantees__c(), false,'test');
            }catch(Exception e){}
            
            Rebate_Guarantees__c rebateG4= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG4.Specialty_Formulary__c = 'Custom Formulary';
            rebateG4.Agreement_Line_Item__c = agrline.id;
            rebateG4.Plan_Design__c = '3 Tier NQ';
            rebateG4.LOB2__c ='ACT';
            rebateG4.GSTP__c = 'Custom';
            rebateG4.FAF_ID__c = FAFObj.id;
            upsert rebateG4;
            Apttus_GridEditRebateController.processMatchToLogic('3TNQ', '3TNQ', 'planDesignOption', wrapper, FAFObj.id, 'basis', rebateG4.Non_Specialty_Formulary_2__c, 'Custom', 'ACT');
            Rebate_Guarantees__c rebateG5= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG5.Specialty_Formulary__c = 'Custom Formulary';
            rebateG5.Agreement_Line_Item__c = agrline.id;
            rebateG5.Plan_Design__c = 'Closed';
            rebateG5.LOB2__c ='ACT';
            rebateG5.GSTP__c = 'Custom';
            rebateG5.FAF_ID__c = FAFObj.id;
            upsert rebateG5;
            Apttus_GridEditRebateController.processMatchToLogic('Closed', 'Closed', 'planDesignOption', wrapper, FAFObj.id, 'basis', rebateG5.Non_Specialty_Formulary_2__c, 'Custom', 'ACT');
            Apttus_GridEditRebateController.deleteSelectedRebateRecords(rg.id);
            
            test.stopTest();
        }
    }
    
    
}