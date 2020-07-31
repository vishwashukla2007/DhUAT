/*********************************************************************************************
 * @ClassName         : WordDocToPDFGeneratorTest
 * @author            : Anudeep Dale
 * @created date      : 23/10/2018
 * @Last modified by  : Anudeep Dale
 * @Last modified date: 23/10/2018
 * @Purpose           : For increase the WordDocToPDFGenerator class coverage 
 **********************************************************************************************/
@isTest
public class WordDocToPDFGeneratorTest{

    // It will cover the convertWordToPDF method
    static testMethod void WordDocToPDFGeneratorMethod1(){
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
                    
            Account accObj =  TestDataFactory.createAccount();
           insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
           insert oppObj;
            
            Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c();
            temp.Name = 'Test Template';
            temp.Apttus__Type__c = 'FAF';
            temp.Apttus__IsActive__c = true;
            temp.Apttus__ReferenceId__c = '0837d320-b63e-4924-ba63-7661a0f8f9d3';            
            insert temp;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            FAFObj.Print_Template__c = temp.id;
            insert FAFObj;

            Client_Information__c ci= TestDataFactory.createClientInfo(FAFObj.id);
            ci.FAF_ID__c=FAFObj.id;
            insert ci;
            
            FAF_Print__c  FAFP=new FAF_Print__c ();
            FAFP.FAF__c =FAFObj.id;
            FAFP.Template_Id__c = temp.id;
            FAFP.Name='FAF PRINT TEST';
            insert FAFP;
            
            List<Id> fafids = new List<Id>();
            fafids.add(FAFP.id);
            test.starttest();
            WordDocToPDFGenerator wtpg = new WordDocToPDFGenerator();
            system.debug('::FAFIds::'+fafids);
            WordDocToPDFGenerator.convertWordToPDF(fafids);
            test.stoptest();
        }
    }  
}