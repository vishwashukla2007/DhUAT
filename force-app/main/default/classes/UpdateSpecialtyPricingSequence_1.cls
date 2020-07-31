public class UpdateSpecialtyPricingSequence_1 {
  @InvocableMethod
    public static void updateSequence(List<String> opid){
    //if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
     DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Map<String, List<Specialty_Pricing__c>> keyToNotNullRebateMap =  new Map<String, List<Specialty_Pricing__c>>();
        Map<String, List<Specialty_Pricing__c>> keyToNullRebateMap =  new Map<String, List<Specialty_Pricing__c>>();
        Map<String, List<Specialty_Pricing__c>> keyToNullRebateTempMap =  new Map<String, List<Specialty_Pricing__c>>();
        
        list<Specialty_Pricing__c> allRGList = new list<Specialty_Pricing__c>();
        list<Specialty_Pricing__c> rgNullSequenceUpdateList = new list<Specialty_Pricing__c>();
        list<Integer> sortList = new list<Integer>();
        List<Specialty_Sequence_Setting__c> sequenceList=new List<Specialty_Sequence_Setting__c>();
        map<String,String> mapChekSetting= new map<String,String>();
        Set<String> ChekSQLSetting= new Set<String>();
        Integer hightestSeqNumber = 0;
        
        allRGList = [
            Select Id, Composite_Key__c,Pharmacy_Benefit__c,Sequence_Number__c, Specialty_Operations__c 
            from Specialty_Pricing__c 
            Where Specialty_Operations__c = : opid[0] and Pharmacy_Benefit__c!='None' Order By Composite_Key__c
        ];
         List<Specialty_Sequence_Setting__c> deleteSequence=[Select ID,Name,Composite_Key__c from Specialty_Sequence_Setting__c where Specialty_Operations__c IN:opid];
                for(Specialty_Sequence_Setting__c sqlSetting :deleteSequence){
                 mapChekSetting.put(sqlSetting.Composite_Key__c,sqlSetting.Name);
                 ChekSQLSetting.add(sqlSetting.Composite_Key__c);
                }
        for(Specialty_Pricing__c rg : allRGList){
            if(!ChekSQLSetting.contains(rg.Composite_Key__c)){
                Specialty_Sequence_Setting__c squ=new Specialty_Sequence_Setting__c();
                squ.Composite_Key__c=rg.Composite_Key__c;
                squ.Specialty_Operations__c=rg.Specialty_Operations__c;
                squ.Sequence_Number__c=rg.Sequence_Number__c;
                sequenceList.add(squ);
                ChekSQLSetting.add(rg.Composite_Key__c);
            }
            if(rg.Sequence_Number__c != null){
                if(keyToNotNullRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToNotNullRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Specialty_Pricing__c> temp = new list<Specialty_Pricing__c>();
                    temp.add(rg);
                    keyToNotNullRebateMap.put(rg.Composite_Key__c, temp);
                }
                sortList.add(Integer.valueOf(rg.Sequence_Number__c));
            } else {
                if(keyToNullRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToNullRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Specialty_Pricing__c> temp = new list<Specialty_Pricing__c>();
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
                for(Specialty_Pricing__c rg : keyToNullRebateMap.get(key)){
                    rg.Sequence_Number__c = seq;
                    rgNullSequenceUpdateList.add(rg);
                }
            } else {
                keyToNullRebateTempMap.put(key, keyToNullRebateMap.get(key));
            }
        }
        
        for(String key :keyToNullRebateTempMap.keySet()){
            hightestSeqNumber = hightestSeqNumber + 1;
            for(Specialty_Pricing__c rg : keyToNullRebateTempMap.get(key)){
                rg.Sequence_Number__c = hightestSeqNumber;
                rgNullSequenceUpdateList.add(rg);
            }            
        }
        if(!deleteSequence.isEmpty()){
           //Delete deleteSequence;
        }
        if(!rgNullSequenceUpdateList.isEmpty()){
        update rgNullSequenceUpdateList;
        }
        if(!sequenceList.isEmpty()){
        insert sequenceList;
        }
        updateRGDSequence(opid);
        //}
    }
   
    public static void updateRGDSequence(List<String> opid){
        Map<String, List<Specialty_Pricing__c>> keyToNotNullRebateMap =  new Map<String, List<Specialty_Pricing__c>>();
        Map<String, List<Specialty_Sequence_Setting__c>> keyToNullRebateDenormMap =  new Map<String, List<Specialty_Sequence_Setting__c>>();
        
        list<Specialty_Pricing__c> allRGList = new list<Specialty_Pricing__c>();
        list<Specialty_Sequence_Setting__c> allRGDList = new list<Specialty_Sequence_Setting__c>();
        list<Specialty_Sequence_Setting__c> rgdNullSequenceUpdateList = new list<Specialty_Sequence_Setting__c>();
        
        allRGList = [
            Select Id, Composite_Key__c, Sequence_Number__c, Specialty_Operations__c 
            from Specialty_Pricing__c 
            Where Specialty_Operations__c = : opid[0] Order By Composite_Key__c
        ];
        
        for(Specialty_Pricing__c rg : allRGList){
            if(rg.Sequence_Number__c != null){
                if(keyToNotNullRebateMap.containsKey(rg.Composite_Key__c)){
                    keyToNotNullRebateMap.get(rg.Composite_Key__c).add(rg);
                } else {
                    list<Specialty_Pricing__c> temp = new list<Specialty_Pricing__c>();
                    temp.add(rg);
                    keyToNotNullRebateMap.put(rg.Composite_Key__c, temp);
                }
            } 
        }
        allRGDList = [
            Select Id, Composite_Key__c, Sequence_Number__c, Specialty_Operations__c 
            from Specialty_Sequence_Setting__c 
            Where Specialty_Operations__c = : opid[0]  and Sequence_Number__c = null //and Grid_flag__c = true
        ];
        
        system.debug('allRGDList------------------->'+allRGDList.size());
        for(Specialty_Sequence_Setting__c rgd : allRGDList){
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