@isTest(seeAllData=true)
public class TransactionLogsCTriggerHelperTest {

   static testMethod void doTest1(){ 
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        User useObj1 = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj1;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
         System.runAs(useObj){
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
                
               Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,useObjNew.id);
                faf1.Salesperson__c= null;
                faf1.Network_Operations__c= false;
                faf1.Specialty_Operations__c= false;
                faf1.Mail_Operations__c= false;
                faf1.FAF_Type__c='Partial';
                insert faf1;
                
                Network_Operations__c no=TestDataFactory.createNetworkOperation(faf1.id);
                insert no;
                
                faf1.Salesperson__c= useObjNew.id;
                faf1.Underwriter__c = UserInfo.getUserId();
                faf1.Peer_Reviewer__c = useObj1.id;
                faf1.Sales_Approver__c= UserInfo.getUserId();  
                faf1.FAF_Type__c='Partial';
                faf1.Approved_By_Sales__c= false;
                faf1.Peer_Reviewed__c= false;
                upsert faf1;
                Test.startTest();
                faf1.Peer_Reviewer__c = UserInfo.getUserId();
                upsert faf1;
                
                TransactionLogsC__c trans= new TransactionLogsC__c();
                trans.FAFId__c=faf1.id;
                trans.OldValue__c=useObj1.id;
                trans.NewValue__c=UserInfo.getUserId();
                insert trans;
                /*
                List<TransactionLogsC__c> listTrans= new List<TransactionLogsC__c>();
                TransactionLogsCTriggerHelper.updateUserNameOnInsert(listTrans);
                */          
                Test.stopTest();
           }  
    
    }  
}