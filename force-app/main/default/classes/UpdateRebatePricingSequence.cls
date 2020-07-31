public class UpdateRebatePricingSequence {
    @InvocableMethod
    public static void updateSequence(List<String> opid){
        Map<String, List<Rebate_Guarantees__c>> keyToNotNullRebateMap =  new Map<String, List<Rebate_Guarantees__c>>();
        Map<String, List<Rebate_Guarantees__c>> keyToNullRebateMap =  new Map<String, List<Rebate_Guarantees__c>>();
        Map<String, List<Rebate_Guarantees__c>> keyToNullRebateTempMap =  new Map<String, List<Rebate_Guarantees__c>>();
        
        list<Rebate_Guarantees__c> allRGList = new list<Rebate_Guarantees__c>();
        list<Rebate_Guarantees__c> rgNullSequenceUpdateList = new list<Rebate_Guarantees__c>();
        list<Integer> sortList = new list<Integer>();
        
        Integer hightestSeqNumber = 0;
        
        allRGList = [
            Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
            from Rebate_Guarantees__c 
            Where Rebate_Operations__c = : opid[0] Order By Composite_Key__c
        ];
        
        for(Rebate_Guarantees__c rg : allRGList){
            if(rg.Sequence_Number__c != null){
                if(keyToNotNullRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToNotNullRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Rebate_Guarantees__c> temp = new list<Rebate_Guarantees__c>();
                    temp.add(rg);
                    keyToNotNullRebateMap.put(rg.Composite_Key__c, temp);
                }
                sortList.add(Integer.valueOf(rg.Sequence_Number__c));
            } else {
                if(keyToNullRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToNullRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Rebate_Guarantees__c> temp = new list<Rebate_Guarantees__c>();
                    temp.add(rg);
                    keyToNullRebateMap.put(rg.Composite_Key__c, temp);
                }
            }
        }
        system.debug('keyToNullRebateMap------------------->'+keyToNullRebateMap.keySet());
        system.debug('keyToNotNullRebateMap------------------->'+keyToNotNullRebateMap.keySet());
        sortList.sort();
        if(!sortList.isEmpty()){
            Integer len = sortList.size();
            hightestSeqNumber = sortList[len-1];
        } 
        
        for(String key :keyToNullRebateMap.keySet()){
            if(keyToNotNullRebateMap.containsKey(key)){
                Integer seq = Integer.valueOf(keyToNotNullRebateMap.get(key)[0].Sequence_Number__c);
                for(Rebate_Guarantees__c rg : keyToNullRebateMap.get(key)){
                    rg.Sequence_Number__c = seq;
                    rgNullSequenceUpdateList.add(rg);
                }
            } else {
                keyToNullRebateTempMap.put(key, keyToNullRebateMap.get(key));
            }
        }
        
        for(String key :keyToNullRebateTempMap.keySet()){
            hightestSeqNumber = hightestSeqNumber + 1;
            for(Rebate_Guarantees__c rg : keyToNullRebateTempMap.get(key)){
                rg.Sequence_Number__c = hightestSeqNumber;
                rgNullSequenceUpdateList.add(rg);
            }            
        }
        system.debug('rgNullSequenceUpdateList------------------->'+rgNullSequenceUpdateList.size());
        update rgNullSequenceUpdateList;
        updateRGDSequence(opid);
    }
    
    public static void updateRGDSequence(List<String> opid){
        Map<String, List<Rebate_Guarantees__c>> keyToNotNullRebateMap =  new Map<String, List<Rebate_Guarantees__c>>();
        Map<String, List<Rebate_Guarantee_Denorm__c>> keyToNullRebateDenormMap =  new Map<String, List<Rebate_Guarantee_Denorm__c>>();
        
        list<Rebate_Guarantees__c> allRGList = new list<Rebate_Guarantees__c>();
        list<Rebate_Guarantee_Denorm__c> allRGDList = new list<Rebate_Guarantee_Denorm__c>();
        list<Rebate_Guarantee_Denorm__c> rgdNullSequenceUpdateList = new list<Rebate_Guarantee_Denorm__c>();
        
        allRGList = [
            Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
            from Rebate_Guarantees__c 
            Where Rebate_Operations__c = : opid[0] Order By Composite_Key__c
        ];
        
        for(Rebate_Guarantees__c rg : allRGList){
            if(rg.Sequence_Number__c != null){
                if(keyToNotNullRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToNotNullRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Rebate_Guarantees__c> temp = new list<Rebate_Guarantees__c>();
                    temp.add(rg);
                    keyToNotNullRebateMap.put(rg.Composite_Key__c, temp);
                }
            } 
        }
        allRGDList = [
            Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
            from Rebate_Guarantee_Denorm__c 
            Where Rebate_Operations__c = : opid[0]  and Sequence_Number__c = null //and Grid_flag__c = true
        ];
        
        system.debug('allRGDList------------------->'+allRGDList.size());
        for(Rebate_Guarantee_Denorm__c rgd : allRGDList){
            if(keyToNotNullRebateMap.containsKey(rgd.Composite_Key__c)){
                Integer seq = Integer.valueOf(keyToNotNullRebateMap.get(rgd.Composite_Key__c)[0].Sequence_Number__c);
                rgd.Sequence_Number__c = seq;
                rgdNullSequenceUpdateList.add(rgd);
            } 
        }
        system.debug('rgdNullSequenceUpdateList------------------->'+rgdNullSequenceUpdateList.size());
        update rgdNullSequenceUpdateList;
     }
}