// Test class: Apttus_Mail_GuaranteesTest
public class Apttus_MP_Parent_Controller
{
    @AuraEnabled
    public static list<Mail_Pricing__c> getMailPricing( string mailOpId )
    {
        return [ SELECT Id,
                        Name,
                        Year__c,
                        LOB__c,
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
                        SSGs_into_Brands__c,
                        SSG_Exclusion_List__c,
                        SSG_Exclusivity_Period__c,
                        FAF_Mail_Operations__c
                        FROM Mail_Pricing__c
                        WHERE FAF_Mail_Operations__c =  :mailOpId];
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
    public static void deleteSelectedRecords(List <Mail_Pricing__c> selectedRecordList) {
        system.debug('deleteSelectedRecords'+selectedRecordList);
        List <Mail_Pricing__c> recordsList  = new List <Mail_Pricing__c>() ;
        List <Mail_Pricing__c> recordsToDelete = [SELECT Id FROM Mail_Pricing__c WHERE Id IN: selectedRecordList ];
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
       isDeletable = Schema.sObjectType.Mail_Pricing__c.isDeletable();
       return isDeletable ;
    }
  
  
  
   //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Mail_Pricing__c.isCreateable();
        return isCreateable;
    }
    
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Mail_Pricing__c.isUpdateable();
        return isCreateable;
            }
*/
}