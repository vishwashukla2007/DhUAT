public with sharing class Apttus_Specialty_Guarantee {
  
@AuraEnabled
public static List <Specialty_Guarantee__c> getSpecialtyguarantee(String spriceid) {
List<Specialty_Guarantee__c> specialtyguarantees = new List<Specialty_Guarantee__c>();

        List<Specialty_Guarantee__c> specialtyguarantee = [SELECT id, 
                                                   X340B__c,
                                                   X340B_Exclusion_Option__c,
                                                   Biosimilars__c,
                                                   COB__c,
                                                   Name,
                                                   Compound__c,
                                                   LDD__c,
                                                   Link__c,
                                                   LDD_Exclusion_Option__c,
                                                   New_to_Market_Brands__c,
                                                   New_to_Market_Generics__c,
                                                   OTC__c,
                                                   Paper__c,
                                                   Rate__c,
                                                   SSG__c,
                                                   Subtype__c,
                                                   Type__c,
                                                   Vaccine__c,
                                                   ZBD__c
                                                   FROM Specialty_Guarantee__c WHERE Specialty_Pricing__c =:spriceid ];
        for (Specialty_Guarantee__c sg : specialtyGuarantee) {
            specialtyGuarantees.add(sg);
        }
        return specialtyGuarantees;
    }    
    
    @AuraEnabled
    public static List<Specialty_Guarantee__c> deleteSelectedRecords(String sPriceId, List<Specialty_Guarantee__c> selectedRecordList) {
        system.debug('deleteSelectedRecords'+selectedRecordList);
        List<Specialty_Guarantee__c> recordsList  = new List<Specialty_Guarantee__c>() ;
        List<Specialty_Guarantee__c> recordsToDelete = [SELECT Id FROM Specialty_Guarantee__c WHERE Id IN: selectedRecordList ];
        try{
            delete recordsToDelete;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
           
        }
        system.debug('After deleteSelectedRecords'+selectedRecordList.size());
        recordsList = getSpecialtyguarantee(sPriceId);
        return recordsList;
    }
    /*
    @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Specialty_Guarantee__c.isDeletable();
        return isDeletable; 
    }
    
    
    
     //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Specialty_Guarantee__c.isCreateable();
        return isCreateable;
    }
    
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Specialty_Guarantee__c.isUpdateable();
        return isCreateable;
        }
*/
}