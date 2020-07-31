public class FeeServiceTemplateController {
    
    public Fee_Service_Template__c fst {get;set;}
    
    public FeeServiceTemplateController(ApexPages.StandardController stdCntrlr){
        this.fst = (Fee_Service_Template__c)stdCntrlr.getRecord();
        if(fst.Id != null){
            fst = [SELECT Id,Name,Template_Type__c,Section_Limited__c,Print_Static__c,Active__c,Auxiliary_Text__c,Auxiliary_checkbox__c,Effective_date__c,Expiration_Date__c,Item__c,
                   Item_Section__c,Amount__c,Max_Amount__c,FAF_Component__c,Basis2__c,LOB__c,Election_Protected__c,
                   Item_Description__c,FAF_Component_Type__c,Item_Description2__c,Automation_Logic__c,Sequence__c,
                   Market_Segment__c,Additional_Service__c,Column__c,Sub_Section__c,Core_Service__c,Fee_Type_1__c
                   FROM Fee_Service_Template__c WHERE Id =: fst.Id];
        }
    }
    
    public PageReference saveFeeServiceTemplate(){
        PageReference pg;
        try{
        upsert fst;
            pg = new PageReference('/' + fst.Id);
        }
        catch(Exception e){
//            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            ApexPages.addMessages(e);
            return null;
        }
        return pg;
    } 
}