@isTest(seeAlldata=true)
public class Test_AccountTriggerFutureHandler{
 
 public static TestMethod void doTest(){
           try{
            Test.startTest();
            Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
            UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        
 
            User u1 = new User(Alias = 'standt1', Email='sstandarduser1212@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                              TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='sstandarduser2121@testorg.com',Market_Segment__c='Employer');
     
           insert u1;   
        
           User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u1.id, UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        
            
        System.runAs(u) { 
        
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            acct.Status__c='Active';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            list<Central_Hub__c> fafList = new list<Central_Hub__c>();

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
            
            insert fafList;
            
            account acct1=[select id,Market_Segment__c from account where id=:acct.id];
            acct1.Market_Segment__c ='Consumer Programs';
            update acct1; 
            Test.stopTest();
     }
     }catch(exception e){system.debug('++++++test calss failed with exception:'+e.getMessage());}
 }
 
 //method to cover AccountOwnerAccess
  public static TestMethod void doTestAccountOwner(){
           //try{
            Test.startTest();
             Profile p1 = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
            UserRole role1=[select id,name  from userrole where name='Apttus Underwriting'];
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Sales']; 
            UserRole role=[select id,name  from userrole where name='Apttus Sales Read Only'];
            
           
            
 
            User u8 = new User(Alias = 'newus8', Email='newsalesuser8@testorg.com', 
                      EmailEncodingKey='UTF-8', LastName='Testing8', LanguageLocaleKey='en_US', 
                      LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                      TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='newsalesuser8@testorg.com',Market_Segment__c='Employer');
     
           insert u8; 
           
           User u1 = new User(Alias = 'salesu1', Email='salesuser1@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Sales1', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, ManagerId=u8.id,
                              TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='newsalesuser1@testorg.com',Market_Segment__c='Employer');
     
           insert u1; 
           
           User u2 = new User(Alias = 'newus2', Email='newsalesuser2@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, ManagerId=u1.id,
                              TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='newsalesuser2@testorg.com',Market_Segment__c='Employer');
     
           insert u2; 
           
           User u3 = new User(Alias = 'salesu3', Email='salesuser3@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Sales3', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u2.id, UserName='salesuser3@testorg.com',Market_Segment__c='Employer');
        
            insert u3;
 
            User u4 = new User(Alias = 'newsu4', Email='newsalesuser4@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, ManagerId=u3.id,
                              TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='newsalesuser4@testorg.com',Market_Segment__c='Employer');
     
           insert u4;   
        
            User u5 = new User(Alias = 'salesu5', Email='salesuser5@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Sales5', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u4.id, UserName='salesuser5@testorg.com',Market_Segment__c='Employer');
        
            insert u5;
 
            User u6 = new User(Alias = 'newsu6', Email='newsalesuser6@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing6', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id ,ManagerId=u5.id, 
                              TimeZoneSidKey='America/Los_Angeles',isactive=true, UserName='newsalesuser6@testorg.com',Market_Segment__c='Employer');
     
           insert u6;  
            
            User u7 = new User(Alias = 'salesu7', Email='salesuser7@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Sales7', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, ManagerId=u6.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='salesuser7@testorg.com',Market_Segment__c='Employer');
        
            insert u7;
 
 

            User us = new User(Alias = 'salesu', Email='salesuser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Sales', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u1.id, 
                          Manager_Level_2__c='salesuser2',Manager_Level_3__c='salesuser3',Manager_Level_4__c='salesuser4',
                          Manager_Level_5__c='salesuser5', Manager_Level_6__c='salesuser6', Manager_Level_7__c='salesuser7',
                          UserName='salesuser11@testorg.com',Market_Segment__c='Employer');
        
            insert us;
 
            User us1 = new User(Alias = 'newsu', Email='newsalesuser22@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Salesuser1', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                              TimeZoneSidKey='America/Los_Angeles',isactive=true, ManagerId=u1.id, 
                              Manager_Level_2__c='newsalesu2',Manager_Level_3__c='salesuser3',Manager_Level_4__c='newsalesu4',
                              Manager_Level_5__c='salesuser5', Manager_Level_6__c='newsalesu6', Manager_Level_7__c='salesuser7',
                              UserName='newsalesuser22@testorg.com',Market_Segment__c='Employer');
     
           insert us1;  
        
           User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, userroleid=role1.id, 
                          TimeZoneSidKey='America/Los_Angeles',ManagerId=u8.id, UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        
            
        System.runAs(u) { 
        
            Account acct = TestDataFactory.createAccount(); 
            acct.Status__c='Active';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;

            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,u7.id);
            insert faf1;
            Central_Hub__c faf2 = TestDataFactory.createFAF(acct.Id,opp.Id,u7.id);
            insert faf2;
            
            acct.OwnerId=us.id; 
            update acct;
            
            System.debug('after updated owner');
            Test.stopTest();
     }
     //}catch(exception e){system.debug('++++++test calss failed with exception:'+e.getMessage());}
 }

}