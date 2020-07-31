@isTest
public class TransactionFeeSharingTriggerHandlerTest {  

          
    static testmethod void ValidateMaxTrans(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        //Tier 1  
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'MAC Prevails then Discount without U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On', Type__c = 'Tiered',
        Transmission_Fee_Waived__c = true, Transaction_Fee_Sharing__c = 'Yes',
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,To__c = 19,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        
        
        Transaction_Fee_Sharing_Tier__c TransactionFees1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 20,To__c = 39,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees1;
        Transaction_Fee_Sharing_Tier__c TransactionFees2 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 40,To__c = 59,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees2;
        Transaction_Fee_Sharing_Tier__c TransactionFees3 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 60,To__c = 79,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees3;
        Transaction_Fee_Sharing_Tier__c TransactionFees4 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 80,To__c = 89,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees4;
        Transaction_Fee_Sharing_Tier__c TransactionFees5 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 90,To__c = 99,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees5;
        Transaction_Fee_Sharing_Tier__c TransactionFees6 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 100,To__c = 109,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees6;
        Transaction_Fee_Sharing_Tier__c TransactionFees7 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 110,To__c = 119,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees7;
        Transaction_Fee_Sharing_Tier__c TransactionFees8 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 120,To__c = 129,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees8;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees9 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 130,To__c = 139,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees9;

        
        Transaction_Fee_Sharing_Tier__c TransactionFees10 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 141,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees10;
        
        //added by sonal sharma
        TransactionFees.From__c=20;
        TransactionFees.Client_Share__c=30;
        TransactionFees.Client_Share__c=70;
        update TransactionFees;
        
        TransactionFees1.From__c=30;
        TransactionFees1.Client_Share__c=47;
        TransactionFees1.Client_Share__c=80;
        update TransactionFees1;
     }
    
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
    
        Transaction_Fee_Sharing_Tier__c TransactionFee1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,
        To__c = 19, Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Tier__c = 1,
        Network_Operations__c = NetworkOps.Id
            );
        insert TransactionFee1; 
        
        Transaction_Fee_Sharing_Tier__c TransactionFee2 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 20,
        To__c = 30, Client_Share__c = 65,
        FAF_ID__c = FAFObj.Id,
        Tier__c = 2,
        Network_Operations__c = NetworkOps.Id
            );
        insert TransactionFee2;   
            
        Transaction_Fee_Sharing_Tier__c TransactionFee3 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 25,
        To__c = 35, Client_Share__c = 65,
        FAF_ID__c = FAFObj.Id,
        Tier__c = 4,
        Network_Operations__c = NetworkOps.Id
            );
            
        insert TransactionFee3; 
        
        Transaction_Fee_Sharing_Tier__c TransactionFee4 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 35,
        To__c = 34, Client_Share__c = 65,
        FAF_ID__c = FAFObj.Id,
        Tier__c = 4,
        Network_Operations__c = NetworkOps.Id
            );
            
        insert TransactionFee4; 
    
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
        try{
            Transaction_Fee_Sharing_Tier__c TransactionFee1 = new Transaction_Fee_Sharing_Tier__c(
            From__c = 10,
            To__c = 19, Client_Share__c = 55,
            FAF_ID__c = FAFObj.Id,
            Tier__c = 9,
            Network_Operations__c = NetworkOps.Id
            );
            
            insert TransactionFee1; 
            Transaction_Fee_Sharing_Tier__c TransactionFee2 = new Transaction_Fee_Sharing_Tier__c(
            From__c = 20,
            To__c = 30, Client_Share__c = 65,
            FAF_ID__c = FAFObj.Id,
            Tier__c = 2,
            Network_Operations__c = NetworkOps.Id
            );
        insert TransactionFee2; 
        }  catch(Exception e){
        } 
    }
   static testMethod void validateTransaction2() {
           
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
        try{
            Transaction_Fee_Sharing_Tier__c TransactionFee1 = new Transaction_Fee_Sharing_Tier__c(
            From__c = 10,
            To__c = 19, Client_Share__c = 55,
            FAF_ID__c = FAFObj.Id,
            Tier__c = 1,
            Network_Operations__c = NetworkOps.Id
                );
            insert TransactionFee1; 
            
            Transaction_Fee_Sharing_Tier__c TransactionFee2 = new Transaction_Fee_Sharing_Tier__c(
            From__c = 10,
            To__c = 30, Client_Share__c = 65,
            FAF_ID__c = FAFObj.Id,
            Tier__c = 2,
            Network_Operations__c = NetworkOps.Id
                );
            insert TransactionFee2;   
        }catch(Exception e){
        }
    } 
 }