@isTest
public class CreateAgreementExtTest {

    @isTest 
    static void createAgreeExt() {
        List<List<PBS_Agreement_Extension__c>> result = new List<List<PBS_Agreement_Extension__c>>();
        List<List<String>> arguments = new List<List<String>>();
        arguments.add(new List<String>{'Client_Name__c-ClientTest','Market_Check__c-true','Audit_CVS_Share__c-35'});
        Test.startTest(); 
        result = createAgreementExt.createAgreeExt(arguments);
        Test.stopTest();
        System.assert(!result.isEmpty());
    }
}