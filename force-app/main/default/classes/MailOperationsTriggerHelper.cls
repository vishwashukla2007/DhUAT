public with sharing class MailOperationsTriggerHelper {
public class MyException extends Exception {}
    public static void updateFAFOnInsert(List<Mail_Operations__c> mailOpsList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
       
        
        for(Mail_Operations__c mOps: mailOpsList)
        {   
            if(mOps.FAF_ID__c!= null){
                
                        Central_Hub__c faf = new Central_Hub__c();
                        faf.id = mOps.FAF_ID__c;
                        faf.Mail_Operations__c = true;
                       
                        fafToUpdate.add(faf);
                       
            }           
        }       

          if(fafToUpdate.size()>0){
        FAFTriggerHelper.validateFAFStatusCheck = false;
         update fafToUpdate;
          }
          }catch(exception e){mailOpsList[0].addError(e.getDmlMessage(0)); }
   }
   
   public static void updateFAFOnDelete(List<Mail_Operations__c> mailOpsList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
        for(Mail_Operations__c mOps: mailOpsList)
        {   
           if(mOps.FAF_ID__c!= null){
                 Central_Hub__c faf = new Central_Hub__c();
                        faf.id = mOps.FAF_ID__c;
                        faf.Mail_Operations__c = False;
                        
                        fafToUpdate.add(faf);
                        
            }           
        }       

          if(fafToUpdate.size()>0){
          update fafToUpdate;
          }
           }catch(exception e){mailOpsList[0].addError(e.getDmlMessage(0)); }
   }
   
   public static void checkCountOnBeforeInsert(List<Mail_Operations__c> mailOpsList) {
        try{
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafnetworkMap =new Map<id,integer>();
        
        for(Mail_Operations__c mops: mailOpsList)
        {   
            fafIds.add(mops.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Mail_Operations__c WHERE FAF_ID__c in: fafIds and
            FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Mail_Operations__c mops: mailOpsList)
        { 
            if(fafnetworkMap.get(mops.FAF_ID__c) >0){
             mops.adderror('Cannot add more than One Mail Operations to FAF');
            }        
        }
        }catch(exception e){mailOpsList[0].addError(e.getMessage()); }
   }
   
   //Added Sonal Sharma 
   public static void UpdateNetworkPricing(Map<id, Mail_Operations__c> oldMap,Map<id, Mail_Operations__c> trNewMap,boolean isInsert){
       Map<id, Mail_Operations__c> newMap=new Map<id, Mail_Operations__c>();
        Set<Id> trMailOpsID = new Set<Id>(); 
       for(Mail_Operations__c mailOps : trNewMap.values()) {
           if(!isInsert){
                if((mailOps.Client__c!=oldMap.get(mailOps.id).Client__c) || (mailOps.Member__c!=oldMap.get(mailOps.id).Member__c)){
                    newMap.put(mailOps.id,mailOps);
                    trMailOpsID.add(mailOps.id);
                }
           }
        }
        if(isInsert){
            UpdateMirrorNetworkPricing(trNewMap);
        }else{
            if(!trMailOpsID.isEmpty()){
                UpdateMirrorNetworkPricing(newMap);
            }
        }
   }
   //Added by Sonal Sharma
   public static void UpdateMirrorNetworkPricing(Map<id, Mail_Operations__c> newMap){
       
           Set<id> fafId= new Set<id>();
           Map<id,id> fafMailMap= new  Map<id,id>();   //map of fafid and mailOps id
           Map<id,String> MailClientMap= new  Map<id,String>(); 
           Map<id,String> MailMemberMap= new  Map<id,String>(); 
           String mailOpsId='';
           List<Network_Pricing__c> npList= new List<Network_Pricing__c>();
           for(Mail_Operations__c mos:newMap.values()){
               fafId.add(mos.FAF_ID__c);
               fafMailMap.put(mos.FAF_ID__c,mos.id);
               MailClientMap.put(mos.id,mos.Client__c);
               MailMemberMap.put(mos.id,mos.Member__c);
           }
           
           if(!fafId.isEmpty()){
               npList= [select id,FAF_ID__c, Client_Adjudication_Logic_Deviation__c, Member_Adjudication_Logic_Deviation__c, Mirror_Mail_Brand_Pricing__c, Mirror_Mail_Generic_Pricing__c from Network_Pricing__c where FAF_ID__c IN: fafId];
           }
           if(!npList.isEmpty()){
               for(Network_Pricing__c np :npList){
                   if(np.Mirror_Mail_Brand_Pricing__c||np.Mirror_Mail_Generic_Pricing__c){
                       mailOpsId=fafMailMap.get(np.FAF_ID__c); //to get the mail ops id from the map which is related to np
                       System.debug('np.id= '+np.id +' mailOpsId = '+mailOpsId);
                       np.Client_Adjudication_Logic_Deviation__c=MailClientMap.get(mailOpsId);
                       np.Member_Adjudication_Logic_Deviation__c=MailMemberMap.get(mailOpsId);
                   }
               }
               try{
                database.upsert(npList);
               }catch(Exception e){
                   System.debug(' exception = '+e);
               }
        }
    }
    
    //added by Sonal Sharma
    public static void updateNetworkPricingOnDelete(List<Mail_Operations__c> mailOpsList){
        Set<id> fafId= new Set<id>();
           Map<id,id> fafMailMap= new  Map<id,id>();   //map of fafid and mailOps id
           
           List<Network_Pricing__c> npList= new List<Network_Pricing__c>();
           for(Mail_Operations__c mos:mailOpsList){
               fafId.add(mos.FAF_ID__c);
           }
           
           if(!fafId.isEmpty()){
               npList= [select id,FAF_ID__c, Client_Adjudication_Logic_Deviation__c, Member_Adjudication_Logic_Deviation__c, Mirror_Mail_Brand_Pricing__c, Mirror_Mail_Generic_Pricing__c from Network_Pricing__c where FAF_ID__c IN: fafId];
           }
           if(!npList.isEmpty()){
               for(Network_Pricing__c np :npList){
                   if(np.Mirror_Mail_Brand_Pricing__c||np.Mirror_Mail_Generic_Pricing__c){
                       np.Client_Adjudication_Logic_Deviation__c='';
                       np.Member_Adjudication_Logic_Deviation__c='';
                   }
               }
               try{
                update npList;
               }catch(Exception e){
                   System.debug(' exception = '+e);
               }
               
           }
    }
   
}