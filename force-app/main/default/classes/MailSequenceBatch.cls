global class MailSequenceBatch implements Database.Batchable<sObject>,Database.Stateful{
   
    Global Set<String> opsIdSet;
    Global Map<String, Integer> mapOfLobToSequence;
    Global Map<String, Integer> mapOfOpsToHighest;
	//Global Set<String> opsNamesSetWithoutSequence;    
    global MailSequenceBatch(Set<String> opIds) {
        opsIdSet = new Set<String>();
        opsIdSet = opIds;
        mapOfOpsToHighest = new Map<String, Integer>();
        // this query can be avoided if we pass names of mail ops intead of ids
        Set<String> opsNamesSet = new Set<String>();
        for(Mail_Operations__c eachOp : [select name from Mail_Operations__c where ID IN : opsIdSet]){
            opsNamesSet.add(eachOp.name);
            mapOfOpsToHighest.put(eachOp.name, 0);
        }
        //opsNamesSetWithoutSequence.addAll(opsNamesSet);
        // query sequence per lob
        mapOfLobToSequence = new Map<String, Integer>();
        for(Mail_Sequence_Setting__c sn : [Select Agreement_Line_Item_ID__c, LOB__c, FAF_ID__c, Sequence_Number__c, Mail_Operation_ID__c from Mail_Sequence_Setting__c where Mail_Operation_ID__c IN: opsNamesSet AND Sequence_Number__c != null]){
            string key = sn.LOB__c + sn.FAF_ID__c + sn.Agreement_Line_Item_ID__c + sn.Mail_Operation_ID__c;
            mapOfLobToSequence.put(key, Integer.valueOf(sn.Sequence_Number__c));
            mapOfOpsToHighest.remove(sn.Mail_Operation_ID__c);
        }
        System.debug('con#####'+ mapOfLobToSequence); 
    }
    global database.QueryLocator start(Database.BatchableContext bc){
     String query = 'Select id, Sequence_Number__c, Agreement_Line_Item__r.name, LOB__c, FAF_ID__r.name,'+
                    'FAF_Mail_Operations__c, FAF_Mail_Operations__r.name from Mail_Pricing__c '+
         			'where FAF_Mail_Operations__c IN : opsIdSet';
     System.debug('new#####'+ query);   
     System.debug('opsIdSet#####'+ opsIdSet);    
     return Database.getQueryLocator(query);   
    }
    
   global void execute(Database.BatchableContext bc, List<Mail_Pricing__c> scope){
	//List<Mail_Pricing__c> mpList = [Select id from Mail_Pricing__c where FAF_Data_Loading_Flag__c = true AND FAF_Mail_Operations__c IN : scope];
	// find the right sequence for mail princing with new lobs
	System.debug('@@@@@@@@@ '+ scope); 
    System.debug('@@@@@@@@@ '+ mapOfLobToSequence); 
    List<Mail_Sequence_Setting__c> newSeqToInsert = new List<Mail_Sequence_Setting__c>();    
    for(Mail_Pricing__c mp : scope){
        string key = mp.LOB__c + mp.FAF_ID__r.name + mp.Agreement_Line_Item__r.name + mp.FAF_Mail_Operations__r.name;
        if(mapOfOpsToHighest.containsKey(mp.FAF_Mail_Operations__r.name)){
            if(mapOfLobToSequence.containsKey(key)){
				mp.Sequence_Number__c = mapOfLobToSequence.get(key);                
            }else{
                mp.Sequence_Number__c = mapOfOpsToHighest.get(mp.FAF_Mail_Operations__r.name)+1;
                mapOfLobToSequence.put(key, Integer.valueOf(mp.Sequence_Number__c));
                mapOfOpsToHighest.put(mp.FAF_Mail_Operations__r.name, Integer.valueOf(mp.Sequence_Number__c));
                newSeqToInsert.add(new Mail_Sequence_Setting__c(LOB__c=mp.LOB__c, Agreement_Line_Item_ID__c=mp.Agreement_Line_Item__r.name, FAF_ID__c=mp.FAF_ID__r.name, Sequence_Number__c=mp.Sequence_Number__c, Mail_Operation_ID__c=mp.FAF_Mail_Operations__r.name));
            }
            continue;
        }
        if(mapOfLobToSequence.containskey(key)){
            mp.Sequence_Number__c = mapOfLobToSequence.get(key);
        }
    }
    update scope; 
    insert newSeqToInsert;   
   }
   global void Finish(Database.BatchableContext bc){
                  
   }
}