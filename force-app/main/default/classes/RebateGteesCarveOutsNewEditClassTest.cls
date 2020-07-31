/*********************************************************************************************
* @author   Sanket Saxena
* @date     21 06 2018
* @description:This is the testclass for the classRebateGteesCarveOutsNewEditClassTest        
 **********************************************************************************************/
@isTest
public with sharing class RebateGteesCarveOutsNewEditClassTest{
    
    //Method 1 to pass the parameters
    @isTest
    static void RebateGteesCarveOutsNewEditClassTestMeth1()
    {
      User useObj = TestDataFactory.createUser('Apttus Underwriting');
      insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
        
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            system.debug('============FAFObj.id============'+FAFObj.id);
            
            
            
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            rebOpsObj.Class_Carve_Out_Guarantee_Percentage__c = false;
            insert rebOpsObj;
            
            
            Client_Information__c ClientInfoObj = TestDataFactory.createClientInfo(FAFObj.id); 
            insert ClientInfoObj;
                     
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            RGCO.Specialty_Dollar_Amount__c = 20;
            insert RGCO;
            
            Central_Hub__c FAFObj2= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
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
    
            //Pass the parameters from the VF page
            test.starttest();
            PageReference pageRef = Page.RebateGteesCarveOutsNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',RGCO.id); 
            pageRef.getParameters().put(Label.rebateCarveOutCustLab,rebOpsObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(RGCO);
            RebateGteesCarveOutsNewEditClass  controller = new RebateGteesCarveOutsNewEditClass (sc);
            //controller.percentBool= true;
            controller.saveUpdaterebCarOutObj();
            //controller.percentBool= false;
            controller.saveUpdaterebCarOutObj();
             
    
            test.stoptest();
        }
    }
    
    //Method 2 to pass the parameters
    @isTest 
    static void RebateGteesCarveOutsNewEditClassTestMeth2()
    {
        //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> gterssCarveOutList=new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
             //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            Client_Information__c ClientInfoObj =new Client_Information__c(); 
            ClientInfoObj.FAF_ID__c=fafObj.id;
            insert ClientInfoObj;
            
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            
           // Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj1.id);
           // insert clientINFO;
                      
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            //insert RGCO;
            gterssCarveOutList.add(RGCO);
            insert gterssCarveOutList;
    
            //Pass the parameters from the VF page
            test.starttest();
            PageReference pageRef = Page.RebateGteesCarveOutsNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',RGCO.id); 
            ApexPages.StandardController sc = new ApexPages.standardController(RGCO);
            RebateGteesCarveOutsNewEditClass  controller = new RebateGteesCarveOutsNewEditClass (sc);
            controller.percentBool=True;
            controller.saveUpdaterebCarOutObj();
            controller.percentBool= false;
            controller.saveUpdaterebCarOutObj();
            
            RebtGtesSpecClassTriggerHelper trhelperobj=new RebtGtesSpecClassTriggerHelper();
            //trhelperobj.rebateOpsIdSet.add();
            RebtGtesSpecClassTriggerHelper.validateLobYearDrugTheraphyCombinalion(gterssCarveOutList,true,false);
            
            test.stoptest();
        }
    }
    
    @isTest
    static void RebateGteesCarveOutsNewEditClassTestMeth3()
    {
      User useObj = TestDataFactory.createUser('Apttus Underwriting');
      insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Client_Information__c ClientInfoObj =new Client_Information__c(); 
            ClientInfoObj.FAF_ID__c=fafObj.id;
            insert ClientInfoObj;
            
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
                      
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            insert RGCO;
            
            Central_Hub__c FAFObj2= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                
            clientINFO.year_1__c='1';
            clientINFO.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            clientINFO.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            
            update clientINFO;
    
            //Pass the parameters from the VF page
            test.starttest();
            system.debug('#############################'+clientINFO.year_1__c);
            PageReference pageRef = Page.RebateGteesCarveOutsNewEditPage;
            Test.setCurrentPage(pageRef);
            //pageRef.getParameters().put('id',RGCO.id); 
            pageRef.getParameters().put(Label.rebateCarveOutCustLab,rebOpsObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(RGCO);
            RebateGteesCarveOutsNewEditClass  controller = new RebateGteesCarveOutsNewEditClass (sc);
            controller.percentBool= true;
            controller.saveUpdaterebCarOutObj();
            controller.percentBool= false;
            controller.saveUpdaterebCarOutObj();
             
    
            test.stoptest();
        }
    }
    //Method 4 to pass the parameters
    @isTest
    static void RebateGteesCarveOutsNewEditClassTestMeth4()
    {
      User useObj = TestDataFactory.createUser('Apttus Underwriting');
      insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Client_Information__c ClientInfoObj =new Client_Information__c(); 
            ClientInfoObj.FAF_ID__c=fafObj.id;
            insert ClientInfoObj;
            
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
                      
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            insert RGCO;
            
            Central_Hub__c FAFObj2= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
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
    
            //Pass the parameters from the VF page
            test.starttest();
            PageReference pageRef = Page.RebateGteesCarveOutsNewEditPage;
            Test.setCurrentPage(pageRef);
            //pageRef.getParameters().put('id',RGCO.id); 
            pageRef.getParameters().put(Label.rebateCarveOutCustLab,rebOpsObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(RGCO);
            RebateGteesCarveOutsNewEditClass  controller = new RebateGteesCarveOutsNewEditClass (sc);
            controller.percentBool= true;
            controller.saveUpdaterebCarOutObj();
            controller.percentBool= false;
            controller.saveUpdaterebCarOutObj();
             
    
            test.stoptest();
        }
    }
    //Method 1 to pass the parameters
    @isTest
    static void RebateGteesCarveOutsNewEditClassTestMeth5()
    {
      User useObj = TestDataFactory.createUser('Apttus Underwriting');
      insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
        
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            system.debug('============FAFObj.id============'+FAFObj.id);
            
            
            
            //Create Rebate Operations Record 
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            rebOpsObj.Class_Carve_Out_Guarantee_Percentage__c = false;
            insert rebOpsObj;
            
            
            Client_Information__c ClientInfoObj = TestDataFactory.createClientInfo(FAFObj.id); 
            insert ClientInfoObj;
                     
            //Create Rebate Gtees Specialty Class Carve Outs Record 
            Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(rebOpsObj.id,FAFObj.id);
            RGCO.Specialty_Dollar_Amount__c = null;
            RGCO.Specialty_Retail_Dollar_Amt__c = null;
            //RGCO.Specialty_Dollar_Amount__c = null;
            //RGCO.Specialty_Retail_Dollar_Amt__c = null
            insert RGCO;
            
            Central_Hub__c FAFObj2= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
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
    
            //Pass the parameters from the VF page
            test.starttest();
            PageReference pageRef = Page.RebateGteesCarveOutsNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',null); 
            pageRef.getParameters().put(Label.rebateCarveOutCustLab, rebOpsObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(RGCO);
            RebateGteesCarveOutsNewEditClass controller = new RebateGteesCarveOutsNewEditClass (sc);
            //controller.percentBool= true;
            controller.saveUpdaterebCarOutObj();
            //controller.percentBool= false;
            //controller.saveUpdaterebCarOutObj();
             
    
            test.stoptest();
        }
    }
}