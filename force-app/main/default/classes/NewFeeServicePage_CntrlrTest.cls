@isTest
public class NewFeeServicePage_CntrlrTest {
    
    @isTest
    public static void newFeeServicePageTest(){
         PageReference pageRef = Page.NewFeeServicePage;
        Test.setCurrentPage(pageRef);
        
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
        
         Central_Hub__c faf2 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        faf2.Salesperson__c= null;
        faf2.Network_Operations__c= true;
        faf2.Specialty_Operations__c= true;
        faf2.Mail_Operations__c= true;
        insert faf2;
        
        Fee_Services__c fs = new Fee_Services__c();
        fs.FAF_ID__c = faf1.Id;
        fs.Retiree_Drug_Subsidy__c = true;
        insert fs;
        
        Fee_Services__c fs2 = new Fee_Services__c();
        fs2.FAF_ID__c = faf1.Id;
        fs2.Retiree_Drug_Subsidy__c = true;
        
        Fee_Services__c fs3 = new Fee_Services__c();
        fs3.FAF_ID__c = faf2.Id;
        fs3.Retiree_Drug_Subsidy__c = true;
       // insert f2s;
        Apexpages.StandardController sc = new Apexpages.standardController(fs);
        NewFeeServicePage_Cntrlr controller = new NewFeeServicePage_Cntrlr(sc);
        controller.saveFeeService();
        controller.redirectToRequiredPage();
        
        sc = new Apexpages.standardController(fs2);
        controller = new NewFeeServicePage_Cntrlr(sc);
        controller.saveFeeService();
        controller.redirectToRequiredPage();
        
        sc = new Apexpages.standardController(fs3);
        controller = new NewFeeServicePage_Cntrlr(sc);
        controller.saveFeeService();
       // controller.redirectToRequiredPage();
        
        sc = new Apexpages.standardController(new Fee_Services__c());
        controller = new NewFeeServicePage_Cntrlr(sc);
        controller.saveFeeService();
    }
}