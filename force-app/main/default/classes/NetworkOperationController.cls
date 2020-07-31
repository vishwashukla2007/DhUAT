public class NetworkOperationController {
    ApexPages.StandardController con;
    public Network_Operations__c networkOperations{get;set;}
    //public string FAFID{get;set;}
    //Public Boolean DaysSupplyValue{get;set;}
   // public string Type{get;set;}
    public boolean hasExistingNetworkOperations{get;set;}
    Network_Operations__c NO = new Network_Operations__c();
    public Boolean hasExisitingNP{get;set;}
    public Boolean hasExisitingTrans{get;set;}
    public string defaultNetworkType {get;set;}
    
    public NetworkOperationController(ApexPages.StandardController controller){
        networkOperations = new Network_Operations__c();
        networkOperations = (Network_Operations__c)controller.getRecord();
        system.debug('the networkOperations are' + networkOperations.FAF_ID__c);
        defaultNetworkType = networkOperations.Type__c;
        if(networkOperations.FAF_ID__c != null && networkOperations.Id == null){
            List<Network_Operations__c> existingNetWorkOperations = [Select Id,client__c from Network_Operations__c Where FAF_ID__c =: networkOperations.FAF_ID__c];
            if(!existingNetWorkOperations.isEmpty()){
                hasExistingNetworkOperations = true;
            }
            else{
                hasExistingNetworkOperations = false;
            }
        }
        hasExisitingNP = false;
        if(controller.getId()!=null) { 
            List<Network_Pricing__c> npList = [SELECT Id FROM Network_Pricing__c WHERE FAF_Network_Ops__c=:controller.getId()];
            if(!npList.isEmpty()) {
                hasExisitingNP = true;
            }
        }
       hasExisitingTrans = false;
        if(controller.getId()!=null) { 
            List<Transaction_Fee_Sharing_Tier__c> TransList = [SELECT Id FROM Transaction_Fee_Sharing_Tier__c WHERE Network_Operations__c=:controller.getId()];
            if(!TransList.isEmpty()) {
                hasExisitingTrans = true;
            }
        }
        if(networkOperations.Retail_90_Days_Supply_84__c){
            retailsDaysRequired = true;
        }
        else{
            networkOperations.Days_Supply__c = null;
            retailsDaysRequired = false;
        } 
        if(networkOperations.type__c == 'not tiered'){
            enbleClientShare = true;
        }
        else{
            enbleClientShare = false;
            //networkOperations.type__c = null;
            networkOperations.Client_Share__c = null;
        }
        TSRMSF_Fee_Waived = false;
        Transmission_Fee_Waived = false;
        transmissionFee();
    }
    public boolean TSRMSF_Fee_Waived{get;set;}
    public boolean Transmission_Fee_Waived{get;set;}
    public void transmissionFee(){
        Central_Hub__c fafRecord = [Select id, LOB2__c from Central_Hub__c where Id=: networkOperations.FAF_ID__c limit 1];
        set<string> transmissionFeeWalved = new set<string>{'ACT', 'CAP', 'CC', 'CDH', 'CON', 'EXCH', 'FLU', 'MIP', 'MSB', 'PR', 'RET', 'RU', 'SRx', 'STD', 'WC', 'WRAP', 'MEDI'};
        set<string> transmissionNetwork = new set<string>{'EGFI', 'EGWP', 'MAPD', 'MMP', 'PDP', 'SUBS'};
      if(fafRecord.LOB2__c == null){
        TSRMSF_Fee_Waived = true;
        Transmission_Fee_Waived = true;
      }
        if(transmissionFeeWalved.contains(fafRecord.LOB2__c))
           TSRMSF_Fee_Waived = true;
        if(transmissionNetwork.contains(fafRecord.LOB2__c))
            
             Transmission_Fee_Waived = true;
        
    }
   
    public boolean retailsDaysRequired {get;set;}
    public void retailSelected(){
        if(networkOperations.Retail_90_Days_Supply_84__c){
            retailsDaysRequired = true;
        }
        else{
            networkOperations.Days_Supply__c = null;
            retailsDaysRequired = false;
        }
    } 
    
    public boolean enbleClientShare{get;set;}
    public string NetWorkType{get;set;}
    
    public void transactionFeeTypeNotTieredSelected(){
        System.debug('********************************'+NetWorkType);
        if(NetWorkType == 'Not Tiered')
            enbleClientShare = true;
        else{
            enbleClientShare = false;
            networkOperations.Client_Share__c = null;
        }       
    }
   
    public void transactionFeeTypeNotTieredNotSelected(){
        enbleClientShare = false;
        networkOperations.type__c = null;
        networkOperations.Client_Share__c = null;
    }
    
    public void transactionFeeTypeNotTieredNotSelected1(){
      //  if(!networkOperations.Transaction_Fee_Sharing__c.equals('Yes')){
      if((networkOperations.Transaction_Fee_Sharing__c == 'No') || (networkOperations.Transaction_Fee_Sharing__c == null) ){
            enbleClientShare = false;
            networkOperations.type__c = null;
            networkOperations.Client_Share__c = null;
        }
        //enbleClientShare = false;
        //networkOperations.type__c = null;
        //networkOperations.Client_Share__c = null;
    }
    
    /**public void transactionShareFeeUpdated(){
        enbleClientShare = false;
        networkOperations.Client_Share__c = null;
        networkOperations.type__c = null;
    }**/
    
    public pagereference saveNetworkOperations(){
        try{
          if(networkOperations.Method__c == null){
                networkOperations.Time_Frame__c =null;
                networkOperations.Level__c =null;
            }
            FAFTriggerHelper.validateFAFStatusCheck = false;
            upsert networkOperations;
            if(networkOperations.type__c == 'not tiered' || networkOperations.Transaction_Fee_Sharing__c == 'No'){
                List<Transaction_Fee_Sharing_Tier__c> transactionsToDelete = [Select Id,Deleting_From_Network_Operations__c from Transaction_Fee_Sharing_Tier__c Where Network_Operations__c =: networkOperations.Id];
                if(!transactionsToDelete.isEmpty()){
                    for(Transaction_Fee_Sharing_Tier__c transFeeRec : transactionsToDelete){
                        transFeeRec.Deleting_From_Network_Operations__c = true;
                    }
                    update transactionsToDelete;
                    delete transactionsToDelete;
                } 
            }
       /* //08.09.18   
       if( networkOperations.Method__c <> null && networkOperations.Time_Frame__c == null )
           {
               networkOperations.Time_Frame__c.addError('You must enter a value');
               return null;
           }
           
           if( networkOperations.Time_Frame__c <> null && networkOperations.Level__c == null )
           {
               networkOperations.Level__c.addError('Required field missing');
               return null;
           } */
            pagereference pf = new pagereference('/' + networkOperations.Id); 
            pf.setRedirect(true);
            return pf;
        }
        catch(Exception exp){
           String errorMessage = exp.getMessage(); 
           Integer occurence; 
          /* if (exp.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){ 
              
              occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34; 
              errorMessage = errorMessage.mid(occurence, errorMessage.length()); 
              occurence = errorMessage.lastIndexOf(':'); 
              errorMessage = errorMessage.mid(0, occurence); 
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage); 
               System.debug('Testing Validation'+myMsg);
             // ApexPages.addMessage(myMsg);
             }*/
    }
        return null;
    }
    
    public void deleteTransactionFee(){
  
        List<Transaction_Fee_Sharing_Tier__c> transactionsToDelete = [Select Id from Transaction_Fee_Sharing_Tier__c Where Network_Operations__c =: networkOperations.Id];
        if(!transactionsToDelete.isEmpty() && networkOperations.type__c == 'not tiered'){
            delete transactionsToDelete;
      
        }      
    }
    
  /*  public void DaysSupplyAction(){    
        if(DaysSupplyValue == false){
            networkOperations.Transaction_Fee_Sharing__c = null;
        }   
        } */
  }