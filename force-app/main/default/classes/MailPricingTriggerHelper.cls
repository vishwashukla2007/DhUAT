/* ================================================
 * @Trigger Name      : MailPricingTrigger 
 * @author            : Kiran
 * @Purpose           :Helper class of Trigger for LOB Year  Validation
================================================*/ 

public  with sharing class MailPricingTriggerHelper {
  public static void validateNoOfRecords(List<Mail_Pricing__c> MailPricingList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            Set<Id> mailOpsIdSet = new Set<Id>();
            Set<String> yearSet = new Set<String>();
            Map<String, Set<Id>> parentChildMap = new Map<String, Set<Id>>();
            
            for(Mail_Pricing__c mp: MailPricingList) {
                mailOpsIdSet.add(mp.FAF_Mail_Operations__c );    
                yearSet.add(mp.Year__c);
            }
             List<Mail_Pricing__c> mpList = [SELECT Id, Year__c, FAF_Mail_Operations__c  FROM Mail_Pricing__c WHERE FAF_Mail_Operations__c IN:mailOpsIdSet AND Year__c IN:yearSet ];
            if(!mpList.isEmpty()){
                for(Mail_Pricing__c mp:mpList){
                    Set<Id> mpSet;
                    String concatinateStr = mp.FAF_Mail_Operations__c+'-'+mp.Year__c;
                    if(parentChildMap.containsKey(concatinateStr)) {
                        mpSet = parentChildMap.get(concatinateStr);
                    } else {
                        mpSet = new Set<Id>();
                    }
                    mpSet.add(mp.Id);
                    parentChildMap.put(concatinateStr, mpSet);
                }
            }
}

catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
}

 public static void validateLobYearName(List<Mail_Pricing__c> MailPricingList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>();
            Map<string, MAP<string, Id>> MailPricingRelatedMap = new Map<string, MAP<string, Id>>();
            Map<string, Id> tempMap;
            set<Id> MailOpsIdSet = new set<Id>(); //Set contain the mail operation id
            set<string> concatinateStr = new set<string>(); //set created to add year,LOB  in set
            Set<Id>MailOprIdSet = new Set<Id>(); //Used to add mail operation id for pass in the query
            String str;
            String str1;
            //List<Mail_Pricing__c> MailPricingRecList = new List<Mail_Pricing__c>();
             for(Mail_Pricing__c MailPric: MailPricingList){
            MailOprIdSet.add(MailPric.FAF_Mail_Operations__c);
        }
            //Iterate over all Mail Pricing which are present in the MailPricingList
            for(Mail_Pricing__c MailPric: [select id, FAF_Mail_Operations__c, Year__c, LOB__c from Mail_Pricing__c
            where FAF_Mail_Operations__c in: MailOprIdSet]){
                tempMap = new Map<string,Id>();
                concatinateStr = new set<string>();
                if(MailOpsIdSet.size()>0){
                    if(MailOpsIdSet.contains(MailPric.FAF_Mail_Operations__c)){
                        concatinateStr.addall(parentChildMap.get(MailPric.FAF_Mail_Operations__c));
                        concatinateStr.add(MailPric.Year__c + MailPric.LOB__c );
                        parentChildMap.put(MailPric.FAF_Mail_Operations__c, concatinateStr);
                        tempMap.put(MailPric.Year__c + MailPric.LOB__c , MailPric.Id);
                        str = string.valueOf(MailPric.FAF_Mail_Operations__c)+string.valueOf(MailPric.Id);
                        MailPricingRelatedMap.put(str,tempMap);
                    }else{
                        concatinateStr.add(MailPric.Year__c + MailPric.LOB__c );
                        MailOpsIdSet.add(MailPric.FAF_Mail_Operations__c);
                        parentChildMap.put(MailPric.FAF_Mail_Operations__c, concatinateStr);
                        tempMap.put(MailPric.Year__c + MailPric.LOB__c , MailPric.Id);
                        str = string.valueOf(MailPric.FAF_Mail_Operations__c)+string.valueOf(MailPric.Id);
                        MailPricingRelatedMap.put(str,tempMap);
                    }
                }else{ //This condition will execute first time the loop will execute
                    concatinateStr.add(MailPric.Year__c + MailPric.LOB__c );
                    MailOpsIdSet.add(MailPric.FAF_Mail_Operations__c);
                    parentChildMap.put(MailPric.FAF_Mail_Operations__c, concatinateStr);
                    tempMap.put(MailPric.Year__c + MailPric.LOB__c , MailPric.Id);
                    str = string.valueOf(MailPric.FAF_Mail_Operations__c)+string.valueOf(MailPric.Id);
                    MailPricingRelatedMap.put(str,tempMap);
                }
            }
            if(isUpdateBool){ //Value to check it is insert case or Update
                for(Mail_Pricing__c MailPric: MailPricingList){
                    if(MailOpsIdSet.contains(MailPric.FAF_Mail_Operations__c)){
                        if(parentChildMap.get(MailPric.FAF_Mail_Operations__c).contains(MailPric.Year__c + MailPric.LOB__c )){
                            str1 = MailPric.Year__c + MailPric.LOB__c;
                            str = string.valueOf(MailPric.FAF_Mail_Operations__c)+string.valueOf(MailPric.Id);
                            if(MailPricingRelatedMap.get(str).get(str1) != MailPric.id){
                                MailPric.addError('Created Mail Pricing record already exists for the Year, and LOB combination. Please create a unique record using the combination.');
                            }
                        }
                    }     
                }
            }
            if(isInsertBool){ //Value to check it is insert case or Update
                for(Mail_Pricing__c MailPric: MailPricingList){
                    if(MailOpsIdSet.contains(MailPric.FAF_Mail_Operations__c)){
                        if(parentChildMap.get(MailPric.FAF_Mail_Operations__c).contains(MailPric.Year__c + MailPric.LOB__c )){
                            MailPric.addError('Created Mail Pricing record already exists for the Year, and LOB combination. Please create a unique record using the combination.');
                        }
                    }     
                }
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
    }
    
           /* =================================================================================
         * @Method Name       : UpdateMailPricing
         * @author            : Soumendu Chowdhury
         * @created date      : 08/18/2019
         * @Last modified by  : Soumendu Chowdhury
         * @Purpose           : Populate Rate on Mail Gurantee from Mail Pricing when update from Template
          ======================================================================================= */
       Public static void ProcessMailpricing(Map<Id,Mail_Pricing__c > OldMap,Map<Id,Mail_Pricing__c> NewMap,List<Mail_Pricing__c> MailPricingList)
      {
        set<id> ids=new set<id>();
        set<id> Mailids=new set<id>();
        set<id> agreementIds=new set<id>();
        map<id,decimal> mapOfMer=new map<id,decimal>();
        map<id,decimal> mapOfBer=new map<id,decimal>();
        map<id,decimal> mapOfNed=new map<id,decimal>();
        map<id,decimal> mapOfGer=new map<id,decimal>();
        map<id,decimal> mapOfSSG=new map<id,decimal>();
        map<id,String> mapDocumentAct=new map<id,String>();
       List<Mail_Pricing__c> Listprice = new List<Mail_Pricing__c>();
         for(Mail_Pricing__c mailPrice: MailPricingList){
            agreementIds.add(mailPrice.Agreement__c);
            Mailids.add(mailPrice.Id);
        }
        List<Mail_Pricing__c> MPrice = [Select Id,Batch_Update__c from Mail_Pricing__c Where Batch_Update__c = true And Id IN: Mailids];
        for(Mail_Pricing__c mpricing: MPrice ){
            mpricing.Batch_Update__c = false; // PCD Internal Template change
            Listprice.add(mpricing);
           
        }
        for(Mail_Pricing__c mailPrice: MailPricingList)
        {       
                if(Oldmap.get(mailPrice.ID).Invokable_Update__c==Newmap.get(mailPrice.ID).Invokable_Update__c){
                    if(Oldmap.get(mailPrice.Id).BER_Guarantee_Rate__c!=Newmap.get(mailPrice.Id).BER_Guarantee_Rate__c 
                    ||Oldmap.get(mailPrice.Id).GER_Guarantee_Rate__c!=Newmap.get(mailPrice.Id).GER_Guarantee_Rate__c
                    ||Oldmap.get(mailPrice.Id).MER_Guarantee_Rate__c !=Newmap.get(mailPrice.Id).MER_Guarantee_Rate__c 
                    ||Oldmap.get(mailPrice.Id).NED_Guarantee_Rate__c !=Newmap.get(mailPrice.Id).NED_Guarantee_Rate__c
                    ||Oldmap.get(mailPrice.Id).SSG_Guarantee_Rate__c !=Newmap.get(mailPrice.Id).SSG_Guarantee_Rate__c)
                    { 
                      ids.add(mailPrice.id);
                    }
                    if(Oldmap.get(mailPrice.Id).BER_Guarantee_Rate__c!=Newmap.get(mailPrice.Id).BER_Guarantee_Rate__c)
                    mapOfBer.put(mailPrice.id,Newmap.get(mailPrice.Id).BER_Guarantee_Rate__c);
                    if(Oldmap.get(mailPrice.Id).GER_Guarantee_Rate__c!=Newmap.get(mailPrice.Id).GER_Guarantee_Rate__c)
                    mapOfGer.put(mailPrice.id,Newmap.get(mailPrice.Id).GER_Guarantee_Rate__c);
                    if(Oldmap.get(mailPrice.Id).MER_Guarantee_Rate__c !=Newmap.get(mailPrice.Id).MER_Guarantee_Rate__c)
                    mapOfMer.put(mailPrice.id,Newmap.get(mailPrice.Id).MER_Guarantee_Rate__c);
                    if(Oldmap.get(mailPrice.Id).NED_Guarantee_Rate__c !=Newmap.get(mailPrice.Id).NED_Guarantee_Rate__c)
                    mapOfNed.put(mailPrice.id,Newmap.get(mailPrice.Id).NED_Guarantee_Rate__c);
                    if(Oldmap.get(mailPrice.Id).SSG_Guarantee_Rate__c !=Newmap.get(mailPrice.Id).SSG_Guarantee_Rate__c)
                    mapOfSSG.put(mailPrice.id,Newmap.get(mailPrice.Id).SSG_Guarantee_Rate__c);
                    
                     
                    
                    
                    
                }
            
        }
        
        List<Mail_Guarantees__c> guranteeListUpdate=new List<Mail_Guarantees__c>();
        List<Mail_Guarantees__c> guranteeList=[Select ID,Type__c,Rate__c,Mail_Pricing__c from Mail_Guarantees__c where Mail_Pricing__c IN:ids];
        for(Mail_Guarantees__c guar:guranteeList){
            if(guar.Type__c=='MER' && mapOfMer.get(guar.Mail_Pricing__c)!=null){
            guar.Rate__c=mapOfMer.get(guar.Mail_Pricing__c);
            }
            if(guar.Type__c=='GER' && mapOfGer.get(guar.Mail_Pricing__c)!=null){
            guar.Rate__c=mapOfGer.get(guar.Mail_Pricing__c);
            }
            if(guar.Type__c=='BER'&& mapOfBer.get(guar.Mail_Pricing__c)!=null ){
            guar.Rate__c=mapOfBer.get(guar.Mail_Pricing__c);
            }
            if(guar.Type__c=='NED' && mapOfNed.get(guar.Mail_Pricing__c)!=null){
            guar.Rate__c=mapOfNed.get(guar.Mail_Pricing__c);
            }
            if(guar.Type__c=='SSG' && mapOfSSG.get(guar.Mail_Pricing__c)!=null){
            guar.Rate__c=mapOfSSG.get(guar.Mail_Pricing__c);
            }
            guranteeListUpdate.add(guar);
        }
        if(!guranteeListUpdate.isEmpty() && guranteeListUpdate != null){
         Database.update(guranteeListUpdate);
         ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK=false;
        }
        
        if(!Listprice.isEmpty()  && Listprice!= null){
         //Database.update(Listprice);
         //ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK=false;
        }
    } 
}