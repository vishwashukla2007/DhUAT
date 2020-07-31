@isTest
public with sharing class Invoke_GridDisplayNameMailTest{
    
    @isTest
    static void Invoke_GridDisplayNameMailMethod1()
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
            
            test.starttest();
            Grid_Display_Name_Setting__c gridDisp= new Grid_Display_Name_Setting__c();
            gridDisp.FAF__c =FAFObj.id;
            gridDisp.Object_Name__c='Mail Pricing';
            insert gridDisp;
            
            List<Id> MailOpsList=new List<Id>();
            
             Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = FAFObj.Id
                                    );
            insert moObj; 
            
            Mail_Pricing__c mailPriceObj =  new Mail_Pricing__c(Year__c = 'All', FAF_ID__c=FAFObj.Id, LOB__c = 'EGFI', Brand_Basis__c = 'Standard Brand Discount',
                                             Brand_Rate__c = 56, Brand_Dispensing_Fee__c = 56, Generic_Basis__c = 'MAC Modeled & Non-MAC',Show_in_Grid__c=True,
                                             MAC_Modeled__c = 'MAC 570', Non_MAC_Generic_Rate__c = 56, Generic_Dispensing_Fee__c = 56, FAF_Mail_Operations__c = moObj.Id);
            mailPriceObj.Year_Begin_Date__c=Date.newInstance(2020,6,24);
            mailPriceObj.Year_End_Date__c=Date.newInstance(2020,7,24);
            mailPriceObj.Custom_Description__c='test';
            mailPriceObj.Generic_Rate__c=5;
            mailPriceObj.BER_Guarantee_Rate__c=1;
 
            insert mailPriceObj;
            
            MailOpsList.add(moObj.id);
           
            Invoke_GridDisplayNameMail.UpdateGridName(MailOpsList);
            test.stoptest();
        }
    }
    }