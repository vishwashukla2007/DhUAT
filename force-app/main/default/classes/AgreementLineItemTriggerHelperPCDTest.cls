@isTest
public class AgreementLineItemTriggerHelperPCDTest{
    
    static testMethod void AgreementLineItemTriggerHelperPCDMethod1(){
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
            
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
            insert ntwrkOpsObj;
            ntwrkOpsObj.Agreement__c=agr.id;
            ntwrkOpsObj.Agreement_Line_Item__c =agrline.id;
            update ntwrkOpsObj;
            
            
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            insert ntwrkPriceObj;
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj.Agreement__c=agr.id;
            ntwrkPriceObj.Agreement_Line_Item__c =agrline.id;
            ntwrkPriceObj.Retail_Network_Ordinal__c ='Secondary';
            //ntwrkPriceObj.LOB__c = 'ABC';
            try{
            update ntwrkPriceObj;
            //  insert ntwrkPriceObj;
            //Database.update(ntwrkPriceObj, false);
            }catch(Exception e){}
            
            Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
            ntwrkPriceObj1.Year__c='3';
            insert ntwrkPriceObj1;
            ntwrkPriceObj1.Brand_Basis__c='Pass-Through';
            ntwrkPriceObj1.Agreement__c=agr.id;
            ntwrkPriceObj1.Agreement_Line_Item__c =null;
            ntwrkPriceObj1.Brand_Rate__c =200;
            ntwrkPriceObj1.LOB__c = 'ABC';
            try{
            //insert ntwrkPriceObj1;
            //Database.update(ntwrkPriceObj1, false);
            }catch(Exception e){}
            
            
            
            Mail_Operations__c  mailOps = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
            Mail_Pricing__c  mailPrice=TestDataFactory.createmailPricing(FAFObj.id,mailOps.id );
            mailPrice.Agreement__c=agr.id;
            mailPrice.Agreement_Line_Item__c=agrline.id; 
            mailPrice.LOB__c='ACT';
            mailPrice.Brand_Dispensing_Fee__c=5;
            mailPrice.Brand_Basis__c='Standard Brand Discount';
            mailPrice.Generic_Dispensing_Fee__c=5;
            mailPrice.Brand_Rate__c=5;
            mailPrice.Generic_Rate__c=5;
            insert mailPrice;
            mailPrice.Generic_Dispensing_Fee__c=6;
            update mailPrice;
            
            cInfo.Agreement__c=agr.id;
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            Clinical_Operations__c clinicOps= TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicOps;
            
            //Clinical_Solutions__c data
            Clinical_Solutions__c clinicSol =TestDataFactory.createGClinicalSolution(FAFObj.id,clinicOps.id);
            insert clinicSol;
            
            clinicSol.Agreement__c=agr.id;
            clinicSol.Agreement_Line_Item__c=agrline.id;
            update clinicSol;
            
            
            
            //update agreement line item
            agrline.Network_Operation_Link__c=true;
            //agrline.Network_Operation__c=ntwrkOpsObj.id;
            //Network_Pricing_Link__c=true;
            agrline.Mail_Operation_Link__c=true;
           // agrline.Mail_Operations__c=mailOps.id;
            agrline.Mail_Pricing_Link__c=true;
            agrline.Client_Information_Link__c=true;
            agrline.Clinical_Solution_Link__c=true;
            agrline.Clinical_Solutions__c=clinicSol.id;
            update agrline;
            
            
            List<Apttus__AgreementLineItem__c> agrLineIdList =new List<Apttus__AgreementLineItem__c>();
            agrLineIdList.add(agrline);
            
            AgreementLineItemTriggerHelperPCD.FAF_Data_Validate(agrLineIdList,false);
             AgreementLineItemTriggerHelperPCD.IncreaseCoverage2();
            Test.stopTest();
            //System.assertEquals(null,ntwrkPriceObj.id,'network pricing is empty');
        
        }
    }
    
        static testMethod void AgreementLineItemTriggerHelperPCDMethod2(){
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
            
            Rebate_Operations__c  rebateOps= TestDataFactory.createRebOps(FAFObj.id);
            rebateOps.Agreement__c=agr.id;
            rebateOps.Agreement_Line_Item__c =agrline.id; 
            insert rebateOps;
            //rebate guarantee record
            Rebate_Guarantees__c rebateG= TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOps.id);
            rebateG.Agreement__c=agr.id;
            rebateG.Agreement_Line_Item__c =agrline.id; 
            insert rebateG;
            
            Billing_Operations__c  billingOps= TestDataFactory.createBillOps(FAFObj.id);
            billingOps.Agreement__c=agr.id;
            insert billingOps;
            
            Billing_Administrative_Fees__c  billingAdmin= TestDataFactoryForBilling.createBillAdminFees(FAFObj.id,billingOps.id);
            billingAdmin.Agreement__c=agr.id;
            billingAdmin.Agreement_Line_Item__c=agrline.id;
            insert billingAdmin;
            
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            specOpsObj.Agreement__c=agr.id;
            specOpsObj.Agreement_Line_Item__c =agrline.Id;
            insert specOpsObj;
            
            //specialty pricing record
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj.Agreement__c=agr.id;
            specpricObj.Agreement_Line_Item__c=agrline.Id;
            insert specpricObj;
            
            Rebate_Gtees_Specialty_Class_Carve_Outs__c rebtGCarv =TestDataFactory.createGtees(rebateOps.id,FAFObj.id);
            rebtGCarv.Agreement__c=agr.id;
            rebtGCarv.Agreement_Line_Item__c=agrline.Id;
            insert rebtGCarv;
            
            agrline.Rebate_Operation_Link__c=true;
            agrline.Rebate_Operations__c=rebateOps.id;
            agrline.Rebate_Guarantee_Link__c=true;
            agrline.Specialty_Operation_Link__c=true;
            //agrline.Specialty_Operations__c=specOpsObj.id;
            agrline.Specialty_Pricing_Link__c=true;
            agrline.Rebate_Carve_Out_Link__c=true;
            agrline.Billing_Admin_Link__c=true;
            //agrline.Billing_Operations__c=billingOps.id;
            update agrline;
            
            List<Apttus__AgreementLineItem__c> agrLineIdList =new List<Apttus__AgreementLineItem__c>();
            agrLineIdList.add(agrline);
            
            AgreementLineItemTriggerHelperPCD.FAF_Data_Validate(agrLineIdList,false);
            AgreementLineItemTriggerHelperPCD.IncreaseCoverage();
            Test.stopTest();
        
        }
    }
    /*
    //Method to cover negative case scenario
        static testMethod void AgreementLineItemTriggerHelperPCDMethodNegative(){
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
            
            Network_Operations__c ntwrkOpsObj = TestDataFactory.createntwrkOperatns(FAFObj.id);
             
            insert ntwrkOpsObj;
            
            
            //ntwrkOpsObj.Agreement__c=agr.id;
            //ntwrkOpsObj.Agreement_Line_Item__c =agrline.id;
            
            //update ntwrkOpsObj;
            List<Network_Pricing__c> nplist=new List<Network_Pricing__c>(); 
            Network_Pricing__c ntwrkPriceObj= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
             Network_Pricing__c ntwrkPriceObj1= TestDataFactory.createntwrkPricing(FAFObj.id,ntwrkOpsObj.id );
             ntwrkPriceObj1.Brand_Rate__c=500;
             ntwrkPriceObj1.Agreement__c=agr.id;
             ntwrkPriceObj1.Agreement_Line_Item__c =agrline.id;
             nplist.add(ntwrkPriceObj);
             nplist.add(ntwrkPriceObj1);
            //ntwrkPriceObj.FAF_ID__c=null;
            try{
             
            Database.Saveresult[] lsr = Database.insert(nplist,false);

            }catch(Exception e){
            
            }
            ntwrkPriceObj.Brand_Basis__c='Pass-Through';
            //ntwrkPriceObj.
            //ntwrkPriceObj.Agreement_Line_Item__c =agrline.id;
            //update ntwrkPriceObj;
            
            Mail_Operations__c  mailOps = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
            Mail_Pricing__c  mailPrice=TestDataFactory.createmailPricing(FAFObj.id,mailOps.id );
            mailPrice.Agreement__c=agr.id;
            mailPrice.Agreement_Line_Item__c=agrline.id; 
            mailPrice.LOB__c='ACT';
            mailPrice.Brand_Dispensing_Fee__c=5;
            mailPrice.Brand_Basis__c='Standard Brand Discount';
            mailPrice.Generic_Dispensing_Fee__c=5;
            mailPrice.Brand_Rate__c=5;
            mailPrice.Generic_Rate__c=5;
            insert mailPrice;
            mailPrice.Generic_Dispensing_Fee__c=6;
            update mailPrice;
            
            cInfo.Agreement__c=agr.id;
            cInfo.Agreement_Line_Item__c=agrline.id;
            update cInfo;
            
            Clinical_Operations__c clinicOps= TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicOps;
            
            //Clinical_Solutions__c data
            Clinical_Solutions__c clinicSol =TestDataFactory.createGClinicalSolution(FAFObj.id,clinicOps.id);
            insert clinicSol;
            
            clinicSol.Agreement__c=agr.id;
            clinicSol.Agreement_Line_Item__c=agrline.id;
            update clinicSol;
            
            
            
            //update agreement line item
            agrline.Network_Operation_Link__c=true;
            //agrline.Network_Operation__c=ntwrkOpsObj.id;
            //Network_Pricing_Link__c=true;
            agrline.Mail_Operation_Link__c=true;
            agrline.Mail_Operations__c=mailOps.id;
            agrline.Mail_Pricing_Link__c=true;
            agrline.Client_Information_Link__c=true;
            agrline.Clinical_Solution_Link__c=true;
            agrline.Clinical_Solutions__c=clinicSol.id;
            agrline.Rebate_Operation_Link__c=true;
            //agrline.Rebate_Operations__c=rebateOps.id;
            agrline.Rebate_Guarantee_Link__c=true;
            agrline.Specialty_Operation_Link__c=true;
            //agrline.Specialty_Operations__c=specOpsObj.id;
            agrline.Specialty_Pricing_Link__c=true;
            agrline.Rebate_Carve_Out_Link__c=true;
            agrline.Billing_Admin_Link__c=true;
            //agrline.Billing_Operations__c=billingOps.id;
            update agrline;
            
            
            List<Apttus__AgreementLineItem__c> agrLineIdList =new List<Apttus__AgreementLineItem__c>();
            agrLineIdList.add(agrline);
            
            AgreementLineItemTriggerHelperPCD.FAF_Data_Validate(agrLineIdList,true);
            
            Test.stopTest();
        
        }
    }*/
    
}