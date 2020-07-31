public with sharing class PlatformSpecificTriggerHelper {

    public static void validateXAERecords(List<Platform_Specifics__c> PlatformspecificList, Boolean isInsertBool, Boolean isUpdateBool) { 
        if (isInsertBool == true || isUpdateBool == true) {
            boolean ErrorFlag = false;
            Map<Id,SObject> Rops = new Map<Id,SObject>([Select Id,Name,FAF_ID__c from Rebate_Operations__c]);
            for( Platform_Specifics__c ps : PlatformspecificList){
// 
// Update Rebate Ops Lookups on PS record
//     
                if (ps.Bulk_Update__c == TRUE) 
                    return;      
                if (ps.Copy_Pending__c == false) {
                if (ps.Rebate_Operations__c == null){
                    system.debug('::Query Rebate Ops::'+ps.FAF_ID__c); 
                    for(SObject ro: Rops.values())
                    {
                        if (ro.get('FAF_ID__c') ==  ps.FAF_ID__c)                  
                           ps.Rebate_Operations__c = ro.Id;                    
                    }
                }            
                if (ps.DeleteRow__c != true && ps.XAE__c == true) {
                if (ps.Instruction__c == null || ps.Platform__c == null || ps.LOB__c == null || ps.Level_1_ID_XAE__c == null){
                    ps.adderror('Platform, LOB, Instruction, and Level 1 ID are required.');
                }
                else
                {            
//                            
// Search CAG for matching Carrier record.  If found update the Level_1_Record_ID__c and Level1_Name__c fields
//
                system.debug('::Platform__c::'+ps.Platform__c ); 
                system.debug('::Level_1_ID_XAE__c::'+ps.Level_1_ID_XAE__c); 
                system.debug('::Level_2_ID_XAE__c::'+ps.Level_2_ID_XAE__c); 
                system.debug('::Level_3_ID_XAE__c::'+ps.Level_3_ID_XAE__c);                                                                                     
                if (ps.Level_1_ID_XAE__c != null) {             
                   List<CAG__c> CAGList = [SELECT Id, Record_Type__c, Carrier_ID__c, Carrier_Name__c, Platform_Name__c,Account_ID__c, Group_ID__c from CAG__c WHERE Carrier_ID__c=:ps.Level_1_ID_XAE__c AND Record_Type__c= 'C' AND Platform_Name__c =:ps.Platform__c];
                   if(CAGList == null || CAGList.isEmpty() == true ) {
                       system.debug('::Not Found Level 1::'+ps.Level_1_ID_XAE__c);                                         
                       ps.adderror('Invalid Level 1 ID.');
                       ErrorFlag=true;
                   }
                   else
                   {
                       system.debug('::Found:: Level 1');    
                       for(CAG__c cl: CAGList) 
                       {
                            ps.Level_1_Record_ID__c = cl.Id;
                            ps.Level1_Name__c = cl.Carrier_Name__c;
                            system.debug('::Assigned::' + cl.Id);                               
                       }
                       
                   }
                }
                if (ps.Level_2_ID_XAE__c != null && ps.Level_1_ID_XAE__c != null && ErrorFlag == false) {
//                            
// Search CAG for matching Account record.  If found update the Level_2_Record_ID__c field
                   List<CAG__c> CAGList = [SELECT Id, Record_Type__c, Carrier_ID__c, Carrier_Name__c, Platform_Name__c, Account_ID__c, Account_Name__c, Group_ID__c from CAG__c WHERE Account_ID__c=:ps.Level_2_ID_XAE__c AND Carrier_ID__c=:ps.Level_1_ID_XAE__c AND Record_Type__c= 'A' AND Platform_Name__c =:ps.Platform__c];
                   if(CAGList == null || CAGList.isEmpty() == true) {
                       system.debug('::Not Found Level 2::'+ps.Level_2_ID_XAE__c);                                         
                       ps.adderror('Invalid Level 2 ID.');
                       ErrorFlag=true;
                   }
                   else
                   {
                       system.debug('::Found:: Level 2'); 
                       for(CAG__c cl: CAGList) 
                       {
                            ps.Level_2_Record_ID__c = cl.Id;
                            ps.Level2_Name__c = cl.Account_Name__c;
                       }
                       
                   }              
                }
                if (ps.Level_3_ID_XAE__c != null && ps.Level_2_ID_XAE__c == null && ErrorFlag == false) {
                    ps.adderror('Level 2 ID is required to populate Level 3 ID.');
                    ErrorFlag=true;
                }
                
                if (ps.Level_1_ID_XAE__c != null && ps.Level_3_ID_XAE__c != null && ps.Level_2_ID_XAE__c != null && ErrorFlag == false) {
// Search CAG for matching Group record.  If found update the Level_1_Record_ID__c field
                   List<CAG__c> CAGList = [SELECT Id, Record_Type__c, Carrier_ID__c, Carrier_Name__c, Platform_Name__c, Account_ID__c, Account_Name__c, Group_ID__c, Group_Name__c from CAG__c WHERE Carrier_ID__c=:ps.Level_1_ID_XAE__c AND Account_ID__c=:ps.Level_2_ID_XAE__c AND Group_ID__c=:ps.Level_3_ID_XAE__c AND Record_Type__c= 'G' AND Platform_Name__c =:ps.Platform__c];
                   if(CAGList == null || CAGList.isEmpty() == true) { 
                       system.debug('::Not Found Level 3::'+ps.Level_3_ID_XAE__c);                                        
                       ps.adderror('Invalid Level 3 ID.');
                       ErrorFlag=true;
                   }
                   else
                   {
                       system.debug('::Found:: Level 3'); 
                       for(CAG__c cl: CAGList) 
                       {
                            ps.Level_3_Record_ID__c = cl.Id;
                            ps.Level3_Name__c = cl.Group_Name__c;
                       }
                       
                   }                 
                }
                }
              }
                                                
            }           
        }
        }
        
    }   
    public static boolean BulkUpdate(List<Platform_Specifics__c> PSList) {
    for(Platform_Specifics__c ps : PSList){
        return ps.Bulk_Update__c;
    }
    return false;
    }     
    public static void DeleteXAE(List<Platform_Specifics__c> PSList, Boolean isInsertBool, Boolean isUpdateBool) {
            for( Platform_Specifics__c ps : PSList){
            
                if (ps.Bulk_Update__c == TRUE) 
                    return;                            
                if (ps.DeleteRow__c == true && ps.XAE__c == true) {
                
                     list<Platform_Specifics__c> bae= [select id from Platform_Specifics__c where id =: ps.id];             
                     delete bae;    
                }            
            }    
    }
    
    public static void updateclientinfo(List<Platform_Specifics__c> PlatformspecificList)
     {
     try{
      List<Client_Information__c> clientInfoupdate = new List<Client_Information__c>();
        for(Platform_Specifics__c ps: PlatformspecificList) 
            {
            
             List<Client_Information__c> CIList = [SELECT Id, Release_FAF__c from Client_Information__c where Id=:ps.FAF_Client_Information__c and Release_FAF__c = True];
              if(CIList != null && !CIList.isEmpty())  
              {
                for(Client_Information__c ci: CIList ) 
                    {
                     ci.Release_FAF__c = false;
                     clientInfoupdate.add(ci);
                    }
              }             
            }
         if (clientInfoupdate != null && !clientInfoupdate.isEmpty())
         {
           update clientInfoupdate;
         }
         Config_Validation_for_Clientinfo__c dv = Config_Validation_for_Clientinfo__c.getOrgDefaults();
         dv.By_Pass_CI_Validation__c = true;
         upsert dv; 
        }
        catch(Exception ex){
        // changes by Mohit Srivastava :X-Author Excel Catch Defect
            string catchUrl=String.valueOf(System.URL.getCurrentRequestUrl());
            for( Platform_Specifics__c ps : PlatformspecificList){
                if(catchUrl.contains('/apex/')){
                    ps.adderror(ex.getDmlMessage(0));
                }
                else{
                system.debug('XAE Exception');
                }
            } 
        } 
     }
     
     public static void afterupdateclientinfo(List<Platform_Specifics__c> PlatformspecificList)
     {
         /*Disable_Validation_AccountSubtype__c dv = Disable_Validation_AccountSubtype__c.getOrgDefaults();
         dv.Disable_Validation__c = false;
         upsert dv; */
     }

    public static void validatduplicateRecords(List<Platform_Specifics__c> PlatformspecificList, Boolean isInsertBool, Boolean isUpdateBool) {
        
            set<Id> clientInfoIds= new set<Id>();
            set<id> currentPSIds=new set<Id>();
            Map<string,string> uniqueKeyandRecordLinkMap=new Map<string,string>();
            //storing key fields we will using for comparision
//            string keyFields= 'FAF_Client_Information__c,LOB__c,Level_1_ID__c,Level_2_ID__c,Level_3_ID__c,Instruction__c,Platform__c,Specialty_Pharmacy_Benefit_Price_List__c,Non_Specialty_Formulary_Choice__c,NonSpecialtyFormularyRebateEndDate__c,Specialty_Formulary_Choice__c,SpecialtyFormularyEndDate__c,GSTP_Choice__c,GSTPEndDate__c,Termed_Date__c,EffectiveDate__c';
            string keyFields= 'FAF_Client_Information__c,LOB__c,Level_1_Record_ID__c,Level_2_Record_ID__c,Level_3_Record_ID__c,Instruction__c,Platform__c,Specialty_Pharmacy_Benefit_Price_List__c,Non_Specialty_Formulary_Choice__c,NonSpecialtyFormularyRebateEndDate__c,Specialty_Formulary_Choice__c,SpecialtyFormularyEndDate__c,GSTP_Choice__c,GSTPEndDate__c,Termed_Date__c,EffectiveDate__c';
            string KeyFields1='NonSpecialtyFormularyEffectiveDate__c,SpecialtyFormularyEffectiveDate__c,GSTPEffectiveDate__c';
            List<string> keyFieldsList=keyFields.split(',',-1);
            List<string> keyFieldsList1=keyFields1.split(',',-1);
           
            //get client info Ids and current PS record Ids to fetch exisitng records           
            for(Platform_Specifics__c ps: PlatformspecificList) {
                if (ps.Bulk_Update__c == TRUE) 
                    return;  
                if (ps.Copy_Pending__c == false){
                    clientInfoIds.add(ps.FAF_Client_Information__c);  
                 }
                 if(ps.Id!=null){
                     currentPSIds.add(ps.Id);
                 }               
            }
            
            //query existing platfrom specific records and generate uniqueKeyMap
            if(!clientInfoIds.isempty()){
                    List<Platform_Specifics__c> psExistingList = [SELECT Id,FAF_Client_Information__c,LOB__c,Level_3_ID__c ,Level_2_ID__c ,Level_1_ID__c,Instruction__c,Platform__c, Level_1_Record_ID__r.Carrier_ID__c, Level_1_Record_ID__c, Level_2_record_ID__c, Level_3_record_ID__c,
                                                          Specialty_Pharmacy_Benefit_Price_List__c, Non_Specialty_Formulary_Choice__c, NonSpecialtyFormularyEffectiveDate__c, NonSpecialtyFormularyRebateEndDate__c, Specialty_Formulary_Choice__c, SpecialtyFormularyEffectiveDate__c, SpecialtyFormularyEndDate__c,
                                                          GSTP_Choice__c, GSTPEffectiveDate__c, GSTPEndDate__c, Termed_Date__c, EffectiveDate__c,
                                                          FAF_ID__r.Name,FAF_Client_Information__r.Name,Name
                                                          FROM Platform_Specifics__c WHERE FAF_Client_Information__c IN: clientInfoIds and Id NOT IN: currentPSIds and FAF_ID__c!=null];
               if(!psExistingList.isEmpty()){
                   for(Platform_Specifics__c pe:psExistingList){
                       string unquieString='';
                       for(string s:keyFieldsList){
                               string tempVal=(pe.get(s)!=null && string.valueof(pe.get(s))!='' )? string.valueOf(pe.get(s)) : '--None--';
                               unquieString =unquieString + tempVal;
                       }
                       for(string s:keyFieldsList1){
                           string peeffetivedate=(pe.get('EffectiveDate__c')!=null && string.valueof(pe.get('EffectiveDate__c'))!='') ?string.valueof(pe.get('EffectiveDate__c')):'--None--';
                           string tempVal=(pe.get(s)!=null && string.valueof(pe.get(s))!='' )? string.valueOf(pe.get(s)) :peeffetivedate;
                           unquieString =unquieString + tempVal;
                       }
                       if(unquieString!=''){
                              string RecordLink= 'FAF: '+pe.FAF_ID__r.Name+' - '+'Client Info: '+pe.FAF_Client_Information__r.Name+' - '+'Platform Specific: '+pe.Name;
                              uniqueKeyandRecordLinkMap.put(unquieString,RecordLink); 
                       }
                   }     
                    
               } 
            }
            
            //check current create/update PS records match with existing records and if so display error.
            if(uniqueKeyandRecordLinkMap.size()>0){
                for(Platform_Specifics__c ps: PlatformspecificList) {                   
                    if (ps.Copy_Pending__c == false){
                              string unquieString='';
                              for(string s:keyFieldsList){
                                     string tempVal=(ps.get(s)!=null && string.valueof(ps.get(s))!='')? string.valueOf(ps.get(s)) : '--None--';
                                     unquieString =unquieString + tempVal;
                               }  
                               for(string s:keyFieldsList1){
                                   string peeffetivedate=(ps.get('EffectiveDate__c')!=null && string.valueof(ps.get('EffectiveDate__c'))!='') ?string.valueof(ps.get('EffectiveDate__c')):'--None--';
                                   string tempVal=(ps.get(s)!=null && string.valueof(ps.get(s))!='' )? string.valueOf(ps.get(s)) :peeffetivedate;
                                    unquieString =unquieString + tempVal;
                               }
                               system.debug('::unquieString Check::'+unquieString);  
                               if( unquieString!= '' && uniqueKeyandRecordLinkMap.containsKey(unquieString )){ 
                                    ps.addError('Platform Specifics record already exists with this information, please review "'+uniqueKeyandRecordLinkMap.get(unquieString )+'"');
                               }
                    }
                 }
                
            } 
            
        }
        
     public static void updateEffectivedates(List<Platform_Specifics__c> PlatformspecificList){
        
       
         List<Id> clientInfoIds = new List<Id>();
         List<Id> fafIds = new List<Id>();
         Map<Id,Rebate_Operations__c> rebateMap = new Map<Id,Rebate_Operations__c>();
         
         for(Platform_Specifics__c platformSpecific: PlatformspecificList)  {
         
            clientInfoIds.add(platformSpecific.FAF_Client_Information__c);
            fafIds.add(platformSpecific.FAF_ID__c);
         }
         
         Map<id,Client_Information__c> clientinfoMap = new Map<id,Client_Information__c>([select id,FAF_ID__c,Client_Subtype__c,Pricing_Effective_Date__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where id in:clientInfoIds]);
           
           List<Rebate_Operations__c> rOpsList = [select id,GSTP_Option__c,FAF_ID__c,Specialty_Formulary_Option__c,Non_Specialty_Formulary_Option__c from Rebate_Operations__c where FAF_ID__c in:fafIds];
           if(!rOpsList.isempty()){
                for(Rebate_Operations__c rebate: rOpsList) {
                     rebateMap.put(rebate.FAF_ID__c,rebate);
                  }
               }   
         
         for(Platform_Specifics__c platformSpecific: PlatformspecificList)  {
      
          if(platformSpecific.EffectiveDate__c!= null && platformSpecific.DifferentGSTPFormularyEffectiveDates__c == false){
              
              if(rebateMap.containskey(platformSpecific.FAF_ID__c)){
              
                  String  clientSubType = clientinfoMap.get(platformSpecific.FAF_Client_Information__c).Client_Subtype__c;
                  
                  Rebate_Operations__c rOperations = rebateMap.get(platformSpecific.FAF_ID__c);
                                       
                  
                  if(rOperations.Non_Specialty_Formulary_Option__c == 'Client Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                    platformSpecific.NonSpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c;
                  }
                  
                   if(rOperations.GSTP_Option__c == 'Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                   platformSpecific.GSTPEffectiveDate__c = platformSpecific.EffectiveDate__c;             
                  } 
              
                   if(rOperations.Specialty_Formulary_Option__c == 'Client Choice'  && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                       platformSpecific.SpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c;             
                      }
                  
              }
          }
          
      }
        
        
     }
      //Description: Close the IPI WA tasks, When Platform Specifics(PS) record is added after the FAF Status is set to 'Implemented'. UserStory - 183 in PT, added by Sneha Inturi. 
   public static void UpdateIPIWAstatus(List<Platform_Specifics__c > PSnew,List<Platform_Specifics__c > PSold,Boolean isUpdate) {
     for(Platform_Specifics__c ps: PSnew) {
        if (ps.Bulk_Update__c == TRUE) 
            return;  
     }
        //figure out action is insert or update
        set<id> EPSids=new set<id>();
    
        //get first eligible PS records
        for(integer i=0;i<PSnew.size();i++){
            if(PSnew[i].FAF_ID__c!=null && PSnew[i].Level_1_ID__c!=null && PSnew[i].EffectiveDate__c!=null &&
                ( !isUpdate  || ( isUpdate && (PSnew[i].Level_1_ID__c!= PSold[i].Level_1_ID__c || PSnew[i].EffectiveDate__c!= PSold[i].EffectiveDate__c) ) )){
                    EPSids.add(PSnew[i].id);
                }
        }
    
        //filter down to only PS that has FAF status implemented.
        List<Platform_Specifics__c > PSFinallist=new List<Platform_Specifics__c >();
        PSFinallist=[select id,FAF_ID__r.name,Level_1_ID__c,EffectiveDate__c from Platform_Specifics__c where id in:EPSids and FAF_ID__r.FAF_Status__c='Implemented'];

        //exceute if there are any PS remaing after 2 filterations
        if(PSFinallist.size()>0){
                Map<string,Platform_Specifics__c> PSMAP=new Map<string,Platform_Specifics__c>();
                set<string> L1Ids=new set<string>();
                set<date> Edates=new set<date>();
                for(Platform_Specifics__c p:PSFinallist){
                    L1Ids.add(p.Level_1_ID__c);
                    Edates.add(p.EffectiveDate__c);
                    PSMAP.put(p.Level_1_ID__c+string.valueOf(p.EffectiveDate__c),p);
                }
                
                //Query tasks and update status to resloved-complete.
                List<IPI_WA_Tasks__c> IPIWAupdateList=new list<IPI_WA_Tasks__c>();
                for(IPI_WA_Tasks__c w:[select id,Pricing_Effective_Date__c,Carrier_ID__c from IPI_WA_Tasks__c where  Pricing_Effective_Date__c IN: Edates and Carrier_ID__c IN: L1Ids]){
                         if(PSMAP.containsKey(w.Carrier_ID__c+string.valueOf(w.Pricing_Effective_Date__c))){
                                    Platform_Specifics__c  p=PSMAP.get(w.Carrier_ID__c+string.valueOf(w.Pricing_Effective_Date__c));
                                    w.FAF_ID__c = p.FAF_ID__r.name ;
                                    w.Task_Status__c = 'Resolved-Complete';
                                    w.Transaction_Complete_Timestamp__c = System.now();
                                    IPIWAupdateList.add(w);
                                }
                } 
                                            
                if(IPIWAupdateList.size() >0)
                    Update IPIWAupdateList;       
        }
            
      }
   }