/* ================================================
 * @Class Name : SpecialtyPricingDeleteClassTest
 * @author : Accenture
 * @Purpose: Test Class for SpecialtyPricingDeleteClass
 * @created date:08/10/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class SpecialtyPricingDeleteClassTest{


    /*========================================================
     * @Method Name : SpecialtyPricingDeleteClassTestMethod1
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ==========================================================*/
    @isTest
    static void SpecialtyPricingDeleteClassMethod1(){
    
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
           // insert platForm;
                        
            test.starttest();            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
            Set<Specialty_Pricing__c> specPricingSet =new Set<Specialty_Pricing__c>();
             map<id,Specialty_Pricing__c> mapFAFandSpecPric = new map<id,Specialty_Pricing__c>();
            //Create Specialty Operation Pricing Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
           // insert specOpsObj1;
            
            
            //Create Specialty Pricing record            
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj.Pharmacy_Benefit__c = 'None';
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj1.id,specOpsObj.id);
            specPricingObj1.Pharmacy_Benefit__c = 'None';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
            insert specPricingList;
            PageReference pageRef = Page.SpecialtyPricingDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specPricingObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPricingDeleteClass controller = new SpecialtyPricingDeleteClass(sc);
            controller.deleteRecord();

            test.stoptest();
        }
    
    }
    /*=======================================================
     * @Method Name : SpecialtyPricingDeleteClassMethod2
     * @author : Accenture
     * @Purpose: Test method to cover delete method
     * @Parameters: NA
     * @return: Void
     * @created date:10/12/2018
     * @Last modified date:
     * @Last modified by : Accenture
    =========================================================*/
    @isTest
    static void SpecialtyPricingDeleteClassMethod2(){
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
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
             specPricingObj1.pharmacy_benefit__c = 'Exclusive (Retail Lockout)';
            specPricingObj1.price_List__c = 'Default Rate w/o Enhancements';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);           
            insert specPricingList;
            
            PageReference pageRef = Page.SpecialtyPricingDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specPricingObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPricingDeleteClass controller = new SpecialtyPricingDeleteClass(sc);
            controller.deleteRecord();
            test.stoptest();
        }
        }catch(exception e){
        }
    
    }
    /*=======================================================
     * @Method Name : SpecialtyPricingDeleteClassMethod3
     * @author : Accenture
     * @Purpose: Test method to cover delete method
     * @Parameters: NA
     * @return: Void
     * @created date:10/12/2018
     * @Last modified date:
     * @Last modified by : Accenture
    =========================================================*/
    @isTest
    static void SpecialtyPricingDeleteClassMethod3(){
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
            platForm.Specialty_Pharmacy_Benefit_Price_List__c  = 'Exclusive (Retail Lockout)-Default Rate w Enhancements';
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
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);           
            insert specPricingList;
            
            PageReference pageRef = Page.SpecialtyPricingDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specPricingObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPricingDeleteClass controller = new SpecialtyPricingDeleteClass(sc);
            controller.deleteRecord();
            test.stoptest();
        }
        }catch(exception e){
        }
    
    }
     /*========================================================
     * @Method Name : SpecialtyPricingDeleteClassTestMethod4
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ==========================================================*/
    @isTest
    static void SpecialtyPricingDeleteClassMethod4(){
    
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
        //    insert platForm;
                        
            test.starttest();            
            List<Specialty_Pricing__c> specPricingList =new List<Specialty_Pricing__c>();
            Set<Specialty_Pricing__c> specPricingSet =new Set<Specialty_Pricing__c>();
             map<id,Specialty_Pricing__c> mapFAFandSpecPric = new map<id,Specialty_Pricing__c>();
            //Create Specialty Operation Pricing Record 
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;            
            
            //Create Specialty Pricing record            
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj.Pharmacy_Benefit__c = 'None';
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj1.id,specOpsObj.id);
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
            insert specPricingList;
            PageReference pageRef = Page.SpecialtyPricingDeletePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specPricingObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPricingDeleteClass controller = new SpecialtyPricingDeleteClass(sc);
            controller.deleteRecord();

            test.stoptest();
        }
    
    }
   
}