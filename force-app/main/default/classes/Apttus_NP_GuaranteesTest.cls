@isTest
public class Apttus_NP_GuaranteesTest {
  
      static testmethod void NetworkPriceGuarateeTest()
    {
        string fieldName = Label.rebateOperationLabel;
        User useObj = ClientTestRef.createuwUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = ClientTestRef.createuwUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Network_Operations__c noObj = new Network_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount with U&C',
                                        Member__c = 'Lower of Discount or U&C or Copay - Standard Copay Logic Off',
                                        Method__c = 'By Component',
                                        Level__c = 'Client',
                                        Time_Frame__c ='Annually',
                                        FAF_ID__c = FAFObj.Id
                                    );
            insert noObj; 
             Network_Pricing__c npObj = new Network_Pricing__c(Year__c= '1', 
                                           LOB__c = 'SRx', Brand_Basis__c = 'Standard Brand Discount',
                                           Brand_Rate__c = 24, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                           Brand_Dispensing_Fee__c = 45, MAC_Modeled__c = 'MAC 567',
                                           Non_MAC_Generic_Rate__c = 45,  Generic_Dispensing_Fee__c = 56, 
                                           FAF_ID__c = FAFObj.Id, FAF_Network_Ops__c = noObj.Id);
            
            insert npObj;
            Network_Pricing__c npObj1 = new Network_Pricing__c(Year__c= '2', 
                                           LOB__c = 'SRx', Brand_Basis__c = 'Standard Brand Discount',
                                           Brand_Rate__c = 24, Generic_Basis__c = 'MAC Modeled & Non-MAC',
                                           Brand_Dispensing_Fee__c = 45, MAC_Modeled__c = 'MAC 567',
                                           Non_MAC_Generic_Rate__c = 45,  Generic_Dispensing_Fee__c = 56, 
                                           FAF_ID__c = FAFObj.Id, FAF_Network_Ops__c = noObj.Id);
            
            insert npObj1;
            
                Retail_Network_Guarantees__c ngObj = new Retail_Network_Guarantees__c(Type__c = 'BER',
                        Rate__c= 45,
                        ZBD__c = 'No',
                        SSG__c= 'No',
                        OTC__c= 'No',
                        X340B__c= 'Yes',
                        //X340B_Inclusion_Option__c = 'Standard',
                        Biosimilars__c= 'No',
                        LDD__c= 'Yes',
                       // LDD_Inclusion_Option__c = 'Broad (w/ Access + w/o Access)',
                        Compound__c= 'No',
                        Vaccine__c= 'No',
                        Vaccine_Inclusion_Option__c='Program Vaccines',
                        Paper__c= 'No',
                        COB__c= 'No', FAF_ID__c= FAFObj.Id, Network_Pricing__c = npObj.Id);
            insert ngObj;
            Retail_Network_Guarantees__c ngObj1 = new Retail_Network_Guarantees__c(Type__c = 'BER',
                        Rate__c= 45,
                        ZBD__c = 'Yes',
                        SSG__c= 'No',
                        OTC__c= 'No',
                        X340B__c= 'Yes',
                        //X340B_Inclusion_Option__c = 'Standard',
                        Biosimilars__c= 'No',
                        LDD__c= 'Yes',
                        //LDD_Inclusion_Option__c = 'Broad (w/ Access + w/o Access)',
                        Compound__c= 'No',
                        Vaccine__c= 'No',
                        Vaccine_Inclusion_Option__c='Program Vaccines',
                        Paper__c= 'No',
                        COB__c= 'No', FAF_ID__c= FAFObj.Id, Network_Pricing__c = npObj1.Id);
            insert ngObj1;
            List<Network_Pricing__c> npPricingList= new List<Network_Pricing__c>();
            npPricingList.add(npObj);
            
             List<Retail_Network_Guarantees__c> retailNetworkList= new List<Retail_Network_Guarantees__c>();
            retailNetworkList.add(ngObj);
            
            test.starttest();
            Apttus_Network_Operation.getNetworkpricing(noObj.id);
            Apttus_Network_Operation.avoidAccessForSalesUser();
            Apttus_Network_Operation.deletePricing(noObj.ID);
            Apttus_Network_Operation.deleteSelectedRecords(npObj.id, npPricingList);
            Apttus_NP_Retail_Gurantee.getNPGurantee(npObj.id);
            Apttus_NP_Retail_Gurantee.getNPGurantee(npObj1.id);
            Apttus_NP_Retail_Gurantee.deleteSelectedRecords(npObj.id, retailNetworkList);
            Apttus_NT_PricingController.deletePricingRecord(npObj1.id);
            Apttus_NT_PricingController.deletePricingRecord('12344');
            test.stoptest();
        }
    }
}