/* ================================================
 * @Class Name : specialtyPricingTriggerHelperTest
 * @author : Accenture
 * @Purpose: Test Class for specialtyPricingTriggerHelper
 * @created date:08/10/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class specialtyPricingTriggerHelperTest{


    /*================================================
     * @Method Name : specialtyPricingTriggerHelperMethod1
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/10/2018
     * @Last modified date:23/12/2019
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void SpecialtyPricingNewEditClassTestMethod1(){
           
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            Platform_Specifics__c platForm = new Platform_Specifics__c();
            platForm.FAF_Client_Information__c =  ClinInfo.Id;
            platForm.Level_1_Record_ID__c = cag.Id;
            platForm.Termed__c = false;
            platForm.DifferentGSTPFormularyEffectiveDates__c = false;
            platForm.FAF_ID__c = FAFObj.id; 
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'None';
            platForm.Platform__c ='CATS';
            platForm.Instruction__c ='Exclude';
            platForm.LOB__c = 'ACT';
            platForm.DeleteRow__c=true;
            platForm.Level_1_ID_XAE__c ='L1ID';
            insert platForm;
            
            test.starttest();
            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
            
             map<id,Specialty_Pricing__c> mapFAFandSpecPric = new map<id,Specialty_Pricing__c>();
             map<id,Specialty_Pricing__c> mapFAFandSpecPricNew = new map<id,Specialty_Pricing__c>();
            //Create Specialty Operation Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            //Create Specialty Pricing record                       
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            insert specPricingObj;
            specPricingObj.Pharmacy_Benefit__c ='Exclusive (Retail Lockout)';
            update specPricingObj;
            
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            insert specPricingObj1;
            specPricingObj1.Pharmacy_Benefit__c ='Preferred';
            update specPricingObj1;
            
            Specialty_Pricing__c specPricingObj2 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            insert specPricingObj2;
            
            
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);   
            specPricingList.add(specPricingObj2);
            //insert specPricingList;
            

            mapFAFandSpecPric.put(FAFObj.id,specPricingObj);
            mapFAFandSpecPricNew.put(FAFObj.id,specPricingObj2);
            specialtyPricingTriggerHelper.validateLobYearCombinalion(specPricingList,true,false);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,true,false,mapFAFandSpecPric,specPricingList);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,false,true,mapFAFandSpecPric,specPricingList);
            specialtyPricingTriggerHelper.onUpdateSpecialtyPricing(specPricingList,mapFAFandSpecPric,mapFAFandSpecPricNew,false, true);
            test.stoptest();
        }
    
    }
     /*================================================
     * @Method Name : specialtyPricingTriggerHelperMethod2
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void specialtyPricingTriggerHelperMethod2(){
    
       //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            Platform_Specifics__c platForm = new Platform_Specifics__c();
            platForm.FAF_Client_Information__c =  ClinInfo.Id;
            platForm.Level_1_Record_ID__c = cag.Id;
            platForm.Termed__c = false;
            platForm.DifferentGSTPFormularyEffectiveDates__c = false;
            platForm.FAF_ID__c = FAFObj.id; 
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'None';
         //   insert platForm;
                        
            test.starttest();            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
            Set<Specialty_Pricing__c> specPricingSet =new Set<Specialty_Pricing__c>();
             map<id,Specialty_Pricing__c> mapFAFandSpecPric = new map<id,Specialty_Pricing__c>();
            //Create Specialty Operation Pricing Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            insert specOpsObj1;
            
            
            //Create Specialty Pricing record            
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj.Pharmacy_Benefit__c = 'None';
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj1.id,specOpsObj1.id);
            specPricingObj1.Pharmacy_Benefit__c = 'None';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
            insert specPricingList;
            mapFAFandSpecPric.put(FAFObj.id,specPricingObj);
            String specValue='Exclusive (Retail Lockout)-Custom';
            specialtyPricingTriggerHelper.validateSpciality(specPricingList,false,true,specValue,true);
            specialtyPricingTriggerHelper.validateLobYearCombinalion(specPricingList,false,true);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,true,false,mapFAFandSpecPric,specPricingList);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,false,true,mapFAFandSpecPric,specPricingList);
            //specialtyPricingTriggerHelper.onUpdateSpecialtyPricing(specPricingList,mapFAFandSpecPric,true,false);
            test.stoptest();
        }
    
    }
    
    /*=======================================================
     * @Method Name : specialtyPricingTriggerHelperMethod3
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:10/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    =========================================================*/
    @isTest
    static void SpecialtyPricingNewEditClassTestMethod3(){
        try{
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            Platform_Specifics__c platForm = new Platform_Specifics__c();
            platForm.FAF_Client_Information__c =  ClinInfo.Id;
            platForm.Level_1_Record_ID__c = cag.Id;
            platForm.Termed__c = false;
            platForm.DifferentGSTPFormularyEffectiveDates__c = false;
            platForm.FAF_ID__c = FAFObj.id; 
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'Exclusive (Retail Lockout)-Default Rate w/o Enhancements';
            insert platForm;
            
            test.starttest();
            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
            List<Specialty_Pricing__c> specPricingList2 =new List<Specialty_Pricing__c>();
             map<id,Specialty_Pricing__c> mapFAFandSpecPric = new map<id,Specialty_Pricing__c>();
             
            //Create Specialty Operation Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            //Create Specialty Pricing record                       
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj.pharmacy_benefit__c = 'Exclusive (Retail Lockout)';
            specPricingObj.price_List__c = 'Default Rate w/o Enhancements';
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj1.pharmacy_benefit__c = 'Open';
            specPricingObj1.price_List__c = 'Custom';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);           
            insert specPricingList;
            specPricingObj.price_List__c = 'Standard w/ Enhancements';
            specPricingObj1.price_List__c = 'Default Rate w/o Enhancements';
            specPricingList2.add(specPricingObj);
            specPricingList2.add(specPricingObj1);
            update specPricingList2;
            
            //delete specPricingObj;
            mapFAFandSpecPric.put(FAFObj.id,specPricingObj);
            specialtyPricingTriggerHelper.validateLobYearCombinalion(specPricingList,true,false);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,true,false,mapFAFandSpecPric,specPricingList);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,false,true,mapFAFandSpecPric,specPricingList);
            //specialtyPricingTriggerHelper.onUpdateSpecialtyPricing(specPricingList,mapFAFandSpecPric,mapFAFandSpecPric,true,false);
            test.stoptest();
        }
        }catch(exception e){
        }
    
    }
    /*=======================================================
     * @Method Name : specialtyPricingTriggerHelperMethod4
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:10/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    =========================================================*/
    @isTest
    static void SpecialtyPricingNewEditClassTestMethod4(){
        try{
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            Platform_Specifics__c platForm = new Platform_Specifics__c();
            platForm.FAF_Client_Information__c =  ClinInfo.Id;
            platForm.Level_1_Record_ID__c = cag.Id;
            platForm.Termed__c = false;
            platForm.DifferentGSTPFormularyEffectiveDates__c = false;
            platForm.FAF_ID__c = FAFObj.id; 
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'Exclusive (Retail Lockout)-Default Rate w/o Enhancements';
            insert platForm;
            
            test.starttest();
            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
             map<id,Specialty_Pricing__c> mapFAFandSpecPric = new map<id,Specialty_Pricing__c>();
             
            //Create Specialty Operation Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            //Create Specialty Pricing record                       
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj.pharmacy_benefit__c = 'Exclusive (Retail Lockout)';
            specPricingObj.price_List__c = 'Default Rate w/o Enhancements';
            String specValue =specPricingObj.pharmacy_benefit__c+'-'+specPricingObj.price_List__c;
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);           
            insert specPricingList;
            
            delete specPricingList;
            
            mapFAFandSpecPric.put(FAFObj.id,specPricingObj);
            specialtyPricingTriggerHelper.validateLobYearCombinalion(specPricingList,true,false);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,true,false,mapFAFandSpecPric,specPricingList);
            specialtyPricingTriggerHelper.PharmBenefitValueDupCheck(specPricingList,false,true,mapFAFandSpecPric,specPricingList);
            //specialtyPricingTriggerHelper.validateSpciality(specPricingList,true,false,specValue,true);
            //specialtyPricingTriggerHelper.onUpdateSpecialtyPricing(specPricingList,mapFAFandSpecPric,mapFAFandSpecPric,true,false);
            test.stoptest();
        }
        }catch(exception e){
        }
    
    }
    
       @isTest
    static void specialtyPricingTriggerHelperMethod5(){
    
       //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            CAG__c cag = new CAG__c();
            cag.CAG_ID__c = '1234567890567CAGTESTC1';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Non_Validated_CAG__c = true;        
            insert cag;
        
            Client_Information__c ClinInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert ClinInfo;
            Platform_Specifics__c platForm = new Platform_Specifics__c();
            platForm.FAF_Client_Information__c =  ClinInfo.Id;
            platForm.Level_1_Record_ID__c = cag.Id;
            platForm.Termed__c = false;
            platForm.DifferentGSTPFormularyEffectiveDates__c = false;
            platForm.FAF_ID__c = FAFObj.id; 
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'None';
         //   insert platForm;
                        
            test.starttest();            
            //Create Specialty Operation Pricing Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            //Create Specialty Pricing record            
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj.Pharmacy_Benefit__c = 'None';
            
            insert specPricingObj;
            specPricingObj.Pharmacy_Benefit__c ='Exclusive (Retail Lockout)';
            update specPricingObj;
            
            delete specPricingObj;
            test.stoptest();
        }
    
    }
}