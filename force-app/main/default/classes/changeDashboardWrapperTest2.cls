@isTest 
public class changeDashboardWrapperTest2 {
    /*
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
        
        //Create Specialty Ops
        Specialty_Operations__c specialOpsObj = TestDataFactory.createSpeciality(fafObj.id);
        insert specialOpsObj;
        
        //Create Specialty pricing
        Specialty_Pricing__c specialPriceObj = TestDataFactory.createspecPricingObject(fafObj.id,specialOpsObj.id);
        insert specialPriceObj;
        
        //Create Specialty Guarantee
        Specialty_Guarantee__c specialGuaObj = TestDataFactory.createspecGuarnt(fafObj.id,specialPriceObj.id);
        insert specialGuaObj;
        
        Specialty_Guarantee__c specialGuaObj2 = TestDataFactory.createspecGuarnt(fafObj.id,specialPriceObj.id);
        specialGuaObj2.Type__c = 'OED';
        specialGuaObj2.Subtype__c= 'Reconciled';
        insert specialGuaObj2;
        
        //Create Specialty Drug level Pricing
        Specialty_Drug_Level_Pricing__c specialDrugObj = TestDataFactory.createspecDrugObject(fafObj.id,specialOpsObj.id);
        insert specialDrugObj;
        Specialty_Drug_Level_Pricing__c specialDrugObj2 = TestDataFactory.createspecDrugObject(fafObj.id,specialOpsObj.id);
        specialDrugObj2.Year__c = '1';
        specialDrugObj2.LOB__c= 'CAP';
        specialDrugObj2.Pharmacy_Benefit__c = 'Preferred';
        specialDrugObj2.Drug_Therapy__c = 'Acromegaly';
        specialDrugObj2.Drug_Name__c = 'test2';
        specialDrugObj2.Rate__c = 50;     
        insert specialDrugObj2;
        
        //Create Agreement 1.
        List<Apttus__APTS_Agreement__c> agreementList = TestDataFactoryCLM.createAgreementData();
        For (Apttus__APTS_Agreement__c agreement: agreementList) {
            agreement.PBM_FAF__c = fafObj.Id;
            agreement.Attorney__c = atty.id;
            agreement.Paralegal__c = paralegal.id;
            agreement.Name = 'test agreement for batch job test class';
            agreement.FAF_Data_Sync__c = true;
            agreement.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
        }
        insert agreementList;
             
        //Create Agreement Extension
        PBS_Agreement_Extension__c agreementExtension = TestDataFactoryCLM.createAgreementExtension(agreementList[0].Id);
        agreementExtension.Pass_MAF__c = true;
        insert agreementExtension;
        
        //Create change Dashboard custom setting
        list<changeDashboardFields__c> fieldList = new list<changeDashboardFields__c>();
        changeDashboardFields__c instCustomSetting = new changeDashboardFields__c();
        instCustomSetting.Name = 'Pass_MAF__c';
        instCustomSetting.Active__c = true;
        instCustomSetting.AgreementExt_Field_API__c = 'Pass_MAF__c';
        instCustomSetting.FAF_object_API_Name__c = 'Rebate_Operations__r';
        instCustomSetting.Field_Label__c = 'Pass MAF';
        instCustomSetting.Field_Type__c = 'Checkbox';
        fieldList.add(instCustomSetting);
        
        changeDashboardFields__c instCustomSetting1 = new changeDashboardFields__c();
        instCustomSetting1.Name = 'Market Segment';
        instCustomSetting1.Active__c = true;
        instCustomSetting1.AgreementExt_Field_API__c = 'Segment__c';
        instCustomSetting1.FAF_object_API_Name__c = 'Central_Hub__c';
        instCustomSetting1.Field_Label__c = 'Market Segment';
        instCustomSetting1.Field_Type__c = 'Picklist';
        instCustomSetting1.FAF_Object_Relationship__c = 'FAF';
        instCustomSetting1.FAF_Field_API__c = 'Segment__c';
        fieldList.add(instCustomSetting1);
        
        changeDashboardFields__c instCustomSetting2 = new changeDashboardFields__c();
        instCustomSetting2.Name = 'ERISA/NON-ERISA';
        instCustomSetting2.Active__c = true;
        instCustomSetting2.AgreementExt_Field_API__c = 'ERISA_NON_ERISA__c';
        instCustomSetting2.FAF_object_API_Name__c = 'Account_Name__r';
        instCustomSetting2.Field_Label__c = 'ERISA/NON-ERISA';
        instCustomSetting2.Field_Type__c = 'Text';
        instCustomSetting2.FAF_Object_Relationship__c = 'Parent';
        instCustomSetting2.FAF_Field_API__c = 'ERISA_NON_ERISA__c';
        fieldList.add(instCustomSetting2);
        
        changeDashboardFields__c instCustomSetting3 = new changeDashboardFields__c();
        instCustomSetting3.Name = 'Additional Admin Fee Payment Term Info';
        instCustomSetting3.Active__c = true;
        instCustomSetting3.AgreementExt_Field_API__c = 'Additional_Admin_Fee_Payment_Term_Info__c';
        instCustomSetting3.FAF_object_API_Name__c = 'Billing_Ops__r';
        instCustomSetting3.Field_Label__c = 'Additional Admin Fee Payment Term Info';
        instCustomSetting3.Field_Type__c = 'Text';
        instCustomSetting3.FAF_Object_Relationship__c = 'Child';
        instCustomSetting3.FAF_Field_API__c = 'Additional_Admin_Fee_Payment_Term_Info__c';
        fieldList.add(instCustomSetting3);
        
        changeDashboardFields__c instCustomSetting4 = new changeDashboardFields__c();
        instCustomSetting4.Name = 'Appeals';
        instCustomSetting4.Active__c = true;
        instCustomSetting4.AgreementExt_Field_API__c = 'Appeals__c';
        instCustomSetting4.FAF_object_API_Name__c = 'Clinical_Ops__r';
        instCustomSetting4.Field_Label__c = 'Appeals';
        instCustomSetting4.Field_Type__c = 'Checkbox';
        instCustomSetting4.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting4.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting4);
        
        changeDashboardFields__c instCustomSetting5 = new changeDashboardFields__c();
        instCustomSetting5.Name = 'Maintenance choice';
        instCustomSetting5.Active__c = true;
        instCustomSetting5.AgreementExt_Field_API__c = 'Maintenance_choice__c';
        instCustomSetting5.FAF_object_API_Name__c = 'FAF_Network_Ops__r';
        instCustomSetting5.Field_Label__c = 'Maintenance choice';
        instCustomSetting5.Field_Type__c = 'Checkbox';
        instCustomSetting5.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting5.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting5);
        
        changeDashboardFields__c instCustomSetting6 = new changeDashboardFields__c();
        instCustomSetting6.Name = 'Medicare Subsidy';
        instCustomSetting6.Active__c = true;
        instCustomSetting6.AgreementExt_Field_API__c = 'Medicare_Subsidy__c';
        instCustomSetting6.FAF_object_API_Name__c = 'Billing_Ops__r';
        instCustomSetting6.Field_Label__c = 'Medicare Subsidy';
        instCustomSetting6.Field_Type__c = 'Checkbox';
        instCustomSetting6.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting6.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting6);
        
        changeDashboardFields__c instCustomSetting7 = new changeDashboardFields__c();
        instCustomSetting7.Name = 'Transform Diabetic care program';
        instCustomSetting7.Active__c = true;
        instCustomSetting7.AgreementExt_Field_API__c = 'Transform_Diabetic_care_program__c';
        instCustomSetting7.FAF_object_API_Name__c = 'Clinical_Ops__r';
        instCustomSetting7.Field_Label__c = 'Transform Diabetic care program';
        instCustomSetting7.Field_Type__c = 'Checkbox';
        instCustomSetting7.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting7.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting7);
        
        changeDashboardFields__c instCustomSetting8 = new changeDashboardFields__c();
        instCustomSetting8.Name = 'Extracare Healthcard';
        instCustomSetting8.Active__c = true;
        instCustomSetting8.AgreementExt_Field_API__c = 'Extracare_Healthcard__c';
        instCustomSetting8.FAF_object_API_Name__c = 'Clinical_Ops__r';
        instCustomSetting8.Field_Label__c = 'Extracare Healthcard';
        instCustomSetting8.Field_Type__c = 'Checkbox';
        instCustomSetting8.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting8.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting8);
        
        changeDashboardFields__c instCustomSetting9 = new changeDashboardFields__c();
        instCustomSetting9.Name = 'SFS Included?';
        instCustomSetting9.Active__c = true;
        instCustomSetting9.AgreementExt_Field_API__c = 'SFS_Included__c';
        instCustomSetting9.FAF_object_API_Name__c = 'Specialty_Ops__r';
        instCustomSetting9.Field_Label__c = 'SFS Included?';
        instCustomSetting9.Field_Type__c = 'Checkbox';
        instCustomSetting9.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting9.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting9);
        
        changeDashboardFields__c instCustomSetting10 = new changeDashboardFields__c();
        instCustomSetting10.Name = 'SFS Pharmacy Benefit';
        instCustomSetting10.Active__c = true;
        instCustomSetting10.AgreementExt_Field_API__c = 'SFS_Pharmacy_Benefit__c';
        instCustomSetting10.FAF_object_API_Name__c = 'Specialty_Ops__r';
        instCustomSetting10.Field_Label__c = 'SFS Pharmacy Benefit';
        instCustomSetting10.Field_Type__c = 'Picklist';
        instCustomSetting10.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting10.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting10);
        
        changeDashboardFields__c instCustomSetting11 = new changeDashboardFields__c();
        instCustomSetting11.Name = 'SFS Type';
        instCustomSetting11.Active__c = true;
        instCustomSetting11.AgreementExt_Field_API__c = 'SFS_Type__c';
        instCustomSetting11.FAF_object_API_Name__c = 'Specialty_Ops__r';
        instCustomSetting11.Field_Label__c = 'SFS Type';
        instCustomSetting11.Field_Type__c = 'Picklist';
        instCustomSetting11.FAF_Object_Relationship__c = 'Custom Logic';
        instCustomSetting11.FAF_Field_API__c = 'Id';
        fieldList.add(instCustomSetting11);
		
        insert fieldList;
        
        //Create change summary 
        Contract_Change_Summary__c insertChangeSummary = new Contract_Change_Summary__c();
        insertChangeSummary.FAF_ID__c = fafObj.id;
        insertChangeSummary.Agreement_ID__c = agreementList[0].Id;
        insertChangeSummary.Agreement_Extension_ID__c = agreementExtension.id;
        insertChangeSummary.Original_Doc_Generation_Date__c = system.now();
        insertChangeSummary.FAF_Fields_Used_In_Doc__c = 26;
        insertChangeSummary.Sync_Date__c = system.now();
        insertChangeSummary.Field_Values_Changed__c = 20;
        insert insertChangeSummary;
        
        //Create Field Change log
        Contract_Field_Change_Log__c insertFieldChangeLog = new Contract_Field_Change_Log__c();
        insertFieldChangeLog.Agreement_Extension_Field_Name__c = 'Appeals';
        insertFieldChangeLog.Agreement_Extension_Field_Value__c = 'true';
        insertFieldChangeLog.Source_Data_Field_Value__c = 'false';
        insertFieldChangeLog.Reconcile_to_Agreement__c =  true;
        insertFieldChangeLog.Reconcile_to_Document__c = true;
        insertFieldChangeLog.Reconcile_Unreconcile_Doc_By__c = UserInfo.getUserId();
        insertFieldChangeLog.Reconcile_Unreconcile_Doc_Date__c = system.now();
        insertFieldChangeLog.CC_Summary_ID__c = insertChangeSummary.Id;
        insertFieldChangeLog.Agreement__c = agreementList[0].Id;
        insert insertFieldChangeLog;
    }
    
    @isTest 
    static void compareAgreementAndFAFTestMethod() {
        Apttus__APTS_Agreement__c ag = [SELECT id, PBM_FAF__c FROM Apttus__APTS_Agreement__c LIMIT 1];
        list<Apttus__APTS_Agreement__c> agList = [SELECT id, PBM_FAF__c FROM Apttus__APTS_Agreement__c];
        list<Contract_Field_Change_Log__c> cflList = [SELECT Agreement_Extension_Field_Name__c, Agreement_Extension_Field_Value__c,
                                                      Source_Data_Field_Value__c, Reconcile_to_Agreement__c,
                                                      Reconcile_to_Document__c FROM Contract_Field_Change_Log__c];
        //ag.FAF_Data_Sync__c = false;
       	ag.Master_Document_Generation_Date__c = system.now();
        update ag;
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'CVS Official (Do Not Reply)'];
        
        Test.startTest();
        	//compareAgreementAndFAF(Boolean IsBatchJob, id agreementId, list<Apttus__APTS_Agreement__c> agreeList, list<OrgWideEmailAddress> owea, boolean IsForceRun)	
        	changeDashboardWrapper.wrapperClass b = changeDashboardWrapper.compareAgreementAndFAF(true, ag.id ,agList,owea, false);	
        	changeDashboardWrapper.wrapperClass b1 = changeDashboardWrapper.compareAgreementAndFAF(false, ag.id ,agList,owea, true);
            string res1 = changeDashboardWrapper.reconcile(JSON.serialize(b1.fieldValueList),ag.id,2);
            string res2 = changeDashboardWrapper.updateReconcile2(JSON.serialize(cflList),ag.id);
        	cflList[0].Reconcile_to_Document__c = false;
        	string res3 = changeDashboardWrapper.updateReconcile2(JSON.serialize(cflList),ag.id);
        Test.stopTest();
    }
	*/
}