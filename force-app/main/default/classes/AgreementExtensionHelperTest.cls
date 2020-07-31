@isTest
public class AgreementExtensionHelperTest {
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
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        
        //Create Opportunity
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        //Create FAF
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fafObj.Business_Type__c = 'New';
        insert fafObj;
        
        //Create billing ops
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(fafObj.id);
        insert billOpsObj;
        
        list<Billing_Operations__c> billlist = fafObj.Billing_Ops__r;

        //Create Billing Other Payments record            
        Contractual_Payments__c billOthrPayObj = TestDataFactory.createBillOthrPaymnts(fafObj.id,billOpsObj.id);
        billOthrPayObj.Type__c = 'Audit Allowance';
        insert billOthrPayObj;
        
        List<Apttus__APTS_Agreement__c> agreeementList = TestDataFactoryCLM.createAgreementData();
        insert agreeementList;
        
        PBS_Agreement_Extension__c agreementExtension = TestDataFactoryCLM.createAgreementExtension(agreeementList[0].Id);
        agreementExtension.Specialty_Rebates__c = 'Do Not Pass to Client';
        agreementExtension.Pharmacy_Audit_Retention__c = 'Base (80/20)';
        agreementExtension.Pass_MAF__c = false;
        agreementExtension.Rebate_RTMD__c = true;
        agreementExtension.CVS_Share__c = 10;
        agreementExtension.Performance_Guarantee__c = true;
        agreementExtension.Appeals__c = true;
        agreementExtension.Maintenance_choice__c = true;
        agreementExtension.Medicare_Subsidy__c = true;
        agreementExtension.Preventive_Care_Drug_Program__c = true;
        agreementExtension.Vaccine_service__c = true;
        agreementExtension.Transform_Diabetic_care_program__c = true;
        agreementExtension.FAF_ID__c = fafObj.id;
        agreementExtension.Client_Name__c = 'test1';
        insert agreementExtension;
        
        PBS_Agreement_Extension__c agreementExtension2 = TestDataFactoryCLM.createAgreementExtension(agreeementList[0].Id);
        agreementExtension2.Specialty_Rebates__c = 'Do Not Pass to Client';
        agreementExtension2.Pharmacy_Audit_Retention__c = 'Base (80/20)';
        agreementExtension2.Pass_MAF__c = false;
        agreementExtension2.Rebate_RTMD__c = false;
        agreementExtension2.CVS_Share__c = 10;
        agreementExtension2.Performance_Guarantee__c = true;
        agreementExtension2.Appeals__c = true;
        agreementExtension2.Maintenance_choice__c = true;
        agreementExtension2.Medicare_Subsidy__c = true;
        agreementExtension2.Preventive_Care_Drug_Program__c = true;
        agreementExtension2.Vaccine_service__c = true;
        agreementExtension2.Transform_Diabetic_care_program__c = true;
        agreementExtension2.FAF_ID__c = fafObj.id;
        agreementExtension2.Client_Name__c = 'test2';
        insert agreementExtension2;
    }
    
    @isTest 
    static void updateAgreementExt() {
        Test.startTest();
        	//map<id,PBS_Agreement_Extension__c> oldAgreementExtList = new map<id,PBS_Agreement_Extension__c>([SELECT id, Pass_MAF__c, Rebate_RTMD__c, Pharmacy_Audit_Retention__c,
            //                                               Rebate_definition__c, Specialty_Rebates__c, CVS_Share__c, Claim_Audit__c, 
            //                                               Billing_Admin_Payment_Terms__c, Billing_Claim_Payment_Terms__c, Client_Share__c,
            //                                               Exhibit_D__c, Exhibit_E__c, Exhibit_F__c, Exhibit_G__c, Exhibit_H__c, Exhibit_I__c, 
            //                                               Exhibit_J__c,FAF_ID__c,Performance_Guarantee__c, Appeals__c, Maintenance_choice__c,
            //                                               Medicare_Subsidy__c, Preventive_Care_Drug_Program__c, Vaccine_service__c, Transform_Diabetic_care_program__c                                                
            //                                               FROM PBS_Agreement_Extension__c]);
            
            list<PBS_Agreement_Extension__c> AgreementExtList = [SELECT id, Pass_MAF__c, Rebate_RTMD__c, Pharmacy_Audit_Retention__c,
                                                           Rebate_definition__c, Specialty_Rebates__c, CVS_Share__c, Claim_Audit__c, 
                                                           Billing_Admin_Payment_Terms__c, Billing_Claim_Payment_Terms__c, Client_Share__c,
                                                           Exhibit_D__c, Exhibit_E__c, Exhibit_F__c, Exhibit_G__c, Exhibit_H__c, Exhibit_I__c, Exhibit_J__c, 
                                                           FAF_ID__c, Performance_Guarantee__c, Appeals__c, Maintenance_choice__c,
                                                           Medicare_Subsidy__c, Preventive_Care_Drug_Program__c, Vaccine_service__c, Transform_Diabetic_care_program__c
                                                           FROM PBS_Agreement_Extension__c WHERE Client_Name__c = 'test1'];
            
        	//AgreementExtList[0].Pass_MAF__c = true; 
            //AgreementExtList[0].Specialty_Rebates__c = 'Pass to Client';
        	//AgreementExtList[0].Rebate_RTMD__c = false;
            //AgreementExtList[0].Client_Share__c = 20;
       		//AgreementExtList[1].Pharmacy_Audit_Retention__c = 'Base (80/20)'; 
            //AgreementExtList[1].Specialty_Rebates__c = 'Do Not Pass to Client';
        	//AgreementExtList[1].Rebate_RTMD__c = true;
            //AgreementExtensionHelper.updateAgreementExt(AgreementExtList, false, true, true, false, oldAgreementExtList);    	
            //update AgreementExtList;
    
  			//AgreementExtList[0].Pass_MAF__c = false; 
            AgreementExtList[0].Specialty_Rebates__c = 'Pass to Client';      	
            update AgreementExtList;
        
        	AgreementExtList[0].Pass_MAF__c = true;
        	update AgreementExtList;
        
        	AgreementExtList[0].Pass_MAF__c = true;
        	AgreementExtList[0].Specialty_Rebates__c = 'Do Not Pass to Client';
        	update AgreementExtList;
        
        	AgreementExtList[0].Rebate_RTMD__c = true;
        	AgreementExtList[0].Claim_Audit__c = 'No POS';
        	update AgreementExtList;
        
        	AgreementExtList[0].Rebate_RTMD__c = false;
        	update AgreementExtList;
        
        	AgreementExtList[0].Pharmacy_Audit_Retention__c = 'Premier (75/25)';
        	update AgreementExtList;
        
        	AgreementExtList[0].Client_Share__c = 22;
        	update AgreementExtList;
        
        	AgreementExtList[0].Performance_Guarantee__c = false;
        	AgreementExtList[0].Appeals__c = false;
        	AgreementExtList[0].Maintenance_choice__c = false;
        	AgreementExtList[0].Medicare_Subsidy__c = false;
        	AgreementExtList[0].Preventive_Care_Drug_Program__c = false;
        	AgreementExtList[0].Vaccine_service__c = false;
        	AgreementExtList[0].Transform_Diabetic_care_program__c = false;
        	update AgreementExtList;
        Test.stopTest();
    }
}