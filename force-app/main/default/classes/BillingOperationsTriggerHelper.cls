public with sharing class BillingOperationsTriggerHelper {

    public static void updateFAFOnInsert(List<Billing_Operations__c> billingOpsList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
        List<Id> fafIds = new List<Id>();
        
        for(Billing_Operations__c billingOps: billingOpsList)
        {  
          if(billingOps.FAF_ID__c!= null){
              fafIds.add(billingOps.FAF_ID__c); 
            }           
        }
        
        Map<id,id> invalidFaf = UtilClass.validateLinkFAF(fafIds);
        
        for(Billing_Operations__c billingOps: billingOpsList)
        {   
            if(billingOps.FAF_ID__c!= null){
                if(invalidFaf.containskey(billingOps.FAF_ID__c)){
                   billingOps.adderror(ConstantsUtil.PARTIAL_FAF_ERROR);
                  }else{
                        Central_Hub__c faf = new Central_Hub__c();
                        faf.id = billingOps.FAF_ID__c;
                        faf.Billing_Operations__c = true;
                       
                        fafToUpdate.add(faf);
                       } 
            }           
        }       

          if(fafToUpdate.size()>0){
          //AvoidParentTriggerExecOnChildUpdate.executeParentTriggerExecution();
          //AvoidParentTriggerExecOnChildUpdate.isChilldUpdate = true;
          update fafToUpdate;
          //AvoidParentTriggerExecOnChildUpdate.isChilldUpdate = false;
          }
          }catch(exception e){billingOpsList[0].addError(e.getDmlMessage(0)); }
   }
   
   public static void updateFAFOnDelete(List<Billing_Operations__c> billingOpsList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
            

        for(Billing_Operations__c billingOps: billingOpsList)
        {   
            if(billingOps.FAF_ID__c!= null){
            Central_Hub__c faf = new Central_Hub__c();
            faf.id = billingOps.FAF_ID__c;
            faf.Billing_Operations__c = False;
           
            fafToUpdate.add(faf);
            }           
        }       

          if(fafToUpdate.size()>0){
          //AvoidParentTriggerExecOnChildUpdate.executeParentTriggerExecution();
          //AvoidParentTriggerExecOnChildUpdate.isChilldUpdate = true;
          update fafToUpdate;
          //AvoidParentTriggerExecOnChildUpdate.isChilldUpdate = false;
          }
          }catch(exception e){billingOpsList[0].addError(e.getDmlMessage(0)); }
   }
    
    public static void checkElectionOnDelete(List<Billing_Operations__c> billingOpsList) {
        try{
            set<id> fafIds = new set<Id>();
            Map<id,integer> fafnetworkMap =new Map<id,integer>();
            Map<id,integer> fafnetRDSMap =new Map<id,integer>();
            for(Billing_Operations__c billingOps: billingOpsList)
            {   
                fafIds.add(billingOps.FAF_ID__c);           
            }
            
            for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM PBM_Services__c WHERE FAF_ID__c in: fafIds AND Election__c =true GROUP BY FAF_ID__c]){
                Integer Count =  (Integer)a.get('Total');
                fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
            }
//            for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Retiree_Drug_Subsidy__c WHERE FAF_ID__c in: fafIds AND Election__c =true GROUP BY FAF_ID__c]){
//                Integer Count =  (Integer)a.get('Total');
//                fafnetRDSMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
//            }
            
            for(Billing_Operations__c billing: billingOpsList)
            { 
//                if(fafnetworkMap.get(billing.FAF_ID__c) >0 || fafnetRDSMap.get(billing.FAF_ID__c) >0){
                if(fafnetworkMap.get(billing.FAF_ID__c) >0 ){                
                 billing.adderror(ConstantsUtil.BILLING_OPP_Election_Check_ERROR);
                }        
            }
          }catch(exception e){billingOpsList[0].addError(e.getDmlMessage(0)); }
   }
    
   
   /*public static void checkCountOnBeforeInsert(List<Billing_Operations__c> billingOpsList) {
        try{
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafnetworkMap =new Map<id,integer>();
        
        for(Billing_Operations__c billing: billingOpsList)
        {   
            fafIds.add(billing.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Billing_Operations__c WHERE FAF_ID__c in: fafIds GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Billing_Operations__c billing: billingOpsList)
        { 
            if(fafnetworkMap.get(billing.FAF_ID__c) >0){
             billing.adderror(ConstantsUtil.BILLING_OPP_FAF_ERROR);
            }        
        }
        }catch(exception e){billingOpsList[0].addError(e.getDmlMessage(0)); }
   }*/
   
}