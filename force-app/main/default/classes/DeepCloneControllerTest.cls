/*********************************************************************************************
 * @ClassName         : DeepCloneControllerTest
 * @author            : Accenture
 * @created date      : 29/08/2018
 * @Last modified by  : Accenture
 * @Last modified date: 29/08/2018
 * @Purpose           : For increase the class coverage 
 **********************************************************************************************/
@isTest
public with sharing class DeepCloneControllerTest{
    @isTest 
    static void DeepCloneControllerMeth1(){
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
            
            Billing_Operations__c billingObj = TestDataFactory.createBillOps(FAFObj.id);
            insert billingObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.searchCategory = 'NO';
            controller.OpportunityValue = oppObj.id;
            controller.AccountValue = accObj.id;
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    
    @isTest 
    static void DeepCloneControllerMeth4(){
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
            
            Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
            insert netOpsObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.searchCategory = 'NO';
            controller.OpportunityValue = oppObj.id;
            controller.AccountValue = accObj.id;
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    
    @isTest 
    static void DeepCloneControllerMeth5(){
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
            
            Mail_Operations__c mailOpsObj = TestDataFactory.createMailOperation(FAFObj.id);
            insert mailOpsObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.searchCategory = 'NO';
            controller.OpportunityValue = oppObj.id;
            controller.AccountValue = accObj.id;
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    
    @isTest 
    static void DeepCloneControllerMeth2(){
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
            
            Guarantees_Information__c guarntObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert guarntObj;
            
            Clinical_Operations__c clinicalObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalObj;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    
    @isTest 
    static void DeepCloneControllerMeth3(){
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
            
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.searchCategory = 'NO';
            controller.OpportunityValue = oppObj.id;
            controller.AccountValue = accObj.id;
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    
    @isTest 
    static void DeepCloneControllerMeth6(){
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
            
            Specialty_Operations__c spOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert spOpsObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.searchCategory = 'NO';
            controller.OpportunityValue = oppObj.id;
            controller.AccountValue = accObj.id;
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    
    @isTest 
    static void DeepCloneControllerMeth7(){
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
            
            Guarantees_Information__c guarntObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert guarntObj;
            
            Clinical_Operations__c clinicalObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            controller.searchCategory ='Yes';
            controller.PlatformSpecifics=true;
            controller.OpportunityValue = oppObj.id;
            controller.AccountValue = accObj.id;
            controller.enablePicklist();
            controller.cloneFafrecord();
            test.stoptest();
        }
    }
    @isTest 
    static void DeepCloneControllerMeth8(){
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
            
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            
            Guarantees_Information__c guarntObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert guarntObj;
            
            Clinical_Operations__c clinicalObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
              Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
            insert netOpsObj;
            
             Network_Operations__c netOpsObj1= TestDataFactory.createNetworkOperation(FAFObj1.id);
            insert netOpsObj1;
            
            Specialty_Operations__c sops= TestDataFactory.createSpeciality(FAFObj.id);
            insert sops;
            
            Specialty_Operations__c sops1= TestDataFactory.createSpeciality(FAFObj1.id);
            insert sops1;
            
            Specialty_Pricing__c spric=TestDataFactory.createspecPricingObject(FAFObj1.id,sops.id);
            insert spric;
            
            Specialty_Pricing__c spric2=TestDataFactory.createspecPricingObject(FAFObj.id,sops1.id);
            insert spric2;
            
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAFObj.id);
            insert rebOpsObj;
            
            Rebate_Operations__c rebOpsObj1 = TestDataFactory.createRebOps(FAFObj1.id);
            insert rebOpsObj1;
            
            Network_Pricing__c np1 = new Network_Pricing__c();
            np1.FAF_ID__c = FAFObj.Id;
            np1.FAF_Network_Ops__c = netOpsObj.Id;
            np1.Retail_Network_Ordinal__c = 'Primary';
            np1.Year__c = 'All';
            np1.LOB__c = 'ACT';
            np1.Network_Name__c = 'MC(84-90)CP';
            np1.Brand_Rate__c = 5;
            insert np1;
            
            Network_Pricing__c np2 = new Network_Pricing__c();
            np2.FAF_ID__c = FAFObj.Id;
            np2.FAF_Network_Ops__c =netOpsObj.Id;
            np2.Retail_Network_Ordinal__c = 'Secondary';
            np2.Year__c = 'All';
            np2.LOB__c = 'ACT';
            np2.Network_Name__c = 'MC(84-90)CP';
            np2.Brand_Rate__c = 5;
           // insert np2;
            
            Map<ID,ID> mpna =new Map<ID,ID>();
            mpna.put(np1.id,np2.id);
            
            Map<ID,ID> mpnop =new Map<ID,ID>();
            mpna.put(netOpsObj.id,netOpsObj1.id);
            
            Map<ID,ID> mpsoop =new Map<ID,ID>();
            mpsoop.put(sops.id,sops1.id);
            
            Map<ID,ID> mproop =new Map<ID,ID>();
            mproop.put(rebOpsObj.id,rebOpsObj1.id);
            
            Map<ID,ID> mpspric =new Map<ID,ID>();
            mpspric.put(spric.id,spric2.id);
            
            Map<ID,ID> rebateOpmap =new Map<ID,ID>();
            mpspric.put(rebOpsObj.id,rebOpsObj1.id);
            
            
             Map<String, String> fieldsToResetChild = new Map<String, String>();
             fieldsToResetChild.put('Brand_Rate__c',null);
             fieldsToResetChild.put('Preferred_Brand_Rate__c',null);
             fieldsToResetChild.put('Non_Preferred_Brand_Rate__c',null);
             fieldsToResetChild.put('Generic_Rate__c',null);
             fieldsToResetChild.put('Non_MAC_Generic_Rate__c',null);
             fieldsToResetChild.put('Generic_Dispensing_Fee__c',null);
             fieldsToResetChild.put('Brand_Dispensing_Fee__c',null);
             fieldsToResetChild.put('Network_Type__c','PCD');
             //fieldsToResetChild.put('Agreement_Line_Item__c',Ops[0].Agreement_Line_Item__c);
             fieldsToResetChild.put('PCDQSCreation__c','FALSE');
              fieldsToResetChild.put('Pharmacy_Benefit__c','None');
              fieldsToResetChild.put('Agreement_Line_Item__c','  ');
              fieldsToResetChild.put('Plan_Design__c',' ');
              fieldsToResetChild.put('Network_Pricing__c','  ');
               fieldsToResetChild.put('Retail_30__c','  ');
               fieldsToResetChild.put('Mail__c','  ');
              
             
             fieldsToResetChild.put('Source_Record_ID__c', null);
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
   /*        DeepCloneUtility.PCDcloneRelatedSObject('Retail_Network_Guarantees__c',
                                                    'Network_Pricing__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                        'Network_Pricing__c'=> new Map<Id, Id>{np1.id => np2.id },
                                                                                'Network_Pricing__c'=>mpna
                                                                                }, null,fieldsToResetChild,null);
            
            DeepCloneUtility.PCDcloneRelatedSObject('Network_Pricing__c',
                                                    'FAF_ID__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                        'FAF_ID__c'=> new Map<Id, Id>{FAFObj.id => FAFObj.id },
                                                                                'FAF_Network_Ops__c'=>mpnop
                                                                                }, null,fieldsToResetChild,null);
                                                                                
            DeepCloneUtility.PCDcloneRelatedSObject('Specialty_Pricing__c',
                                                    'FAF_ID__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                        'FAF_ID__c'=> new Map<Id, Id>{FAFObj.id => FAFObj.id },
                                                                                'Specialty_Operations__c'=>mpsoop
                                                                                }, null,fieldsToResetChild,null);
                                                                                
            DeepCloneUtility.PCDcloneRelatedSObject('Rebate_Guarantees__c',
                                                    'FAF_ID__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                        'FAF_ID__c'=> new Map<Id, Id>{FAFObj.id => FAFObj.id },
                                                                                'Specialty_Operations__c'=>mproop
                                                                                }, null,fieldsToResetChild,null);
                                                                                
            
            
            DeepCloneUtility.PCDcloneRelatedSObject('Specialty_Guarantee__c',
                                                    'Specialty_Pricing__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                     'Specialty_Pricing__c'=> new Map<Id, Id>{spric.id => spric2.id },
                                                                                'Specialty_Pricing__c'=>mpspric
                                                                                }, null,fieldsToResetChild,null);
            
             DeepCloneUtility.PCDcloneRelatedSObject('Rebate_Guarantees__c',
                                                    'Rebate_Operations__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                     'Rebate_Operations__c'=> new Map<Id, Id>{rebOpsObj.id => rebOpsObj1.id },
                                                                                'Rebate_Operations__c'=>rebateOpmap
                                                                                }, null,fieldsToResetChild,null); */
            
            
          
            test.stoptest();
        }
    } 
    
    @isTest 
    static void DeepCloneControllerMeth9(){
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
            
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
            insert clientINFO;
            
            Guarantees_Information__c guarntObj = TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert guarntObj;
            
            Clinical_Operations__c clinicalObj = TestDataFactory.createGClinicalOperaiton(FAFObj.id);
            insert clinicalObj;
            
            List<FAFDeepClone__c> deepCloneList = TestDataFactory.createDeepCloneCustSettng();
            insert deepCloneList;
            
              Network_Operations__c netOpsObj = TestDataFactory.createNetworkOperation(FAFObj.id);
            insert netOpsObj;
            
             Network_Operations__c netOpsObj1= TestDataFactory.createNetworkOperation(FAFObj1.id);
            insert netOpsObj1;
            
            Specialty_Operations__c sops= TestDataFactory.createSpeciality(FAFObj.id);
            insert sops;
            
            Specialty_Operations__c sops1= TestDataFactory.createSpeciality(FAFObj1.id);
            insert sops1;
            
          
            
            Network_Pricing__c np1 = new Network_Pricing__c();
            np1.FAF_ID__c = FAFObj.Id;
            np1.FAF_Network_Ops__c = netOpsObj.Id;
            np1.Retail_Network_Ordinal__c = 'Primary';
            np1.Year__c = 'All';
            np1.LOB__c = 'ACT';
            np1.Network_Name__c = 'MC(84-90)CP';
            np1.Brand_Rate__c = 5;
            insert np1;
            
            Network_Pricing__c np2 = new Network_Pricing__c();
            np2.FAF_ID__c = FAFObj.Id;
            np2.FAF_Network_Ops__c =netOpsObj.Id;
            np2.Retail_Network_Ordinal__c = 'Secondary';
            np2.Year__c = 'All';
            np2.LOB__c = 'ACT';
            np2.Network_Name__c = 'MC(84-90)CP';
            np2.Brand_Rate__c = 5;
          //  insert np2;
            
         
            
            Map<ID,ID> mpsoop =new Map<ID,ID>();
            mpsoop.put(sops.id,sops1.id);
        
            
             Map<String, String> fieldsToResetChild = new Map<String, String>();
             fieldsToResetChild.put('Brand_Rate__c',null);
             fieldsToResetChild.put('Preferred_Brand_Rate__c',null);
             fieldsToResetChild.put('Non_Preferred_Brand_Rate__c',null);
             fieldsToResetChild.put('Generic_Rate__c',null);
             fieldsToResetChild.put('Non_MAC_Generic_Rate__c',null);
             fieldsToResetChild.put('Generic_Dispensing_Fee__c',null);
             fieldsToResetChild.put('Brand_Dispensing_Fee__c',null);
             fieldsToResetChild.put('Network_Type__c','PCD');
             //fieldsToResetChild.put('Agreement_Line_Item__c',Ops[0].Agreement_Line_Item__c);
             fieldsToResetChild.put('PCDQSCreation__c','FALSE');
              fieldsToResetChild.put('Pharmacy_Benefit__c','None');
              fieldsToResetChild.put('Agreement_Line_Item__c','  ');
              fieldsToResetChild.put('Plan_Design__c',' ');
              fieldsToResetChild.put('Network_Pricing__c','  ');
               fieldsToResetChild.put('Retail_30__c','  ');
               fieldsToResetChild.put('Mail__c','  ');
              
             
             fieldsToResetChild.put('Source_Record_ID__c', null);
            test.starttest();
            
            PageReference pageRef = Page.DeepClonePage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FAFObj.id);
            ApexPages.StandardController sc = new ApexPages.standardController(FAFObj);
            DeepCloneController controller = new DeepCloneController(sc);
            DeepCloneController controller1 = new DeepCloneController();
            
                                                                                
     /*        DeepCloneUtility.PCDcloneRelatedSObject('Specialty_Pricing__c',
                                                    'FAF_ID__c', 
                                                     new Map<String, Map<Id, Id>> {
                                                        'FAF_ID__c'=> new Map<Id, Id>{FAFObj.id => FAFObj.id },
                                                                                'Specialty_Operations__c'=>mpsoop
                                                                                }, null,fieldsToResetChild,null);   */
              
            
            
          
            test.stoptest();
        }
    }
}