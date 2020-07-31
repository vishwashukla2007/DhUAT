@isTest
public with sharing class Invoke_UpdateCustomSpecialtyGridTest{

static testMethod void Invoke_UpdateCustomSpecialtyGridTestMethod1(){
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
   // Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
   // specOpsObj.Pharmacy_Benefit__c ='Open';
   // insert specOpsObj;
    
    
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
    
    //List<Specialty_Pricing__c> specPricingList = new List<Specialty_Pricing__c>();
    //Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
    //insert specPricingObj;
    //Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
    //specPricingObj1.Year__c = '2';
    //specPricingObj1.LOB__c = 'ACT';
    //specPricingList.add(specPricingObj);
    //specPricingList.add(specPricingObj1);
    
    Test.startTest();
    
    
    
      List<Specialty_Operations__c > specOperList = new List<Specialty_Operations__c >();
      Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
      specOpsObj.Pharmacy_Benefit__c ='Open';
      //specOpsObj.Medical_Benefit__c='Open';
      //specOpsObj.Billing_Type__c='Manual';
      //specOpsObj.Discount_Basis__c='Post-AWP-MS';
      //specOpsObj.Select_Specialty_Exclusion__c='Acromegaly';
      specOpsObj.Invokable_Update__c=true;
       
       specOperList.add(specOpsObj );
       insert specOperList;
    
    
        List<Specialty_Pricing__c> specPricingList = new List<Specialty_Pricing__c>();
        Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
        specPricingObj1.Year__c = '2';
        specPricingObj1.LOB__c = 'ACT';
        specPricingObj1.Custom_Specialty_Grid__c=true;
        specPricingList.add(specPricingObj1);
        insert specPricingList;
        
        
       
       
       list<id> fafidsList = new List<ID>();
       for( Specialty_Operations__c c :specOperList){
          fafidsList.add(c.id);
       }
       
       
       
       
        Invoke_UpdateCustomSpecialtyGrid.UpdateSpecialtyGrid(fafidsList);
        Test.stopTest();
    }
}




}