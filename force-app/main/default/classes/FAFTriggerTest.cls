@isTest(seeAllData=true)
private class FAFTriggerTest{
    @isTest(seeAllData=true)
     static void TestinsertFAF() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
 
  User u1 = new User(Alias = 'standt1', Email='sstandarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='sstandarduser2121@testorg.com',Market_Segment__c='Employer');
     
insert u1;        system.debug('u1'+u1.id);
        
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u1.id, UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        
        
        System.runAs(u) { 
            
            list<Central_Hub__c> fafList = new list<Central_Hub__c>();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            acct.Status__c='Active';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= false;
            faf1.Specialty_Operations__c= false;
            faf1.Mail_Operations__c= false;
            faf1.Underwriter__c = u.id;//UserInfo.getUserId();
            faf1.Peer_Reviewer__c = u.id;
            faf1.Sales_Approver__c= u.id;  
            faf1.FAF_Type__c='Partial';
            faf1.Approved_By_Sales__c= false;
            faf1.Peer_Reviewed__c= false;
            // faf1.FAF_Status__c='Implemented';
            
            fafList.add(faf1);
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            faf2.Network_Operations__c= false;
            faf2.Specialty_Operations__c= false;
            faf2.Mail_Operations__c= false;
            faf2.FAF_Type__c='Partial';
            fafList.add(faf2);                
            
            Central_Hub__c faf3 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf3.Salesperson__c= null;
            faf3.Network_Operations__c= false;
            faf3.Specialty_Operations__c= false;
            faf3.Mail_Operations__c= false;
            fafList.add(faf3);
            
            Central_Hub__c faf4 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf4.Salesperson__c= null;
            faf4.Network_Operations__c= false;
            faf4.Specialty_Operations__c= false;
            faf4.Mail_Operations__c= false;
            fafList.add(faf4);        
            
            Central_Hub__c faf5 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf5.Salesperson__c= null;
            faf5.Network_Operations__c= False;
            faf5.Specialty_Operations__c= false;
            faf5.Mail_Operations__c= false;
            fafList.add(faf5);
            
            Central_Hub__c faf6 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf6.Salesperson__c= null;
            faf6.Network_Operations__c= False;
            faf6.Specialty_Operations__c= False;
            faf6.Mail_Operations__c= false;
            fafList.add(faf6);
            
            Central_Hub__c faf7 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf7.Salesperson__c= null;
            faf7.Network_Operations__c= false;
            faf7.Specialty_Operations__c= False;
            faf7.Mail_Operations__c= False;
            fafList.add(faf7);        
            
            Central_Hub__c faf8 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf8.Salesperson__c= null;
            faf8.Network_Operations__c= False;
            faf8.Specialty_Operations__c= false;
            faf8.Mail_Operations__c= False;
            fafList.add(faf8);
            
            Central_Hub__c faf9 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf9.Salesperson__c= null;
            faf9.Network_Operations__c= False;
            faf9.Specialty_Operations__c= False;
            faf9.Mail_Operations__c= False;
            faf9.Billing_Operations__c= false;
            fafList.add(faf9);        
            
            Central_Hub__c faf10 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf10.Salesperson__c= null;
            faf10.Network_Operations__c= False;
            faf10.Specialty_Operations__c= False;
            faf10.Mail_Operations__c= False;
            faf10.Billing_Operations__c= False;
            faf10.Rebate_Operations__c= False;
            faf10.Clinical_Operations__c= False;
            faf10.Guarantee_Information__c= False;
            fafList.add(faf10);
            
            Insert fafList;
            
            list<Billing_Operations__c> billopsList = new list<Billing_Operations__c>();
            Billing_Operations__c billop = TestDataFactory.createBillOps(fafList[0].Id);
            billopsList.add(billop);
            Insert billopsList;
            
            Test.startTest();
            List<Client_Information__c> updatefafClientInfo= new   List<Client_Information__c> ();
            List<Client_Information__c> fafClientInfo = [Select Rebate_Effective_Date__c, 
                                                         Pricing_Effective_Date__c,
                                                         FAF_ID__r.Business_Type__c
                                                         from 
                                                         Client_Information__c
                                                         Where
                                                         FAF_ID__c IN : fafList];
            for(Client_Information__c cinfo :fafClientInfo){
                cinfo.Pricing_Effective_Date__c=System.today();
                updatefafClientInfo.add(cinfo);
            }
            update updatefafClientInfo;
            fafList[0].FAF_Type__c='Partial';
            fafList[0].Billing_Operations__c= true;
            fafList[0].FAF_Status__c='Implemented';
            fafList[0].Peer_Reviewed__c = true;
            fafList[0].Approved_By_Sales__c = true;
            fafList[0].Peer_Reviewer__c = UserInfo.getUserId();
            
            update fafList[0];
            //FAFTriggerHelper.validateLinkFAF(fafList);
            FAFTriggerHelper.FromandTodatespopulate(fafList);
            FAFTriggerHelper.FAFErrorValidator(fafList);
            FAFTriggerHelper.updateOpsBeforeUpdate(fafList);
            FAFTriggerHelper.validateLinkFAF(fafList);
            FAFTriggerHelper.populateUnderwriter(fafList);
            FAFTriggerHelper.populateUnderwriterCreatedBy(fafList);
            FAFTriggerHelper.populateMarketSegment(fafList);
            Test.stopTest();
        }
    }
    
