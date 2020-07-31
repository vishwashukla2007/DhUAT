@isTest
public with sharing class Invoke_GridDisplayNameAdditionalTest{
    static testmethod void Invoke_GridDisplayNameAdditionalMethod1()
    {
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
            
            Grid_Display_Name_Setting__c gridDisp= new Grid_Display_Name_Setting__c();
            gridDisp.FAF__c =FAFObj.id;
            gridDisp.Object_Name__c='Clinical Solution';
            insert gridDisp;
            
            Clinical_Operations__c clinicalOprObj =  TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalOprObj;
            
            Clinical_Solutions__c clinicalSolObj =  TestDataFactory.createGClinicalSolution(FAFObj.id,clinicalOprObj.id);
            clinicalSolObj.Clinical_Solution__c='1st Level Appeals';
            clinicalSolObj.Clinical_Solution_Type__c='Commercial';
            clinicalSolObj.Fee_Basis__c='Annually';
            insert clinicalSolObj;
            
            List<ID> clinicalOpsList= new List<ID>();
            clinicalOpsList.add(clinicalOprObj.id);
            
            test.startTest();
           Invoke_GridDisplayNameAdditionalProgram.UpdateGridName(clinicalOpsList);
         
                      
            test.stopTest();
        }
        
        
    }
}