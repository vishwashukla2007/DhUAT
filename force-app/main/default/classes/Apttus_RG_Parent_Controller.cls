public with sharing class Apttus_RG_Parent_Controller{
 

@AuraEnabled
public static list<Rebate_Guarantees__c> getRebateGuarantee( string RGOpId )
{
List<Rebate_Guarantees__c>rebateguarantees = new List<Rebate_Guarantees__c>();

        List<Rebate_Guarantees__c> rebateguarantee = [ SELECT Id,
                        Name,
                        Year__c,
                        LOB2__c,
                        Basis__c,
                        GSTP__c,
                        Link__c,
                        Non_Specialty_Formulary_2__c,
                        Plan_Design__c,
                        Specialty_Formulary__c,
                        Retail_30__c,
                        Retail_30_1__c,
                        Retail_90__c,
                        Retail_90_1__c,
                        Mail__c,
                        Mail_1__c,
                        Mchoice_1__c,
                        Mchoice__c,
                        Specialty__c,
                        Specialty_1__c,
                        Specialty_Retail_1__c,
                        Specialty_Retail__c,
                        Client_Owned_30__c,
                        Client_Owned_30_1__c,
                        Client_Owned_90__c,
                        Client_Owned_90_1__c,
                        RebateExpandedView__c
                        FROM Rebate_Guarantees__c
                        WHERE Rebate_Operations__c =  :RGOpId order by Non_Specialty_Formulary_2__c,Specialty_Formulary__c,GSTP__c,Year__c,Plan_Design__c,CreatedDate ASC ];
        for (Rebate_Guarantees__c rg : rebateguarantee ) {
            rebateguarantees .add(rg);
        }
        return rebateguarantees ;
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
    public static void deleteSelectedRecords(List <Rebate_Guarantees__c> selectedRecordList) {
        try{
            delete selectedRecordList;
        } catch(Exception ex){
            system.debug('Exception' +ex.getMessage());
             throw new AurahandledException(ex.getDmlMessage(0));
        }
    
}
    /*
    @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Rebate_Guarantees__c.isDeletable();
        return isDeletable; 
    }
    
    
    
     //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Rebate_Guarantees__c.isCreateable();
        return isCreateable;
    }
    
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Rebate_Guarantees__c.isUpdateable();
        return isCreateable;
        }
*/
}