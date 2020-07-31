/*********************************************************************************************
* @Class Name      : RebateGuaranteeTriggerHelper
* @author   Sanket Saxena
* @Created date     12 07 2018
* @description:This is the helper class for TR_RebateGuarantee_validate         
 **********************************************************************************************/
public with sharing class RebateGuaranteeTriggerHelper{
 

/*********************************************************************************************
 Method used to check duplicacy on year,LOB and Basis in Rebate Guarantee record
**********************************************************************************************/
    public static void validateLobYearBasisCombination(List<Rebate_Guarantees__c> RebateGteeList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>();
            Map<string, MAP<string, Id>> RebateGteeRelatedMap = new Map<string, MAP<string, Id>>();
            Map<string, Id> tempMap;
            set<Id> RebateOpsIdSet = new set<Id>(); //Set contain the Rebate Operation id
            set<string> concatinateStr = new set<string>(); //set created to add year,LOB and Ba siscombination in set
            Set<Id>RebateOprIdSet = new Set<Id>(); //Used to add Rebate operation id for pass in the query
            String str;
            String str1;
            List<Rebate_Guarantees__c> RebateGteeRecList = new List<Rebate_Guarantees__c>();
        
            
            //Iterate over all Rebate GTEss which are present in the billBrokList list
            for(Rebate_Guarantees__c RebateGtee: RebateGteeList){
                rebateOprIdSet.add(RebateGtee.Rebate_operations__c);
            }
        
            //Query data from Rebate Operations Object
            //RebateGteeRecList = [select id, Rebate_Operations__c, Year__c, LOB2__c, Basis__c,GSTP__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c from Rebate_Guarantees__c
            //where Rebate_Operations__c in: RebateOprIdSet];
            
            for(Rebate_Guarantees__c RebateGtee: [select id, Rebate_Operations__c, Year__c, LOB2__c, Basis__c,GSTP__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c from Rebate_Guarantees__c
            where Rebate_Operations__c in: RebateOprIdSet]){
                tempMap = new Map<string,Id>();
                concatinateStr = new set<string>();
                if(RebateOpsIdSet.size()>0){
                if(RebateOpsIdSet.contains(RebateGtee.Rebate_operations__c)){
                    concatinateStr.addall(parentChildMap.get(RebateGtee.Rebate_operations__c));
                    concatinateStr.add(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c );
                        RebateOpsIdSet.add(RebateGtee.Rebate_Operations__c);
                        parentChildMap.put(RebateGtee.Rebate_Operations__c, concatinateStr);
                        tempMap.put(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c, RebateGtee.Id);
                        str = string.valueOf(RebateGtee.Rebate_Operations__c)+string.valueOf(RebateGtee.Id);
                        RebateGteeRelatedMap.put(str,tempMap);
                    }
                else{ //This condition will execute first time the loop will execute
                    concatinateStr.add(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c);
                    RebateOpsIdSet.add(RebateGtee.Rebate_Operations__c);
                    parentChildMap.put(RebateGtee.Rebate_Operations__c, concatinateStr);
                    tempMap.put(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c, RebateGtee.Id);
                    str = string.valueOf(RebateGtee.Rebate_Operations__c)+string.valueOf(RebateGtee.Id);
                    RebateGteeRelatedMap.put(str,tempMap);
                }
                } else{ //This condition will execute first time the loop will execute
                    concatinateStr.add(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c);
                    RebateOpsIdSet.add(RebateGtee.Rebate_Operations__c);
                    parentChildMap.put(RebateGtee.Rebate_Operations__c, concatinateStr);
                    tempMap.put(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c, RebateGtee.Id);
                    str = string.valueOf(RebateGtee.Rebate_Operations__c)+string.valueOf(RebateGtee.Id);
                    RebateGteeRelatedMap.put(str,tempMap);
                }
                
            }
            if(isUpdateBool){ //Value to check it is insert case or Update
                for(Rebate_Guarantees__c RebateGtee: RebateGteeList){
                    if(RebateOpsIdSet.contains(RebateGtee.Rebate_Operations__c)){
                        if(parentChildMap.get(RebateGtee.Rebate_Operations__c).contains(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c)){
                            str1 = RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c;
                            str = string.valueOf(RebateGtee.Rebate_Operations__c)+string.valueOf(RebateGtee.Id);
                            if(RebateGteeRelatedMap.get(str).get(str1) != RebateGtee.id){
                                system.debug('before error---1-----');
                                RebateGtee.addError(ConstantsUtil.YEAR_LOB_BASIS_ERROR);
                            }
                        }
                    }     
                }
            }
            
            if(isInsertBool){ //Value to check it is insert case or Update
                for(Rebate_Guarantees__c RebateGtee: RebateGteeList){
                    if(RebateOpsIdSet.contains(RebateGtee.Rebate_Operations__c)){
                        
                        if(parentChildMap.get(RebateGtee.Rebate_Operations__c).contains(RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c)){
                            system.debug('before error----2----');
                            RebateGtee.addError(ConstantsUtil.YEAR_LOB_BASIS_ERROR);
                        }
                    }     
                }
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
    }
    
}