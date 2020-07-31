@isTest
public class IUMSDeleteObjectrecords12Test {
Static testmethod void IUMSDeleteObjectrecords8(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        FAFObj.FAF_Status__c='Uploaded';
        Update FAFObj;
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
         
        Clinical_Operations__c clOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        insert clOpsObj;
         
        Rebate_Operations__c rbOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        insert rbOpsObj;
        
        Network_Operations__c  npObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert npObj;
     
        IUMSDeleteObjectrecords12 obj = new IUMSDeleteObjectrecords12();
        obj.query = 'Select id from Central_Hub__c';
        DataBase.executeBatch(obj); 
       
        IUMSDeleteObjectrecords13 obj1 = new IUMSDeleteObjectrecords13();
        obj1.query = 'Select id from Central_Hub__c';
        DataBase.executeBatch(obj1); 
       
            
     }    
}