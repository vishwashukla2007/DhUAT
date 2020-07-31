@isTest
public class UpdatePricingSequenceTest {
    static testmethod void TestMeth1() {
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
            
            insert ntwrkPriceObj;
            ntwrkPriceObj.Retail_Network_Ordinal__c='Secondary';
            update ntwrkPriceObj;
            
            
            Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Custom_Network_Description__c='Test';
            ntwrkPriceObj1.Network_Type__c='Transparent';
            ntwrkPriceObj1.LOB__c ='STD';
            ntwrkPriceObj1.Network_Name__c ='National - NACH7';
            insert ntwrkPriceObj1;
            
             Network_Pricing__c ntwrkPriceObj2= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            //ntwrkPriceObj2.Custom_Network_Description__c='Test';
            ntwrkPriceObj2.Network_Type__c='Transparent';
            ntwrkPriceObj2.LOB__c ='MEDI';
            ntwrkPriceObj2.Network_Name__c ='National - CVL5';
            ntwrkPriceObj2.Retail_Network_Ordinal__c='Secondary';
            ntwrkPriceObj2.Year__c='2';
            
            insert ntwrkPriceObj2;
            List<String> opid = new List<String>();
            opid.add(ntwrkOpsObj.Id);
            UpdatePricingSequence.updateSequence(opid);
            
            Network_Pricing__c  ntwrkPriceObjNew= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
             ntwrkPriceObjNew.Agreement__c= agr.id;
             ntwrkPriceObjNew.Year_Begin_Date__c= Date.newInstance(2020, 01, 01);
             ntwrkPriceObjNew.Year_End_Date__c=Date.newInstance(2020, 01, 31);
             ntwrkPriceObjNew.Brand_Basis__c='Pass-Through';
             ntwrkPriceObjNew.Non_MAC_Generic_Rate__c=23.00;                               
             ntwrkPriceObjNew.Custom_Network_Description__c='Test';
             ntwrkPriceObjNew.Network_Name_for_Grid__c='';
             ntwrkPriceObjNew.Template_BER_Display__c=false;
             ntwrkPriceObjNew.Template_BER_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Brand_Display__c=false;
             ntwrkPriceObjNew.Template_Brand_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Dispensing_Fee_Text__c='';
             ntwrkPriceObjNew.Template_Generic_BER_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Generic_Display__c=false;
             ntwrkPriceObjNew.Template_Generic_OR_Mac_Text__c='';
             ntwrkPriceObjNew.Template_Generic_Rate_Text__c='';
             ntwrkPriceObjNew.Template_GER_Display__c=false;
             ntwrkPriceObjNew.Template_GER_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Template_MCCP__c=false;
             ntwrkPriceObjNew.Template_MER_Display__c=false;
             ntwrkPriceObjNew.Template_MER_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Template_NED_Display__c=false;
             ntwrkPriceObjNew.Template_NED_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Network_Name_Text__c='';
             ntwrkPriceObjNew.Template_NonMacGeneric_Display__c=false;
             ntwrkPriceObjNew.Template_Non_MAC_Generic_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Non_Preferred_Brand_Rate_Text__c='';
             ntwrkPriceObjNew.Template_OED_Display__c=false;
             ntwrkPriceObjNew.Template_OED_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Preferred_Brand_Rate_Text__c='';
             ntwrkPriceObjNew.Template_Preferred_Display__c=false;
             ntwrkPriceObjNew.SSG_Display__c=false;                
             ntwrkPriceObjNew.Template_SSG_Guarantee_Rate_Text__c='';
             ntwrkPriceObjNew.Network_Type__c='Transparent';
             ntwrkPriceObjNew.Generic_Basis__c='MAC Modeled & Non-MAC';   
             ntwrkPriceObjNew.Agreement_Line_Item__c=agrline.id;
             ntwrkPriceObjNew.Show_in_Grid__c=true;
             ntwrkPriceObjNew.Retail_Network_Ordinal__c='Primary';
             ntwrkPriceObjNew.Specialty_Show_in_Grid__c=true;
             ntwrkPriceObjNew.Network_Name__c ='National - NACH7';
            
            insert ntwrkPriceObjNew;
            Test.StopTest();
        }
    }
}