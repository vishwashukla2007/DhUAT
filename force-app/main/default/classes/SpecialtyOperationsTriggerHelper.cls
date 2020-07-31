public with sharing class SpecialtyOperationsTriggerHelper {

    public static void updateFAFOnInsert(List<Specialty_Operations__c> spOpsList) {
       try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
        
         
        for(Specialty_Operations__c sOps: spOpsList)
        {   
            if(sOps.FAF_ID__c!= null){
                
                        Central_Hub__c faf = new Central_Hub__c();
                        faf.id = sOps.FAF_ID__c;
                        faf.Specialty_Operations__c = true;
                      
                        fafToUpdate.add(faf);
                        
            }           
        }       

          if(fafToUpdate.size()>0){
          update fafToUpdate;
          }
      }
        catch(Exception ex){
            for( Specialty_Operations__c so : spOpsList){
                so.adderror(ex.getDmlMessage(0));
            } 
        }     
    }
   
   public static void updateFAFOnDelete(List<Specialty_Operations__c> spOpsList) {
         try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();

        for(Specialty_Operations__c sOps: spOpsList)
        {   
            if(sOps.FAF_ID__c!= null){
            Central_Hub__c faf = new Central_Hub__c();
            faf.id = sOps.FAF_ID__c;
            faf.Specialty_Operations__c = False;
            
            fafToUpdate.add(faf);
            }           
        }       

          if(fafToUpdate.size()>0){
          update fafToUpdate;
          }
          }catch(Exception ex){
            for( Specialty_Operations__c so : spOpsList){
                so.adderror(ex.getDmlMessage(0));
            } 
        }     
   }
   
   public static void checkCountOnBeforeInsert(List<Specialty_Operations__c> spOpsList) {
       try{ 
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafnetworkMap =new Map<id,integer>();
        
        for(Specialty_Operations__c sOps: spOpsList)
        {   
            fafIds.add(sOps.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Specialty_Operations__c WHERE FAF_ID__c in: fafIds and FAF_ID__r.Data_Loading__c = false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Specialty_Operations__c sOps: spOpsList)
        { 
            if(fafnetworkMap.get(sOps.FAF_ID__c) >0){
             sOps.adderror('Cannot add more than One Specialty Operations to FAF');
            }        
              }
        }catch(Exception ex){
            for( Specialty_Operations__c so : spOpsList){
                so.adderror(ex.getDmlMessage(0));
            } 
        }
   }
         public static void updatePlatfrmSpecific(List<Specialty_Operations__c> spOpsList,Map<id,Specialty_Operations__c> oldspOpsList) {
        try{
            set<id> fafIds = new set<Id>();
            List<Platform_Specifics__c> psToUpdate = new List<Platform_Specifics__c>();
            for(Specialty_Operations__c sOps: spOpsList)
            {   
                if(oldspOpsList.get(sOps.id).Pharmacy_Benefit__c == 'Client Choice' && sOps.Pharmacy_Benefit__c != 'Client Choice'){
                    fafIds.add(sOps.FAF_ID__c);   
                  }         
            }       
            
            // WAM 10/28 - Modified 1 line and Added 1 line to eliminate SOQL Error            
            for(Platform_Specifics__c ps: [SELECT id,Specialty_Pharmacy_Benefit_Price_List__c FROM Platform_Specifics__c WHERE Specialty_Pharmacy_Benefit_Price_List__c <> null AND FAF_ID__c in: fafIds ]){
                ps.XAE__c = False;
                ps.Specialty_Pharmacy_Benefit_Price_List__c = null;
                psToUpdate.add(ps);
            }
            
            if(psToUpdate.size()>0){
                update psToUpdate;
            }
            
        }catch(Exception ex){
             
        }
   }
}