@isTest(SeeAllData=true)
private class NetworkOperationsTriggerTest{
    @isTest(SeeAllData=true)
    static void NetworkOperationsm1() {
         
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
        
         Field_History_Tracking__c fht = new Field_History_Tracking__c();
         fht.Network_Operations__c=true;                                               
        Test.startTest();
            Network_Operations__c no = new Network_Operations__c();
            no.FAF_ID__c = faf1.id;
            no.Client__c='No MAC then Discount without U&C';
            no.Member__c='  Lower of Discount or U&C or Copay - Standard Copay Logic Off';
            insert no;
            no.Client__c='Lower of Discount or U&C or MAC';
            update no;
            Network_Pricing__c  np=TestDataFactory.createntwrkPricing(faf1.id,no.id);
            np.Brand_Basis__c='Standard Brand Discount';
            
            np.Generic_Rate__c=0.5;
            insert np;
            
            delete np;
            delete no;
        Test.stopTest();
     }  
       
    @isTest(SeeAllData=true)
    static void NetworkOperationsm2() {
         
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
                                                        
        Test.startTest();
            Network_Operations__c no = new Network_Operations__c();
            no.FAF_ID__c = faf1.id;
            no.Client__c='Lower of Discount or U&C or MAC';
            no.Member__c='  Lower of Discount or U&C or Copay - Standard Copay Logic Off';
            insert no;
            no.Client__c='No MAC then Discount without U&C';
            update no;
            Network_Pricing__c  np=TestDataFactory.createntwrkPricing(faf1.id,no.id);
            np.Brand_Basis__c='Pass-Through';
            np.Generic_Rate__c=0.5;
            insert np;
            
        Test.stopTest();
       }
       @isTest(SeeAllData=true)
       static void NetworkOperationsm3() {
         
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
        
         Field_History_Tracking__c fht = new Field_History_Tracking__c();
         fht.Network_Operations__c=true; 
        List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
        Test.startTest();
            Network_Operations__c no = new Network_Operations__c();
            no.FAF_ID__c = faf1.id;
            no.Client__c='Lower of Discount or U&C or MAC';
            no.Member__c='  Lower of Discount or U&C or Copay - Standard Copay Logic Off';
            insert no;
            
            
            Network_Pricing__c np1 = new Network_Pricing__c();
            np1.FAF_ID__c = faf1.Id;
            np1.FAF_Network_Ops__c = no.Id;
            np1.Retail_Network_Ordinal__c = 'Primary';
            np1.Year__c = 'All';
            np1.LOB__c = 'ACT';
            np1.Network_Name__c = 'MC(84-90)CP';
            np1.Brand_Rate__c = 5;
            np1.Brand_Basis__c='Standard Brand Discount';
            np1.Generic_Rate__c=0.5;
            np1.Brand_Dispensing_Fee__c=5;
            np1.Generic_Dispensing_Fee__c=5;
            np1.Rebate_Plan_Design__c='2 Tier Q';
            npList.add(np1);
            
            Network_Pricing__c np2 = new Network_Pricing__c();
            np2.FAF_ID__c = faf1.Id;
            np2.FAF_Network_Ops__c = no.Id;
            np2.Retail_Network_Ordinal__c = 'Primary';
            np2.Year__c = 'All';
            np2.LOB__c = 'CAP';
            np2.Network_Name__c = 'MC(84-90)CP';
            np2.Brand_Rate__c = 5;
            np2.Brand_Basis__c='Pass-Through';
            np2.Generic_Rate__c=0.5;
            npList.add(np2);
            insert npList;
            
            no.Client__c='No MAC then Discount without U&C';
            update no;
            
        Test.stopTest();
       }
}