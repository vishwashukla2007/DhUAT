@isTest
public class TransactionFeeSharingHandlerTest {

   static testMethod void validateTransaction() {
           
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Coalition Member';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'MAC Prevails then Discount without U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Transaction_Fee_Sharing__c = 'Yes',  Type__c = 'Tiered' , 
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
    
        Transaction_Fee_Sharing_Tier__c Transactions = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,
        To__c = 19, Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id
            );
        insert Transactions; 
        
        Transaction_Fee_Sharing_Tier__c Transactions1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 20,
        To__c = 30, Client_Share__c = 65,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id
            );
        insert Transactions1; 
        
        
        
        ApexPages.currentPage().getParameters().put('id', Transactions1.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(Transactions1);
        TransactionFeeSharingHandler newTransaction = new TransactionFeeSharingHandler(TransactionSC);
        
        newTransaction.deleteRecord();
        delete Transactions;
        
  
    }
    
     static testMethod void validateTransaction1() {
           
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Coalition Member';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'MAC Prevails then Discount without U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Transaction_Fee_Sharing__c = 'Yes',  Type__c = 'Tiered' , 
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
    
        Transaction_Fee_Sharing_Tier__c Transactions = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,
        To__c = 19, Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id
            );
        insert Transactions; 
        
        Transaction_Fee_Sharing_Tier__c Transactions1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 20,
        To__c = 30, Client_Share__c = 65,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id
            );
        insert Transactions1; 
        
        
        
        ApexPages.currentPage().getParameters().put('id', Transactions.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(Transactions1);
        TransactionFeeSharingHandler newTransaction = new TransactionFeeSharingHandler(TransactionSC);
        
        newTransaction.deleteRecord();
        delete Transactions1;
        
  
    }

}