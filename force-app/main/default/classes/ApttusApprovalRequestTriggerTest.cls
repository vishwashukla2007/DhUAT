/*
    Usage           :   This Test class is used to cover the ApttusApprovalRequestTrigger and ApttusApprovalRequestTriggerHelper class.
    Created by      :   Anudeep Dale
    Last ModifiedBy :   Anudeep Dale 
*/

@isTest
private class ApttusApprovalRequestTriggerTest {
    
    static testmethod void RelatedFAFMethod(){
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
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            //faf1.Underwriter_Manager__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true;          
            insert faf1;
                        
            List<Id> aarIds = new List<Id>();
            
            Apttus_Approval__Approval_Request__c aar = new Apttus_Approval__Approval_Request__c();
            
            aar.Send_Email_To_Address__c ='Testing@testing.com';
            aar.Send_Email_CC_Address__c = 'Testing@testing.com';
            aar.Apttus_Approval__ObjectRefId__c = faf1.id;
            aar.Related_FAF__c = faf1.id;
            aar.Apttus_Approval__Object_Type__c='central_hub__c';
            aar.Apttus_Approval__Assigned_To_Id__c = u.id;
            aar.Apttus_Approval__Send_Email__c = true;
            insert aar;           
            
            Test.stopTest();
        }   
        
        
    }
  // to cover the second if the helper
    static testmethod void RelatedFAFMethod2(){
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
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            //faf1.Underwriter_Manager__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true;          
            insert faf1;
                      
            List<Id> aarIds = new List<Id>();
            
            Apttus_Approval__Approval_Request__c aar = new Apttus_Approval__Approval_Request__c();
            
            aar.Send_Email_To_Address__c ='Testing@testing.com';
            aar.Send_Email_CC_Address__c = 'Testing@testing.com';
            aar.Apttus_Approval__Assigned_To_Id__c = u.id;
            //aar.Related_FAF__c = faf1.id; 
            aar.Apttus_Approval__ObjectRefId__c = faf1.id;
            //aar.Apttus_Approval__Send_Email__c = true;
            insert aar;           
            
            Test.stopTest();
        }   
        
        
    }  
    
    static testmethod void RelatedFAFMethod3(){
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
            insert acct;
            
            Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
            insert opp;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            //faf1.Underwriter_Manager__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true;          
            insert faf1;
            
            Performance_Guarantees__c perGtees = new Performance_Guarantees__c();
            perGtees.FAF__c=faf1.id;
            perGtees.Status__c='Draft';
            perGtees.Client_Agreement_Name__c='Test';
            insert perGtees;
                      
            List<Id> aarIds = new List<Id>();
            
            Apttus_Approval__Approval_Request__c aar = new Apttus_Approval__Approval_Request__c();
            
            aar.Send_Email_To_Address__c ='Testing@testing.com';
            aar.Send_Email_CC_Address__c = 'Testing@testing.com';
            aar.Apttus_Approval__Assigned_To_Id__c = u.id;
            //aar.Related_FAF__c = faf1.id; 
            aar.Apttus_Approval__Object_Type__c='Performance_Guarantees__c';
            aar.Apttus_Approval__ObjectRefId__c = perGtees.id;
            aar.Apttus_Approval__Send_Email__c = true;
            insert aar;           
            
            Test.stopTest();
        }   
        
        
    }  

}