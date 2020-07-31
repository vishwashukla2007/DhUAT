// Test class: Apttus_Mail_GuaranteesTest
public class Apttus_Mail_Guarantees 
{
    @AuraEnabled
    public static list<Mail_Guarantees__c> getMailGuarantees( string mpId )
    {
        return [ SELECT Id,
                        Name,
                        Type__c,
                        Rate__c,
                        ZBD__c,
                        SSG__c,
                        OTC__c,
                        X340B__c,
                        X340B_Inclusion_Option__c,
                        Biosimilars__c,
                        LDD__c,
                        LDD_Inclusion_Option__c,
                        Compound__c,
                        Vaccine__c,
                        Paper__c,
                        COB__c,
                        Vaccine_Inclusion_Option__c
                        FROM Mail_Guarantees__c
                        WHERE Mail_Pricing__c = :mpId
                ];
    }
    
    @AuraEnabled
    public static List<Mail_Guarantees__c> deleteSelectedRecords(String mpId, List<Mail_Guarantees__c> selectedRecordList) {
        system.debug('deleteSelectedRecords'+selectedRecordList);
        List<Mail_Guarantees__c> recordsList  = new List<Mail_Guarantees__c>() ;
        List<Mail_Guarantees__c> recordsToDelete = [SELECT Id FROM Mail_Guarantees__c WHERE Id IN: selectedRecordList ];
        try{
            delete recordsToDelete;
         recordsList = getMailGuarantees(mpId);
        return recordsList;
        } catch(Exception ex){
            system.debug('Exception' +ex.getMessage());
             throw new AurahandledException(ex.getDmlMessage(0));
        }
        
    }
/*    
    @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Mail_Guarantees__c.isDeletable();
        return isDeletable; 
    }
    
    

     //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Mail_Guarantees__c.isCreateable();
        return isCreateable;
    }
    
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Mail_Guarantees__c.isUpdateable();
        return isCreateable;
        }
*/
}