@isTest(seeAllData=true)
private class OpportunityTriggerHelper_Test {
    @isTest(seeAllData=true)
    private static void testAccessOnFAF() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
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
            
            List<User> usales=[SELECT Id FROM USER where Profile.Name='Apttus Sales' and Isactive=true and ManagerId!=null limit 2];
            Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf1.Salesperson__c= usales[0].id;
            faf1.Underwriter__c=u.id;
            //faf1.Network_Operations__c= true;
            //faf1.Specialty_Operations__c= true;
            //faf1.Mail_Operations__c= true;
            
            
            //faf1.FAF_Status__c='Sales Review';
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'Existing';
            
            fafList.add(faf1);
            
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            faf2.Underwriter__c=u.id;
            //faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= False;
            //faf2.Mail_Operations__c= true;
            faf2.Business_Type__c = 'New';
            fafList.add(faf2);  
            
            Central_Hub__c faf3 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf3.Salesperson__c= usales[0].id;
            //faf3.Network_Operations__c= true;
            //faf3.Specialty_Operations__c= true;
            //faf3.Mail_Operations__c= true;
            
            
            //faf3.FAF_Status__c='Sales Review';
            faf3.LOB2__c ='EGFI';
            faf3.Underwriter__c=u.id;
            faf3.Business_Type__c = 'Existing';
            
            fafList.add(faf3);
            Insert fafList;
            
            Test.startTest();
            oppList[0].Oppty_Winner__c='test Testing';
            oppList[1].Med_D_Sales_Lead__c='test Testing';
            update oppList;
            
