@isTest
public class BillingOtherFeesTest{
 @isTest
    static void BillingOtherFeesTest1()
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
            
            Billing_Operations__c billingOps=TestDataFactoryForBilling.createBillOps(FAFObj.id);
            insert billingOps;
            
            test.starttest();
            Billing_Other_Fees__c billingOtherFee= new Billing_Other_Fees__c();
            billingOtherFee.Billing_Operations__c=billingOps.id;
            billingOtherFee.FAF__c=FAFObj.id;
            billingOtherFee.Basis__c='> 1 million members';
            billingOtherFee.Fee_Amount__c=2;
            billingOtherFee.LOB__c='CAP';
            billingOtherFee.Other_Fee_Description__c='Claims History upon Termination';
            billingOtherFee.Other_Fee_Type__c='Commercial';
            billingOtherFee.Year__c='All';
            insert billingOtherFee;
            
            billingOtherFee.LOB__c='ACT';
            update billingOtherFee;
            
            //Field_History_Tracking__c fht=new Field_History_Tracking__c();
            //fht.FAF_Instructions__c=true;
            
            delete billingOtherFee;
            test.stoptest();
        }
    }
}