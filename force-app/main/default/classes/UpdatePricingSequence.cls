public class UpdatePricingSequence {
    @InvocableMethod
    public static void updateSequence(List<String> opid){
        
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        list<Network_Pricing__c> npAllList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNotNullAllList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npUpdateList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npSPUpdateList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npAllNullSequenceList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSequenceList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSPSequenceList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSequenceTempList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSequenceUpdateList = new list<Network_Pricing__c>();
        list<Sequence_Setting__c> ssList = new list<Sequence_Setting__c>();
        list<Sequence_Setting__c> ssInsertList = new list<Sequence_Setting__c>();
        list<Sequence_Setting__c> ssMissInsertList = new list<Sequence_Setting__c>();
        
        Map<String, Sequence_Setting__c> networkKeyToSSMap =  new Map<String, Sequence_Setting__c>();
        Map<String, Sequence_Setting__c> networkKeyToSSInsertMap =  new Map<String, Sequence_Setting__c>();
        Map<String, list<Network_Pricing__c>> networkKeyToNpListMap =  new Map<String, list<Network_Pricing__c>>();
        Map<String, Integer> networkKeyToSeqMap =  new Map<String, Integer>();
        List<Network_Pricing__c> latestNp = new List<Network_Pricing__c>();
        
        String cLabel = System.Label.Network_Pricing_Exclude_Values;
        List<String> val = new List<String>();
        
        for(String str : cLabel.split(',')){
            val.add(str.trim());
        }
        
        Integer hightestSeqNumber = 0;
        for( Network_Pricing__c np : [
            SELECT id, Name, Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c,  Network_Type__c , 
            (Select Id, FAFID__c, Network_Name_for_Grid__c ,  Network_Type__c, ObjectID__c, Object_Name__c, Retail_Network_Ordinal__c, Sequence_Number__c
             From Sequence_Settings__r order by Sequence_Number__c desc limit 1)
            from Network_Pricing__c where FAF_Network_Ops__c = :opid[0] and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null 
            and Sequence_Number__c != Null and Network_Name__c NOT IN : val
        ]){
            if(np.Sequence_Settings__r.isEmpty()){
                Sequence_Setting__c ss = new Sequence_Setting__c();
                ss.FAFID__c = np.FAF_ID__c;
                ss.ObjectID__c = np.FAF_Network_Ops__c;
                ss.Object_Name__c = 'Network Operation';
                ss.Network_Pricing__c = np.Id;
                ssMissInsertList.add(ss);
            }
        }
        insert ssMissInsertList; 
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        latestNp = [
            SELECT id, Name, Sequence_Number__c
            from Network_Pricing__c where FAF_Network_Ops__c = :opid[0] and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null 
            and Sequence_Number__c != Null //and Network_Name__c != 'Specialty'
            order by Sequence_Number__c desc limit 1
        ];

        if(!latestNp.isEmpty()){
            hightestSeqNumber = Integer.valueOf(latestNp[0].Sequence_Number__c);
        } 
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        for(Sequence_Setting__c ss : [
            Select Id, FAFID__c, Network_Name_for_Grid__c ,  Network_Type__c, ObjectID__c, Object_Name__c, Retail_Network_Ordinal__c, Sequence_Number__c
            From Sequence_Setting__c
            Where ObjectID__c In :opid
        ]){
            String key = ss.Retail_Network_Ordinal__c + '_' + ss.Network_Name_for_Grid__c + '_' + ss.Network_Type__c;
            key = key.toUpperCase();
            networkKeyToSSMap.put(key, ss);
            networkKeyToSeqMap.put(key, Integer.valueOf(ss.Sequence_Number__c));
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        npNullSequenceList = [
            SELECT id, Name, Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c,  Network_Type__c , 
            (Select Id, FAFID__c, Network_Name_for_Grid__c ,  Network_Type__c, ObjectID__c, Object_Name__c, Retail_Network_Ordinal__c, Sequence_Number__c
             From Sequence_Settings__r order by Sequence_Number__c desc limit 1)
            from Network_Pricing__c where FAF_Network_Ops__c = :opid[0] and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null 
            and Sequence_Number__c = Null and Network_Name__c != 'Specialty' and Network_Name__c NOT IN : val
            order by Retail_Network_Ordinal__c,Network_Name_for_Grid__c,Network_Type__c asc
        ];
                
        for(Network_Pricing__c np  : npNullSequenceList){
            String key = np.Retail_Network_Ordinal__c + '_' + np.Network_Name_for_Grid__c + '_' + np.Network_Type__c;
            key = key.toUpperCase();
            if(networkKeyToSeqMap.containsKey(key)){
                np.Sequence_Number__c = networkKeyToSeqMap.get(key);
                if(np.Sequence_Settings__r.isEmpty()){
                    Sequence_Setting__c ss = new Sequence_Setting__c();
                    ss.FAFID__c = np.FAF_ID__c;
                    ss.ObjectID__c = np.FAF_Network_Ops__c;
                    ss.Object_Name__c = 'Network Operation';
                    ss.Network_Pricing__c = np.Id;
                    ssInsertList.add(ss);
                }
                npNullSequenceUpdateList.add(np);
            } else {
                npNullSequenceTempList.add(np);
            }
        }
        Integer counter = 0;
        while(counter < npNullSequenceTempList.size()){
            if(npNullSequenceTempList.size() > counter && npNullSequenceTempList[counter] != null){
                Network_Pricing__c np = npNullSequenceTempList[counter];
                String key = np.Retail_Network_Ordinal__c + '_' + np.Network_Name_for_Grid__c + '_' + np.Network_Type__c;
                key = key.toUpperCase();
                if(networkKeyToSeqMap.containsKey(key) && networkKeyToSeqMap.get(key) != 0){
                    np.Sequence_Number__c = networkKeyToSeqMap.get(key);
                } else {
                    np.Sequence_Number__c = hightestSeqNumber + 1;
                    hightestSeqNumber = Integer.valueOf(np.Sequence_Number__c);   
                    if(np.Sequence_Number__c == 0 ){
                        np.Sequence_Number__c = null;                            
                    } else {
                    	networkKeyToSeqMap.put(key, Integer.valueOf(np.Sequence_Number__c));
                    }
                }        
                npNullSequenceUpdateList.add(np);
                if(np.Sequence_Settings__r.isEmpty()){
                    Sequence_Setting__c ss = new Sequence_Setting__c();
                    ss.FAFID__c = np.FAF_ID__c;
                    ss.ObjectID__c = np.FAF_Network_Ops__c;
                    ss.Object_Name__c = 'Network Operation';
                    ss.Network_Pricing__c = np.Id;
                    ssInsertList.add(ss);
                }
                
                counter++;
            }
        }
        update npNullSequenceUpdateList;
        
        insert ssInsertList;
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        updateSpSequence(opid);
        
        
    }
    
    public static void updateSpSequence(List<String> opid){
         DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        list<Network_Pricing__c> npAllList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNotNullAllList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npUpdateList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npSPUpdateList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npAllNullSequenceList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSequenceList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSPSequenceList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSequenceTempList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullSequenceUpdateList = new list<Network_Pricing__c>();
        list<Sequence_Setting__c> ssList = new list<Sequence_Setting__c>();
        list<Sequence_Setting__c> ssInsertList = new list<Sequence_Setting__c>();
        list<Sequence_Setting__c> ssMissInsertList = new list<Sequence_Setting__c>();
        
        Map<String, Sequence_Setting__c> networkKeyToSSMap =  new Map<String, Sequence_Setting__c>();
        Map<String, Sequence_Setting__c> networkKeyToSSInsertMap =  new Map<String, Sequence_Setting__c>();
        Map<String, list<Network_Pricing__c>> networkKeyToNpListMap =  new Map<String, list<Network_Pricing__c>>();
        Map<String, Integer> networkKeyToSeqMap =  new Map<String, Integer>();
        List<Network_Pricing__c> latestNp = new List<Network_Pricing__c>();
        
        Integer hightestSeqNumber = 0;
        
        String cLabel = System.Label.Network_Pricing_Exclude_Values;
        List<String> val = new List<String>();
        
        for(String str : cLabel.split(',')){
            val.add(str.trim());
        }
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        latestNp = [
            SELECT id, Name, Sequence_Number__c
            from Network_Pricing__c where FAF_Network_Ops__c = :opid[0] and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null and Network_Name__c NOT IN : val
            and Sequence_Number__c != Null //and Network_Name__c != 'Specialty'
            order by Sequence_Number__c desc limit 1
        ];

        if(!latestNp.isEmpty()){
            hightestSeqNumber = Integer.valueOf(latestNp[0].Sequence_Number__c);
        } 
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        for(Sequence_Setting__c ss : [
            Select Id, FAFID__c, Network_Name_for_Grid__c ,  Network_Type__c, ObjectID__c, Object_Name__c, Retail_Network_Ordinal__c, Sequence_Number__c
            From Sequence_Setting__c
            Where ObjectID__c In :opid
        ]){
            String key = ss.Retail_Network_Ordinal__c + '_' + ss.Network_Name_for_Grid__c + '_' + ss.Network_Type__c;
            key = key.toUpperCase();
            networkKeyToSSMap.put(key, ss);
            networkKeyToSeqMap.put(key, Integer.valueOf(ss.Sequence_Number__c));
        }
       
        //////////////////////////////////////////////////////////////////////////////////////////////

        npNullSPSequenceList = [
            SELECT id, Name, Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c,  Network_Type__c , 
            (Select Id, FAFID__c, Network_Name_for_Grid__c ,  Network_Type__c, ObjectID__c, Object_Name__c, Retail_Network_Ordinal__c, Sequence_Number__c
             From Sequence_Settings__r order by Sequence_Number__c desc limit 1)
            from Network_Pricing__c where FAF_Network_Ops__c = :opid[0] and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c = 'Specialty' and Network_Name__c NOT IN : val
            order by Retail_Network_Ordinal__c,Network_Name_for_Grid__c,Network_Type__c asc
        ];
        
        for(Network_Pricing__c np  : npNullSPSequenceList){
            String key = np.Retail_Network_Ordinal__c + '_' + np.Network_Name_for_Grid__c + '_' + np.Network_Type__c;
            key = key.toUpperCase();
            if(networkKeyToSeqMap.containsKey(key)){
                np.Sequence_Number__c = networkKeyToSeqMap.get(key);
                if(np.Sequence_Settings__r.isEmpty()){
                    Sequence_Setting__c ss = new Sequence_Setting__c();
                    ss.FAFID__c = np.FAF_ID__c;
                    ss.ObjectID__c = np.FAF_Network_Ops__c;
                    ss.Object_Name__c = 'Network Operation';
                    ss.Network_Pricing__c = np.Id;
                    ssInsertList.add(ss);
                }
                npNullSequenceUpdateList.add(np);
            } else {
                npNullSequenceTempList.add(np);
            }
        }
        Integer counter = 0;
        while(counter < npNullSequenceTempList.size()){
            if(npNullSequenceTempList.size() > counter && npNullSequenceTempList[counter] != null){
                Network_Pricing__c np = npNullSequenceTempList[counter];
                String key = np.Retail_Network_Ordinal__c + '_' + np.Network_Name_for_Grid__c + '_' + np.Network_Type__c;
                key = key.toUpperCase();
                if(networkKeyToSeqMap.containsKey(key) && networkKeyToSeqMap.get(key) != 0){
                    np.Sequence_Number__c = networkKeyToSeqMap.get(key);
                } else {
                    np.Sequence_Number__c = hightestSeqNumber + 1;
                    hightestSeqNumber = Integer.valueOf(np.Sequence_Number__c);
                    if(np.Sequence_Number__c == 0 ){
                        np.Sequence_Number__c = null;                            
                    } else {
                        networkKeyToSeqMap.put(key, Integer.valueOf(np.Sequence_Number__c));
                    }
                    
                }        
                npNullSequenceUpdateList.add(np);
                if(np.Sequence_Settings__r.isEmpty()){
                    Sequence_Setting__c ss = new Sequence_Setting__c();
                    ss.FAFID__c = np.FAF_ID__c;
                    ss.ObjectID__c = np.FAF_Network_Ops__c;
                    ss.Object_Name__c = 'Network Operation';
                    ss.Network_Pricing__c = np.Id;
                    ssInsertList.add(ss);
                }
                
                counter++;
            }
        }
        update npNullSequenceUpdateList;
        
        insert ssInsertList;
        
    }
}