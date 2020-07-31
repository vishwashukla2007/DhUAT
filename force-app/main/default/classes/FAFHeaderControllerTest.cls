@isTest
private class FAFHeaderControllerTest {

	private static testMethod void test() {
        Central_Hub__c chObj = new Central_Hub__c(
                        	        FAF_Status__c = 'Draft'
                        	        );
        insert chObj;
        system.assert(chObj.Id <> null);
        FAFHeaderController fafH = new FAFHeaderController();
        fafH.fafId = chObj.Id;
        fafH.objectType = 'Client_Information__c';
        fafH.getFAF();
        
        fafH.objectType = 'Mail_Pricing__c';
        fafH.getFAF();
	}

}