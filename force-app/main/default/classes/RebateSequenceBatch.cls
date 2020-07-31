global class RebateSequenceBatch implements  Database.Batchable<sObject>, Database.Stateful{
    
    global Set<String> opIdset;

    global RebateSequenceBatch(Set<String> opIds) {
        opIdset = new Set<String>();
        opIdset = opIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('opIdset----'+opIdset); //
        Set<String> fafIdset = new Set<String>();
        for(Rebate_Operations__c op :[Select Id, FAF_ID__c From Rebate_Operations__c Where Id IN : opIdset]){
            fafIdset.add(op.FAF_ID__c);
        }
        system.debug('fafIdset----'+fafIdset); 
        string query = 'SELECT id, '+ 
            ' (Select Id, Key__c , Sequence_Number__c, FAFID__c From Rebate_Sequence_Setting__r ) , '+ 
            ' (Select Id,Composite_Key__c,  Sequence_Number__c, FAF_ID__c From Rebate_Guarantees__r ) '+ 
            ' from Central_Hub__c where ID IN :fafIdset '; 
        system.debug('query----'+query);
        return Database.getQueryLocator(query );
    }
    
    global void execute(Database.BatchableContext bc, List<Central_Hub__c> scope){
        Map<String, Map<String, List<Rebate_Guarantees__c>>> keyToRGMap = new Map<String, Map<String, List<Rebate_Guarantees__c>>>();
        Map<String, Map<String, Integer>> keyToSeqMap = new Map<String, Map<String, Integer>>();
        Map<String, Map<String, List<Rebate_Guarantees__c>>> keyToNullSeqMap = new Map<String, Map<String, List<Rebate_Guarantees__c>>>();
        Map<String, Rebate_Guarantees__c> updateMap = new Map<String, Rebate_Guarantees__c>();
        Map<String, list<Integer>> sortListMap = new Map<String, list<Integer>>();
        List<Rebate_Sequence_Setting__c> ssUpdateList = new List<Rebate_Sequence_Setting__c>();
        
        for(Central_Hub__c op :scope){
            Map<String, List<Rebate_Guarantees__c>> keyToRGMapTemp = new Map<String, List<Rebate_Guarantees__c>>();
            list<Integer> sortListTemp = new list<Integer>();
            Map<String, Integer> keyToSeqMapTemp = new Map<String, Integer>();
            
            for(Rebate_Sequence_Setting__c ss : op.Rebate_Sequence_Setting__r){
                keyToSeqMapTemp.put(ss.Key__c, Integer.valueOf(ss.Sequence_Number__c));
                sortListTemp.add(Integer.valueOf(ss.Sequence_Number__c));
            }
            sortListTemp.sort();
            
            system.debug('op.Rebate_Guarantees__r-------'+op.Rebate_Guarantees__r);
            for(Rebate_Guarantees__c rg : op.Rebate_Guarantees__r){
                if(keyToRGMapTemp.containsKey(rg.Composite_Key__c)){
                    keyToRGMapTemp.get(rg.Composite_Key__c).add(rg);
                } else{
                    List<Rebate_Guarantees__c> temp = new List<Rebate_Guarantees__c>();
                    temp.add(rg);
                    keyToRGMapTemp.put(rg.Composite_Key__c, temp);
                }
            }
            system.debug('keyToRGMapTemp-------'+keyToRGMapTemp);
            
            keyToRGMap.put(op.Id, keyToRGMapTemp);
            keyToSeqMap.put(op.Id, keyToSeqMapTemp);
            sortListMap.put(op.Id, sortListTemp);
            
        }
        system.debug('keyToRGMap-------'+keyToRGMap);
        system.debug('keyToSeqMap-------'+keyToSeqMap);
        system.debug('sortListMap-------'+sortListMap);
        
        for(String opid : keyToRGMap.keySet()){
            Map<String, List<Rebate_Guarantees__c>> keyToRGMapTemp = new Map<String, List<Rebate_Guarantees__c>>();
            keyToRGMapTemp = keyToRGMap.get(opid);
            
            Map<String, Integer> keyToSeqMapTemp = new Map<String, Integer>();
            keyToSeqMapTemp = keyToSeqMap.get(opid);
            
            Map<String, List<Rebate_Guarantees__c>> keyToNullSeqMapTemp = new Map<String, List<Rebate_Guarantees__c>>();
            
            for(String key : keyToRGMapTemp.keySet()){
                for(Rebate_Guarantees__c rg : keyToRGMapTemp.get(key)){
                    if(keyToSeqMapTemp.containsKey(key)){
                        rg.Sequence_Number__c = keyToSeqMapTemp.get(key);
                        updateMap.put(rg.Id, rg);
                    } else {
                        if(keyToNullSeqMapTemp.containsKey(key)){
                            keyToNullSeqMapTemp.get(key).add(rg);
                        } else{
                            List<Rebate_Guarantees__c> temp = new List<Rebate_Guarantees__c>();
                            temp.add(rg);
                            keyToNullSeqMapTemp.put(key, temp);
                        }
                    }
                }
                
                keyToNullSeqMap.put(opid, keyToNullSeqMapTemp);
            }
        }
        
        system.debug('keyToNullSeqMap-------'+keyToNullSeqMap);
        system.debug('sortListMap-------'+sortListMap);
        
        for(String opid : sortListMap.keySet()){
            list<Integer> sortList = new list<Integer>();
            sortList = sortListMap.get(opid);
            
            Map<String, List<Rebate_Guarantees__c>> keyToNullSeqMapTemp = new Map<String, List<Rebate_Guarantees__c>>();
            if(keyToNullSeqMap.containsKey(opid)){
                keyToNullSeqMapTemp = keyToNullSeqMap.get(opid);
            }
            
            Map<String, Integer> keyToSeqMapTemp = new Map<String, Integer>();
            keyToSeqMapTemp = keyToSeqMap.get(opid);
            
            Integer hightestSeqNumber = 0;
            
            if(!sortList.isEmpty()){
                Integer len = sortList.size();
                hightestSeqNumber = sortList[len-1];
            } 
            
            for(String key :keyToNullSeqMapTemp.keySet()){
                hightestSeqNumber = hightestSeqNumber + 1;
                for(Rebate_Guarantees__c rg : keyToNullSeqMapTemp.get(key)){
                    rg.Sequence_Number__c = hightestSeqNumber;
                    updateMap.put(rg.Id, rg);
                }      
                if(!keyToSeqMapTemp.containsKey(key)){
                    Rebate_Sequence_Setting__c ss = new Rebate_Sequence_Setting__c();
                    
                    ss.FAFID__c = opid;
                    ss.Key__c = key;
                    ss.Sequence_Number__c = hightestSeqNumber;
                    ssUpdateList.add(ss);
                }
            }
        }
        if(!updateMap.values().isEmpty()){
            update updateMap.values();
        }
        
        system.debug('ssUpdateList-------'+ssUpdateList);
        if(!ssUpdateList.isEmpty()){
            insert ssUpdateList;
        }
    }    
    global void finish(Database.BatchableContext bc){
        
    }    
}