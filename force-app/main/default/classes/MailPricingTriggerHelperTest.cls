@isTest
public with sharing class MailPricingTriggerHelperTest{
    
    
    //Method 1 to pass the parameters
    @isTest
    static void MailPricingTriggerHelperMeth1()
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
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
            
            test.starttest();
            
            List<Mail_Pricing__c> MailPricingList=new List<Mail_Pricing__c>();
            
             Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = FAFObj.Id
                                    );
            insert moObj; 
            
            Mail_Operations__c moObj1 = new Mail_Operations__c( 
                                        Client__c = 'Lower of MAC or Discount',
                                        Member__c = 'Maximize to Copay- Standard Copay Logic On',
                                        FAF_ID__c = FAFObj1.Id
                                    );
            insert moObj1;  
            
            Mail_Operations__c moObj2 = new Mail_Operations__c( 
                                        Client__c = 'No MAC',
                                        Member__c = 'Maximize to Copay- Standard Copay Logic On',
                                        FAF_ID__c = FAFObj2.Id
                                    );
            insert moObj2;  
           
            
            Mail_Pricing__c mailPriceObj =  new Mail_Pricing__c(Year__c = 'All', LOB__c = 'EGFI', Brand_Basis__c = 'Standard Brand Discount',
                                             Brand_Rate__c = 56, Brand_Dispensing_Fee__c = 56, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                             MAC_Modeled__c = 'MAC 570', Non_MAC_Generic_Rate__c = 56, Generic_Dispensing_Fee__c = 56, FAF_Mail_Operations__c = moObj.Id);
            insert mailPriceObj;
            
            Mail_Pricing__c mailPriceObj1 =  new Mail_Pricing__c(Year__c = 'All', LOB__c = 'EGFI', Brand_Basis__c = 'Standard Brand Discount',
                                             Brand_Rate__c = 56, Brand_Dispensing_Fee__c = 56, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                             MAC_Modeled__c = 'MAC 570', Non_MAC_Generic_Rate__c = 56, Generic_Dispensing_Fee__c = 56, FAF_Mail_Operations__c = moObj1.Id);
            insert mailPriceObj1;
            
            Mail_Pricing__c mailPriceObj2 =  new Mail_Pricing__c(Year__c = 'All', LOB__c = 'EGFI', Brand_Basis__c = 'Standard Brand Discount',
                                             Brand_Rate__c = 56, Brand_Dispensing_Fee__c = 56, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                             MAC_Modeled__c = 'MAC 570', Non_MAC_Generic_Rate__c = 56, Generic_Dispensing_Fee__c = 56, FAF_Mail_Operations__c = moObj2.Id);
            insert mailPriceObj2;
           
            MailPricingTriggerHelper.validateNoOfRecords(MailPricingList,true,false);
            MailPricingTriggerHelper.validateNoOfRecords(MailPricingList,false,true);
            test.stoptest();
        }
    }
    
  
    @isTest
    static void MailPricingTriggerHelperMeth2()
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
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
           Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
             FAFObj1.LOB2__c='EGFI';
            Update FAFObj1;
            
            Central_Hub__c FAFObj2 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj2;
            
            FAFObj2.LOB2__c='EGFI';
            Update FAFObj2;
            
            test.starttest();
            
          List<Mail_Pricing__c> MailPricingList=new List<Mail_Pricing__c>();
            
            
             Mail_Operations__c mailOps  = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
             Mail_Operations__c mailOps1 = TestDataFactory.createmailOperatns(FAFObj1.id);
            insert mailOps1;
            
             Mail_Operations__c mailOps2 = TestDataFactory.createmailOperatns(FAFObj2.id);
            insert mailOps2;
                      
            Mail_Pricing__c mailPricObj = TestDataFactory.createmailPricing(FAFObj.id,mailOps.id);
            Mail_Pricing__c mailPricObj1 = TestDataFactory.createmailPricing(FAFObj1.id,mailOps1.id);
            Mail_Pricing__c mailPricObj2 = TestDataFactory.createmailPricing(FAFObj2.id,mailOps2.id);
            MailPricingList.add(mailPricObj);
            MailPricingList.add(mailPricObj1);
            MailPricingList.add(mailPricObj2);
            insert MailPricingList;
            MailPricingTriggerHelper.validateLobYearName(MailPricingList,true,false);
            MailPricingTriggerHelper.validateLobYearName(MailPricingList,false,true);
            test.stoptest();
        }
    }
    
    @isTest
    static void MailPricingTriggerHelperMeth3()
    {
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
            Central_Hub__c FAFObj= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Central_Hub__c FAFObj1= TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            
            FAFObj.LOB2__c='EGFI';
            Update FAFObj;
            
             test.starttest();
             
             List<Mail_Pricing__c> MailPricingList=new List<Mail_Pricing__c>();
            
            
            Mail_Operations__c moObj= TestDataFactory.createmailOperatns(FAFObj.id);
            insert moObj;
          
    
            Mail_Pricing__c mailPriceObj =  new Mail_Pricing__c(Year__c = 'All', LOB__c = 'ACT', Brand_Basis__c = 'Standard Brand Discount',
                                             Brand_Rate__c = 56, Brand_Dispensing_Fee__c = 56, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                             MAC_Modeled__c = 'MAC 570', Non_MAC_Generic_Rate__c = 56, Generic_Dispensing_Fee__c = 56, FAF_Mail_Operations__c = moObj.Id);
            insert mailPriceObj;
            
            Mail_Pricing__c mailPriceObj1 =  new Mail_Pricing__c(Year__c = 'All', LOB__c = 'ACT', Brand_Basis__c = 'Standard Brand Discount',
                                             Brand_Rate__c = 56, Brand_Dispensing_Fee__c = 56, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                             MAC_Modeled__c = 'MAC 570', Non_MAC_Generic_Rate__c = 56, Generic_Dispensing_Fee__c = 56, FAF_Mail_Operations__c = moObj.Id);
          //  insert mailPriceObj1;
        
            Mail_Pricing__c mailPricObj = TestDataFactory.createmailPricing(FAFObj.id,moObj.id);
            Mail_Pricing__c mailPricObj1 = TestDataFactory.createmailPricing(FAFObj1.id,moObj.id);
            MailPricingList.add(mailPricObj);
            MailPricingList.add(mailPricObj1);
            insert MailPricingList;
            
            MailPricingTriggerHelper trhelperobj=new MailPricingTriggerHelper();
            MailPricingTriggerHelper.validateLobYearName(MailPricingList,true,false);
            test.stoptest();
         
        }
    }

}