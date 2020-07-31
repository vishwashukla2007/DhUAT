@isTest
private class Level3customLookUpController_Test {
    @isTest
    private static void testfetchLookUpValues() {
        Account acc=   CAGTestClassRecords.createAccount();
        insert acc;
        CAG__c cag=  CAGTestClassRecords.createCAGG(acc.id);
        cag.Status__c='A';
        cag.Platform_Name__c='Test';
        insert cag;
        
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('System Administrator');

        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id, u.Id);
        Insert FAF;
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        Insert ClientInformation;
        
        
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecifics();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Level_1_Record_ID__c=cag.id;
     //   insert ps;
        Level3customLookUpController.fetchLookUpValues('GP1234567', 'AC123456', 'CA12345', 'Test');
        Level3customLookUpController.fetchinitialCValues('AC123456', 'CA12345', 'Test');
        Level3customLookUpController.fetchsearchkeyCValues('GP1234567', 'AC123456', 'CA12345', 'Test');
       // Level3customLookUpController.UpdatePlatformSpecGroupID(ps.Id,acc.Id, 'Test');
     
    }
    

}