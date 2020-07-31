@isTest
public class clientInfomationDetailsTest {
      static testmethod void validateNewClientInformation(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
         Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(FAFObj.id);
        insert billOpsObj;
        Billing_Administrative_Fees__c billAdmObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
        billAdmObj.year__c = '5';
        insert billAdmObj;
        
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
     
        newClientInfo.hidePricingEffectiveMethod();
        newClientInfo.rebateEffectiveDate();
        newClientInfo.save1();
        newClientInfo.cancel();
        newClientInfo.escalatingPriceSelected();
        newClientInfo.yesDeleteEscaltingPrice();
        newClientInfo.cancelPopUp();
        newClientInfo.deleteRecordsAction();
        
        Test.stopTest();
        
    } 
   
    static testmethod void validateNewClientInformation1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        clientInfo.Escalating_Pricing__c = true;
        clientInfo.year_1__c = '1';
        clientInfo.year_2__c = '2';
        clientInfo.year_3__c = '3';
        clientInfo.year_4__c = '4';
        clientInfo.year_5__c = '5';
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(FAFObj.id);
        insert billOpsObj;
        Broker_TPA_Name_Support__c brokerNameObj = TestDataFactoryForBilling.createBrokersupport();
        insert brokerNameObj;
        Billing_Broker_TPA_Payments__c brokerTPAObj = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id,billOpsObj.id,brokerNameObj.id);
        brokerTPAObj.Year__c = '5';
        insert brokerTPAObj;
        Billing_Administrative_Fees__c billAdmObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
        billAdmObj.year__c = '5';
        insert billAdmObj;
        Billing_Ancillary_Fee__c billAncObj = TestDataFactory.createBillAncillary(FAFObj.id,billOpsObj.id);
        billAncObj.Year__c = '5';
        insert billAncObj;
        Contractual_Payments__c billOthrObj = TestDataFactory.createBillOthrPaymnts(FAFObj.id,billOpsObj.id);
        billOthrObj.Years__c = '5';
        insert billOthrObj;
        /*Rebate_Operations__c rebateOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        insert rebateOpsObj;
        Rebate_Guarantees__c rebateGuarObj = TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOpsObj.id);
        rebateGuarObj.Year__c = '5';
        insert rebateGuarObj;
        Rebate_Gtees_Specialty_Class_Carve_Outs__c rebateGteesObj = TestDataFactory.createGtees(rebateOpsObj.id,FAFObj.id);
        rebateGteesObj.Year__c = '5';
        insert rebateGteesObj;
        Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
        insert specOpsObj;
        Specialty_Legacy_Drug_Level_pricing__c specLegacyObj = TestDataFactory.createSpeciality(FAFObj.id,specOpsObj.id);
        specLegacyObj.year__c = '5';
        insert specLegacyObj;
        Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
        specPricingObj.Year__c = '5';
        insert specPricingObj;
        Specialty_Drug_Level_Pricing__c specDrugObj = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
        specDrugObj.year__c = '5';
        insert specDrugObj;
        Guarantees_Information__c guarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
        insert guarInfoObj;
        Trend_Guarantee__c trendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        trendGuarObj.Year__c = '5';
        insert trendGuarObj;
        Gnc_Guarantee__c aspGuarObj = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        aspGuarObj.Year__c = '5';
        insert aspGuarObj;
        Clinical_Operations__c clinOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        insert clinOpsObj;
        Clinical_Solutions__c clinSolObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clinOpsObj.id);
        clinSolObj.Year__c = '5';
        insert clinSolObj;
        Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert netOpsObj;
        Network_Pricing__c netPriObj = TestDataFactory.createntwrkPricing(FAFObj.id,netOpsObj.id);
        netPriObj.Year__c = '5';
        insert netPriObj;
        Mail_Operations__c mailOpsObj = TestDataFactory.createMailOperation(FAFObj.id);
        insert mailOpsObj;
        Mail_Pricing__c mailPriObj = TestDataFactory.createmailPricing(FAFObj.id,mailOpsObj.id);
        mailPriObj.Year__c = '5';
        insert mailPriObj;*/
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.clientInfo.year_1__c = null;
        newClientInfo.clientInfo.year_2__c = null;
        newClientInfo.clientInfo.year_3__c = null;
        newClientInfo.clientInfo.year_4__c = null;
        newClientInfo.clientInfo.year_5__c = null;
        newClientInfo.clientInfo.Year_1_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_1_End_Date__c = null;
        newClientInfo.clientInfo.Year_2_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_2_End_Date__c = null;
        newClientInfo.clientInfo.Year_3_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_3_End_Date__c = null;
        newClientInfo.clientInfo.Year_4_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_4_End_Date__c = null;
        newClientInfo.clientInfo.Year_5_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_5_End_Date__c = null;
        newClientInfo.clientInfo.Escalating_Pricing__c = false;
       
        newClientInfo.save1();
        
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        
    } 
     static testmethod void validateNewClientInformation5(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        clientInfo.Escalating_Pricing__c = true;
        clientInfo.year_1__c = '1';
        clientInfo.year_2__c = '2';
        clientInfo.year_3__c = '3';
        clientInfo.year_4__c = '4';
        clientInfo.year_5__c = '5';
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        
        Rebate_Operations__c rebateOpsObj = TestDataFactory.createRebOps(FAFObj.id);
        insert rebateOpsObj;
        Rebate_Guarantees__c rebateGuarObj = TestDataFactory.createRebateGuarantee(FAFObj.id,rebateOpsObj.id);
        rebateGuarObj.Year__c = '5';
        insert rebateGuarObj;
        Rebate_Gtees_Specialty_Class_Carve_Outs__c rebateGteesObj = TestDataFactory.createGtees(rebateOpsObj.id,FAFObj.id);
        rebateGteesObj.Year__c = '5';
        insert rebateGteesObj; 
        /*Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
        insert specOpsObj;
        Specialty_Legacy_Drug_Level_pricing__c specLegacyObj = TestDataFactory.createSpeciality(FAFObj.id,specOpsObj.id);
        specLegacyObj.year__c = '5';
        insert specLegacyObj;
        Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
        specPricingObj.Year__c = '5';
        insert specPricingObj;
        Specialty_Drug_Level_Pricing__c specDrugObj = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
        specDrugObj.year__c = '5';
        insert specDrugObj;
        Guarantees_Information__c guarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
        insert guarInfoObj;
        Trend_Guarantee__c trendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        trendGuarObj.Year__c = '5';
        insert trendGuarObj;
        Gnc_Guarantee__c aspGuarObj = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        aspGuarObj.Year__c = '5';
        insert aspGuarObj;
        Clinical_Operations__c clinOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        insert clinOpsObj;
        Clinical_Solutions__c clinSolObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clinOpsObj.id);
        clinSolObj.Year__c = '5';
        insert clinSolObj;
        Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert netOpsObj;
        Network_Pricing__c netPriObj = TestDataFactory.createntwrkPricing(FAFObj.id,netOpsObj.id);
        netPriObj.Year__c = '5';
        insert netPriObj;
        Mail_Operations__c mailOpsObj = TestDataFactory.createMailOperation(FAFObj.id);
        insert mailOpsObj;
        Mail_Pricing__c mailPriObj = TestDataFactory.createmailPricing(FAFObj.id,mailOpsObj.id);
        mailPriObj.Year__c = '5';
        insert mailPriObj;*/
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.clientInfo.year_1__c = null;
        newClientInfo.clientInfo.year_2__c = null;
        newClientInfo.clientInfo.year_3__c = null;
        newClientInfo.clientInfo.year_4__c = null;
        newClientInfo.clientInfo.year_5__c = null;
        newClientInfo.clientInfo.Year_1_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_1_End_Date__c = null;
        newClientInfo.clientInfo.Year_2_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_2_End_Date__c = null;
        newClientInfo.clientInfo.Year_3_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_3_End_Date__c = null;
        newClientInfo.clientInfo.Year_4_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_4_End_Date__c = null;
        newClientInfo.clientInfo.Year_5_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_5_End_Date__c = null;
        newClientInfo.clientInfo.Escalating_Pricing__c = false;
       
        newClientInfo.save1();
        
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        
    } 
    
    static testmethod void validateNewClientInformation6(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        clientInfo.Escalating_Pricing__c = true;
        clientInfo.year_1__c = '1';
        clientInfo.year_2__c = '2';
        clientInfo.year_3__c = '3';
        clientInfo.year_4__c = '4';
        clientInfo.year_5__c = '5';
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        
        Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
        insert specOpsObj;
        Specialty_Legacy_Drug_Level_pricing__c specLegacyObj = TestDataFactory.createSpeciality(FAFObj.id,specOpsObj.id);
        specLegacyObj.year__c = '5';
        insert specLegacyObj;
        Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(FAFObj.id,specOpsObj.id);
        specPricingObj.Year__c = '5';
        insert specPricingObj;
        Specialty_Drug_Level_Pricing__c specDrugObj = TestDataFactory.createspecDrugObject(FAFObj.id,specOpsObj.id);
        specDrugObj.year__c = '5';
        insert specDrugObj; 
        /*Guarantees_Information__c guarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
        insert guarInfoObj;
        Trend_Guarantee__c trendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        trendGuarObj.Year__c = '5';
        insert trendGuarObj;
        Gnc_Guarantee__c aspGuarObj = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        aspGuarObj.Year__c = '5';
        insert aspGuarObj;
        Clinical_Operations__c clinOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        insert clinOpsObj;
        Clinical_Solutions__c clinSolObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clinOpsObj.id);
        clinSolObj.Year__c = '5';
        insert clinSolObj;
        Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert netOpsObj;
        Network_Pricing__c netPriObj = TestDataFactory.createntwrkPricing(FAFObj.id,netOpsObj.id);
        netPriObj.Year__c = '5';
        insert netPriObj;
        Mail_Operations__c mailOpsObj = TestDataFactory.createMailOperation(FAFObj.id);
        insert mailOpsObj;
        Mail_Pricing__c mailPriObj = TestDataFactory.createmailPricing(FAFObj.id,mailOpsObj.id);
        mailPriObj.Year__c = '5';
        insert mailPriObj;*/
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.clientInfo.year_1__c = null;
        newClientInfo.clientInfo.year_2__c = null;
        newClientInfo.clientInfo.year_3__c = null;
        newClientInfo.clientInfo.year_4__c = null;
        newClientInfo.clientInfo.year_5__c = null;
        newClientInfo.clientInfo.Year_1_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_1_End_Date__c = null;
        newClientInfo.clientInfo.Year_2_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_2_End_Date__c = null;
        newClientInfo.clientInfo.Year_3_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_3_End_Date__c = null;
        newClientInfo.clientInfo.Year_4_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_4_End_Date__c = null;
        newClientInfo.clientInfo.Year_5_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_5_End_Date__c = null;
        newClientInfo.clientInfo.Escalating_Pricing__c = false;
       
        newClientInfo.save1();
        
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        
    } 
    
    static testmethod void validateNewClientInformation7(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        clientInfo.Escalating_Pricing__c = true;
        clientInfo.year_1__c = '1';
        clientInfo.year_2__c = '2';
        clientInfo.year_3__c = '3';
        clientInfo.year_4__c = '4';
        clientInfo.year_5__c = '5';
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        
        Guarantees_Information__c guarInfoObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
        insert guarInfoObj;
        Trend_Guarantee__c trendGuarObj = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        trendGuarObj.Year__c = '5';
        insert trendGuarObj;
        Gnc_Guarantee__c aspGuarObj = TestDataFactory.createASPGuaranteeInfo(FAFObj.id,guarInfoObj.id);
        aspGuarObj.Year__c = '5';
        insert aspGuarObj; 
        /*Clinical_Operations__c clinOpsObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
        insert clinOpsObj;
        Clinical_Solutions__c clinSolObj = TestDataFactory.createGClinicalSolution(FAFObj.id,clinOpsObj.id);
        clinSolObj.Year__c = '5';
        insert clinSolObj;
        Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert netOpsObj;
        Network_Pricing__c netPriObj = TestDataFactory.createntwrkPricing(FAFObj.id,netOpsObj.id);
        netPriObj.Year__c = '5';
        insert netPriObj;
        Mail_Operations__c mailOpsObj = TestDataFactory.createMailOperation(FAFObj.id);
        insert mailOpsObj;
        Mail_Pricing__c mailPriObj = TestDataFactory.createmailPricing(FAFObj.id,mailOpsObj.id);
        mailPriObj.Year__c = '5';
        insert mailPriObj;*/
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.clientInfo.year_1__c = null;
        newClientInfo.clientInfo.year_2__c = null;
        newClientInfo.clientInfo.year_3__c = null;
        newClientInfo.clientInfo.year_4__c = null;
        newClientInfo.clientInfo.year_5__c = null;
        newClientInfo.clientInfo.Year_1_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_1_End_Date__c = null;
        newClientInfo.clientInfo.Year_2_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_2_End_Date__c = null;
        newClientInfo.clientInfo.Year_3_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_3_End_Date__c = null;
        newClientInfo.clientInfo.Year_4_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_4_End_Date__c = null;
        newClientInfo.clientInfo.Year_5_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_5_End_Date__c = null;
        newClientInfo.clientInfo.Escalating_Pricing__c = false;
       
        newClientInfo.save1();
        
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        
    } 
    
    static testmethod void validateNewClientInformation8(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        clientInfo.Escalating_Pricing__c = true;
        clientInfo.year_1__c = '1';
        clientInfo.year_2__c = '2';
        clientInfo.year_3__c = '3';
        clientInfo.year_4__c = '4';
        clientInfo.year_5__c = '5';
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        
        
        Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
        insert netOpsObj;
        Network_Pricing__c netPriObj = TestDataFactory.createntwrkPricing(FAFObj.id,netOpsObj.id);
        netPriObj.Year__c = '5';
        insert netPriObj;
        
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.clientInfo.year_1__c = null;
        newClientInfo.clientInfo.year_2__c = null;
        newClientInfo.clientInfo.year_3__c = null;
        newClientInfo.clientInfo.year_4__c = null;
        newClientInfo.clientInfo.year_5__c = null;
        newClientInfo.clientInfo.Year_1_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_1_End_Date__c = null;
        newClientInfo.clientInfo.Year_2_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_2_End_Date__c = null;
        newClientInfo.clientInfo.Year_3_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_3_End_Date__c = null;
        newClientInfo.clientInfo.Year_4_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_4_End_Date__c = null;
        newClientInfo.clientInfo.Year_5_Begin_Date__c = null;
        newClientInfo.clientInfo.Year_5_End_Date__c = null;
        newClientInfo.clientInfo.Escalating_Pricing__c = false;
       
        newClientInfo.save1();
        
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        
    } 
    
    static testmethod void validateNewClientInformation2(){
        Test.startTest();
        Client_Information__c clientInfo = new Client_Information__c();
        
        //clientInfo.FAF_ID__c = FAFObj.Id;
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.hidePricingEffectiveMethod();
        newClientInfo.rebateEffectiveDate();
        newClientInfo.save1();
        newClientInfo.cancel();
        newClientInfo.escalatingPriceSelected();
        newClientInfo.yesDeleteEscaltingPrice();
        newClientInfo.cancelPopUp();
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
    }  
    
    
     static testmethod void validateNewClientInformation3(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        FAFObj.FAF_Status__c = 'Draft';
        insert FAFObj;
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        // Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.hidePricingEffectiveMethod();
        newClientInfo.rebateEffectiveDate();
        newClientInfo.save1();
        newClientInfo.cancel();
        newClientInfo.escalatingPriceSelected();
        newClientInfo.yesDeleteEscaltingPrice();
        newClientInfo.cancelPopUp();
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        
     }
    
    static testmethod void validateNewClientInformation4(){
        
        try{
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Test.startTest();
        //Insert Full FAF 
        Central_Hub__c fullFAF = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        fullFAF.Business_Type__c = 'New';
        fullFAF.FAF_Status__c = 'Closed';
        fullFAF.FAF_Type__c  = 'Full';
        insert fullFAF;
        
        //Inset Partial FAF
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'Existing';
        FAFObj.FAF_Status__c = 'Draft';
        insert FAFObj;
        
        //Link Partial and Full FAF
        FAF_Link__c fafLink = new FAF_Link__c();
        fafLink.Full_FAF__c = fullFAF.Id;
        fafLink.Partial_FAF__c = FAFObj.Id;
        insert fafLink;
        
        list<FAF_Link__c>  fafLinkList = [select id,Full_FAF__c,Partial_FAF__c,Full_FAF_Type__c,Full_FAF__r.FAF_Type__c from FAF_Link__c where Partial_FAF__c =: FAFObj.Id ];
        
        system.debug('the faf link is' + fafLinkList);
        
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        
        //Change Full FAF APTS_Template__cus to Implemneted
        FAFObj.FAF_Status__c = 'Implemented';
        FAFObj.FAF_Type__c  = 'Partial';
        update FAFObj;
       
        Rebate_Operations__c rebOpsObj1 = [select id, FAF_Id__c from Rebate_Operations__c where FAF_Id__c =: FAFObj.Id limit 1];
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = date.parse('1/7/2009');
        clientInfo.Rebate_Effective_Date__c = date.parse('4/1/2009');
        clientInfo.Escalating_Pricing__c = true;
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        newClientInfo.popupActionValue = 'Continue';
        newClientInfo.hidePricingEffectiveMethod();
        newClientInfo.rebateEffectiveDate();
        newClientInfo.save1();
        newClientInfo.cancel();
        newClientInfo.escalatingPriceSelected();
        newClientInfo.yesDeleteEscaltingPrice();
        newClientInfo.cancelPopUp();
        newClientInfo.deleteRecordsAction();
        Test.stopTest();
        }
        catch(exception exp){
            
        }
        
    }
    
    static testmethod void EditButtonTest1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = userInfo.getUserName();
        salesperson.Manager_Level_3__c = userInfo.getUserName();
        salesperson.Manager_Level_4__c = userInfo.getUserName();
        salesperson.Manager_Level_5__c = userInfo.getUserName();
        salesperson.ManagerId = userInfo.getUserId();
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest();
    
    }
     static testmethod void EditButtonTest2(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
       newClientInfo1.Actionvisible();
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest3(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_3__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest4(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_4__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest5(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_5__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest6(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_6__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest7(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_7__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
       ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        ClientInfoEditButton.createapproval(clientInfo.id);
        ClientInfoEditButton.getAccessForSalesUser1();
        ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        FAFInfoEditButton.createapproval(FAFObj.id);
        Test.stopTest(); 
    
   } 
}