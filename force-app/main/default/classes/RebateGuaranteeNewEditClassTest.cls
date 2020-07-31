/*********************************************************************************************
* @author   Akanksha Singh
* @date     26 06 2018
* @description:This is the testclass for RebateGuaranteeNewEditClass         
 **********************************************************************************************/
 
@isTest
public with sharing class RebateGuaranteeNewEditClassTest{
    
    @testSetup static void dataSetup() {
        string fieldName = Label.rebateOperationLabel;
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOpsOfferIngType(FAFObj.id);
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            insert rebOpsObj;
            
            Rebate_Guarantees__c rebateGuarantees = TestDataFactory.createRebateGuarantee(FAFObj.id,rebOpsObj.id);            
            insert rebateGuarantees;
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            clientINFO.year_2__c='2';
            clientINFO.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            clientINFO.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            clientINFO.year_3__c='3';
            clientINFO.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            clientINFO.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            clientINFO.year_4__c='4';
            clientINFO.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            clientINFO.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            clientINFO.year_5__c='5';
            clientINFO.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            clientINFO.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            
            update clientINFO;
            system.debug('=================rebateGuarantees================='+rebateGuarantees);
        }
    }
     
    static testmethod void RebateGuaranteeNewEditClassTestMeth1()
    { 
            test.starttest();
             string fieldName = Label.rebateOperationLabel;
             
            Rebate_Operations__c rebOpsObj = [select id, FAF_ID__c, Rebate_Contract_Type__c, Specialty_Rebates__c, Rebate_Offering_Type__c,
            Client_Share__c, Pass_MAF__c, Rebate_RTMD__c, Pass_PP__C, Client_MAF_Share__c, Client_PP_Share__c,
            X340B__c, Custom_Exclusion_s__c, X340B_Exclusion_Option__c,Select_Custom_Exclusion_s__c, LDD__c,
            Exclude_Rebate_Class__c, LDD_Exclusion_Option__c, Select_Rebate_Exclusion_Class_es__c, Biosimilars__c,
            OTC__c, GSTP__c, GSTP_Option__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c,
            Rebate_Payment_Term_Method_by_Contract__c, Pay_On__c, Frequency__c, Speed__c, Pay_After__c,
            Recon_Basis__c, Recon_Method__c, Recon_Frequency__c, Recon_Timeframe__c, Recon_Level__c,
            Specialty_Retail_Mirror_Retail_30__c, Retail_90_Mirror_Retail_30__c, MChoice_Mirror_Mail__c,
            Percentage_Guarantee__c, Rebate_Retail_90_Days_Supply_84__c, Days_Supply__c,
            Specialty_Rebate_Setup_different_than__c, Specialty_Rebate_Contract_Type__c, Specialty_Price_List__c,
            Specialty_Rebate_Offering_Type__c, Specialty_Client_Share__c, Specialty_Pass_MAF__c,
            Specialty_Client_MAF_Share__c, Specialty_Pass_PP__c, Specialty_Client_PP_Share__c,
            Rebate_Specialty_Payment_Term_Method__c, Specialty_Pay_On__c, Specialty_Frequency__c, Specialty_Speed__c,
            Specialty_Pay_After__c, Specialty_Recon_Basis__c, Specialty_Recon_Method__c, Specialty_Recon_Frequency__c,
            Specialty_Recon_Timeframe__c, Specialty_Recon_Level__c, Specialty_PDPD__c, Select_Specialty_PDPD_Therapy_Class_es__c,
            Exclude_Rebate_Specialty_Therapeutic__c, Select_Specialty_Therapy_Class_es__c,
            Class_Carve_Out_Guarantee_Percentage__c, Additional_Rebate_Information__c
            from Rebate_Operations__c];
            
             Rebate_Guarantees__c rebateGuarantees = [select id,FAF_ID__c,Rebate_Operations__c,Year__c ,
                                                     Basis__c,LOB2__c,GSTP__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c  
                                                      from Rebate_Guarantees__c where Rebate_Operations__c =: rebOpsObj.id];
            
            Client_Information__c clientInfo=[Select ID from Client_Information__c ];
            
            rebOpsObj.Non_Specialty_Formulary_Option__c ='Comm Value Standard';
            rebOpsObj.Specialty_Formulary_Option__c = 'Client Choice';
            update rebOpsObj;
            rebateGuarantees.Non_Specialty_Formulary_2__c = '';
            update rebateGuarantees;
            
            PageReference pageRef = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',rebateGuarantees.id);
            pageRef.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controller = new RebateguaranteeNewEditClass(sc);
            controller.perguaranteeFlag=false;
            //controller.changeplanDesign();
            controller.validateRequiredFlag =true;
            controller.operationType='CLONE';
            controller.saveUpdateRec();
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            ////rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Non_Specialty_Formulary_Option__c = 'EGWP Gold';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            rebOpsObj.Percentage_Guarantee__c=false;
            
            update rebOpsObj;
            
            
            PageReference pageRef1 = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRef1);
           // pageRef.getParameters().put('id','');
            pageRef1.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRef1.getParameters().put('type','clone');
            ApexPages.StandardController scA = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controllerA = new RebateguaranteeNewEditClass(scA);
            
           
            rebateGuarantees.Non_Specialty_Formulary_2__c = 'Med D 2T MMP';
            //controllerA.nonspecialtyFormulary = 'Med D 2T MMP';
            update rebateGuarantees;
            controllerA.enableDollar=false;
            
            controllerA.enablePercentage=true;
            //controllerA.changeplanDesign();
            controllerA.operationType='CLONE';
            controllerA.validateRequiredFlag=false;
            controllerA.saveUpdateRec();
            
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Non_Specialty_Formulary_Option__c ='';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            rebOpsObj.Percentage_Guarantee__c=false;
            
            update rebOpsObj;
            PageReference pageRefmain = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRefmain );
            pageRefmain.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRefmain.getParameters().put('type','Clone');
            ApexPages.StandardController sc1 = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controller1 = new RebateguaranteeNewEditClass(sc1);
            
            rebOpsObj.Rebate_Contract_Type__c = 'Silver Script, Inc. (SSI+MAF)';
            rebOpsObj.Rebate_Offering_Type__c = 'Minimum Guarantee with Split of Over Performance';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            rebOpsObj.Non_Specialty_Formulary_Option__c ='';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            update rebOpsObj;
            
          
            //controller1.changeplanDesign();
            
             controller1.enableDollar=true;
             controller1.validateRequiredFlag=false;
          
            controller1.saveUpdateRec();
            
             PageReference pageRefmainA = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRefmainA );
            pageRefmainA.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRefmainA.getParameters().put('type','null');
            
            ApexPages.StandardController scB = new ApexPages.standardController(rebateGuarantees);
        //    RebateguaranteeNewEditClass controllerB = new RebateguaranteeNewEditClass(scB);
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO+MAF+PP) w/ Recon';
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            update rebOpsObj;
            //controllerB.changeplanDesign();
       //     controllerB.saveUpdateRec();
            Test.stopTest();
            System.assertNotEquals(rebateGuarantees.id, null);
        
    }
    static testmethod void RebateGuaranteeNewEditClassTestMeth2()
    { 
            test.starttest();
             string fieldName = Label.rebateOperationLabel;
             
            Rebate_Operations__c rebOpsObj = [select id, FAF_ID__c, Rebate_Contract_Type__c, Specialty_Rebates__c, Rebate_Offering_Type__c,
            Client_Share__c, Pass_MAF__c, Rebate_RTMD__c, Pass_PP__C, Client_MAF_Share__c, Client_PP_Share__c,
            X340B__c, Custom_Exclusion_s__c, X340B_Exclusion_Option__c,Select_Custom_Exclusion_s__c, LDD__c,
            Exclude_Rebate_Class__c, LDD_Exclusion_Option__c, Select_Rebate_Exclusion_Class_es__c, Biosimilars__c,
            OTC__c, GSTP__c, GSTP_Option__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c,
            Rebate_Payment_Term_Method_by_Contract__c, Pay_On__c, Frequency__c, Speed__c, Pay_After__c,
            Recon_Basis__c, Recon_Method__c, Recon_Frequency__c, Recon_Timeframe__c, Recon_Level__c,
            Specialty_Retail_Mirror_Retail_30__c, Retail_90_Mirror_Retail_30__c, MChoice_Mirror_Mail__c,
            Percentage_Guarantee__c, Rebate_Retail_90_Days_Supply_84__c, Days_Supply__c,
            Specialty_Rebate_Setup_different_than__c, Specialty_Rebate_Contract_Type__c, Specialty_Price_List__c,
            Specialty_Rebate_Offering_Type__c, Specialty_Client_Share__c, Specialty_Pass_MAF__c,
            Specialty_Client_MAF_Share__c, Specialty_Pass_PP__c, Specialty_Client_PP_Share__c,
            Rebate_Specialty_Payment_Term_Method__c, Specialty_Pay_On__c, Specialty_Frequency__c, Specialty_Speed__c,
            Specialty_Pay_After__c, Specialty_Recon_Basis__c, Specialty_Recon_Method__c, Specialty_Recon_Frequency__c,
            Specialty_Recon_Timeframe__c, Specialty_Recon_Level__c, Specialty_PDPD__c, Select_Specialty_PDPD_Therapy_Class_es__c,
            Exclude_Rebate_Specialty_Therapeutic__c, Select_Specialty_Therapy_Class_es__c,
            Class_Carve_Out_Guarantee_Percentage__c, Additional_Rebate_Information__c
            from Rebate_Operations__c];
            
             Rebate_Guarantees__c rebateGuarantees = [select id,FAF_ID__c,Rebate_Operations__c,Year__c ,
                                                     Basis__c,LOB2__c,GSTP__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c  
                                                      from Rebate_Guarantees__c where Rebate_Operations__c =: rebOpsObj.id];
            
            Client_Information__c clientInfo=[Select ID from Client_Information__c ];
            
            rebOpsObj.Non_Specialty_Formulary_Option__c ='Comm Value Standard';
            rebOpsObj.Specialty_Formulary_Option__c = 'Client Choice';
            update rebOpsObj;
            rebateGuarantees.Non_Specialty_Formulary_2__c = '';
            update rebateGuarantees;
            
            PageReference pageRef = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',rebateGuarantees.id);
            pageRef.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controller = new RebateguaranteeNewEditClass(sc);
            controller.perguaranteeFlag=false;
            //controller.changeplanDesign();
            controller.validateRequiredFlag =true;
            controller.operationType='CLONE';
            controller.saveUpdateRec();
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Non_Specialty_Formulary_Option__c = 'EGWP Gold';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            rebOpsObj.Percentage_Guarantee__c=false;
            
            update rebOpsObj;
            
            
            PageReference pageRef1 = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRef1);
           // pageRef.getParameters().put('id','');
            pageRef1.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRef1.getParameters().put('type','null');
            ApexPages.StandardController scA = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controllerA = new RebateguaranteeNewEditClass(scA);
            
           
            rebateGuarantees.Non_Specialty_Formulary_2__c = 'Med D 2T MMP';
            //controllerA.nonspecialtyFormulary = 'Med D 2T MMP';
            update rebateGuarantees;
            controllerA.enableDollar=false;
            
            controllerA.enablePercentage=true;
            //controllerA.changeplanDesign();
            controllerA.operationType='CLONE';
            controllerA.validateRequiredFlag=false;
            controllerA.saveUpdateRec();
            
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Non_Specialty_Formulary_Option__c ='';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            rebOpsObj.Percentage_Guarantee__c=false;
            
            update rebOpsObj;
            PageReference pageRefmain = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRefmain );
            pageRefmain.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRefmain.getParameters().put('type','null');
            ApexPages.StandardController sc1 = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controller1 = new RebateguaranteeNewEditClass(sc1);
            
            rebOpsObj.Rebate_Contract_Type__c = 'Silver Script, Inc. (SSI+MAF)';
            rebOpsObj.Rebate_Offering_Type__c = 'Minimum Guarantee with Split of Over Performance';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            rebOpsObj.Non_Specialty_Formulary_Option__c ='';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            update rebOpsObj;
            
          
            //controller1.changeplanDesign();
            
             controller1.enableDollar=true;
             controller1.validateRequiredFlag=false;
          
            controller1.saveUpdateRec();
            
             PageReference pageRefmainA = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRefmainA );
            pageRefmainA.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRefmainA.getParameters().put('type','null');
            
            ApexPages.StandardController scB = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controllerB = new RebateguaranteeNewEditClass(scB);
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO+MAF+PP) w/ Recon';
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            update rebOpsObj;
            //controllerB.changeplanDesign();
            controllerB.saveUpdateRec();
            Test.stopTest();
            System.assertNotEquals(rebateGuarantees.id, null);
        
    }
    
    static testmethod void RebateGuaranteeNewEditClassTestMeth3()
    { 
            test.starttest();
             string fieldName = Label.rebateOperationLabel;
             
            Rebate_Operations__c rebOpsObj = [select id, FAF_ID__c, Rebate_Contract_Type__c, Specialty_Rebates__c, Rebate_Offering_Type__c,
            Client_Share__c, Pass_MAF__c, Rebate_RTMD__c, Pass_PP__C, Client_MAF_Share__c, Client_PP_Share__c,
            X340B__c, Custom_Exclusion_s__c, X340B_Exclusion_Option__c,Select_Custom_Exclusion_s__c, LDD__c,
            Exclude_Rebate_Class__c, LDD_Exclusion_Option__c, Select_Rebate_Exclusion_Class_es__c, Biosimilars__c,
            OTC__c, GSTP__c, GSTP_Option__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c,
            Rebate_Payment_Term_Method_by_Contract__c, Pay_On__c, Frequency__c, Speed__c, Pay_After__c,
            Recon_Basis__c, Recon_Method__c, Recon_Frequency__c, Recon_Timeframe__c, Recon_Level__c,
            Specialty_Retail_Mirror_Retail_30__c, Retail_90_Mirror_Retail_30__c, MChoice_Mirror_Mail__c,
            Percentage_Guarantee__c, Rebate_Retail_90_Days_Supply_84__c, Days_Supply__c,
            Specialty_Rebate_Setup_different_than__c, Specialty_Rebate_Contract_Type__c, Specialty_Price_List__c,
            Specialty_Rebate_Offering_Type__c, Specialty_Client_Share__c, Specialty_Pass_MAF__c,
            Specialty_Client_MAF_Share__c, Specialty_Pass_PP__c, Specialty_Client_PP_Share__c,
            Rebate_Specialty_Payment_Term_Method__c, Specialty_Pay_On__c, Specialty_Frequency__c, Specialty_Speed__c,
            Specialty_Pay_After__c, Specialty_Recon_Basis__c, Specialty_Recon_Method__c, Specialty_Recon_Frequency__c,
            Specialty_Recon_Timeframe__c, Specialty_Recon_Level__c, Specialty_PDPD__c, Select_Specialty_PDPD_Therapy_Class_es__c,
            Exclude_Rebate_Specialty_Therapeutic__c, Select_Specialty_Therapy_Class_es__c,
            Class_Carve_Out_Guarantee_Percentage__c, Additional_Rebate_Information__c
            from Rebate_Operations__c];
            
             Rebate_Guarantees__c rebateGuarantees = [select id,FAF_ID__c,Rebate_Operations__c,Year__c ,
                                                     Basis__c,LOB2__c,GSTP__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c  
                                                      from Rebate_Guarantees__c where Rebate_Operations__c =: rebOpsObj.id];
            
            Client_Information__c clientInfo=[Select ID from Client_Information__c ];
            
            rebOpsObj.Non_Specialty_Formulary_Option__c ='Comm Value Standard';
            rebOpsObj.Specialty_Formulary_Option__c = 'Client Choice';
            update rebOpsObj;
            rebateGuarantees.Non_Specialty_Formulary_2__c = '';
            update rebateGuarantees;
            
            PageReference pageRef = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',rebateGuarantees.id);
            pageRef.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controller = new RebateguaranteeNewEditClass(sc);
            controller.perguaranteeFlag=true;
            //ontroller.changeplanDesign();
            controller.validateRequiredFlag =true;
            controller.operationType='CLONE';
            controller.saveUpdateRec();
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Non_Specialty_Formulary_Option__c = 'EGWP Gold';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            rebOpsObj.Percentage_Guarantee__c=true;
            
            update rebOpsObj;
            
            
            PageReference pageRef1 = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRef1);
           // pageRef.getParameters().put('id','');
            pageRef1.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRef1.getParameters().put('type','null');
            ApexPages.StandardController scA = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controllerA = new RebateguaranteeNewEditClass(scA);
            
           
            rebateGuarantees.Non_Specialty_Formulary_2__c = 'Med D 2T MMP';
            //controllerA.nonspecialtyFormulary = 'Med D 2T MMP';
            update rebateGuarantees;
            controllerA.enableDollar=false;
            
            controllerA.enablePercentage=true;
            //controllerA.changeplanDesign();
            controllerA.operationType='CLONE';
            controllerA.validateRequiredFlag=false;
            controllerA.saveUpdateRec();
            
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO)';
            rebOpsObj.Rebate_Offering_Type__c = 'Split Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = true;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = true;
            rebOpsObj.MChoice_Mirror_Mail__c = true;
            rebOpsObj.Non_Specialty_Formulary_Option__c ='';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            rebOpsObj.Percentage_Guarantee__c=true;
            
            update rebOpsObj;
            PageReference pageRefmain = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRefmain );
            pageRefmain.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRefmain.getParameters().put('type','null');
            ApexPages.StandardController sc1 = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controller1 = new RebateguaranteeNewEditClass(sc1);
            
            rebOpsObj.Rebate_Contract_Type__c = 'Silver Script, Inc. (SSI+MAF)';
            rebOpsObj.Rebate_Offering_Type__c = 'Minimum Guarantee with Split of Over Performance';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            rebOpsObj.Non_Specialty_Formulary_Option__c ='';
            rebOpsObj.Specialty_Formulary_Option__c = 'Custom Formulary';
            update rebOpsObj;
            
          
            //controller1.changeplanDesign();
            
             controller1.enableDollar=true;
             controller1.validateRequiredFlag=false;
          
            controller1.saveUpdateRec();
            
             PageReference pageRefmainA = Page.RebateguaranteeNewEditPage;
            Test.setCurrentPage(pageRefmainA );
            pageRefmainA.getParameters().put(Label.rebateGuaranteerOperations,rebOpsObj.id);
            pageRefmainA.getParameters().put('type','null');
            
            ApexPages.StandardController scB = new ApexPages.standardController(rebateGuarantees);
            RebateguaranteeNewEditClass controllerB = new RebateguaranteeNewEditClass(scB);
            
            rebOpsObj.Rebate_Contract_Type__c = 'Reinvested Rebates (GPO+MAF+PP) w/ Recon';
            rebOpsObj.Rebate_Offering_Type__c = 'Guarantee Only';
            rebOpsObj.Specialty_Retail_Mirror_Retail_30__c = false;
            rebOpsObj.Retail_90_Mirror_Retail_30__c = false;
            rebOpsObj.MChoice_Mirror_Mail__c = false;
            update rebOpsObj;
            //controllerB.changeplanDesign();
            controllerB.saveUpdateRec();
            Test.stopTest();
            System.assertNotEquals(rebateGuarantees.id, null);
        
    }
   
}