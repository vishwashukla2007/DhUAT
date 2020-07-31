public class PCD_Network_MultipleLOB {
    @AuraEnabled
    public static List<PCD_Multiple_LOB__c> get_AdditionalLOB(String Basealiid){
        try {
            List<PCD_Multiple_LOB__c> lstMultipleLOB = [
                select Id,Base_FAF_ID__c, Base_LOB__c, Base_LOB_ID__c, ALI_ID__c, Additional_FAF_ID__c, Base_LOB__r.LOB_Description__c,
                Additional_LOB__c, Additional_LOB_ID__c, Additional_LOB_Numeric_ID__c, Base_LOB_Numeric_ID__c 
                from PCD_Multiple_LOB__c 
                where ALI_ID__c= :Basealiid order by Additional_LOB_Numeric_ID__c asc
            ];
            return lstMultipleLOB; 
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }   
    @AuraEnabled
    public static List<LOB__c> get_AddToLOB(String Basealiid){
        List<LOB__c> lobList = new List<LOB__c>();
        try {
            List<Apttus__AgreementLineItem__c> lstali = [select Id, Apttus__AgreementId__c from Apttus__AgreementLineItem__c where Id = :Basealiid];
            if(!lstali.isEmpty()){
                Set<Id> selectedLobIds = new Set<Id>();
                for(PCD_Multiple_LOB__c mlob : [
                    select Id, Base_LOB__c, Additional_LOB__c
                    from PCD_Multiple_LOB__c 
                    where ALI_ID__c= :Basealiid
                ]){
                    selectedLobIds.add(mlob.Base_LOB__c);
                    selectedLobIds.add(mlob.Additional_LOB__c);
                }
                Offer__c offer =[select Id, PCD__c from Offer__c where PCD__c= :lstali[0].Apttus__AgreementId__c limit 1];
                lobList = [Select Id, FAF__c, LOB_Description__c, Client_Pricing_Offer__c from LOB__c Where Client_Pricing_Offer__c = : offer.Id and Id NOT IN :selectedLobIds];
                return lobList;
            }
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return lobList;
    }   
    @AuraEnabled
    public static List<LOB__c> get_allLOB(String Basealiid){
        try {
            List<LOB__c> lstallLOB =  new List<LOB__c>();
            Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c from  Apttus__AgreementLineItem__c where Id = :Basealiid ];                    
            if (lstali.Apttus__AgreementId__c != null) {  
                lstallLOB= [
                    select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,FAF_Agreement_Line_Item__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                    where Agreement__c = :lstali.Apttus__AgreementId__c
                ];   
            }                 
            return lstallLOB; 
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 
    public class NetworkWrapper {
        @AuraEnabled public list<NetworkInsideWrapper> npList;
        @AuraEnabled public String networkName;
        @AuraEnabled public Boolean isSelectedAll;
    }
    public class NetworkInsideWrapper {
        @AuraEnabled public Network_Pricing__c np;
        @AuraEnabled public Boolean isSelected;
    }
    @AuraEnabled
    public static List<NetworkWrapper> get_NetworkWrapperList(String fafId){
        List<NetworkWrapper> wrapperList = new List<NetworkWrapper>();
        Map<String, List<Network_Pricing__c>> npMap = new Map<String, List<Network_Pricing__c>>();
        
        list<Network_Pricing__c> npList = [
            Select Id, Year__c, Network_Type__c, Network_Name_for_Grid__c, LOB__c, Network_Name__c, Generic_Basis__c, Brand_Basis__c, FAF_ID__c
            From Network_Pricing__c
            Where FAF_ID__c = :fafId order by NetworkOrdinalSort__c,Year__c asc
        ];
        for(Network_Pricing__c np :npList){
            if(String.isNotBlank(np.Network_Name_for_Grid__c)){
                if(npMap.containsKey(np.Network_Name_for_Grid__c)){
                    npMap.get(np.Network_Name_for_Grid__c).add(np);
                } else {
                    List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                    temp.add(np);
                    npMap.put(np.Network_Name_for_Grid__c, temp);
                }
            }
        }
        
        for(String npName :npMap.keySet()){
            NetworkWrapper nw = new NetworkWrapper();
            nw.networkName = npName;
            List<NetworkInsideWrapper> wrapperNPList = new List<NetworkInsideWrapper>();
            for(Network_Pricing__c np :npMap.get(npName)){
                NetworkInsideWrapper npw = new NetworkInsideWrapper();
                npw.np = np;
                npw.isSelected = false;
                wrapperNPList.add(npw);
            }
            nw.npList = wrapperNPList;
            nw.isSelectedAll = false;
            wrapperList.add(nw);
        }
        return wrapperList;
    }

    @AuraEnabled
    public static PCD_Multiple_LOB__c create_mlob(String Basealiid, List<String> mlob){
        try {
            List<PCD_Multiple_LOB__c> newmlob = new List<PCD_Multiple_LOB__c>();
            LOB__c lstallLOB = new LOB__c();
            system.debug('aa');
            Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c,LOB_ID__c from  Apttus__AgreementLineItem__c where Id = :Basealiid ];                    
            if (lstali.Apttus__AgreementId__c != null) {  
                system.debug('bb');
                lstallLOB = [
                    select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                    where Agreement__c = :lstali.Apttus__AgreementId__c and Id = :lstali.LOB_ID__c
                ];   
            } 
            system.debug('cc');
            List<LOB__c> lstallmLOB= [
                select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                where Id IN :mlob order by Lob__c asc
            ];  
            system.debug('dd');  
            //List<String> lobNum = new List<String>();
            for (LOB__c lob : lstallmLOB) {
                PCD_Multiple_LOB__c  mlobid = new PCD_Multiple_LOB__c();
                mlobid.Base_FAF_ID__c = lstallLOB.FAF__c;
                mlobid.Base_LOB__c = lstallLOB.Id;
                mlobid.Base_LOB_ID__c = lstallLOB.LOB_Description__c;
                mlobid.Additional_FAF_ID__c = lob.FAF__c;
                mlobid.Additional_LOB__c = lob.Id;
                mlobid.Additional_LOB_ID__c = lob.LOB_Description__c;
                newmlob.add(mlobid);
                
            }           
            system.debug('ee');
            List<Database.UpsertResult> result = Database.upsert(newmlob, false);
            for(Integer i=0;i<result.size();i++){
                if(!result.get(i).isSuccess()) {
                    Database.Error error = result.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    throw new AuraHandledException(failedDML);
                }
            }      
            PCD_Multiple_LOB__c returnMLob = new PCD_Multiple_LOB__c();
            if(newmlob[0] != null && newmlob[0].Id != null){
                returnMLob = [
                    select Id,Base_FAF_ID__c, Base_LOB__c, Base_LOB_ID__c, ALI_ID__c, Additional_FAF_ID__c, Base_LOB__r.LOB_Description__c,
                    Additional_LOB__c, Additional_LOB_ID__c, Additional_LOB_Numeric_ID__c, Base_LOB_Numeric_ID__c 
                    from PCD_Multiple_LOB__c 
                    where Id= :newmlob[0].Id
                ];
            }
            return returnMLob; 
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }  
    @AuraEnabled
    public static void create_npDenorm(String Basealiid, List<String> selectedNpIds){
        
    }
}