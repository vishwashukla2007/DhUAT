public with sharing class clientInfoTriggerHelper {
/* 
    public static void updateRebateBeforeInsert(List<Client_Information__c> cInfoList) {
     
        List<Integer> quater1Months = new List<Integer>{1,2,3};
        List<Integer> quater2Months = new List<Integer>{4,5,6};
        List<Integer> quater3Months = new List<Integer>{7,8,9};
        List<Integer> quater4Months = new List<Integer>{10,11,12};
                
        for(Client_Information__c cInfo : cInfoList){
            
           if(cInfo.Pricing_Effective_Date__c != null){
           
              Date pricingEffectiveDate = cInfo.Pricing_Effective_Date__c;
              Integer month = cInfo.Pricing_Effective_Date__c.month();
              Integer year = cInfo.Pricing_Effective_Date__c.year();
              Date fiscalQ1 = date.newInstance(year, 1, 1);
              Date fiscalQ2 = date.newInstance(year, 4, 1);
              Date fiscalQ3 = date.newInstance(year, 7, 1);
              Date fiscalQ4 = date.newInstance(year, 10, 1);
              
              if(quater1Months.contains(month)){
                 
                 if(pricingEffectiveDate == fiscalQ1){
                    cInfo.Rebate_Effective_Date__c = fiscalQ1;
                   }else{
                         cInfo.Rebate_Effective_Date__c = fiscalQ2;
                        }
              
               }
               
               if(quater2Months.contains(month)){
                 
                 if(pricingEffectiveDate == fiscalQ2){
                    cInfo.Rebate_Effective_Date__c = fiscalQ2;
                   }else{
                         cInfo.Rebate_Effective_Date__c = fiscalQ3;
                        }
              
               }
               
               if(quater3Months.contains(month)){
                 
                 if(pricingEffectiveDate == fiscalQ3){
                    cInfo.Rebate_Effective_Date__c = fiscalQ3;
                   }else{
                         cInfo.Rebate_Effective_Date__c = fiscalQ4;
                        }
              
               } 
               
               if(quater4Months.contains(month)){
                 
                 if(pricingEffectiveDate == fiscalQ4){
                    cInfo.Rebate_Effective_Date__c = fiscalQ4;
                   }else{
                         cInfo.Rebate_Effective_Date__c = date.newInstance(year+1, 1, 1);
                        }
              
               }          
           }         
        }    
    }
    public void autoPopulateRebathEffectiveDate(List<Client_Information__c> clientInfoList){
        set<Id> fafIds = new set<Id>();
        for(Client_Information__c c : clientInfoList){
            if(c.FAF_ID__c <> null) fafIds.add(c.FAF_ID__c);
        }
        Map<Id, Central_Hub__c> fafMapRecords = new Map<Id, Central_Hub__c>([select id, Business_Type__c from Central_Hub__c where id =: fafIds]);
        for(Client_Information__c clientInfo : clientInfoList){
            Central_Hub__c faf = new Central_Hub__c();
            if(clientInfo.FAF_ID__c <> null){
                faf = fafMapRecords.get(clientInfo.FAF_ID__c); 
                if(faf.Business_Type__c == 'New' || faf.Business_Type__c == 'Add On'){
                        clientInfo.Rebate_Effective_Date__c = clientInfo.Pricing_Effective_Date__c;
                }
                else if(faf.Business_Type__c == 'Existing'){
                    Date quaterStartDate;
                    if(clientInfo.Pricing_Effective_Date__c.Month() <= 3) quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 1,1);
                    else if(clientInfo.Pricing_Effective_Date__c.Month() <= 6) quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 4,1);
                    else if(clientInfo.Pricing_Effective_Date__c.Month() <= 9) quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 7,1);
                    else quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 10,1);
                    System.debug(clientInfo.Pricing_Effective_Date__c+'******** Effective Date ********'+clientInfo.Pricing_Effective_Date__c);
                    System.debug('******** Quater Start Date ********'+quaterStartDate);
                    if(clientInfo.Pricing_Effective_Date__c == quaterStartDate)
                       clientInfo.Rebate_Effective_Date__c = quaterStartDate;
                    else   
                       clientInfo.Rebate_Effective_Date__c =  quaterStartDate.AddMonths(3);
                }
            }   
        }   
    }   

    */
    
       public static void checkCountOnBeforeInsert(List<Client_Information__c> clientInfoList) {
        
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafCInfoMap =new Map<id,integer>();
        
        for(Client_Information__c cInfo: clientInfoList)
        {   
            fafIds.add(cInfo.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Client_Information__c WHERE FAF_ID__c in: fafIds and FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafCInfoMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Client_Information__c cInfo: clientInfoList)
        { 
            if(fafCInfoMap.get(cInfo.FAF_ID__c) >0){
                cInfo.adderror('Cannot add more than One Client Information to FAF');
            }        
        }
        
   }
   public static boolean BulkUpdate(List<Client_Information__c> clientInfoList) {
    for(Client_Information__c ci : clientInfoList){
        return ci.Bulk_Update_2__c;
    }
    return false;
    } 
   public static void updatePlatformSpefics(List<Client_Information__c> clientInfoList,Map<id,Client_Information__c> clientInfoOldMap) {
        
        set<id> cInfoIds = new set<Id>();
        Map<id,List<Platform_Specifics__c>> cInfoPSMap =new Map<id,List<Platform_Specifics__c>>();
        List<Platform_Specifics__c> psToUpdate = new List<Platform_Specifics__c>();
        for(Client_Information__c cInfo: clientInfoList)
        {    
            Client_Information__c cInfoOld = clientInfoOldMap.get(cInfo.ID);
            if(  cInfo.Pricing_Effective_Date__c != cInfoOld.Pricing_Effective_Date__c){
               cInfoIds.add(cInfo.id);  
              }                    
        }       
        
        for(Platform_Specifics__c ps: [SELECT id,EffectiveDate__c,FAF_Client_Information__c FROM Platform_Specifics__c WHERE FAF_Client_Information__c in: cInfoIds and EffectiveDate__c!= null]){
            if(cInfoPSMap.containskey(ps.FAF_Client_Information__c)){
                List<Platform_Specifics__c> psList = cInfoPSMap.get(ps.FAF_Client_Information__c);
                psList.add(ps);
                cInfoPSMap.put(ps.FAF_Client_Information__c,psList);
                }else{ 
                      List<Platform_Specifics__c> psList = new List<Platform_Specifics__c>();
                      psList.add(ps);
                      cInfoPSMap.put(ps.FAF_Client_Information__c,psList);
                     }
        } 
        
        
        
        for(Client_Information__c cInfo: clientInfoList)
        { 
            if(cInfoPSMap.containskey(cInfo.id)){
                Client_Information__c cInfoOld = clientInfoOldMap.get(cInfo.ID);
                for(Platform_Specifics__c ps: cInfoPSMap.get(cInfo.id)){
                    if(cInfoOld.Pricing_Effective_Date__c == ps.EffectiveDate__c) {
                       ps.EffectiveDate__c = cInfo.Pricing_Effective_Date__c;
                       psToUpdate.add(ps);
                      }             
                }
            }        
        }
        
        if(psToUpdate.size()>0){
            Update psToUpdate;
        }
        
   }
   
    public static void clientInfoPricingEffectiveDateCheck(List<Client_Information__c> ciNewList,Map<Id, Client_Information__c> ciOldMap){
        List<Id> fafId = new List<Id>();
        Map<Id,Date> priceDateMap = new Map<Id,Date>();
        Map<Id,Client_Information__c> fafClientInfoMap = new Map<Id,Client_Information__c>();
        List<Billing_Broker_TPA_Payments__c> brokerTpaList = new List<Billing_Broker_TPA_Payments__c>();
        for(Client_Information__c newCI : ciNewList){
            Client_Information__c oldClientInfo = ciOldMap.get(newCI.ID);       
            if(newCI.Pricing_Effective_Date__c != null && newCI.Pricing_Effective_Date__c != oldClientInfo.Pricing_Effective_Date__c){              
                fafId.add(newCI.FAF_ID__c);
                priceDateMap.put(newCI.FAF_ID__c,newCI.Pricing_Effective_Date__c);
                fafClientInfoMap.put(newCI.FAF_ID__c,newCI);    
            }
        }
        
        if(!fafId.IsEmpty()){
            brokerTpaList = [select id,FAF_ID__c,Effective_Date__c from Billing_Broker_TPA_Payments__c where FAF_ID__c in : fafId];
            if(!brokerTpaList.IsEmpty()){
                for(Billing_Broker_TPA_Payments__c btpa : brokerTpaList){
                    Date priceEffectiveDate = priceDateMap.get(btpa.FAF_ID__c);
                    if(btpa.Effective_Date__c < priceEffectiveDate){
                        Client_Information__c ci = fafClientInfoMap.get(btpa.FAF_ID__c);
                        ci.addError(ConstantsUtil.PRICEEFFECTIVEDATEERROR);                         
                    }           
                }
            }
        }
    }
    
    public static void afterupdateclientinfo(List<Client_Information__c> clientInfoList)
     {
         Config_Validation_for_Clientinfo__c dv = Config_Validation_for_Clientinfo__c.getOrgDefaults();
         dv.By_Pass_CI_Validation__c = false;
         upsert dv;
     }
     
    
    public static void clientInfoContractEndDateCheck(List<Client_Information__c> ciNewList,Map<Id, Client_Information__c> ciOldMap){
       /*PT US82 Remove validation for Contract End Date on Client Information ... Code Commented by Sneha Inturi
        List<Id> fafId = new List<Id>();
        Map<Id,Date> contractDateMap = new Map<Id,Date>();
        Map<Id,Client_Information__c> fafClientInfoMap = new Map<Id,Client_Information__c>();
        List<Billing_Other_Payments__c> billOtherList = new List<Billing_Other_Payments__c>();
        for(Client_Information__c newCI : ciNewList){
            Client_Information__c oldClientInfo = ciOldMap.get(newCI.ID);       
            if(newCI.Contract_End_Date__c != null && newCI.Contract_End_Date__c != oldClientInfo.Contract_End_Date__c){             
                fafId.add(newCI.FAF_ID__c);
                contractDateMap.put(newCI.FAF_ID__c,newCI.Contract_End_Date__c);
                fafClientInfoMap.put(newCI.FAF_ID__c,newCI);    
            }
        }
        
        if(!fafId.IsEmpty()){
            billOtherList = [select id,FAF_ID__c,Expiration__c from Billing_Other_Payments__c where FAF_ID__c in : fafId];
            if(!billOtherList.IsEmpty()){
                for(Billing_Other_Payments__c bop : billOtherList){
                    Date contractEndDate = contractDateMap.get(bop.FAF_ID__c);
                    if(bop.Expiration__c < contractEndDate){
                        Client_Information__c ci = fafClientInfoMap.get(bop.FAF_ID__c);
                        ci.addError(ConstantsUtil.CONTRACTENDDATEERROR);                            
                    }           
                }
            }
        } */
    }
}