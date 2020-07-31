/* =================================================================================
* @Class Name        : IUMSDeleteObjectrecords6Test
* @author            : Parvathi Chunduri (parvathi.chunduri@cvshealth.com)
* @created date      : 06/24/2020
* @Purpose           : Test coverage for IUMSDeleteObjectrecords6
=======================================================================================*/
@isTest
public class IUMSDeleteObjectrecords6Test {
    
    Static testmethod void IUMSDeleteObjectrecords6(){
        
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
        Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
        insert bilOpsObj;
        
        Broker_TPA_Name_Support__c  brokertpaName=TestDataFactoryForBilling.createBrokersupport();
                insert brokertpaName;
        Billing_Broker_TPA_Payments__c  billbrokerTPAObj = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,bilOpsObj.id,brokertpaName.id);
                                             
        //Billing_Broker_TPA_Payments__c bpObj = new Billing_Broker_TPA_Payments__c(Billing_Operations__c = bilOpsObj.id, Metric__c='%');
        insert billbrokerTPAObj;
        
        
        IUMSDeleteObjectrecords6 obj = new IUMSDeleteObjectrecords6();
        obj.query = 'Select id from Central_Hub__c';
        DataBase.executeBatch(obj); 
      
    }

}