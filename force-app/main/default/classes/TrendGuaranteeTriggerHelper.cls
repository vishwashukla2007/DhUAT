/* ====================================================================
 * @Class Name      : TrendGuaranteeTriggerHelper
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 30 07 2018
 * @Purpose           : This is the Helper class for Trend Guarantee
========================================================================*/
public with sharing class TrendGuaranteeTriggerHelper{

    //Method used to check duplicay on year and LOB in Broker Trend Guarantee
    public static void validateLobYearCombination(List<Trend_Guarantee__c> TrendGuaranteeList, Boolean isInsertBool, Boolean isUpdateBool) {
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Guarantee Information Id and year, Lob combination in all associated Billing Broker TPA
        Map<string, MAP<string, Id>> TrendGuaranteeIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Guarantee Info Id and Trend Guarantee Id
        MAP<string, Id> tempMap;
        set<string> concatinateStr = new set<string>(); //set created to add year and LOB combination in set
        Set<Id>GuaranteeInforIdSet = new Set<Id>();   //Used to add Guarantee Information Id for pass in the query
        String str; 
        String str1;
        List<Trend_Guarantee__c> GuaranteeInfoRecList = new List<Trend_Guarantee__c>();
        set<Id> GuaranteeInfoIdSet = new set<Id>();  //Set contain the Guarantee Info id
        for(Trend_Guarantee__c GuaranteeInfo: TrendGuaranteeList){    
            GuaranteeInforIdSet.add(GuaranteeInfo.Guarantee_Information__c);
        }
        
        
        //Iterate over all brokerTPA which are present in the TrendGuaranteeList list
        //Query data from Guarantee Information Object
        GuaranteeInfoRecList = [select id, Guarantee_Information__c, year__c, LOB__c, Guarantee_Type__c, Drug_Type__c from Trend_Guarantee__c
        where Guarantee_Information__c in: GuaranteeInforIdSet];
        
        //Iterate over all brokerTPA which are present in the TrendGuaranteeList list
        for(Trend_Guarantee__c GuaranteeInfo: GuaranteeInfoRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(GuaranteeInfoIdSet.size()>0){
                if(GuaranteeInfoIdSet.contains(GuaranteeInfo.Guarantee_Information__c)){
                    concatinateStr.addall(parentChildMap.get(GuaranteeInfo.Guarantee_Information__c));   //add all value present with the concerned Guarantee Information
                    concatinateStr.add(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c);  //concatenate and add new value in the set
                    parentChildMap.put(GuaranteeInfo.Guarantee_Information__c, concatinateStr);
                    tempMap.put(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c, GuaranteeInfo.Id);     //temp map which contain the year,LOB combination as key and Guarantee Information id and value
                    str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);  //concatenate Guarantee Information Id and Guarantee Information Id 
                    TrendGuaranteeIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c);   //concatenate and add new value in the set
                    GuaranteeInfoIdSet.add(GuaranteeInfo.Guarantee_Information__c);
                    parentChildMap.put(GuaranteeInfo.Guarantee_Information__c, concatinateStr);
                    tempMap.put(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c, GuaranteeInfo.Id);      //temp map which contain the year,LOB combination as key and Guarantee Information id and value
                    str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);   //concatenate Guarantee Information Id and Guarantee Information Id 
                    TrendGuaranteeIdRelatMap.put(str,tempMap);
                }
            }else{  //This condition will execute first time the loop will execute
                concatinateStr.add(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c);   //concatenate and add new value in the set
                GuaranteeInfoIdSet.add(GuaranteeInfo.Guarantee_Information__c);
                parentChildMap.put(GuaranteeInfo.Guarantee_Information__c, concatinateStr);
                tempMap.put(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c, GuaranteeInfo.Id);      //temp map which contain the year,LOB combination as key and Guarantee Information id and value
                str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);       //concatenate Guarantee Information Id and Guarantee Information Id 
                TrendGuaranteeIdRelatMap.put(str,tempMap);
            }
        }
        if(isUpdateBool){  //Value to check it is insert case or Update
            for(Trend_Guarantee__c GuaranteeInfo: TrendGuaranteeList){
                if(GuaranteeInfoIdSet.contains(GuaranteeInfo.Guarantee_Information__c)){  //check GuaranteeInfoIdSet set contain Guarantee Information
                    if(parentChildMap.get(GuaranteeInfo.Guarantee_Information__c).contains(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c)){  //verify that set associated with unique Guarantee Information contains the year, Lob combination
                        str1 = GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c;
                        str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);  //concatenate Guarantee Information and Guarantee Information Id 
                        if(TrendGuaranteeIdRelatMap.get(str).get(str1) != GuaranteeInfo.id){      //For exclude the update condition
                            GuaranteeInfo.addError(ConstantsUtil.YEARLOBERROR);  //Display error
                        }
                    }
                }     
            }
        }
        if(isInsertBool){ //Boolean used to identify the insert scenario
            for(Trend_Guarantee__c GuaranteeInfo: TrendGuaranteeList){
                if(GuaranteeInfoIdSet.contains(GuaranteeInfo.Guarantee_Information__c)){
                    if(parentChildMap.get(GuaranteeInfo.Guarantee_Information__c).contains(GuaranteeInfo.year__c + GuaranteeInfo.LOB__c + GuaranteeInfo.Guarantee_Type__c + GuaranteeInfo.Drug_Type__c)){  //verify that set associated with unique Guarantee Information contains the year, Lob combination
                        GuaranteeInfo.addError(ConstantsUtil.YEARLOBTYPEERROR);  //Display error
                    }
                }     
            }
        }
    }
}