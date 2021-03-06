@isTest
public class pbmRequestWrapperTest {
	@testSetup 
    static void dataSetup() {
        //Create users
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
        
        //Create Account
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = '';
        //accObj.iUMS_Client_Subtype__c = 'Health Plan Member';
        update accObj;
        
        //Create Opportunity
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        //Create FAF
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        
        //Create Client Info
        Client_Information__c clientInfoObj = TestDataFactory.createClientInfo(fafObj.id);
        clientInfoObj.Master_Client_Name__c = accObj.id;
        clientInfoObj.Contract_Effective_Date__c = null;
        clientInfoObj.Contract_End_Date__c = null;
        insert clientInfoObj;
        
        //Create billing ops
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(fafObj.id);
        billOpsObj.Claim_Billing__c = null;
        billOpsObj.Admin_Fee_Billing__c = null;
        insert billOpsObj;
        
        //Create Rebate Info
        Rebate_Operations__c rebateOpsObj = TestDataFactory.createRebOps(fafObj.id);
        rebateOpsObj.Pass_MAF__c = false;
        rebateOpsObj.Non_Specialty_Formulary_Option__c = null;
        rebateOpsObj.Specialty_Formulary_Option__c = null;
        insert rebateOpsObj;
        
        //Create Legal info
        Legal_Information__c legalInfoObj = new Legal_Information__c();
        legalInfoObj.FAF_ID__c = fafObj.id;
        legalInfoObj.Days_Written_Notice_Before_Termination__c = '180';
        legalInfoObj.Frequency_1__c = 'Anytime';
        legalInfoObj.Term_Without_Cause__c = 'Yes';
        insert legalInfoObj;
        
        //Create Guarantee info
		Guarantees_Information__c guarantInfoObj = TestDataFactory.createGuaranteeInfo(fafObj.id);
        guarantInfoObj.Performance_Guarantee__c = true;
        insert guarantInfoObj;
                
        List<Apttus__APTS_Agreement__c> agreeementList = TestDataFactoryCLM.createAgreementData();
        For (Apttus__APTS_Agreement__c agreeement: agreeementList) {
            agreeement.PBM_FAF__c = fafObj.Id;
        }        
        insert agreeementList;
        
        PBS_Agreement_Extension__c agreementExtension = TestDataFactoryCLM.createAgreementExtension(agreeementList[0].Id);
        insert agreementExtension;
        
        //Create PBM Request        
        PBMRequest__c pbmReq = TestDataFactoryCLM.createpbmRequest();
        pbmReq.FAF__c = fafObj.id;
        pbmReq.Agreement__c = agreeementList[0].id;
        pbmReq.Request_Submitted__c = true;
        insert pbmReq;
                    
    }
	
    @isTest 
    static void pbmRequestWrapperTestMethod() {       
        Central_Hub__c fafObj = [SELECT Id, (SELECT id FROM PBMRequest__r LIMIT 1) FROM Central_Hub__c LIMIT 1];
        id fafId;
        id pbmReqId;
        if(fafObj != null){
            fafId = fafObj.id;
            list<PBMRequest__c> pbmReq = fafObj.PBMRequest__r;            
            pbmReqId = pbmReq.size() > 0 ? pbmReq[0].id : null;
        }        
        Test.startTest();
            pbmRequestWrapper.wrapperClass getWrapper = pbmRequestWrapper.getFAF(fafId);
        	pbmRequestWrapper.wrapperClass getWrapper1 = pbmRequestWrapper.getRequestInfo(pbmReqId);
        	pbmRequestWrapper.wrapperClass getWrapper2 = pbmRequestWrapper.submitRequest(fafId);
        	pbmRequestWrapper.wrapperClass getWrapper3 = pbmRequestWrapper.syncStatus(pbmReqId);
        	list<user> paralegalUser = pbmRequestWrapper.getUserByGroup('Paralegal');
        	list<user> attorneyUser = pbmRequestWrapper.getUserByGroup('Attorney');
        	pbmRequestWrapper.wrapperClass getWrapper4 = pbmRequestWrapper.createAgreement(fafId,attorneyUser[0].id,paralegalUser[0].id);         
        Test.stopTest();
    }
}