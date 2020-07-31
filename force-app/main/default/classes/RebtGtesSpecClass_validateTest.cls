@isTest
public class RebtGtesSpecClass_validateTest{
 @isTest(SeeAllData=true)
    static void RebtGtesSpecClass_validateTest1()
    {
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
            
            Rebate_Operations__c rebateOps=TestDataFactory.createRebOps(FAFObj.id);
            insert rebateOps;
            
            Rebate_Gtees_Specialty_Class_Carve_Outs__c rebateGtees= TestDataFactory.createGtees(rebateOps.id,FAFObj.id);
            
            test.starttest();
            insert rebateGtees;
            
            rebateGtees.Year__c='All';
            update rebateGtees;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Rebate_Gtees_Specia_Class_Carve_Outs__c=true;
            
            delete rebateGtees;
            test.stoptest();
        }
    }
}