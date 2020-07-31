@isTest
public class IUMS_FAF_Delete_ReParentbatchTest {
    
    static testmethod void IUMS_FAF_Delete_ReParentbatch(){
        
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
        
        Central_Hub__c FAFObj2 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj2;
        
        /*Central_Hub__c FAFObj3 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj3;*/
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
   
        Test.startTest();
        List<Clinical_Operations__c> co = new List<Clinical_Operations__c>();        
        Clinical_Operations__c clOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        co.add(clOpsObj);
        
        //Clinical_Operations__c clOpsObj2 = TestDataFactory.createGClinicalOperaiton(FAFObj2.id);
        //co.add(clOpsObj2);
        insert co;
        
        List<Rebate_Operations__c> ro = new List<Rebate_Operations__c>(); 
        Rebate_Operations__c roOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        ro.add(roOpsObj);
        
        Rebate_Operations__c roOpsObj2 = TestDataFactory.createRebOps(FAFObj2.id);
        ro.add(roOpsObj2);
        insert ro;
        
        List<Network_Operations__c> no = new List<Network_Operations__c>();
        Network_Operations__c  noObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        no.add(noObj);
        
        Network_Operations__c  noObj2 = TestDataFactory.createNetworkOperation(FAFObj2.id);
        no.add(noObj2);
        insert no;
        
        Mail_Operations__c moOBJ = TestDataFactory.createMailOperation(FAFObj.id);
        insert moObj;
        
        //Mail_Operations__c moOBJ2 = TestDataFactory.createMailOperation(FAFObj2.id);
        //insert moObj2;
        
        Specialty_Operations__c soObj = TestDataFactory.createSpeciality(FAFObj.id);
        insert soObj;
        
        Specialty_Operations__c soObj2 = TestDataFactory.createSpeciality(FAFObj2.id);
        insert soObj2;
        
        Billing_Operations__c boObj = TestDataFactory.createBillOps(FAFObj.id);
        insert boObj;
        
        //Billing_Operations__c boObj2 = TestDataFactory.createBillOps(FAFObj2.id);
        //insert boObj2;
       
      //  List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
        
        Network_Pricing__c np = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        np.IUMS_Upload__c = false;
        insert np;   
              
        Mail_Pricing__c mp = TestDataFactory.createmailPricing(FAFObj.id,moOBJ.id);
        mp.LOB__c = 'ACT';
        mp.IUMS_Upload__c = true;
        insert mp;
       
        
        Specialty_Pricing__c spObj = TestDataFactory.createspecPricingObject(FAFObj.id,soObj.id);
        spObj.IUMS_Upload__c = false;
        insert spObj;
        
        
        Rebate_Guarantees__c rbObj = TestDataFactory.createRebateGuarantee(FAFObj.id,roOpsObj.id);
        rbObj.IUMS_Upload__c = true;
        insert rbObj;
        
        /*Rebate_Guarantees__c rbObj2 = TestDataFactory.createRebateGuarantee(FAFObj2.id,roOpsObj2.id);
        rbObj2.IUMS_Upload__c = false;
        insert rbObj2;*/
        
        Billing_Administrative_Fees__c baObj = TestDataFactory.createBillAdminFees(FAFObj.id,boObj.id);
        baObj.IUMS_Upload__c = true;
        insert baObj;
        
        Clinical_Solutions__c clObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clOpsObj.id);
        clObj.IUMS_Upload__c = true;
        insert clObj;
       
                
        
        IUMS_FAF_Delete_ReParentbatch obj = new IUMS_FAF_Delete_ReParentbatch();
        obj.query = 'Select id from Central_Hub__c';
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
    
