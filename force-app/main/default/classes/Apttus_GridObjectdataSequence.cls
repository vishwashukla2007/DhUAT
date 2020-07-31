global class Apttus_GridObjectdataSequence {
    @AuraEnabled
    global static void updateNPSeq(String recId, String aliId, String currSeqNum, String newSeqNum, Boolean isUpDown) {
        
        Map<Integer, Network_Pricing__c> npSeqMap = new Map<Integer, Network_Pricing__c>();
        String cLabel = System.Label.Network_Pricing_Exclude_Values;
        List<String> val = new List<String>();
        
        for(String str : cLabel.split(',')){
            val.add(str.trim());
        }
        if(String.isNotBlank(newSeqNum )){
            Integer newSeq = Integer.valueOf(newSeqNum);
            Integer currSeq;
            if(aliId != null){
                for(Network_Pricing__c np :Apttus_GridObjectdata.get_GridObjectdata(aliId, '')){
                     if(np.Sequence_Number__c != null ){// && np.Network_Name__c != 'Specialty'
                        npSeqMap.put(Integer.valueOf(np.Sequence_Number__c) , np);
                    }
                }
            }
            system.debug('npSeqMap----------------'+npSeqMap.keySet());
            if(recId != null && newSeq != null){
                system.debug('newSeq----------------------------------------------------------------------------'+newSeq);
                Map<Id, Sequence_Setting__c> ssIdToSSMap =  new Map<Id, Sequence_Setting__c>();
                Map<Id, Sequence_Setting__c> ssUpdateMap =  new Map<Id, Sequence_Setting__c>();
                Map<Id, Network_Pricing__c> npUpdateMap =  new Map<Id, Network_Pricing__c>();
                Map<String, list<Network_Pricing__c>> networkKeyToNpListMap =  new Map<String, list<Network_Pricing__c>>();
                
                list<Network_Pricing__c> npAllList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npAllNullList = new list<Network_Pricing__c>();
                    
                Network_Pricing__c currentNP = [
                    SELECT id, Custom_Description__c,Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c,  Network_Type__c,
                    FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c
                    from Network_Pricing__c where Id = :recId 
                ];
                //npAllRecList
                npAllList = [
                    SELECT id,Custom_Description__c,Name, Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c,  
                    Network_Type__c, FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c, 
                    (Select Id, FAFID__c, Network_Name_for_Grid__c ,  Network_Type__c, ObjectID__c, Object_Name__c, Retail_Network_Ordinal__c, Sequence_Number__c
                     From Sequence_Settings__r order by Sequence_Number__c desc limit 1) 
                    from Network_Pricing__c where FAF_Network_Ops__c = :currentNP.FAF_Network_Ops__c and Id != :currentNP.Id and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null 
                    and Network_Name__c NOT IN : val
                    //and Network_Name__c != 'Specialty'
                ]; 
                String opid = currentNP.FAF_Network_Ops__c;
                for(Network_Pricing__c np  : npAllList){
                    if(np.Sequence_Number__c == null){
                        npAllNullList.add(np);
                    } 
                }
                
                for(Network_Pricing__c np : npAllList){
                    String key = np.Retail_Network_Ordinal__c + '_' + np.Network_Name_for_Grid__c + '_' + np.Network_Type__c;
                    key = key.toUpperCase();
                    if(networkKeyToNpListMap.containsKey(key)){
                        networkKeyToNpListMap.get(key).add(np);
                    } else {
                        List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                        temp.add(np);
                        networkKeyToNpListMap.put(key, temp);
                    }
                }
                
                currSeq = Integer.valueOf(currentNP.Sequence_Number__c);
                
                system.debug('currSeq----------'+currSeq+'------newSeq----'+newSeq);
                
                if(newSeq != null && newSeq >= currentNP.FAF_Network_Ops__r.Network_Pricing_Min_Seq__c && newSeq <= currentNP.FAF_Network_Ops__r.Network_Pricing_Max_Seq__c ){
                       
                    if(currSeq != null){
                        currentNP.Sequence_Number__c = newSeq;
                        npUpdateMap.put(currentNP.Id, currentNP);
                        String key1 = currentNP.Retail_Network_Ordinal__c + '_' + currentNP.Network_Name_for_Grid__c + '_' + currentNP.Network_Type__c;
                        key1 = key1.toUpperCase();
                        if(networkKeyToNpListMap.containsKey(key1)){
                            for(Network_Pricing__c np : networkKeyToNpListMap.get(key1)){
                                np.Sequence_Number__c = currentNP.Sequence_Number__c;
                                npUpdateMap.put(np.Id, np);
                            }
                        }
                        system.debug('npUpdateMap----------'+npUpdateMap);
                        
                        if(newSeq < currSeq){ //6 -> 2
                            for(Integer i = newSeq ; i < currSeq ; i++){
                                Network_Pricing__c changeNP = new Network_Pricing__c();
                                if(npSeqMap.containsKey(i)){
                                    changeNP = npSeqMap.get(i);
                                    changeNP.Sequence_Number__c = changeNP.Sequence_Number__c + 1;
                                    npUpdateMap.put(changeNP.Id, changeNP);
                                    
                                    String key = changeNP.Retail_Network_Ordinal__c + '_' + changeNP.Network_Name_for_Grid__c + '_' + changeNP.Network_Type__c;
                                    key = key.toUpperCase();
                                    if(networkKeyToNpListMap.containsKey(key)){
                                        for(Network_Pricing__c np : networkKeyToNpListMap.get(key)){
                                            np.Sequence_Number__c = changeNP.Sequence_Number__c;
                                            npUpdateMap.put(np.Id, np);
                                        }
                                    }
                                }
                            }
                            system.debug('npUpdateMap------1----'+npUpdateMap);
                        } else if(newSeq > currSeq){ //2 -> 6
                            for(Integer i = newSeq ; i > currSeq ; i--){
                                Network_Pricing__c changeNP = new Network_Pricing__c();
                                if(npSeqMap.containsKey(i)){
                                    changeNP = npSeqMap.get(i);
                                    changeNP.Sequence_Number__c = changeNP.Sequence_Number__c - 1;
                                    npUpdateMap.put(changeNP.Id, changeNP);
                                    
                                    String key = changeNP.Retail_Network_Ordinal__c + '_' + changeNP.Network_Name_for_Grid__c + '_' + changeNP.Network_Type__c;
                                    key = key.toUpperCase();
                                    if(networkKeyToNpListMap.containsKey(key)){
                                        for(Network_Pricing__c np : networkKeyToNpListMap.get(key)){
                                            np.Sequence_Number__c = changeNP.Sequence_Number__c;
                                            npUpdateMap.put(np.Id, np);
                                        }
                                    }
                                }
                            }
                            system.debug('npUpdateMap-----2-----'+npUpdateMap);
                        } 
                    } else if(currSeq == null ){
                        currentNP.Sequence_Number__c = newSeq;
                        String key = currentNP.Retail_Network_Ordinal__c + '_' + currentNP.Network_Name_for_Grid__c + '_' + currentNP.Network_Type__c;
                        key = key.toUpperCase();
                        if(networkKeyToNpListMap.containsKey(key)){
                            for(Network_Pricing__c np : networkKeyToNpListMap.get(key)){
                                np.Sequence_Number__c = currentNP.Sequence_Number__c;
                                npUpdateMap.put(np.Id, np);
                            }
                        }
                        npUpdateMap.put(currentNP.Id, currentNP);
                    } 
                    if(!npUpdateMap.values().isEmpty()){
                        Database.SaveResult[] srList = Database.update(npUpdateMap.values(), false);
                    }
                } else if(currSeq == null && npAllNullList.size() == npAllList.size()){
                    List<String> opidList = new List<String>();
                    opidList.add(opid);
                    UpdatePricingSequence.updateSequence(opidList);
                }
            }
        } 
    }
    
    @AuraEnabled
    global static void updateMPSeq(String recId, String aliId, String currSeqNum, String newSeqNum, Boolean isUpDown) {
        Integer currSeg;
        Integer newSeq;
        Id mailOp;
        Integer max;
        Integer min;
        String mailOpName;
        /*if(currSeqNum == null){
            currSeg = Integer.valueOf([Select id, Sequence_Number__c from Mail_Pricing__c where id=: recId limit 1].Sequence_Number__c);
        }else{
            currSeg = Integer.valueOf(currSeqNum);
        }*/
        if(newSeqNum != null){
            newSeq = Integer.valueOf(newSeqNum);
        }
        List<Integer> seqs = new List<Integer>{currSeg, newSeq};
        Map<Integer, List<Mail_Pricing__c>> allMailPricing = new Map<Integer, List<Mail_Pricing__c>>();
        Map<Integer, Mail_Sequence_Setting__c> mailSeqSetting = new Map<Integer, Mail_Sequence_Setting__c>(); 
        List<Mail_Pricing__c> updateMailPricing = new List<Mail_Pricing__c>();
        Mail_Pricing__c mailPc = [Select id, Sequence_Number__c, Agreement_Line_Item__r.name, LOB__c, FAF_ID__r.name, 
                                  FAF_Mail_Operations__c, FAF_Mail_Operations__r.name, FAF_Mail_Operations__r.Mail_Max_Sequence__c, FAF_Mail_Operations__r.Mail_Min_Sequence__c  
                                  from Mail_Pricing__c where id=:recId];
       
        if(mailPc != null){
           currSeg = Integer.valueOf(mailPc.Sequence_Number__c);
           mailOp = mailPc.FAF_Mail_Operations__c;
           mailOpName = mailPc.FAF_Mail_Operations__r.name;
           max = Integer.valueOf(mailPc.FAF_Mail_Operations__r.Mail_Max_Sequence__c);
           min = Integer.valueOf(mailPc.FAF_Mail_Operations__r.Mail_Min_Sequence__c);
        }
        
        if(mailPc != null && currSeg == null){
            mailPc.Sequence_Number__c = newSeq;
            insert new Mail_Sequence_Setting__c(Agreement_Line_Item_ID__c = mailPc.Agreement_Line_Item__r.name, FAF_ID__c = mailPc.FAF_ID__r.name, LOB__c = mailPc.LOB__c, 
                                                Mail_Operation_ID__c = mailOpName, Sequence_Number__c = newSeq);
            update mailPc;
            UpdateMailPricingSequence.updateSequence(new List<Id>{mailPc.FAF_Mail_Operations__c});
            return;
        }
        
        if(newSeq>max || newSeq<min){
            return;
        }
        for(Mail_Pricing__c mp : [Select id, LOB__c,Sequence_Number__c, FAF_Mail_Operations__r.name from Mail_Pricing__c where FAF_Mail_Operations__c =: mailOp  order by Sequence_Number__c desc]){
            Integer key = Integer.valueOf(mp.Sequence_Number__c);
            if(allMailPricing.containsKey(key)){
                allMailPricing.get(key).add(mp);
                continue;
            }
            allMailPricing.put(key, new List<Mail_Pricing__c>{mp});
        }
        for(Mail_Sequence_Setting__c mp : [Select id ,Sequence_Number__c from Mail_Sequence_Setting__c where Mail_Operation_ID__c =: mailOpName  order by Sequence_Number__c desc]){
            Integer key = Integer.valueOf(mp.Sequence_Number__c);
            if(mailSeqSetting.containsKey(key)){
                continue;
            }
            mailSeqSetting.put(key, mp);
        }
        
        // down
        if(newSeq>currSeg){
            integer start = currSeg;
            for(;start<newSeq; start++){
                for(Mail_Pricing__c eachMailP : allMailPricing.get(start+1)){
                    eachMailP.Sequence_Number__c = start;
                    updateMailPricing.add(eachMailP);
                }
                mailSeqSetting.get(start+1).Sequence_Number__c = start;
            }
            for(Mail_Pricing__c eachMailP : allMailPricing.get(currSeg)){
                    eachMailP.Sequence_Number__c = start;
                    updateMailPricing.add(eachMailP);
            }
            mailSeqSetting.get(currSeg).Sequence_Number__c = start;
        }else{
            integer start = currSeg;
            for(;start>newSeq; start--){
                for(Mail_Pricing__c eachMailP : allMailPricing.get(start-1)){
                    eachMailP.Sequence_Number__c = start;
                    updateMailPricing.add(eachMailP);
                }
                mailSeqSetting.get(start-1).Sequence_Number__c = start;
            }
            for(Mail_Pricing__c eachMailP : allMailPricing.get(currSeg)){
                    eachMailP.Sequence_Number__c = start;
                    updateMailPricing.add(eachMailP);
            }
            mailSeqSetting.get(currSeg).Sequence_Number__c = start;
        }
        
        // update pricing and sequence
        update updateMailPricing;
        update mailSeqSetting.values();
    }
    
    @AuraEnabled
    global static void updateRGSeq(String recId, String aliId, String newSeqNum) {
        Map<String, List<Rebate_Guarantees__c>> keyToAllRebateMap =  new Map<String, List<Rebate_Guarantees__c>>();
        Map<Integer, List<Rebate_Guarantees__c>> seqToAllRebateMap =  new Map<Integer, List<Rebate_Guarantees__c>>();
        Map<String, List<Rebate_Guarantee_Denorm__c>> keyToAllRebateGDMap =  new Map<String, List<Rebate_Guarantee_Denorm__c>>();
        Map<Integer, List<Rebate_Guarantee_Denorm__c>> seqToAllRebateGDMap =  new Map<Integer, List<Rebate_Guarantee_Denorm__c>>();
        Map<String, Rebate_Guarantees__c> updateRebateMap =  new Map<String, Rebate_Guarantees__c>();
        Map<String, Rebate_Guarantee_Denorm__c> updateRebateGDMap =  new Map<String, Rebate_Guarantee_Denorm__c>();
        
        List<Rebate_Guarantees__c> rgAllNullSeqList = new List<Rebate_Guarantees__c>();
        List<Rebate_Guarantee_Denorm__c> rgdAllNullSeqList = new List<Rebate_Guarantee_Denorm__c>();
        
        List<Rebate_Guarantees__c> rgNullSeqList = new List<Rebate_Guarantees__c>();
        List<Rebate_Guarantee_Denorm__c> rgdNullSeqList = new List<Rebate_Guarantee_Denorm__c>();
        
        Rebate_Guarantee_Denorm__c currentRGD = new Rebate_Guarantee_Denorm__c();
        
        if(String.isNotBlank(newSeqNum ) && String.isNotBlank(recId )){
            Integer newSeq = Integer.valueOf(newSeqNum);
            Integer currSeq;
            String opid;
            
            currentRGD = [
                Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                from Rebate_Guarantee_Denorm__c 
                Where Id = : recId
            ];
            opid = currentRGD.Rebate_Operations__c;
            currSeq = Integer.valueOf(currentRGD.Sequence_Number__c);
            
            for(Rebate_Guarantees__c rg : [
                Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                from Rebate_Guarantees__c 
                Where Rebate_Operations__c = : opid 
            ]){
                if(keyToAllRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToAllRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Rebate_Guarantees__c> temp = new list<Rebate_Guarantees__c>();
                    temp.add(rg);
                    keyToAllRebateMap.put(rg.Composite_Key__c, temp);
                }
                if(rg.Sequence_Number__c != null){
                    if(seqToAllRebateMap.containsKey(Integer.valueOf(rg.Sequence_Number__c))){
                        seqToAllRebateMap.get(Integer.valueOf(rg.Sequence_Number__c)).add(rg);
                    } else {
                        list<Rebate_Guarantees__c> temp = new list<Rebate_Guarantees__c>();
                        temp.add(rg);
                        seqToAllRebateMap.put(Integer.valueOf(rg.Sequence_Number__c), temp);
                    }
                } else {
                    rgNullSeqList.add(rg);
                }
                rgAllNullSeqList.add(rg);
            }
            
            for(Rebate_Guarantee_Denorm__c rgd : [
                Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                from Rebate_Guarantee_Denorm__c 
                Where Rebate_Operations__c = : opid 
            ]){
                if(keyToAllRebateGDMap.containsKey(rgd.Composite_Key__c)){
                    keyToAllRebateGDMap.get(rgd.Composite_Key__c).add(rgd);
                } else {
                    list<Rebate_Guarantee_Denorm__c> temp = new list<Rebate_Guarantee_Denorm__c>();
                    temp.add(rgd);
                    keyToAllRebateGDMap.put(rgd.Composite_Key__c, temp);
                }
                if(rgd.Sequence_Number__c != null){
                    if(seqToAllRebateGDMap.containsKey(Integer.valueOf(rgd.Sequence_Number__c))){
                        seqToAllRebateGDMap.get(Integer.valueOf(rgd.Sequence_Number__c)).add(rgd);
                    } else {
                        list<Rebate_Guarantee_Denorm__c> temp = new list<Rebate_Guarantee_Denorm__c>();
                        temp.add(rgd);
                        seqToAllRebateGDMap.put(Integer.valueOf(rgd.Sequence_Number__c), temp);
                    }
                } else {
                    rgdNullSeqList.add(rgd);
                }
                rgdAllNullSeqList.add(rgd);
            }
            system.debug('newSeq------------------------'+newSeq);
            system.debug('currSeq------------------------'+currSeq);
            system.debug('rgdNullSeqList------------------------'+rgdNullSeqList.size());
            system.debug('rgdAllNullSeqList------------------------'+rgdAllNullSeqList.size());
            system.debug('rgNullSeqList------------------------'+rgNullSeqList.size());
            system.debug('rgAllNullSeqList------------------------'+rgAllNullSeqList.size());
            
            if(newSeq != null ){
                if(currSeq != null){
                    if(seqToAllRebateMap.containsKey(currSeq)){
                        for(Rebate_Guarantees__c rg : seqToAllRebateMap.get(currSeq)){
                            rg.Sequence_Number__c = newSeq;
                            updateRebateMap.put(rg.Id, rg);
                        }
                    }
                    if(seqToAllRebateGDMap.containsKey(currSeq)){
                        for(Rebate_Guarantee_Denorm__c rgd : seqToAllRebateGDMap.get(currSeq)){
                            rgd.Sequence_Number__c = newSeq;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }
                    }
                    
                    if(newSeq < currSeq){ //6 -> 2
                        for(Integer i = newSeq ; i < currSeq ; i++){
                            if(seqToAllRebateMap.containsKey(i)){
                                for(Rebate_Guarantees__c rg : seqToAllRebateMap.get(i)){
                                    rg.Sequence_Number__c = rg.Sequence_Number__c + 1;
                                    updateRebateMap.put(rg.Id, rg);
                                }
                            }
                            if(seqToAllRebateGDMap.containsKey(i)){
                                for(Rebate_Guarantee_Denorm__c rgd : seqToAllRebateGDMap.get(i)){
                                    rgd.Sequence_Number__c = rgd.Sequence_Number__c + 1;
                                    updateRebateGDMap.put(rgd.Id, rgd);
                                }
                            }
                        }
                        system.debug('updateRebateGDMap------1----'+updateRebateGDMap);
                    } else if(newSeq > currSeq){ //2 -> 6
                        for(Integer i = newSeq ; i > currSeq ; i--){
                            if(seqToAllRebateMap.containsKey(i)){
                                for(Rebate_Guarantees__c rg : seqToAllRebateMap.get(i)){
                                    rg.Sequence_Number__c = rg.Sequence_Number__c - 1;
                                    updateRebateMap.put(rg.Id, rg);
                                }
                            }
                            if(seqToAllRebateGDMap.containsKey(i)){
                                for(Rebate_Guarantee_Denorm__c rgd : seqToAllRebateGDMap.get(i)){
                                    rgd.Sequence_Number__c = rgd.Sequence_Number__c - 1;
                                    updateRebateGDMap.put(rgd.Id, rgd);
                                }
                            }
                        }
                        system.debug('updateRebateGDMap-----2-----'+updateRebateGDMap);
                    } 
                } else if(currSeq == null && (rgNullSeqList.size() == rgAllNullSeqList.size() || rgdNullSeqList.size() == rgdAllNullSeqList.size())) {
                    List<String> opidList = new List<String>();
                    opidList.add(opid);
                    UpdateRebatePricingSequence.updateSequence(opidList);
                } else if(currSeq == null ){
                    if(keyToAllRebateMap.containsKey(currentRGD.Composite_Key__c)){
                        for(Rebate_Guarantees__c rg : keyToAllRebateMap.get(currentRGD.Composite_Key__c)){
                            rg.Sequence_Number__c = newSeq;
                            updateRebateMap.put(rg.Id, rg);
                        }
                    }
                    if(keyToAllRebateGDMap.containsKey(currentRGD.Composite_Key__c)){
                        for(Rebate_Guarantee_Denorm__c rgd : keyToAllRebateGDMap.get(currentRGD.Composite_Key__c)){
                            rgd.Sequence_Number__c = newSeq;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }
                    }
                } 
                if(!updateRebateGDMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateGDMap.values(), false);
                }
                if(!updateRebateMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateMap.values(), false);
                }
            } 
        }
    }
      
  // Update Specialty Sequence Number .
  @AuraEnabled
    global static void updateSpecSeq(String recId, String aliId, String newSeqNum) {
        Map<String, List<Specialty_Pricing__c>> keyToAllRebateMap =  new Map<String, List<Specialty_Pricing__c>>();
        Map<Integer, List<Specialty_Pricing__c>> seqToAllRebateMap =  new Map<Integer, List<Specialty_Pricing__c>>();
        Map<String, List<Specialty_Sequence_Setting__c>> keyToAllRebateGDMap =  new Map<String, List<Specialty_Sequence_Setting__c>>();
        Map<Integer, List<Specialty_Sequence_Setting__c>> seqToAllRebateGDMap =  new Map<Integer, List<Specialty_Sequence_Setting__c>>();
        Map<String, Specialty_Pricing__c> updateRebateMap =  new Map<String, Specialty_Pricing__c>();
        Map<String, Specialty_Sequence_Setting__c> updateRebateGDMap =  new Map<String, Specialty_Sequence_Setting__c>();
        
        List<Specialty_Pricing__c> rgAllNullSeqList = new List<Specialty_Pricing__c>();
        List<Specialty_Sequence_Setting__c> rgdAllNullSeqList = new List<Specialty_Sequence_Setting__c>();
        
        List<Specialty_Pricing__c> rgNullSeqList = new List<Specialty_Pricing__c>();
        List<Specialty_Sequence_Setting__c> rgdNullSeqList = new List<Specialty_Sequence_Setting__c>();
        
        Specialty_Pricing__c currentRGD = new Specialty_Pricing__c();
        
        
        if(String.isNotBlank(newSeqNum ) && String.isNotBlank(recId)){
            Integer newSeq = Integer.valueOf(newSeqNum);
            Integer currSeq;
            String opid;
          
            currentRGD = [
                Select Id, Composite_Key__c,Specialty_Operations__r.Specialty_MAX_Sequence__c,Specialty_Operations__r.Specialty_MIN_Sequence__c, Sequence_Number__c, Specialty_Operations__c 
                from Specialty_Pricing__c 
                Where Id = : recId
            ];
            opid = currentRGD.Specialty_Operations__c;
            currSeq = Integer.valueOf(currentRGD.Sequence_Number__c);
            system.debug('********** In method'+newSeq);
            if(newSeq >= currentRGD.Specialty_Operations__r.Specialty_MIN_Sequence__c && newSeq <=currentRGD.Specialty_Operations__r.Specialty_MAX_Sequence__c||currSeq==null ){
            
            
            for(Specialty_Pricing__c rg : [
                Select Id, Composite_Key__c, Sequence_Number__c, Specialty_Operations__c 
                from Specialty_Pricing__c 
                Where Specialty_Operations__c = : opid 
            ]){
                if(keyToAllRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToAllRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Specialty_Pricing__c> temp = new list<Specialty_Pricing__c>();
                    temp.add(rg);
                    keyToAllRebateMap.put(rg.Composite_Key__c, temp);
                }
                if(rg.Sequence_Number__c != null){
                    if(seqToAllRebateMap.containsKey(Integer.valueOf(rg.Sequence_Number__c))){
                        seqToAllRebateMap.get(Integer.valueOf(rg.Sequence_Number__c)).add(rg);
                    } else {
                        list<Specialty_Pricing__c> temp = new list<Specialty_Pricing__c>();
                        temp.add(rg);
                        seqToAllRebateMap.put(Integer.valueOf(rg.Sequence_Number__c), temp);
                    }
                } else {
                    rgNullSeqList.add(rg);
                }
                rgAllNullSeqList.add(rg);
            }
            
            for(Specialty_Sequence_Setting__c rgd : [
                Select Id, Composite_Key__c, Sequence_Number__c, Specialty_Operations__c 
                from Specialty_Sequence_Setting__c 
                Where Specialty_Operations__c = : opid 
            ]){
                if(keyToAllRebateGDMap.containsKey(rgd.Composite_Key__c)){
                    keyToAllRebateGDMap.get(rgd.Composite_Key__c).add(rgd);
                } else {
                    list<Specialty_Sequence_Setting__c> temp = new list<Specialty_Sequence_Setting__c>();
                    temp.add(rgd);
                    keyToAllRebateGDMap.put(rgd.Composite_Key__c, temp);
                }
                if(rgd.Sequence_Number__c != null){
                    if(seqToAllRebateGDMap.containsKey(Integer.valueOf(rgd.Sequence_Number__c))){
                        seqToAllRebateGDMap.get(Integer.valueOf(rgd.Sequence_Number__c)).add(rgd);
                    } else {
                        list<Specialty_Sequence_Setting__c> temp = new list<Specialty_Sequence_Setting__c>();
                        temp.add(rgd);
                        seqToAllRebateGDMap.put(Integer.valueOf(rgd.Sequence_Number__c), temp);
                    }
                } else {
                    rgdNullSeqList.add(rgd);
                }
                rgdAllNullSeqList.add(rgd);
            }
            system.debug('newSeq------------------------'+newSeq);
            system.debug('currSeq------------------------'+currSeq);
            system.debug('rgdNullSeqList------------------------'+rgdNullSeqList.size());
            system.debug('rgdAllNullSeqList------------------------'+rgdAllNullSeqList.size());
            system.debug('rgNullSeqList------------------------'+rgNullSeqList.size());
            system.debug('rgAllNullSeqList------------------------'+rgAllNullSeqList.size());
            
            if(newSeq != null ){
                if(currSeq != null){
                    if(seqToAllRebateMap.containsKey(currSeq)){
                        for(Specialty_Pricing__c rg : seqToAllRebateMap.get(currSeq)){
                            rg.Sequence_Number__c = newSeq;
                            updateRebateMap.put(rg.Id, rg);
                        }
                    }
                    if(seqToAllRebateGDMap.containsKey(currSeq)){
                        for(Specialty_Sequence_Setting__c rgd : seqToAllRebateGDMap.get(currSeq)){
                            rgd.Sequence_Number__c = newSeq;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }
                    }
                    
                    if(newSeq < currSeq){ //6 -> 2
                        for(Integer i = newSeq ; i < currSeq ; i++){
                            if(seqToAllRebateMap.containsKey(i)){
                                for(Specialty_Pricing__c rg : seqToAllRebateMap.get(i)){
                                    rg.Sequence_Number__c = rg.Sequence_Number__c + 1;
                                    updateRebateMap.put(rg.Id, rg);
                                }
                            }
                            if(seqToAllRebateGDMap.containsKey(i)){
                                for(Specialty_Sequence_Setting__c rgd : seqToAllRebateGDMap.get(i)){
                                    rgd.Sequence_Number__c = rgd.Sequence_Number__c + 1;
                                    updateRebateGDMap.put(rgd.Id, rgd);
                                }
                            }
                        }
                        system.debug('updateRebateGDMap------1----'+updateRebateGDMap);
                    } else if(newSeq > currSeq){ //2 -> 6
                        for(Integer i = newSeq ; i > currSeq ; i--){
                            if(seqToAllRebateMap.containsKey(i)){
                                for(Specialty_Pricing__c rg : seqToAllRebateMap.get(i)){
                                    rg.Sequence_Number__c = rg.Sequence_Number__c - 1;
                                    updateRebateMap.put(rg.Id, rg);
                                }
                            }
                            if(seqToAllRebateGDMap.containsKey(i)){
                                for(Specialty_Sequence_Setting__c rgd : seqToAllRebateGDMap.get(i)){
                                    rgd.Sequence_Number__c = rgd.Sequence_Number__c - 1;
                                    updateRebateGDMap.put(rgd.Id, rgd);
                                }
                            }
                        }
                        system.debug('updateRebateGDMap-----2-----'+updateRebateGDMap);
                    } 
                } else if(currSeq == null && (rgNullSeqList.size() == rgAllNullSeqList.size() || rgdNullSeqList.size() == rgdAllNullSeqList.size())) {
                system.debug('################');
                    List<String> opidList = new List<String>();
                    opidList.add(opid);
                    UpdateSpecialtyPricingSequence_1.updateSequence(opidList);
                } else if(currSeq == null ){
                 system.debug('*********');
                    if(keyToAllRebateMap.containsKey(currentRGD.Composite_Key__c)){
                        for(Specialty_Pricing__c rg : keyToAllRebateMap.get(currentRGD.Composite_Key__c)){
                            rg.Sequence_Number__c = newSeq;
                            updateRebateMap.put(rg.Id, rg);
                        }
                    }
                    if(keyToAllRebateGDMap.containsKey(currentRGD.Composite_Key__c)){
                        for(Specialty_Sequence_Setting__c rgd : keyToAllRebateGDMap.get(currentRGD.Composite_Key__c)){
                            rgd.Sequence_Number__c = newSeq;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }
                    }
                } 
                system.debug('updateRebateMapupdateRebateMapupdateRebateMap'+updateRebateMap);
                if(!updateRebateGDMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateGDMap.values(), false);
                }
                if(!updateRebateMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateMap.values(), false);
                }
            } 
        }
        }
    }
}