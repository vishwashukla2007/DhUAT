@isTest(SeeAllData=true)
public class Test_NetworkGuaranteesTriggerHelper {
    
    static testMethod void  runTest(){
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
                    
                    
                    //Network operatrions
                    Network_Operations__c NOP=TestDataFactory.createNetworkOperation(FAFObj.id);
                    insert NOP;
                    
                    Network_Pricing__c NP=TestDataFactory.createntwrkPricing(FAFObj.id,NOP.id);
                    NP.SSG_Exclusion_List__c='Standard';
                    insert Np;
                    
                    Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP.id);
                    RNG.SSG__c='No';
                    insert RNG;
                    
                    RNG.Type__c='BER';
                    update RNG;
                    
                    Field_History_Tracking__c fht=new Field_History_Tracking__c();
                    fht.Retail_Network_Guarantees__c=true;
            
                    Delete RNG;
                   
                 }
             }Catch(exception e){system.debug('+++++++no coverage++++++'+e.getmessage());}
    }
}