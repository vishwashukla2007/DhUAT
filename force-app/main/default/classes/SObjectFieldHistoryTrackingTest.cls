@isTest(SeeAllData=true)
public class SObjectFieldHistoryTrackingTest{
    @isTest(SeeAllData=true)
     static void SObjectFieldHistoryTrackingTest1() {
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
            Field_History_Tracking__c fht= new Field_History_Tracking__c();
            fht.Central_Hub__c=true;
            
           Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
            faf1.Salesperson__c= null;
            faf1.Network_Operations__c= false;
            faf1.Specialty_Operations__c= false;
            faf1.Mail_Operations__c= false;
            faf1.FAF_Type__c='Partial';
            insert faf1;
            
            faf1.Salesperson__c= null;
            faf1.Underwriter__c = u.id;//UserInfo.getUserId();
            faf1.Peer_Reviewer__c = u.id;
            faf1.Sales_Approver__c= u.id;  
            faf1.FAF_Type__c='Partial';
            faf1.Approved_By_Sales__c= false;
            faf1.Peer_Reviewed__c= false;
            upsert faf1;
            
            Test.stopTest();
        }
     }
}