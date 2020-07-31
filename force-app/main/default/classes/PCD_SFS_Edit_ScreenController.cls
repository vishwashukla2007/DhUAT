public without sharing class PCD_SFS_Edit_ScreenController {
    public class spSummaryData {
        @AuraEnabled 
        public String Name {get; set;}
        @AuraEnabled
        public String Value{get; set;}

}
    @AuraEnabled(cacheable=true)
    public static List<Specialty_Drug_Level_Pricing__c> getDrugListFromFAF(string fafId, string specOpId){
        //try{
            List<Specialty_Drug_Level_Pricing__c> fafDrugList = [
            SELECT Id,
            Year__c,
            LOB__c, 
            Pharmacy_Benefit__c, 
            Drug_Therapy__c, 
            Notes__c,
            Drug_Name__c, 
            MAC__c, 
            Rate__c,  
            Drug_Type__c 
            FROM Specialty_Drug_Level_Pricing__c 
            WHERE FAF_ID__r.id =: fafId
            AND Specialty_Operations__r.id =: specOpId
            //AND Year__c = 'All'
           ];
            return fafDrugList;
    //    }catch(Exception e){
    //        system.debug(e.getMessage());
    //        throw new AuraHandledException(e.getMessage());
    //    }
        
    }
    @AuraEnabled(cacheable=true)
    public static  string getPharmacyBenefit(string specOpId, string fafId){
        Specialty_Pricing__c pharmacyBen = [Select Pharmacy_Benefit__c  from Specialty_Pricing__c WHERE Specialty_Operations__c=:specOpId AND FAF_ID__c =:fafId limit 1];
        return pharmacyBen.Pharmacy_Benefit__c;
    }
    @AuraEnabled(cacheable=true)
    public static List<Specialty_Pricing__c> getSFSSummaryData(string specOpId, string fafId){
        map<id,Specialty_Pricing__c> specialtyPricingList = new map<id,Specialty_Pricing__c>([
                SELECT Id, 
                Name, 
                Brand_Dispensing_Fee__c, 
                Brand_Rate__c,
                Year__c,
                GER_Guarantee_Rate__c,
                OED_Guarantee_Rate__c,
                LOB__c,
                BER_Guarantee_Rate__c,
                MER_Guarantee_Rate__c,
                Generic_Rate__c,
                Generic_Dispensing_Fee__c
                FROM Specialty_Pricing__c 
                WHERE FAF_ID__r.id =: fafId
                AND Specialty_Operations__r.id =: specOpId 
                ORDER BY LOB__c]);
        
        if(specialtyPricingList.size() > 0){
            list<Specialty_Guarantee__c> specGuaranteeList = [SELECT Type__c, Rate__c,Specialty_Pricing__c FROM Specialty_Guarantee__c 
                                                          WHERE Specialty_Pricing__c =:specialtyPricingList.keyset()];
            if(specGuaranteeList.size() > 0){
                for(Specialty_Guarantee__c eachSpecGuar : specGuaranteeList){
                    if(eachSpecGuar.Type__c == 'BER'){
                        specialtyPricingList.get(eachSpecGuar.Specialty_Pricing__c).BER_Guarantee_Rate__c = eachSpecGuar.Rate__c;
                    }else if(eachSpecGuar.Type__c == 'GER'){
                        specialtyPricingList.get(eachSpecGuar.Specialty_Pricing__c).GER_Guarantee_Rate__c = eachSpecGuar.Rate__c;
                    }else if(eachSpecGuar.Type__c == 'MER'){
                        specialtyPricingList.get(eachSpecGuar.Specialty_Pricing__c).MER_Guarantee_Rate__c = eachSpecGuar.Rate__c;
                    }else if(eachSpecGuar.Type__c == 'OED'){
                        specialtyPricingList.get(eachSpecGuar.Specialty_Pricing__c).OED_Guarantee_Rate__c = eachSpecGuar.Rate__c;
                    }
                }
            }
        }
        
        
        return specialtyPricingList.values();
    }
}