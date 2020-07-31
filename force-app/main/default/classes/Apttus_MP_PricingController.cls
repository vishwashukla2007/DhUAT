public class Apttus_MP_PricingController {
@AuraEnabled 
    public static void deleteMailPricingRecord(String pricingRecId){
        System.debug('Delet Record Id:'+pricingRecId);
            List<Mail_Pricing__c> mailPricing = [SELECT Id From Mail_Pricing__c where Id = :pricingRecId];
            if(mailPricing.size()>0) delete mailPricing;
           
    }
}