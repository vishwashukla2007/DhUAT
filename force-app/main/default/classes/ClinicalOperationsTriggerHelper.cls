public with sharing class ClinicalOperationsTriggerHelper {
    
    public static void updateFAFOnInsert(List<Clinical_Operations__c> clinicOpsList) {
        try{
            List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
            
            List<Id> fafIds = new List<Id>();
            
            for(Clinical_Operations__c clinicOps: clinicOpsList)
            {  
                if(clinicOps.FAF_ID__c!= null){
                    fafIds.add(clinicOps.FAF_ID__c); 
                }           
            }
            
            Map<id,id> invalidFaf = UtilClass.validateLinkFAF(fafIds);
            
            for(Clinical_Operations__c clinicOps: clinicOpsList)
            {   
                if(clinicOps.FAF_ID__c!= null){
                    if(invalidFaf.containskey(clinicOps.FAF_ID__c)){
                        clinicOps.adderror('The current Partial FAF needs to be linked to an existing Full FAF');
                    }else{
                        Central_Hub__c faf = new Central_Hub__c();
                        faf.id = clinicOps.FAF_ID__c;
                        faf.Clinical_Operations__c = true;
                        fafToUpdate.add(faf);
                    }
                }           
            }       
            
            if(fafToUpdate.size()>0){
                update fafToUpdate;
            }
        }
        catch(Exception ex){
            for(Clinical_Operations__c co : clinicOpsList){
                co.adderror(ex.getDmlMessage(0));
            } 
        }     
    }
    
    public static void updateFAFOnDelete(List<Clinical_Operations__c> clinicOpsList) {
        try{
            List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
            
            for(Clinical_Operations__c clinicOps: clinicOpsList)
            {   
                if(clinicOps.FAF_ID__c!= null){
                    Central_Hub__c faf = new Central_Hub__c();
                    faf.id = clinicOps.FAF_ID__c;
                    faf.Clinical_Operations__c = False;
                    fafToUpdate.add(faf);
                }           
            }       
            
            if(fafToUpdate.size()>0){
                update fafToUpdate;
            }
        }
        catch(Exception ex){
            for(Clinical_Operations__c co : clinicOpsList){
                co.adderror(ex.getDmlMessage(0));
            } 
        }   
    }
    
    public static void checkCountOnBeforeInsert(List<Clinical_Operations__c> clinicOpsList) {
        try{
            set<id> fafIds = new set<Id>();
            Map<id,integer> fafnetworkMap =new Map<id,integer>();
            
            for(Clinical_Operations__c clinic: clinicOpsList)
            {   
                fafIds.add(clinic.FAF_ID__c);          
            }       
            
            for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Clinical_Operations__c WHERE FAF_ID__c in: fafIds and FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
                Integer Count =  (Integer)a.get('Total');
                fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
            }
            
            for(Clinical_Operations__c clinic: clinicOpsList)
            { 
                if(fafnetworkMap.get(clinic.FAF_ID__c) >0){
                    clinic.adderror('Cannot add more than One Clinical Operations to FAF');
                }        
            }
        }
        catch(Exception ex){
            for(Clinical_Operations__c co : clinicOpsList){
                co.adderror(ex.getDmlMessage(0));
            } 
        } 
    }
    
    public static void checkElectionOnDelete(List<Clinical_Operations__c> clinicalOpsList) {
        try{
            set<id> fafIds = new set<Id>();
            List<id> FeeServicesIds = new List<Id>();
            Map<id,integer> fafnetworkMap =new Map<id,integer>();
//            Map<id,integer> fafnetRDSMap =new Map<id,integer>();
            for(Clinical_Operations__c clinicalOp: clinicalOpsList)
            {   
                fafIds.add(clinicalOp.FAF_ID__c);           
            }
            
            for(Fee_Services__c feeObj : [select id,FAF_ID__c from Fee_Services__c where FAF_ID__c IN:fafIds]){
                FeeServicesIds.add(feeObj.Id);
            }
            
            for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM PBM_Services__c WHERE Fee_Services__c =: FeeServicesIds AND Election__c =true GROUP BY FAF_ID__c]){
                Integer Count =  (Integer)a.get('Total');
                fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
            }
//            for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Retiree_Drug_Subsidy__c WHERE Fee_Services__c =: FeeServicesIds AND Election__c =true GROUP BY FAF_ID__c]){
//                Integer Count =  (Integer)a.get('Total');
//                fafnetRDSMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
//            }
            
            for(Clinical_Operations__c clinical: clinicalOpsList)
            { 
                if(fafnetworkMap.get(clinical.FAF_ID__c) >0 ){
//                if(fafnetworkMap.get(clinical.FAF_ID__c) >0 || fafnetRDSMap.get(clinical.FAF_ID__c) >0){                
                 clinical.adderror(ConstantsUtil.BILLING_OPP_Election_Check_ERROR);
                }        
            }
          }catch(exception e){clinicalOpsList[0].addError(e.getDmlMessage(0)); }
   }
}