public class Apttus_NP_Retail_Gurantee {
@AuraEnabled
public static List <Retail_Network_Guarantees__c> getNPGurantee(String netpriceId) {
List<Retail_Network_Guarantees__c> retailGurantees = new List<Retail_Network_Guarantees__c>();

        List<Retail_Network_Guarantees__c> retailGurantee = [SELECT Name,Id, 
                                                   Type__c, 
                                                   Rate__c,
                                                   ZBD__c,
                                                   U_C__c,
                                                   SSG__c,
                                                   X340B__c,
                                                   Compound__c,
                                                   Vaccine__c,
                                                   Paper__c,
                                                   OTC__c,
                                                   COB__c,
                                                   LDD__c,
                                                   Biosimilars__c,  
                                                   Mirror_Mail_Guarantees__c,
                                                   LDD_Inclusion_Option__c,
                                                   X340B_Inclusion_Option__c,          
                                                   Network_Pricing__c,
                                                   Vaccine_Inclusion_Option__c          
                                                   FROM Retail_Network_Guarantees__c WHERE Network_Pricing__c =:netpriceId];
        for (Retail_Network_Guarantees__c ntp : retailGurantee) {
            retailGurantees.add(ntp);
        }
        return retailGurantees;
   }
    
    @AuraEnabled
    public static List<Retail_Network_Guarantees__c> deleteSelectedRecords(String netpriceId, List<Retail_Network_Guarantees__c> selectedRecordList) {
        system.debug('deleteSelectedRecords'+selectedRecordList);
        List<Retail_Network_Guarantees__c> recordsList  = new List<Retail_Network_Guarantees__c>() ;
        List<Retail_Network_Guarantees__c> recordsToDelete = [SELECT Id FROM Retail_Network_Guarantees__c WHERE Id IN: selectedRecordList ];
        try{
            delete recordsToDelete;
        } catch(Exception ex){
            system.debug('Exception' +ex.getMessage());
             throw new AurahandledException(ex.getDmlMessage(0));
             //throw new AurahandledException(ex.getDmlMessage(0));
        }
        recordsList.addAll(getNPGurantee(netpriceId));
        return recordsList;
    
    }

    /*
    @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Retail_Network_Guarantees__c.isDeletable();
        return isDeletable; 
    }
*/
}