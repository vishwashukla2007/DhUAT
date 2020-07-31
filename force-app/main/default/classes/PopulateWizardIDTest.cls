@isTest
public class PopulateWizardIDTest{
    static testMethod void PopulateWizardIDTestMethod(){
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
            
            Apttus__WizardDesign__c apttusWizard= new Apttus__WizardDesign__c();
            apttusWizard.Name='22222';
            apttusWizard.Apttus__Category__c='Default';
            insert apttusWizard;
            
            test.startTest();
            
            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            agr.Status_In_Progress__c='Setup Pricing';
            agr.PCD_Status__c='Setup Pricing';
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            agrline.LOB_Description__c='';
            agrline.Default_Wizard__c=apttusWizard.id;
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c=agrline.id;
            update agr;
            
            Network_Operations__c ntOps= TestDataFactory.createNetworkOperation(FAFObj.id);
            ntOps.Agreement_Line_Item__c =agrline.id;
            insert ntOps;
            
            Network_Pricing__c  ntPricing=TestDataFactory.createntwrkPricing(FAFObj.id,ntOps.id);
            ntPricing.Agreement_Line_Item__c =agrline.id;
            insert ntPricing;
            
            Retail_Network_Guarantees__c retailNt=TestDataFactory.createretntwrkGuarnt(FAFObj.id,ntPricing.id);
            retailNt.Agreement_Line_Item__c =agrline.id;
            insert retailNt;
            
            List<ID> idList=new List<ID>();
            idList.add(agrline.id);
            
            PopulateWizardID.populateWizardIdOnLineItem(idList);
            test.stopTest();
        }
    }
}