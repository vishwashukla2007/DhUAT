@isTest
private class Level3_Create_Carrier_Test {
    @isTest
    private static void testcreateCarrier() {
        Account acc=   CAGTestClassRecords.createAccount();
        insert acc;
        CAG__c cag=  CAGTestClassRecords.createCAGG(acc.id);
        cag.Status__c='A';
        cag.Platform_Name__c='Test';
        insert cag;
        
        Level3_Create_Carrier.createCarrier('CA12345', 'CATESTNAME', 'Test', 'AC123456', 'G', 'ACTESTNAME', 'GP1234567');
        Level3_Create_Carrier.createCarrier('CA12345', 'CATESTNAME', 'Test1', 'AC123456', 'G', 'ACTESTNAME', 'GP1234567');
        Level3_Create_Carrier.createCarrier('CA12345', 'CATESTNAME', 'Test1', 'AC123456', 'A', 'ACTESTNAME', 'GP1234567');
        Level3_Create_Carrier.createCarrier('CA12345', 'CATESTNAME', 'Test1', null, 'A', 'ACTESTNAME', 'GP1234567');
        
    }
    
}