@isTest
public class Level1customLookUpControllerTest {
	
    @isTest
    public static void fetchLookUpValuesTest(){
        String CarrierId = '1234567890';
        String searchKeyWord ='1234';
        String ObjectName = null;
        String AccountId='ACC-Super Client';
        String Platform = 'Abc';
        String fafid= null;
        String lob = null;
        
        CAG__c cag = TestDataFactory.createCAG('C', 'abc');
        cag.Carrier_Id__c = '1234567890';
        cag.Carrier_Name__c = 'Non-Validated';
        cag.Status__c = 'A';
        cag.Record_Type__c = 'C';
        insert cag;
        
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='Super Client';
        acc.Client_ID__c = '1234567890';
        insert acc;
        
        Account acc1 = TestDataFactory.createAccount();
        acc1.Account_Level__c ='Level 1';
        acc1.Client_ID__c = '1234567890';
        acc1.ParentId = acc.Id;
        insert acc1;
        
        Level1customLookUpController.fetchLookUpValues(searchKeyWord, ObjectName, acc.Id, Platform);
        Level1customLookUpController.fetchLookUpValues(searchKeyWord, ObjectName, acc1.Id, Platform);
        Level1customLookUpController.fetchclearFilterValues(platform, lob, fafid, AccountId); 
        Level1customLookUpController.fetchclearFilterSearchValues(searchKeyWord, platform, lob, fafid, AccountId); 
        Level1customLookUpController.fetchinitialCValues(platform, lob, fafid, acc1.Id);
        Level1customLookUpController.fetchinitialCValues(platform, lob, fafid, acc.Id);
        Level1customLookUpController.fetchsearchkeyCValues(searchKeyWord, platform, lob, fafid, acc1.Id);
        Level1customLookUpController.fetchsearchkeyCValues(searchKeyWord, platform, lob, fafid, acc.Id);
    }
}