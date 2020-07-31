@isTest
public class Level2customLookUpControllerTest {
    
    @isTest
    public static void fetchLookUpValuesTest(){
        String CarrierId = '1234567890';
        String searchKeyWord ='1234';
        String ObjectName = null;
        String AccountId=null;
        String Platform = 'Abc';
        String fafid= null;
        String lob = null;
        String Carrier = '1234567890';
        
        User u  = TestDataFactory.createUser('System Administrator');
        //Insert u;
        
  
        
        CAG__c cag = TestDataFactory.createCAG('C', 'Abc');
        cag.Carrier_Id__c = '1234';
        cag.CAG_ID__c = '1234Abc';
        cag.Platform_Name__c = 'Abc';
        cag.Carrier_Name__c = 'Non-Validated';
        cag.Status__c = 'A';
        cag.Record_Type__c = 'C';
        insert cag;
        
        CAG__c cag1 = TestDataFactory.createCAG('A', 'Abc');
        cag1.Carrier_Id__c = '1234';
        cag1.CAG_ID__c = '12341234567890Abc';
        cag1.Platform_Name__c = 'Abc';
        cag1.Account_Id__c = '1234567890';
        cag1.Carrier_Name__c = 'Non-Validated';
        cag1.Status__c = 'A';
        cag1.Record_Type__c = 'A';
        insert cag1;
        
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.Client_ID__c = '1234';
        insert acc;
        
        Account acc1 = TestDataFactory.createAccount();
        acc1.Account_Level__c = 'Level 1';
        acc1.ParentId = acc.Id;
        acc1.Client_ID__c = '1234';
        
        insert acc1;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc1.Id);
        Insert opp;
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc1.Id,opp.Id, u.Id);
        Insert FAF;
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        Insert ClientInformation;
        
        
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecifics();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Level_1_Record_ID__c=cag.id;
        ps.Level_2_record_ID__c=cag1.id;
       // insert ps;
        
        
       
        Level2customLookUpController.fetchLookUpValues(searchKeyWord, ObjectName, Platform, Carrier);
        
        Level2customLookUpController.fetchinitialCValues(platform, Carrier);
        Level2customLookUpController.fetchsearchkeyCValues(searchKeyWord, platform, Carrier);
        //Level2customLookUpController.UpdatePlatformSpecAccountID(ps.Id,acc.Id, platform);
 
    }
}