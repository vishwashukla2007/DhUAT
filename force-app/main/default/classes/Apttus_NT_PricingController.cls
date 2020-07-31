public class Apttus_NT_PricingController {
	@AuraEnabled
    public static void deletePricingRecord(String pricingRecId) {
        system.debug('Delete Record Id:'+pricingRecId);
        try{
            Network_Pricing__c ntPrice = [SELECT Id From Network_Pricing__c where Id = :pricingRecId];
    		delete ntPrice;
        }catch(Exception ex){
            system.debug('Line Number::'+ex.getLineNumber()+' Error Message::'+ex.getMessage());
        }
    }
}