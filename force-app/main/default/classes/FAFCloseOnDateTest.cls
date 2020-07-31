/*********************************************************************************************
* @author   Sindhu Alati
* @date      07/15/2018
* @description:This is the testclass for the class FAFCloseOnDate   
 **********************************************************************************************/
@isTest
private class FAFCloseOnDateTest {
    
    @testSetup
    static void setup() {
        List<Central_Hub__c> fafList = new List<Central_Hub__c>();
        Central_Hub__c faf1 = new Central_Hub__c();
        faf1.FAF_Status__c = 'Draft';
        faf1.FAF_Close_On_Date__c = Date.today()-1;
        fafList.add(faf1);
        
        Central_Hub__c faf2 = new Central_Hub__c();
        faf2.FAF_Status__c = 'Draft';
        faf2.FAF_Close_On_Date__c = Date.today()-1;
        fafList.add(faf2);        
        
        insert fafList;
        Central_Hub__c faf1Rec = [SELECT Id, Client_Info__c FROM Central_Hub__c WHERE Id=:fafList[0].Id];
        Client_Information__c clientINFO= TestDataFactory.createClientInfo(faf1.id);
        //Client_Information__c ci = new Client_Information__c(Id=faf1Rec.Client_Info__c, Pricing_Effective_Date__c=Date.today()-1);
        insert clientINFO;
        Central_Hub__c ch = new Central_Hub__c(Id=fafList[0].Id, FAF_Status__c='Closed');
        update ch;
    }  
    
    static testMethod void test() {
        Test.startTest();
        FAFCloseOnDate fafBatch = new FAFCloseOnDate();
        Database.executeBatch(fafBatch);
        Test.stopTest();
    }
    
    static testmethod void testScheduledJob() {
        Test.startTest();
        String jobId = System.schedule('Schedule FAFCloseOnDate', '0 50 * * * ? *', new FAFCloseOnDate());
        Test.stopTest();
    }
}