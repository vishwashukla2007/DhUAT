@isTest
public class Invoke_iUMS_FAF_Delete_ReParentTest {

     static testmethod void IUMS_FAF_Delete_ReParent(){
        
         User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
         
         FAFObj.Data_Loading__c = true;
         update FAFObj;
        
        Test.startTest();
        List<id> idlist=new List<id>();
        
        Task__c tk=new Task__c();
        tk.Account__c=accObj.id;
        tk.Opportunity__c=oppObj.id;
        insert tk;
        
        idlist.add(tk.id);
        
        
        Offer__c offr=new Offer__c();
        offr.iUMSTask__c=tk.id;
        insert offr;
        
        LOB__c lb=new LOB__c();
        lb.FAF__c=FAFObj.id;
        lb.Client_Pricing_Offer__c=offr.id;
        insert lb;

            
       Invoke_iUMS_FAF_Delete_ReParent.Invoke_iUMS_FAF_Delete_ReParentfuture(idlist);
       Test.stopTest();
     }
    
     static testmethod void Method2(){
        
         User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
         
        FAFObj.Data_Loading__c = false;
         update FAFObj;
         
        Test.startTest();
        List<id> idlist=new List<id>();
        
        Task__c tk=new Task__c();
        tk.Account__c=accObj.id;
        tk.Opportunity__c=oppObj.id;
        insert tk;
        
        idlist.add(tk.id);
        
        
        Offer__c offr=new Offer__c();
        offr.iUMSTask__c=tk.id;
        insert offr;
        
        LOB__c lb=new LOB__c();
        lb.FAF__c=FAFObj.id;
        lb.Client_Pricing_Offer__c=offr.id;
        insert lb;

              
       Invoke_iUMS_FAF_Delete_ReParent.Invoke_iUMS_FAF_Delete_ReParentfuture(idlist);
       Invoke_iUMS_FAF_Delete_ReParent.Invoke_iUMS_FAF_Delete_ReParent(idlist);
       Test.stopTest();
        
     }
}