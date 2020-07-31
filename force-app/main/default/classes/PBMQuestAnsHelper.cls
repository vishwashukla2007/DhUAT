public without sharing class PBMQuestAnsHelper {
    public static void updateObjects(list<PBM_Questions_Answers__c> pbmAnsQuestList){
        
        Apttus__APTS_Agreement__c updateAgreement = [SELECT id, Apttus__Account__c, Apttus__Contract_Start_Date__c, 
                                                     Apttus__Contract_End_Date__c, PBM_FAF__c
                                                FROM Apttus__APTS_Agreement__c 
                                                WHERE id = :pbmAnsQuestList[0].Agreement__c];
        
        PBS_Agreement_Extension__c updateExt = [SELECT id, Client_Name__c,Client_Share__c,CVS_Share__c, Pharmacy_Audit_Retention__c
                                                FROM PBS_Agreement_Extension__c 
                                                WHERE Agreement__c = :pbmAnsQuestList[0].Agreement__c];
        
        Map<ID, PBM_Questions__c> quest_map = new Map<ID, PBM_Questions__c>([SELECT Id, Field_API__c, Data_Type__c, Object_API__c FROM PBM_Questions__c]);
        Map<ID, Account> account_map = new Map<ID, Account>([SELECT Id, Name FROM Account WHERE id =:updateAgreement.Apttus__Account__c]);
        
        for(PBM_Questions_Answers__c updateEx : pbmAnsQuestList){
            if(updateEx.Answer__c != 'null' && updateEx.Answer__c != null){
                if(updateEx.Field_API__c != 'Contract_Effective_Date__c' && updateEx.Field_API__c != 'Contract_End_Date__c' && updateEx.Field_API__c != 'Master_Client_Name__c'){
                    //Update Agreement Extension Object
                    if(updateEx.Field_API__c == 'Pharmacy_Audit_Retention__c'){
                        if(updateEx.Answer__c == 'Base (80/20)'){
                            updateExt.put('Client_Share__c',80); 
                            updateExt.put('CVS_Share__c',20);                    
                        }else if(updateEx.Answer__c == 'Base (100/0)'){
                            updateExt.put('Client_Share__c',100); 
                            updateExt.put('CVS_Share__c',0); 
                        }else if(updateEx.Answer__c == 'Premier (75/25)'){
                            updateExt.put('Client_Share__c',75); 
                            updateExt.put('CVS_Share__c',20); 
                        }
                    }else if(updateEx.Field_API__c == 'Client_Share__c'){
                    	integer cvsShare = (100 - integer.valueOf(updateEx.Answer__c));
                        updateExt.put('CVS_Share__c',cvsShare); 
                    }
                    
                    if(quest_map.get(updateEx.PBM_Question__c).Data_Type__c == 'Number'){
                        updateExt.put(quest_map.get(updateEx.PBM_Question__c).Field_API__c,decimal.valueOf(updateEx.Answer__c));
                    }else{
                        updateExt.put(quest_map.get(updateEx.PBM_Question__c).Field_API__c,string.valueOf(updateEx.Answer__c)); 
                    }    
                    
                }else{
                    //Update Agreement Object
                    if(updateEx.Field_API__c == 'Contract_Effective_Date__c'){
                        updateAgreement.put('Apttus__Contract_Start_Date__c', date.valueOf(updateEx.Answer__c) );
                    }else if(updateEx.Field_API__c == 'Contract_End_Date__c'){
                        updateAgreement.put('Apttus__Contract_End_Date__c', date.valueOf(updateEx.Answer__c));
                    }
                }
            }
        }
        if(updateExt!=null){
           update updateExt; 
        }
        if(updateAgreement != null){
        	update updateAgreement;    
        }
        
        
        map<id, PBM_Questions_Answers__c> clientInfo_map = new map<id, PBM_Questions_Answers__c>();
        for(PBM_Questions_Answers__c eachQuestion : pbmAnsQuestList){
            if(quest_map.get(eachQuestion.PBM_Question__c).Object_API__c == 'Client_Information__c'){
                clientInfo_map.put(eachQuestion.PBM_Question__c, eachQuestion);
            }
        }
        
      
    }
}