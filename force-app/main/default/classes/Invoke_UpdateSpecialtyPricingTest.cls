@isTest
public class Invoke_UpdateSpecialtyPricingTest{
    
    static testMethod void Invoke_UpdateSpecialtyPricingMethod1(){
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
            
            /*Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            insert agrline;
            */
            test.startTest();
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
           // Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            //specOpsObj1.Pharmacy_Benefit__c = ConstantsUtil.const_None;
            //insert specOpsObj1;
            
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj.Pharmacy_Benefit__c='Preferred';
            insert specpricObj;
            
            Specialty_Pricing__c specpricObj1 = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj1.Pharmacy_Benefit__c = 'Preferred';
            specpricObj1.Year__c ='3';
            insert specpricObj1;
            /*Specialty_Pricing__c specpricObj2 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
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
            */
            Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            insert specGuaranObj;
            
            List<id> specOpsList =new List<id>();
            specOpsList.add(specOpsObj.id);
            
            Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(specOpsList);
            specpricObj.Year__c ='1';
            update specpricObj;
            
            Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(specOpsList);
            
            //Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(specOpsList1);
            Test.StopTest();
        }
    }
     static testMethod void Invoke_UpdateSpecialtyPricingMethod2(){
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
            
            /*Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            insert agrline;
            */
            test.startTest();
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
           // Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            //specOpsObj1.Pharmacy_Benefit__c = ConstantsUtil.const_None;
            //insert specOpsObj1;
            
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj.Pharmacy_Benefit__c='Preferred';
            specpricObj.Year__c ='2';
            insert specpricObj;
            
            Specialty_Pricing__c specpricObj1 = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj1.Pharmacy_Benefit__c = 'Preferred';
            specpricObj1.Year__c ='4';
            insert specpricObj1;
            Specialty_Pricing__c specpricObj2 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj.id);
            specpricObj2.Year__c ='5';
            insert specpricObj2;
            /*
            Specialty_Pricing__c specpricObj3 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
            specpricObj3.Year__c ='3';
            specpricObj3.LOB__c ='WC';
            specpricObj3.Pharmacy_Benefit__c = 'Preferred';
            insert specpricObj3;
            */
            Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            insert specGuaranObj;
            
            List<id> specOpsList =new List<id>();
            specOpsList.add(specOpsObj.id);
            
            Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(specOpsList);
            //specpricObj.Year__c ='4';
            //update specpricObj;
            //List<id> specOpsList1 =new List<id>();
            //specOpsList1.add(specOpsObj.id);
            //Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(specOpsList1);
            //specpricObj.Year__c ='5';
            //update specpricObj;
            //List<id> specOpsList2 =new List<id>();
            //specOpsList2.add(specOpsObj.id);
            //Invoke_UpdateSpecialtyPricing.UpdateSpecialtyPricing(specOpsList2);
            
            
            Test.StopTest();
        }
    }
}