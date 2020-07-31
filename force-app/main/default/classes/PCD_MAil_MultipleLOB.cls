public class PCD_MAil_MultipleLOB {
    
     @AuraEnabled
    public static List<PCD_Multiple_LOB__c> get_AdditionalLOB(String Basealiid){
        try {
            List<PCD_Multiple_LOB__c> lstMultipleLOB = [
                select Id,Base_FAF_ID__c, Base_LOB__c, Base_LOB_ID__c, ALI_ID__c, Additional_FAF_ID__c,
                Additional_LOB__c, Additional_LOB_ID__c, Additional_LOB_Numeric_ID__c, Base_LOB_Numeric_ID__c, Additional_ALI_ID__c
                from PCD_Multiple_LOB__c where ALI_ID__c= :Basealiid order by Additional_LOB_Numeric_ID__c
            ];
            return lstMultipleLOB; 
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }   
    
    
     @AuraEnabled
    public static List<Mail_Pricing__c> get_MPLOB(String fafid){
       try {
            List<Mail_Pricing__c> lstMP= [select Id,name,Year__c,LOB__c,Custom_Description__c,Brand_Basis__c,Generic_Basis__c,Plan_Year__c from Mail_Pricing__c where FAF_ID__c= :fafid];
            return lstMP; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<LOB__c> get_allLOB(String Basealiid){
       try {
            List<LOB__c> lstallLOB =  new List<LOB__c>();
            Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c from  Apttus__AgreementLineItem__c where Id = :Basealiid
                                  ];                    
            if (lstali.Apttus__AgreementId__c != null)
             {  
              lstallLOB= [select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,FAF_Agreement_Line_Item__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                          where Agreement__c = :lstali.Apttus__AgreementId__c
                         ];   
            }                 
            return lstallLOB; 
            } 
        catch(exception e)
            {
            throw new AuraHandledException(e.getMessage());
            }
    }
    
    @AuraEnabled
    public static Boolean create_mlob(String Basealiid, List<String> mlob){
       try {
            List<PCD_Multiple_LOB__c> newmlob = new List<PCD_Multiple_LOB__c>();
            LOB__c lstallLOB = new LOB__c();
            system.debug('aa');
            Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c,LOB_ID__c from  Apttus__AgreementLineItem__c where Id = :Basealiid
                                  ];                    
            if (lstali.Apttus__AgreementId__c != null)
             {  
             system.debug('bb');
                lstallLOB = [select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                          where Agreement__c = :lstali.Apttus__AgreementId__c and Id = :lstali.LOB_ID__c
                         ];   
            } 
            system.debug('cc');
            List<LOB__c> lstallmLOB= [select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                          where Id IN :mlob
                         ];  
            system.debug('dd');             
            for (LOB__c lob : lstallmLOB)
            {
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
                                          
            return true; 
            } 
        catch(exception e)
            {
            throw new AuraHandledException(e.getMessage());
            }
    }
    
   
}