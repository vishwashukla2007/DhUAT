global without sharing class updateAgreementAccount {
	@InvocableMethod
    //Parameter: AgreementId + '-' + AccountId
    public static void updateAgreeAcct(list<list<string>> Agreement_Account_id) {
        /*
        //Extract collectionFields
        list<string> processInput = new list<string>();
        processInput = Agreement_Account_id[0];
        
        //get id's
        string agreementId = null;
        string accountId = null;
        for(string eachInput : processInput){
            List<String> res = eachInput.split('-', 2);
            if(res[0] != null){
                agreementId = res[0];
            }
            if(res[1] != null){
                accountId = res[1];
            }
        }
        
        Apttus__APTS_Agreement__c updtAgreement = [SELECT id, Apttus__Account__c, Apttus__Contract_Start_Date__c FROM Apttus__APTS_Agreement__c
                                                   WHERE id =: agreementId];
        
        
        if(accountId != null && accountId != ''){
            account getAcct = [SELECT id, Name FROM account WHERE id =:accountId];
            if(getAcct!= null){
                //updtAgreement.Name = 'PBM-' + getAcct.Name + '-' + string.valueof(system.today());
                //String dateOutput = updtAgreement.Apttus__Contract_Start_Date__c.format('dd-MM-yyyy');
                string dateOutput = DateTime.newInstance(updtAgreement.Apttus__Contract_Start_Date__c.year(), updtAgreement.Apttus__Contract_Start_Date__c.month(), updtAgreement.Apttus__Contract_Start_Date__c.day()).format('MM-dd-yy');
                string acctname = getAcct.Name.toUpperCase();
                if(acctname.length() > 20){
                    acctname = getAcct.Name.substring(0,20).toUpperCase();
                }
                updtAgreement.Name = acctname  + '-' + 'PBSA' + '-' + 'FULL' + '-(' + dateOutput + ')';
                updtAgreement.Apttus__Account__c = getAcct.Id;
            } else{
                //updtAgreement.Name = 'PBM-' + string.valueof(system.today());
            }
        }else{
            //updtAgreement.Name = 'PBM-' + string.valueof(system.today());
        }
        
        update updtAgreement;    
        
        */
    }
}