   @isTest(seeAllData=true)
    private static void TestSalesPersonAccessOnFAF() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
   
  User u1 = new User(Alias = 'standt1', Email='sstandarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='sstandarduser2121@testorg.com',Market_Segment__c='Employer');
     
insert u1;        system.debug('u1'+u1.id);
        
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u1.id, UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        
        System.runAs(u) {
            
            list<Central_Hub__c> fafList = new list<Central_Hub__c>();
            list<Account> accList = new list<Account>();
            list<AccountTeamMember> AccountTeamMemberList = new list<AccountTeamMember>();
            list<Opportunity> oppList = new list<Opportunity>();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer';  
            acct.Status__c='Active';
            accList.add(acct) ;
            
            Account acct2 = TestDataFactory.createAccount();  
            acct2.Market_Segment__c='Employer';   
            acct2.Status__c='Active';
            accList.add(acct2) ;
            insert accList;
            
            
            
            Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
            oppList.add(opp);
            Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
            oppList.add(opp2);
            insert oppList;
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales'];
            User usales1 = new User(Alias = 'Sales1', Email='TestSales1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales1@testorg.com',Market_Segment__c='Employer');
            User usales2 = new User(Alias = 'Sales12', Email='TestSales12@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales12@testorg.com',Market_Segment__c='Employer');
            List<User> usales = new List<User>();
            usales.add(usales1);
            usales.add(usales2);
           // List<User> usales=[SELECT Id FROM USER where Profile.Name='Apttus Sales' limit 2];
            Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf1.Salesperson__c= usales[0].id;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;//UserInfo.getUserId();
            faf1.Peer_Reviewer__c = u.id;
            //faf1.FAF_Status__c='Sales Review';
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'Existing';
            
            fafList.add(faf1);
            
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= False;
            faf2.Mail_Operations__c= true;
            faf2.Business_Type__c = 'New';
            fafList.add(faf2);  
            
            Central_Hub__c faf3 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf3.Salesperson__c= usales[0].id;
            faf3.Network_Operations__c= true;
            faf3.Specialty_Operations__c= true;
            faf3.Mail_Operations__c= true;
            faf3.Underwriter__c = u.id;//UserInfo.getUserId();
            faf3.Peer_Reviewer__c = u.id;
            //faf3.FAF_Status__c='Sales Review';
            faf3.LOB2__c ='EGFI';
            faf3.Business_Type__c = 'Existing';
            
            fafList.add(faf3);
            Insert fafList;
            
            Test.startTest();
            
         

            
            
            fafList[0].Account_Name__c=accList[1].Id;
            fafList[0].Salesperson__c=null;
            fafList[0].LOB2__c = 'PR'; 
            fafList[0].Business_Type__c = 'New';
            fafList[0].Opportunity_Name__c=oppList[1].Id;
            fafList[1].Business_Type__c = 'Existing';
            fafList[1].Salesperson__c = usales[0].id;
            fafList[2].Salesperson__c = usales[1].id;
            update fafList;
            
            FAFTriggerHelper.FromandTodatespopulate(fafList);
            FAFTriggerHelper.FAFErrorValidator(fafList);
            FAFTriggerHelper.updateOpsBeforeUpdate(fafList);
            FAFTriggerHelper.validateLinkFAF(fafList);
            FAFTriggerHelper.populateUnderwriter(fafList);
            FAFTriggerHelper.populateUnderwriterCreatedBy(fafList);
            FAFTriggerHelper.populateMarketSegment(fafList);
            
            
            Test.stopTest();
        }
        
    }
     @isTest(seeAllData=true)
    private static void TestAccessOnFAF() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
     
