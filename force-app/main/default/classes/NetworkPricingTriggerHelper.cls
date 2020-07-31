public with sharing class NetworkPricingTriggerHelper {

    public static void validateNoOfRecords(List<Network_Pricing__c> NetworkPricingList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            if(isInsertBool){            
            FAFTriggerHelper.validateFAFStatusCheck = false;
            }
            Set<Id> networkOpsIdSet = new Set<Id>();
            Set<String> yearSet = new Set<String>();
            Map<String, Set<Id>> parentChildMap = new Map<String, Set<Id>>();

            
            for(Network_Pricing__c np: NetworkPricingList) {
                networkOpsIdSet.add(np.FAF_Network_Ops__c);    
                yearSet.add(np.Year__c);
            }
            
            List<Network_Pricing__c> npList = [SELECT Id, Year__c, FAF_Network_Ops__c, Retail_Network_Ordinal__c, Custom_Network_Description__c FROM Network_Pricing__c WHERE FAF_Network_Ops__c IN:networkOpsIdSet AND Year__c IN:yearSet AND Retail_Network_Ordinal__c='Primary' AND Network_Name__c!='Client Owned'];
            if(!npList.isEmpty()){
                for(Network_Pricing__c np:npList){
                    Set<Id> npSet;
                    String concatinateStr = np.FAF_Network_Ops__c+'-'+np.Year__c+'-'+np.Retail_Network_Ordinal__c;
                    if(parentChildMap.containsKey(concatinateStr)) {
                        npSet = parentChildMap.get(concatinateStr);
                    } else {
                        npSet = new Set<Id>();
                    }
                    npSet.add(np.Id);
                    parentChildMap.put(concatinateStr, npSet);
                }
            }
            
            for(Network_Pricing__c np: NetworkPricingList) {
                Set<Id> npSet = parentChildMap.get(np.FAF_Network_Ops__c+'-'+np.Year__c+'-'+np.Retail_Network_Ordinal__c); 
                if(npSet!=null && np.Network_Name__c!='Client Owned')  {  
                    if(isInsertBool && !npSet.isEmpty()) {
                        np.addError('Only one Primary Retail Network is permitted for a given pricing year.');
                    }                
                    if(isUpdateBool && !npSet.isEmpty() && !npSet.contains(np.Id) && np.Network_Name__c!='Client Owned'  ) {
                        np.addError('Only one Primary Retail Network is permitted for a given pricing year.');
                    }
                }
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }


    public static void validateLobYearName(List<Network_Pricing__c> NetworkPricingList, Boolean isInsertBool, Boolean isUpdateBool) {
       try{
            Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>();
            Map<string, MAP<string, Id>> NetworkPricingRelatedMap = new Map<string, MAP<string, Id>>();
            Map<string, Id> tempMap;
            set<Id> NetworkOpsIdSet = new set<Id>(); 
            set<string> concatinateStr = new set<string>(); 
            Set<Id>NetworkOprIdSet = new Set<Id>(); 
            String str;
            String str1;
             for(Network_Pricing__c NetworkPric: NetworkPricingList){
            NetworkOprIdSet.add(NetworkPric.FAF_Network_Ops__c);
        }
            //Iterate over all Rebate Guarantee which are present in the NetworkPricingList
            for(Network_Pricing__c NetworkPric: [select id, FAF_Network_Ops__c, Year__c, LOB__c,  Network_Name__c,  Custom_Network_Description__c from Network_Pricing__c
            where FAF_Network_Ops__c in: NetworkOprIdSet AND Network_Name__c!='Client Owned']){
                tempMap = new Map<string,Id>();
                concatinateStr = new set<string>();
                if(NetworkOpsIdSet.size()>0){
                    if(NetworkOpsIdSet.contains(NetworkPric.FAF_Network_Ops__c)){
                        concatinateStr.addall(parentChildMap.get(NetworkPric.FAF_Network_Ops__c));
                        concatinateStr.add(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c +  NetworkPric.Custom_Network_Description__c);
                        parentChildMap.put(NetworkPric.FAF_Network_Ops__c, concatinateStr);
                        tempMap.put(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c, NetworkPric.Id);
                        str = string.valueOf(NetworkPric.FAF_Network_Ops__c)+string.valueOf(NetworkPric.Id);
                        NetworkPricingRelatedMap.put(str,tempMap);
                    }else{
                        concatinateStr.add(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c);
                        NetworkOpsIdSet.add(NetworkPric.FAF_Network_Ops__c);
                        parentChildMap.put(NetworkPric.FAF_Network_Ops__c, concatinateStr);
                        tempMap.put(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c, NetworkPric.Id);
                        str = string.valueOf(NetworkPric.FAF_Network_Ops__c)+string.valueOf(NetworkPric.Id);
                        NetworkPricingRelatedMap.put(str,tempMap);
                    }
                }else{ //This condition will execute first time the loop will execute
                    concatinateStr.add(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c);
                    NetworkOpsIdSet.add(NetworkPric.FAF_Network_Ops__c);
                    parentChildMap.put(NetworkPric.FAF_Network_Ops__c, concatinateStr);
                    tempMap.put(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c, NetworkPric.Id);
                    str = string.valueOf(NetworkPric.FAF_Network_Ops__c)+string.valueOf(NetworkPric.Id);
                    NetworkPricingRelatedMap.put(str,tempMap);
                }
            }
            if(isUpdateBool){ //Value to check it is insert case or Update
                for(Network_Pricing__c NetworkPric: NetworkPricingList){
                    if(NetworkOpsIdSet.contains(NetworkPric.FAF_Network_Ops__c)){
                        if(parentChildMap.get(NetworkPric.FAF_Network_Ops__c).contains(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c)){
                            str1 = NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c;
                            str = string.valueOf(NetworkPric.FAF_Network_Ops__c)+string.valueOf(NetworkPric.Id);
                            if(NetworkPricingRelatedMap.get(str).get(str1) != NetworkPric.id ) 
                            {
                                if(NetworkPric.Network_Name__c=='Custom Secondary'|| NetworkPric.Network_Name__c=='Custom'){
                                    
                                
                                NetworkPric.addError('Retail Network Pricing record already exists for the Year, LOB, Network Name, and Custom Network Description combination. Please create a unique record using the combination.');
                                }
                                else{
                                 NetworkPric.addError('Retail Network Pricing record already exists for the Year, LOB, Network Name combination. Please create a unique record using the combination.');   
                                }
                            }
                        }
                    }     
                }
            }
            if(isInsertBool){ //Value to check it is insert case or Update
                for(Network_Pricing__c NetworkPric: NetworkPricingList){
                    if(NetworkOpsIdSet.contains(NetworkPric.FAF_Network_Ops__c)){
                        if(parentChildMap.get(NetworkPric.FAF_Network_Ops__c).contains(NetworkPric.Year__c + NetworkPric.LOB__c + NetworkPric.Network_Name__c + NetworkPric.Custom_Network_Description__c)){
                            if(NetworkPric.Network_Name__c=='Custom Secondary' || NetworkPric.Network_Name__c=='Custom'){
                            NetworkPric.addError('Retail Network Pricing record already exists for the Year, LOB, Network Name, and Custom Network Description combination. Please create a unique record using the combination.');
                            }
                            else{
                             NetworkPric.addError('Retail Network Pricing record already exists for the Year, LOB, Network Name combination. Please create a unique record using the combination.');   
                            }
                        }
                    }     
                }
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
    }
    /*
         =================================================================================
         * @Method Name       : UpdateNetworkPricing
         * @author            : Mohit Srivastava(Accenture)
         * @created date      : 05/24/2019
         * @Last modified by  : Mohit Srivastava(Accenture)
         * @Purpose           : Populate Rate on Network Gurantee from Network Pricing when update from Internal Template
          ======================================================================================= */
       Public static void ProcessNetworkpricing(Map<Id,Network_Pricing__c > OldMap,Map<Id,Network_Pricing__c> NewMap,List<Network_Pricing__c> NetworkPricingList)
      {
        set<id> ids=new set<id>();
        set<id> Networkids=new set<id>();
        set<id> agreementIds=new set<id>();
        map<id,decimal> mapOfMer=new map<id,decimal>();
        map<id,decimal> mapOfBer=new map<id,decimal>();
        map<id,decimal> mapOfNed=new map<id,decimal>();
        map<id,decimal> mapOfGer=new map<id,decimal>();
        map<id,decimal> mapOfSSG=new map<id,decimal>();
        map<id,String> mapDocumentAct=new map<id,String>();
        List<Network_Pricing__c> Listprice = new List<Network_Pricing__c>();
         for(Network_Pricing__c netPrice: NetworkPricingList){
            agreementIds.add(netPrice.Agreement__c);
            Networkids.add(netPrice.Id);
        }
      List<Network_Pricing__c> NPrice = [Select Id,Batch_Update__c from Network_Pricing__c Where Id IN: Networkids and Batch_Update__c = true];
        for(Network_Pricing__c npricing: NPrice ){
          if (npricing.Batch_Update__c == true)
          {
             npricing.Batch_Update__c = false; // PCD Internal Template change
             Listprice.add(npricing);
          }
        } 
        for(Network_Pricing__c netPrice: NetworkPricingList)
        { 
                
                if(Oldmap.get(netPrice.ID).Invokable_Update__c==Newmap.get(netPrice.ID).Invokable_Update__c){
                    if(Oldmap.get(netPrice.Id).BER_Guarantee_Rate__c!=Newmap.get(netPrice.Id).BER_Guarantee_Rate__c 
                    ||Oldmap.get(netPrice.Id).GER_Guarantee_Rate__c!=Newmap.get(netPrice.Id).GER_Guarantee_Rate__c
                    ||Oldmap.get(netPrice.Id).MER_Guarantee_Rate__c !=Newmap.get(netPrice.Id).MER_Guarantee_Rate__c 
                    ||Oldmap.get(netPrice.Id).NED_Guarantee_Rate__c !=Newmap.get(netPrice.Id).NED_Guarantee_Rate__c
                    ||Oldmap.get(netPrice.Id).SSG_Guarantee_Rate__c !=Newmap.get(netPrice.Id).SSG_Guarantee_Rate__c)
                    { 
                      ids.add(netPrice.id);
                    }
                    if(Oldmap.get(netPrice.Id).BER_Guarantee_Rate__c!=Newmap.get(netPrice.Id).BER_Guarantee_Rate__c)
                    mapOfBer.put(netPrice.id,Newmap.get(netPrice.Id).BER_Guarantee_Rate__c);
                    if(Oldmap.get(netPrice.Id).GER_Guarantee_Rate__c!=Newmap.get(netPrice.Id).GER_Guarantee_Rate__c)
                    mapOfGer.put(netPrice.id,Newmap.get(netPrice.Id).GER_Guarantee_Rate__c);
                    if(Oldmap.get(netPrice.Id).MER_Guarantee_Rate__c !=Newmap.get(netPrice.Id).MER_Guarantee_Rate__c)
                    mapOfMer.put(netPrice.id,Newmap.get(netPrice.Id).MER_Guarantee_Rate__c);
                    if(Oldmap.get(netPrice.Id).NED_Guarantee_Rate__c !=Newmap.get(netPrice.Id).NED_Guarantee_Rate__c)
                    mapOfNed.put(netPrice.id,Newmap.get(netPrice.Id).NED_Guarantee_Rate__c);
                    if(Oldmap.get(netPrice.Id).SSG_Guarantee_Rate__c !=Newmap.get(netPrice.Id).SSG_Guarantee_Rate__c)
                    mapOfSSG.put(netPrice.id,Newmap.get(netPrice.Id).SSG_Guarantee_Rate__c);
            
                   
                }
            
        }
        
        List<Retail_Network_Guarantees__c> guranteeListUpdate=new List<Retail_Network_Guarantees__c>();
        List<Retail_Network_Guarantees__c> guranteeList=[Select ID,Type__c,Rate__c,Network_Pricing__c from Retail_Network_Guarantees__c where Network_Pricing__c IN:ids];
        for(Retail_Network_Guarantees__c guar:guranteeList){
            if(guar.Type__c=='MER' && mapOfMer.get(guar.Network_Pricing__c)!=null){
            guar.Rate__c=mapOfMer.get(guar.Network_Pricing__c);
            }
            if(guar.Type__c=='GER' && mapOfGer.get(guar.Network_Pricing__c)!=null){
            guar.Rate__c=mapOfGer.get(guar.Network_Pricing__c);
            }
            if(guar.Type__c=='BER'&& mapOfBer.get(guar.Network_Pricing__c)!=null ){
            guar.Rate__c=mapOfBer.get(guar.Network_Pricing__c);
            }
            if(guar.Type__c=='NED' && mapOfNed.get(guar.Network_Pricing__c)!=null){
            guar.Rate__c=mapOfNed.get(guar.Network_Pricing__c);
            }
            if(guar.Type__c=='SSG' && mapOfSSG.get(guar.Network_Pricing__c)!=null){
            guar.Rate__c=mapOfSSG.get(guar.Network_Pricing__c);
            }
            guranteeListUpdate.add(guar);
        }
    
        if(!guranteeListUpdate.isEmpty() && guranteeListUpdate != null){
         Database.Update(guranteeListUpdate);
         ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK=false;
        }
    
    
        /*if(!Listprice.isEmpty())
        {
         
         //update Listprice;
         //ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK=false;
        } */
        
    }
    
    /*
    =================================================================================
         * @Method Name       : updateTpaForm
         * @author            : Sonal Sharma(Accenture)
         * @created date      : 
         * @Last modified by  : Sonal Sharma(Accenture)
         * @Purpose           : Populate Maintenance_Choice_Network1__c and X90_Day_Network__c when Network Name is modified.
     ======================================================================================= */
    public static void updateTpaForm(Map<id,Network_Pricing__c> newMap, Map<id,Network_Pricing__c> oldMap, Boolean isInsertBol){
        Set<id> fafIds= new Set<id>();
        map<id,Network_Pricing__c> trMap= new map<id,Network_Pricing__c>();
        map<id,List<TPA_Form__c>> tpaMap= new map<id,List<TPA_Form__c>>(); //map to store id of client info and tpa form
        map<id,TPA_Form__c> tpaIdMap= new map<id,TPA_Form__c>();
        map<id,id> fafTpaMap= new map<id,id>(); // map to store id of faf and tpa form 
        List<Client_Information__c> cInfo =new List<Client_Information__c>();
        List<TPA_Form__c> tpaForm= new List<TPA_Form__c>();
        Set<id> NpfafIds= new Set<id>(); //to store faf ids for which network name is changed to values other than 90 or MC.
        List<Network_Pricing__c> netwrkPr= new List<Network_Pricing__c>();
        List<Client_Information__c> netClientList =new List<Client_Information__c>();
        List<TPA_Form__c> tpaUpdateList= new List<TPA_Form__c>();
        List<TPA_Form__c> tpaFormList= new List<TPA_Form__c>();
        map<id,Network_Pricing__c> npFafMap= new map<id,Network_Pricing__c>();
        Map<id,Network_Pricing__c> networkFAfMap = new Map<id,Network_Pricing__c>();
        Integer count=0;
        
        try{
            for(Network_Pricing__c np: newMap.values()){
                fafIds.add(np.FAF_ID__c);
                if(isInsertBol){
                    //if network pricing is new
                    if(np.Network_Name__c.contains('90') || np.Network_Name__c.startsWith('MC')){
                        trMap.put(np.id,np);
                    }
                }else{
                    //if update on network pricing
                    if(np.Network_Name__c!=oldMap.get(np.id).Network_Name__c){
                        if(np.Network_Name__c.contains('90') || np.Network_Name__c.startsWith('MC')){
                            trMap.put(np.id,np);
                        }else if(oldMap.get(np.id).Network_Name__c.contains('90') ||oldMap.get(np.id).Network_Name__c.startsWith('MC')){
                            //NpfafIds.add(np.FAF_ID__c);
                            count= count+1;
                                                      
                        }
                    }
                }

            }
            if(count>0){
                updateTpaFormOnDelete(oldMap);
            }
            
            //if trMap is not empty. i.e. network name starts with 90 or MC
            if(!trMap.isEmpty()){
                if(fafIds.size()>0){
                    cInfo=[select id,FAF_ID__c from Client_Information__c where FAF_ID__c In: fafIds];
                }
                if(!cInfo.isEmpty()){
                    tpaForm=[select id,Maintenance_Choice_Network1__c, X90_Day_Network__c, Client_Info_ID__c, Client_Info_ID__r.FAF_ID__c from TPA_Form__c where Client_Info_ID__c In: cInfo];
                    if(!tpaForm.isEmpty()){
                        for(TPA_Form__c tpaObj : tpaForm){
                            tpaIdMap.put(tpaObj.id,tpaObj);
                        }
                    }
                
                }
                
                //List<TPA_Form__c> tpalist=new List<TPA_Form__c>();
                for(Network_Pricing__c npObj: trMap.values()){
                        if(npObj.Network_Name__c.startsWith('MC')){
                            //fafTpaMap.get(npObj.FAF_ID__c);
                            for( TPA_Form__c tp:tpaIdMap.values()){
                                if(tp.Client_Info_ID__r.FAF_ID__c ==npObj.FAF_ID__c){
                                    tp.Maintenance_Choice_Network1__c='Yes';
                                    tp.X90_Day_Network__c='No';
                                    tpaUpdateList.add(tp);
                                }
                            
                            }
                            
                        }else if(!npObj.Network_Name__c.startsWith('MC') && (npObj.Network_Name__c.contains('90'))){
                            //for( TPA_Form__c tp:tpaIdMap.get(npObj.FAF_ID__c)){
                            for( TPA_Form__c tp:tpaIdMap.values()){
                                if(tp.Client_Info_ID__r.FAF_ID__c ==npObj.FAF_ID__c){
                                    tp.X90_Day_Network__c='Yes';
                                    tp.Maintenance_Choice_Network1__c='No';
                                    tpaUpdateList.add(tp);
                                }
                            
                            }
                        }
                }
                
                
            }
            if(!tpaUpdateList.isEmpty()){
                database.update(tpaUpdateList);
            }
        }catch(Exception e){
            System.debug('error - '+e.getmessage());
        }
        
    }
    
    public static void updateTpaFormOnDelete(Map<id,Network_Pricing__c> oldMap){
      //  System.debug('inside delete');
        map<id,List<TPA_Form__c>> tpaMap= new map<id,List<TPA_Form__c>>(); //map to store id of client info and tpa form
        Set<id> NpfafIds= new Set<id>(); //to store faf ids for which network name is changed to values other than 90 or MC.
        List<Network_Pricing__c> netwrkPr= new List<Network_Pricing__c>();
        List<Client_Information__c> netClientList =new List<Client_Information__c>();
        List<TPA_Form__c> tpaUpdateList= new List<TPA_Form__c>();
        List<TPA_Form__c> tpaFormList= new List<TPA_Form__c>();
        map<id,Network_Pricing__c> npFafMap= new map<id,Network_Pricing__c>();
        Map<id,Network_Pricing__c> networkFAfMap = new Map<id,Network_Pricing__c>();
        try{
            for(Network_Pricing__c np: oldMap.values()){
            
                if(np.Network_Name__c.contains('90') || np.Network_Name__c.startsWith('MC')){
                    NpfafIds.add(np.FAF_ID__c);
                }
            }
            
            if(NpfafIds.size()>0){
                    
                //network pricing
                netwrkPr=[select id, Network_Name__c, FAF_ID__c from Network_Pricing__c where FAF_ID__c IN: NpfafIds];
                netClientList=[select id,FAF_ID__c from Client_Information__c where FAF_ID__c In: NpfafIds];
                
                tpaFormList=[select id,Maintenance_Choice_Network1__c, X90_Day_Network__c, Client_Info_ID__c, Client_Info_ID__r.FAF_ID__c from TPA_Form__c where Client_Info_ID__c In: netClientList];
                
                if(!tpaFormList.isEmpty()){
                    for(TPA_Form__c tpaObj : tpaFormList){
                        if(tpaMap.containsKey(tpaObj.Client_Info_ID__r.FAF_ID__c) && tpaMap.get(tpaObj.id)!=null){
                                List<TPA_Form__c> tpalist =tpaMap.get(tpaObj.id);
                                tpalist.add(tpaObj);
                                tpaMap.put(tpaObj.Client_Info_ID__r.FAF_ID__c,tpalist);
                            } else{
                                tpaMap.put(tpaObj.Client_Info_ID__r.FAF_ID__c,new list<TPA_Form__c> {tpaObj});
                            }
                    }
                }

                if(!netwrkPr.isEmpty()){
                    for(Network_Pricing__c npObj :netwrkPr){
                        networkFAfMap.put(npObj.id,npObj);
                    }
        
                    //for(Network_Pricing__c npObj: networkFAfMap.values()){
                    for(Network_Pricing__c npObj: networkFAfMap.values()){
                        if(npObj.Network_Name__c.startsWith('MC') || npObj.Network_Name__c.contains('90')){
                            if(!npFafMap.containsKey(npObj.FAF_ID__c)){
                                npFafMap.put(npObj.FAF_ID__c,npObj); //store the faf id and np object only, when the faf id does not exits in the map. 
                                
                            }
                        }
                    }
                }
                if(!tpaFormList.isEmpty()){
                    for(TPA_Form__c tpaObj : tpaFormList){
                        if(!npFafMap.containsKey(tpaObj.Client_Info_ID__r.FAF_ID__c)){ 
                            tpaObj.X90_Day_Network__c='No';
                            tpaObj.Maintenance_Choice_Network1__c='No';
                            tpaUpdateList.add(tpaObj);
                        }
                    }
                }

            }           
            if(tpaUpdateList.size()>0){
                database.update(tpaUpdateList);
            }
        }catch(Exception ex){
            System.debug('exception= '+ ex.getMessage());
        }
    }
    
}