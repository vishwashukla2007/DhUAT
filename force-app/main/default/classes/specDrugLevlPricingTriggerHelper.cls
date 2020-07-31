/* ===================================================================================================================
 * @Class Name        : specDrugLevlPricingTriggerHelper
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 02/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 02/08/2018
 * @Purpose           : This is the Helper class for Specility Drug Level Pricing Trigger for check the duplicacy
======================================================================================================================*/
public with sharing class specDrugLevlPricingTriggerHelper{

    //method to validate the combination of year, LOB, Pharmacy Benefit, Drug Therapy and Drug Name is unique
    public static void SetUniqueId(List<Specialty_Drug_Level_Pricing__c> specDrugLevlPriceList, Boolean isInsertBool, Boolean isUpdateBool) {
    
       for(Specialty_Drug_Level_Pricing__c specDrugLevel: specDrugLevlPriceList){    
            specDrugLevel.Unique_Id__c = specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c;
        }            
    }
    
    public static void validatedupComb(List<Specialty_Drug_Level_Pricing__c> specDrugLevlPriceList, Boolean isInsertBool, Boolean isUpdateBool) {
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Speciality Operation Id and year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit combination in all associated Speciality Drug Level Pricing
        Map<string, MAP<string, Id>> specDrugLevIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Specialty Operation Id and Specialty drug level Price Id
        MAP<string, Id> tempMap;
        set<Id> specOpsIdSet = new set<Id>();  //Set contain the Specialty operation id
        set<string> concatinateStr = new set<string>(); //set created to add year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit  combination in set
        Set<Id>specialtyOprIdSet = new Set<Id>();   //Used to add Specialty operation id for pass in the query
        String str; 
        String str1;
        List<Specialty_Drug_Level_Pricing__c> specDrugLevlPriceRecList = new List<Specialty_Drug_Level_Pricing__c>();
        
        //Iterate over all Specialty Pricing which are present in the specDrugLevlPriceList list
        for(Specialty_Drug_Level_Pricing__c specDrugLevel: specDrugLevlPriceList){    
            specialtyOprIdSet.add(specDrugLevel.specialty_Operations__c);
        }
        
        //Query data from Specialty Operation Object
        specDrugLevlPriceRecList = [select id, Specialty_operations__c, year__c, LOB__c, Pharmacy_Benefit__c, Drug_Name__c, Drug_Therapy__c from Specialty_Drug_Level_Pricing__c
        where Specialty_operations__c in: specialtyOprIdSet];
        
        //Iterate over all brokerTPA which are present in the specDrugLevlPriceList list
        for(Specialty_Drug_Level_Pricing__c specDrugLevel: specDrugLevlPriceRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(specOpsIdSet.size()>0){
                if(specOpsIdSet.contains(specDrugLevel.specialty_Operations__c)){
                    concatinateStr.addall(parentChildMap.get(specDrugLevel.specialty_Operations__c));   //add all value present with the concerned Specialty Operation
                    concatinateStr.add(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c);  //concatenate and add new value in the set
                    parentChildMap.put(specDrugLevel.specialty_Operations__c, concatinateStr);
                    tempMap.put(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c, specDrugLevel.Id);     //temp map which contain the year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit combination as key and Specialty Pricing id and value
                    str = string.valueOf(specDrugLevel.specialty_Operations__c)+string.valueOf(specDrugLevel.Id);  //concatenate Specialty Operation id and Broker TPA Id 
                    specDrugLevIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c);   //concatenate and add new value in the set
                    specOpsIdSet.add(specDrugLevel.specialty_Operations__c);
                    parentChildMap.put(specDrugLevel.specialty_Operations__c, concatinateStr);
                    tempMap.put(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c, specDrugLevel.Id);      //temp map which contain the year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit combination as key and Specialty Pricing id and value
                    str = string.valueOf(specDrugLevel.specialty_Operations__c)+string.valueOf(specDrugLevel.Id);   //concatenate Specialty Operation id and Broker TPA Id 
                    specDrugLevIdRelatMap.put(str,tempMap);
                }
            }else{  //This condition will execute first time the loop will execute
                concatinateStr.add(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c);   //concatenate and add new value in the set
                specOpsIdSet.add(specDrugLevel.specialty_Operations__c);
                parentChildMap.put(specDrugLevel.specialty_Operations__c, concatinateStr);
                tempMap.put(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c, specDrugLevel.Id);       //temp map which contain the year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit combination as key and Specialty Pricing id and value
                str = string.valueOf(specDrugLevel.specialty_Operations__c)+string.valueOf(specDrugLevel.Id);       //concatenate Specialty Operation id and Speciality Drug Level Price Id 
                specDrugLevIdRelatMap.put(str,tempMap);
            }
        }
        if(isUpdateBool){  //Value to check it is insert case or Update
            for(Specialty_Drug_Level_Pricing__c specDrugLevel: specDrugLevlPriceList){
                if(specOpsIdSet.contains(specDrugLevel.specialty_Operations__c)){   //check specOpsIdSet set contain Specialty Operation
                    if(parentChildMap.get(specDrugLevel.specialty_Operations__c).contains(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c)){   //verify that set associated with unique Specialty Operation contains the year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit
                        str1 = specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c;
                        str = string.valueOf(specDrugLevel.specialty_Operations__c)+string.valueOf(specDrugLevel.Id);   //concatenate Specialty Operation and Speciality Drug Level Price Id 
                        if(specDrugLevIdRelatMap.get(str).get(str1) != specDrugLevel.id){      //For exclude the update condition
                            specDrugLevel.addError(ConstantsUtil.SPECDRUGLEVELPRICEMSG);   //Display error
                        }
                    }
                }     
            }
        }
        if(isInsertBool){ //Boolean used to identify the insert scenario
            for(Specialty_Drug_Level_Pricing__c specDrugLevel: specDrugLevlPriceList){
                if(specOpsIdSet.contains(specDrugLevel.specialty_Operations__c)){
                    if(parentChildMap.get(specDrugLevel.specialty_Operations__c).contains(specDrugLevel.year__c + specDrugLevel.LOB__c + specDrugLevel.Drug_Name__c + specDrugLevel.Drug_Therapy__c + specDrugLevel.Pharmacy_Benefit__c)){    //verify that set associated with unique Specialty Operation contains the year, Lob, drug Theraphy, Drug Name and Pharmacy Benefit Combination
                        specDrugLevel.addError(ConstantsUtil.SPECDRUGLEVELPRICEMSG);  //Display error
                    }
                }     
            }
        }
    }
}