  User u1 = new User(Alias = 'standt1', Email='sstandarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='sstandarduser2121@testorg.com',Market_Segment__c='Employer');
     
insert u1;        system.debug('u1'+u1.id);
        
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u1.id, UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        
        System.runAs(u) {
            
            list<Central_Hub__c> fafList = new list<Central_Hub__c>();
            list<Account> accList = new list<Account>();
            list<AccountTeamMember> AccountTeamMemberList = new list<AccountTeamMember>();
            list<Opportunity> oppList = new list<Opportunity>();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer';  
            acct.Status__c='Active';
            acct.iUMS_Client_Subtype__c='TPA Master';
            accList.add(acct) ;
            
            Account acct2 = TestDataFactory.createAccount();  
            acct2.Market_Segment__c='Employer';   
            acct2.Status__c='Active';
            acct2.iUMS_Client_Subtype__c='TPA Master';
            accList.add(acct2) ;
            insert accList;
            
            AccountTeamMember TeamMemberAd=new AccountTeamMember();
            TeamMemberAd.AccountId=accList[0].id;
            TeamMemberAd.UserId=u.id;
            TeamMemberAd.TeamMemberRole = 'Account Manager';
            AccountTeamMemberList.add(TeamMemberAd);
            
            
            AccountTeamMember TeamMemberAd1=new AccountTeamMember();
            TeamMemberAd1.TeamMemberRole = 'Account Manager';
            TeamMemberAd1.AccountId=accList[1].id;
            TeamMemberAd1.UserId=u.id;
            AccountTeamMemberList.add(TeamMemberAd1);
            insert AccountTeamMemberList; 
            
            
            Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
            oppList.add(opp);
            Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
            oppList.add(opp2);
            insert oppList;
            user u2=[select id ,profile.name from user where profile.name='Apttus Sales' and isactive=true limit 1];
            Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf1.Salesperson__c= u2.id;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;//UserInfo.getUserId();
            faf1.Peer_Reviewer__c = u.id;
            //yyyfaf1.FAF_Status__c='Sales Review';
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'New';
            
            fafList.add(faf1);
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf2.Salesperson__c=  u2.id;
            faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= False;
            faf2.Mail_Operations__c= true;
            faf2.Business_Type__c = 'Existing';
            fafList.add(faf2);  
            
            
     
             Insert fafList;
            
            
            
            Test.startTest();
                  
         
            //insert TestDataFactory.createGuaranteeInfo( fafList[0].id);
          // List<User> usales=[SELECT Id FROM USER where Profile.Name='Apttus Sales' limit 2];
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales'];
            User usales1 = new User(Alias = 'Sales1', Email='TestSales1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales1@testorg.com',Market_Segment__c='Employer');
            User usales2 = new User(Alias = 'Sales12', Email='TestSales12@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales12@testorg.com',Market_Segment__c='Employer');
             List<User> usales = new List<User>();
             usales.add(usales1);
             usales.add(usales2);
            
            fafList[0].Account_Name__c=accList[1].Id;
            fafList[0].Salesperson__c=usales[0].id;
            fafList[0].LOB2__c = 'PR'; 
            fafList[0].Business_Type__c = 'Existing';
            fafList[0].Opportunity_Name__c=oppList[1].Id;
            fafList[1].Business_Type__c = 'Existing';
            Map<id,Central_Hub__c>fafOldMap= new Map<id,Central_Hub__c>();
            fafOldMap.put(fafList[0].id,fafList[0]);
            update fafList;

                Test.stopTest();
        }
        
    } 
     @isTest(seeAllData=true)
    private static void TestCentrlHubAccessOnFAF() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales'];
        User usales1 = new User(Alias = 'Sales1', Email='TestSales1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales1@testorg.com',Market_Segment__c='Employer');
        insert usales1;
        User usales2 = new User(Alias = 'Sales12', Email='TestSales12@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales12@testorg.com',Market_Segment__c='Employer');
        insert usales2;
        User usales3 = new User(Alias = 'Sales123', Email='TestSales123@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales123@testorg.com',Market_Segment__c='Employer');
        insert usales3;
        
