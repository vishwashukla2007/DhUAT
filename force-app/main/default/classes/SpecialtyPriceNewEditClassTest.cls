/* ================================================
 * @Class Name : SpecialtyPriceNewEditClassTest
 * @author : Accenture
 * @Purpose: Test Class for SpecialtyPriceNewEditClass
 * @created date:08/10/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class SpecialtyPriceNewEditClassTest{


   /* ================================================
     * @Method Name : SpecialtyPricingNewEditClassTestMethod1
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void SpecialtyPricingNewEditClassTestMethod1(){
           
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
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            specOpsObj.Pharmacy_Benefit__c ='Open';
            insert specOpsObj;
            
            
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            
            update clientINFO;
            
            List<Specialty_Pricing__c> specPricingList = new List<Specialty_Pricing__c>();
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            //insert specPricingObj;
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj1.Year__c = '2';
            specPricingObj1.LOB__c = 'ACT';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
            test.starttest();
            insert specPricingList;
            PageReference pageRef = Page.SpecialtyPriceNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specPricingObj.id);
            pageRef.getParameters().put(Label.SpecialtyOpsLabel,specOpsObj.id);
            pageRef.getParameters().put('lightning','test');
            
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPriceNewEditClass controller = new SpecialtyPriceNewEditClass(sc);
            controller.saveUpdateSpecPrice();
            controller.cancel();
            controller.changeYearMeth();
            test.stoptest();
        }
    
    }
     @isTest
    static void SpecialtyPricingNewEditClassTestMethod2(){
    
        string fieldName = Label.rebateOperationLabel;
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
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            specOpsObj.Pharmacy_Benefit__c ='Open';
            insert specOpsObj;
            
            
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            
            update clientINFO;
            List<Specialty_Pricing__c> specPricingList = new List<Specialty_Pricing__c>();
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            //insert specPricingObj;
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
            test.starttest();
            insert specPricingList;
            PageReference pageRef = Page.SpecialtyPriceNewEditPage;
            Test.setCurrentPage(pageRef);
            //pageRef.getParameters().put('id',specPricingObj.id);
            pageRef.getParameters().put(Label.SpecialtyOpsLabel,specOpsObj.id);
            //pageRef.getParameters().put('lightning','test');
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPriceNewEditClass controller = new SpecialtyPriceNewEditClass(sc);
            controller.saveUpdateSpecPrice();
            controller.cancel();
            controller.changeYearMeth();
            test.stoptest();
        }
    
    }
    
    @isTest
    static void SpecialtyPricingNewEditClassTestMethod3(){
           
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
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            specOpsObj.Pharmacy_Benefit__c ='Open';
            insert specOpsObj;
            
            
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            
            update clientINFO;
            
            List<Specialty_Pricing__c> specPricingList = new List<Specialty_Pricing__c>();
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            //insert specPricingObj;
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
            specPricingObj1.Year__c = '2';
            specPricingObj1.LOB__c = 'ACT';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
            test.starttest();
            insert specPricingList;
            Specialty_Guarantee__c specGuarObj = TestDataFactory.createspecGuarnt(FAFObj.id,specPricingObj.id);
            insert specGuarObj;
            PageReference pageRef = Page.SpecialtyPriceNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specPricingObj.id);
            pageRef.getParameters().put(Label.SpecialtyOpsLabel,specOpsObj.id);
            pageRef.getParameters().put('lightning','test');
            pageRef.getParameters().put('type','clone');
            //specPricingObj.LOB__c = 'FLU';
            ApexPages.StandardController sc = new ApexPages.standardController(specPricingObj);
            SpecialtyPriceNewEditClass controller = new SpecialtyPriceNewEditClass(sc);
            delete specPricingObj;
            controller.saveUpdateSpecPrice();
            controller.cancel();
            controller.changeYearMeth();
            test.stoptest();
        }
    
    }
}