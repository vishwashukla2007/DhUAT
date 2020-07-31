/* ================================================
 * @Class Name : ContentDocumentLinkTriggerHelperTest
 * @author : Accenture
 * @Purpose: Test Class for Handler class of TR_User_PubliGrpAssignment
 * @created date:08/07/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class ContentDocumentLinkTriggerHelperTest{


    /* ================================================
     * @Method Name : ContentDocumentLinkTriggerHelperTestMethod1
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/07/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void ContentDocumentLinkTriggerHelperTestMethod1(){  
    
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
            
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOpsOfferIngType(FAFObj.id);
            insert rebOpsObj;
            
            Rebate_Guarantees__c rebateGuarantees = TestDataFactory.createRebateGuarantee(FAFObj.id,rebOpsObj.id);
            insert rebateGuarantees;
            
            Guarantees_Information__c  gurateeinfoObj= TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert  gurateeinfoObj;
            
            Test.startTest();
             
            ContentVersion content=new ContentVersion(); 
            content.Title='Header_Picture1'; 
            content.PathOnClient='/' + content.Title + '.jpg'; 
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            content.VersionData=bodyBlob; 
            content.origin = 'H';
            insert content;
            
            ContentVersion content1=new ContentVersion(); 
            content1.Title='Header_Picture2'; 
            content1.PathOnClient='/' + content1.Title + '.jpg'; 
            Blob bodyBlob1=Blob.valueOf('Unit Test Content123Version Body'); 
            content1.VersionData=bodyBlob1; 
            content1.origin = 'H';
            insert content1;
            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=gurateeinfoObj.id;
            contentlink.ShareType= 'v';
            contentlink.LinkedEntityId = gurateeinfoObj.Id; 
            contentlink.ContentDocumentId=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
            contentlink.Visibility = 'AllUsers'; 
            
            ContentDocumentLink contentlink1=new ContentDocumentLink();
            contentlink1.LinkedEntityId=gurateeinfoObj.id;
            contentlink1.ShareType= 'v';
            contentlink1.LinkedEntityId = gurateeinfoObj.Id; 
            contentlink1.ContentDocumentId=[select contentdocumentid from contentversion where id =: content1.id].contentdocumentid;
            contentlink1.Visibility = 'AllUsers'; 
            
            List<ContentDocumentLink> cdlist=new List<ContentDocumentLink>();
            cdlist.add(contentlink);
            cdlist.add(contentlink1);
            insert cdlist;
            
            ContentDocumentLinkTriggerHelper.blockmultipleRecordInsertion(cdlist);
              system.assertEquals(cdlist.size(),2);
            Test.stopTest();
            
        }
    }
    
     /* ================================================
     * @Method Name : ContentDocumentLinkTriggerHelperTestMethod2
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:08/07/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void ContentDocumentLinkTriggerHelperTestMethod2(){  
    
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
            Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOpsOfferIngType(FAFObj.id);
            insert rebOpsObj;
            
            Guarantees_Information__c  gurateeinfoObj= TestDataFactory.createGuaranteeInfo(FAFObj.id);
            insert  gurateeinfoObj;
            
            Billing_Operations__c billOpsObj =  TestDataFactory.createBillOps(FAFObj.id);
            insert billOpsObj;
            
            Medicare_Part_D_Fees_Schedule__c mfdScheduleObj=TestDataFactory.createMedifeescheduled(billOpsObj.id,FAFObj.id);
            insert mfdScheduleObj;
            
            Test.startTest();
             
            ContentVersion content=new ContentVersion(); 
            content.Title='Header_Picture1'; 
            content.PathOnClient='/' + content.Title + '.jpg'; 
            Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
            content.VersionData=bodyBlob; 
            content.origin = 'H';
            insert content;
            
            ContentVersion content1=new ContentVersion(); 
            content1.Title='Header_Picture2'; 
            content1.PathOnClient='/' + content1.Title + '.jpg'; 
            Blob bodyBlob1=Blob.valueOf('Unit Test Content123Version Body'); 
            content1.VersionData=bodyBlob1;
            content1.origin = 'H';
            insert content1;
            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=mfdScheduleObj.id;
            contentlink.ShareType= 'v';
            contentlink.LinkedEntityId = mfdScheduleObj.Id; 
            contentlink.ContentDocumentId=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
            contentlink.Visibility = 'AllUsers'; 
            
            ContentDocumentLink contentlink1=new ContentDocumentLink();
            contentlink1.LinkedEntityId=mfdScheduleObj.id;
            contentlink1.ShareType= 'v';
            contentlink1.LinkedEntityId = mfdScheduleObj.Id; 
            contentlink1.ContentDocumentId=[select contentdocumentid from contentversion where id =: content1.id].contentdocumentid;
            contentlink1.Visibility = 'AllUsers'; 
            
            List<ContentDocumentLink> cdlist=new List<ContentDocumentLink>();
            cdlist.add(contentlink);
            cdlist.add(contentlink1);
            insert cdlist;
            
            ContentDocumentLinkTriggerHelper.blockmultipleRecordInsertion(cdlist);
            
            system.assertEquals(cdlist.size(),2);
            Test.stopTest();
            
        }
    }

}