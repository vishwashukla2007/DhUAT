/* =================================================================================
 * @Class Name        : PCD_AdminFees_MultipleLOB
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/09/2020
 * @Purpose           : PCD_Specialty_MultipleLOB
=======================================================================================*/
global class PCD_AdminFees_MultipleLOB 
{
 
 @AuraEnabled
    global static List<PCD_Multiple_LOB__c> get_AdditionalLOB(String Basealiid){
       try {
            List<PCD_Multiple_LOB__c> lstMultipleLOB= [select Id,Base_FAF_ID__c,Base_LOB__r.LOB_Description__c,Base_LOB__c,Base_LOB_ID__c,ALI_ID__c,Additional_FAF_ID__c,Additional_LOB__c,Additional_LOB_ID__c,Additional_LOB_Numeric_ID__c,Base_LOB_Numeric_ID__c from PCD_Multiple_LOB__c where ALI_ID__c= :Basealiid order by Additional_LOB_Numeric_ID__c];
            return lstMultipleLOB; 
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
   
   /*  @AuraEnabled global static list<Billing_Administrative_Fees__c> get_BillingAdmindata(String fafid) 
    {
     List<Billing_Administrative_Fees__c> ba = new List<Billing_Administrative_Fees__c>();
     String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
     String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
     String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
     for (Billing_Administrative_Fees__c balst : [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c])
        {
         if (!Label.PCD_340B_Fee_Type.Contains(balst.Admin_Fee_Type__c) && !Label.PCD_Manual_Fee_Type.Contains(balst.Admin_Fee_Type__c) && !Label.EGWP_Per_Member_Per_Month.Contains(balst.Admin_Fee_Type__c)) 
          {
           ba.add(balst);
          }
        }
        return ba;
    } 
     @AuraEnabled
    global static list<Billing_Administrative_Fees__c> get_BillingAdmindatamanual(String fafid) 
    {
     List<Billing_Administrative_Fees__c> ba = new List<Billing_Administrative_Fees__c>();
     String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
     String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
     String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
     for (Billing_Administrative_Fees__c balst : [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c])
        {
         if (Label.PCD_Manual_Fee_Type.Contains(balst.Admin_Fee_Type__c)) 
          {
           ba.add(balst);
          }
        }
        return ba;
    }  
    
     @AuraEnabled
    global static list<Billing_Administrative_Fees__c> get_BillingAdmindata340b(String fafid) 
    {
     List<Billing_Administrative_Fees__c> ba = new List<Billing_Administrative_Fees__c>();
     String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
     String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
     String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
     for (Billing_Administrative_Fees__c balst : [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c])
        {
         if (Label.PCD_340B_Fee_Type.Contains(balst.Admin_Fee_Type__c)) 
          {
           ba.add(balst);
          }
        }
        return ba;
    } */ 
    /***************************************Electronic Fees Wrapper***********************************************/
    public class AdminWrapper {
        @AuraEnabled public list<AdminWrapperNested> splist;
        @AuraEnabled public String AdminName;
        @AuraEnabled public Boolean ischecked;
    }
     public class AdminWrapperNested {
        @AuraEnabled public Billing_Administrative_Fees__c sp;
        @AuraEnabled public Boolean isclick;
    }
    @AuraEnabled
    public static List<AdminWrapper> get_AdminWrapperList(String fafid){
     System.debug('FAF+++++++++++++'+fafId);
        List<AdminWrapper> wrapperList = new List<AdminWrapper>();
        Map<String, List<AdminWrapperNested>> npMap = new Map<String, List<AdminWrapperNested>>();
        List<AdminWrapperNested> NestedList = new List<AdminWrapperNested>();
         String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
        String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
        String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
        
        list<Billing_Administrative_Fees__c> splist = [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c
        ];
        System.debug('Billling List +++++++++++++'+splist);
        for(Billing_Administrative_Fees__c np :splist){
            if (!Label.PCD_340B_Fee_Type.Contains(np.Admin_Fee_Type__c) && !Label.PCD_Manual_Fee_Type.Contains(np.Admin_Fee_Type__c) && !Label.EGWP_Per_Member_Per_Month.Contains(np.Admin_Fee_Type__c)){ 
                 System.debug('In condition++++++++++++'+splist);
                if(String.isNotBlank(np.Admin_Fee_Type__c)){
                    if(npMap.containsKey(np.Admin_Fee_Type__c)){
                        List<AdminWrapperNested> temp = new List<AdminWrapperNested>();
                        AdminWrapperNested nt=new AdminWrapperNested();
                        nt.sp=np;
                        nt.isclick=false;
                        temp.add(nt);
                        npMap.get(np.Admin_Fee_Type__c).add(nt);
                    }else {
                        List<AdminWrapperNested> temp = new List<AdminWrapperNested>();
                        AdminWrapperNested nt=new AdminWrapperNested();
                        nt.sp=np;
                        nt.isclick=false;
                        temp.add(nt);
                        npMap.put(np.Admin_Fee_Type__c, temp);
                    }
                }
           }
        }
        for(String npName :npMap.keySet()){
            AdminWrapper nw = new AdminWrapper();
            nw.AdminName = npName;
            nw.splist = npMap.get(npName);
            nw.ischecked=false;
            wrapperList.add(nw);
        }
        return wrapperList;
    }
    /***************************************3040 B Fees Wrapper***********************************************/
     public class Admin340Wrapper {
        @AuraEnabled public list<Admin340WrapperNested> splist;
        @AuraEnabled public String AdminName;
        @AuraEnabled public Boolean ischecked;
    }
     public class Admin340WrapperNested {
        @AuraEnabled public Billing_Administrative_Fees__c sp;
        @AuraEnabled public Boolean isclick;
    }
    @AuraEnabled
    public static List<Admin340Wrapper> get_Admin340WrapperList(String fafid){
     System.debug('FAF+++++++++++++'+fafId);
        List<Admin340Wrapper> wrapperList = new List<Admin340Wrapper>();
        Map<String, List<Admin340WrapperNested>> npMap = new Map<String, List<Admin340WrapperNested>>();
        List<Admin340WrapperNested> NestedList = new List<Admin340WrapperNested>();
        String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
        String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
        String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
        
        list<Billing_Administrative_Fees__c> splist = [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c];
        System.debug('Billling List +++++++++++++'+splist);
        for(Billing_Administrative_Fees__c np :splist){
           if (Label.PCD_340B_Fee_Type.Contains(np.Admin_Fee_Type__c)) { 
                 System.debug('In condition++++++++++++'+splist);
                if(String.isNotBlank(np.Admin_Fee_Type__c)){
                    if(npMap.containsKey(np.Admin_Fee_Type__c)){
                        List<Admin340WrapperNested> temp = new List<Admin340WrapperNested>();
                        Admin340WrapperNested nt=new Admin340WrapperNested();
                        nt.sp=np;
                        nt.isclick=false;
                        temp.add(nt);
                        npMap.get(np.Admin_Fee_Type__c).add(nt);
                    }else {
                        List<Admin340WrapperNested> temp = new List<Admin340WrapperNested>();
                        Admin340WrapperNested nt=new Admin340WrapperNested();
                        nt.sp=np;
                        nt.isclick=false;
                        temp.add(nt);
                        npMap.put(np.Admin_Fee_Type__c, temp);
                    }
                }
           }
        }
        for(String npName :npMap.keySet()){
            Admin340Wrapper nw = new Admin340Wrapper();
            nw.AdminName = npName;
            nw.splist = npMap.get(npName);
            nw.ischecked=false;
            wrapperList.add(nw);
        }
        return wrapperList;
    }
     /***************************************Manual Fees Wrapper***********************************************/
     public class AdminManualWrapper {
        @AuraEnabled public list<AdminManualWrapperNested> splist;
        @AuraEnabled public String AdminName;
        @AuraEnabled public Boolean ischecked;
    }
     public class AdminManualWrapperNested {
        @AuraEnabled public Billing_Administrative_Fees__c sp;
        @AuraEnabled public Boolean isclick;
    }
    @AuraEnabled
    public static List<AdminManualWrapper> get_AdminManualWrapperList(String fafid){
     System.debug('FAF+++++++++++++'+fafId);
        List<AdminManualWrapper> wrapperList = new List<AdminManualWrapper>();
        Map<String, List<AdminManualWrapperNested>> npMap = new Map<String, List<AdminManualWrapperNested>>();
        List<AdminManualWrapperNested> NestedList = new List<AdminManualWrapperNested>();
        String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
        String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
        String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
        
        list<Billing_Administrative_Fees__c> splist = [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c];
        
        for(Billing_Administrative_Fees__c np :splist){
            if (Label.PCD_Manual_Fee_Type.Contains(np.Admin_Fee_Type__c)){ 
                 System.debug('In condition++++++++++++'+splist);
                if(String.isNotBlank(np.Admin_Fee_Type__c)){
                    if(npMap.containsKey(np.Admin_Fee_Type__c)){
                        List<AdminManualWrapperNested> temp = new List<AdminManualWrapperNested>();
                        AdminManualWrapperNested nt=new AdminManualWrapperNested();
                        nt.sp=np;
                        nt.isclick=false;
                        temp.add(nt);
                        npMap.get(np.Admin_Fee_Type__c).add(nt);
                    }else {
                        List<AdminManualWrapperNested> temp = new List<AdminManualWrapperNested>();
                        AdminManualWrapperNested nt=new AdminManualWrapperNested();
                        nt.sp=np;
                        nt.isclick=false;
                        temp.add(nt);
                        npMap.put(np.Admin_Fee_Type__c, temp);
                    }
                }
           }
        }
        for(String npName :npMap.keySet()){
            AdminManualWrapper nw = new AdminManualWrapper();
            nw.AdminName = npName;
            nw.splist = npMap.get(npName);
            nw.ischecked=false;
            wrapperList.add(nw);
        }
        return wrapperList;
    }
    
  
    }