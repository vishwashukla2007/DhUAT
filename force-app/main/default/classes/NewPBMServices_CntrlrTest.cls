@isTest
public class NewPBMServices_CntrlrTest {
    
    @isTest
    public static void newPbmService(){

         /*UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');        
        insert u;*/
        PageReference pageRef = Page.NewPBMService;
        Test.setCurrentPage(pageRef);
        //System.runAs(u){
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
        faf1.Segment__c = 'Aetna';
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
        fst.Template_Type__c = 'PBM Services';
        insert fst;
        Fee_Services__c fs = new Fee_Services__c();
        fs.FAF_ID__c = faf1.Id;
        fs.Retiree_Drug_Subsidy__c = false;
        fs.PBM_Services__c = true;
        insert fs;
        
        PBM_Services__c pbm = new PBM_Services__c();
        pbm.Election__c = true;
        //pbm.FAF_ID__c = faf1.Id;
        pbm.Fee_Service_Template__c = fst.Id;
        pbm.Fee_Services__c = fs.Id;
        pbm.Amount__c = 200;
        pbm.Basis2__c = 'Per Card';
        pbm.Sequence__c = 2;
        pbm.Service__c = '1';
        insert pbm;
        
        PBM_Services__c pbm2 = new PBM_Services__c();
        pbm2.Election__c = true;
        pbm2.FAF_ID__c = faf1.Id;
        pbm2.Fee_Service_Template__c = fst.Id;
        pbm2.Fee_Services__c = fs.Id;
        pbm2.Amount__c = 200;
        pbm2.Basis2__c = 'Per Card';
        pbm2.Sequence__c = 2;
        pbm2.Service__c = '0';
        
        PBM_Services__c pbm3 = new PBM_Services__c();
        pbm3.Election__c = true;
        pbm3.FAF_ID__c = faf1.Id;
        pbm3.Fee_Service_Template__c = fst.Id;
        pbm3.Fee_Services__c = fs.Id;
        pbm3.Amount__c = 200;
        pbm3.Basis2__c = 'Per Card';
        pbm3.Sequence__c = 2;
        pbm3.Service__c = '0';
        
        PBM_Services__c pbm4 = new PBM_Services__c();
        pbm4.Election__c = true;
        pbm4.FAF_ID__c = faf1.Id;
        //pbm4.Fee_Service_Template__c = fst.Id;
        pbm4.Fee_Services__c = fs.Id;
        pbm4.Amount__c = 200;
        pbm4.Basis2__c = 'Per Card';
        pbm4.Sequence__c = 2;
        pbm4.Service__c = '0';
        
        PBM_Services__c pbm5 = new PBM_Services__c();
        pbm5.Election__c = true;
        pbm5.FAF_ID__c = faf1.Id;
        pbm5.Fee_Service_Template__c = fst.Id;
        //pbm5.Fee_Services__c = fs.Id;
        pbm5.Amount__c = 300;
        pbm5.Basis2__c = 'Per Card Test';
        pbm5.Sequence__c = 2;
        pbm5.Service__c = '20';
        
        Test.startTest();
        Apexpages.StandardController sc = new Apexpages.standardController(pbm2);
        NewPBMServices_Cntrlr controller = new NewPBMServices_Cntrlr(sc);
        controller.savePBMServices();
        
        sc = new Apexpages.standardController(pbm3);
        controller = new NewPBMServices_Cntrlr(sc);
        controller.savePBMServices();
        
        sc = new Apexpages.standardController(pbm4);
        controller = new NewPBMServices_Cntrlr(sc);
        controller.savePBMServices();
        
        sc = new Apexpages.standardController(pbm);
        controller = new NewPBMServices_Cntrlr(sc);
        controller.savePBMServices();
        
        sc = new Apexpages.standardController(pbm5);
        controller = new NewPBMServices_Cntrlr(sc);
        controller.savePBMServices();
        
        sc = new Apexpages.standardController(new PBM_Services__c());
        controller = new NewPBMServices_Cntrlr(sc);
        controller.savePBMServices();
        
        pbm = [SELECT Id,Name FROM PBM_Services__c LIMIT 1];
        pbm.Additional_Service__c = false;
        update pbm;
        try{
            delete pbm;
        }
        catch(Exception e){
            
        }
        Test.stopTest();
      //  }
    }
}