/*
    Usage           :   This Test class is used to cover the ApttusApprovalRequestTrigger and ApttusApprovalRequestTriggerHelper class.
    Created by      :   Anudeep Dale
    Last ModifiedBy :   Anudeep Dale 
*/

@isTest
private class FAFReleaseEmailHelperTest {
    
    static testmethod void CoverIFMethod(){
        // Setup test data        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());
        
        User u1 = new User(Alias = 'standt', Email='Testing@testing.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='Testing123@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());
        
        
        List<user> userList =new List<user>();
        userList.add(u1);
        insert userList;
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
            
            LOB_Descriptor_support__c LOBDescript = new LOB_Descriptor_support__c();
            LOBDescript.Name = 'Testing';
            insert LOBDescript;
            
            Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.LOB_Descriptor__c = LOBDescript.Id;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            faf1.Underwriter_Manager__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true;          
            insert faf1;                    
            
            Apttus_Approval__Approval_Request__c aar = new Apttus_Approval__Approval_Request__c();
            
            aar.Queue_Users__c ='Testing@testing.com';
            aar.Send_Email_To_Address__c ='Testing@testing.com';
            aar.Send_Email_CC_Address__c = 'Testing@testing.com';
            //aar.Apttus_Approval__ObjectRefId__c = faf1.id;
            aar.Related_FAF__c = faf1.id;
            aar.Apttus_Approval__Assigned_To_Id__c = u.id;
            aar.Apttus_Approval__Send_Email__c = true;
            insert aar;     
            
            List<id> aarIds =new List<id>();
            aarIds.add(aar.id);
            FAFReleaseEmailHelper.sendFAFReleaseEmail(aarIds);
            
            Test.stopTest();
        }   
        
        
    }
    static testmethod void CoverElseMethod(){
        // Setup test data        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());
        
        User u1 = new User(Alias = 'standt', Email='Testing@testing.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='Testing123@testorg.com',Market_Segment__c='Employer',ManagerId = userInfo.getuserId());
        
        
        List<user> userList =new List<user>();
        userList.add(u1);
        
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
            
            LOB_Descriptor_support__c LOBDescript = new LOB_Descriptor_support__c();
            LOBDescript.Name = 'Testing';
            insert LOBDescript;
            
           Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= true;
            faf1.LOB_Descriptor__c = LOBDescript.Id;
            faf1.Specialty_Operations__c= true;
            faf1.Mail_Operations__c= true;
            faf1.Underwriter__c = u.id;
            faf1.Underwriter_Manager__c = u.id;
            faf1.Peer_Reviewer__c = u.id; 
            faf1.FAF_Type__c='Partial';  
            faf1.Clone_Flag__c = true;          
            insert faf1;                     
            
            Apttus_Approval__Approval_Request__c aar = new Apttus_Approval__Approval_Request__c();
            
            aar.Send_Email_To_Address__c ='Testing@testing.com';
            aar.Send_Email_CC_Address__c = 'Testing@testing.com';
            //aar.Apttus_Approval__ObjectRefId__c = faf1.id;
            aar.Related_FAF__c = faf1.id;
            aar.Apttus_Approval__Assigned_To_Id__c = u.id;
            aar.Apttus_Approval__Send_Email__c = true;
            insert aar;     
            
            List<id> aarIds =new List<id>();
            aarIds.add(aar.id);
            FAFReleaseEmailHelper.sendFAFReleaseEmail(aarIds);
            
            Test.stopTest();
        }   
        
        
    }  

}