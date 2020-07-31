@isTest
public class FAFInstructionsTest{
 @isTest(SeeAllData=true)
    static void FAFInstructionsTest1()
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
            
            test.starttest();
            FAF_Instructions__c fafIns= new FAF_Instructions__c();
            fafIns.FAF_ID__c=FAFObj.id;
            fafIns.Instruction__c='test';
            fafIns.Type__c='Correction';
            insert fafIns;
            
            fafIns.Type__c='Change';
            update fafIns;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.FAF_Instructions__c=true;
            
            delete fafIns;
            test.stoptest();
        }
    }
}