        List<User> usales = new List<User>();
        usales.add(usales1);
        usales.add(usales2);
        usales.add(usales3);
      //  usales=[SELECT Id FROM USER where isActive=true];
        for(User u:usales){
            u.Market_Segment__c='Employer';
        }
        update usales;
        User u =  usales[0];
        list<Central_Hub__c> fafList = new list<Central_Hub__c>();
        list<Account> accList = new list<Account>();
        list<AccountTeamMember> AccountTeamMemberList = new list<AccountTeamMember>();
        list<Opportunity> oppList = new list<Opportunity>();
        
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';  
        acct.Status__c='Active';
        accList.add(acct) ;
        
        Account acct2 = TestDataFactory.createAccount();  
        acct2.Market_Segment__c='Employer';   
        acct2.Status__c='Active';
        accList.add(acct2) ;
        insert accList;
        
        AccountTeamMember TeamMemberAd=new AccountTeamMember();
        TeamMemberAd.AccountId=accList[0].id;
        TeamMemberAd.UserId=u.id;
        TeamMemberAd.TeamMemberRole = 'Account Manager';
        AccountTeamMemberList.add(TeamMemberAd);
        
        
        AccountTeamMember TeamMemberAd1=new AccountTeamMember();
        TeamMemberAd1.TeamMemberRole = 'Account Manager';
        TeamMemberAd1.AccountId=accList[1].id;
        TeamMemberAd1.UserId=u.id;
        AccountTeamMemberList.add(TeamMemberAd1);
        insert AccountTeamMemberList; 
        
        
        Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
        oppList.add(opp);
        Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
        oppList.add(opp2);
        insert oppList;
        Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
        faf1.Salesperson__c= null;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.Mail_Operations__c= true;
        
        
       // faf1.FAF_Status__c='Sales Review';
        faf1.LOB2__c ='EGFI';
        faf1.Business_Type__c = 'New';
        
        fafList.add(faf1);
        
        Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
        faf2.Salesperson__c= null;
        faf2.Network_Operations__c= true;
        faf2.Specialty_Operations__c= False;
        faf2.Mail_Operations__c= true;
        faf2.Business_Type__c = 'Existing';
        
        fafList.add(faf2);  
        
        
        Insert fafList;
        
        Test.startTest();
        Central_Hub__Share cntrHubShare= new Central_Hub__Share(); // creating record for each account team member for related account 
        cntrHubShare.AccessLevel='Read';
        cntrHubShare.ParentId= fafList[0].id;
        cntrHubShare.RowCause ='Manual';
        cntrHubShare.UserOrGroupId=usales[1].id;
        insert cntrHubShare;
        
