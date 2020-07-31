/*=================================================================================================================================
     * @Method Name       : getInstanceURLTest
     * @author            : John Paul Revilla
     * @Last modified by  : John Paul Revilla
     * @Last modified date: 04/07/2020
     * @Purpose           : test class for getInstanceUrl class
    ==================================================================================================================================*/
@isTest
public with sharing class getInstanceURLTest {
    //Setup reusable data which would be used by the test methods below 
    @testSetup 
    static void dataSetup() {
		Account accObj =  ClientTestRef.createAccount();
        insert accObj;
    }
    //Assert if return is not null
    @isTest 
    static void getInstanceURLTest() {
		Test.startTest();
        String instanceUrl = getInstanceURL.getInstanceURL();
        system.assert(instanceUrl != null);
        Test.stopTest();
    }

    //Asserts if the return data is correct value
    @isTest 
    static void checkObjectTypeTest() {
        Test.startTest();
        list<Account> acctList = [Select Id from Account limit 1];
        list<Id> idList = new List<Id>();
        idList.add(acctList[0].id);


        list<String> objectList = getInstanceURL.checkObjectType(idList);
        system.assertEquals('Account', objectList[0]);
        Test.stopTest();
    }
}