public without sharing class pbmQuestionParentController {
	@AuraEnabled
    public static list<PBM_Questions_Answers__c> getSaveRecord(list<string> pbmQuestAnsString, string fafid ){
        
        list<PBM_Questions_Answers__c> pbmquestAnsList = new list<PBM_Questions_Answers__c>();
        Map<ID, PBM_Questions__c> quest_map = new Map<ID, PBM_Questions__c>([SELECT Id, Field_API__c, Data_Type__c, Object_API__c FROM PBM_Questions__c]);
        
        map<id, string> quest_ans_map = new map<id,string>();
        for(string questres : pbmQuestAnsString){
            List<String> res = questres.split('-', 2);
            if(res[1] != null && res[1] != 'null'){
                PBM_Questions_Answers__c newPBMquestAns = new PBM_Questions_Answers__c();
                newPBMquestAns.PBM_Question__c = res[0];
                newPBMquestAns.Answer__c = res[1];
                newPBMquestAns.Agreement__c = null;
                if(quest_map.size()>0){
                    newPBMquestAns.Field_API__c = quest_map.get(res[0]).Field_API__c;
                }
                quest_ans_map.put(res[0],res[1]);
                pbmquestAnsList.add(newPBMquestAns);    
            }
        }
        if (pbmquestAnsList.size()>0){
            insert pbmquestAnsList;
        }
        list<string> pbmQuesAnsIds = new list<string>();
        if(pbmquestAnsList.size()>0){
            for(PBM_Questions_Answers__c getIds : pbmquestAnsList){
                pbmQuesAnsIds.add(getIds.Id);
            }
        }
        
        if(quest_ans_map.size()> 0){
			Central_Hub__c fafRec = [SELECT id,
                                     (SELECT id FROM Client_Info__r LIMIT 1),
                                     (SELECT id FROM Mail_Ops__r LIMIT 1),
                                     (SELECT id FROM Rebate_Operations__r LIMIT 1),
                                     (SELECT id FROM Guarantee_Info__r LIMIT 1),
                                     (SELECT id FROM FAF_Network_Ops__r LIMIT 1),
                                     (SELECT id FROM Legal__r LIMIT 1),
                                     (SELECT id FROM Specialty_Ops__r LIMIT 1),
                                     (SELECT id FROM Billing_Ops__r LIMIT 1)
                                     FROM Central_Hub__c WHERE id =: fafid];
            
           
            // Update FAF Info
            map<id, string> FAFInfo_map = new map<id, string>();
            for(id questId : quest_ans_map.keyset()){
                if(quest_map.get(questId).Object_API__c == 'Central_Hub__c'){
                    FAFInfo_map.put(questId, quest_ans_map.get(questId));
                }
            }
            if(fafRec != null && FAFInfo_map.size() > 0 ){
                for(id eachQuestion : FAFInfo_map.keyset()){
                    if (quest_map.get(eachQuestion).Data_Type__c == 'Date'){
                        fafRec.put(quest_map.get(eachQuestion).Field_API__c,date.valueOf(FAFInfo_map.get(eachQuestion)));
                    }else{
                        fafRec.put(quest_map.get(eachQuestion).Field_API__c,string.valueOf(FAFInfo_map.get(eachQuestion)));
                    }      
                }
                update fafRec;           
            }
            
            
            
            // Update Client Info
            map<id, string> clientInfo_map = new map<id, string>();
            for(id questId : quest_ans_map.keyset()){
                if(quest_map.get(questId).Object_API__c == 'Client_Information__c'){
                    clientInfo_map.put(questId, quest_ans_map.get(questId));
                }
            }
            if(fafRec.Client_Info__r.size() > 0 && clientInfo_map.size() > 0 ){
                for(id eachQuestion : clientInfo_map.keyset()){
                    if (quest_map.get(eachQuestion).Data_Type__c == 'Date'){
                        fafRec.Client_Info__r[0].put(quest_map.get(eachQuestion).Field_API__c,date.valueOf(clientInfo_map.get(eachQuestion)));
                    }else{
                        fafRec.Client_Info__r[0].put(quest_map.get(eachQuestion).Field_API__c,string.valueOf(clientInfo_map.get(eachQuestion)));
                    }      
                }
                update fafRec.Client_Info__r[0];           
            }
            
            // Update Rebate Operations Info
            map<id, string> rebateOpsInfo_map = new map<id, string>();
            for(id questId : quest_ans_map.keyset()){
                if(quest_map.get(questId).Object_API__c == 'Rebate_Operations__c'){
                    rebateOpsInfo_map.put(questId, quest_ans_map.get(questId));
                }
            }
            if(fafRec.Rebate_Operations__r.size() > 0 && rebateOpsInfo_map.size() > 0 ){
                for(id eachQuestion : rebateOpsInfo_map.keyset()){
                    if (quest_map.get(eachQuestion).Data_Type__c == 'Date'){
                        fafRec.Rebate_Operations__r[0].put(quest_map.get(eachQuestion).Field_API__c,date.valueOf(rebateOpsInfo_map.get(eachQuestion)));
                    }else{
                        fafRec.Rebate_Operations__r[0].put(quest_map.get(eachQuestion).Field_API__c,string.valueOf(rebateOpsInfo_map.get(eachQuestion)));
                    }      
                }
                update fafRec.Rebate_Operations__r[0];           
            }
            
            // Update Billing Operations Info
            map<id, string> billingOpsInfo_map = new map<id, string>();
            for(id questId : quest_ans_map.keyset()){
                if(quest_map.get(questId).Object_API__c == 'Billing_Operations__c'){
                    billingOpsInfo_map.put(questId, quest_ans_map.get(questId));
                }
            }
            if(fafRec.Billing_Ops__r.size() > 0 && billingOpsInfo_map.size() > 0 ){
                for(id eachQuestion : billingOpsInfo_map.keyset()){
                    if (quest_map.get(eachQuestion).Data_Type__c == 'Date'){
                        fafRec.Billing_Ops__r[0].put(quest_map.get(eachQuestion).Field_API__c,date.valueOf(billingOpsInfo_map.get(eachQuestion)));
                    }else if(quest_map.get(eachQuestion).Data_Type__c == 'Number'){
                        fafRec.Billing_Ops__r[0].put(quest_map.get(eachQuestion).Field_API__c,integer.valueOf(billingOpsInfo_map.get(eachQuestion)));
                    }else{
                        fafRec.Billing_Ops__r[0].put(quest_map.get(eachQuestion).Field_API__c,string.valueOf(billingOpsInfo_map.get(eachQuestion)));
                    }
                        
                    if(quest_map.get(eachQuestion).Field_API__c == 'Pharmacy_Audit_Retention__c'){
                        if(billingOpsInfo_map.get(eachQuestion) == 'Base (80/20)'){
                            fafRec.Billing_Ops__r[0].put('Client_Share__c',80); 
                            fafRec.Billing_Ops__r[0].put('CVS_Share__c',20);       
                        }else if(billingOpsInfo_map.get(eachQuestion) == 'Base (100/0)'){
                            fafRec.Billing_Ops__r[0].put('Client_Share__c',100); 
                            fafRec.Billing_Ops__r[0].put('CVS_Share__c',0); 
                        }else if(billingOpsInfo_map.get(eachQuestion) == 'Premier (75/25)'){
                            fafRec.Billing_Ops__r[0].put('Client_Share__c',75); 
                            fafRec.Billing_Ops__r[0].put('CVS_Share__c',25);
                        }
                    }else if(quest_map.get(eachQuestion).Field_API__c == 'Client_Share__c'){
                    	integer cvsShare = (100 - integer.valueOf(billingOpsInfo_map.get(eachQuestion)));
                        fafRec.Billing_Ops__r[0].put('CVS_Share__c',cvsShare); 
                    }
                }
                update fafRec.Billing_Ops__r[0];           
            }
            
            
        }
        
        
        return pbmquestAnsList;
    }
    
}