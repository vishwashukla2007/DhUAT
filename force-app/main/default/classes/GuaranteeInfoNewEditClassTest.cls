/*********************************************************************************************
* @author   Priyanka Goyal
* @date     07 08 2018
* @description:This is the test class for GuaranteeInfoNewEditClass        
**********************************************************************************************/

@isTest
public with sharing class GuaranteeInfoNewEditClassTest{
    static testmethod void GuaranteeInfoNewEditClassTestMeth1()
    {
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
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            Guarantees_Information__c guarInfoObj =  TestDataFactory.createGuaranteeInfo(FAFObj.id);
            guarInfoObj.Trend_Guarantee__c='Yes';
            guarInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'Yes';
            guarInfoObj.Average_Sales_Price_Per_Client_ASP__c=True;
            guarInfoObj.ASP_Specific_Plan_Design__c=False;
            guarInfoObj.Client_Share_Percent__c= 50;
            insert guarInfoObj;
            
            test.starttest();
            PageReference pageRef = Page.GuaranteeInfoNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',guarInfoObj.id);
            pageRef.getParameters().put(Label.fafIdInGuaranteeInfo,FAFObj.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(guarInfoObj);
            GuaranteeInfoNewEditClass controller = new GuaranteeInfoNewEditClass(sc);

           
            controller.saveUpdateguaranteeInfoObj();          
            controller.changeTrendGuarField();
            controller.changeSharedRiskField();
            controller.changeASPGuarField();
            controller.actionOnChangePerfGuarantee();
            controller.changeASPDesignField();
            controller.actionOnChangeValueForm();
            controller.actionOnChangeOtherForm();
            controller.showHidePercentDollarField();
            controller.enableRiskDependentFields();
            controller.changePayOutCapMeth();
            controller.enableShareType();
            test.stoptest();
        }
    }

    static testmethod void GuaranteeInfoNewEditClassTestMeth2()
    {
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
            Guarantees_Information__c guarInfoObj =  TestDataFactory.createGuaranteeInfo(FAFObj.id);
            guarInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'Yes';
            guarInfoObj.Trend_Guarantee__c='Yes';
            guarInfoObj.Average_Sales_Price_Per_Client_ASP__c=True;
            guarInfoObj.ASP_Specific_Plan_Design__c=True;
            guarInfoObj.Trend_Guarantee_Shared_Risk__c=True;
            insert guarInfoObj;
            
            test.starttest();
            PageReference pageRef = Page.GuaranteeInfoNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.fafIdInGuaranteeInfo,FAFObj.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(guarInfoObj);
            GuaranteeInfoNewEditClass controller = new GuaranteeInfoNewEditClass(sc);

           
            controller.saveUpdateguaranteeInfoObj();          
            controller.changeTrendGuarField();
            controller.changeSharedRiskField();
            controller.changeASPGuarField();
            controller.actionOnChangePerfGuarantee();
            controller.changeASPDesignField();
            controller.actionOnChangeValueForm();
            controller.actionOnChangeOtherForm();
            
            test.stoptest();
        }
    }
    
    static testmethod void GuaranteeInfoNewEditClassTestMeth3()
    {
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
            Guarantees_Information__c guarInfoObj =  TestDataFactory.createGuaranteeInfo(FAFObj.id);
            guarInfoObj.Trend_Guarantee__c='Yes';
            guarInfoObj.Average_Sales_Price_Per_Client_ASP__c=False;
            guarInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = 'Yes';
            insert guarInfoObj;
            guarInfoObj.Trend_Guarantee_Shared_Risk__c=True;
            update guarInfoObj;
            
            test.starttest();
            PageReference pageRef = Page.GuaranteeInfoNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.fafIdInGuaranteeInfo,FAFObj.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(guarInfoObj);
            GuaranteeInfoNewEditClass controller = new GuaranteeInfoNewEditClass(sc);

           
            controller.saveUpdateguaranteeInfoObj();          
            controller.changeTrendGuarField();
            controller.changeSharedRiskField();
            controller.changeASPGuarField();
            controller.actionOnChangePerfGuarantee();
            controller.changeASPDesignField();
            controller.actionOnChangeValueForm();
            controller.actionOnChangeOtherForm();
            controller.GncGuaranteeChange();
            test.stoptest();
        }
    }
    
    static testmethod void GuaranteesInformationTriggerHelperTest()
    {
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
            
            
            List<Guarantees_Information__c> GuarInfolist=new List<Guarantees_Information__c>();
                        
            Guarantees_Information__c guarInfoObj =  TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert guarInfoObj;
            
            Trend_Guarantee__c TrendGuaranteeObj  = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id, guarInfoObj.id);
            TrendGuaranteeObj.At_Risk_Amount__c=null;
            insert TrendGuaranteeObj;
            
            delete guarInfoObj;
            
            test.starttest();
            GuaranteesInformationTriggerHelper.updateFAFOnDelete(GuarInfolist);
            
            test.stoptest();
        }
    }
}