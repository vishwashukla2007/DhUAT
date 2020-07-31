global without sharing class updateFAFAgreement {
	@InvocableMethod
    //Parameter: FAFId + '-' + AgreementId
    public static void updateFAFAgree(list<list<string>> FAFId_AgreementId) {
        
        //Extract collectionFields
        list<string> processInput = new list<string>();
        processInput = FAFId_AgreementId[0];
        
        //get id's
        string FAFId = null;
        string agreementId = null;
        
        for(string eachInput : processInput){
            List<String> res = eachInput.split('-', 2);
            if(res[0] != null){
                FAFId = res[0];
            }
            if(res[1] != null){
                agreementId = res[1];
            }
        }
        if(FAFId != null && agreementId != null){
			Central_Hub__c updtFAF = [SELECT id, SFS_Agreement__c, Master_Agreement__c FROM Central_Hub__c
                                                   WHERE id =: FAFId];
            updtFAF.Master_Agreement__c = agreementId;
            update updtFAF;            
             
        //Commented out the method due to SFS not being moved to production for jun 4 deployment - JP Revilla 25/05/202
            if(updtFAF != null){
                if(updtFAF.SFS_Agreement__c != null){
                	Apttus__APTS_Agreement__c sfsAgreement = [Select id, Apttus__Parent_Agreement__c from Apttus__APTS_Agreement__c where id =: updtFAF.SFS_Agreement__c Limit 1];
                    if(sfsAgreement != null){
                    	sfsAgreement.Apttus__Parent_Agreement__c = agreementId;
            			update sfsAgreement;    
                    }
                }
            }
            
        } 
    }
}