/* =================================================================================
 * @Class Name        : PCD_Specialty_MultipleLOB
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/09/2020
 * @Purpose           : PCD_Specialty_MultipleLOB
=======================================================================================*/
public class PCD_Specialty_MultipleLOB 
{
 
 @AuraEnabled
    public static List<PCD_Multiple_LOB__c> get_AdditionalLOB(String Basealiid){
       try {
            List<PCD_Multiple_LOB__c> lstMultipleLOB= [select Id,Base_FAF_ID__c,Base_LOB__c,Base_LOB__r.LOB_Description__c,Base_LOB_ID__c,ALI_ID__c,Additional_FAF_ID__c,Additional_LOB__c,Additional_LOB_ID__c,Additional_LOB_Numeric_ID__c,Base_LOB_Numeric_ID__c from PCD_Multiple_LOB__c where ALI_ID__c= :Basealiid order by Additional_LOB_Numeric_ID__c];
            return lstMultipleLOB; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
   @AuraEnabled
    public static List<Specialty_Pricing__c> get_SPLOB(String fafid){
       try {
            List<Specialty_Pricing__c> lstSpecialty= [select Id,FAF_ID__c,name,Year__c,LOB__c,Custom_Description__c,Pharmacy_Benefit__c from Specialty_Pricing__c where FAF_ID__c= :fafid];
            return lstSpecialty; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    } 
    @AuraEnabled
    public static List<Specialty_Pricing__c> SpecialtyDataPharmacy(String fafid,String Pharmacy){
       try {
            List<Specialty_Pricing__c> lstSpecialty= [select Id,FAF_ID__c,name,Year__c,LOB__c,Custom_Description__c,Pharmacy_Benefit__c from Specialty_Pricing__c where FAF_ID__c= :fafid order BY Pharmacy_Benefit__c ];
            return lstSpecialty; 
            } 
        catch(exception e)
        {
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
     public class SpecialtyWrapper {
        @AuraEnabled public list<SpecialtyWrapperNested> splist;
        @AuraEnabled public String BenefitName;
        @AuraEnabled public Boolean ischecked;
    }
     public class SpecialtyWrapperNested {
        @AuraEnabled public Specialty_Pricing__c sp;
        @AuraEnabled public Boolean isclick;
    }
    @AuraEnabled
    public static List<SpecialtyWrapper> get_SpecialtyWrapperList(String fafId){
        List<SpecialtyWrapper> wrapperList = new List<SpecialtyWrapper>();
        Map<String, List<SpecialtyWrapperNested>> npMap = new Map<String, List<SpecialtyWrapperNested>>();
        List<SpecialtyWrapperNested> NestedList = new List<SpecialtyWrapperNested>();
        
        list<Specialty_Pricing__c> splist = [
            Select Id, Year__c,LOB__c, Pharmacy_Benefit__c, Price_List__c,Pharmacy_Benefit_Text__c,Generic_Basis__c, Brand_Basis__c, FAF_ID__c
            From Specialty_Pricing__c
            Where FAF_ID__c = :fafId and Pharmacy_Benefit__c!='None' order by Year__c
        ];
        for(Specialty_Pricing__c np :splist){
            if(String.isNotBlank(np.Pharmacy_Benefit__c)){
                if(npMap.containsKey(np.Pharmacy_Benefit__c)){
                    List<SpecialtyWrapperNested> temp = new List<SpecialtyWrapperNested>();
                    SpecialtyWrapperNested nt=new SpecialtyWrapperNested();
                    nt.sp=np;
                    nt.isclick=false;
                    temp.add(nt);
                    npMap.get(np.Pharmacy_Benefit__c).add(nt);
                } else {
                    List<SpecialtyWrapperNested> temp = new List<SpecialtyWrapperNested>();
                    SpecialtyWrapperNested nt=new SpecialtyWrapperNested();
                    nt.sp=np;
                    nt.isclick=false;
                    temp.add(nt);
                    npMap.put(np.Pharmacy_Benefit__c, temp);
                }
            }
        }
        for(String npName :npMap.keySet()){
            SpecialtyWrapper nw = new SpecialtyWrapper();
            nw.BenefitName = npName;
            nw.splist = npMap.get(npName);
            nw.ischecked=false;
            wrapperList.add(nw);
        }
        return wrapperList;
    }
     @AuraEnabled
    public static void createMultipleLob(String Basealiid, String basefafId, String baseLobId, String selectedLobId, String baselobDesId){
        try {
            List<LOB__c> lobList = [Select Id, FAF__c, LOB_Description__c, Client_Pricing_Offer__c from LOB__c Where Id = :selectedLobId];
            if(!lobList.isEmpty()){
                PCD_Multiple_LOB__c multiplelob = new PCD_Multiple_LOB__c();
                multiplelob.Additional_FAF_ID__c = lobList[0].FAF__c;
                multiplelob.Additional_LOB_ID__c = lobList[0].LOB_Description__c;
                multiplelob.Additional_LOB__c = lobList[0].Id;
                multiplelob.Base_FAF_ID__c = basefafId;
                multiplelob.Base_LOB_ID__c = baselobDesId;
                multiplelob.Base_LOB__c = baseLobId;
                insert multiplelob;
            }
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }   
    @AuraEnabled
    public static Boolean create_mlob(String Basealiid, List<String> mlob){
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
                where Id IN :mlob
            ];  
            system.debug('dd');             
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
            return true; 
        } catch(exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }    
    
    
}