/*********************************************************************************************
* @author   Priyanka Goyal
* @date     08 08 2018
* @description:This is the test class for TrendGuaranteeNewEditClass        
**********************************************************************************************/

@isTest
public with sharing class TrendGuaranteeNewEditClassTest{
    static testmethod void TrendGuaranteeNewEditClassTestMeth1()
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
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Guarantees_Information__c GuaranteeObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuaranteeObj;
            
            Trend_Guarantee__c TrendGuaranteeObj  = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id, GuaranteeObj.id);
            insert TrendGuaranteeObj;
            
            test.starttest();
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
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
            PageReference pageRef = Page.TrendGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',TrendGuaranteeObj.id);
            pageRef.getParameters().put(Label.GuarInfoIdInTrendGuarantee,GuaranteeObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(TrendGuaranteeObj);
            TrendGuaranteeNewEditClass controller = new TrendGuaranteeNewEditClass(sc);
            controller.changeYearMeth();
            controller.saveUpdatetrendGuaranteeObj();           
            test.stoptest();
        }
    }
    static testmethod void TrendGuaranteeNewEditClassTestMeth2()
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
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Guarantees_Information__c GuaranteeObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuaranteeObj;
            
            Trend_Guarantee__c TrendGuaranteeObj  = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id, GuaranteeObj.id);
            insert TrendGuaranteeObj;
            
            test.starttest();
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
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
            PageReference pageRef = Page.TrendGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null);
            pageRef.getParameters().put(Label.GuarInfoIdInTrendGuarantee,GuaranteeObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(TrendGuaranteeObj);
            TrendGuaranteeNewEditClass controller = new TrendGuaranteeNewEditClass(sc);
            controller.changeYearMeth();
            controller.saveUpdatetrendGuaranteeObj();           
            test.stoptest();
        }
    }
	static testmethod void TrendGuaranteeNewEditClassTestMeth3()
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
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            Guarantees_Information__c GuaranteeObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuaranteeObj;
            
            Trend_Guarantee__c TrendGuaranteeObj  = TestDataFactory.createTrendGuaranteeInfo(FAFObj.id, GuaranteeObj.id);
            insert TrendGuaranteeObj;
            
            test.starttest();
            clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
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
            PageReference pageRef = Page.TrendGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',TrendGuaranteeObj.id);
            pageRef.getParameters().put(Label.GuarInfoIdInTrendGuarantee,GuaranteeObj.Id);
            pageRef.getParameters().put('type','clone');
            ApexPages.StandardController sc = new ApexPages.standardController(TrendGuaranteeObj);
            TrendGuaranteeNewEditClass controller = new TrendGuaranteeNewEditClass(sc);
            controller.changeYearMeth();
            controller.saveUpdatetrendGuaranteeObj();           
            test.stoptest();
        }
    }
}