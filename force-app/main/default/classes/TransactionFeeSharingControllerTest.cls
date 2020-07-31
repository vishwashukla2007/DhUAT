@isTest
public class TransactionFeeSharingControllerTest {
    static testmethod void validateTransaction(){
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
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On', 
        Transaction_Fee_Sharing__c = 'Yes', Type__c = 'Not Tiered',
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,
        To__c = 19, Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
     
        
        ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
    
    static testmethod void validateTransaction1(){
        
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
        
    
        //ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees10);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
    
     static testmethod void validateTransaction2(){
        
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
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees = new Transaction_Fee_Sharing_Tier__c(
        From__c = 100,To__c = 19,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        
        ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
      static testmethod void validateTransaction3(){
        
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
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees = new Transaction_Fee_Sharing_Tier__c(
        From__c = 100,To__c = 19,Tier__c=1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        Transaction_Fee_Sharing_Tier__c TransactionFees1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 23,To__c = 124,Tier__c=1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees1;
        //TransactionFees.To__c = null;
        
        ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
      static testmethod void validateTransaction4(){
        
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
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees0 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 60,To__c = 89,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees0;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees = new Transaction_Fee_Sharing_Tier__c(
        From__c = 90,To__c = 101,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees2 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 18,To__c = 16,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
      
        //ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees2);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
    
     static testmethod void validateTransaction5(){
        
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
        From__c = 10,To__c = 19, Tier__c =1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        Transaction_Fee_Sharing_Tier__c TransactionFees1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 20,To__c = 39,Tier__c =2,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees1;
        Transaction_Fee_Sharing_Tier__c TransactionFees2 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 40,To__c = 59, Tier__c =3,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees2;
        Transaction_Fee_Sharing_Tier__c TransactionFees3 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 60,To__c = 79, Tier__c =4,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees3;
        Transaction_Fee_Sharing_Tier__c TransactionFees4 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 80,To__c = 89, Tier__c =5,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees4;
        Transaction_Fee_Sharing_Tier__c TransactionFees5 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 90,To__c = 99,Tier__c =6,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees5;
        Transaction_Fee_Sharing_Tier__c TransactionFees6 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 100,To__c = 109,Tier__c =7,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees6;
       Transaction_Fee_Sharing_Tier__c TransactionFees7 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 110,To__c = 119,Tier__c =8,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees7;
        Transaction_Fee_Sharing_Tier__c TransactionFees8 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 120,Tier__c =9,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
       // insert TransactionFees8;
        
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
        
    
       // ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees8);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
    
    
    static testmethod void validationsTest(){
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
        From__c = 10,To__c = null, Tier__c =1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        
        Transaction_Fee_Sharing_Tier__c newTransactionFeeShareTier = new Transaction_Fee_Sharing_Tier__c();
        newTransactionFeeShareTier.Network_Operations__c = NetworkOps.Id;
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(newTransactionFeeShareTier);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        //TransactionFeeSharingHandler newTransaction1 = new TransactionFeeSharingHandler(TransactionSC);
    }
    
    static testmethod void validationToTest(){
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
        From__c = 10,To__c = 15, Tier__c =1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        
        Transaction_Fee_Sharing_Tier__c newTransactionFeeShareTier = new Transaction_Fee_Sharing_Tier__c();
        newTransactionFeeShareTier.Network_Operations__c = NetworkOps.Id;
        newTransactionFeeShareTier.From__c = 13;
        newTransactionFeeShareTier.Tier__c = 2;
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(newTransactionFeeShareTier);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        newTransaction.saveTransactionFeeSharing();
        
    }
        
    static testmethod void validateTransaction6(){
        
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
        From__c = 10,To__c = 5, Tier__c =1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
       
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        
        newTransaction.saveTransactionFeeSharing();
       
    } 
    
    static testmethod void validateTransaction9(){
        
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
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,To__c = 19,Tier__c=1,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        insert TransactionFees;
        Transaction_Fee_Sharing_Tier__c TransactionFees1 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 20,To__c = 30,Tier__c=2,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        Insert TransactionFees1;
        
        Transaction_Fee_Sharing_Tier__c TransactionFees2 = new Transaction_Fee_Sharing_Tier__c(
        From__c = 31,To__c = 40,Tier__c = 3,
        Client_Share__c = 55,
        FAF_ID__c = FAFObj.Id,
        Network_Operations__c = NetworkOps.Id);
        Insert TransactionFees2;
        // TransactionFees.To__c = null;
        
        //ApexPages.currentPage().getParameters().put('id', TransactionFees.Id);
        ApexPages.StandardController TransactionSC = new ApexPages.StandardController(TransactionFees1);
        TransactionFeeSharingController newTransaction = new TransactionFeeSharingController(TransactionSC);
        newTransaction.TransactionFee.From__c = 11;
        newTransaction.TransactionFee.To__c = 11;
        newTransaction.saveTransactionFeeSharing();
        newTransaction.TransactionFee.To__c = null;
        newTransaction.saveTransactionFeeSharing();
        newTransaction.TransactionFee.To__c = 30;   
        newTransaction.TransactionFee.From__c = 20;
        newTransaction.TransactionFee.FAF_ID__c = null;
        newTransaction.saveTransactionFeeSharing();
    } 
 }