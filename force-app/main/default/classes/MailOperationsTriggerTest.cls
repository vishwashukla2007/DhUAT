@isTest
private class MailOperationsTriggerTest{
    @isTest static void mailOperationm1() {
         
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
            Mail_Operations__c mo = new Mail_Operations__c();
            mo.FAF_ID__c = faf1.id;
            mo.Client__c='Lower of MAC or Discount';
            mo.Member__c='Lower of Discount or Copay - Standard Copay Logic Off';
            insert mo;
            
            Mail_Pricing__c mp = new Mail_Pricing__c(
                              FAF_Mail_Operations__c = mo.Id,
                              FAF_ID__c = faf1.Id
                          );
            insert mp;
            
            Mail_Guarantees__c mg = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, 
                                                            FAF_ID__c = faf1.Id,
                                                            SSG__c = 'No', 
                                                            Type__c = 'SSG' );
            insert mg;
          Test.stopTest();
              
          system.assert( mg.Id <> null );
            delete mg;
            delete mo;
        
       } 
     @isTest static void mailOperationmTwo() {
         
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
            Mail_Operations__c mo = new Mail_Operations__c();
            mo.FAF_ID__c = faf1.id;
            mo.Client__c='Lower of MAC or Discount';
            mo.Member__c='Lower of Discount or Copay - Standard Copay Logic Off';
            insert mo;
            
            Mail_Pricing__c mp = new Mail_Pricing__c(
                              FAF_Mail_Operations__c = mo.Id,
                        SSGs_into_Brands__c = true,
                              FAF_ID__c = faf1.Id
                          );
            insert mp;
            
            Mail_Guarantees__c mg = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, 
                                                            FAF_ID__c = faf1.Id,
                                                            SSG__c = 'No', 
                                                            Type__c = 'SSG' );
            insert mg;
          Test.stopTest();
          Mail_Guarantees__c mg2 = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, 
                                                            FAF_ID__c = faf1.Id,
                                                            SSG__c = 'No', 
                                                            Type__c = 'SSG' );
        insert mg2;    
        system.assert( mg.Id <> null );
            delete mg;
            delete mo;
        
       }
    @isTest static void mailOperationm3() {
         
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
            Mail_Operations__c mo = new Mail_Operations__c();
            mo.FAF_ID__c = faf1.id;
            mo.Client__c='Lower of MAC or Discount';
            mo.Member__c='Lower of Discount or Copay - Standard Copay Logic Off';
            insert mo;
            
            mo.Member__c='Maximize to Copay - Standard Copay Logic On';
            update mo;
            
            Mail_Pricing__c mp = new Mail_Pricing__c(
                              FAF_Mail_Operations__c = mo.Id,
                              FAF_ID__c = faf1.Id,
                              Year__c='All',
                              LOB__c='ACT'
                          );
            insert mp;
            
            Network_Operations__c netwrkOps=TestDataFactory.createNetworkOperation(faf1.id);
            insert netwrkOps;
            
            Network_Pricing__c ntwrkPricing= TestDataFactory.createntwrkPricing(faf1.id, netwrkOps.id);
            insert ntwrkPricing;
          
          Test.stopTest();
          
        
       }       
}