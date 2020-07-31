/* ================================================
 * @Class Name : SpecDrugLevelNewEditClassTest
 * @author : Accenture
 * @Purpose: Test Class for SpecDrugLevelNewEditClass
 * @created date:08/10/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class SpecDrugLevelNewEditClassTest{


   /* ================================================
     * @Method Name : SpecDrugLevelNewEditClassTestMethod1
     * @author : Accenture
     * @Purpose: Test method to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/10/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void SpecDrugLevelNewEditClassTestMethod1(){
           
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
            specOpsObj.pharmacy_Benefit__c = 'Preferred';
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
            
            List<Specialty_Drug_Level_Pricing__c> specDrugPricingList = new List<Specialty_Drug_Level_Pricing__c>();
            Specialty_Drug_Level_Pricing__c specDrugPricingObj = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
            specDrugPricingObj.MAC__c = true;
            //insert specPricingObj;
            Specialty_Drug_Level_Pricing__c specDrugPricingObj1 = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
            specDrugPricingObj1.Year__c = '2';
            specDrugPricingObj1.LOB__c = 'ACT';
            specDrugPricingObj.MAC__c = true;
            specDrugPricingList.add(specDrugPricingObj);
            specDrugPricingList.add(specDrugPricingObj1);
            
            test.starttest();
            insert specDrugPricingList;
            PageReference pageRef = Page.SpecDrugLevelNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',specDrugPricingObj.id);
            pageRef.getParameters().put(Label.SpecOpsOnDrugLevelLabel,specOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specDrugPricingObj);
            SpecDrugLevelNewEditClass controller = new SpecDrugLevelNewEditClass(sc);            
          //  controller.pharBeneEnabDisbMeth(specOpsObj.id);
            controller.enabledisableRateMeth();
            controller.saveUpdateSpecDrugLevel();
            controller.changeYearMeth();
            test.stoptest();
        }
    
    }
     @isTest
    static void SpecDrugLevelNewEditClassTestMethod2(){
    
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
            specOpsObj.pharmacy_Benefit__c = 'Preferred';
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
            List<Specialty_Drug_Level_Pricing__c> specDrugPricingList = new List<Specialty_Drug_Level_Pricing__c>();
            Specialty_Drug_Level_Pricing__c specDrugPricingObj = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
            //insert specDrugPricingObj;
            Specialty_Drug_Level_Pricing__c specDrugPricingObj1 = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
            specDrugPricingList.add(specDrugPricingObj);
            specDrugPricingList.add(specDrugPricingObj1);
            
            test.starttest();
            insert specDrugPricingList;
            PageReference pageRef = Page.SpecDrugLevelNewEditPage;
            Test.setCurrentPage(pageRef);
            //pageRef.getParameters().put('id',specDrugPricingObj.id);
            pageRef.getParameters().put(Label.SpecOpsOnDrugLevelLabel,specOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(specDrugPricingObj);
            SpecDrugLevelNewEditClass controller = new SpecDrugLevelNewEditClass(sc);
          //  controller.pharBeneEnabDisbMeth(specOpsObj.id);
            controller.enabledisableRateMeth();
            controller.saveUpdateSpecDrugLevel();
            controller.changeYearMeth();
            test.stoptest();
        }
    
    }
}