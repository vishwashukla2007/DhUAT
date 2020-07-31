/*********************************************************************************************
* @author   Akanksha Singh
* @date     18 07 2018
* @description:This is the testclass for the class BillAncillaryNewEditClass   
 **********************************************************************************************/
@isTest
public with sharing class BillAncillaryNewEditClassTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void BillAncillaryNewEditClassTestMeth1()
    {
        //Create a user with Apttus Underwriting Profile
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
            system.debug('=======FAFObj======='+FAFObj);
            
            Client_Information__c ClientInfoObj = TestDataFactory.createClientInfo(FAFObj.id); 
            insert ClientInfoObj;
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
           // insert ancObj;
           // ancObj.
           
            //Create 2nd Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);         
            //insert ancObj1;
            
            list<Billing_Ancillary_Fee__c> billancList = new list<Billing_Ancillary_Fee__c>();
            billancList.add(ancObj);
            billancList.add(ancObj1);
            database.insert(billancList);
             
            
            
            Central_Hub__c FAFObj2= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
           /* Client_Information__c clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
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
           */
            //Pass the parameters from the VF page
            test.starttest();
            database.update(billancList);
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.Id);
            ApexPages.StandardController sc = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller = new BillAncillaryNewEditClass (sc);
            controller.FeeAmountAction();
            controller.FeeAdditiveAction();
            controller.changeAction();
            controller.saveUpdateBAF();
            test.stoptest();
        }
    }
    

    @isTest
    static void BillAncillaryNewEditClassTestMeth2()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            Client_Information__c ClientInfoObj = TestDataFactory.createClientInfo(FAFObj.id); 
            insert ClientInfoObj;
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            //ancObj1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAdministrativeFeesNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller = new BillAncillaryNewEditClass (sc);
            
            system.debug('############Feebasic########' + ancObj.Fee_Basis__c+'##Lob###'+ ancObj.LOB2__c+'$$$years'+ancObj.Year__c+'type'+admobj.Admin_Fee_Type__c);
            controller.FeeAmountAction();
            controller.FeeAdditiveAction();
            controller.changeAction();
            controller.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Retail Per Claim';
            admobj.Base_Amount__c=0;
            update admObj;
            
            
            ApexPages.StandardController sc1 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller1 = new BillAncillaryNewEditClass (sc1);
            controller1.FeeAmountAction();
            controller1.FeeAdditiveAction();
            controller1.changeAction();
            controller1.saveUpdateBAF();
            
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Mail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Coordination of Benefits – Mail Electronic';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Mail Per Claim';
            admobj.Base_Amount__c=0;
            update admObj;
            
            ApexPages.StandardController sc2 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller2 = new BillAncillaryNewEditClass (sc2);
            controller2.FeeAmountAction();
            controller2.FeeAdditiveAction();
            controller2.changeAction();
            controller2.saveUpdateBAF();
            
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Mail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Coordination of Benefits – Mail Electronic';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            
            ApexPages.StandardController sc3 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller3 = new BillAncillaryNewEditClass (sc3);
            controller3.FeeAmountAction();
            controller3.FeeAdditiveAction();
            controller3.changeAction();
            controller3.saveUpdateBAF();
            
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Paper Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Coordination of Benefits – Paper';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Paper per Claim';
            admobj.Base_Amount__c=0;
            update admObj;
            
            ApexPages.StandardController sc4 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller4 = new BillAncillaryNewEditClass (sc4);
            controller4.FeeAmountAction();
            controller4.FeeAdditiveAction();
            controller4.changeAction();
            controller4.saveUpdateBAF();
                       
            test.stoptest();          
            }
            
        }
         @isTest
    static void BillAncillaryNewEditClassTestMeth3()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            //ancObj1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
            ApexPages.StandardController sc12 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller12 = new BillAncillaryNewEditClass (sc12);
            controller12.FeeAmountAction();
            controller12.FeeAdditiveAction();
            controller12.changeAction();
            controller12.saveUpdateBAF();
            
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Booklet';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Standard Marketing & 1 Pg of PDL Sheet';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc13 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller13 = new BillAncillaryNewEditClass (sc13);
            controller13.FeeAmountAction();
            controller13.FeeAdditiveAction();
            controller13.changeAction();
            controller13.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Page';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Custom Materials';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc14= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller14= new BillAncillaryNewEditClass (sc14);
            controller14.FeeAmountAction();
            controller14.FeeAdditiveAction();
            controller14.changeAction();
            controller14.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Envelope';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Assembly Costs';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc15= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller15= new BillAncillaryNewEditClass (sc15);
            controller15.FeeAmountAction();
            controller15.FeeAdditiveAction();
            controller15.changeAction();
            controller15.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Oz.';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Postage 1st Oz. (6 Sheets)';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc16= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller16= new BillAncillaryNewEditClass (sc16);
            controller16.FeeAmountAction();
            controller16.FeeAdditiveAction();
            controller16.changeAction();
            controller16.saveUpdateBAF();
            
                       
            test.stoptest();
         }
    }
    
       @isTest
    static void BillAncillaryNewEditClassTestMeth4()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            //ancObj1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
            ApexPages.StandardController sc12 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller12 = new BillAncillaryNewEditClass (sc12);
            controller12.FeeAmountAction();
            controller12.FeeAdditiveAction();
            controller12.changeAction();
            controller12.saveUpdateBAF();
            
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Decentralized Administration';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sca1 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj2 = new BillAncillaryNewEditClass (sca1);
            controllerObj2.FeeAmountAction();
            controllerObj2.FeeAdditiveAction();
            controllerObj2.changeAction();
            controllerObj2.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Toll Free Member Services';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scc= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj3= new BillAncillaryNewEditClass (scc);
            controllerObj3.FeeAmountAction();
            controllerObj3.FeeAdditiveAction();
            controllerObj3.changeAction();
            controllerObj3.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Transaction Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Electronic Managed Access';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scd= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj4= new BillAncillaryNewEditClass (scd);
            controllerObj4.FeeAmountAction();
            controllerObj4.FeeAdditiveAction();
            controllerObj4.changeAction();
            controllerObj4.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Group Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Client Set Up';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sce= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj5= new BillAncillaryNewEditClass (sce);
            controllerObj5.FeeAmountAction();
            controllerObj5.FeeAdditiveAction();
            controllerObj5.changeAction();
            controllerObj5.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Claim Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Electronic Coordination of Benefits';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scf= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj6= new BillAncillaryNewEditClass (scf);
            controllerObj6.FeeAmountAction();
            controllerObj6.FeeAdditiveAction();
            controllerObj6.changeAction();
            controllerObj6.saveUpdateBAF();
                       
            test.stoptest();
        }
    }
    @isTest
    static void BillAncillaryNewEditClassTestMeth5()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create 2nd CentralHub Record 
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            //Create 2nd Billing Operations Record 
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            

            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
           // insert ancObj;
           
            
            //Create 2nd Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj1 = TestDataFactory.createBillAncillary(FAFObj1.id,bilOpsObj1.id);
            //insert ancObj1;
            ancObj1.LOB2__c='RU';
            ancObj1.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj1.Ancillary_Fee_Type__c='Claim Fees';
            ancObj1.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj1.Year__c='2';
            ancObj1.Fee_Amount__c=0;
           // update ancObj1;
           
          
           
           //Create 3rd Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj3 = TestDataFactory.createBillAncillary(FAFObj1.id,bilOpsObj1.id);
            //insert ancObj3;
            ancObj3.LOB2__c='CAP';
            ancObj3.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj3.Ancillary_Fee_Type__c='Claim Fees';
            ancObj3.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj3.Year__c='2';
            ancObj3.Fee_Amount__c=0;
           // update ancObj3;
            
            //Create 4rth Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj4 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj4;
            ancObj4.LOB2__c='CAP';
            ancObj4.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj4.Ancillary_Fee_Type__c='Claim Fees';
            ancObj4.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj4.Year__c='All';
            ancObj4.Fee_Amount__c=0;
            
            list<Billing_Ancillary_Fee__c>  bilancList = new list<Billing_Ancillary_Fee__c>();
            bilancList.add(ancObj);
            bilancList.add(ancObj1);
            bilancList.add(ancObj3);
            bilancList.add(ancObj4);
                       
            test.starttest();
            insert bilancList;
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
            ApexPages.StandardController sc12 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller12 = new BillAncillaryNewEditClass (sc12);
            controller12.FeeAmountAction();
            controller12.FeeAdditiveAction();
            controller12.changeAction();
            controller12.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Pharmacy Directories, On Line';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scm1= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj14= new BillAncillaryNewEditClass (scm1);
            controllerObj14.FeeAmountAction();
            controllerObj14.FeeAdditiveAction();
            controllerObj14.changeAction();
            controllerObj14.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Pharmacy Help Desk for Pharmacists';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scm2= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj15= new BillAncillaryNewEditClass (scm2);
            controllerObj15.FeeAmountAction();
            controllerObj15.FeeAdditiveAction();
            controllerObj15.changeAction();
            controllerObj15.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Physician Connectivity';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scm3= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj16= new BillAncillaryNewEditClass (scm3);
            controllerObj16.FeeAmountAction();
            controllerObj16.FeeAdditiveAction();
            controllerObj16.changeAction();
            controllerObj16.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='RxHub/Caremark Connected Network';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scm4= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj17= new BillAncillaryNewEditClass (scm4);
            controllerObj17.FeeAmountAction();
            controllerObj17.FeeAdditiveAction();
            controllerObj17.changeAction();
            controllerObj17.saveUpdateBAF();
            
            
                                   
            test.stoptest();
                
        Billing_Ancillary_Fee__c billAncFee = [Select id,Ancillary_Fee_Description__c from Billing_Ancillary_Fee__c where Fee_Basis__c =: ancObj.Fee_Basis__c limit 1];
        System.assertEquals(billAncFee.Ancillary_Fee_Description__c, 'RxHub/Caremark Connected Network');
        }
    }
     @isTest
    static void BillAncillaryNewEditClassTestMeth6()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create 2nd CentralHub Record 
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            //Create 2nd Billing Operations Record 
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            

            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
           
            
           
            test.starttest();
            
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
            ApexPages.StandardController sc71 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller71 = new BillAncillaryNewEditClass (sc71);
            controller71.FeeAmountAction();
            controller71.FeeAdditiveAction();
            controller71.changeAction();
            controller71.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Programming Hour Fee';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='Client Specific Programming';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= 150;
            update ancObj;
            
            
            ApexPages.StandardController sc8 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller8 = new BillAncillaryNewEditClass (sc8);
            controller8.FeeAmountAction();
            controller8.FeeAdditiveAction();
            controller8.changeAction();
            controller8.saveUpdateBAF();
            
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per File';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='PA File';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
            ApexPages.StandardController sc81 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller81 = new BillAncillaryNewEditClass (sc81);
            controller81.FeeAmountAction();
            controller81.FeeAdditiveAction();
            controller81.changeAction();
            controller81.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per File';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='PA File';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= 3500;
            update ancObj;
            
            ApexPages.StandardController sc82 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller82 = new BillAncillaryNewEditClass (sc82);
            controller82.FeeAmountAction();
            controller82.FeeAdditiveAction();
            controller82.changeAction();
            controller82.saveUpdateBAF();
            
          ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Member Services';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
            ApexPages.StandardController sc83 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller83 = new BillAncillaryNewEditClass (sc83);
            controller83.FeeAmountAction();
            controller83.FeeAdditiveAction();
            controller83.changeAction();
            controller83.saveUpdateBAF();
                       
            test.stoptest();
            
        Billing_Ancillary_Fee__c billAncFee = [Select id,Ancillary_Fee_Description__c from Billing_Ancillary_Fee__c where Fee_Basis__c =: ancObj.Fee_Basis__c limit 1];
        System.assertEquals(billAncFee.Ancillary_Fee_Description__c,'Member Services');
        }
    }
    @isTest
    static void BillAncillaryNewEditClassTestMeth7()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create 2nd CentralHub Record 
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            //Create 2nd Billing Operations Record 
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            

            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
           
            
           
            test.starttest();
            
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
            ApexPages.StandardController sc72 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller72 = new BillAncillaryNewEditClass (sc72);
            controller72.FeeAmountAction();
            controller72.FeeAdditiveAction();
            controller72.changeAction();
            controller72.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Website';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Co-Branded Website';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc73 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller73 = new BillAncillaryNewEditClass (sc73);
            controller73.FeeAmountAction();
            controller73.FeeAdditiveAction();
            controller73.changeAction();
            controller73.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Booklet';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Standard Marketing & 1 Pg of PDL Sheet';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc74 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller74 = new BillAncillaryNewEditClass (sc74);
            controller74.FeeAmountAction();
            controller74.FeeAdditiveAction();
            controller74.changeAction();
            controller74.saveUpdateBAF();
            
           ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Page';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Custom Materials';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc75 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller75 = new BillAncillaryNewEditClass (sc75);
            controller75.FeeAmountAction();
            controller75.FeeAdditiveAction();
            controller75.changeAction();
            controller75.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Envelope';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Assembly Costs';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
                        
            
            ApexPages.StandardController sc76 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller76 = new BillAncillaryNewEditClass (sc76);
            controller76.FeeAmountAction();
            controller76.FeeAdditiveAction();
            controller76.changeAction();
            controller76.saveUpdateBAF();
            
           
            test.stoptest();
            
        Billing_Ancillary_Fee__c billAncFee = [Select id,Ancillary_Fee_Type__c from Billing_Ancillary_Fee__c where Fee_Basis__c =: ancObj.Fee_Basis__c limit 1];
        System.assertEquals(billAncFee.Ancillary_Fee_Type__c,'Enrollment Materials');
        }
        
        }
        @isTest
    static void BillAncillaryNewEditClassTestMeth8()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create 2nd CentralHub Record 
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            //Create 2nd Billing Operations Record 
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            

            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
           
            
           
            test.starttest();
            
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
           
            ApexPages.StandardController sc89 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller89 = new BillAncillaryNewEditClass (sc89);
            controller89.FeeAmountAction();
            controller89.FeeAdditiveAction();
            controller89.changeAction();
            controller89.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Transaction Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Electronic Managed Access';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
            ApexPages.StandardController sc90 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller90 = new BillAncillaryNewEditClass (sc90);
            controller90.FeeAmountAction();
            controller90.FeeAdditiveAction();
            controller90.changeAction();
            controller90.saveUpdateBAF();
            
             ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Group Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Client Set Up';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc91 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller91 = new BillAncillaryNewEditClass (sc91);
            controller91.FeeAmountAction();
            controller91.FeeAdditiveAction();
            controller91.changeAction();
            controller91.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Claim Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Electronic Coordination of Benefits';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc92 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller92 = new BillAncillaryNewEditClass (sc92);
            controller92.FeeAmountAction();
            controller92.FeeAdditiveAction();
            controller92.changeAction();
            controller92.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Administration of Deductibles and Maximums';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
                        
            ApexPages.StandardController sc93 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller93 = new BillAncillaryNewEditClass (sc93);
            controller93.FeeAmountAction();
            controller93.FeeAdditiveAction();
            controller93.changeAction();
            controller93.saveUpdateBAF();
            
            ApexPages.StandardController sc94 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller94 = new BillAncillaryNewEditClass (sc94);
            controller94.operationType = 'Clone';
            controller94.FeeAmountAction();
            controller94.FeeAdditiveAction();
            controller94.changeAction();
            controller94.saveUpdateBAF();
            
            test.stoptest();
         Billing_Ancillary_Fee__c billAncFee = [Select id,Ancillary_Fee_Type__c from Billing_Ancillary_Fee__c where Fee_Basis__c =: ancObj.Fee_Basis__c limit 1];
        System.assertEquals(billAncFee.Ancillary_Fee_Type__c,'No Charge');
        }
    }
    
     @isTest
    static void BillAncillaryNewEditClassTestMeth9()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            Client_Information__c ClientInfoObj = TestDataFactory.createClientInfo(FAFObj.id); 
            insert ClientInfoObj;
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;                        
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
             ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Match Paper Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Coordination of Benefits – Paper';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAdministrativeFeesNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
            
                        
            ApexPages.StandardController sc5 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller5 = new BillAncillaryNewEditClass (sc5);
            controller5.FeeAmountAction();
            controller5.FeeAdditiveAction();
            controller5.changeAction();
            controller5.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Add To Retail Per Claim Admin Fee';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Coordination of Benefits – Batch Pay-and-Chase (e.g., SPAP, Medicaid, commercial, etc.)';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            
            ApexPages.StandardController sc6 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller6 = new BillAncillaryNewEditClass (sc6);
            controller6.FeeAmountAction();
            controller6.FeeAdditiveAction();
            controller6.changeAction();
            controller6.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Paper Claim';
            ancObj.Ancillary_Fee_Type__c='Claim Fees';
            ancObj.Ancillary_Fee_Description__c='Denied/Rejected Claims';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            
            ApexPages.StandardController sc7 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller7 = new BillAncillaryNewEditClass (sc7);
            controller7.FeeAmountAction();
            controller7.FeeAdditiveAction();
            controller7.changeAction();
            controller7.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Programming Hour Fee';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='Client Specific Programming';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
            ApexPages.StandardController sc9 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller9 = new BillAncillaryNewEditClass (sc9);
            controller9.FeeAmountAction();
            controller9.FeeAdditiveAction();
            controller9.changeAction();
            controller9.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Month';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='Historical – Claims Data Extract – Current and or Previous Year';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc10 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller10 = new BillAncillaryNewEditClass (sc10);
            controller10.FeeAmountAction();
            controller10.FeeAdditiveAction();
            controller10.changeAction();
            controller10.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Quarter';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='Historical – Claims Data Extract – Over the Current and or Previous Year';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            test.stoptest();          
            }
            
        }
        
         @isTest
    static void BillAncillaryNewEditClassTestMeth10()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            //ancObj1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Oz.';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Postage After 1st Oz.';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
                                  
            ApexPages.StandardController sc17= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller17= new BillAncillaryNewEditClass (sc17);
            controller17.FeeAmountAction();
            controller17.FeeAdditiveAction();
            controller17.changeAction();
            controller17.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Card fee';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Benefit Cards Individual Postage';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc18= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller18= new BillAncillaryNewEditClass (sc17);
            controller18.FeeAmountAction();
            controller18.FeeAdditiveAction();
            controller18.changeAction();
            controller18.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Card fee';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Benefit Cards Assembly Bulk Mailing';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc19= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller19= new BillAncillaryNewEditClass (sc19);
            controller19.FeeAmountAction();
            controller19.FeeAdditiveAction();
            controller19.changeAction();
            controller19.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Card fee';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Benefit Cards Card Carrier';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc20= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller20= new BillAncillaryNewEditClass (sc20);
            controller20.FeeAmountAction();
            controller20.FeeAdditiveAction();
            controller20.changeAction();
            controller20.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Kit';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Welcome Kits (Benefit Cards & Booklet)';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc21= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller21= new BillAncillaryNewEditClass (sc21);
            controller21.FeeAmountAction();
            controller21.FeeAdditiveAction();
            controller21.changeAction();
            controller21.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Card Fee';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Entire Client Card Reissue - Client Requested';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc22= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller22= new BillAncillaryNewEditClass (sc22);
            controller22.FeeAmountAction();
            controller22.FeeAdditiveAction();
            controller22.changeAction();
            controller22.saveUpdateBAF();
            
            test.stoptest();
         }
    }
    
       @isTest
    static void BillAncillaryNewEditClassTestMeth11()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
                      
            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            //ancObj1 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Administration of Deductibles and Maximums';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            test.starttest();
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
                                    
            ApexPages.StandardController scg= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerobj8= new BillAncillaryNewEditClass (scg);
            controllerobj8.FeeAmountAction();
            controllerobj8.FeeAdditiveAction();
            controllerobj8.changeAction();
            controllerobj8.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Client/Group Implementation';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sch= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj9= new BillAncillaryNewEditClass (sch);
            controllerObj9.FeeAmountAction();
            controllerObj9.FeeAdditiveAction();
            controllerObj9.changeAction();
            controllerObj9.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Website';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Co-Branded Website';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sci= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj10= new BillAncillaryNewEditClass (sci);
            controllerObj10.FeeAmountAction();
            controllerObj10.FeeAdditiveAction();
            controllerObj10.changeAction();
            controllerObj10.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Managed Access/Managed Drug Limitations';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scj= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj11= new BillAncillaryNewEditClass (scj);
            controllerObj11.FeeAmountAction();
            controllerObj11.FeeAdditiveAction();
            controllerObj11.changeAction();
            controllerObj11.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Transmission';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Member Eligibility Transmission - Electronic';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sck= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj12= new BillAncillaryNewEditClass (sck);
            controllerObj12.FeeAmountAction();
            controllerObj12.FeeAdditiveAction();
            controllerObj12.changeAction();
            controllerObj12.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Member Services';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scm= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj13= new BillAncillaryNewEditClass (scm);
            controllerObj13.FeeAmountAction();
            controllerObj13.FeeAdditiveAction();
            controllerObj13.changeAction();
            controllerObj13.saveUpdateBAF();
            
            ApexPages.StandardController sc80 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller80 = new BillAncillaryNewEditClass (sc80);
            controller80.operationType = 'Clone';
            controller80.FeeAmountAction();
            controller80.FeeAdditiveAction();
            controller80.changeAction();
            controller80.saveUpdateBAF();
            test.stoptest();
        }
    }
    @isTest
    static void BillAncillaryNewEditClassTestMeth12()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create 2nd CentralHub Record 
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            //Create 2nd Billing Operations Record 
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            

            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='EOB for paper claims';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            //update ancObj;
           
            
            //Create 2nd Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj1 = TestDataFactory.createBillAncillary(FAFObj1.id,bilOpsObj1.id);
            //insert ancObj1;
            ancObj1.LOB2__c='RU';
            ancObj1.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj1.Ancillary_Fee_Type__c='Claim Fees';
            ancObj1.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj1.Year__c='2';
            ancObj1.Fee_Amount__c=0;
           // update ancObj1;
           
          
           
           //Create 3rd Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj3 = TestDataFactory.createBillAncillary(FAFObj1.id,bilOpsObj1.id);
            //insert ancObj3;
            ancObj3.LOB2__c='CAP';
            ancObj3.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj3.Ancillary_Fee_Type__c='Claim Fees';
            ancObj3.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj3.Year__c='2';
            ancObj3.Fee_Amount__c=0;
           // update ancObj3;
            
            //Create 4rth Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj4 = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            //insert ancObj4;
            ancObj4.LOB2__c='CAP';
            ancObj4.Fee_Basis__c='Match Retail Per Claim Admin Fee';
            ancObj4.Ancillary_Fee_Type__c='Claim Fees';
            ancObj4.Ancillary_Fee_Description__c='Medicaid claims Batch';
            ancObj4.Year__c='All';
            ancObj4.Fee_Amount__c=0;
            
            list<Billing_Ancillary_Fee__c>  bilancList = new list<Billing_Ancillary_Fee__c>();
            bilancList.add(ancObj);
            bilancList.add(ancObj1);
            bilancList.add(ancObj3);
            bilancList.add(ancObj4);
                       
            test.starttest();
            insert bilancList;
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
                        
            ApexPages.StandardController scm5= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj18= new BillAncillaryNewEditClass (scm5);
            controllerObj18.FeeAmountAction();
            controllerObj18.FeeAdditiveAction();
            controllerObj18.changeAction();
            controllerObj18.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Submission';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Paper Eligibility Submission';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController scm6= new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controllerObj19= new BillAncillaryNewEditClass (scm6);
            controllerObj19.FeeAmountAction();
            controllerObj19.FeeAdditiveAction();
            controllerObj19.changeAction();
            controllerObj19.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Quarter';
            ancObj.Ancillary_Fee_Type__c='Miscellaneous Fees';
            ancObj.Ancillary_Fee_Description__c='Ongoing - Claims Data Extract';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=0;
            update ancObj;
            
            ApexPages.StandardController sc11 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller11 = new BillAncillaryNewEditClass (sc11);
            controller11.operationType = 'Clone';
            controller11.FeeAmountAction();
            controller11.FeeAdditiveAction();
            controller11.changeAction();
            controller11.saveUpdateBAF();
            
             ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Oz.';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Postage 1st Oz. (6 Sheets)';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            
            ApexPages.StandardController sc77 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller77 = new BillAncillaryNewEditClass (sc77);
            controller77.FeeAmountAction();
            controller77.FeeAdditiveAction();
            controller77.changeAction();
            controller77.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Oz.';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Enrollment Material Postage After 1st Oz.';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            
            ApexPages.StandardController sc78 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller78 = new BillAncillaryNewEditClass (sc78);
            controller78.FeeAmountAction();
            controller78.FeeAdditiveAction();
            controller78.changeAction();
            controller78.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Card fee';
            ancObj.Ancillary_Fee_Type__c='Enrollment Materials';
            ancObj.Ancillary_Fee_Description__c='Benefit Cards Individual Postage';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= 0.50;
            update ancObj;
            
             ApexPages.StandardController sc79 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller79 = new BillAncillaryNewEditClass (sc79);
            controller79.operationType = 'Clone';
            controller79.FeeAmountAction();
            controller79.FeeAdditiveAction();
            controller79.changeAction();
            controller79.saveUpdateBAF();
                                     
            test.stoptest();
                
        Billing_Ancillary_Fee__c billAncFee = [Select id,Ancillary_Fee_Description__c from Billing_Ancillary_Fee__c where Fee_Basis__c =: ancObj.Fee_Basis__c limit 1];
        System.assertEquals(billAncFee.Ancillary_Fee_Description__c, 'Benefit Cards Individual Postage');
        }
    }
    @isTest
    static void BillAncillaryNewEditClassTestMeth13()
    {
        //Create a user with Apttus Underwriting Profile
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
            
            //Create Billing Operations Record 
            Billing_Operations__c bilOpsObj = TestDataFactory.createBillOps(FAFObj.id);
            insert bilOpsObj;
            
            //Create 2nd CentralHub Record 
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            //Create 2nd Billing Operations Record 
            Billing_Operations__c bilOpsObj1 = TestDataFactory.createBillOps(FAFObj1.id);
            insert bilOpsObj1;
            
            //Create Billing Administrative Fees Record 
            Billing_Administrative_Fees__c admObj = TestDataFactory.createBillAdminFees(FAFObj.id,bilOpsObj.id);
            insert admObj;
            admobj.LOB__c='CC';
            admobj.Year__c='1';
            admobj.Admin_Fee_Type__c='Per Employee Per Month';
            admobj.Base_Amount__c=0;
            update admObj;
            

            //Create Ancillary Fees Record 
            Billing_Ancillary_Fee__c ancObj = TestDataFactory.createBillAncillary(FAFObj.id,bilOpsObj.id);
            insert ancObj;
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='EOB for paper claims';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
           
            test.starttest();
            
            PageReference pageRef = Page.BillingAncillaryNewEditPage;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',ancObj.id);
            pageRef.getParameters().put(Label.BillingAncillaryBillingOps,bilOpsObj.id);
                        
            ApexPages.StandardController sc84 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller84 = new BillAncillaryNewEditClass (sc84);
            controller84.FeeAmountAction();
            controller84.FeeAdditiveAction();
            controller84.changeAction();
            controller84.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='RxHub/Caremark Connected Network';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
            ApexPages.StandardController sc85 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller85 = new BillAncillaryNewEditClass (sc85);
            controller85.FeeAmountAction();
            controller85.FeeAdditiveAction();
            controller85.changeAction();
            controller85.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Report';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Paper Client Detail Reporting';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c= null;
            update ancObj;
            
            ApexPages.StandardController sc86 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller86 = new BillAncillaryNewEditClass (sc86);
            controller86.FeeAmountAction();
            controller86.FeeAdditiveAction();
            controller86.changeAction();
            controller86.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Per Transmission';
            ancObj.Ancillary_Fee_Type__c='No Charge';
            ancObj.Ancillary_Fee_Description__c='Member Eligibility Transmission - Electronic';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc87 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller87 = new BillAncillaryNewEditClass (sc87);
            controller87.FeeAmountAction();
            controller87.FeeAdditiveAction();
            controller87.changeAction();
            controller87.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Decentralized Administration';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
            ApexPages.StandardController sc88 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller88 = new BillAncillaryNewEditClass (sc88);
            controller88.FeeAmountAction();
            controller88.FeeAdditiveAction();
            controller88.changeAction();
            controller88.saveUpdateBAF();
            
            ancObj.LOB2__c='CC';
            ancObj.Fee_Basis__c='Flat Fee';
            ancObj.Ancillary_Fee_Type__c='No charge';
            ancObj.Ancillary_Fee_Description__c='Toll Free Member Services';
            ancObj.Year__c='1';
            ancObj.Fee_Amount__c=null;
            update ancObj;
            
             ApexPages.StandardController sc89 = new ApexPages.standardController(bilOpsObj);
            BillAncillaryNewEditClass  controller89 = new BillAncillaryNewEditClass (sc89);
            controller89.operationType = 'Clone';
            controller89.FeeAmountAction();
            controller89.FeeAdditiveAction();
            controller89.changeAction();
            controller89.saveUpdateBAF();
            
            test.stoptest();
            
        Billing_Ancillary_Fee__c billAncFee = [Select id,LOB2__c from Billing_Ancillary_Fee__c where Fee_Basis__c =: ancObj.Fee_Basis__c limit 1];
        System.assertEquals(billAncFee.LOB2__c,'CC');
        }
    }
 }