/*********************************************************************************************
 * @ClassName         : QueueListExtractorTest
 * @author            : Anudeep Dale
 * @created date      : 23/10/2018
 * @Last modified by  : Anudeep Dale
 * @Last modified date: 23/10/2018
 * @Purpose           : For increase the QueueListExtractor class coverage 
 **********************************************************************************************/
@isTest
public class QueueListExtractorTest{

    static testmethod void CoverSendEmailMethod(){
        // Setup test data        
        // This code runs as the system user
		Group g1 = new Group(Name='groupname', type='Queue');
		insert g1;
		
		/*
		QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Apttus_Approval__Approval_Request__c');
		insert q1; 
		*/
		
        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = g1.Id;
        Insert grpMem1;	
					
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
			
			Apttus_Approval__Approval_Request__c aar = new Apttus_Approval__Approval_Request__c();
            
            aar.Send_Email_To_Address__c ='Testing@testing.com';
            aar.Send_Email_CC_Address__c = 'Testing@testing.com';
            //aar.Apttus_Approval__ObjectRefId__c = faf1.id;
            aar.Related_FAF__c = faf1.id;
            aar.Apttus_Approval__Assigned_To_Id__c = u.id;
            aar.Apttus_Approval__Send_Email__c = true;
			aar.Queue_List__c = 'groupname';
            insert aar;     
            
            List<id> aarIds =new List<id>();
            aarIds.add(aar.id);
            QueueListExtractor.extractor(aarIds);
            
            Test.stopTest();
        }                  
    }
}