@isTest
private class MailGuaranteesControllerTest {

    private static testMethod void test() 
    {
        Account accRec=TestDataFactory.createAccount();
        insert accRec;  
        Central_Hub__c chObj = new Central_Hub__c(
                                    FAF_Status__c = 'Draft',
                        Account_Name__c=accRec.Id
                                    );
        insert chObj;
        
        Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = chObj.Id
                                    );
        insert moObj;   
        
        ApexPages.currentPage().getParameters().put(Label.MailOperationsFieldId,moObj.Id);
        Mail_Pricing__c mp = new Mail_Pricing__c(
                                FAF_Mail_Operations__c = moObj.Id,
                                FAF_ID__c = chObj.Id
                            );
                            
        insert mp   ;
        Test.StartTest();
        ApexPages.currentPage().getParameters().put(Label.MailPricingFieldId,mp.Id);
        
        Mail_Guarantees__c mg = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, SSG__c = 'No', Type__c = 'SSG' );
        ApexPages.StandardController con = new ApexPages.StandardController(mg);
        MailGuaranteesController mgc = new MailGuaranteesController(con);
        mgc.populateRate();
        mgc.saveMailGuarantees();
        
        Test.StopTest();
        
        Mail_Guarantees__c[] mailGuarantees = [ SELECT Id FROM Mail_Guarantees__c LIMIT 5 ];
        system.assert( !mailGuarantees.isEmpty(), 'Assert failed: empty results found' );
        
        //Mail_Guarantees__c[] mailGuarantees1 = [ SELECT Rate__c FROM Mail_Guarantees__c LIMIT 5 ];
        //system.assert( mg.Rate__c>100, 'Assert failed: Mail Guarantee Rate must be between 0.00% and 100.00%.' );
        
        Mail_Guarantees__c mg2 = new Mail_Guarantees__c( Type__c = 'SSG', SSG__C = 'Yes' );
        ApexPages.StandardController con2 = new ApexPages.StandardController(mg2);
        MailGuaranteesController mgc2 = new MailGuaranteesController(con2);
        mgc2.saveMailGuarantees();
        
        Mail_Guarantees__c mg3 = new Mail_Guarantees__c( Type__c = 'BER', SSG__C = 'Yes', LDD__c = 'Yes', X340B__c = 'Yes', Vaccine__c = 'Yes' );
        ApexPages.StandardController con3 = new ApexPages.StandardController(mg3);
        MailGuaranteesController mgc3 = new MailGuaranteesController(con3);
        mgc3.saveMailGuarantees();
        
        ApexPages.currentPage().getParameters().put('isExpandableView','true');
        mg2 = new Mail_Guarantees__c( Type__c = 'SSG', SSG__C = 'Yes', Rate__c = 120 );
        con2 = new ApexPages.StandardController(mg2);
        mgc2 = new MailGuaranteesController(con2);
        mgc2.saveMailGuarantees();
        
        //Mail_Guarantees__c[] mailGuarantees2 = [ SELECT Id FROM Mail_Guarantees__c LIMIT 5 ];
        //system.assert( !mailGuarantees2.isEmpty(), 'Assert failed: expecting results'+mailGuarantees2 );
    }
    
    private static testMethod void test2() 
    {
        Test.StartTest();
        Mail_Guarantees__c mg = new Mail_Guarantees__c( Type__c = 'SSG' );
        ApexPages.StandardController con = new ApexPages.StandardController(mg);
        MailGuaranteesController mgc = new MailGuaranteesController(con);
        mgc.populateRate();
        mg.Rate__c = 200;
        mgc.saveMailGuarantees();
        Mail_Guarantees__c[] mailGuarantees2 = [ SELECT Id FROM Mail_Guarantees__c LIMIT 1 ];
        system.assert( mailGuarantees2.isEmpty(), 'Assert failed: expecting no results' );
        Test.StopTest();
    }
}