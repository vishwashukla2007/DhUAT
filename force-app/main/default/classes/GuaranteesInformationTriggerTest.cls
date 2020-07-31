@isTest
public with sharing class GuaranteesInformationTriggerTest{
    @isTest(seeAllData=true)
    static void GuaranteesInformationTriggerMet1()
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
            
             CAG__c cag = new CAG__c();
                cag.CAG_ID__c = 'CAG1234567890789TEST';
                cag.Record_Type__c='A';
                cag.Status__c='A';
                
                insert cag;
                        
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            insert clientInfo;
            
            test.starttest();
            
           Guarantees_Information__c  guaranteeInfo= TestDataFactory.createGuaranteeInfo(FAFObj.id);
           guaranteeInfo.Guaranteed_Net_Cost_Gnc_Guarantee__c='Yes';
           guaranteeInfo.Gnc_Guarantee_Risk_Sharing__c='No';
           guaranteeInfo.Gnc_Claim_Exclusions__c='COB';
           guaranteeInfo.Gnc_Guarantee_Basis__c='$ for $ Unlimited';
           guaranteeInfo.Gnc_Retain_Rebates_After_Reconciliation__c='No';
           guaranteeInfo.Gnc_Guarantee_Frequency__c='Annually';
           guaranteeInfo.Gnc_Recon_Timeframe__c='Contract Term';
           guaranteeInfo.Gnc_Recon_Level__c='Client';
           insert guaranteeInfo;
           
           guaranteeInfo.Gnc_Recon_Level__c='LOB';
           update guaranteeInfo;
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Guarantees_Information__c=true;
            delete guaranteeInfo;
            
            test.stoptest();
        }
    }
}