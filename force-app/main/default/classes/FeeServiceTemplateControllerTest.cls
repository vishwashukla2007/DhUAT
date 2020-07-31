@isTest
public class FeeServiceTemplateControllerTest {
    
    @isTest
    public static void feeServiceTemplateControllerTest(){
        PageReference pageRef = Page.FeeServiceTemplate;
        Test.setCurrentPage(pageRef);
        Fee_Service_Template__c fst = new Fee_Service_Template__c();
        //fst.Name = 'Test';
        fst.Active__c = false;
        fst.Expiration_Date__c = System.today();
        fst.Effective_date__c = System.today();
        fst.Item__c = 'Test';
        insert fst;
        Fee_Service_Template__c fst2 = new Fee_Service_Template__c();
        //fst.Name = 'Test';
        fst.Active__c = false;
        fst2.Expiration_Date__c = System.today();
        fst2.Effective_date__c = System.today();
        Test.startTest();
       
        Apexpages.StandardController sc = new Apexpages.standardController(fst);
         FeeServiceTemplateController controller = new FeeServiceTemplateController(sc);
        controller.saveFeeServiceTemplate();
        sc = new Apexpages.standardController(fst2);
          controller = new FeeServiceTemplateController(sc);
        controller.saveFeeServiceTemplate();
        //upsert rds;
        Test.stopTest();
    }
}