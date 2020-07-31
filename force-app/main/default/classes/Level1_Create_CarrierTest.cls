@isTest
public class Level1_Create_CarrierTest {
	
    @isTest
    public static void createCarrierTest(){
        String CarrierId = '1234567890';
        String Platform = 'abc';
        String Platform1 = 'abc1';
        String Lob = null;
        String AccountId = null;
        String GroupId = null;
        String Recordtype= 'C';
        String PAccountId = null;
        Test.startTest();
        Level1_Create_Carrier.createCarrier(CarrierId, Platform, Lob, AccountId, GroupId, Recordtype, PAccountId);
        
        CAG__c cag = TestDataFactory.createCAG('C', 'abc');
        insert cag;
        List<Account> accList = new List<Account>();
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        insert acc;
        
        Account acc1 = TestDataFactory.createAccount();
        acc1.Account_Level__c = 'Level 1';
        acc1.ParentId = acc.Id;
        
        insert acc1;
        
        
        Level1_Create_Carrier.createCarrier(CarrierId, Platform, Lob, acc1.Id, GroupId, Recordtype, acc.Id);
        Test.stopTest();
    }
}