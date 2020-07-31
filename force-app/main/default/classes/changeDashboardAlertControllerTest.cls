@isTest 
public class changeDashboardAlertControllerTest {
	@testSetup 
    static void dataSetup() {
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = userInfo.getUserName();
        salesperson.Manager_Level_3__c = userInfo.getUserName();
        salesperson.Manager_Level_4__c = userInfo.getUserName();
        salesperson.Manager_Level_5__c = userInfo.getUserName();
        salesperson.ManagerId = userInfo.getUserId();
        update salesperson;
        
        User paralegal = ClientTestRef.createUser('Apttus Operations');
        paralegal.User_Grouping__c = 'Paralegal';
        insert paralegal;
        
        User atty = ClientTestRef.createUser('Apttus Operations');
        atty.User_Grouping__c = 'Attorney';
        insert atty;
        
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        Client_Information__c clientInfoObj = TestDataFactory.createClientInfo(fafObj.id); 
        insert clientInfoObj;
        Rebate_Operations__c rebateOpsObj = TestDataFactory.createRebOps(fafObj.id);
        rebateOpsObj.Pass_MAF__c = false;
        insert rebateOpsObj;
        List<Apttus__APTS_Agreement__c> agreementList = TestDataFactoryCLM.createAgreementData();
        For (Apttus__APTS_Agreement__c agreement: agreementList) {
            agreement.PBM_FAF__c = fafObj.Id;
            agreement.Attorney__c = atty.id;
            agreement.Paralegal__c = paralegal.id;
            agreement.Name = 'test agreement for batch job test class';
            agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
        }
        insert agreementList;
        PBS_Agreement_Extension__c agreementExtension = TestDataFactoryCLM.createAgreementExtension(agreementList[0].Id);
        agreementExtension.Pass_MAF__c = true;
        insert agreementExtension;
        
        changeDashboardFields__c instCustomSetting = new changeDashboardFields__c();
        instCustomSetting.Name = 'Pass_MAF__c';
        instCustomSetting.Active__c = true;
        instCustomSetting.AgreementExt_Field_API__c = 'Pass_MAF__c';
        instCustomSetting.FAF_object_API_Name__c = 'Rebate_Operations__r';
        instCustomSetting.Field_Label__c = 'Pass MAF';
        instCustomSetting.Field_Type__c = 'Checkbox';
        insert instCustomSetting;
        
       
    }
    
    @isTest 
    static void changeDashboardAlertBatchTestMethod() {
        Apttus__APTS_Agreement__c ag = [SELECT id FROM Apttus__APTS_Agreement__c LIMIT 1];
        Test.startTest(); 
        	id result = changeDashboardAlertController.runJob(null);
        	id result2 = changeDashboardAlertController.runJob(ag.id);
        Test.stopTest();
     
    }
}