@isTest
public class Level2_Create_CarrierTest {
	
    @isTest
    public static void createCarrierTest(){
        String CarrierId = '1234567890';
        String Platform = 'abc';
        String Platform1 = 'abc1';
        String Lob = null;
        String AccountId = null;
        String GroupId = null;
        String Recordtype= 'A';
        String PAccountId = '1234567890Account';
        Test.startTest();
        Level2_Create_Carrier.createCarrier(CarrierId, Platform, Lob, PAccountId, GroupId, Recordtype);
        //createCarrier(String CarrierId, String Platform, String Lob, String AccountId, String GroupId, String Recordtype)
        CAG__c cag = TestDataFactory.createCAG('A', 'abc');
        insert cag;
        List<Account> accList = new List<Account>();
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        insert acc;
        
        Account acc1 = TestDataFactory.createAccount();
        acc1.Account_Level__c = 'Level 1';
        acc1.ParentId = acc.Id;
        
        insert acc1;
        
        
        Level2_Create_Carrier.createCarrier(CarrierId, Platform, Lob, PAccountId, GroupId, Recordtype);
        Test.stopTest();
    }
}