public class DeleteMailPricingSequence {
    @invocableMethod
    Public Static void deleteSequence(List<String> OpId){
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<String> mailOpNames = new Set<String>();
        Set<String> mailOpNamesDeleted = new Set<String>();
        Set<String> setKeys = new Set<String>();
        Set<String> deletedOps = new Set<String>();
        List<Mail_Pricing__c> updateSeq = new List<Mail_Pricing__c>();
        List<Mail_Sequence_Setting__c> lstSeqToBeDeleted = new List<Mail_Sequence_Setting__c>();
        List<Mail_Sequence_Setting__c> lstSeqToBeCareated = new List<Mail_Sequence_Setting__c>();
        Map<String, Integer> mapOfLobToSequence = new Map<String, Integer>();
    
        // delete the sequence for the deleted ops
        List<Mail_Sequence_Setting__c> lstOfAllSequenceDeletedOps = [Select id, Agreement_Line_Item_ID__c, LOB__c, FAF_ID__c, Sequence_Number__c, Mail_Operation_ID__c from Mail_Sequence_Setting__c where Mail_Operation_ID__c IN : OpId];
        if(lstOfAllSequenceDeletedOps.size()>0){
            delete lstOfAllSequenceDeletedOps;
        }      
        
            // logic to reorder the pricing
            for(Mail_Operations__c eachOPs : [select id, name, (select id, Sequence_Number__c, LOB__c ,FAF_ID__r.name, FAF_Mail_Operations__r.name, Agreement_Line_Item__r.name 
                                                                from FAF_Mail_Pricing__r where Sequence_Number__c != null order by Sequence_Number__c) from Mail_Operations__c where name IN : OpId]){
                Integer expectedSeq = 1;
                Set<String> lobs = new Set<String>();
                Integer prevSeq = 1;                                                    
                for(Mail_Pricing__c eachPrice : eachOPs.FAF_Mail_Pricing__r){
                    if(!lobs.contains(eachPrice.LOB__c)){
                        lobs.add(eachPrice.LOB__c);
                        prevSeq = expectedSeq;
                        lstSeqToBeCareated.add(new Mail_Sequence_Setting__c(Agreement_Line_Item_ID__c = eachPrice.Agreement_Line_Item__r.name , LOB__c = eachPrice.LOB__c, 
                                                                                FAF_ID__c = eachPrice.FAF_ID__r.name, Mail_Operation_ID__c = eachPrice.FAF_Mail_Operations__r.name,
                                                                                 Sequence_Number__c = expectedSeq)); 
                        if(eachPrice.Sequence_Number__c == expectedSeq){
                            expectedSeq++;
                            continue;
                        }
                        eachPrice.Sequence_Number__c = expectedSeq++;
                        updateSeq.add(eachPrice);
                    }else{
                        eachPrice.Sequence_Number__c = prevSeq;
                        updateSeq.add(eachPrice);
                    }
                }
            }
            // update pricing
            update updateSeq; 
           // after mail pricing order change, reorder the corresponding sequence for mail sequence setting records
            insert lstSeqToBeCareated;
            
    }

}