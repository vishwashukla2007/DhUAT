@isTest
private class IUMSDeleteObjectrecords1Test {
         
       static testmethod void TestMethod1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        
        List<id> idlist=new List<id>();
        
        Task__c tk=new Task__c();
        tk.Account__c=accObj.id;
        tk.Opportunity__c=oppObj.id;
        insert tk;
        
        idlist.add(tk.id);
        
        
        Offer__c offr=new Offer__c();
        offr.iUMSTask__c=tk.id;
        insert offr;
        
        LOB__c lb=new LOB__c();
        lb.FAF__c=FAFObj.id;
        lb.Client_Pricing_Offer__c=offr.id;
        insert lb;
        
        
        
        
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        clientInfo.Pricing_Effective_Date__c =System.Today();
        insert clientInfo;
        
         Legal_Information__c LegalInfoObj =  new Legal_Information__c();
         LegalInfoObj.FAF_ID__c= FAFObj.id;
         LegalInfoObj.Days_Written_Notice_Before_Termination__c='90';
         LegalInfoObj.Term_Without_Cause__c='Yes';
         LegalInfoObj.Frequency_1__c='Anytime';
         LegalInfoObj.Contract_Review_Completed__c=true;
         insert LegalInfoObj ;
         
         Specialty_Operations__c SpecOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
         insert SpecOpsObj;

         Specialty_Pricing__c SpecPricObj = TestDataFactory.createspecPricingObject(FAFObj.id,SpecOpsObj.id);
         insert SpecPricObj;
         
         Specialty_Drug_Level_Pricing__c  specDrugPr=TestDataFactory.createspecDrugObject(FAFObj.id,SpecOpsObj.id);
         insert specDrugPr;
         
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
           
          FAF_Instructions__c fafIns= new FAF_Instructions__c();
          fafIns.FAF_ID__c=FAFObj.id;
          fafIns.Instruction__c='test';
          fafIns.Type__c='Correction';
          insert fafIns;
        
        
        Test.startTest();
       // Invoke_iUMS_FAF_Delete DelOb= new Invoke_iUMS_FAF_Delete(idlist);
        Invoke_iUMS_FAF_Delete.Invoke_iUMS_FAF_Delete_Method(idlist);
        
        //IUMSDeleteObjectrecords1 ium= new IUMSDeleteObjectrecords1();
        //Database.executeBatch(ium);
        Test.stopTest();
    }
}