@isTest
private class MailOperationsControllerTest {

	private static testMethod void unitTestmethodNegative() {
	    Central_Hub__c chObj = new Central_Hub__c(
                        	        FAF_Status__c = 'Draft'
                        	        );
        insert chObj;
        ApexPages.currentPage().getParameters().put(Label.FAFFieldId,chObj.Id);
        Mail_Operations__c moObj = new Mail_Operations__c();
        ApexPages.StandardController con = new ApexPages.StandardController( moObj );
        MailOperationsController mocObj = new MailOperationsController(con);
        mocObj.saveMailOperations();
        system.assertEquals( moObj.Id , null, 'Negative test failed' );
        
       
	}
	
	private static testMethod void unitTestmethodPositive() {
	    Test.startTest();
	    Central_Hub__c chObj = new Central_Hub__c(
                        	        FAF_Status__c = 'Draft'
                        	        );
        insert chObj;
        ApexPages.currentPage().getParameters().put('CF00Nf400000HaBtn_lkid',chObj.Id);
        Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = chObj.Id
                                    );
        insert moObj;                                    
        Mail_Pricing__c mpObj = new Mail_Pricing__c(
                                    FAF_Mail_Operations__c = moObj.Id
                                ); 
        insert mpObj;                                
        ApexPages.StandardController con = new ApexPages.StandardController( moObj );
        MailOperationsController mocObj = new MailOperationsController(con);
        mocObj.saveMailOperations();
        Test.stopTest();
        moObj.Client__c = 'No MAC';
        mocObj.saveMailOperations();
        system.assert( mpObj.Generic_Basis__c <> 'Flat Generic Discount', 'Positive test failed' );
	}

}