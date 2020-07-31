@isTest(seeAlldata=false)
public class FAFIPITriggerCallTest{
     static testmethod void TestMethod1() {
            
         // Setup test data
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');
        
        
        System.runAs(u) {
            
            list<Central_Hub__c> fafList = new list<Central_Hub__c>();
            MAP<Id, Central_Hub__c> fafListMap = New MAP<Id, Central_Hub__c>();
            
            Account acct = TestDataFactory.createAccount();  
            acct.Market_Segment__c='Employer'; 
            acct.Status__c='Active';
            insert acct;
            
            CAG__c cag = TestDataFactory.createCAG('C', 'abc');
            //cag.Account_ID__c = '1234';
            cag.Record_Type__c='C';
            cag.Status__c='A';
            cag.Carrier_Name__c = '1234567890';
            cag.Platform_Name__c = 'RXCLAIM';
            insert cag;
            
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
            
            
            
            Insert fafList;
            
            for(Central_Hub__c FAF: fafList){
            fafListMap.put(FAF.id,FAF);
            }
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
            
             Client_Information__c ClientInformation = TestDataFactory.createClientInfo(faf1.Id);
             Insert ClientInformation;
            Platform_Specifics__c ps = new Platform_Specifics__c();
            ps.FAF_ID__c = faf1.id;
            ps.FAF_Client_Information__c = ClientInformation.id;
            ps.Platform__c = 'RXCLAIM';
            ps.LOB__c = 'ACT';
            ps.Instruction__c = 'Include';
            ps.Level_1_Record_ID__c = cag.id;
            //ps.Level_2_record_ID__c = cag.id;  
            ps.EffectiveDate__c = system.today();         
            insert ps; 
            
            IPI_WA_Tasks__c IWT = new IPI_WA_Tasks__c();
            IWT.Carrier_ID__c = '1234567890' ;
            IWT.FAF_ID__c = '33333' ;
            IWT.IPI_Opp_Id__c = '006m0000008rYGxAAM';
            IWT.Pricing_Effective_Date__c   = system.today();
            IWT.Super_Client_ID__c = '1234';
            IWT.Task_Case_ID__c = 'T-1555509';
            IWT.Task_ID__c='T-UNDW-16' ;
            IWT.Work_Assignment_Case_ID__c = 'WA-599294';
            IWT.Work_Assignment_ID__c ='UNDW1' ;
            insert IWT;
            
            fafList[0].FAF_Type__c='Partial';
            fafList[0].Billing_Operations__c= true;
            fafList[0].FAF_Status__c='Implemented';
            fafList[0].Peer_Reviewed__c = true;
            fafList[0].Approved_By_Sales__c = true;
            fafList[0].Peer_Reviewer__c = UserInfo.getUserId();
            
            update fafList[0];
            FAFTriggerHelper.updateFAFIDonIPIWAs(fafList,fafListMap);
            Test.stopTest();
        }
  }  
}