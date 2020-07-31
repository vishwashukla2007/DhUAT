/* ================================================
 * @Class Name : MedicareFeesScheduleNewEditClassTest
 * @author : Accenture
 * @Purpose: Test Class for Handler class of TR_User_PubliGrpAssignment
 * @created date:07/20/2018
 * @Last modified date:
 * @Last modified by : Accenture
================================================*/
@isTest
public with sharing class MedicareFeesScheduleNewEditClassTest{


   /* ================================================
     * @Method Name : MedicareFeesScheduleNewEditClassTestMethod1
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:07/20/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
   @isTest
    static void MedicareFeesScheduleNewEditClassTestMethod1(){
    
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
        Billing_Operations__c billingobj=TestDataFactory.createBillOps(FAFObj.id);
        insert billingobj;
        
        FAFObj.LOB2__c = 'ACT';
        FAFObj.Peer_Reviewed__c = true;
        FAFObj.Approved_By_Sales__c = true;
        FAFObj.Peer_Reviewer__c  = useObj.id;
        FAFObj.Sales_Approver__c = useObj.id;
         FAFObj.Initiate_FAF_Release__c=false;
        FAFObj.Underwriter__c=useObj.id;
        update FAFObj;
        Medicare_Part_D_Fees_Schedule__c mediObj=TestDataFactory.createMedifeescheduled(billingobj.id,FAFObj.id);
        insert mediObj;
        Test.StartTest();
        PageReference pageRef = Page.MedicareFeesScheduleNewEditPage; 
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',mediObj.id);
        pageRef.getParameters().put(Label.medicareScheduleFeeLable,billingobj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(mediObj);
        MedicareFeesScheduleNewEditClass md=new MedicareFeesScheduleNewEditClass(sc);
        md.saveUpdateMFS();
        Test.StopTest();
        }
       
    }
    /* ================================================
     * @Method Name : MedicareFeesScheduleNewEditClassTestMethod2
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:07/20/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest 
    static void MedicareFeesScheduleNewEditClassTestMethod2(){
     
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
        FAFObj.LOB2__c = 'ACT';
        insert FAFObj;
        Billing_Operations__c billingobj=TestDataFactory.createBillOps(FAFObj.id);
        insert billingobj;
        Medicare_Part_D_Fees_Schedule__c mediObj=TestDataFactory.createMedifeescheduled(billingobj.id,FAFObj.id);
        insert mediObj;
        Test.StartTest();PageReference pageRef = Page.MedicareFeesScheduleNewEditPage; 
        Test.setCurrentPage(pageRef);
       // pageRef.getParameters().put('id',mediObj.id);
        pageRef.getParameters().put(Label.medicareScheduleFeeLable,billingobj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(mediObj);
        MedicareFeesScheduleNewEditClass md=new MedicareFeesScheduleNewEditClass(sc);
        md.saveUpdateMFS();
        Test.StopTest();
        //System.assertEquals(useObj1.isActive,false);
      }
    }
    /* ================================================
     * @Method Name : MedicareFeesScheduleNewEditClassTestMethod3
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:07/20/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
     @isTest static void MedicareFeesScheduleNewEditClassTestMethod3(){
     
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
        Billing_Operations__c billingobj=TestDataFactory.createBillOps(FAFObj.id);
        insert billingobj;
        Medicare_Part_D_Fees_Schedule__c mediObj=TestDataFactory.createMedifeescheduled(billingobj.id,FAFObj.id);
        insert mediObj;
        Test.StartTest();PageReference pageRef = Page.MedicareFeesScheduleNewEditPage; 
        Test.setCurrentPage(pageRef);
       // pageRef.getParameters().put('id',mediObj.id);
        pageRef.getParameters().put(Label.medicareScheduleFeeLable,billingobj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(mediObj);
        MedicareFeesScheduleNewEditClass md=new MedicareFeesScheduleNewEditClass(sc);
        md.saveUpdateMFS();
        Test.StopTest();
        //System.assertEquals(useObj1.isActive,false);
      }
    }
    /* ================================================
     * @Method Name : MedicareFeesScheduleNewEditClassTestMethod4
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:07/20/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
     @isTest static void MedicareFeesScheduleNewEditClassTestMethod4(){
     
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
        
        Billing_Operations__c billingobj=TestDataFactory.createBillOps(FAFObj.id);
        insert billingobj;
        
        FAFObj.Peer_Reviewed__c = true;
        FAFObj.Approved_By_Sales__c = true;
        FAFObj.Peer_Reviewer__c  = useObj.id;
        FAFObj.Sales_Approver__c = useObj.id;
        FAFObj.Initiate_FAF_Release__c=false;
        FAFObj.Underwriter__c=useObj.id;
        update FAFObj;
        Medicare_Part_D_Fees_Schedule__c mediObj=TestDataFactory.createMedifeescheduled(billingobj.id,FAFObj.id);
        insert mediObj;
        Test.StartTest();PageReference pageRef = Page.MedicareFeesScheduleNewEditPage; 
        Test.setCurrentPage(pageRef);
       // pageRef.getParameters().put('id',mediObj.id);
        pageRef.getParameters().put(Label.medicareScheduleFeeLable,billingobj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(mediObj);
        MedicareFeesScheduleNewEditClass md=new MedicareFeesScheduleNewEditClass(sc);
        md.saveUpdateMFS();
        Test.StopTest();
        }
    }
    /* ================================================
     * @Method Name : MedicareFeesScheduleNewEditClassTestMethod5
     * @author : Accenture
     * @Purpose: Test methood to cover insert method
     * @Parameters: NA
     * @return: Void
     * @created date:07/20/2018
     * @Last modified date:
     * @Last modified by : Accenture
    ================================================*/
    @isTest
    static void MedicareFeesScheduleNewEditClassTestMethod5(){
    
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
        Billing_Operations__c billingobj=TestDataFactory.createBillOps(FAFObj.id);
        insert billingobj;
        FAFObj.Peer_Reviewed__c = true;
        FAFObj.Approved_By_Sales__c = true;
        FAFObj.Peer_Reviewer__c  = useObj.id;
        FAFObj.Sales_Approver__c = useObj.id;
         FAFObj.Initiate_FAF_Release__c=false;
        FAFObj.Underwriter__c=useObj.id;
        update FAFObj;
        Medicare_Part_D_Fees_Schedule__c mediObj=TestDataFactory.createMedifeescheduled(billingobj.id,FAFObj.id);
        insert mediObj;
        Test.StartTest();
        PageReference pageRef = Page.MedicareFeesScheduleNewEditPage; 
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',mediObj.id);
        pageRef.getParameters().put(Label.medicareScheduleFeeLable,billingobj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(mediObj);
        MedicareFeesScheduleNewEditClass md=new MedicareFeesScheduleNewEditClass(sc);
        md.operationType = 'clone';
        md.saveUpdateMFS();
        Test.StopTest();
        }
       
    }
}