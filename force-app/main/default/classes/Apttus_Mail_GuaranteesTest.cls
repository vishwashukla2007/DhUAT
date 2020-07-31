@isTest
public class Apttus_Mail_GuaranteesTest {
  
      static testmethod void MailPriceGuarateeTest()
    {
        string fieldName = Label.rebateOperationLabel;
        User useObj = ClientTestRef.createuwUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = ClientTestRef.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        Method__c = 'By Component',
                                        Level__c = 'Client',
                                        Time_Frame__c ='Annually',
                                        FAF_ID__c = FAFObj.Id
                                    );
            insert moObj; 
             Mail_Pricing__c mpObj = new Mail_Pricing__c(Year__c= '1', 
                                           LOB__c = 'SRx', Brand_Basis__c = 'Standard Brand Discount',
                                           Brand_Rate__c = 24, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                           Brand_Dispensing_Fee__c = 45, MAC_Modeled__c = 'MAC 567',
                                           Non_MAC_Generic_Rate__c = 45,  Generic_Dispensing_Fee__c = 56, 
                                           FAF_ID__c = FAFObj.Id, FAF_Mail_Operations__c = moObj.Id);
            
            insert mpObj;
            
            Mail_Guarantees__c mgObj = new Mail_Guarantees__c(Type__c = 'BER',
                        Rate__c= 45,
                        ZBD__c = 'No',
                        SSG__c= 'No',
                        OTC__c= 'No',
                        X340B__c= 'Yes',
                        X340B_Inclusion_Option__c = 'Standard',
                        Biosimilars__c= 'No',
                        LDD__c= 'Yes',
                        //LDD_Inclusion_Option__c = 'Broad (w/ Access + w/o Access)',
                        Compound__c= 'No',
                        Vaccine__c= 'No',
                        Paper__c= 'No',
                        Vaccine_Inclusion_Option__c='Program Vaccines',
                        COB__c= 'No', FAF_ID__c= FAFObj.Id, Mail_Pricing__c = mpObj.Id);
            insert mgObj;
          
            test.starttest();
            Apttus_Mail_Guarantees.getMailGuarantees(mpObj.id);
            
            
            List<Mail_Guarantees__c> mailGuranteeList = new List<Mail_Guarantees__c>();
            mailGuranteeList.add(mgObj);
            
            List<Mail_Pricing__c> mailPricingList = new List<Mail_Pricing__c>();
            mailPricingList.add(mpObj);
            
            Apttus_MP_Parent_Controller.getMailPricing(moObj.id);
            Apttus_MP_Parent_Controller.avoidAccessForSalesUser();
            Apttus_MP_Parent_Controller.deleteSelectedRecords(mailPricingList);
            Apttus_Mail_Guarantees.deleteSelectedRecords(moObj.id, mailGuranteeList);
            
            
            
            
            
            Apttus_MP_PricingController.deleteMailPricingRecord(mpobj.id);
            test.stoptest();
        }
    }
    
    

}