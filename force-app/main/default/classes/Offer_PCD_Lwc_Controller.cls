public with sharing class Offer_PCD_Lwc_Controller {
    @AuraEnabled (cacheable=true)
    public static List<Apttus__APTS_Agreement__c> getAgreement(String Key){
        return[SELECT Id, Name,Offer__c,PCD_Agreement_link__c,Task_Offer__c,Primary_Agreement_Line_Item__c,PCD_Status__c,Generate_PCD__c,Opportunity__r.Name,Alert__c
               FROM Apttus__APTS_Agreement__c where Offer__c=:Key and Offer__c!=null];
    }
    @AuraEnabled (cacheable=true)
    public static List<Apttus__APTS_Agreement__c> getAgreement1(String Key){
        return[SELECT Id, Name,Offer__c,PCD_Agreement_link__c,Primary_Agreement_Line_Item__c,Task_Offer__c,PCD_Status__c,Generate_PCD__c,Opportunity__r.Name,Alert__c
               FROM Apttus__APTS_Agreement__c where Offer__c=:Key and Offer__c!=null ];
    }
    
    @AuraEnabled (cacheable=true)
    public static List<Central_Hub__c> getFAF(String Key){
        return[SELECT Id, Name,Account_Name__c,Underwriter__c,PCD_FAF_Link__c,Segment__c,Client_Subtype__c,FAF_Status__c,LOB_IDS__c
                FROM Central_Hub__c where Agreement__r.Offer__r.Id=:Key AND Agreement__r.Offer__r.Id!=null];
    }
    
     @AuraEnabled (cacheable=true)
    public static List<Apttus__DocumentVersionDetail__c> getDocument(String Key){
        return[SELECT Id, Name,Agreement__c,Template__c,Apttus__FileType__c,Apttus__DocumentInfo__c,PCD_Document_link__c,Description__c,LOB_Detail__c
                FROM Apttus__DocumentVersionDetail__c where Agreement__r.Offer__r.Id=:Key and Agreement__c!=null and  Agreement__r.Offer__r.Id!=null  Order By CreatedDate DESC];
    }
     @AuraEnabled(cacheable=true)
    public static List<Offer__c> getWrapperList(String Searchkey) {
            return[SELECT Id, Name, OfferCategory__c,Offer_Revenue_PCD__c,PCD_Offer_link__c,iUMSTask__r.Account__c,OfferTotalRevenue__c,OfferDescriptor__c,Account__c,PCD__c,OfferGrouping__c FROM Offer__c where iUMSTask__r.Account__c=:Searchkey];
    }
    @AuraEnabled
    public static Apttus__APTS_Agreement__c  getAuraAgreementData(String Aggrid) {
     Apttus__APTS_Agreement__c Aggr=[Select Id,Primary_Agreement_Line_Item__c FROM Apttus__APTS_Agreement__c Where Id =: Aggrid limit 1];
     return Aggr;
    }
    
}