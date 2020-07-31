public class TransactionFeeSharingController {
    public Transaction_Fee_Sharing_Tier__c TransactionFee{get;set;}
    public Network_Operations__c nOperations{get;set;}
    public boolean hasDefaultErrors{get;set;}
    public Id transactionId{get;set;}
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    public TransactionFeeSharingController(ApexPages.StandardController controller){
        operationType=ApexPages.currentPage().getParameters().get('type');
        TransactionFee = new Transaction_Fee_Sharing_Tier__c();
        nOperations = new Network_Operations__c();
        transactionId = ApexPages.currentPage().getParameters().get('id');
        TransactionFee = (Transaction_Fee_Sharing_Tier__c)controller.getRecord();
        List<Transaction_Fee_Sharing_Tier__c> existingTransactionFee = [Select Id,From__c,To__c from Transaction_Fee_Sharing_Tier__c Where Network_Operations__c =: TransactionFee.Network_Operations__c ORDER By CreatedDate DESC];
        if((TransactionFee.Tier__c == null || TransactionFee.Id == null)||(operationType=='clone' && operationType!=null)){
            TransactionFee.Tier__c = existingTransactionFee.size() + 1;
        }
        
        List<Network_Operations__c> nOperations = [SELECT Id, FAF_ID__c,client__c,type__c,Transaction_Fee_Sharing__c FROM Network_Operations__c WHERE Id = : TransactionFee.Network_Operations__c];           
        if(TransactionFee.FAF_ID__c == null ){
            if(!nOperations.isempty()){
                TransactionFee.FAF_ID__c = nOperations[0].FAF_ID__c; 
            }
        }
        if(!nOperations.isempty()){
            if(nOperations[0].type__c == 'Not Tiered' || nOperations[0].Transaction_Fee_Sharing__c != 'Yes'){
                hasDefaultErrors = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaction Fee Sharing Tiers are only allowed when Transaction Fee Sharing Type (on Network Operation) is selected as Tiered.');
                ApexPages.addMessage(myMsg);
            }
            else{
                if(existingTransactionFee.size() == 9 && (TransactionFee.Id == null|| (operationType=='clone' && operationType!=null))){
                    hasDefaultErrors = true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A maximum of Nine records are allowed for the Transaction Fee Sharing Tier.');
                    ApexPages.addMessage(myMsg);
                }
                else if(existingTransactionFee.size() > 0){
                    for(Integer i=0; i<existingTransactionFee.size(); i++){
                        if(existingTransactionFee[i].To__c == null && TransactionFee.Id == null){
                            hasDefaultErrors = true;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Transaction Fee Sharing Tier To value for the existing tier needs to be populated before adding a new tier record.');
                            ApexPages.addMessage(myMsg);
                            break;
                        }
                    }
                }
            }
        }
        
        system.debug('the transaction fee are' + TransactionFee.FAF_ID__c);
    }
    
    public pagereference saveTransactionFeeSharing(){
        boolean hasNoErrors = true;
        List<Network_Operations__c> nOperations = [SELECT Id, FAF_ID__c, client__c, type__c FROM Network_Operations__c WHERE Id = : TransactionFee.Network_Operations__c];           
        List<Transaction_Fee_Sharing_Tier__c> existingTransactionFee = [Select Id,From__c,To__c,Tier__c from Transaction_Fee_Sharing_Tier__c Where Network_Operations__c =: TransactionFee.Network_Operations__c ORDER By Tier__c ASC];
        Map<Integer, Transaction_Fee_Sharing_Tier__c> existingTransactionFeeMap = new Map<Integer, Transaction_Fee_Sharing_Tier__c>();
        for(Transaction_Fee_Sharing_Tier__c existingTransactionFeeRec : existingTransactionFee){
            existingTransactionFeeMap.put(Integer.valueOf(existingTransactionFeeRec.Tier__c), existingTransactionFeeRec);
        }
         try{
           if(TransactionFee.id == null ||(operationType=='clone' && operationType!=null)){
                if(!(TransactionFee.To__c > TransactionFee.From__c) && TransactionFee.To__c != null){
                    hasNoErrors = false;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Transaction Fee Sharing Tier To value must be greater than the Transaction Fee Sharing Tier From value or it can be blank.');
                    ApexPages.addMessage(myMsg);
                }
                 //if(TransactionFee.To__c != null){
                //   System.debug('==='+existingTransactionFee[existingTransactionFee.size() - 1].To__c);
               //    System.debug('==='+TransactionFee.From__c);
                if(!existingTransactionFee.isEmpty() && existingTransactionFee[existingTransactionFee.size() - 1].To__c != TransactionFee.From__c - 1 
                   && ( TransactionFee.To__c > existingTransactionFee[existingTransactionFee.size() - 1].From__c || TransactionFee.From__c > existingTransactionFee[existingTransactionFee.size() - 1].From__c ) ){
                        hasNoErrors = false;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There shall not be any overlap or gap between From and To value spans between two consecutive tiers.');
                        ApexPages.addMessage(myMsg);
                     } 
                if(!existingTransactionFee.isEmpty() && existingTransactionFee[existingTransactionFee.size() - 1].From__c >= TransactionFee.From__c){
                    hasNoErrors = false;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                    ApexPages.addMessage(myMsg);
                }
                if(!existingTransactionFee.isEmpty() && existingTransactionFee[existingTransactionFee.size() - 1].To__c >= TransactionFee.To__c){
                    hasNoErrors = false;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                    ApexPages.addMessage(myMsg);
                 }
                if(hasNoErrors){
                        if(operationType==CLONE){
                        
                        SObject cloneSObj;
                        cloneSObj=CustomCloneUtility.customCloneMethod(TransactionFee);
                       
                        insert cloneSObj;
                        pagereference pf = new pagereference('/' +cloneSObj.id);
                        pf.setredirect(true);
                        return pf;
                        
                    }
                    else{
                        insert TransactionFee; 
                        pagereference pf = new pagereference('/' + TransactionFee.Id);
                        pf.setredirect(true);
                        return pf;
                    }
                }
            }
            else{
                
                if(TransactionFee.Tier__c != null){
                    boolean hasNoIncreasingOrderError = true;
                    if(!existingTransactionFee.isEmpty()){
                        if(existingTransactionFee[0].Tier__c != TransactionFee.Tier__c){
                            if(existingTransactionFee[0].To__c >= TransactionFee.To__c || 
                            existingTransactionFee[0].From__c >= TransactionFee.From__c){ //|| 
                            //existingTransactionFee[0].To__c >= TransactionFee.From__c ){
                                hasNoErrors = false;
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Transaction Fee Sharing Tier From and To values for each tier needs to be populated in increasing order.');
                                ApexPages.addMessage(myMsg);
                                if(existingTransactionFee[0].To__c >= TransactionFee.To__c && existingTransactionFee[0].From__c >= TransactionFee.From__c){
                                    hasNoIncreasingOrderError = false;
                                }
                            }
                        }
                    }
                    if(hasNoIncreasingOrderError){
                         if(existingTransactionFeeMap.get(Integer.valueOf(TransactionFee.Tier__c) - 1) != null){
                            if(TransactionFee.From__c != existingTransactionFeeMap.get(Integer.valueOf(TransactionFee.Tier__c) - 1).To__c + 1){
                                hasNoErrors = false;
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There shall not be any overlap or gap between From and To value spans between two consecutive tiers.');
                                ApexPages.addMessage(myMsg);
                            }
                        }
                        if(existingTransactionFeeMap.get(Integer.valueOf(TransactionFee.Tier__c) + 1) != null && TransactionFee.To__c != null){
                            if(TransactionFee.To__c != existingTransactionFeeMap.get(Integer.valueOf(TransactionFee.Tier__c) + 1).From__c - 1){
                                hasNoErrors = false;
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There shall not be any overlap or gap between From and To value spans between two consecutive tiers.');
                                ApexPages.addMessage(myMsg);
                            }
                        }
                        if(!(TransactionFee.To__c > TransactionFee.From__c) && TransactionFee.Tier__c != existingTransactionFee.size()  && TransactionFee.To__c != null){
                            hasNoErrors = false;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Transaction Fee Sharing Tier To value must be greater than the From');
                            ApexPages.addMessage(myMsg);
                        }
                        
                        if(TransactionFee.Tier__c != existingTransactionFee.size() && TransactionFee.To__c == null){
                            hasNoErrors = false;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Transaction Fee Sharing Tier To value must be populated.');
                            ApexPages.addMessage(myMsg);
                        }
                       //  if(!(TransactionFee.To__c > TransactionFee.From__c) && TransactionFee.To__c != null){
                        if(TransactionFee.Tier__c == existingTransactionFee.size() && 
                        (!(TransactionFee.To__c > TransactionFee.From__c) && TransactionFee.To__c != null)){
                            hasNoErrors = false;
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Transaction Fee Sharing Tier To value must be greater than the Transaction Fee Sharing Tier From value or it can be blank.');
                            ApexPages.addMessage(myMsg);
                        }
                    }
                }
                 for(Integer i=0; i<existingTransactionFee.size(); i++){
                }
                if(hasNoErrors){
                    upsert TransactionFee;
                    pagereference pf = new pagereference('/' + TransactionFee.Id);
                    pf.setredirect(true);
                    return pf;
                }
            }
        }
        catch(Exception exp){
         String errorMessage = exp.getMessage(); 
           Integer occurence; 
           if (exp.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){ 
              occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34; 
              errorMessage = errorMessage.mid(occurence, errorMessage.length()); 
              occurence = errorMessage.lastIndexOf(':'); 
              errorMessage = errorMessage.mid(0, occurence); 
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage); 
              ApexPages.addMessage(myMsg);
             }
        }
        return null;
    }
}