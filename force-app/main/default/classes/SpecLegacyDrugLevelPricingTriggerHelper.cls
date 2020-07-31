/* ====================================================================
 * @Class Name      : SpecLegacyDrugLevelPricingTriggerHelper
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 30 07 2018
 * @Purpose           : This is the Helper class for Specialty Legacy Drug Level Pricing
========================================================================*/
public with sharing class SpecLegacyDrugLevelPricingTriggerHelper{

    //Method used to check duplicacy on year, LOB, Pharmacy Benefit and Price List Type all associated Specialty Legacy Drug Level Pricing
    public static void validatePricingFieldsCombination(List<Specialty_Legacy_Drug_Level_pricing__c> SpecLegacyDrugLevelPricingList, Boolean isInsertBool, Boolean isUpdateBool) {
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Specialty Ops Id and year, Lob combination in all associated Billing Broker TPA
        Map<string, MAP<string, Id>> SpecLegacyDrugLevelPricingIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Specialty Ops Id and Specialty Legacy Drug Level Pricing Id
        MAP<string, Id> tempMap;
        set<string> concatinateStr = new set<string>(); //set created to add year, LOB, Pharmacy Benefit and Price List Type in all associated Specialty Legacy Drug Level Pricing record
        Set<Id>SpecLegacyDrugrIdSet = new Set<Id>();   //Used to add Specialty Ops Id for pass in the query
        String str; 
        String str1;
        List<Specialty_Legacy_Drug_Level_pricing__c> SpecLegacyDrugRecList = new List<Specialty_Legacy_Drug_Level_pricing__c>();
        set<Id> SpecLegacyDrugIdSet = new set<Id>();  //Set contain the Specialty Ops id
        for(Specialty_Legacy_Drug_Level_pricing__c SpecLegacyDrug: SpecLegacyDrugLevelPricingList){    
            SpecLegacyDrugrIdSet.add(SpecLegacyDrug.Specialty_Ops__c);
        }
        
        
        //Iterate over all brokerTPA which are present in the SpecLegacyDrugLevelPricingList list
        //Query data from Specialty Ops Object
        SpecLegacyDrugRecList = [select id, Specialty_Ops__c, year__c,LOB__c,Pharmacy_Benefit__c,Price_List_Type__c from Specialty_Legacy_Drug_Level_pricing__c
        where Specialty_Ops__c in: SpecLegacyDrugrIdSet];
        
        //Iterate over all brokerTPA which are present in the SpecLegacyDrugLevelPricingList list
        for(Specialty_Legacy_Drug_Level_pricing__c SpecLegacyDrug: SpecLegacyDrugRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(SpecLegacyDrugIdSet.size()>0){
                if(SpecLegacyDrugIdSet.contains(SpecLegacyDrug.Specialty_Ops__c)){
                    concatinateStr.addall(parentChildMap.get(SpecLegacyDrug.Specialty_Ops__c));   //add all value present with the concerned Specialty Ops
                    concatinateStr.add(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c );  //concatenate and add new value in the set
                    parentChildMap.put(SpecLegacyDrug.Specialty_Ops__c, concatinateStr);
                    tempMap.put(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c , SpecLegacyDrug.Id);     //temp map which contain the year,LOB combination as key and Specialty Ops id and value
                    str = string.valueOf(SpecLegacyDrug.Specialty_Ops__c)+string.valueOf(SpecLegacyDrug.Id);  //concatenate Specialty Ops Id and Specialty Ops Id 
                    SpecLegacyDrugLevelPricingIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c );   //concatenate and add new value in the set
                    SpecLegacyDrugIdSet.add(SpecLegacyDrug.Specialty_Ops__c);
                    parentChildMap.put(SpecLegacyDrug.Specialty_Ops__c, concatinateStr);
                    tempMap.put(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c , SpecLegacyDrug.Id);      //temp map which contain the year,LOB combination as key and Specialty Ops id and value
                    str = string.valueOf(SpecLegacyDrug.Specialty_Ops__c)+string.valueOf(SpecLegacyDrug.Id);   //concatenate Specialty Ops Id and Specialty Ops Id 
                    SpecLegacyDrugLevelPricingIdRelatMap.put(str,tempMap);
                }
            }else{  //This condition will execute first time the loop will execute
                concatinateStr.add(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c );   //concatenate and add new value in the set
                SpecLegacyDrugIdSet.add(SpecLegacyDrug.Specialty_Ops__c);
                parentChildMap.put(SpecLegacyDrug.Specialty_Ops__c, concatinateStr);
                tempMap.put(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c , SpecLegacyDrug.Id);      //temp map which contain the year,LOB combination as key and Specialty Ops id and value
                str = string.valueOf(SpecLegacyDrug.Specialty_Ops__c)+string.valueOf(SpecLegacyDrug.Id);       //concatenate Specialty Ops Id and Specialty Ops Id 
                SpecLegacyDrugLevelPricingIdRelatMap.put(str,tempMap);
            }
        }
        if(isUpdateBool){  //Value to check it is insert case or Update
            for(Specialty_Legacy_Drug_Level_pricing__c SpecLegacyDrug: SpecLegacyDrugLevelPricingList){
                if(SpecLegacyDrugIdSet.contains(SpecLegacyDrug.Specialty_Ops__c)){  //check SpecLegacyDrugIdSet set contain Specialty Ops
                    if(parentChildMap.get(SpecLegacyDrug.Specialty_Ops__c).contains(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c )){  //verify that set associated with unique Specialty Ops contains the year, Lob combination
                        str1 = SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c ;
                        str = string.valueOf(SpecLegacyDrug.Specialty_Ops__c)+string.valueOf(SpecLegacyDrug.Id);  //concatenate Specialty Ops and Specialty Ops Id 
                        if(SpecLegacyDrugLevelPricingIdRelatMap.get(str).get(str1) != SpecLegacyDrug.id){      //For exclude the update condition
                            SpecLegacyDrug.addError(ConstantsUtil.SPECLEGVALIDATEERROR);  //Display error
                        }
                    }
                }     
            }
        }
        if(isInsertBool){ //Boolean used to identify the insert scenario
            for(Specialty_Legacy_Drug_Level_pricing__c SpecLegacyDrug: SpecLegacyDrugLevelPricingList){
                if(SpecLegacyDrugIdSet.contains(SpecLegacyDrug.Specialty_Ops__c)){
                    if(parentChildMap.get(SpecLegacyDrug.Specialty_Ops__c).contains(SpecLegacyDrug.year__c + SpecLegacyDrug.LOB__c + SpecLegacyDrug.Pharmacy_Benefit__c + SpecLegacyDrug.Price_List_Type__c )){  //verify that set associated with unique Specialty Ops contains the year, Lob, Pharmacy Benefit, Price List Type combination
                        SpecLegacyDrug.addError(ConstantsUtil.SPECLEGVALIDATEERROR);  //Display error
                    }
                }     
            }
        }
    }
    
    public static void validateSpciality(List<Specialty_Legacy_Drug_Level_pricing__c> specPriceList, Boolean isDelete, Boolean isUpdate){
        system.debug('validateSpciality() method START ::');
        Set<Id> fafIdSet = new Set<Id>();
        Map<Id,id> fafIdMap = new Map<Id,Id>();
        Set<Id> sOpsSet = new Set<Id>();
        Map<id,Integer> sOpsCount = new Map<id,Integer>();
        Map<id,Integer> sOpsActualCount = new Map<id,Integer>();
        Map<id,Integer> sOpsPricingCount = new Map<id,Integer>();
        try{
        for(Specialty_Legacy_Drug_Level_pricing__c spPricingRec:specPriceList){
            if(spPricingRec.Specialty_Ops__c!= null){
                sOpsSet.add(spPricingRec.Specialty_Ops__c);
                if(sOpsCount.containskey(spPricingRec.Specialty_Ops__c)){
                    sOpsCount.put(spPricingRec.Specialty_Ops__c,sOpsCount.get(spPricingRec.Specialty_Ops__c)+ 1);  
                }else{
                      sOpsCount.put(spPricingRec.Specialty_Ops__c,1);  
                      } 
            }
        }
        
        List<Specialty_Operations__c> sOpsList = [Select id,FAF_ID__c,(SELECT Id FROM Specialty_Legacy_drug_Level_pricings__r),(SELECT Id FROM Specialty_Pricing__r) from Specialty_Operations__c where Id in:sOpsSet];
        if(sOpsList.size()>0){       
            for(Specialty_Operations__c spPricingRec:sOpsList){
                   fafIdSet.add(spPricingRec.FAF_ID__c);    
                   fafIdMap.put(spPricingRec.Id,spPricingRec.FAF_ID__c);
                   sOpsActualCount.put(spPricingRec.id,spPricingRec.Specialty_Legacy_drug_Level_pricings__r.size()) ;
                   sOpsPricingCount.put(spPricingRec.id,spPricingRec.Specialty_Pricing__r.size()) ;       
            }
        }
        
        Map<Id, Central_Hub__c> platformSpecificMap =new Map<Id, Central_Hub__c>([SELECT Id,Name,(SELECT Id, Name, Specialty_Pharmacy_Benefit_Price_List__c FROM Platform_Specifics__r where Specialty_Pharmacy_Benefit_Price_List__c!= null) FROM Central_Hub__c WHERE Id in:fafIdSet]);
        
        
        
        for(Specialty_Legacy_Drug_Level_pricing__c spPricingRec:specPriceList){
            if(spPricingRec.Specialty_Ops__c!= null){
                if(sOpsPricingCount.get(spPricingRec.Specialty_Ops__c)==0){               
                      if(platformSpecificMap.containsKey(fafIdMap.get(spPricingRec.Specialty_Ops__c))&& platformSpecificMap.get(fafIdMap.get(spPricingRec.Specialty_Ops__c)).Platform_Specifics__r.size()>0){
                        if(sOpsCount.get(spPricingRec.Specialty_Ops__c) == sOpsActualCount.get(spPricingRec.Specialty_Ops__c)) {                 
                         //spPricingRec.addError('Platform Specific record(s) exist with \'Specialty Pharmacy Benefit & Price List\'value(s) which is/are being updated/removed on Specialty Legacy Drug Level Pricing. Please modify the platform specifics records which are utilizing the specific Specialty \'Pharmacy Benefit\' and \'Price List value\' combination.');
                         spPricingRec.addError(Label.Specialty_Error_message);                                                                                         
                          }
                }
             }   
          }  
        }
        }catch(Exception ex){
            system.debug('Line Number'+ex.getLineNumber()+'::Error Message::'+ex.getMessage());
            specPriceList[0].addError(ex.getMessage());
        }
        
    }
}