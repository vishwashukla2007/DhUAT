/*********************************************************************************************
 * @ClassName         : SpecialtyGuaranteeTriggerHelper
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 10/08/2018
 * @Last modified by  : 
 * @Last modified date: 10/08/2018
 * @Purpose           : This is the Helper class for TR_SpecialtyGuarantee
 **********************************************************************************************/
public with sharing class SpecialtyGuaranteeTriggerHelper{

    //Method used to check duplicacy on Type, SubType in all associated Specialty Legacy Drug Level Pricing
    public static void validateTypeSubtypeCombination(List<Specialty_Guarantee__c> SpecGuaranteeLevelPricingList, Boolean isInsertBool, Boolean isUpdateBool) {
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Specialty Pricing Id and Type, SubType combination in all associated Guarantee Information
        Map<string, MAP<string, Id>> SpecGuaranteeIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Specialty Pricing Id and Specialty Legacy Drug Level Pricing Id
        MAP<string, Id> tempMap;
        set<string> concatinateStr = new set<string>(); //set created to add Type, SubType in all associated Specialty Legacy Drug Level Pricing record
        Set<Id>SpecGuaranteesIdSet = new Set<Id>();   //Used to add Specialty Pricing Id for pass in the query
        String str; 
        String str1;
        List<Specialty_Guarantee__c> SpecGuaranteeRecList = new List<Specialty_Guarantee__c>();
        set<Id> SpecGteeIdSet = new set<Id>();  //Set contain the Specialty Pricing id
        for(Specialty_Guarantee__c SpecGuarantee: SpecGuaranteeLevelPricingList){    
            SpecGuaranteesIdSet.add(SpecGuarantee.Specialty_Pricing__c);
        }
        
        
        //Iterate over all Specialty Guarantee which are present in the SpecGuaranteeLevelPricingList list
        //Query data from Specialty Pricing Object
        SpecGuaranteeRecList = [select id, Specialty_Pricing__c, Type__c, Subtype__c from Specialty_Guarantee__c
        where   Specialty_Pricing__c in: SpecGuaranteesIdSet];
        
        //Iterate over all Specialty Guarantee which are present in the SpecGuaranteeLevelPricingList list
        for(Specialty_Guarantee__c SpecGuarantee: SpecGuaranteeRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(SpecGteeIdSet.size()>0){
                if(SpecGteeIdSet.contains(SpecGuarantee.Specialty_Pricing__c)){
                    concatinateStr.addall(parentChildMap.get(SpecGuarantee.Specialty_Pricing__c));   //add all value present with the concerned Specialty Pricing
                    concatinateStr.add(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c );  //concatenate and add new value in the set
                    parentChildMap.put(SpecGuarantee.Specialty_Pricing__c, concatinateStr);
                    tempMap.put(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c , SpecGuarantee.Id);     //temp map which contain the Type,SubType combination as key and Specialty Pricing id and value
                    str = string.valueOf(SpecGuarantee.Specialty_Pricing__c)+string.valueOf(SpecGuarantee.Id);  //concatenate Specialty Pricing Id and Specialty Pricing Id 
                    SpecGuaranteeIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c );   //concatenate and add new value in the set
                    SpecGteeIdSet.add(SpecGuarantee.Specialty_Pricing__c);
                    parentChildMap.put(SpecGuarantee.Specialty_Pricing__c, concatinateStr);
                    tempMap.put(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c , SpecGuarantee.Id);      //temp map which contain the Type,SubType combination as key and Specialty Pricing id and value
                    str = string.valueOf(SpecGuarantee.Specialty_Pricing__c)+string.valueOf(SpecGuarantee.Id);   //concatenate Specialty Pricing Id and Specialty Pricing Id 
                    SpecGuaranteeIdRelatMap.put(str,tempMap);
                }
            }else{  //This condition will execute first time the loop will execute
                concatinateStr.add(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c );   //concatenate and add new value in the set
                SpecGteeIdSet.add(SpecGuarantee.Specialty_Pricing__c);
                parentChildMap.put(SpecGuarantee.Specialty_Pricing__c, concatinateStr);
                tempMap.put(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c , SpecGuarantee.Id);      //temp map which contain the Type,SubType combination as key and Specialty Pricing id and value
                str = string.valueOf(SpecGuarantee.Specialty_Pricing__c)+string.valueOf(SpecGuarantee.Id);       //concatenate Specialty Pricing Id and Specialty Pricing Id 
                SpecGuaranteeIdRelatMap.put(str,tempMap);
            }
        }
        if(isUpdateBool){  //Value to check it is insert case or Update
            for(Specialty_Guarantee__c SpecGuarantee: SpecGuaranteeLevelPricingList){
                if(SpecGteeIdSet.contains(SpecGuarantee.Specialty_Pricing__c)){  //check SpecGteeIdSet set contain Specialty Pricing
                    if(parentChildMap.get(SpecGuarantee.Specialty_Pricing__c).contains(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c )){  //verify that set associated with unique Specialty Pricing contains the Type, SubType combination
                        str1 = SpecGuarantee.Type__c + SpecGuarantee.Subtype__c ;
                        str = string.valueOf(SpecGuarantee.Specialty_Pricing__c)+string.valueOf(SpecGuarantee.Id);  //concatenate Specialty Pricing and Specialty Pricing Id 
                        if(SpecGuaranteeIdRelatMap.get(str).get(str1) != SpecGuarantee.id){      //For exclude the update condition
                            SpecGuarantee.addError(ConstantsUtil.SPECGTEEVALIDATEERROR);  //Display error
                        }
                    }
                }     
            }
        }
        if(isInsertBool){ //Boolean used to identify the insert scenario
            for(Specialty_Guarantee__c SpecGuarantee: SpecGuaranteeLevelPricingList){
                if(SpecGteeIdSet.contains(SpecGuarantee.Specialty_Pricing__c)){
                    if(parentChildMap.get(SpecGuarantee.Specialty_Pricing__c).contains(SpecGuarantee.Type__c + SpecGuarantee.Subtype__c )){  //verify that set associated with unique Specialty Pricing contains the Type, SubType, Pharmacy Benefit, Price List Type combination
                        SpecGuarantee.addError(ConstantsUtil.SPECGTEEVALIDATEERROR);  //Display error
                    }
                }     
            }
        }
    }
}