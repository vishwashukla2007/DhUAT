/*
    Usage           :   This Test class is used to cover the FAFPlatformSpecifics class.
    Created by      :   Anudeep Dale
    Last ModifiedBy :   Anudeep Dale 
*/
@isTest
public class FAFPlatformSpecificsTest {
  
    static testmethod void CoverPlatformSpecificsMethod(){
        // Setup test data        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());        
        
        System.runAs(u) {
        
            Test.startTest();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            acct.Status__c='Active';
            acct.iUMS_Client_Name__c = 'Testing';
            acct.iUMS_Client_Type__c = 'Employer';
            acct.iUMS_Client_Subtype__c = 'Coalition Master';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true; 
            faf1.FAF_Released_Date__c = system.now();
            insert faf1;  
      
      Client_Information__c ClientInformation = TestDataFactory.createClientInfo(faf1.Id);
      Insert ClientInformation;
                 
      Platform_Specifics__c ps = new Platform_Specifics__c();
      ps.FAF_ID__c = faf1.id;
      ps.FAF_Client_Information__c = ClientInformation.id;
      ps.Platform__c = null;
      ps.LOB__c = null;            
    //  insert ps;      
            
            List<id> fafIds =new List<id>();
            fafIds.add(faf1.id);
      FAFPlatformSpecifics.PlatformSpecifics(fafIds); 
            
            Test.stopTest();
        }                  
    }
    // if FAF_Released_Date__c is null
    static testmethod void CoverPlatformSpecificsMethod2(){
        // Setup test data        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());        
        
        System.runAs(u) {
        
            Test.startTest();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            acct.Status__c='Active';
            acct.iUMS_Client_Name__c = 'Testing';
            acct.iUMS_Client_Type__c = 'Employer';
            acct.iUMS_Client_Subtype__c = 'Coalition Master';
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true; 
            faf1.FAF_Released_Date__c = null;
            insert faf1;  
      
      Client_Information__c ClientInformation = TestDataFactory.createClientInfo(faf1.Id);
      Insert ClientInformation;
                 
      Platform_Specifics__c ps = new Platform_Specifics__c();
      ps.FAF_ID__c = faf1.id;
      ps.FAF_Client_Information__c = ClientInformation.id;
      ps.Platform__c = null;
      ps.LOB__c = null;            
      //insert ps;      
            
            List<id> fafIds =new List<id>();
            fafIds.add(faf1.id);
      FAFPlatformSpecifics.PlatformSpecifics(fafIds); 
            
            Test.stopTest();
        }                  
    }   
}