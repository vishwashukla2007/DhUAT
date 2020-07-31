/*********************************************************************************************
* @author   Sanket Saxena
* @date     08 07 2018
* @description:This is the test class for ASPGuaranteeNewEditClass        
**********************************************************************************************/

@isTest
public with sharing class ASPGuaranteeNewEditClassTest{
    static testmethod void ASPGuaranteeNewEditClassTestMeth1()
    {   
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj){
         test.starttest();
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Guarantees_Information__c GuaranteeObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuaranteeObj;
            
            Gnc_Guarantee__c ASPGuaranteeObj  = TestDataFactory.createASPGuaranteeInfo(FAFObj.id, GuaranteeObj.id);
            insert ASPGuaranteeObj;
            
            Client_Information__c clientINFO = TestDataFactory.createClientInfo(FAFObj.id);
            //Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
            //                                Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
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
            
            insert clientINFO;
            //update clientINFO;
            PageReference pageRef = Page.ASPGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(Label.GuarInfoIdInASPGuarantee,GuaranteeObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(ASPGuaranteeObj);
            ASPGuaranteeNewEditClass controller = new ASPGuaranteeNewEditClass(sc);
            controller.changeYearMeth();
            controller.saveUpdateASPGuaranteeObj();  

            ApexPages.StandardController sc1 = new ApexPages.standardController(ASPGuaranteeObj);
            ASPGuaranteeNewEditClass controller1 = new ASPGuaranteeNewEditClass(sc1);
            controller1.operationType = 'clone';
            controller1.changeYearMeth();
            controller1.saveUpdateASPGuaranteeObj();            
            test.stoptest();
        }
    }
    static testmethod void ASPGuaranteeNewEditClassTestMeth2()
    {

        User useObj = TestDataFactoryForBilling.createUser('Apttus Underwriting');
        insert useObj;
        User useObjNew = TestDataFactoryForBilling.createUser('Apttus Sales');
        insert useObjNew;       
        System.runAs(useObj){
        test.starttest();
            Account accObj =  TestDataFactoryForBilling.createAccount();
            insert accObj;
            Opportunity oppObj = TestDataFactoryForBilling.createOpportunity(accObj.id);
            insert oppObj;
            
            Central_Hub__c FAFObj = TestDataFactoryForBilling.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Client_Information__c clientINFO = TestDataFactory.createClientInfo(FAFObj.id);
            //Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
            //                               Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];  
            clientINFO.year_1__c='1';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     clientINFO.year_1__c='1';
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
            insert clientINFO;
            //update clientINFO;
          
            Guarantees_Information__c GuaranteeObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert GuaranteeObj;
            
            Gnc_Guarantee__c ASPGuaranteeObj  = TestDataFactory.createASPGuaranteeInfo(FAFObj.id, GuaranteeObj.id);
            insert ASPGuaranteeObj;
                       
            PageReference pageRef = Page.ASPGuaranteeNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ASPGuaranteeObj.id);
            pageRef.getParameters().put(Label.GuarInfoIdInASPGuarantee,GuaranteeObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(ASPGuaranteeObj);
            ASPGuaranteeNewEditClass controller = new ASPGuaranteeNewEditClass(sc);
            system.debug('-------Label.GuarInfoIdInASPGuarantee------');
            system.debug('-------ASPGuaranteeObj.id------');
            controller.changeYearMeth();
            controller.saveUpdateASPGuaranteeObj(); 

            ApexPages.StandardController sc1 = new ApexPages.standardController(ASPGuaranteeObj);
            ASPGuaranteeNewEditClass controller1 = new ASPGuaranteeNewEditClass(sc1);
            controller1.operationType = 'clone';
            controller1.changeYearMeth();
            controller1.saveUpdateASPGuaranteeObj();            
            test.stoptest();
            
        }
    } 
}