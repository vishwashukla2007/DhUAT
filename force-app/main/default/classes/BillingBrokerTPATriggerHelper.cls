/* ====================================================================
 * @Class Name      : BillingBrokerTPATriggerHelper
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 12 07 2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the Helper class for Billing Broker TPA
========================================================================
 * @Last modified by  : Sneha Inturi
 * @Last modified date: 09/20/2019
 * @Purpose           : Effective Date and Termination is added to the existing logic.
 ========================================================================*/
public with sharing class BillingBrokerTPATriggerHelper{
//Method used to check duplicacy on LOB and Year in Billing Broker TPA
    public static void validateLobYearCombinalion(List<Billing_Broker_TPA_Payments__c> billBrokList, Boolean isInsertBool, Boolean isUpdateBool) {
    try{
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>();
        Map<string, MAP<string, Id>> billingBrokerIdRelatMap = new Map<string, MAP<string, Id>>();
        MAP<string, Id> tempMap;
        set<Id> billingOpsIdSet = new set<Id>();
        set<string> concatinateStr = new set<string>();
        Set<Id>billingOprIdSet = new Set<Id>();
        String str;
        String str1;
        List<Billing_Broker_TPA_Payments__c> billBrokRecList = new List<Billing_Broker_TPA_Payments__c>();
        for(Billing_Broker_TPA_Payments__c billBrok: billBrokList){
            billingOprIdSet.add(billBrok.billing_operations__c);
        }
        billBrokRecList = [select id, billing_operations__c, year__c, LOB2__c, BrokerTPA_Name__c, Pay_on__c, Type__c, Effective_Date__c, Termination__c from Billing_Broker_TPA_Payments__c
        where billing_operations__c in: billingOprIdSet];
        for(Billing_Broker_TPA_Payments__c billBrok: billBrokRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(billingOpsIdSet.size()>0){
                if(billingOpsIdSet.contains(billBrok.billing_operations__c)){
                    concatinateStr.addall(parentChildMap.get(billBrok.billing_operations__c));
                    concatinateStr.add(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c);
                    parentChildMap.put(billBrok.billing_operations__c, concatinateStr);
                    tempMap.put(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c, billBrok.Id);
                    str = string.valueOf(billBrok.billing_operations__c)+string.valueOf(billBrok.Id);
                    billingBrokerIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c);
                    billingOpsIdSet.add(billBrok.billing_operations__c);
                    parentChildMap.put(billBrok.billing_operations__c, concatinateStr);
                    tempMap.put(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c, billBrok.Id);
                    str = string.valueOf(billBrok.billing_operations__c)+string.valueOf(billBrok.Id);
                    billingBrokerIdRelatMap.put(str,tempMap);
                }
            }else{
                concatinateStr.add(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c);
                billingOpsIdSet.add(billBrok.billing_operations__c);
                parentChildMap.put(billBrok.billing_operations__c, concatinateStr);
                tempMap.put(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c, billBrok.Id);
                str = string.valueOf(billBrok.billing_operations__c)+string.valueOf(billBrok.Id);
                billingBrokerIdRelatMap.put(str,tempMap);
            }
        }
        if(isUpdateBool){
            for(Billing_Broker_TPA_Payments__c billBrok: billBrokList){
                if(billingOpsIdSet.contains(billBrok.billing_operations__c)){
                    if(parentChildMap.get(billBrok.billing_operations__c).contains(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c)){
                        str1 = billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c;
                        str = string.valueOf(billBrok.billing_operations__c)+string.valueOf(billBrok.Id);
                        if(billingBrokerIdRelatMap.get(str).get(str1) != billBrok.id){
                            billBrok.addError(ConstantsUtil.BILL_BRO_YEAR_LOB_ERROR);
                        }
                    }
                }     
            }
        }
        if(isInsertBool){
            for(Billing_Broker_TPA_Payments__c billBrok: billBrokList){
                if(billingOpsIdSet.contains(billBrok.billing_operations__c)){
                    if(parentChildMap.get(billBrok.billing_operations__c).contains(billBrok.year__c + billBrok.LOB2__c + billBrok.BrokerTPA_Name__c + billBrok.Pay_on__c + billBrok.Type__c + billBrok.Effective_Date__c + billBrok.Termination__c)){
                        billBrok.addError(ConstantsUtil.BILL_BRO_YEAR_LOB_ERROR);
                    }
                }     
            }
        }
    }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
    }
}