            delete  oppList[0];
            delete  oppList[1];
            Test.stopTest();
        }
    }
    @isTest(seeAllData=true)
    private static void testAccessOnFAF2() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
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
            opp.Oppty_Winner__c='test Testing';
            
            oppList.add(opp);
            Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
            opp2.Med_D_Sales_Lead__c='test Testing';
            oppList.add(opp2);
            insert oppList;
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
            
            List<User> usales=[SELECT Id FROM USER where Profile.Name='Apttus Sales' and Isactive=true and ManagerId!=null limit 2];
            Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf1.Salesperson__c= usales[0].id;
            //faf1.Network_Operations__c= true;
            //faf1.Specialty_Operations__c= true;
            //faf1.Mail_Operations__c= true;
            
            
            //faf1.FAF_Status__c='Sales Review';
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'Existing';
            faf1.Underwriter__c=u.id;
            fafList.add(faf1);
            
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            //faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= False;
            //faf2.Mail_Operations__c= true;
            faf2.Business_Type__c = 'New';
            faf2.Underwriter__c=u.id;
            fafList.add(faf2);  
            
            Central_Hub__c faf3 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf3.Salesperson__c= usales[0].id;
            //faf3.Network_Operations__c= true;
            //faf3.Specialty_Operations__c= true;
            //faf3.Mail_Operations__c= true;
            
            
            //faf3.FAF_Status__c='Sales Review';
            faf3.LOB2__c ='EGFI';
            faf3.Business_Type__c = 'Existing';
            faf3.Underwriter__c=u.id;
            fafList.add(faf3);
            Insert fafList;
            
            Test.startTest();
            oppList[0].Oppty_Winner__c=null;
            oppList[1].Med_D_Sales_Lead__c=null;
            update oppList;
            
            Test.stopTest();
        }
        
    }
    @isTest(seeAllData=true)
    private static void testAccessOnFAF3() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
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
            
            List<User> usales=[SELECT Id,Name FROM USER where Profile.Name='Apttus Sales' and Isactive=true and ManagerId!=null limit 2];
            
            Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
            opp.Oppty_Winner__c=usales[0].Name;
            
            oppList.add(opp);
            Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
            opp2.Med_D_Sales_Lead__c=usales[1].Name;
            oppList.add(opp2);
            insert oppList;
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
            
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf1.Salesperson__c= usales[0].id;
            //faf1.Network_Operations__c= true;
            //faf1.Specialty_Operations__c= true;
            //faf1.Mail_Operations__c= true;
            
            
            //faf1.FAF_Status__c='Sales Review';
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'Existing';
            faf1.Underwriter__c=u.id;
            
            fafList.add(faf1);
            
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            //faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= False;
            //faf2.Mail_Operations__c= true;
            faf2.Business_Type__c = 'New';
            faf2.Underwriter__c=u.id;
            fafList.add(faf2);  
            
            Central_Hub__c faf3 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf3.Salesperson__c= usales[0].id;
            //faf3.Network_Operations__c= true;
            //faf3.Specialty_Operations__c= true;
            //faf3.Mail_Operations__c= true;
            
            
            //faf3.FAF_Status__c='Sales Review';
            faf3.LOB2__c ='EGFI';
            faf3.Business_Type__c = 'Existing';
            faf3.Underwriter__c=u.id;
            fafList.add(faf3);
            Insert fafList;
            
            Test.startTest();
            oppList[0].Oppty_Winner__c='';
            oppList[1].Med_D_Sales_Lead__c='';
            update oppList;
            
         
            
            
            Test.stopTest();
        }
        
    }
     @isTest(seeAllData=true)
    private static void testAccessOnFAF4() {
        // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
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
            
            List<User> usales=[SELECT Id,Name FROM USER where Profile.Name='Apttus Sales' and Isactive=true and ManagerId!=null limit 2];
             List<id>salesPersonMapIdNewList= new List<ID>();
            salesPersonMapIdNewList.add(usales[1].id);
            Set<id>salesPersonMapIdNew= new Set<ID>();
            salesPersonMapIdNew.add(usales[0].id);
            OpportunityTriggerHelper.insertUserWithPermission(salesPersonMapIdNew);
            OpportunityTriggerHelper.deleteUserWithPermission(salesPersonMapIdNewList);
            Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
            opp.Oppty_Winner__c=usales[0].Name;
            
            oppList.add(opp);
            Opportunity opp2 = TestDataFactory.createOpportunity(accList[1].Id);
            opp2.Med_D_Sales_Lead__c=usales[1].Name;
            oppList.add(opp2);
            insert oppList;
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
            
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf1.Salesperson__c= usales[0].id;
            //faf1.Network_Operations__c= true;
            //faf1.Specialty_Operations__c= true;
            //faf1.Mail_Operations__c= true;
            
            
            //faf1.FAF_Status__c='Sales Review';
            faf1.LOB2__c ='EGFI';
            faf1.Business_Type__c = 'Existing';
            faf1.Underwriter__c=u.id;
            
            fafList.add(faf1);
            
            
            Central_Hub__c faf2 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf2.Salesperson__c= null;
            //faf2.Network_Operations__c= true;
            faf2.Specialty_Operations__c= False;
            //faf2.Mail_Operations__c= true;
            faf2.Business_Type__c = 'New';
            faf2.Underwriter__c=u.id;
            fafList.add(faf2);  
            
            Central_Hub__c faf3 = TestDataFactory.createFAF(accList[0].Id,oppList[0].Id,UserInfo.getUserId());
            faf3.Salesperson__c= usales[0].id;
            //faf3.Network_Operations__c= true;
            //faf3.Specialty_Operations__c= true;
            //faf3.Mail_Operations__c= true;
            
            
            //faf3.FAF_Status__c='Sales Review';
            faf3.LOB2__c ='EGFI';
            faf3.Business_Type__c = 'Existing';
            faf3.Underwriter__c=u.id;
            fafList.add(faf3);
            Insert fafList;
            
            Test.startTest();
            oppList[0].Oppty_Winner__c=usales[1].Name;
            oppList[1].Med_D_Sales_Lead__c=usales[0].Name;
            update oppList;
            
            central_Hub__share insertFAFShareObj = new central_Hub__share();
            insertFAFShareObj.AccessLevel = 'Edit';
            insertFAFShareObj.ParentId = faf1.id;
            insertFAFShareObj.RowCause = ConstantsUtil.Manual;
            insertFAFShareObj.UserOrGroupId =usales[1].id;
            //insert insertFAFShareObj;
            

            salesPersonMapIdNew.add(usales[0].id);
            OpportunityTriggerHelper.insertUserWithPermission(salesPersonMapIdNew);
            OpportunityTriggerHelper.deleteSalespersonAccessOnFaf(oppList);
           // OpportunityTriggerHelper.salespersonAccessOnFaf(oppList);
           // OpportunityTriggerHelper.deleteUserWithPermission();
            Test.stopTest();
        }
        
    }
}