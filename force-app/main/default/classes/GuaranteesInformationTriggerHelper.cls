public with sharing class GuaranteesInformationTriggerHelper {

    public static void updateFAFOnInsert(List<Guarantees_Information__c> infoList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
        List<Id> fafIds = new List<Id>();
        
        for(Guarantees_Information__c info: infoList)
        {  
          if(info.FAF_ID__c!= null){
              fafIds.add(info.FAF_ID__c); 
            }           
        }
        
        Map<id,id> invalidFaf = UtilClass.validateLinkFAF(fafIds);
        
        for(Guarantees_Information__c info: infoList)
        {   
            if(info.FAF_ID__c!= null){
                 if(invalidFaf.containskey(info.FAF_ID__c)){
                  info.adderror('The current Partial FAF needs to be linked to an existing Full FAF');
                  }else{
                        Central_Hub__c faf = new Central_Hub__c();
                        faf.id = info.FAF_ID__c;
                        faf.Guarantee_Information__c = true;
                        fafToUpdate.add(faf);
                        }
            }           
        }       

          if(fafToUpdate.size()>0){
              FAFTriggerHelper.validateFAFStatusCheck = false;
              system.debug('*********fafToUpdate*************'+fafToUpdate);
          update fafToUpdate;
          }
        }
        catch(Exception ex){
            for(Guarantees_Information__c gi : infoList){
                gi.adderror(ex.getDmlMessage(0));
            } 
        }   
   }
   
   public static void updateFAFOnDelete(List<Guarantees_Information__c> infoList) {
        
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        try{
        for(Guarantees_Information__c info: infoList)
        {   
            if(info.FAF_ID__c!= null){
            Central_Hub__c faf = new Central_Hub__c();
            faf.id = info.FAF_ID__c;
            faf.Guarantee_Information__c = False;
            fafToUpdate.add(faf);
            }           
        }       

          if(fafToUpdate.size()>0){
          update fafToUpdate;
          }
          }
        catch(Exception ex){
            for(Guarantees_Information__c gi : infoList){
                gi.adderror(ex.getDmlMessage(0));
            } 
        }   
   }
   
   public static void checkCountOnBeforeInsert(List<Guarantees_Information__c> infoList) {
        
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafnetworkMap =new Map<id,integer>();
        
        for(Guarantees_Information__c info: infoList)
        {   
            fafIds.add(info.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Guarantees_Information__c WHERE FAF_ID__c in: fafIds and FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Guarantees_Information__c info: infoList)
        { 
            if(fafnetworkMap.get(info.FAF_ID__c) >0){
             info.adderror('Cannot add more than One Guarantees Information to FAF');
            }        
        }
        
   }
   
   // method added for Defect fixing of 1.4.5.12
   public static void updateRiskAmount(List<Guarantees_Information__c> infoList) {
       try{
        set<id> ginfoIds = new set<Id>();
        List<Trend_Guarantee__c> newTrendguarList = new List<Trend_Guarantee__c>();
        for(Guarantees_Information__c info: infoList)
        {   
            if(info.Trend_Recon_Method__c != 'By Component'){
                ginfoIds.add(info.Id);
            }
      
        }
        
        List<Trend_Guarantee__c> trendGuarList = [SELECT id,At_Risk_Amount__c FROM Trend_Guarantee__c WHERE Guarantee_Information__c in: ginfoIds];
        for(Trend_Guarantee__c tg: trendGuarList)
        {
            tg.At_Risk_Amount__c = null;
            newTrendguarList.add(tg);
        }
        update newTrendguarList;  
            }
        catch(Exception ex){
            for(Guarantees_Information__c gi : infoList){
                gi.adderror(ex.getDmlMessage(0));
            } 
        }   
   }
   // Logic to delete Gnc guarantee records when the GNC value changes from Yes to No- Sindhu A
      public static void deleteGNCChildRecords(Map<Id, Guarantees_Information__c> oldMap, Map<Id, Guarantees_Information__c> newMap) {
        Set<Id> infoIdSet = new Set<Id>();

        for(Id id: newMap.keySet()){    
            if(oldMap.get(Id).Guaranteed_Net_Cost_Gnc_Guarantee__c == 'Yes' && newMap.get(Id).Guaranteed_Net_Cost_Gnc_Guarantee__c != 'Yes') {
                infoIdSet.add(id);
            }          
        }           
        List<Gnc_Guarantee__c> gncList = [SELECT Id FROM Gnc_Guarantee__c WHERE Guarantee_Information__c IN:infoIdSet];
        if(!gncList.isEmpty()) {
            delete gncList;
        }             
   } 
}