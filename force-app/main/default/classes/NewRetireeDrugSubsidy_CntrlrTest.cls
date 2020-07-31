@isTest
public class NewRetireeDrugSubsidy_CntrlrTest {
    
    @isTest
    public static void newRetireeDrugSubsidyTest(){
        PageReference pageRef = Page.NewRetireeDrugSubsidyPage;
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
        
        Fee_Service_Template__c fst = new Fee_Service_Template__c();
        fst.Effective_date__c = System.today();
        fst.Expiration_Date__c = System.today().addDays(3);
        fst.Amount__c = 100;
        fst.Max_Amount__c = 500;
        fst.Item__c = 'test';
        fst.Item_Section__c = 'test';
        fst.Active__c = true;
        fst.Item_Description__c = 'test';
        fst.Template_Type__c = 'RDS Services';
        insert fst;
        
        Fee_Services__c fs = new Fee_Services__c();
        fs.FAF_ID__c = faf1.Id;
        fs.Retiree_Drug_Subsidy__c = true;
        insert fs;
        
        Retiree_Drug_Subsidy__c rds = new Retiree_Drug_Subsidy__c();
        rds.FAF_ID__c = faf1.Id;
        rds.Fee_Services__c = fs.Id;
        rds.Amount__c = 200;
        rds.Election__c = true;
        rds.Basis__c = 'Per Card';
        rds.Sequence__c = 2;
        rds.Service__c = 'Test';
        rds.Fee_Service_Template__c = fst.Id;
        
        Retiree_Drug_Subsidy__c rds2 = new Retiree_Drug_Subsidy__c();
        rds2.FAF_ID__c = faf1.Id;
        rds2.Fee_Services__c = fs.Id;
        rds2.Basis__c = 'Per Card';
        rds2.Amount__c = 200;
        rds2.Election__c = true;
        rds2.Sequence__c = 2;
        rds2.Service__c = 'Test2';
        
        Retiree_Drug_Subsidy__c rds3 = new Retiree_Drug_Subsidy__c();
        rds3.FAF_ID__c = faf1.Id;
        rds3.Fee_Services__c = fs.Id;
        rds3.Basis2__c = 'Per Card';
        rds3.Amount__c = 600;
        rds3.Election__c = true;
        rds3.Sequence__c = 2;
        rds3.Service__c = 'Test2';
        rds3.Fee_Service_Template__c = fst.Id;
        insert rds3;
        
        Retiree_Drug_Subsidy__c rds4 = new Retiree_Drug_Subsidy__c();
        rds4.FAF_ID__c = faf1.Id;
        rds4.Fee_Services__c = fs.Id;
        rds4.Basis__c = 'Test';
        rds4.Amount__c = 300;
        rds4.Election__c = true;
        rds4.Sequence__c = 2;
        rds4.Service__c = 'Test4';
        rds4.Fee_Service_Template__c = fst.Id;
        
        Retiree_Drug_Subsidy__c rds5 = new Retiree_Drug_Subsidy__c();
       // rds5.FAF_ID__c = faf1.Id;
        rds5.Fee_Services__c = fs.Id;
        rds5.Basis__c = 'Per Card';
        rds5.Amount__c = 200;
        rds5.Election__c = true;
        rds5.Sequence__c = 2;
        rds5.Service__c = 'Test2';
        
        Test.startTest();
        // ApexPages.currentPage().getParameters().put('id', bof.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(rds);
        NewRetireeDrugSubsidy_Cntrlr controller = new NewRetireeDrugSubsidy_Cntrlr(sc);
        controller.saveRetireeDrugSubsidy();
        upsert rds;
        
        sc = new Apexpages.standardController(rds2);
        controller = new NewRetireeDrugSubsidy_Cntrlr(sc);
        controller.saveRetireeDrugSubsidy();
        sc = new Apexpages.standardController(rds3);
        controller = new NewRetireeDrugSubsidy_Cntrlr(sc);
        controller.saveRetireeDrugSubsidy();
        sc = new Apexpages.standardController(rds4);
        controller = new NewRetireeDrugSubsidy_Cntrlr(sc);
        controller.saveRetireeDrugSubsidy();
        sc = new Apexpages.standardController(rds5);
        controller = new NewRetireeDrugSubsidy_Cntrlr(sc);
        controller.saveRetireeDrugSubsidy();
        controller = new NewRetireeDrugSubsidy_Cntrlr(null);
        controller.saveRetireeDrugSubsidy();
        
        rds4 = [SELECT Id,Name FROM Retiree_Drug_Subsidy__c LIMIT 1];
        rds4.Additional_Service__c = false;
       // rds4.RDS_Allowed__c = true;
        update rds4;
        try{
            delete rds4;
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }
    
}