        fafList[0].Account_Name__c=accList[1].Id;
        fafList[0].Salesperson__c=usales[1].id;
        fafList[0].LOB2__c = 'PR'; 
        fafList[0].Business_Type__c = 'Existing';
        fafList[0].Opportunity_Name__c=oppList[1].Id;
        fafList[1].Business_Type__c = 'Existing';
        update fafList;
        FAFTriggerHelper.FromandTodatespopulate(fafList);
            FAFTriggerHelper.FAFErrorValidator(fafList);
            FAFTriggerHelper.updateOpsBeforeUpdate(fafList);
            FAFTriggerHelper.validateLinkFAF(fafList);
            FAFTriggerHelper.populateUnderwriter(fafList);
            FAFTriggerHelper.populateUnderwriterCreatedBy(fafList);
            FAFTriggerHelper.populateMarketSegment(fafList);
        Test.stopTest();
        
        
    } 
         @isTest(seeAllData=true)
    private static void TestCentrlHubAccessOnFAFNew() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales'];
        User usales1 = new User(Alias = 'Sales1', Email='TestSales1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales1@testorg.com',Market_Segment__c='Employer');
        insert usales1;
        User usales2 = new User(Alias = 'Sales12', Email='TestSales12@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales12@testorg.com',Market_Segment__c='Employer');
        insert usales2;
        User usales3 = new User(Alias = 'Sales123', Email='TestSales123@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales123@testorg.com',Market_Segment__c='Employer');
        insert usales3;
        
        List<User> usales = new List<User>();
        usales.add(usales1);
        usales.add(usales2);
        usales.add(usales3);
      //  usales=[SELECT Id FROM USER where isActive=true];
        for(User u:usales){
            u.Market_Segment__c='Employer';
        }
        usales[0].managerid =usales[1].id;
         usales[1].managerid =usales[2].id;
        update usales;
        User u =  usales[0];
        
        list<Central_Hub__c> fafList = new list<Central_Hub__c>();
        list<Account> accList = new list<Account>();
        list<AccountTeamMember> AccountTeamMemberList = new list<AccountTeamMember>();
        list<Opportunity> oppList = new list<Opportunity>();
        
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';  
        acct.Status__c='Active';
        accList.add(acct) ;
        
        Account acct2 = TestDataFactory.createAccount();  
        acct2.Market_Segment__c='Employer';   
        acct2.Status__c='Active';
        accList.add(acct2) ;
        insert accList;
        
        AccountTeamMember TeamMemberAd=new AccountTeamMember();
        TeamMemberAd.AccountId=accList[0].id;
        TeamMemberAd.UserId=u.id;
        TeamMemberAd.TeamMemberRole = 'Account Manager';
        AccountTeamMemberList.add(TeamMemberAd);
        
        
        AccountTeamMember TeamMemberAd1=new AccountTeamMember();
        TeamMemberAd1.TeamMemberRole = 'Account Manager';
        TeamMemberAd1.AccountId=accList[1].id;
        TeamMemberAd1.UserId=u.id;
        AccountTeamMemberList.add(TeamMemberAd1);
        insert AccountTeamMemberList; 
        
        
        Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
        oppList.add(opp);
        Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
        oppList.add(opp2);
        insert oppList;
        Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
        faf1.Salesperson__c= usales[0].id;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.Mail_Operations__c= true;
        
        
       // faf1.FAF_Status__c='Sales Review';
        faf1.LOB2__c ='EGFI';
        faf1.Business_Type__c = 'New';
        
        fafList.add(faf1);
        
        Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
        faf2.Salesperson__c= null;
        faf2.Network_Operations__c= true;
        faf2.Specialty_Operations__c= False;
        faf2.Mail_Operations__c= true;
        faf2.Business_Type__c = 'Existing';
        
        fafList.add(faf2);  
        
        
        Insert fafList;
        
        Test.startTest();
        Central_Hub__Share cntrHubShare= new Central_Hub__Share(); // creating record for each account team member for related account 
        cntrHubShare.AccessLevel='Read';
        cntrHubShare.ParentId= fafList[0].id;
        cntrHubShare.RowCause ='Manual';
        cntrHubShare.UserOrGroupId=usales[1].id;
        insert cntrHubShare;
        
        fafList[0].Account_Name__c=accList[1].Id;
        fafList[0].Salesperson__c=usales[1].id;
        fafList[0].LOB2__c = 'PR'; 
        fafList[0].Business_Type__c = 'Existing';
        fafList[0].Opportunity_Name__c=oppList[1].Id;
        fafList[1].Business_Type__c = 'Existing';
        update fafList;
        FAFTriggerHelper.FromandTodatespopulate(fafList);
            FAFTriggerHelper.FAFErrorValidator(fafList);
            FAFTriggerHelper.updateOpsBeforeUpdate(fafList);
            FAFTriggerHelper.validateLinkFAF(fafList);
            FAFTriggerHelper.populateUnderwriter(fafList);
            FAFTriggerHelper.populateUnderwriterCreatedBy(fafList);
            FAFTriggerHelper.populateMarketSegment(fafList);
        Test.stopTest();
        
        
    } 
       @isTest(seeAllData=true)
    private static void TestCentrlHubAccessOnFAFNewStatus() {
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales'];
        User usales1 = new User(Alias = 'Sales1', Email='TestSales1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales1@testorg.com',Market_Segment__c='Employer');
        insert usales1;
        User usales2 = new User(Alias = 'Sales12', Email='TestSales12@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales12@testorg.com',Market_Segment__c='Employer');
        insert usales2;
        User usales3 = new User(Alias = 'Sales123', Email='TestSales123@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='TestSales123@testorg.com',Market_Segment__c='Employer');
        insert usales3;
        
        List<User> usales = new List<User>();
        usales.add(usales1);
        usales.add(usales2);
        usales.add(usales3);
      //  usales=[SELECT Id FROM USER where isActive=true];
        for(User u:usales){
            u.Market_Segment__c='Employer';
        }
        usales[0].managerid =usales[1].id;
         usales[1].managerid =usales[2].id;
        update usales;
        User u =  usales[0];
        
        list<Central_Hub__c> fafList = new list<Central_Hub__c>();
        list<Account> accList = new list<Account>();
        list<AccountTeamMember> AccountTeamMemberList = new list<AccountTeamMember>();
        list<Opportunity> oppList = new list<Opportunity>();
        
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';  
        acct.Status__c='Active';
        accList.add(acct) ;
        
        Account acct2 = TestDataFactory.createAccount();  
        acct2.Market_Segment__c='Employer';   
        acct2.Status__c='Active';
        accList.add(acct2) ;
        insert accList;
        
        AccountTeamMember TeamMemberAd=new AccountTeamMember();
        TeamMemberAd.AccountId=accList[0].id;
        TeamMemberAd.UserId=u.id;
        TeamMemberAd.TeamMemberRole = 'Account Manager';
        AccountTeamMemberList.add(TeamMemberAd);
        
        
        AccountTeamMember TeamMemberAd1=new AccountTeamMember();
        TeamMemberAd1.TeamMemberRole = 'Strategic Account Executive 1  ';
        TeamMemberAd1.AccountId=accList[1].id;
        TeamMemberAd1.UserId=u.id;
        AccountTeamMemberList.add(TeamMemberAd1);
        insert AccountTeamMemberList; 
        
        
        Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
        oppList.add(opp);
        Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
        oppList.add(opp2);
        insert oppList;
        Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
        faf1.Salesperson__c= usales[0].id;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.FAF_Status__c='Deleted';
        faf1.Mail_Operations__c= true;
        
        
       // faf1.FAF_Status__c='Sales Review';
        faf1.LOB2__c ='EGFI';
        faf1.Business_Type__c = 'New';
        
        fafList.add(faf1);
        
        Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
        faf2.Salesperson__c= null;
        faf2.Network_Operations__c= true;
        faf2.Specialty_Operations__c= False;
        faf2.Mail_Operations__c= true;
        faf2.Business_Type__c = 'Existing';
        
        fafList.add(faf2);  
        
        
        Insert fafList;
        
        Test.startTest();
        Central_Hub__Share cntrHubShare= new Central_Hub__Share(); // creating record for each account team member for related account 
        cntrHubShare.AccessLevel='Read';
        cntrHubShare.ParentId= fafList[0].id;
        cntrHubShare.RowCause ='Manual';
        cntrHubShare.UserOrGroupId=usales[1].id;
        insert cntrHubShare;
        
        fafList[0].Account_Name__c=accList[1].Id;
        fafList[0].FAF_Status__c='Draft'; 
        fafList[0].Salesperson__c=usales[1].id;
        fafList[0].LOB2__c = 'PR'; 
        fafList[0].Business_Type__c = 'Existing';
        fafList[0].Opportunity_Name__c=oppList[1].Id;
        fafList[1].Business_Type__c = 'Existing';
        update fafList;
       
        Test.stopTest();
        
        
    } 
    
       @isTest(seeAllData=true)
    private static void TestFafTrigger1() {
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account acct = TestDataFactory.createAccount();  
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,useObjNew.id);
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'New';
            insert faf1; 
            
            Test.startTest();
            
            faf1.Business_Type__c = 'Existing';
            update faf1;
           
            Test.stopTest();
            
        }
    } 
}