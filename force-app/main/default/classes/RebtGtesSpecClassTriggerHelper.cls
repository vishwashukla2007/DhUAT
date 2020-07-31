public with sharing class RebtGtesSpecClassTriggerHelper{
    public static void validateLobYearDrugTheraphyCombinalion(List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> gterssCarveOutList, Boolean isInsertBool, Boolean isUpdateBool) {
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>();
        Map<string, MAP<string, Id>> rebateOpsGtessRelatMap = new Map<string, MAP<string, Id>>();
        MAP<string, Id> tempMap;
        set<Id> rebateOpsIdSet = new set<Id>();
        set<string> concatinateStr = new set<string>();
        Set<Id>rebateOprIdSet = new Set<Id>();
        String str;
        String str1;
        List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> rebGtessRecList = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
        for(Rebate_Gtees_Specialty_Class_Carve_Outs__c rebGtess: gterssCarveOutList){
            rebateOprIdSet.add(rebGtess.Rebate_operations__c);
        }
        rebGtessRecList = [select id, Rebate_operations__c, year__c, LOB2__c, Drug_Therapy_Class_2__c from Rebate_Gtees_Specialty_Class_Carve_Outs__c
        where Rebate_operations__c in: rebateOprIdSet];
        for(Rebate_Gtees_Specialty_Class_Carve_Outs__c rebGtess: rebGtessRecList){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(rebateOpsIdSet.size()>0){
                if(rebateOpsIdSet.contains(rebGtess.Rebate_operations__c)){
                    concatinateStr.addall(parentChildMap.get(rebGtess.Rebate_operations__c));
                    concatinateStr.add(rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c);
                    parentChildMap.put(rebGtess.Rebate_operations__c, concatinateStr);
                    tempMap.put(rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c, rebGtess.Id);
                    str = string.valueOf(rebGtess.Rebate_operations__c)+string.valueOf(rebGtess.Id);
                    rebateOpsGtessRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(rebGtess.year__c + rebGtess.LOB2__c+ rebGtess.Drug_Therapy_Class_2__c);
                    rebateOpsIdSet.add(rebGtess.Rebate_operations__c);
                    parentChildMap.put(rebGtess.Rebate_operations__c, concatinateStr);
                    tempMap.put(rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c, rebGtess.Id);
                    str = string.valueOf(rebGtess.Rebate_operations__c)+string.valueOf(rebGtess.Id);
                    rebateOpsGtessRelatMap.put(str,tempMap);
                }
            }else{
                concatinateStr.add(rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c);
                rebateOpsIdSet.add(rebGtess.Rebate_operations__c);
                parentChildMap.put(rebGtess.Rebate_operations__c, concatinateStr);
                tempMap.put(rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c, rebGtess.Id);
                str = string.valueOf(rebGtess.Rebate_operations__c)+string.valueOf(rebGtess.Id);
                rebateOpsGtessRelatMap.put(str,tempMap);
            }
        }
        system.debug('========parentChildMap========'+parentChildMap);
        system.debug('========rebateOpsGtessRelatMap========'+rebateOpsGtessRelatMap);
        system.debug('========parentChildMap========'+parentChildMap);
        if(isUpdateBool){
            for(Rebate_Gtees_Specialty_Class_Carve_Outs__c rebGtess: gterssCarveOutList){
                if(rebateOpsIdSet.contains(rebGtess.Rebate_operations__c)){
                    system.debug('========rebGtess.Rebate_operations__c========'+rebGtess.Rebate_operations__c);
                    system.debug('========rebGtess.id========'+rebGtess.id);
                    if(parentChildMap.get(rebGtess.Rebate_operations__c).contains(rebGtess.year__c + rebGtess.LOB2__c+ rebGtess.Drug_Therapy_Class_2__c)){
                        str1 = rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c;
                        str = string.valueOf(rebGtess.Rebate_operations__c)+string.valueOf(rebGtess.Id);
                        system.debug('========str========'+str);
                        system.debug('========str1========'+str1);
                        system.debug('========rebateOpsGtessRelatMap.get(str).get(str1)========'+rebateOpsGtessRelatMap.get(str).get(str1));
                        if(rebateOpsGtessRelatMap.get(str).get(str1) != rebGtess.id){
                            rebGtess.addError(ConstantsUtil.REBATE_GTEE_TRIG_HELP_ERROR);
                        }
                    }
                }     
            }
        }
        if(isInsertBool){
            for(Rebate_Gtees_Specialty_Class_Carve_Outs__c rebGtess: gterssCarveOutList){
                if(rebateOpsIdSet.contains(rebGtess.Rebate_operations__c)){
                    if(parentChildMap.get(rebGtess.Rebate_operations__c).contains(rebGtess.year__c + rebGtess.LOB2__c + rebGtess.Drug_Therapy_Class_2__c)){
                        rebGtess.addError(ConstantsUtil.REBATE_GTEE_TRIG_HELP_ERROR);
                    }
                }     
            }
        }
    }
}