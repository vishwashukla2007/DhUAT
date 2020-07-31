public with sharing class NetworkOperationsTriggerHelper {
    public static Set<String> groupA = new Set<String>{'Lower of Discount or U&C or MAC', 'Lower of MAC or Discount', 'MAC Prevails then Discount with U&C', 'MAC Prevails then Discount without U&C'};
    public static Set<String> groupB = new Set<String>{'No MAC then Discount without U&C', 'No MAC with U&C'};

    
    public static void updateFAFOnInsert(List<Network_Operations__c> networkList) {
        
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
        for(Network_Operations__c net: networkList)
        {                   
            if(net.FAF_ID__c!= null){
                Central_Hub__c faf = new Central_Hub__c();
                            faf.id = net.FAF_ID__c;
                            faf.Network_Operations__c = true;
                            fafToUpdate.add(faf);
                           
            }           
        }       
            try{
              if(fafToUpdate.size()>0){
              
              FAFTriggerHelper.validateFAFStatusCheck = false;
              update fafToUpdate;
              }
            }
            Catch(Exception Ex){
                for(Network_Operations__c FAFObj:networkList){
                 FAFObj.adderror(ex.getDMLMessage(0));
                }
            
            }
             
   }
   
   public static void updateFAFOnDelete(List<Network_Operations__c> networkList) {
        
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        for(Network_Operations__c net: networkList)
        {   
           if(net.FAF_ID__c!= null){
               Central_Hub__c faf = new Central_Hub__c();
                            faf.id = net.FAF_ID__c;
                            faf.Network_Operations__c = False;
                            fafToUpdate.add(faf);
                           
            }           
        }       
        try{
          if(fafToUpdate.size()>0){
              update fafToUpdate;
          }
        }
        Catch(Exception Ex)
        {
            for(Network_Operations__c FAFObj:networkList){
                 FAFObj.adderror(ex.getDMLMessage(0));
                }
        }
   }
   
   public static void checkCountOnBeforeInsert(List<Network_Operations__c> networkList) {
        
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafnetworkMap =new Map<id,integer>();
        
        for(Network_Operations__c net: networkList)
        {   
            fafIds.add(net.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Network_Operations__c WHERE FAF_ID__c in: fafIds and FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Network_Operations__c net: networkList)
        { 
            if(fafnetworkMap.get(net.FAF_ID__c) >0){
             net.adderror('Cannot add more than One network to FAF');
            }        
        }
        
   }
   
   public static void clientValueUpdateOnPricing(Map<id, Network_Operations__c> oldMap, Map<id, Network_Operations__c> newMap) {
       Set<Id> noIdSet = new Set<Id>();
       String passThrough='Pass-Through'; //added by Sonal Sharma as per us30559
       for(Id id:newMap.keySet()) {
           if((groupA.contains(oldMap.get(id).client__c) && groupB.contains(newMap.get(id).client__c)) ||
               (groupB.contains(oldMap.get(id).client__c) && groupA.contains(newMap.get(id).client__c))) {
               noIdSet.add(id);
           }
       }
       
       if(!noIdSet.isEmpty()) {
           String genericBasis='';
           List<Network_Pricing__c> npList = [SELECT Id, FAF_Network_Ops__c,Brand_Basis__c,Generic_Rate__c FROM Network_Pricing__c WHERE FAF_Network_Ops__c IN:noIdSet];
           for(Network_Pricing__c np:npList) {
               if(groupA.contains(newMap.get(np.FAF_Network_Ops__c).client__c) && (np.Brand_Basis__c!=passThrough) ) {
                   genericBasis = 'MAC Modeled & Non-MAC';
               } else if(groupB.contains(newMap.get(np.FAF_Network_Ops__c).client__c) && (np.Brand_Basis__c!=passThrough)) {
                   genericBasis = 'Flat Generic Discount';
                   np.MAC_Modeled__c = null;
                   np.Non_MAC_Generic_Rate__c=null;
               } else if(np.Brand_Basis__c==passThrough){
                   genericBasis='Pass-Through';
               }else {
                   genericBasis = '';
               }
               np.Generic_Basis__c = genericBasis;
                np.Generic_Rate__c = null;
           }
           try{
               if(!npList.isEmpty()) {
                   update npList;
               }
           }
           Catch(Exception Ex)
        {
            for(Network_Operations__c FAFObj:newMap.values()){
                 FAFObj.adderror(ex.getDMLMessage(0));
            }
        }
       }
   }
}