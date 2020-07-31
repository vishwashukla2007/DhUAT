public class UpdateMailPricingSequence {
@invocableMethod
Public Static void updateSequence(List<String> OpId){
    DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
    List<Mail_Sequence_Setting__c> msMissInsertList = new List<Mail_Sequence_Setting__c>();
    Map<String, Integer> mapOfLobToSequence = new Map<String, Integer>();
    List<Mail_Pricing__c> listOfAllMP = new List<Mail_Pricing__c>();
    List<Mail_Pricing__c> listOfNullMP = new List<Mail_Pricing__c>();
    List<Mail_Pricing__c> listOfMPToBeUpdated= new List<Mail_Pricing__c>();
    List<Mail_Pricing__c> listOfMPSequenceNotKnown = new List<Mail_Pricing__c>();
    Set<String> mailOpNames = new Set<String>();
    Map<id, Mail_Sequence_Setting__c> mapOfMailIdToSequenceSetting = new Map<id, Mail_Sequence_Setting__c>();
    Map<String, Integer> highestSeqMap = new Map<String, Integer>();
    integer SequenceNumber = 0;
    Integer hightestSeqNumber = 0;
    
    for(Mail_Pricing__c mp : [Select id, LOB__c,Sequence_Number__c,FAF_ID__r.name,FAF_Mail_Operations__r.name, Agreement_Line_Item__r.name, FAF_Mail_Operations__c
                              from Mail_Pricing__c where FAF_Mail_Operations__c IN : OpId order by Sequence_Number__c desc]){
                                  
         if(mp.Sequence_Number__c == null){                      
           listOfNullMP.add(mp);
         }                                 
        listOfAllMP.add(mp);                          
        mailOpNames.add(mp.FAF_Mail_Operations__r.name);                       
        // map highest seq for each operations                                                    
        if(highestSeqMap.containsKey(mp.FAF_Mail_Operations__r.name)){
            if(mp.Sequence_Number__c != null  && highestSeqMap.get(mp.FAF_Mail_Operations__r.name)<Integer.valueOf(mp.Sequence_Number__c))
                highestSeqMap.put(mp.FAF_Mail_Operations__r.name, Integer.valueOf(mp.Sequence_Number__c));
        }else{
            Integer seq = mp.Sequence_Number__c == null?0:Integer.valueOf(mp.Sequence_Number__c);
            highestSeqMap.put(mp.FAF_Mail_Operations__r.name, seq);
        }
      }
    
    // query sequence per lob
    for(Mail_Sequence_Setting__c sn : [Select Agreement_Line_Item_ID__c, LOB__c, FAF_ID__c, Sequence_Number__c, Mail_Operation_ID__c from Mail_Sequence_Setting__c where Mail_Operation_ID__c IN: mailOpNames AND Sequence_Number__c != null]){
        string key = sn.LOB__c + sn.FAF_ID__c + sn.Agreement_Line_Item_ID__c + sn.Mail_Operation_ID__c;
        mapOfLobToSequence.put(key, Integer.valueOf(sn.Sequence_Number__c));
    }
    
    // since this also fires for lob change which is determined by checking if every records has sequence
    if(listOfNullMP.size() == 0){
        for(String eachHigh : highestSeqMap.keySet()){
            highestSeqMap.put(eachHigh, 0);
        }
        mapOfLobToSequence = new Map<String, Integer>();
        List<Mail_Sequence_Setting__c> lstOfAllSequenceDeletedOps = [Select id, Agreement_Line_Item_ID__c, LOB__c, FAF_ID__c, Sequence_Number__c, Mail_Operation_ID__c from Mail_Sequence_Setting__c where Mail_Operation_ID__c IN : mailOpNames];
        if(lstOfAllSequenceDeletedOps.size()>0){
            delete lstOfAllSequenceDeletedOps;
        }
        listOfNullMP.addAll(listOfAllMP);
    }

    // find the right sequence for mail princing with new lobs
    for(Mail_Pricing__c mp : listOfNullMP){
        string key = mp.LOB__c + mp.FAF_ID__r.name + mp.Agreement_Line_Item__r.name + mp.FAF_Mail_Operations__r.name;
        System.debug('*****key '+key);
        if(mapOfLobToSequence.containskey(key)){
            mp.Sequence_Number__c = mapOfLobToSequence.get(key);
        }else{
            highestSeqMap.put(mp.FAF_Mail_Operations__r.name, highestSeqMap.get(mp.FAF_Mail_Operations__r.name)+1); 
            mp.Sequence_Number__c = highestSeqMap.get(mp.FAF_Mail_Operations__r.name);
            mapOfLobToSequence.put(key, Integer.valueOf(mp.Sequence_Number__c));
            Mail_Sequence_Setting__c sequenceObj = new Mail_Sequence_Setting__c(LOB__c=mp.LOB__c, FAF_ID__c=mp.FAF_ID__r.name, Agreement_Line_Item_ID__c= mp.Agreement_Line_Item__r.name, Mail_Operation_ID__c=mp.FAF_Mail_Operations__r.name);
            sequenceObj.Sequence_Number__c = mp.Sequence_Number__c;
            mapOfLobToSequence.put(key, Integer.valueOf(mp.Sequence_Number__c));
            mapOfMailIdToSequenceSetting.put(mp.id, sequenceObj);             
        }
    }
   
    upsert mapOfMailIdToSequenceSetting.values();
    update listOfNullMP;
   }
}