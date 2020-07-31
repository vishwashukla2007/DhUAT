@isTest
public class NetworkOperationsControllerTest {
  //Method 1
    static testmethod void validateNetworkoperations(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
       
        insert NetworkOps;
       
        ApexPages.currentPage().getParameters().put('id', NetworkOps.Id);
        ApexPages.StandardController NetworkOpsSC = new ApexPages.StandardController(NetworkOps);
        NetworkOperationController newNetworkOps = new NetworkOperationController(NetworkOpsSC);
        
        newNetworkOps.transmissionFee();
        newNetworkOps.deleteTransactionFee();
        newNetworkOps.saveNetworkOperations();
       // newNetworkOps.DaysSupplyAction();
        newNetworkOps.retailSelected();
        newNetworkOps.transactionFeeTypeNotTieredSelected();
        newNetworkOps.transactionFeeTypeNotTieredNotSelected();
        newNetworkOps.transactionFeeTypeNotTieredNotSelected1();
        Test.stopTest();
        
    } 
  
  //Method 2  
    static testmethod void validateNetworkoperations1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj1 = ClientTestRef.createFAF1(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj1;
        
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Transmission_Fee_Waived__c = false,
        Retail_90_Days_Supply_84__c = false,
        FAF_ID__c = FAFObj1.Id
            );
            
        Central_Hub__c FAFObj2 = ClientTestRef.createFAF2(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj2;
        
        Network_Operations__c NetworkOps2 = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On', Type__c = 'Tiered',
      
        Retail_90_Days_Supply_84__c = false, 
        FAF_ID__c = FAFObj2.Id
            );
    
    
    
        ApexPages.currentPage().getParameters().put('id', NetworkOps.Id);
        ApexPages.StandardController NetworkOpsSC = new ApexPages.StandardController(NetworkOps);
        NetworkOperationController newNetworkOps = new NetworkOperationController(NetworkOpsSC);
        
        newNetworkOps.transmissionFee();
        newNetworkOps.deleteTransactionFee();
        newNetworkOps.saveNetworkOperations();
       // newNetworkOps.DaysSupplyAction();
        newNetworkOps.retailSelected();
        newNetworkOps.transactionFeeTypeNotTieredSelected();
        newNetworkOps.transactionFeeTypeNotTieredNotSelected();
        newNetworkOps.transactionFeeTypeNotTieredNotSelected1();
        Test.stopTest();
        
    } 
   
//Method 3   

 static testmethod void validateNetworkoperations2(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj1 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj1;
        
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'MAC Prevails then Discount without U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Transaction_Fee_Sharing__c = 'Yes',  Type__c = 'Not Tiered' , Client_Share__c = 55,
        Transmission_Fee_Waived__c = false,
        FAF_ID__c = FAFObj1.Id);
        insert NetworkOps;
    
        Transaction_Fee_Sharing_Tier__c Transactions = new Transaction_Fee_Sharing_Tier__c(
        From__c = 10,
        To__c = 19, Client_Share__c = 55,
        FAF_ID__c = FAFObj1.Id,
        Network_Operations__c = NetworkOps.Id
            );
        insert Transactions;
        
       
        
        Network_Pricing__c netPrice = new Network_Pricing__c(
        Year__c = '1',
        LOB__c = 'RU' , Network_Name__c = 'Commercial National', Managed_Network_Type__c = 'N/A', Network_Type__c = 'Locked' , Brand_Basis__c = 'Standard Brand Discount' , 
        Brand_Rate__c = 45, Brand_Dispensing_Fee__c = 35, Generic_Dispensing_Fee__c = 67,  Non_MAC_Generic_Rate__c = 78,
        FAF_ID__c = FAFObj1.Id,
        FAF_Network_Ops__c = NetworkOps.Id
            );
      //  insert netPrice; 
      
        NetworkOps.client__c = 'No MAC with U&C';
        NetworkOps.Type__c = 'Not Tiered';
        NetworkOps.Client_Share__c = 55;
        update NetworkOps;
       
        delete Transactions;
        
        ApexPages.currentPage().getParameters().put('id', NetworkOps.Id);
        ApexPages.StandardController NetworkOpsSC = new ApexPages.StandardController(NetworkOps);
        NetworkOperationController newNetworkOps = new NetworkOperationController(NetworkOpsSC);
        
        newNetworkOps.transmissionFee();
        newNetworkOps.deleteTransactionFee();
        newNetworkOps.saveNetworkOperations();
      //  newNetworkOps.DaysSupplyAction();
        newNetworkOps.retailSelected();
        newNetworkOps.transactionFeeTypeNotTieredSelected();
        newNetworkOps.transactionFeeTypeNotTieredNotSelected();
        newNetworkOps.transactionFeeTypeNotTieredNotSelected1();
        Test.stopTest();
    } 
       static testmethod void validateNetworkoperations3(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj3 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj3;
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'Lower of MAC or Discount',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj3.Id);
        insert NetworkOps; 
        Network_Pricing__c netPrice = new Network_Pricing__c(
        Year__c = '1',
        LOB__c = 'RU' , Network_Name__c = 'Commercial National', Managed_Network_Type__c = 'N/A', Network_Type__c = 'Locked' , Brand_Basis__c = 'Standard Brand Discount' , 
        Brand_Rate__c = 45, Brand_Dispensing_Fee__c = 35, Generic_Dispensing_Fee__c = 67,  Non_MAC_Generic_Rate__c = 78,
        FAF_ID__c = FAFObj3.Id,
        FAF_Network_Ops__c = NetworkOps.Id
            );
    //    insert netPrice; 
       
        NetworkOps.client__c = 'No MAC with U&C';
        NetworkOps.Type__c = 'Not Tiered';
        NetworkOps.Client_Share__c = 55;
        update NetworkOps;
              
       
        
    } 
        static testmethod void validateNetworkoperations4(){        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj3 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj3;
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj3.Id);
        insert NetworkOps; 
        Network_Pricing__c netPrice = new Network_Pricing__c(
        Year__c = '1',
        LOB__c = 'RU' , Network_Name__c = 'Commercial National', Managed_Network_Type__c = 'N/A', Network_Type__c = 'Locked' , Brand_Basis__c = 'Standard Brand Discount' , 
        Brand_Rate__c = 45, Brand_Dispensing_Fee__c = 35, Generic_Dispensing_Fee__c = 67,  Non_MAC_Generic_Rate__c = 78,
        FAF_ID__c = FAFObj3.Id,
        FAF_Network_Ops__c = NetworkOps.Id
            );
     //   insert netPrice; 
       
        NetworkOps.client__c = 'Lower of MAC or Discount';
        NetworkOps.Type__c = 'Not Tiered';
        NetworkOps.Client_Share__c = 55;
        update NetworkOps;
        
     } 
     static testmethod void validateNetworkoperations7(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
        
        insert NetworkOps;
              
        List<Network_Operations__c> networkList = new List<Network_Operations__c>();
        networkList.add(NetworkOps);
        delete NetworkOps;
        FAFObj.FAF_Status__c='Implement';
        update FAFObj;
                   
        NetworkOperationsTriggerHelper.updateFAFOnDelete(networkList );
        Test.stopTest();
        
    } 
  
}