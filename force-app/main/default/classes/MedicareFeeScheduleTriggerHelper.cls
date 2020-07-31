/* ====================================================================
* @Class Name      : MedicareFeeScheduleTriggerHelper
* @author          : Dhron
* @Purpose         : This is the Helper class for Medicare Part D Fees Schedule
========================================================================*/
public with sharing class MedicareFeeScheduleTriggerHelper {
    //Below Method is used to check the Elections on Fee services record before detete the Medicare Part D Fees Schedule record.
    public static void checkElectionOnDelete(List<Medicare_Part_D_Fees_Schedule__c> medicareFeeList) {
        try{
            set<id> fafIds = new set<Id>();
            List<id> FeeServicesIds = new List<Id>();
            List<Retiree_Drug_Subsidy__c> RDSLst = new List<Retiree_Drug_Subsidy__c>();
            
            for(Medicare_Part_D_Fees_Schedule__c mediFee: medicareFeeList)
            { 
                FeeServicesIds.add(mediFee.Id);           
            }
            
            RDSLst = [SELECT Id,FAF_ID__c,Election__c,Medicare_Part_D_Fees_Schedule__c FROM Retiree_Drug_Subsidy__c WHERE Medicare_Part_D_Fees_Schedule__c =: FeeServicesIds AND Election__c =true];
            if(RDSLst.size()>0)
            {
                for(Retiree_Drug_Subsidy__c RDSObj : RDSLst)
                {
                    RDSObj.Election__c= false;
                    RDSObj.DelFlag__c = true;
                    RDSObj.Medicare_Part_D_Fees_Schedule__c = null;
                }
                update RDSLst;
            }
            
        }catch(exception e){medicareFeeList[0].addError(e.getDmlMessage(0)); }
    }
    
    //Method used to validate PBM Services exist
    public static void validatePBMServices(List<Medicare_Part_D_Fees_Schedule__c> medicareList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            set<Id> FAFIds = new set<Id>();
            List<Fee_Services__c> feeServiceLst = new List<Fee_Services__c>();
            List<Fee_Service_Template__c> templateLst = new List<Fee_Service_Template__c>();
            for( Medicare_Part_D_Fees_Schedule__c medPartObj : medicareList){
                FAFIds.add(medPartObj.FAF_ID__c);
            }
            feeServiceLst = [select id,RDS_Count__c from Fee_Services__c where FAF_ID__c =:FAFIds AND RDS_Count__c=0];
            if(feeServiceLst.Size()>0){
                templateLst = [select id,FAF_Component_Type__c,Item__c from Fee_Service_Template__c where Active__c = True AND FAF_Component__c = 'Billing Ops.Medicare Part D Fees Schedules'];
                
                if(templateLst.size()>0)
                {
                    set<string> items = new set<string>();
                    for(Fee_Service_Template__c tempObj : templateLst)
                    {
                        items.add(tempObj.Item__c);
                    }
                    for(Medicare_Part_D_Fees_Schedule__c medObj : medicareList)
                    {
                        if(medObj.Type__c == 'Retiree Drug Subsidy')
                        {
                            string description = string.valueOf(medObj.Fee_Description__c).trim();
                            if(items.contains(description))
                            {
								medObj.addError(ConstantsUtil.Check_RDS_Services_Med);
                            }
                        }
                    }
                }
            }
        }catch(exception e){medicareList[0].addError(e.getDmlMessage(0)); }
    }
}