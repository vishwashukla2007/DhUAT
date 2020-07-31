@isTest
private class RebateOperationsTriggerTest{
    @isTest static void RebateOperationsm1() {
         
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';     
        insert acct;
        
        Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
        insert opp;     
        
        Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        faf1.Salesperson__c= null;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.Mail_Operations__c= true;
        insert faf1;
        Guarantees_Information__c guarInfoObj =  TestDataFactory.createGuaranteeInfo(faf1 .id);
            guarInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'Yes';
            guarInfoObj.Trend_Guarantee__c='Yes';
            guarInfoObj.Average_Sales_Price_Per_Client_ASP__c=True;
            guarInfoObj.ASP_Specific_Plan_Design__c=False;
            guarInfoObj.Client_Share_Percent__c= 50;
            insert guarInfoObj;                                               
        Test.startTest();
            Rebate_Operations__c ro = new Rebate_Operations__c();
            ro.FAF_ID__c = faf1.id;
            ro.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
            ro.Rebate_Contract_Type__c='Group Purchase Organization (GPO)';
            ro.Rebate_Offering_Type__c='Guarantee Only';
            ro.Specialty_Rebates__c='Do Not Pass to Client';
            ro.X340B__c='Yes';
            ro.LDD__c='Yes';
            ro.Retail_90_Mirror_Retail_30__c = true;
            ro.Specialty_Retail_Mirror_Retail_30__c = true;
            ro.MChoice_Mirror_Mail__c = true;
            insert ro;
            
            delete ro;
        Test.stopTest();
       } 
        @isTest static void RebateOperationsm2() {
         
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';     
        insert acct;
        
        Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
        insert opp;     
        
        Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        faf1.Salesperson__c= null;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.Mail_Operations__c= true;
        insert faf1;
        Guarantees_Information__c guarInfoObj =  TestDataFactory.createGuaranteeInfo(faf1 .id);
            guarInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'Yes';
            guarInfoObj.Trend_Guarantee__c='Yes';
            guarInfoObj.Average_Sales_Price_Per_Client_ASP__c=True;
            guarInfoObj.ASP_Specific_Plan_Design__c=False;
            guarInfoObj.Client_Share_Percent__c= 50;
            insert guarInfoObj;                                               
        Test.startTest();
            Rebate_Operations__c ro = new Rebate_Operations__c();
            ro.FAF_ID__c = faf1.id;
            ro.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'Yes';
            ro.Rebate_Contract_Type__c='Group Purchase Organization (GPO)';
            ro.Rebate_Offering_Type__c='Guarantee Only';
            ro.Specialty_Rebates__c='Do Not Pass to Client';
            ro.X340B__c='Yes';
            ro.LDD__c='Yes';
            ro.Retail_90_Mirror_Retail_30__c = true;
            ro.Specialty_Retail_Mirror_Retail_30__c = true;
            ro.MChoice_Mirror_Mail__c = true;
            insert ro;
            Rebate_Guarantees__c rebtGuarant = TestDataFactory.createRebateGuarantee(faf1.id, ro.id);
            insert rebtGuarant;
            ro.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No';
            update ro;
            delete ro;
        Test.stopTest();
       }       
}