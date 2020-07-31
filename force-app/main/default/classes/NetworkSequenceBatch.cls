global class NetworkSequenceBatch implements  Database.Batchable<sObject>, Database.Stateful{
    
    global Set<String> opIdset;

    global NetworkSequenceBatch(Set<String> opIds) {
        opIdset = new Set<String>();
        opIdset = opIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('opIdset----'+opIdset); //
        Set<String> fafIdset = new Set<String>();
        for(Network_Operations__c op :[Select Id, FAF_ID__c From Network_Operations__c Where Id IN : opIdset]){
            fafIdset.add(op.FAF_ID__c);
        }
        system.debug('fafIdset----'+fafIdset); 
        
        String cLabel = System.Label.Network_Pricing_Exclude_Values;
        List<String> val = new List<String>();
        
        for(String str : cLabel.split(',')){
            val.add(str.trim());
        }
        
        string query = 'SELECT id, '+ 
            ' (Select Id, Key__c , Sequence_Number__c, FAFID__c From Network_Sequence_Setting__r ) , '+ 
            ' (Select Id,Composite_Key__c,  Sequence_Number__c, FAF_ID__c From Network_Pricing__r where Network_Name__c != \'MC(84-90)CVS\' and Network_Name__c != null and Network_Name__c NOT IN : val ) '+ 
            ' from Central_Hub__c where ID IN :fafIdset '; 
        system.debug('query----'+query);
        return Database.getQueryLocator(query );
    }
    
    global void execute(Database.BatchableContext bc, List<Central_Hub__c> scope){
        Map<String, Map<String, List<Network_Pricing__c>>> keyToNPMap = new Map<String, Map<String, List<Network_Pricing__c>>>();
        Map<String, Map<String, Integer>> keyToSeqMap = new Map<String, Map<String, Integer>>();
        Map<String, Map<String, List<Network_Pricing__c>>> keyToNullSeqMap = new Map<String, Map<String, List<Network_Pricing__c>>>();
        Map<String, Network_Pricing__c> updateMap = new Map<String, Network_Pricing__c>();
        Map<String, list<Integer>> sortListMap = new Map<String, list<Integer>>();
        List<Network_Sequence_Setting__c> ssUpdateList = new List<Network_Sequence_Setting__c>();
        
        for(Central_Hub__c op :scope){
            Map<String, List<Network_Pricing__c>> keyToNPMapTemp = new Map<String, List<Network_Pricing__c>>();
            list<Integer> sortListTemp = new list<Integer>();
            Map<String, Integer> keyToSeqMapTemp = new Map<String, Integer>();
            
            for(Network_Sequence_Setting__c ss : op.Network_Sequence_Setting__r){
                keyToSeqMapTemp.put(ss.Key__c, Integer.valueOf(ss.Sequence_Number__c));
                sortListTemp.add(Integer.valueOf(ss.Sequence_Number__c));
            }
            sortListTemp.sort();
            
            system.debug('op.Network_Pricing__r-------'+op.Network_Pricing__r);
            for(Network_Pricing__c np : op.Network_Pricing__r){
                if(keyToNPMapTemp.containsKey(np.Composite_Key__c)){
                    keyToNPMapTemp.get(np.Composite_Key__c).add(np);
                } else{
                    List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                    temp.add(np);
                    keyToNPMapTemp.put(np.Composite_Key__c, temp);
                }
            }
            system.debug('keyToNPMapTemp-------'+keyToNPMapTemp);
            
            keyToNPMap.put(op.Id, keyToNPMapTemp);
            keyToSeqMap.put(op.Id, keyToSeqMapTemp);
            sortListMap.put(op.Id, sortListTemp);
            
        }
        system.debug('keyToNPMap-------'+keyToNPMap);
        system.debug('keyToSeqMap-------'+keyToSeqMap);
        system.debug('sortListMap-------'+sortListMap);
        
        for(String opid : keyToNPMap.keySet()){
            Map<String, List<Network_Pricing__c>> keyToNPMapTemp = new Map<String, List<Network_Pricing__c>>();
            keyToNPMapTemp = keyToNPMap.get(opid);
            
            Map<String, Integer> keyToSeqMapTemp = new Map<String, Integer>();
            keyToSeqMapTemp = keyToSeqMap.get(opid);
            
            Map<String, List<Network_Pricing__c>> keyToNullSeqMapTemp = new Map<String, List<Network_Pricing__c>>();
            
            for(String key : keyToNPMapTemp.keySet()){
                for(Network_Pricing__c np : keyToNPMapTemp.get(key)){
                    if(keyToSeqMapTemp.containsKey(key)){
                        np.Sequence_Number__c = keyToSeqMapTemp.get(key);
                        updateMap.put(np.Id, np);
                    } else {
                        if(keyToNullSeqMapTemp.containsKey(key)){
                            keyToNullSeqMapTemp.get(key).add(np);
                        } else{
                            List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                            temp.add(np);
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
            
            Map<String, List<Network_Pricing__c>> keyToNullSeqMapTemp = new Map<String, List<Network_Pricing__c>>();
            if(keyToNullSeqMap.containsKey(opid)){
                keyToNullSeqMapTemp = keyToNullSeqMap.get(opid);
            }
            
            Map<String, Integer> keyToSeqMapTemp = new Map<String, Integer>();
            keyToSeqMapTemp = keyToSeqMap.get(opid);
            system.debug('keyToSeqMapTemp--------------'+keyToSeqMapTemp);
            Integer hightestSeqNumber = 0;
            
            system.debug('sortList--------------'+sortList);
            
            if(!sortList.isEmpty()){
                Integer len = sortList.size();
                hightestSeqNumber = sortList[len-1];
            } 
            system.debug('hightestSeqNumber--------------'+hightestSeqNumber);
            for(String key :keyToNullSeqMapTemp.keySet()){
                hightestSeqNumber = hightestSeqNumber + 1;
                for(Network_Pricing__c np : keyToNullSeqMapTemp.get(key)){
                    np.Sequence_Number__c = hightestSeqNumber;
                    updateMap.put(np.Id, np);
                }      
                system.debug('key--------------'+key);
                if(!keyToSeqMapTemp.containsKey(key)){
                    Network_Sequence_Setting__c ss = new Network_Sequence_Setting__c();
                    
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