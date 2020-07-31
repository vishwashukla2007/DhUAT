public class pbmRequestHandler implements TriggerInterface {
	public static void beforeUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){        
    }
    public static void afterInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){        
    }
    public static void beforeInsert(List<sObject> newRecordsList, Map<id,sObject> newRecordsMap){        
    }
    public static void afterUpdate (Map<id,sObject> newRecordsMap, Map<id,sObject> oldRecordsMap){
        map<id,PBMRequest__c> inputObjOldMap = (map<id,PBMRequest__c>) oldRecordsMap; 
        map<id,PBMRequest__c> inputObjNewMap = (map<id,PBMRequest__c>) newRecordsMap;
        map<id,PBMRequest__c> inputObjNewMap2 = new map<id,PBMRequest__c>();
        for(PBMRequest__c eachPBMReq : inputObjNewMap.values()){
            if(eachPBMReq.Agreement__c != null){
                inputObjNewMap2.put(eachPBMReq.id, eachPBMReq);
            }
        }
        if(inputObjNewMap2.size() > 0 ){
        	pbmRequestHelper.compareAgreementExtVspbmReq(inputObjNewMap2,inputObjOldMap);  
        }
        
    }
}