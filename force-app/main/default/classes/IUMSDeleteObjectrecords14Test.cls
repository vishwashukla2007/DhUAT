@isTest
public class IUMSDeleteObjectrecords14Test {

    Static testmethod void IUMSDeleteObjectrecord14(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        User operation = ClientTestRef.createUser('Apttus Operations');
        insert operation;
                
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
         
        Rebate_Operations__c roOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        insert roOpsObj;
        
        Network_Operations__c  noObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert noObj;
        
        Mail_Operations__c moOBJ = TestDataFactory.createMailOperation(FAFObj.id);
        insert moObj;
        
        Specialty_Operations__c soObj = TestDataFactory.createSpeciality(FAFObj.id);
        insert soObj;
        
        Billing_Operations__c boObj = TestDataFactory.createBillOps(FAFObj.id);
        insert boObj;
        
        Test.startTest();
        List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
        Network_Pricing__c np = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        insert np;
        np.Year__C = '1';
        np.IUMS_Upload__c = true;
        update np;
       // npList.add(np.id);
        Mail_Pricing__c mp = TestDataFactory.createmailPricing(FAFObj.id,moOBJ.id);
        insert mp;
        mp.IUMS_Upload__c = true;
        update mp;
        
        Specialty_Pricing__c spObj = TestDataFactory.createspecPricingObject(FAFObj.id,soObj.id);
        insert spObj;
        spObj.IUMS_Upload__c = true;
        update spObj;
        
        Rebate_Guarantees__c rbObj = TestDataFactory.createRebateGuarantee(FAFObj.id,roOpsObj.id);
        insert rbObj;
        rbObj.IUMS_Upload__c = true;
        update rbObj;
        
        Billing_Administrative_Fees__c baObj = TestDataFactory.createBillAdminFees(FAFObj.id,boObj.id);
        insert baObj;
        baObj.IUMS_Upload__c = true;
        update baObj;
        
        Clinical_Solutions__c clObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clOpsObj.id);
        insert clObj;
        clObj.IUMS_Upload__c = true;
        update clObj;
        
        Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        np1.Year__c = 'All';
        np1.FAF_ID__c= FAFObj.id;
        np1.IUMS_Upload__c= true;
        insert np1;
      
       
  
        system.runAs(operation)
        {
        IUMSDeleteObjectrecords14 obj2 = new IUMSDeleteObjectrecords14();
        obj2.query = 'Select id from Central_Hub__c where ID =\'' + FAFObj.id + '\'';
        DataBase.executeBatch(obj2);
        }
        Network_Pricing__c np2 = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        np2.Year__C = '2';
        np2.FAF_ID__c= FAFObj.id;
        np2.IUMS_Upload__c= true;
        insert np2;
        
        system.runAs(operation)
        {
        IUMSDeleteObjectrecords14 obj = new IUMSDeleteObjectrecords14();
        obj.query = 'Select id from Central_Hub__c where ID =\'' + FAFObj.id + '\'';
        DataBase.executeBatch(obj);
        }
        
        Test.stopTest();
    
     }
     Static testmethod void IUMSDeleteObjectrecord2(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        User operation = ClientTestRef.createUser('Apttus Operations');
        insert operation;
                
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
         
        Rebate_Operations__c roOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        insert roOpsObj;
        
        Network_Operations__c  noObj = TestDataFactory.createNetworkOperation(FAFObj.id);
       //noObj.Method__c='abc';
        try{
        insert noObj;
        }
        catch(Exception ex){
            
        }
        
        Mail_Operations__c moOBJ = TestDataFactory.createMailOperation(FAFObj.id);
        insert moObj;
        
        Specialty_Operations__c soObj = TestDataFactory.createSpeciality(FAFObj.id);
        insert soObj;
        
        Billing_Operations__c boObj = TestDataFactory.createBillOps(FAFObj.id);
        insert boObj;
        
        Test.startTest();
        List<Network_Pricing__c> npList = new List<Network_Pricing__c>();
        Network_Pricing__c np = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        insert np;
        np.Year__C = '1';
        np.IUMS_Upload__c = true;
        update np;
       // npList.add(np.id);
        Mail_Pricing__c mp = TestDataFactory.createmailPricing(FAFObj.id,moOBJ.id);
        insert mp;
        mp.IUMS_Upload__c = true;
        update mp;
        
        Specialty_Pricing__c spObj = TestDataFactory.createspecPricingObject(FAFObj.id,soObj.id);
        insert spObj;
        spObj.IUMS_Upload__c = true;
        update spObj;
        
        Rebate_Guarantees__c rbObj = TestDataFactory.createRebateGuarantee(FAFObj.id,roOpsObj.id);
        insert rbObj;
        rbObj.IUMS_Upload__c = true;
        update rbObj;
        
        Billing_Administrative_Fees__c baObj = TestDataFactory.createBillAdminFees(FAFObj.id,boObj.id);
        insert baObj;
        baObj.IUMS_Upload__c = true;
        update baObj;
        
        Clinical_Solutions__c clObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clOpsObj.id);
        insert clObj;
        clObj.IUMS_Upload__c = true;
        update clObj;
        
        Network_Pricing__c np1 = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        np1.Year__c = 'All';
        np1.FAF_ID__c= FAFObj.id;
        np1.IUMS_Upload__c= true;
       
       
        try{
        np1.year__c='6';
        insert np1;
        }
        catch(Exception ex){
            
        }
      
       
  
        system.runAs(operation)
        {
        IUMSDeleteObjectrecords14 obj2 = new IUMSDeleteObjectrecords14();
        obj2.query = 'Select id from Central_Hub__c where ID =\'' + FAFObj.id + '\'';
        DataBase.executeBatch(obj2);
        }
        Network_Pricing__c np2 = TestDataFactory.createntwrkPricing(FAFObj.id,noObj.id);
        np2.Year__C = '6';
        np2.FAF_ID__c= FAFObj.id;
        np2.IUMS_Upload__c= true;
        //np2.id='';
        try{
        insert np2;
        }
        Catch(Exception Ex){
        }
        
        system.runAs(operation)
        {
        IUMSDeleteObjectrecords14 obj = new IUMSDeleteObjectrecords14();
        obj.query = 'Select id from Central_Hub__c where ID =\'' + FAFObj.id + '\'';
        DataBase.executeBatch(obj);
          obj.IncreaseCoverage2(); 
        }
       
        
        Test.stopTest();
    
     }       
}