/* ====================================================================
* @Class Name      : BillOtherFeesTriggerHelper
* @author            : Dhron
* @Purpose           : This is the Helper class for Billing Other Fees
========================================================================*/
public with sharing class BillOtherFeesTriggerHelper {
    //Below Method is used to check the Elections on Fee services record before detete the Billing Other Fees record.
    public static void checkElectionOnDelete(List<Billing_Other_Fees__c> billOtherFeesList) {
        try{
            set<Id> FeeIds = new set<Id>();
            List<PBM_Services__c> PBMLstToUpdate = new List<PBM_Services__c>();
            for(Billing_Other_Fees__c BillOtherObj : billOtherFeesList){
                //FeeIds.add(BillOtherObj.Fee_Service_Id__c);
                FeeIds.add(BillOtherObj.Id);
            }
            
            //for(PBM_Services__c PBMObj : [select id,Election__c,Billing_Other_Fees__c,Sync_Source__c,Ignore_Flow__c,DelFlag__c from PBM_Services__c where Fee_Services__c IN:FeeIds AND Election__c =true]){
            for(PBM_Services__c PBMObj : [select id,Election__c,Billing_Other_Fees__c,Sync_Source__c,Ignore_Flow__c,DelFlag__c from PBM_Services__c where Billing_Other_Fees__c IN:FeeIds AND Election__c =true]){
                PBMObj.Election__c = false;                 
                PBMObj.Ignore_Flow__c = true;
                PBMObj.Sync_Source__c = 'Target'; 
                PBMObj.Billing_Other_Fees__c = null;
                PBMLstToUpdate.add(PBMObj);
            }
            
            If(PBMLstToUpdate.size()>0)
            {
                update PBMLstToUpdate;
            }
        }catch(exception e){billOtherFeesList[0].addError(e.getDmlMessage(0)); }
    }
    
    //Method used to validate PBM Services exist
    public static void validatePBMServices(List<Billing_Other_Fees__c> billOtherList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            set<Id> FAFIds = new set<Id>();
            List<Fee_Services__c> feeServiceLst = new List<Fee_Services__c>();
            List<Fee_Service_Template__c> templateLst = new List<Fee_Service_Template__c>();
            for( Billing_Other_Fees__c billOtherObj : billOtherList){
                FAFIds.add(billOtherObj.FAF_ID__c);
                //AncIds.add(ba.Id);
            }
            feeServiceLst = [select id,PBM_Count__c from Fee_Services__c where FAF_ID__c =:FAFIds AND PBM_Count__c=0];
            if(feeServiceLst.Size()>0){
                templateLst = [select id,FAF_Component_Type__c,Item__c from Fee_Service_Template__c where Active__c = True AND FAF_Component__c = 'Billing Ops.Other Fees'];
                if(templateLst.size()>0)
                {
                    for(Billing_Other_Fees__c otherObj : billOtherList)
                    {
                        for(Fee_Service_Template__c tempObj : templateLst){
                            if(tempObj.FAF_Component_Type__c == otherObj.Other_Fee_Type__c && tempObj.Item__c == otherObj.Other_Fee_Description__c){
                                otherObj.addError(ConstantsUtil.Check_PBM_Services_BOF);
                            }
                        }
                    }
                }
            }
        }catch(exception e){billOtherList[0].addError(e.getDmlMessage(0)); }
    }
}