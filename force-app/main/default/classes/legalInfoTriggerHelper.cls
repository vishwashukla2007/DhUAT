public with sharing class legalInfoTriggerHelper {

       public static void checkCountOnBeforeInsert(List<Legal_Information__c> legalInfoList) {
        
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafLInfoMap =new Map<id,integer>();
        
        for(Legal_Information__c lInfo: legalInfoList)
        {   
            fafIds.add(lInfo.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Legal_Information__c WHERE FAF_ID__c in: fafIds and FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafLInfoMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Legal_Information__c lInfo: legalInfoList)
        { 
            if(fafLInfoMap.get(lInfo.FAF_ID__c) >0){
             lInfo.adderror('Cannot add more than One Legal Info to FAF');
            }        
        }
        
   }
}