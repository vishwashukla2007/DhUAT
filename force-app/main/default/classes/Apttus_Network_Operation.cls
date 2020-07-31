public with sharing class Apttus_Network_Operation {
    
    @AuraEnabled
    public static List <Network_Pricing__c> getNetworkpricing(String netopId) {
        List<Network_Pricing__c> networkPricings = new List<Network_Pricing__c>();
        
        List<Network_Pricing__c> networkPricing = [SELECT id,
                                                   FAF_Network_Ops__r.Client__c,
                                                   FAF_Network_Ops__r.Member__c,
                                                   Network_Name__c, 
                                                   Network_Adjudication_Logic_Deviation__c,
                                                   Year__c, Custom_Network_Description__c,
                                                   LOB__c,
                                                   Managed_Network_Type__c,
                                                   Network_Type__c,
                                                   Retail_Network_Ordinal__c,
                                                   Client_Adjudication_Logic_Deviation__c,
                                                   Member_Adjudication_Logic_Deviation__c,
                                                   Maintenance_Choice__c,
                                                   Brand_Basis__c,
                                                   Link__c,
                                                   Brand_Rate__c,
                                                   Preferred_Brand_Rate__c,
                                                   Non_Preferred_Brand_Rate__c,
                                                   Brand_Dispensing_Fee__c,
                                                   Rebate_Plan_Design__c,
                                                   Generic_Basis__c,
                                                   Generic_Rate__c,
                                                   Generic_Dispensing_Fee__c,
                                                   Non_MAC_Generic_Rate__c,
                                                   MAC_Modeled__c,
                                                   Mirror_Mail_Brand_Pricing__c,
                                                   Mirror_Mail_Generic_Pricing__c,
                                                   SSG_Exclusion_List__c,
                                                   SSGs_into_Brands__c,
                                                   SSG_Exclusivity_Period__c,
                                                   Exclude_Specialty__c
                                                   FROM Network_Pricing__c WHERE FAF_Network_Ops__c =:netopId order by year__c,CreatedDate ASC];
        
        for (Network_Pricing__c ntp : networkPricing) {
            networkPricings.add(ntp); 
            
        }
        
        return networkPricings;
    }
    
    @AuraEnabled
    public static void deletePricing(String pricingRecId) {
        system.debug('Delete Record Id:'+pricingRecId);
    }
    @AuraEnabled
    public static Boolean  avoidAccessForSalesUser(){
        
        Boolean val=true;
        user u =[select id ,profile.name,profileId from user where id=:Userinfo.getUserId()];
        if(u.profileId==Label.Apttus_sales_Profile || u.profileId==Label.Apttus_Operations_Profile_Id || Test.isRunningTest()){
            val=false;
            
        }
        return val;
    }
    
    @AuraEnabled
    public static void deleteSelectedRecords(String netpriceId, List <Network_Pricing__c> selectedRecordList) {
        List <Network_Pricing__c> recordsList  = new List <Network_Pricing__c>() ;
        List <Network_Pricing__c> recordsToDelete = [SELECT Id FROM Network_Pricing__c WHERE Id IN: selectedRecordList ];
        try{
            delete recordsToDelete;
        } catch(Exception ex){
            system.debug('Exception' +ex.getMessage());
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
}
/*
     @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Network_Pricing__c.isDeletable();
        return isDeletable; 
    }
  
  
  
   //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Network_Pricing__c.isCreateable();
        return isCreateable;
    }
    
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Network_Pricing__c.isUpdateable();
        return isCreateable;
    }
*/
}