    static testmethod void IUMS_FAF_Delete_ReParentbatch2(){
        
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
        
        Central_Hub__c FAFObj2 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj2;
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
   
        Test.startTest();
        
        
        Mail_Operations__c moOBJ = TestDataFactory.createMailOperation(FAFObj.id);
        insert moObj;
        
        Mail_Operations__c moOBJ2 = TestDataFactory.createMailOperation(FAFObj2.id);
        insert moObj2;
        
        Mail_Pricing__c mp = TestDataFactory.createmailPricing(FAFObj.id,moOBJ.id);
        mp.IUMS_Upload__c = false;
        insert mp;
       
                
        
        IUMS_FAF_Delete_ReParentbatch obj = new IUMS_FAF_Delete_ReParentbatch();
        obj.query = 'Select id from Central_Hub__c';
        try{
        //DataBase.executeBatch(obj);
        obj.execute(null, [Select id from Central_Hub__c]);
        }catch(exception e){ System.debug('exception');}
        Test.stopTest();
    }
    
    static testmethod void IUMS_FAF_Delete_ReParentbatch3(){
        
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
        
        Central_Hub__c FAFObj2 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj2;
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
   
        Test.startTest();
        List<Clinical_Operations__c> co = new List<Clinical_Operations__c>();        
        Clinical_Operations__c clOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        co.add(clOpsObj);
        
        Clinical_Operations__c clOpsObj2 = TestDataFactory.createGClinicalOperaiton(FAFObj2.id);
        co.add(clOpsObj2);
        insert co;
        
        
        Clinical_Solutions__c clObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clOpsObj.id);
        clObj.IUMS_Upload__c = false;
        insert clObj;
       
                
        
        IUMS_FAF_Delete_ReParentbatch obj = new IUMS_FAF_Delete_ReParentbatch();
        obj.query = 'Select id from Central_Hub__c';
        //DataBase.executeBatch(obj);
        try{
        //DataBase.executeBatch(obj);
        obj.execute(null, [Select id from Central_Hub__c]);
        }catch(exception e){ System.debug('exception');}
        Test.stopTest();
    }
    
    static testmethod void IUMS_FAF_Delete_ReParentbatch4(){
        
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
        
        Central_Hub__c FAFObj2 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj2;
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
   
        Test.startTest();
        
        List<Rebate_Operations__c> ro = new List<Rebate_Operations__c>(); 
        Rebate_Operations__c roOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        ro.add(roOpsObj);
        
        Rebate_Operations__c roOpsObj2 = TestDataFactory.createRebOps(FAFObj2.id);
        ro.add(roOpsObj2);
        insert ro;
       
  
        
        
        Rebate_Guarantees__c rbObj = TestDataFactory.createRebateGuarantee(FAFObj.id,roOpsObj.id);
        rbObj.IUMS_Upload__c = false;
        insert rbObj;
       
                
        
        IUMS_FAF_Delete_ReParentbatch obj = new IUMS_FAF_Delete_ReParentbatch();
        obj.query = 'Select id from Central_Hub__c';
        //DataBase.executeBatch(obj);
        try{
        //DataBase.executeBatch(obj);
        obj.execute(null, [Select id from Central_Hub__c]);
        }catch(exception e){ System.debug('exception');}
        Test.stopTest();
    }
    
    static testmethod void IUMS_FAF_Delete_ReParentbatch5(){
        
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
        
        Central_Hub__c FAFObj2 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj2;
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
   
        Test.startTest();
        
        Billing_Operations__c boObj = TestDataFactory.createBillOps(FAFObj.id);
        insert boObj;
        
        Billing_Operations__c boObj2 = TestDataFactory.createBillOps(FAFObj2.id);
        insert boObj2;
        
        
        Billing_Administrative_Fees__c baObj = TestDataFactory.createBillAdminFees(FAFObj.id,boObj.id);
        baObj.IUMS_Upload__c = false;
        insert baObj;
       
                
        
        IUMS_FAF_Delete_ReParentbatch obj = new IUMS_FAF_Delete_ReParentbatch();
        obj.query = 'Select id from Central_Hub__c';
        //DataBase.executeBatch(obj);
        try{
        //DataBase.executeBatch(obj);
        obj.execute(null, [Select id from Central_Hub__c]);
        }catch(exception e){ System.debug('exception');}
        Test.stopTest();
    }
}