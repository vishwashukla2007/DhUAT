@isTest
public class NewBillingOtherFeesControllerTest {
    
    @isTest
    public static void NewBillingOtherFeeTest(){
        PageReference pageRef = Page.NewBillingOtherFees;
        Test.setCurrentPage(pageRef);
        
        Account acct = TestDataFactory.createAccount();  
        acct.Market_Segment__c='Employer';     
        insert acct;
        
        Opportunity opp = TestDataFactory.createOpportunity(acct.Id);
        insert opp;     
        
        Central_Hub__c faf1 = TestDataFactory.createFAF(acct.Id,opp.Id,UserInfo.getUserId());
        faf1.Salesperson__c= null;
        faf1.Network_Operations__c= true;
        faf1.Specialty_Operations__c= true;
        faf1.Mail_Operations__c= true;
        insert faf1;
        
        Billing_Operations__c bo = new Billing_Operations__c();
        bo.FAF_ID__c = faf1.id;
        bo.Billing_Admin_Payment_Terms__c='2 Days (Preferred)';
        bo.Billing_Claim_Payment_Terms__c='2 Days (Preferred)';
        insert bo;
        Billing_Other_Fees__c bof = new Billing_Other_Fees__c();
        bof.Basis__c = '> 1 million members';
        bof.LOB__c = 'CAP';
        bof.Year__c = '2';
        bof.Billing_Operations__c = bo.Id;
        bof.Fee_Amount__c = 100;
        bof.Other_Fee_Description__c = 'Claims History upon Termination';
        bof.Other_Fee_Type__c = 'Enrollment Materials';
        
        Billing_Other_Fees__c bof2 = new Billing_Other_Fees__c();
        bof2.Basis__c = '> 1 million members';
        bof2.LOB__c = 'CAP';
        bof2.Year__c = '2';
        bof2.Billing_Operations__c = bo.Id;
        bof2.Fee_Amount__c = 0;
        bof2.Other_Fee_Description__c = 'Claims History upon Termination';
        bof2.Other_Fee_Type__c = 'Enrollment Materials';
        
        Billing_Other_Fees__c bof3 = new Billing_Other_Fees__c();
        bof3.Basis__c = '> 1 million members';
        bof3.LOB__c = 'CAP';
        bof3.Year__c = '3';
        //bof3.Billing_Operations__c = bo.Id;
        bof3.Fee_Amount__c = 0;
        bof3.Other_Fee_Description__c = 'Claims History upon Termination';
        bof3.Other_Fee_Type__c = 'Enrollment Materials';
        
        Test.startTest();
        // ApexPages.currentPage().getParameters().put('id', bof.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(bof);
        NewBillingOtherFeesController controller = new NewBillingOtherFeesController(sc);
        controller.saveBillingOtherFee();
        upsert bof;
        ApexPages.currentPage().getParameters().put('id', bof.Id);
        ApexPages.currentPage().getParameters().put('type', 'Clone');
        
        sc = new Apexpages.standardController(bof);
        controller = new NewBillingOtherFeesController(sc);
        controller.saveBillingOtherFee();
        
        ApexPages.currentPage().getParameters().put('id', bof2.Id);
        ApexPages.currentPage().getParameters().put('type', 'Clone');
        sc = new Apexpages.standardController(bof2);
        controller = new NewBillingOtherFeesController(sc);
        controller.saveBillingOtherFee();
        
        ApexPages.currentPage().getParameters().put('id', bof3.Id);
        ApexPages.currentPage().getParameters().put('type', 'Clone');
        ApexPages.currentPage().getParameters().put(Label.Billing_Other_Fee, bo.Id);
        sc = new Apexpages.standardController(bof3);
        controller = new NewBillingOtherFeesController(sc);
        controller.saveBillingOtherFee();
        Test.stopTest();
    }
}