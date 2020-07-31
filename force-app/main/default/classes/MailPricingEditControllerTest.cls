@isTest
private class MailPricingEditControllerTest {
    @testSetup
Private Static void testSetupMethod()
{
   Account accRec=TestDataFactory.createAccount();
        insert accRec;  
}
  private static testMethod void test() {
        Account accRec=[SELECT Id,Name from Account where Name = 'testAccount---Anthem' LIMIT 1];
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
       
       Client_Information__c cInfo = TestDataFactory.createClientInfo(chObj.id);

        cInfo.Escalating_Pricing__c = true;
        cInfo.Year_1__c = '1';
        cInfo.Year_1_Begin_Date__c = System.today();
        cInfo.Year_1_End_Date__c = System.today()+10;
        cInfo.Year_2__c = '2';
        cInfo.Year_2_Begin_Date__c = cInfo.Year_1_End_Date__c+1;
        cInfo.Year_2_End_Date__c = cInfo.Year_1_End_Date__c+10;        
        cInfo.Year_3__c = '3';
        cInfo.Year_3_Begin_Date__c = cInfo.Year_2_End_Date__c+1;
        cInfo.Year_3_End_Date__c = cInfo.Year_2_End_Date__c+10;        
        cInfo.Year_4__c = '4';
        cInfo.Year_4_Begin_Date__c = cInfo.Year_3_End_Date__c+1;
        cInfo.Year_4_End_Date__c = cInfo.Year_3_End_Date__c+10;        
        cInfo.Year_5__c = '5';
        cInfo.Year_5_Begin_Date__c = cInfo.Year_4_End_Date__c+1;
        cInfo.Year_5_End_Date__c = cInfo.Year_4_End_Date__c+10;        
        insert cInfo;
        
        for( Client_Information__c ci : [SELECT Id, Year_1__c, Escalating_Pricing__c FROM Client_Information__c WHERE FAF_ID__c = :chObj.Id LIMIT 1 ])
        {
            Date dt = system.toDay();
            date dt2 = dt.addMonths(1);
            Integer numberDays = date.daysInMonth(dt.year(), dt.month());
            ci.Escalating_Pricing__c = true;
            ci.Year_1__c = '1';
        ci.Year_1_Begin_Date__c = System.today();
        ci.Year_1_End_Date__c = System.today()+10;
        ci.Year_2__c = '2';
        ci.Year_2_Begin_Date__c = ci.Year_1_End_Date__c+1;
        ci.Year_2_End_Date__c = ci.Year_1_End_Date__c+10;
            update ci;
        }
        
        ApexPages.currentPage().getParameters().put(Label.MailOperationsFieldId,moObj.Id);
        ApexPages.currentPage().getParameters().put('isExpandableView', 'true');
      Mail_Pricing__c mp = new Mail_Pricing__c(
                              FAF_Mail_Operations__c = moObj.Id,
                              FAF_ID__c = chObj.Id
                          );
        insert mp   ;
        Mail_Guarantees__c mg = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, SSG__C = 'No' );
        insert mg;
      ApexPages.StandardController con = new ApexPages.StandardController( mp );
        MailPricingEditController mpecObj = new MailPricingEditController(con);
        mpecObj.saveMailPricing();
        
        
        mp.Brand_Rate__c = 200;
        mp.Generic_Rate__c = 200;
        mp.Preferred_Brand_Rate__c  = 200;
        mp.Non_Preferred_Brand_Rate__c = 200;
        mp.Non_MAC_Generic_Rate__c = 200;
        MailPricingEditController mpecObj2 = new MailPricingEditController(new ApexPages.StandardController( mp ));
        mpecObj2.yearval='All';
        mpecObj2.saveMailPricing();
  }
  
  private static testMethod void test1() {
        Account accRec=[SELECT Id,Name from Account where Name = 'testAccount---Anthem' LIMIT 1];
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
        
        for( Client_Information__c ci : [SELECT Id, Year_1__c, Escalating_Pricing__c FROM Client_Information__c WHERE FAF_ID__c = :chObj.Id LIMIT 1 ])
        {
            Date dt = system.toDay();
            date dt2 = dt.addMonths(1);
            Integer numberDays = date.daysInMonth(dt.year(), dt.month());
            ci.Escalating_Pricing__c = true;
            ci.Year_1__c = '1';
        ci.Year_1_Begin_Date__c = System.today();
        ci.Year_1_End_Date__c = System.today()+10;
        ci.Year_2__c = '2';
        ci.Year_2_Begin_Date__c = ci.Year_1_End_Date__c+1;
        ci.Year_2_End_Date__c = ci.Year_1_End_Date__c+10;
            update ci;
        }
        
        ApexPages.currentPage().getParameters().put(Label.MailOperationsFieldId,moObj.Id);
    ApexPages.currentPage().getParameters().put('type','clone');
      Mail_Pricing__c mp = new Mail_Pricing__c(
                              FAF_Mail_Operations__c = moObj.Id,
                              FAF_ID__c = chObj.Id
                          );
        insert mp   ;
        Mail_Guarantees__c mg = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, SSG__C = 'No' );
        insert mg;
    
      ApexPages.StandardController con = new ApexPages.StandardController( mp );
        MailPricingEditController mpecObj = new MailPricingEditController(con);
        delete mp;
    mpecObj.saveMailPricing();
        
        
  }
  
  
  private static testMethod void testNewMP() {
        Account accRec=[SELECT Id,Name from Account where Name = 'testAccount---Anthem' LIMIT 1];
      Central_Hub__c chObj = new Central_Hub__c(
                                  FAF_Status__c = 'Draft',
            Account_Name__c=accRec.Id
                                  );
        insert chObj;
        
        //insert new Client_Information__c( FAF_ID__c = chObj.Id, Year_1__c = '1', Escalating_Pricing__c = true );
        
        
        Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'No MAC',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = chObj.Id
                                    );
        insert moObj;   
        
        ApexPages.currentPage().getParameters().put(Label.MailOperationsFieldId,moObj.Id);
      Mail_Pricing__c mp = new Mail_Pricing__c();
      ApexPages.StandardController con = new ApexPages.StandardController( mp );
        MailPricingEditController mpecObj = new MailPricingEditController(con);
        mpecObj.saveMailPricing();
  }

}