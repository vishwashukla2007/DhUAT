@isTest
public with sharing class Invoke_UpdateSpecialtyOperationTest{
//Method1
static testMethod void Invoke_UpdateSpecialtyOperationMethod1(){
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
        //Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
        //specOpsObj.Pharmacy_Benefit__c ='Open';
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
        
        
        
        Test.startTest();
        
        List<Specialty_Operations__c > specOperList = new List<Specialty_Operations__c >();
        Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
        specOpsObj.Pharmacy_Benefit__c ='Open';
        specOpsObj.Custom_Specialty_Therapy_Name__c ='ExclusionsCustom';
        specOperList.add(specOpsObj);
        insert specOperList;
       
       
        list<id> fafidsList = new List<ID>();
        for( Specialty_Operations__c c :specOperList){
          fafidsList.add(c.id);
        }
        
        Invoke_UpdateSpecialtyOperation.UpdateSpecialtyOps(fafidsList);
        Test.stopTest();

        }

    }

}