@isTest
public class Apttus_GridObjectdataTest {
    static testmethod void SpecialtyGuaranteeNewEditClassTestMeth1() {
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
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //billing operation records
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            
            //update faf
            FAFObj.Template_Master_Electronic_Fee_text__c='';
            FAFObj.Template_Master_Manual_Claim_Fee_text__c='';
            FAFObj.Template_340B_Display__c=false;
            FAFObj.Template_Master_340B_Type_text__c='';
            FAFObj.Template_Master_EGWPPMPM_Type_text__c='';
            FAFObj.Template_EGWPPMPM_Display__c=false;
            FAFObj.Agreement_Line_Item__c =agrline.id;  
            update FAFObj;
            
            test.startTest();
            //Added by sonal Sharma
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            ntwrkOpsObj.Agreement_Line_Item__c=agrline.id;
            insert ntwrkOpsObj;
            
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj.Agreement__c= agr.id;
            ntwrkPriceObj.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj.Custom_Network_Description__c='Test';
            ntwrkPriceObj.Network_Name_for_Grid__c='';
            ntwrkPriceObj.Template_BER_Display__c=false;
            ntwrkPriceObj.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Brand_Display__c=false;
            ntwrkPriceObj.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Generic_Display__c=false;
            ntwrkPriceObj.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_GER_Display__c=false;
            ntwrkPriceObj.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_MCCP__c=false;
            ntwrkPriceObj.Template_MER_Display__c=false;
            ntwrkPriceObj.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_NED_Display__c=false;
            ntwrkPriceObj.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Network_Name_Text__c='';
            ntwrkPriceObj.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_OED_Display__c=false;
            ntwrkPriceObj.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Display__c=false;
            ntwrkPriceObj.SSG_Display__c=false;                
            ntwrkPriceObj.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Network_Type__c='Transparent';
            ntwrkPriceObj.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj.Show_in_Grid__c=true;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj.Network_Name__c ='National - NACH7';
            ntwrkPriceObj.Sequence_Number__c =1;
            
            insert ntwrkPriceObj;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Secondary';
            update ntwrkPriceObj;
            
            
            Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Custom_Network_Description__c='Test';
            ntwrkPriceObj1.Network_Type__c='Transparent';
            ntwrkPriceObj1.LOB__c ='STD';
            ntwrkPriceObj1.Network_Name__c ='National - NACH7';
            ntwrkPriceObj.Sequence_Number__c =2;
            insert ntwrkPriceObj1;
            
             Network_Pricing__c ntwrkPriceObj2= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            //ntwrkPriceObj2.Custom_Network_Description__c='Test';
            ntwrkPriceObj2.Network_Type__c='Transparent';
            ntwrkPriceObj2.LOB__c ='MEDI';
            ntwrkPriceObj2.Network_Name__c ='National - CVL5';
            ntwrkPriceObj2.Retail_Network_Ordinal__c='Secondary';
            ntwrkPriceObj2.Year__c='2';
            ntwrkPriceObj.Sequence_Number__c =3;
            insert ntwrkPriceObj2;
            
            //ntwrkPriceObj.Network_Name__c ='Custom';
            //update ntwrkPriceObj;
            
            Retail_Network_Guarantees__c retailNtwrk =TestDataFactory.createretntwrkGuarnt(FAFObj.id,ntwrkPriceObj.id);
            retailNtwrk.Type__c='SSG';
            insert retailNtwrk;

            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            specOpsObj.Agreement__c=agr.id;
            specOpsObj.Specialty_Legacy_Drug_Level_Pharmacy__c='';
            specOpsObj.Specialty_Legacy_Drug_Level_exist__c=true;
            specOpsObj.Agreement_Line_Item__c =agrline.Id;
            insert specOpsObj;
            
            //specialty pricing record
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            //specpricObj.Pharmacy_Benefit__c='None';
            specpricObj.Agreement__c=agr.id;
            specpricObj.Custom_Specialty_Grid__c=true;
            specpricObj.Agreement_Line_Item__c=agrline.Id;
            insert specpricObj;
            
            Specialty_Pricing__c specpricObj1 = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj1.Year__c ='3';
            specpricObj1.LOB__c ='WC';
            specpricObj1.Pharmacy_Benefit__c = 'Preferred';
            insert specpricObj1;
            //Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            //insert specGuaranObj;
            
           
            try{
                list<Network_Pricing__c> npList = Apttus_GridObjectdata.get_GridObjectdata(agrline.Id,'Network_Pricing__c');
                Apttus_GridObjectdata.checkValid(npList[0].Id, agrline.Id,'', '2', false);
                Apttus_GridObjectdata.updateNPSeq(npList[0].Id, agrline.Id,'', '3', false);
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_Opsid(agrline.Id,'Network_Operations__c');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_SpecGridObjectdata(agrline.Id, 'Specialty_Pricing__c');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_SpecOpsGridObjectdata(agrline.Id, 'Specialty_Operations__c');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_BillAdmindata(agrline.id,'Central_Hub__c');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_newpricingdata(FAFObj.id,'National - NACH7','Transparent','Test','ACT');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_pricingdata(FAFObj.id,'National - NACH7','Transparent','Test','ACT');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_SpecialtyPricingData(FAFObj.id, specOpsObj.Id, '');
            //Apttus_GridObjectdata.get_savedata(ntwrkPriceObj);
            }
            Catch(Exception Ex){}
            try{
            //Apttus_GridObjectdata.get_createdata(ntwrkOpsObj.id,'National - NACH7','Transparent','ACT','Test');
            }
            Catch(Exception Ex){}
            try{
            //Apttus_GridObjectdata.get_createdata(ntwrkOpsObj.id,'CareChoice','Locked','CAP','Test');
            }
            Catch(Exception Ex){}
            Client_Information__c cInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
            cInfo2.Year_1__c = null;
            cInfo2.Year_2__c = null;
            cInfo2.Year_3__c = null;
            cInfo2.Year_4__c = null;
            cInfo2.Year_5__c = null;
            cInfo2.Year_1_Begin_Date__c = null;
            cInfo2.Year_1_End_Date__c = null;
            cInfo2.Year_2_Begin_Date__c = null;
            cInfo2.Year_2_End_Date__c = null;
            cInfo2.Year_3_Begin_Date__c = null;
            cInfo2.Year_3_End_Date__c = null;
            cInfo2.Year_4_Begin_Date__c = null;
            cInfo2.Year_4_End_Date__c = null;
            cInfo2.Year_5_Begin_Date__c = null;
            cInfo2.Year_5_End_Date__c = null;
            cInfo2.Escalating_Pricing__c = false;
            insert cInfo2;
            try{
            Apttus_GridObjectdata.get_createdata(ntwrkOpsObj.id,'CareChoice','Locked','CAP','Test');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_copydata(ntwrkPriceObj2,'CareChoice','Locked','STD','Test6');
            
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_copydata(ntwrkPriceObj1,'National - NACH7','Transparent','STD','Test');
            //Apttus_GridObjectdata.get_yearcount(FAFObj.id);
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.get_savedata(ntwrkPriceObj1);
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.deleteSelectedRecords(ntwrkPriceObj1.id);
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.deletepricinggrid(FAFObj.id,'National - NACH7','Transparent','Test','ACT');
            }
            Catch(Exception Ex){}
            try{
            Apttus_GridObjectdata.deleteSelectedSpecialtyRecords(specpricObj1.id);
            }
            Catch(Exception Ex){
            }
           
            Test.StopTest();
        }
    }
    
    static testmethod void SpecialtyGuaranteeNewEditClassTestMeth2() {
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
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
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
            
            /*Client_Information__c cInfo1 = TestDataFactory.createClientInfo(FAFObj.id);
            cInfo1.Year_1__c = '';
            cInfo1.Year_2__c = '';
            cInfo1.Year_3__c = '';
            cInfo1.Year_4__c = '';
            cInfo1.Year_5__c = '';
            insert cInfo1;*/
            
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
            
            test.startTest();
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //Added by sonal Sharma
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            insert ntwrkOpsObj;
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            //ntwrkPriceObj.Plan_Year__c=
            //ntwrkPriceObj.SSG_Guarantee__c
            //ntwrkPriceObj.OED_Count__c,
            //NED_Count__c,
            //MER_Count__c,
            //GER_Count__c,
            //BER_Guarantee__c,                               
            ntwrkPriceObj.Agreement__c= agr.id;
            ntwrkPriceObj.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj.Custom_Network_Description__c='';
            ntwrkPriceObj.Network_Name_for_Grid__c='';
            ntwrkPriceObj.Template_BER_Display__c=false;
            ntwrkPriceObj.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Brand_Display__c=false;
            ntwrkPriceObj.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj.Template_Generic_BER_Guarantee_Rate_Text__c='';
            //ntwrkPriceObj.Template_Generic_Dispensing_Fee__c,
            ntwrkPriceObj.Template_Generic_Display__c=false;
            ntwrkPriceObj.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_GER_Display__c=false;
            ntwrkPriceObj.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_MCCP__c=false;
            ntwrkPriceObj.Template_MER_Display__c=false;
            ntwrkPriceObj.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_NED_Display__c=false;
            ntwrkPriceObj.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Network_Name_Text__c='';
            ntwrkPriceObj.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_OED_Display__c=false;
            ntwrkPriceObj.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Display__c=false;
            ntwrkPriceObj.SSG_Display__c=false;                
            ntwrkPriceObj.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Network_Type__c='Transparent';
            ntwrkPriceObj.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj.Show_in_Grid__c=true;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Primary';
            //FAF_ID__r.LOB2__c                               
            insert ntwrkPriceObj;
            
            ntwrkPriceObj.Retail_Network_Ordinal__c='Secondary';
            update ntwrkPriceObj;
            //ntwrkPriceObj.Network_Name__c ='National - NACH7';
            //update ntwrkPriceObj;
            
            Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Custom_Network_Description__c='Test';
            ntwrkPriceObj1.Network_Type__c='Transparent';
            ntwrkPriceObj1.Network_Name__c ='Custom';
            insert ntwrkPriceObj1;
            
            //ntwrkPriceObj1.Network_Type__c='Transparent';
            //ntwrkPriceObj1.Network_Name__c ='Custom';
            //update ntwrkPriceObj1;
           
          /*  Network_Pricing__c ntwrkPriceObj2= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj2.Custom_Network_Description__c='Test';
            ntwrkPriceObj2.Network_Type__c='Transparent';
            ntwrkPriceObj2.Network_Name__c ='Custom';
            
            insert ntwrkPriceObj2;*/
            
            Retail_Network_Guarantees__c retailNtwrk =TestDataFactory.createretntwrkGuarnt(FAFObj.id,ntwrkPriceObj.id);
            retailNtwrk.Type__c='SSG';
            insert retailNtwrk;

            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            specOpsObj1.Pharmacy_Benefit__c = ConstantsUtil.const_None;
            insert specOpsObj1;
            
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj.Pharmacy_Benefit__c='Preferred';
            insert specpricObj;
            
            Specialty_Pricing__c specpricObj1 = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj1.Pharmacy_Benefit__c = 'Preferred';
            specpricObj1.Year__c ='1';
            specpricObj1.Agreement_Line_Item__c= agrline.Id;
            insert specpricObj1;
            Specialty_Pricing__c specpricObj2 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
            specpricObj2.Year__c ='3';
            specpricObj2.LOB__c ='WC';
            specpricObj2.Price_List__c = specpricObj1.Price_List__c;
            specpricObj2.Specialty_Operations__c = specpricObj1.Specialty_Operations__c;
            specpricObj2.Pharmacy_Benefit__c = 'Preferred';
            specpricObj2.Agreement_Line_Item__c= agrline.Id;
            insert specpricObj2;
            
            Specialty_Pricing__c specpricObj3 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
            specpricObj3.Year__c ='3';
            specpricObj3.LOB__c ='WC';
            specpricObj3.Pharmacy_Benefit__c = 'Preferred';
            insert specpricObj3;
            Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            insert specGuaranObj;
            
            
            list<Network_Pricing__c> npList =  Apttus_GridObjectdata.get_GridObjectdata(agrline.Id,'Network_Pricing__c');
            
            Apttus_GridObjectdata.checkValid(npList[0].Id, agrline.Id,'', '1', false);
            Apttus_GridObjectdata.updateNPSeq(npList[0].Id, agrline.Id,'', '1', false);
            Apttus_GridObjectdata.get_SpecGridObjectdata(agrline.Id, 'Specialty_Pricing__c');
            Apttus_GridObjectdata.get_SpecOpsGridObjectdata(agrline.Id, 'Specialty_Operations__c');
            Apttus_GridObjectdata.get_SpecialtyPricingData(FAFObj.id, specOpsObj.Id, 'Preferred');
            Apttus_GridObjectdata.get_newpricingdata(FAFObj.id,'MC(84-90)CP','Transparent','','ACT');
            Apttus_GridObjectdata.get_pricingdata(FAFObj.id,'MC(84-90)CP','Transparent','','ACT');
            Apttus_GridObjectdata.get_yearcountali(agrline.Id);
            Apttus_GridObjectdata.get_createdata(ntwrkOpsObj.id,'Custom','Transparent','ACT','Test');
            Apttus_GridObjectdata.get_copydata(ntwrkPriceObj1,'Custom','Transparent','ACT','Test');
            Apttus_GridObjectdata.get_saveSpecialtydata(specpricObj3,specOpsObj.Id);
            //Apttus_GridObjectdata.deleteSelectedRecords(ntwrkPriceObj.id);
            Apttus_GridObjectdata.deletSpecialtypricinggrid(FAFObj.id, '',specOpsObj.Id, 'Preferred');
            Apttus_GridObjectdata.deleteSelectedSpecialtyRecords(specpricObj3.id);
            Apttus_GridObjectdata.get_savedata(ntwrkPriceObj1);
            Test.StopTest();
        }
    }
    //method 3 rebate clinical sol mail pricing
     static testmethod void SpecialtyGuaranteeNewEditClassTestMeth3() {
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
            //rebate guarantee record
            Rebate_Guarantees__c rebateG= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
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
            rebateG.Template_SpecialtyatRetail_Text__c='';
            rebateG.Template_SpecialtyatRetail_Display__c=false;
            rebateG.Template_ClientOwned90_Display__c=false;
            rebateG.Template_Retail90_Text__c='';
            rebateG.Sorting_Number__c=1;
            rebateG.Template_Retail90_Display__c=false;
            rebateG.Template_Retail30_Display__c=false;
            rebateG.Modeled_Non_Specialty_Formulary_Name__c='';
            rebateG.Modeled_Non_Specialty_PlanDesign__c='';
            rebateG.Template_Retail_Text__c='';
            rebateG.Template_Mail_Text__c='';
            //Template_Specialty_Formula__c,
            rebateG.Template_Specialty_Carveout_Text__c='';
            rebateG.Template_Specialty_Carveout_Label_Text__c='';
            rebateG.Modeled_Specialty_PlanDesign__c='';
            rebateG.Client_Owned_30__c=5;
            rebateG.Modeled_Specialty_Formulary_Name__c='';
            rebateG.Template_Clientowned30_Text__c=''; rebateG.Template_ClientOwned30_Display__c=false; 
            rebateG.Template_Clientowned90_Text__c='';
            rebateG.Template_Clientowned_Text__c='';  rebateG.Client_Owned_30_1__c=5;
            rebateG.Client_Owned_90__c=5;
            rebateG.Template_Mchoice_Text__c='';
            rebateG.Template_SpecialtyatCVS_Text__c='';
            //rebateG.Retail_Display__c=false;
            //rebateG.ClientOwned30_Display__c=false;
            //rebateG.ClientOwned90_Display__c=false;
            //rebateG.ClientOwned_Display__c=false;
            //rebateG.Mail_Display__c=false; 
            //rebateG.Maintenance_Choice_Display__c=false;
            rebateG.Template_Retail30_Text__c='';
            //rebateG.Retail30_Display__c=false;
            //rebateG.Retail90_Display__c=false;
            rebateG.Template_SpecialtyatCVS_Display__c=false;
            rebateG.Template_Rcurve_Display__c=true;
            rebateG.Template_Mail_Display__c=false;
            rebateG.Template_Retail_Display__c=false;
            rebateG.Template_Mchoice_Display__c=false;
            //rebateG.Template_Mail_Label__c='';
            rebateG.Agreement_Line_Item__c =    agrline.id; 
            rebateG.Basis__c = 'All Rx'; 
            rebateG.Non_Specialty_Formulary_2__c = 'Custom';
            rebateG.Specialty_Formulary__c = 'Custom Formulary';
            rebateG.GSTP__c = 'HPGST';
            insert rebateG;
            
            rebateG.Year__c = '1';
            update rebateG;
            
            
             //rebate guarantee record 2
            Rebate_Guarantees__c rebateG1= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            insert rebateG1;
            
            /*
            //mail pricing record
            Mail_Pricing__c  mailPrice=TestDataFactory.createmailPricing(FAFObj.id,mailOps.id );
            mailPrice.Agreement__c=agr.id;
            mailPrice.Agreement_Line_Item__c=agrline.id; 
            mailPrice.Grid_Name__c='';
            mailPrice.LOB__c='ACT';
            mailPrice.Template_BER_Display__c=false;
            mailPrice.Template_BER_Guarantee_Rate_Text__c='';
            mailPrice.Template_Brand_Display__c=false;
            mailPrice.Template_Brand_Rate_Text__c='';
            mailPrice.Template_Dispensing_Fee_Text__c='';
            mailPrice.Year_Begin_Date__c=Date.newInstance(2020, 01, 01);
            mailPrice.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            mailPrice.Brand_Dispensing_Fee__c=5;
            mailPrice.Brand_Basis__c='Standard Brand Discount';
            mailPrice.Generic_Dispensing_Fee__c=5;
            mailPrice.Template_Generic_Display__c=false;
            mailPrice.Template_Generic_Rate_Text__c='';
            mailPrice.Template_GER_Display__c=false;
            mailPrice.Template_GER_Guarantee_Rate_Text__c='';
            mailPrice.Template_MER_Display__c=false;
            mailPrice.Template_MER_Guarantee_Rate_Text__c='';
            mailPrice.Template_NED_Display__c=false;
            mailPrice.Template_NED_Guarantee_Rate_Text__c='';
            mailPrice.Template_NonMacGeneric_Display__c=false;
            mailPrice.Template_Non_MAC_Generic_Rate_Text__c='';
            mailPrice.Template_Non_Preferred_Brand_Rate_Text__c='';
            mailPrice.Template_Preferred_Brand_Rate_Text__c='';
            mailPrice.Template_Preferred_Display__c=false;
            mailPrice.SSG_Display__c=false;          
            mailPrice.Template_SSG_Guarantee_Rate_Text__c='';
            mailPrice.Show_in_Grid__c=true; 
            mailPrice.Brand_Rate__c=5;
            mailPrice.Generic_Rate__c=5;
            insert mailPrice;
            */
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
            
            
            //Apttus_GridObjectdata.get_MailGridObjectdata(agrline.Id, 'Mail_Pricing__c');
            Apttus_GridObjectdata.get_RebGridObjectdata(agrline.id,'Rebate_Guarantees__c');
            Apttus_GridObjectdata.get_RebCarveOutObjectdata(agrline.id,'Rebate_Guarantees__c');
           // Apttus_GridObjectdata.get_Addprogramdata(agrline.id,'Clinical_Solutions__c');
            //Apttus_GridObjectdata.get_Mailpricingdata(FAFObj.id);
            Apttus_GridObjectdata.get_Rebatedata(FAFObj.id,'3 Tier Q','All Rx','Custom','HPGST','Custom Formulary');
            //Apttus_GridObjectdata.get_RebatedataSpec(FAFObj.id,'3 Tier Q','All Rx','Custom','HPGST','Custom Formulary');
            
            Apttus_GridObjectdata.get_saveRebatedata(rebateG);
            //Apttus_GridObjectdata.get_InsertRebatedata(rebateG);
            Apttus_GridObjectdata.get_createdata(FAFObj.id,'National - NACH7','Transparent','ACT','Test');
            Apttus_GridObjectdata.get_yearcount(FAFObj.id);
            Apttus_GridObjectdata.deleteSelectedRebateRecords(rebateG1.id);
            //Apttus_GridObjectdata.deleteSelectedmailRecords(mailPrice.id);
            Apttus_GridObjectdata.deleteRebategrid(FAFObj.id,'3 Tier Q','All Rx','Custom','HPGST','', true,'test');
            //Apttus_GridObjectdata.deletemailpricinggrid(FAFObj.id,'ACT');
             try{
            Apttus_GridObjectdata.get_RebatedataNonSpec(FAFObj.id,'Test','All Rx','Custom','HPGST','Custom Formulary');
            }
            Catch(Exception Ex){
            }
            
            
            Test.StopTest();
        }
    }
    
    //method 4
     static testmethod void SpecialtyGuaranteeNewEditClassTestMeth4() {
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
            
            
            
            Client_Information__c cInfo = TestDataFactory.createClientInfo(FAFObj.id);/*
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
*/          
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
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            ntwrkOpsObj.Agreement_Line_Item__c=agrline.id;
            insert ntwrkOpsObj;
            
            test.startTest();
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //mail operation
            Mail_Operations__c  mailOps = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
            //rebate operation record
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            insert rebateOps;
            //rebate guarantee record
            Rebate_Guarantees__c rebateG= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
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
            rebateG.Template_SpecialtyatRetail_Text__c='';
            rebateG.Template_SpecialtyatRetail_Display__c=false;
            rebateG.Template_ClientOwned90_Display__c=false;
            rebateG.Template_Retail90_Text__c='';
            rebateG.Sorting_Number__c=1;
            rebateG.Template_Retail90_Display__c=false;
            rebateG.Template_Retail30_Display__c=false;
            rebateG.Modeled_Non_Specialty_Formulary_Name__c='';
            rebateG.Modeled_Non_Specialty_PlanDesign__c='';
            rebateG.Template_Retail_Text__c='';
            rebateG.Template_Mail_Text__c='';
            //Template_Specialty_Formula__c,
            rebateG.Template_Specialty_Carveout_Text__c='';
            rebateG.Template_Specialty_Carveout_Label_Text__c='';
            rebateG.Modeled_Specialty_PlanDesign__c='';
            rebateG.Client_Owned_30__c=5;
            rebateG.Modeled_Specialty_Formulary_Name__c='';
            rebateG.Template_Clientowned30_Text__c=''; rebateG.Template_ClientOwned30_Display__c=false; 
            rebateG.Template_Clientowned90_Text__c='';
            rebateG.Template_Clientowned_Text__c='';  rebateG.Client_Owned_30_1__c=5;
            rebateG.Client_Owned_90__c=5;
            rebateG.Template_Mchoice_Text__c='';
            rebateG.Template_SpecialtyatCVS_Text__c='';
            //rebateG.Retail_Display__c=false;
            //rebateG.ClientOwned30_Display__c=false;
            //rebateG.ClientOwned90_Display__c=false;
            //rebateG.ClientOwned_Display__c=false;
            //rebateG.Mail_Display__c=false; 
            //rebateG.Maintenance_Choice_Display__c=false;
            rebateG.Template_Retail30_Text__c='';
            //rebateG.Retail30_Display__c=false;
            //rebateG.Retail90_Display__c=false;
            rebateG.Template_SpecialtyatCVS_Display__c=false;
            rebateG.Template_Rcurve_Display__c=true;
            rebateG.Template_Mail_Display__c=false;
            rebateG.Template_Retail_Display__c=false;
            rebateG.Template_Mchoice_Display__c=false;
            rebateG.Rebate_Operations__c = rebateOps.id;
            rebateG.Sequence_Number__c = 1;
            //rebateG.Template_Mail_Label__c='';
            rebateG.Agreement_Line_Item__c =    agrline.id; 
            insert rebateG;
            rebateG.Year__c = '1';
            update rebateG;
            
            Rebate_Guarantees__c rebateG1= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            insert rebateG1;
            
            //mail pricing record
            Mail_Pricing__c  mailPrice=TestDataFactory.createmailPricing(FAFObj.id,mailOps.id );
            mailPrice.Agreement__c=agr.id;
            mailPrice.Agreement_Line_Item__c=agrline.id; 
            mailPrice.Grid_Name__c='';
            mailPrice.LOB__c='ACT';
            mailPrice.Template_BER_Display__c=false;
            mailPrice.Template_BER_Guarantee_Rate_Text__c='';
            mailPrice.Template_Brand_Display__c=false;
            mailPrice.Template_Brand_Rate_Text__c='';
            mailPrice.Template_Dispensing_Fee_Text__c='';
            mailPrice.Year_Begin_Date__c=Date.newInstance(2020, 01, 01);
            mailPrice.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            mailPrice.Brand_Dispensing_Fee__c=5;
            mailPrice.Brand_Basis__c='Standard Brand Discount';
            mailPrice.Generic_Dispensing_Fee__c=5;
            mailPrice.Template_Generic_Display__c=false;
            mailPrice.Template_Generic_Rate_Text__c='';
            mailPrice.Template_GER_Display__c=false;
            mailPrice.Template_GER_Guarantee_Rate_Text__c='';
            mailPrice.Template_MER_Display__c=false;
            mailPrice.Template_MER_Guarantee_Rate_Text__c='';
            mailPrice.Template_NED_Display__c=false;
            mailPrice.Template_NED_Guarantee_Rate_Text__c='';
            mailPrice.Template_NonMacGeneric_Display__c=false;
            mailPrice.Template_Non_MAC_Generic_Rate_Text__c='';
            mailPrice.Template_Non_Preferred_Brand_Rate_Text__c='';
            mailPrice.Template_Preferred_Brand_Rate_Text__c='';
            mailPrice.Template_Preferred_Display__c=false;
            mailPrice.SSG_Display__c=false;          
            mailPrice.Template_SSG_Guarantee_Rate_Text__c='';
            mailPrice.Show_in_Grid__c=true; 
            mailPrice.Brand_Rate__c=5;
            mailPrice.Generic_Rate__c=5;
            insert mailPrice;
            
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
            
            
            Apttus_GridObjectdata.get_createdata(FAFObj.id,'National - NACH7','Transparent','ACT','Test');
            Apttus_GridObjectdata.get_MailGridObjectdata(agrline.Id, 'Mail_Pricing__c');
            //Apttus_GridObjectdata.get_RebGridObjectdata(agrline.id,'Rebate_Guarantees__c');
            //Apttus_GridObjectdata.get_RebCarveOutObjectdata(agrline.id,'Rebate_Guarantees__c');
            Apttus_GridObjectdata.get_Addprogramdata(agrline.id,'Clinical_Solutions__c');
            //Apttus_GridObjectdata.get_Mailpricingdata(FAFObj.id);
            //Apttus_GridObjectdata.get_Rebatedata(FAFObj.id,'3 Tier Q','All Rx','Custom','HPGST','Custom Formulary');
            Apttus_GridObjectdata.get_RebatedataSpec(FAFObj.id,'3 Tier Q','All Rx','Custom','HPGST','Custom Formulary');
            Apttus_GridObjectdata.get_savemaildata(mailPrice);
            Apttus_GridObjectdata.deleteRebategrid(FAFObj.id,'3 Tier Q','All Rx','Custom','HPGST','Custom Formulary', false,'test');
            Apttus_GridObjectdata.deletemailpricinggrid(FAFObj.id,'ACT');
            Apttus_GridObjectdata.get_InsertRebatedata(rebateG1);
           // Apttus_GridObjectdata.get_saveRebatedata(rebateG1);
            
            Apttus_GridObjectdata.getDocName(agr.id);
           //Apttus_GridObjectdata.contentdocument('');
           //Apttus_GridObjectdata.updatefilename('','','');
            
            
            //Apttus_GridObjectdata.get_yearcount(FAFObj.id);
            //Apttus_GridObjectdata.deleteSelectedRebateRecords(rebateG.id);
            //Apttus_GridObjectdata.deleteSelectedmailRecords(mailPrice.id);
            
            Test.StopTest();
        }
    }
    //method 5
     static testmethod void SpecialtyGuaranteeNewEditClassTestMeth5() {
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
            agr.Apttus__Agreement_Category__c='PCD';
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
            
            test.startTest();
            Task__c task= new Task__c();
            //task.Owner=useObjNew.id;
            task.Account__c=accObj.id;
            task.Agreement__c=agr.id;
            task.FAF_ID__c=FAFObj.id;
            insert task;
            
            Offer__c offer= new Offer__c();
            //offer.Account__c=accObj.id;
            offer.PCD__c=agr.id;
            offer.Alert_Message__c='';
            //offer.Name='abc';
            offer.OfferCategory__c='Renewal';
            offer.OfferDescriptor__c='';
            //Offer_Revenue_PCD__c,
            //OfferTotalRevenue__c,PCD_Offer_link__c,
            offer.iUMSTask__c=task.id;
            insert offer;
            
            task.Offer__c=offer.id;
            update task;
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //mail operation
            Mail_Operations__c  mailOps = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
            //rebate operation record
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            insert rebateOps;
            //rebate guarantee record
            Rebate_Guarantees__c rebateG= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
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
            rebateG.Template_SpecialtyatRetail_Text__c='';
            rebateG.Template_SpecialtyatRetail_Display__c=false;
            rebateG.Template_ClientOwned90_Display__c=false;
            rebateG.Template_Retail90_Text__c='';
            rebateG.Sorting_Number__c=1;
            rebateG.Template_Retail90_Display__c=false;
            rebateG.Template_Retail30_Display__c=false;
            rebateG.Modeled_Non_Specialty_Formulary_Name__c='';
            rebateG.Modeled_Non_Specialty_PlanDesign__c='';
            rebateG.Template_Retail_Text__c='';
            rebateG.Template_Mail_Text__c='';
            //Template_Specialty_Formula__c,
            rebateG.Template_Specialty_Carveout_Text__c='';
            rebateG.Template_Specialty_Carveout_Label_Text__c='';
            rebateG.Modeled_Specialty_PlanDesign__c='';
            rebateG.Client_Owned_30__c=5;
            rebateG.Modeled_Specialty_Formulary_Name__c='';
            rebateG.Template_Clientowned30_Text__c=''; rebateG.Template_ClientOwned30_Display__c=false; 
            rebateG.Template_Clientowned90_Text__c='';
            rebateG.Template_Clientowned_Text__c='';  rebateG.Client_Owned_30_1__c=5;
            rebateG.Client_Owned_90__c=5;
            rebateG.Template_Mchoice_Text__c='';
            rebateG.Template_SpecialtyatCVS_Text__c='';
            //rebateG.Retail_Display__c=false;
            //rebateG.ClientOwned30_Display__c=false;
            //rebateG.ClientOwned90_Display__c=false;
            //rebateG.ClientOwned_Display__c=false;
            //rebateG.Mail_Display__c=false; 
            //rebateG.Maintenance_Choice_Display__c=false;
            rebateG.Template_Retail30_Text__c='';
            //rebateG.Retail30_Display__c=false;
            //rebateG.Retail90_Display__c=false;
            rebateG.Template_SpecialtyatCVS_Display__c=false;
            rebateG.Template_Rcurve_Display__c=true;
            rebateG.Template_Mail_Display__c=false;
            rebateG.Template_Retail_Display__c=false;
            rebateG.Template_Mchoice_Display__c=false;
            //rebateG.Template_Mail_Label__c='';
            rebateG.Agreement_Line_Item__c =    agrline.id; 
            insert rebateG;
            rebateG.Year__c = '1';
            update rebateG;
            
            Rebate_Guarantees__c rebateG1= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            insert rebateG1;
            
            //mail pricing record
            Mail_Pricing__c  mailPrice=TestDataFactory.createmailPricing(FAFObj.id,mailOps.id );
            mailPrice.Agreement__c=agr.id;
            mailPrice.Agreement_Line_Item__c=agrline.id; 
            mailPrice.Grid_Name__c='';
            mailPrice.LOB__c='ACT';
            mailPrice.Template_BER_Display__c=false;
            mailPrice.Template_BER_Guarantee_Rate_Text__c='';
            mailPrice.Template_Brand_Display__c=false;
            mailPrice.Template_Brand_Rate_Text__c='';
            mailPrice.Template_Dispensing_Fee_Text__c='';
            mailPrice.Year_Begin_Date__c=Date.newInstance(2020, 01, 01);
            mailPrice.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            mailPrice.Brand_Dispensing_Fee__c=5;
            mailPrice.Brand_Basis__c='Standard Brand Discount';
            mailPrice.Generic_Dispensing_Fee__c=5;
            mailPrice.Template_Generic_Display__c=false;
            mailPrice.Template_Generic_Rate_Text__c='';
            mailPrice.Template_GER_Display__c=false;
            mailPrice.Template_GER_Guarantee_Rate_Text__c='';
            mailPrice.Template_MER_Display__c=false;
            mailPrice.Template_MER_Guarantee_Rate_Text__c='';
            mailPrice.Template_NED_Display__c=false;
            mailPrice.Template_NED_Guarantee_Rate_Text__c='';
            mailPrice.Template_NonMacGeneric_Display__c=false;
            mailPrice.Template_Non_MAC_Generic_Rate_Text__c='';
            mailPrice.Template_Non_Preferred_Brand_Rate_Text__c='';
            mailPrice.Template_Preferred_Brand_Rate_Text__c='';
            mailPrice.Template_Preferred_Display__c=false;
            mailPrice.SSG_Display__c=false;          
            mailPrice.Template_SSG_Guarantee_Rate_Text__c='';
            mailPrice.Show_in_Grid__c=true; 
            mailPrice.Brand_Rate__c=5;
            mailPrice.Generic_Rate__c=5;
            insert mailPrice;
            
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
            
            
            Apttus_GridObjectdata.get_UpdateRebatedata(FAFObj.id,true,true,true);
            Apttus_GridObjectdata.get_Offer(accObj.id,task.id);
            //Apttus_GridObjectdata.get_InsertRebatedata(rebateG1); sonal
           // Apttus_GridObjectdata.get_saveRebatedata(rebateG1);
           Apttus_GridObjectdata.get_Mailpricingdata(FAFObj.id);
            
            //Apttus_GridObjectdata.get_createdata(FAFObj.id,'National - NACH7','Transparent','ACT','Test');
            //Apttus_GridObjectdata.get_yearcount(FAFObj.id);
            //Apttus_GridObjectdata.deleteSelectedRebateRecords(rebateG.id);
            Apttus_GridObjectdata.deleteSelectedmailRecords(mailPrice.id);
            Apttus_GridObjectdata.deleteClinicalSolgrid(clinicSol.FAF_ID__c);
            Test.StopTest();
        }
    }
     //method 6
     static testmethod void AgreementMethod() {
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
            agr.Apttus__Agreement_Category__c='PCD';
            agr.Internal_Review_Completed__c=false;
            agr.PCD_Status__c ='Generate Document';
            insert agr;
            
             Apttus__APTS_Template__c aptemp=new Apttus__APTS_Template__c();
            aptemp.Name='Client Facing PCD';
            aptemp.Apttus__Type__c='Agreement'; 
            //aptemp.Next_Template__c='';
            aptemp.Apttus__IsActive__c=true;
            aptemp.Apttus__BusinessObject__c='Apttus__APTS_Agreement__c';
            insert aptemp;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c =agrline.id;
            update agr;
            
            Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
            Docversion.Name = 'Generate Agreement';
            Docversion.Apttus__AgreementId__c = agr.id;
            Docversion.Apttus__LatestVersion__c ='0';
            Docversion.Apttus__ReferenceId__c = aptemp.Id;
            Docversion.Apttus__TemplateId__c = aptemp.Id;
            Docversion.Apttus__Title__c = 'filename';
            insert Docversion;
            
           
            
            Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
            adDetailObj.Agreement__c=agr.id;
            adDetailObj.LOB_Detail__c='STD';
            adDetailObj.Name='66.0.0';
            adDetailObj.Apttus__Title__c='TESTCLASSRUN';
            adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
            adDetailObj.Apttus__VersionMajor__c=66;
            adDetailObj.Apttus__VersionMinor__c=0;
            adDetailObj.Apttus__VersionRevision__c=0;
            insert adDetailObj;
            
            test.startTest();
             //Added by sonal Sharma
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            insert ntwrkOpsObj;
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            //ntwrkPriceObj.Plan_Year__c=
            //ntwrkPriceObj.SSG_Guarantee__c
            //ntwrkPriceObj.OED_Count__c,
            //NED_Count__c,
            //MER_Count__c,
            //GER_Count__c,
            //BER_Guarantee__c,                               
            ntwrkPriceObj.Agreement__c= agr.id;
            ntwrkPriceObj.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj.Custom_Network_Description__c='';
            ntwrkPriceObj.Network_Name_for_Grid__c='';
            ntwrkPriceObj.Template_BER_Display__c=false;
            ntwrkPriceObj.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Brand_Display__c=false;
            ntwrkPriceObj.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj.Template_Generic_BER_Guarantee_Rate_Text__c='';
            //ntwrkPriceObj.Template_Generic_Dispensing_Fee__c,
            ntwrkPriceObj.Template_Generic_Display__c=false;
            ntwrkPriceObj.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_GER_Display__c=false;
            ntwrkPriceObj.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_MCCP__c=false;
            ntwrkPriceObj.Template_MER_Display__c=false;
            ntwrkPriceObj.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_NED_Display__c=false;
            ntwrkPriceObj.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Network_Name_Text__c='';
            ntwrkPriceObj.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_OED_Display__c=false;
            ntwrkPriceObj.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Display__c=false;
            ntwrkPriceObj.SSG_Display__c=false;                
            ntwrkPriceObj.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Network_Type__c='Transparent';
            ntwrkPriceObj.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj.Show_in_Grid__c=true;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Primary';
            //FAF_ID__r.LOB2__c                               
            insert ntwrkPriceObj;
            
            Billing_Operations__c bo =  TestDataFactory.createBillOps(FAFObj.id);
            insert bo;
            Billing_Administrative_Fees__c baf =  TestDataFactory.createBillAdminFees(FAFObj.id, bo.id);
            insert baf;
            Mail_Operations__c mo = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mo;
            Mail_Pricing__c mp = TestDataFactory.createmailPricing(FAFObj.id, mo.id);
            insert mp;
            
           try{
            Apttus_GridObjectdata.get_status('');
           }catch(Exception e){}
            try{
            Apttus_GridObjectdata.get_account('');
           }catch(Exception e){}
           
            Apttus_GridObjectdata.generatedocument('test','pdf',agr.id,'test','test', 1, Date.newInstance(2020, 3, 3), Date.newInstance(2016, 4, 4));
            Apttus_GridObjectdata.deletepricinggrid(FAFObj.id,'MC(84-90)CP','Transparent','','ACT');
            Apttus_GridObjectdata.get_updatestatus(agr.PCD_Status__c, agr.id);
            try{
            Apttus_GridObjectdata.get_agreementterms('mockid');
            }catch(Exception e){}
            //Apttus_GridObjectdata.get_agreementterms(agrline.id);
            try{
            Apttus_GridObjectdata.get_updatestatusali('mockid', 'mockid');
            }catch(Exception e){}
            Apttus_GridObjectdata.get_updatestatusali('mockstage', agr.id);
            try{
            Apttus_GridObjectdata.deleteadminfee(FAFObj.id);
            Apttus_GridObjectdata.deleteadminfee(null);
            }catch(Exception e){}
            try{
            Apttus_GridObjectdata.saveadmindatalist(new List<Billing_Administrative_Fees__c>{baf}, bo.id);
            }catch(Exception e){}
            Apttus_GridObjectdata.get_savemaildatalist(new List<Mail_Pricing__c>{mp}, mo.id);
            Apttus_GridObjectdata.get_savemaildatalist(new List<Mail_Pricing__c>{new Mail_Pricing__c()}, mo.id);
            try{
            Apttus_GridObjectdata.saveadmindatalist(new List<Billing_Administrative_Fees__c>{new Billing_Administrative_Fees__c()}, bo.id);
            }catch(Exception e){}
            Apttus_GridObjectdata.findPicklistOptionsadmintype('Billing_Administrative_Fees__c', 'Admin_Fee_Type__c', '340B');
            Apttus_GridObjectdata.get_savemaildata(new Mail_Pricing__c());
            try{
            Apttus_GridObjectdata.get_saveSpecialtydata(new Specialty_Pricing__c(), baf.id);
            }catch(Exception e){}
            Attachment attach= new Attachment();
            attach.Name='Attachment';
            attach.ContentType='Attachment';
            attach.ParentId=adDetailObj.Agreement__c;
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            insert attach;
            try{
            Apttus_GridObjectdata.updatefilename(adDetailObj.id,'test','docx');
            }catch(Exception e){}
            Task__c task= new Task__c();
            //task.Owner=useObjNew.id;
            task.Account__c=accObj.id;
            task.Agreement__c=agr.id;
            task.FAF_ID__c=FAFObj.id;
            insert task;
            
            Test.StopTest();
        }
    }
        static testmethod void AgreementDocuMethod() {
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
            agr.Apttus__Agreement_Category__c='PCD';
            agr.PCD_Status__c='';
            insert agr;
            
             Apttus__APTS_Template__c aptemp=new Apttus__APTS_Template__c();
            aptemp.Name='Client Facing PCD';
            aptemp.Apttus__Type__c='Agreement'; 
            aptemp.Apttus__Agreement_Types__c='PCD';
            aptemp.Apttus__Guidance__c='';
            aptemp.Apttus__Category__c='Legal';
            aptemp.Apttus__Subcategory__c ='';
            //aptemp.Next_Template__c='';
            aptemp.Apttus__IsActive__c=true;
            aptemp.Apttus__BusinessObject__c='Apttus__APTS_Agreement__c';
            insert aptemp;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c =agrline.id;
            update agr;
            
            Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
            Docversion.Name = 'Generate Agreement';
            //Docversion.Apttus__AgreementId__c = agr.id;
            Docversion.Apttus__LatestVersion__c ='0';
            Docversion.Apttus__ReferenceId__c = aptemp.Id;
            Docversion.Apttus__TemplateId__c = aptemp.Id;
            Docversion.Apttus__Title__c = 'filename';
            insert Docversion;
            
           
            
            Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
            adDetailObj.Agreement__c=agr.id;
            adDetailObj.LOB_Detail__c='STD';
            adDetailObj.Name='66.0.0';
            adDetailObj.Apttus__Title__c='PCD - NTN USA Corporation_Original_2020-02-10.docx';
            adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
            adDetailObj.Apttus__VersionMajor__c=66;
            adDetailObj.Apttus__VersionMinor__c=0;
            adDetailObj.Apttus__VersionRevision__c=0;
            adDetailObj.Apttus__FileType__c='docx';
            adDetailObj.Apttus__ContentId__c='';
            adDetailObj.Apttus__Action2__c='Generate Agreement';
            insert adDetailObj;
            
            //billing operation records
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            
            Billing_Administrative_Fees__c  billingAdmin= TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billingOps.id);
            billingAdmin.Agreement__c=agr.id;
            billingAdmin.Agreement_Line_Item__c=agrline.id;
            billingAdmin.Additive__c=false;
            billingAdmin.Broker_Amount__c=5;
            billingAdmin.PCD_Manual_Claim_Fee__c=false;
            billingAdmin.PCD_Unique_340B_Fee_Type__c=false;
            billingAdmin.PCD_Unique_EGWPPMPM_Fee_Type__c=false;
            billingAdmin.PCD_Unique_Fee_Type__c=false;
            billingAdmin.PCD_Unique_Manual_Fee_Type__c=false;
            billingAdmin.Show_in_Grid__c=true;
            billingAdmin.Template_340B_Type_Text__c='';
            billingAdmin.Template_Admin_Fee_Type_Text__c='';
            billingAdmin.Template_EGWPPMPM_Fee_Type_Text__c='';
            billingAdmin.Template_Manual_Claim_Admin_Text__c='';
            billingAdmin.Year_Start_Date__c=Date.newInstance(2020, 01, 01);
            billingAdmin.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            insert billingAdmin;
           
            /*Apttus__APTS_Agreement__History agHistory = new Apttus__APTS_Agreement__History();
            //agHistory.CreatedDate=Date.newInstance(2020,01,01);
            //agHistory.Field='';
            //agHistory.NewValue='';
            //agHistory.OldValue='';
            //agHistory.ParentId=agr.id;
            insert agHistory;
           */
           
            Attachment attach= new Attachment();
            attach.Name='Attachment';
            attach.ContentType='Attachment';
            attach.ParentId=Docversion.id;
            try{
            insert attach;
            }catch(Exception ex){}
            
            test.startTest();
            try{
            Apttus_GridObjectdata.updatefilename(adDetailObj.id,'test','docx');
            }catch(Exception ex){}
          /*  try{
            Apttus_GridObjectdata.generatedocument('test','pdf',agr.id,'test','test');
            }catch(Exception e){}*/

            try{
            Apttus_GridObjectdata.get_lineitem(agr.id);
            }catch(Exception e){}
            try{
            Apttus_GridObjectdata.findPicklistOptions('Network_Pricing__c','Year__c');
            }catch(Exception e){}
            Apttus_GridObjectdata.contentdocument(adDetailObj.id);
            Apttus_GridObjectdata.get_BillingAdmindata(FAFObj.id);
            Apttus_GridObjectdata.get_saveadminfeedata(billingAdmin);
            Apttus_GridObjectdata.get_aggrhistory(accObj.id);
            try{
            Apttus_GridObjectdata.mergedocument(agr.id,'pdf');
            Apttus_GridObjectdata.mergedocument(agr.id,'docx');
            
            }
            catch(Exception EX){
            }
            Apttus_GridObjectdata.get_updatestatus(agr.PCD_Status__c, agr.id);
            Apttus_GridObjectdata.get_aggrhistory(accObj.id);
            Apttus_GridObjectdata.get_status(agr.id);
             try{
            Apttus_GridObjectdata.get_account(agr.id);
           }catch(Exception e){}
           try{
           Apttus_GridObjectdata.getTemplates('20','2');
           }catch(exception e){}
          /*  try{
          Apttus_GridObjectdata.generatedocument('test','pdf',agr.id,'test','test');
           }catch(Exception e){}*/
           try{
           Apttus_GridObjectdata.findPicklistOptionsadmintype('Billing_Administrative_Fees__c','Admin_Fee_Type__c ','ELECRONIC');
           }catch(Exception e){}
           Apttus_GridObjectdata.get_BillingAdmindatamanual(FAFObj.id);
           Apttus_GridObjectdata.get_BillingAdmindata340b(FAFObj.id);
           Apttus_GridObjectdata.deleteSelectedadminRecords(billingAdmin.id);
           Apttus_GridObjectdata.get_AgreementObj(agr.id);
           Apttus_GridObjectdata.update_AgreementObj(agr.id, true);  
           Test.StopTest();
        }
    }
    // method 8    
    static testmethod void Methiod8(){
        Apttus_GridObjectdata.getDependentSelectOptions1('Network_Pricing__c', 'Network_Name__c', 'Retail_Network_Ordinal__c', 'Access Based Network');
        try{
        Apttus_GridObjectdata.updateMPSeq('', '', '1', '2', true);
        }catch(exception e){}
        try{
        Apttus_GridObjectdata.updateRGSeq('', '', '1');
        }catch(exception e){}
        try{
        Apttus_GridObjectdata.updateSpecSeq('', '', '1');
        }catch(exception e){}
    }
    
    static testmethod void NPTestMeth1() {
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
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //billing operation records
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            
            //update faf
            FAFObj.Template_Master_Electronic_Fee_text__c='';
            FAFObj.Template_Master_Manual_Claim_Fee_text__c='';
            FAFObj.Template_340B_Display__c=false;
            FAFObj.Template_Master_340B_Type_text__c='';
            FAFObj.Template_Master_EGWPPMPM_Type_text__c='';
            FAFObj.Template_EGWPPMPM_Display__c=false;
            FAFObj.Agreement_Line_Item__c =agrline.id;  
            update FAFObj;
            
            test.startTest();
            //Added by sonal Sharma
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            ntwrkOpsObj.Agreement_Line_Item__c=agrline.id;
            insert ntwrkOpsObj;
            
            list<Network_Pricing__c> npListInsert = new list<Network_Pricing__c>();
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj.Agreement__c= agr.id;
            ntwrkPriceObj.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj.Custom_Network_Description__c='Test';
            ntwrkPriceObj.Network_Name_for_Grid__c='test1';
            ntwrkPriceObj.Template_BER_Display__c=false;
            ntwrkPriceObj.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Brand_Display__c=false;
            ntwrkPriceObj.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Generic_Display__c=false;
            ntwrkPriceObj.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_GER_Display__c=false;
            ntwrkPriceObj.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_MCCP__c=false;
            ntwrkPriceObj.Template_MER_Display__c=false;
            ntwrkPriceObj.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_NED_Display__c=false;
            ntwrkPriceObj.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Network_Name_Text__c='';
            ntwrkPriceObj.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_OED_Display__c=false;
            ntwrkPriceObj.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Display__c=false;
            ntwrkPriceObj.SSG_Display__c=false;                
            ntwrkPriceObj.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Network_Type__c='Transparent';
            ntwrkPriceObj.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj.Show_in_Grid__c=true;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj.Network_Name__c ='National - NACH7';
            ntwrkPriceObj.Sequence_Number__c =1;
            ntwrkPriceObj.LOB__c ='STD';
            //insert ntwrkPriceObj;
            npListInsert.add(ntwrkPriceObj);
            
           Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Agreement__c= agr.id;
            ntwrkPriceObj1.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj1.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj1.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj1.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj1.Custom_Network_Description__c='Test2';
            ntwrkPriceObj1.Network_Name_for_Grid__c='test2';
            ntwrkPriceObj1.Template_BER_Display__c=false;
            ntwrkPriceObj1.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Brand_Display__c=false;
            ntwrkPriceObj1.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj1.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Generic_Display__c=false;
            ntwrkPriceObj1.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj1.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj1.Template_GER_Display__c=false;
            ntwrkPriceObj1.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_MCCP__c=false;
            ntwrkPriceObj1.Template_MER_Display__c=false;
            ntwrkPriceObj1.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_NED_Display__c=false;
            ntwrkPriceObj1.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Network_Name_Text__c='';
            ntwrkPriceObj1.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj1.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj1.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_OED_Display__c=false;
            ntwrkPriceObj1.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_Preferred_Display__c=false;
            ntwrkPriceObj1.SSG_Display__c=false;                
            ntwrkPriceObj1.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Network_Type__c='Transparent';
            ntwrkPriceObj1.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj1.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj1.Show_in_Grid__c=true;
            ntwrkPriceObj1.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj1.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj1.Network_Name__c ='National - NACH7';
            ntwrkPriceObj1.Sequence_Number__c =2;
            ntwrkPriceObj1.LOB__c ='STD';
            //insert ntwrkPriceObj1;
            npListInsert.add(ntwrkPriceObj1); 
            
             Network_Pricing__c ntwrkPriceObj2= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj2.Agreement__c= agr.id;
            ntwrkPriceObj2.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj2.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj2.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj2.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj2.Custom_Network_Description__c='Test2';
            ntwrkPriceObj2.Network_Name_for_Grid__c='test2';
            ntwrkPriceObj2.Template_BER_Display__c=false;
            ntwrkPriceObj2.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Brand_Display__c=false;
            ntwrkPriceObj2.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj2.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Generic_Display__c=false;
            ntwrkPriceObj2.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj2.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj2.Template_GER_Display__c=false;
            ntwrkPriceObj2.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_MCCP__c=false;
            ntwrkPriceObj2.Template_MER_Display__c=false;
            ntwrkPriceObj2.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_NED_Display__c=false;
            ntwrkPriceObj2.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Network_Name_Text__c='';
            ntwrkPriceObj2.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj2.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj2.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_OED_Display__c=false;
            ntwrkPriceObj2.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_Preferred_Display__c=false;
            ntwrkPriceObj2.SSG_Display__c=false;                
            ntwrkPriceObj2.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Network_Type__c='Transparent';
            ntwrkPriceObj2.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj2.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj2.Show_in_Grid__c=true;
            ntwrkPriceObj2.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj2.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj2.Network_Name__c ='National - NACH7';
            ntwrkPriceObj2.Sequence_Number__c =3;
            ntwrkPriceObj2.LOB__c ='STD';
            //insert ntwrkPriceObj2;
            npListInsert.add(ntwrkPriceObj2);   
            
            insert npListInsert;
            npListInsert[0].Sequence_Number__c = 1;
            npListInsert[1].Sequence_Number__c = 2;
            npListInsert[2].Sequence_Number__c = 3;
            update npListInsert;
            
            list<Network_Pricing__c> npList1 = [
                SELECT id, Sequence_Number__c
                from Network_Pricing__c where FAF_Network_Ops__c = :ntwrkOpsObj.id Order By Sequence_Number__c asc
            ];
            system.debug('npList1-----3------'+npList1);          
            try{
                //list<Network_Pricing__c> npList = Apttus_GridObjectdata.get_GridObjectdata(agrline.Id,'Network_Pricing__c');
                //system.debug('npList-----------'+npList.size());
                Apttus_GridObjectdata.checkValid(npList1[0].Id, agrline.Id,'', '2', false);
                Apttus_GridObjectdata.updateNPSeq(npList1[0].Id, agrline.Id,'', '3', false);
            }
            Catch(Exception Ex){}
            Test.StopTest();
        }
    }
    static testmethod void NPTestMeth2() {
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
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //billing operation records
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            
            //update faf
            FAFObj.Template_Master_Electronic_Fee_text__c='';
            FAFObj.Template_Master_Manual_Claim_Fee_text__c='';
            FAFObj.Template_340B_Display__c=false;
            FAFObj.Template_Master_340B_Type_text__c='';
            FAFObj.Template_Master_EGWPPMPM_Type_text__c='';
            FAFObj.Template_EGWPPMPM_Display__c=false;
            FAFObj.Agreement_Line_Item__c =agrline.id;  
            update FAFObj;
            
            test.startTest();
            //Added by sonal Sharma
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            ntwrkOpsObj.Agreement_Line_Item__c=agrline.id;
            insert ntwrkOpsObj;
            
            list<Network_Pricing__c> npListInsert = new list<Network_Pricing__c>();
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj.Agreement__c= agr.id;
            ntwrkPriceObj.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj.Custom_Network_Description__c='Test';
            ntwrkPriceObj.Network_Name_for_Grid__c='test1';
            ntwrkPriceObj.Template_BER_Display__c=false;
            ntwrkPriceObj.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Brand_Display__c=false;
            ntwrkPriceObj.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Generic_Display__c=false;
            ntwrkPriceObj.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_GER_Display__c=false;
            ntwrkPriceObj.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_MCCP__c=false;
            ntwrkPriceObj.Template_MER_Display__c=false;
            ntwrkPriceObj.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_NED_Display__c=false;
            ntwrkPriceObj.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Network_Name_Text__c='';
            ntwrkPriceObj.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_OED_Display__c=false;
            ntwrkPriceObj.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Display__c=false;
            ntwrkPriceObj.SSG_Display__c=false;                
            ntwrkPriceObj.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Network_Type__c='Transparent';
            ntwrkPriceObj.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj.Show_in_Grid__c=true;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj.Network_Name__c ='National - NACH7';
            ntwrkPriceObj.Sequence_Number__c =1;
            ntwrkPriceObj.LOB__c ='STD';
            //insert ntwrkPriceObj;
            npListInsert.add(ntwrkPriceObj);
            
           Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Agreement__c= agr.id;
            ntwrkPriceObj1.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj1.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj1.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj1.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj1.Custom_Network_Description__c='Test2';
            ntwrkPriceObj1.Network_Name_for_Grid__c='test2';
            ntwrkPriceObj1.Template_BER_Display__c=false;
            ntwrkPriceObj1.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Brand_Display__c=false;
            ntwrkPriceObj1.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj1.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Generic_Display__c=false;
            ntwrkPriceObj1.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj1.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj1.Template_GER_Display__c=false;
            ntwrkPriceObj1.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_MCCP__c=false;
            ntwrkPriceObj1.Template_MER_Display__c=false;
            ntwrkPriceObj1.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_NED_Display__c=false;
            ntwrkPriceObj1.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Network_Name_Text__c='';
            ntwrkPriceObj1.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj1.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj1.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_OED_Display__c=false;
            ntwrkPriceObj1.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_Preferred_Display__c=false;
            ntwrkPriceObj1.SSG_Display__c=false;                
            ntwrkPriceObj1.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Network_Type__c='Transparent';
            ntwrkPriceObj1.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj1.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj1.Show_in_Grid__c=true;
            ntwrkPriceObj1.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj1.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj1.Network_Name__c ='National - NACH7';
            ntwrkPriceObj1.Sequence_Number__c =2;
            ntwrkPriceObj1.LOB__c ='STD';
            //insert ntwrkPriceObj1;
            npListInsert.add(ntwrkPriceObj1); 
            
             Network_Pricing__c ntwrkPriceObj2= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj2.Agreement__c= agr.id;
            ntwrkPriceObj2.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj2.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj2.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj2.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj2.Custom_Network_Description__c='Test2';
            ntwrkPriceObj2.Network_Name_for_Grid__c='test2';
            ntwrkPriceObj2.Template_BER_Display__c=false;
            ntwrkPriceObj2.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Brand_Display__c=false;
            ntwrkPriceObj2.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj2.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Generic_Display__c=false;
            ntwrkPriceObj2.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj2.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj2.Template_GER_Display__c=false;
            ntwrkPriceObj2.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_MCCP__c=false;
            ntwrkPriceObj2.Template_MER_Display__c=false;
            ntwrkPriceObj2.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_NED_Display__c=false;
            ntwrkPriceObj2.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Network_Name_Text__c='';
            ntwrkPriceObj2.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj2.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj2.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_OED_Display__c=false;
            ntwrkPriceObj2.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_Preferred_Display__c=false;
            ntwrkPriceObj2.SSG_Display__c=false;                
            ntwrkPriceObj2.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Network_Type__c='Transparent';
            ntwrkPriceObj2.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj2.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj2.Show_in_Grid__c=true;
            ntwrkPriceObj2.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj2.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj2.Network_Name__c ='National - NACH7';
            ntwrkPriceObj2.Sequence_Number__c =null;
            ntwrkPriceObj2.LOB__c ='STD';
            //insert ntwrkPriceObj2;
            npListInsert.add(ntwrkPriceObj2);   
            
            insert npListInsert;
            npListInsert[0].Sequence_Number__c = 1;
            npListInsert[1].Sequence_Number__c = 3;
            npListInsert[2].Sequence_Number__c = null;
            update npListInsert;
            
            list<Network_Pricing__c> npList1 = [
                SELECT id, Sequence_Number__c
                from Network_Pricing__c where FAF_Network_Ops__c = :ntwrkOpsObj.id Order By Sequence_Number__c asc
            ];
            system.debug('npList1-----3------'+npList1);          
            try{
                //list<Network_Pricing__c> npList = Apttus_GridObjectdata.get_GridObjectdata(agrline.Id,'Network_Pricing__c');
                //system.debug('npList-----------'+npList.size());
                Apttus_GridObjectdata.checkValid(npList1[0].Id, agrline.Id,'', '2', false);
                Apttus_GridObjectdata.updateNPSeq(npList1[2].Id, agrline.Id,'', '2', false);
            }
            Catch(Exception Ex){}
            Test.StopTest();
        }
    }
    static testmethod void NPTestMeth3() {
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
            
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            //billing operation records
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            insert billingOps;
            
            //update faf
            FAFObj.Template_Master_Electronic_Fee_text__c='';
            FAFObj.Template_Master_Manual_Claim_Fee_text__c='';
            FAFObj.Template_340B_Display__c=false;
            FAFObj.Template_Master_340B_Type_text__c='';
            FAFObj.Template_Master_EGWPPMPM_Type_text__c='';
            FAFObj.Template_EGWPPMPM_Display__c=false;
            FAFObj.Agreement_Line_Item__c =agrline.id;  
            update FAFObj;
            
            test.startTest();
            //Added by sonal Sharma
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            ntwrkOpsObj.Agreement_Line_Item__c=agrline.id;
            insert ntwrkOpsObj;
            
            list<Network_Pricing__c> npListInsert = new list<Network_Pricing__c>();
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj.Agreement__c= agr.id;
            ntwrkPriceObj.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj.Custom_Network_Description__c='Test';
            ntwrkPriceObj.Network_Name_for_Grid__c='test1';
            ntwrkPriceObj.Template_BER_Display__c=false;
            ntwrkPriceObj.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Brand_Display__c=false;
            ntwrkPriceObj.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Generic_Display__c=false;
            ntwrkPriceObj.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_GER_Display__c=false;
            ntwrkPriceObj.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_MCCP__c=false;
            ntwrkPriceObj.Template_MER_Display__c=false;
            ntwrkPriceObj.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_NED_Display__c=false;
            ntwrkPriceObj.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Network_Name_Text__c='';
            ntwrkPriceObj.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_OED_Display__c=false;
            ntwrkPriceObj.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj.Template_Preferred_Display__c=false;
            ntwrkPriceObj.SSG_Display__c=false;                
            ntwrkPriceObj.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj.Network_Type__c='Transparent';
            ntwrkPriceObj.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj.Show_in_Grid__c=true;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj.Network_Name__c ='National - NACH7';
            ntwrkPriceObj.Sequence_Number__c =1;
            ntwrkPriceObj.LOB__c ='STD';
            //insert ntwrkPriceObj;
            npListInsert.add(ntwrkPriceObj);
            
           Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Agreement__c= agr.id;
            ntwrkPriceObj1.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj1.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj1.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj1.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj1.Custom_Network_Description__c='Test2';
            ntwrkPriceObj1.Network_Name_for_Grid__c='test2';
            ntwrkPriceObj1.Template_BER_Display__c=false;
            ntwrkPriceObj1.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Brand_Display__c=false;
            ntwrkPriceObj1.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj1.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Generic_Display__c=false;
            ntwrkPriceObj1.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj1.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj1.Template_GER_Display__c=false;
            ntwrkPriceObj1.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_MCCP__c=false;
            ntwrkPriceObj1.Template_MER_Display__c=false;
            ntwrkPriceObj1.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_NED_Display__c=false;
            ntwrkPriceObj1.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Network_Name_Text__c='';
            ntwrkPriceObj1.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj1.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj1.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_OED_Display__c=false;
            ntwrkPriceObj1.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj1.Template_Preferred_Display__c=false;
            ntwrkPriceObj1.SSG_Display__c=false;                
            ntwrkPriceObj1.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj1.Network_Type__c='Transparent';
            ntwrkPriceObj1.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj1.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj1.Show_in_Grid__c=true;
            ntwrkPriceObj1.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj1.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj1.Network_Name__c ='National - NACH7';
            ntwrkPriceObj1.Sequence_Number__c =2;
            ntwrkPriceObj1.LOB__c ='STD';
            //insert ntwrkPriceObj1;
            npListInsert.add(ntwrkPriceObj1); 
            
             Network_Pricing__c ntwrkPriceObj2= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj2.Agreement__c= agr.id;
            ntwrkPriceObj2.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
            ntwrkPriceObj2.Year_End_Date__c=Date.newInstance(2020, 01, 31);
            ntwrkPriceObj2.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj2.Non_MAC_Generic_Rate__c=23.00;                               
            ntwrkPriceObj2.Custom_Network_Description__c='Test2';
            ntwrkPriceObj2.Network_Name_for_Grid__c='test2';
            ntwrkPriceObj2.Template_BER_Display__c=false;
            ntwrkPriceObj2.Template_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Brand_Display__c=false;
            ntwrkPriceObj2.Template_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_Dispensing_Fee_Text__c='';
            ntwrkPriceObj2.Template_Generic_BER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Generic_Display__c=false;
            ntwrkPriceObj2.Template_Generic_OR_Mac_Text__c='';
            ntwrkPriceObj2.Template_Generic_Rate_Text__c='';
            ntwrkPriceObj2.Template_GER_Display__c=false;
            ntwrkPriceObj2.Template_GER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_MCCP__c=false;
            ntwrkPriceObj2.Template_MER_Display__c=false;
            ntwrkPriceObj2.Template_MER_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_NED_Display__c=false;
            ntwrkPriceObj2.Template_NED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Network_Name_Text__c='';
            ntwrkPriceObj2.Template_NonMacGeneric_Display__c=false;
            ntwrkPriceObj2.Template_Non_MAC_Generic_Rate_Text__c='';
            ntwrkPriceObj2.Template_Non_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_OED_Display__c=false;
            ntwrkPriceObj2.Template_OED_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Template_Preferred_Brand_Rate_Text__c='';
            ntwrkPriceObj2.Template_Preferred_Display__c=false;
            ntwrkPriceObj2.SSG_Display__c=false;                
            ntwrkPriceObj2.Template_SSG_Guarantee_Rate_Text__c='';
            ntwrkPriceObj2.Network_Type__c='Transparent';
            ntwrkPriceObj2.Generic_Basis__c='MAC Modeled & Non-MAC';   
            ntwrkPriceObj2.Agreement_Line_Item__c=agrline.id;
            ntwrkPriceObj2.Show_in_Grid__c=true;
            ntwrkPriceObj2.Retail_Network_Ordinal__c='Primary';
            ntwrkPriceObj2.Specialty_Show_in_Grid__c=true;
            ntwrkPriceObj2.Network_Name__c ='National - NACH7';
            ntwrkPriceObj2.Sequence_Number__c =3;
            ntwrkPriceObj2.LOB__c ='STD';
            //insert ntwrkPriceObj2;
            npListInsert.add(ntwrkPriceObj2);   
            
            insert npListInsert;
            npListInsert[0].Sequence_Number__c = 1;
            npListInsert[1].Sequence_Number__c = 2;
            npListInsert[2].Sequence_Number__c = 3;
            update npListInsert;
            
            list<Network_Pricing__c> npList1 = [
                SELECT id, Sequence_Number__c
                from Network_Pricing__c where FAF_Network_Ops__c = :ntwrkOpsObj.id Order By Sequence_Number__c asc
            ];
            system.debug('npList1-----3------'+npList1);          
            try{
                //list<Network_Pricing__c> npList = Apttus_GridObjectdata.get_GridObjectdata(agrline.Id,'Network_Pricing__c');
                //system.debug('npList-----------'+npList.size());
                Apttus_GridObjectdata.checkValid(npList1[0].Id, agrline.Id,'', '2', false);
                Apttus_GridObjectdata.updateNPSeq(npList1[2].Id, agrline.Id,'', '1', false);
            }
            Catch(Exception Ex){}
            Test.StopTest();
        }
    }
    
   }