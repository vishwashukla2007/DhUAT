/* ====================================================================
 * @Class Name      : GDRGuaranteeTriggerHelper
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 05/09/2018
 * @Purpose           : This is the Helper class for GDR Guarantee
========================================================================*/
public with sharing class GDRGuaranteeTriggerHelper{

    //Method used to check duplicacy on type in GDR Guarantee
    public static void validateTypeCombination(List<GDR_Guarantee__c> GDRGuaranteeList, Boolean isInsertBool, Boolean isUpdateBool) {
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Guarantee Information Id and type in all associated Billing Broker TPA
        Map<string, MAP<string, Id>> GDRGuaranteeIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Guarantee Info Id and GDR Guarantee Id
        MAP<string, Id> tempMap;
        set<string> concatinateStr = new set<string>(); //set created to add type in set
        Set<Id>GuaranteeInforIdSet = new Set<Id>();   //Used to add Guarantee Information Id for pass in the query
        String str; 
        String str1;
        List<GDR_Guarantee__c> GuaranteeInfoRecList = new List<GDR_Guarantee__c>();
        set<Id> GuaranteeInfoIdSet = new set<Id>();  //Set contain the Guarantee Info id
        for(GDR_Guarantee__c GuaranteeInfo: GDRGuaranteeList){    
            GuaranteeInforIdSet.add(GuaranteeInfo.Guarantee_Information__c);
        }
        
        
        //Iterate over all brokerTPA which are present in the GDRGuaranteeList list
        //Query data from Guarantee Information Object
        GuaranteeInfoRecList = [select id, Guarantee_Information__c,Guarantee_Type__c from GDR_Guarantee__c
        where Guarantee_Information__c in: GuaranteeInforIdSet];
        
        //Iterate over all brokerTPA which are present in the GDRGuaranteeList list
        for(GDR_Guarantee__c GuaranteeInfo: GuaranteeInfoRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(GuaranteeInfoIdSet.size()>0){
                if(GuaranteeInfoIdSet.contains(GuaranteeInfo.Guarantee_Information__c)){
                    concatinateStr.addall(parentChildMap.get(GuaranteeInfo.Guarantee_Information__c));   //add all value present with the concerned Guarantee Information
                    concatinateStr.add(GuaranteeInfo.Guarantee_Type__c);  //concatenate and add new value in the set
                    parentChildMap.put(GuaranteeInfo.Guarantee_Information__c, concatinateStr);
                    tempMap.put(GuaranteeInfo.Guarantee_Type__c, GuaranteeInfo.Id);     //temp map which contain the type combination as key and Guarantee Information id and value
                    str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);  //concatenate Guarantee Information Id and Guarantee Information Id 
                    GDRGuaranteeIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(GuaranteeInfo.Guarantee_Type__c);   //concatenate and add new value in the set
                    GuaranteeInfoIdSet.add(GuaranteeInfo.Guarantee_Information__c);
                    parentChildMap.put(GuaranteeInfo.Guarantee_Information__c, concatinateStr);
                    tempMap.put(GuaranteeInfo.Guarantee_Type__c, GuaranteeInfo.Id);      //temp map which contain the type combination as key and Guarantee Information id and value
                    str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);   //concatenate Guarantee Information Id and Guarantee Information Id 
                    GDRGuaranteeIdRelatMap.put(str,tempMap);
                }
            }else{  //This condition will execute first time the loop will execute
                concatinateStr.add(GuaranteeInfo.Guarantee_Type__c);   //concatenate and add new value in the set
                GuaranteeInfoIdSet.add(GuaranteeInfo.Guarantee_Information__c);
                parentChildMap.put(GuaranteeInfo.Guarantee_Information__c, concatinateStr);
                tempMap.put(GuaranteeInfo.Guarantee_Type__c, GuaranteeInfo.Id);      //temp map which contain the type combination as key and Guarantee Information id and value
                str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);       //concatenate Guarantee Information Id and Guarantee Information Id 
                GDRGuaranteeIdRelatMap.put(str,tempMap);
            }
        }
        if(isUpdateBool){  //Value to check it is insert case or Update
            for(GDR_Guarantee__c GuaranteeInfo: GDRGuaranteeList){
                if(GuaranteeInfoIdSet.contains(GuaranteeInfo.Guarantee_Information__c)){  //check GuaranteeInfoIdSet set contain Guarantee Information
                    if(parentChildMap.get(GuaranteeInfo.Guarantee_Information__c).contains(GuaranteeInfo.Guarantee_Type__c)){  //verify that set associated with unique Guarantee Information contains the type
                        str1 = GuaranteeInfo.Guarantee_Type__c;
                        str = string.valueOf(GuaranteeInfo.Guarantee_Information__c)+string.valueOf(GuaranteeInfo.Id);  //concatenate Guarantee Information and Guarantee Information Id 
                        if(GDRGuaranteeIdRelatMap.get(str).get(str1) != GuaranteeInfo.id){      //For exclude the update condition
                            GuaranteeInfo.addError(ConstantsUtil.TYPEERROR);  //Display error
                        }
                    }
                }     
            }
        }
        if(isInsertBool){ //Boolean used to identify the insert scenario
            for(GDR_Guarantee__c GuaranteeInfo: GDRGuaranteeList){
                if(GuaranteeInfoIdSet.contains(GuaranteeInfo.Guarantee_Information__c)){
                    if(parentChildMap.get(GuaranteeInfo.Guarantee_Information__c).contains(GuaranteeInfo.Guarantee_Type__c)){  //verify that set associated with unique Guarantee Information contains the type
                        GuaranteeInfo.addError(ConstantsUtil.TYPEERROR);  //Display error
                    }
                }     
            }
        }
    }
}