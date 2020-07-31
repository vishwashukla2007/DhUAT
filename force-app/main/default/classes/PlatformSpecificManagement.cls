public class PlatformSpecificManagement{
    
    public list<PlatFormSpecificItem> platformSpecifics{get;set;}
    
    public Boolean isEditEnabled {set;get;}
    public Boolean isNewEnabled {set;get;}    
    public String clientInfoId{set;get;}
    public String fafId{set;get;}
    
    public Static list<SelectOption> platformOptions = UtilClass.getPicklistValues('Platform_Specifics__c', 'Platform__c');
    public Static list<SelectOption> lobOptions = UtilClass.getPicklistValues('Platform_Specifics__c', 'LOB__c');
    public Static list<SelectOption> instructionOptions = UtilClass.getPicklistValues('Platform_Specifics__c', 'Instruction__c');
    
    public PlatformSpecificManagement(ApexPages.StandardController controller) {
        
        clientInfoId = Apexpages.currentPage().getParameters().get('ClientInfoId');
        fafId = Apexpages.currentPage().getParameters().get('fafId');
        isEditEnabled =  false;
        isNewEnabled = false;
        
        
        loadData();
    }
    
/*=================================================================================
 * @Method Name       : getTotalPlatformSpecific
 * @author            : Sonal Sharma(Accenture)
 * @created date      : 02/17/2020
 * @Last modified by  : Sonal Sharma(Accenture)
 * @Purpose           : Total number of platform Specific records on client info
=======================================================================================*/
    @AuraEnabled
    public static Integer getTotalPlatformSpecific(ID clientId){
        try{
            List<Platform_Specifics__c> count= new List<Platform_Specifics__c>();
            //if (clientId != null && clientId != 'undefined'){
                count=[select id from Platform_Specifics__c where FAF_Client_Information__c =: clientId];
            
            return count.size();
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
          /*=================================================================================
 * @Method Name       : findByCagID
 * @author            : Sonal Sharma(Accenture)
 * @created date      : 02/17/2020
 * @Last modified by  : Sonal Sharma(Accenture)
 * @Purpose           : Search platformSpecifc record by CAg id.
=======================================================================================*/
 @AuraEnabled
    public static String findByCagID(ID clientId,Integer pageNo,String searchCagKey, String level, String sortField, boolean isAsc) {
        //List<Platform_Specifics__c> p= new List<Platform_Specifics__c> ();
        ID clientInfoRecId=clientId;
        String retrnData='';
        String levelId='';
        //List < Platform_Specifics__c> returnList = new List < Platform_Specifics__c> ();
        if(!String.isEmpty(searchCagKey)){
            levelId = searchCagKey + '%';
        }
        String level1='LEVEL 1 ID';
        String level2='LEVEL 2 ID';
        String level3='LEVEL 3 ID';
        
        
        String queryStr='Select Id, Name,Specialty_Pharmacy_Benefit_Price_List__c, FAF_Client_Information__r.FAF_ID__r.Name, FAF_Client_Information__r.Name,FAF_Client_Information__r.FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c, Platform__c, LOB__c, Link__c, Instruction__c, Level_1_ID__c, Level_1_Record_ID__c, Level_1_Record_ID__r.Name,Level_1_Record_ID__r.Carrier_ID__c,Level_2_Record_ID__r.Carrier_ID__c,Level_3_Record_ID__r.Carrier_ID__c, Level_2_record_ID__c, Level_2_record_ID__r.Name, Level_3_record_ID__c, Level_3_record_ID__r.Name,'; 
                queryStr+=' Level_2_ID__c, Level_3_ID__c, EffectiveDate__c,Termed__c, Termed_Date__c, Specialty_Pharmacy_Benefit__c, Specialty_Price_List__c, DifferentGSTPFormularyEffectiveDates__c, Level1_Name__c,Non_Specialty_Formulary_Choice__c, NonSpecialtyFormularyEffectiveDate__c, NonSpecialtyFormularyRebateEndDate__c, GSTP_Choice__c, GSTPEffectiveDate__c, GSTPEndDate__c, Specialty_Formulary_Choice__c, SpecialtyFormularyEffectiveDate__c, SpecialtyFormularyEndDate__c,FAF_Client_Information__c, CAG_ID__c,';
                queryStr+= ' Rebate_Operations__c,Rebate_Operations__r.GSTP_Option__c,Rebate_Operations__r.Specialty_Formulary_Option__c,Rebate_Operations__r.Non_Specialty_Formulary_Option__c from Platform_Specifics__c where FAF_Client_Information__c=:clientInfoRecId ';
        
        if(!String.isEmpty(levelId)){
            if(level.equals(level1)){
                queryStr+=' AND  Level_1_ID__c  LIKE:levelId';
                
            }
                
                //if level 2 is selected for cag id.
            else if(level.equals(level2)){
                queryStr+=' AND  Level_2_ID__c  LIKE:levelId';
     
            }
            else if(level.equals(level3)){
                queryStr+=' AND  Level_3_ID__c LIKE:levelId';

            }
        }
        
        if (sortField != '' && sortField!=null) {
             queryStr += ' order by '+ sortField;
     
        // if isAsc is equal to true then set 'asc' order otherwise set 'desc' order.
             if (isAsc) {
                queryStr += ' asc, CreatedDate Asc';
             } else {
                queryStr += ' desc, CreatedDate Desc NULLS LAST';
             }
        }
        else{
             queryStr+=' ORDER BY LastModifiedDate DESC';
        }
        ApexPages.StandardSetController ssc  = new ApexPages.StandardSetController(database.getQueryLocator(queryStr));
        retrnData=returnSeralizedString(ssc,clientInfoRecId, pageNo); 
        return retrnData;
    }

/*=================================================================================
 * @Method Name       : returnSeralizedString
 * @author            : Sonal Sharma(Accenture)
 * @created date      : 02/27/2020
 * @Last modified by  : Sonal Sharma(Accenture)
 * @Purpose           : method to return serialized data to findByCagID method
=======================================================================================*/
   public static String returnSeralizedString(ApexPages.StandardSetController ssc, ID clientInfoRecId,Integer pageNo){
        String retrnData='';
         PlatformSpecificData data=new PlatformSpecificData();
         Boolean nsfSectionRequired = false;        
         Boolean gstpSectionRequired = false;       
         Boolean sfSectionRequired = false;
        
        data.clientInfoRecId = clientInfoRecId;
        list<SelectOptionItem> platformOpts=new list<SelectOptionItem>();
        list<SelectOptionItem> lobOpts=new list<SelectOptionItem>();
        list<SelectOptionItem> instrumentsOpts=new list<SelectOptionItem>();
        platformOpts.add(new SelectOptionItem('RxCLAIM', 'RxCLAIM'));
        Rebate_Operations__c rebateOperations;
        //Platform options
        Client_Information__c clientInfo = [select id,FAF_ID__c, Pricing_Effective_Date__c,FAF_ID__r.LOB2__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c,Client_Subtype__c from Client_Information__c where id=: clientInfoRecId];
        String clientSubType = clientInfo.Client_Subtype__c;
        for(SelectOption opt: platformOptions){
            if(opt.getValue()!= 'RxCLAIM'){
                platformOpts.add(new SelectOptionItem(opt.getValue(), opt.getLabel()));
            }
        }
         if(clientInfo.FAF_ID__c != null){      
                 List<Rebate_Operations__c> rOpsList = [select id,GSTP_Option__c,Specialty_Formulary_Option__c,Non_Specialty_Formulary_Option__c from Rebate_Operations__c where FAF_ID__c=:clientInfo.FAF_ID__c];      
                 if(!rOpsList.isempty()){       
                    rebateOperations = rOpsList[0];     
                 }          
             } 
        lobOpts.add(new SelectOptionItem(clientInfo.FAF_ID__r.LOB2__c, clientInfo.FAF_ID__r.LOB2__c));
        //Lob options
        for(SelectOption opt: lobOptions){
            lobOpts.add(new SelectOptionItem(opt.getValue(), opt.getLabel()));
        }
        
        //Instructions options
        for(SelectOption opt: instructionOptions){
            instrumentsOpts.add(new SelectOptionItem(opt.getValue(), opt.getLabel()));
        }
        
        Boolean disableEffectiveDate = true;
        if(clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master' ){
            disableEffectiveDate = false;
        }
        data.disableEffectiveDate = disableEffectiveDate;
        data.pslistsize = ssc.getResultSize();
        data.navigatePage=pageNo;
        ssc.setPageSize(100);         
        pageNo = (pageNo!=null)?pageNo:1;
        ssc.setPageNumber(Integer.valueOf(pageNo));
            for (Platform_Specifics__c p: (List<Platform_Specifics__c>)ssc.getrecords())  {
                PlatFormSpecificItem item=new PlatFormSpecificItem();
                if(p.Rebate_Operations__c != null){
            
                   if(rebateOperations.Non_Specialty_Formulary_Option__c == 'Client Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                       if(p.DifferentGSTPFormularyEffectiveDates__c == false){
                           p.NonSpecialtyFormularyEffectiveDate__c = p.EffectiveDate__c;
                         }
                   }else{   
                         p.NonSpecialtyFormularyEffectiveDate__c = null;
                         p.NonSpecialtyFormularyRebateEndDate__c = null;
                         p.Non_Specialty_Formulary_Choice__c = rebateOperations.Non_Specialty_Formulary_Option__c;
                        }
                      
                   if(rebateOperations.GSTP_Option__c == 'Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                      if(p.DifferentGSTPFormularyEffectiveDates__c == false){
                           p.GSTPEffectiveDate__c = p.EffectiveDate__c;
                         }  
                   }else{ 
                          p.GSTPEffectiveDate__c = null;   
                          p.GSTPEndDate__c = null;   
                          p.GSTP_Choice__c = rebateOperations.GSTP_Option__c ;
                          } 
                      
                   if(rebateOperations.Specialty_Formulary_Option__c == 'Client Choice'  && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                      if(p.DifferentGSTPFormularyEffectiveDates__c == false){
                           p.SpecialtyFormularyEffectiveDate__c = p.EffectiveDate__c;
                         }
                   }else{
                         p.SpecialtyFormularyEffectiveDate__c = null; 
                         p.SpecialtyFormularyEndDate__c = null; 
                         p.Specialty_Formulary_Choice__c = rebateOperations.Specialty_Formulary_Option__c;
                        } 
                } 
                                   
                item.platformSpecific = p;
                item.platformOptions = platformOpts;
                item.lobOptions= lobOpts;
                item.disableEffectiveDate = disableEffectiveDate;
                item.instructionOptions = instrumentsOpts;
                item.pricingEffectiveDate = clientInfo.Pricing_Effective_Date__c;
                
                data.platformSpecifics.add(item);
            }
            data.clientSubType = clientSubType;
            data.newPlatFormSpecificItem.platFormSpecific.FAF_Client_Information__c= clientInfoRecId;
            data.newPlatFormSpecificItem.platFormSpecific.FAF_ID__c = clientInfo.FAF_ID__c;
            if(rebateOperations!=null){
               data.newPlatFormSpecificItem.platFormSpecific.Rebate_Operations__c = rebateOperations.Id;
               if(rebateOperations.Non_Specialty_Formulary_Option__c == 'Client Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                    data.nsfSectionRequired = true;
               }
               if(rebateOperations.GSTP_Option__c == 'Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                   data.gstpSectionRequired = true;              
               }
               if(rebateOperations.Specialty_Formulary_Option__c == 'Client Choice'  && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
                   data.sfSectionRequired = true;              
               }
            }
            
            
            
            data.newPlatFormSpecificItem.platFormSpecific.Platform__c= 'RxCLAIM';
            data.newPlatFormSpecificItem.platFormSpecific.Lob__c= clientInfo.FAF_ID__r.LOB2__c;
            data.newPlatFormSpecificItem.platFormSpecific.Instruction__c = 'Include';
            data.newPlatFormSpecificItem.pricingEffectiveDate = clientInfo.Pricing_Effective_Date__c;
            data.newPlatFormSpecificItem.platformOptions = platformOpts;
            data.newPlatFormSpecificItem.lobOptions= lobOpts;
            data.newPlatFormSpecificItem.instructionOptions = instrumentsOpts;
            data.newPlatFormSpecificItem.disableEffectiveDate = disableEffectiveDate;
            
            if(clientInfo.Pricing_Effective_Date__c != null ){
                  date cInfoEffectiveDate = clientInfo.Pricing_Effective_Date__c;
                  date firstDate = cInfoEffectiveDate.toStartOfMonth();
                  if(clientInfo.Pricing_Effective_Date__c == firstDate){
                       data.newPlatFormSpecificItem.platFormSpecific.EffectiveDate__c = cInfoEffectiveDate;
                    }
            }
            retrnData= JSON.serialize(data);
            
            return retrnData;
    }

//end of method to return serialized data to findByCagID method 
    
   
    private void loadData(){
        
        platformSpecifics=new list<PlatFormSpecificItem>();
        for(Platform_Specifics__c p: [Select Id, Platform__c, Specialty_Pharmacy_Benefit_Price_List__c,Link__c, Instruction__c,Level_1_Record_ID__c,Level_2_record_ID__c,Level_3_record_ID__c, Level1_Name__c,Level_1_ID__c,Termed__c, Level_2_ID__c, Level_3_ID__c, EffectiveDate__c, Termed_Date__c, Specialty_Pharmacy_Benefit__c, Specialty_Price_List__c, DifferentGSTPFormularyEffectiveDates__c, Non_Specialty_Formulary_Choice__c, NonSpecialtyFormularyEffectiveDate__c, NonSpecialtyFormularyRebateEndDate__c, GSTP_Choice__c, GSTPEffectiveDate__c, GSTPEndDate__c, Specialty_Formulary_Choice__c, SpecialtyFormularyEffectiveDate__c, SpecialtyFormularyEndDate__c from Platform_Specifics__c where FAF_Client_Information__c=:clientInfoId ]){
            PlatFormSpecificItem pItem=new PlatFormSpecificItem();
            pItem.platformSpecific = p;
            platformSpecifics.add(pItem);
        }
    }
    
    public void doCancel(){
        refreshTableData();
    }
    
    public list<PlatFormSpecificItem> getActivePlatFormSpecifics(){
        list<PlatFormSpecificItem> allActiveItems=new list<PlatFormSpecificItem>();
        for(PlatFormSpecificItem pItem: platformSpecifics){
            if(pItem.isNewDelete){
                //new Item deleted, then continue with next item
                continue;
            }
            allActiveItems.add(pItem);
        }
        return allActiveItems;
    }
    
    public void doSave(){
        list<Platform_Specifics__c> upsertPlatformSpecific=new list<Platform_Specifics__c>();
        for(PlatFormSpecificItem pItem: platformSpecifics){
            upsertPlatformSpecific.add(pItem.platformSpecific);
        }                
        upsert upsertPlatformSpecific;
        refreshTableData();
    }
    
    private void refreshTableData(){
        isEditEnabled = false;
        isNewEnabled = false;
        loadData();
    }
    
    public void doDelete(){
        list<Platform_Specifics__c> deleteItems=new list<Platform_Specifics__c>();
        for(PlatFormSpecificItem pItem: platformSpecifics){
            if(pItem.isNewDelete){
                //new Item deleted, then continue with next item
                continue;
            }
            if(pItem.isSelected){
                //This is selected for delete
                if(pItem.PlatformSpecific.Id!=null){
                    //record is existed, then this needs to be add to delete list
                    deleteItems.add(pItem.PlatformSpecific);
                }
            }
        }
        if(!deleteItems.isEmpty()){
            delete deleteItems;
            refreshTableData();
        }
    }
    
    public void doEdit(){
        isEditEnabled = true;
    }
    
    public void doAddNew(){
        isNewEnabled = true;
        Platform_Specifics__c newPlatformSpecific=new Platform_Specifics__c(FAF_Client_Information__c=clientInfoId,Platform__c = 'RxCLAIM',FAF_ID__c=fafId);
        PlatFormSpecificItem pItem=new PlatFormSpecificItem();
        pItem.platformSpecific = newPlatformSpecific;
        platformSpecifics.add(pItem);
    }
    
    //lightning controller logic goes here
    @AuraEnabled
    public static string aura_getPlatformSpecificData(String clientInfoRecId, Integer pageNo){
        String retrnData='';
        ApexPages.StandardSetController ssc  = new ApexPages.StandardSetController(database.getQueryLocator([Select Id, Name,Specialty_Pharmacy_Benefit_Price_List__c, FAF_Client_Information__r.FAF_ID__r.Name, FAF_Client_Information__r.Name,FAF_Client_Information__r.FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c, Platform__c, LOB__c, Link__c, Instruction__c, Level_1_ID__c, Level_1_Record_ID__c, Level_1_Record_ID__r.Name,Level_1_Record_ID__r.Carrier_ID__c,Level_2_Record_ID__r.Carrier_ID__c,Level_3_Record_ID__r.Carrier_ID__c, Level_2_record_ID__c, Level_2_record_ID__r.Name, Level_3_record_ID__c, Level_3_record_ID__r.Name, 
                                      Level_2_ID__c, Level_3_ID__c, EffectiveDate__c,Termed__c, Termed_Date__c, Specialty_Pharmacy_Benefit__c, Specialty_Price_List__c, DifferentGSTPFormularyEffectiveDates__c, Level1_Name__c,Non_Specialty_Formulary_Choice__c, NonSpecialtyFormularyEffectiveDate__c, NonSpecialtyFormularyRebateEndDate__c, GSTP_Choice__c, GSTPEffectiveDate__c, GSTPEndDate__c, Specialty_Formulary_Choice__c, SpecialtyFormularyEffectiveDate__c, SpecialtyFormularyEndDate__c,FAF_Client_Information__c, CAG_ID__c,
                                      Rebate_Operations__c,Rebate_Operations__r.GSTP_Option__c,Rebate_Operations__r.Specialty_Formulary_Option__c,Rebate_Operations__r.Non_Specialty_Formulary_Option__c  from Platform_Specifics__c where FAF_Client_Information__c=:clientInfoRecId ORDER BY LastModifiedDate DESC]));
       
             
        retrnData=returnSeralizedString(ssc,clientInfoRecId, pageNo); 
        return retrnData;                                
    }
    @AuraEnabled
    public static Client_Information__c aura_GetClientInfo(String clientInfoRecId){
        Client_Information__c cInfo = [select id,FAF_ID__c from Client_Information__c where id=:clientInfoRecId];
        return cInfo;
    }
    
        @AuraEnabled
    public static Central_Hub__c GetFAFInfo(String cinfo){
        List<Client_Information__c> fID = [select FAF_ID__c from Client_Information__c where id=:cinfo];
        Central_Hub__c fInfo = [select Account_Name__c from Central_Hub__c where id =: fID[0].FAF_ID__c];
        return fInfo;
    }
     @AuraEnabled
     public static Integer SavePlaformSpec(Platform_Specifics__c Platformspec){
            Integer duplicate = 0;
            String CAGID = Platformspec.CAG_ID__c;
            String PlatformID = Platformspec.Id;
            String ClientInfoId = Platformspec.FAF_Client_Information__c;
            String LOB = Platformspec.LOB__c;
            /* Sneha commented to stop duplicacy check as it handled from trigger Rally US30583
            **Platform_Specifics__c[] lstPlatform = NULL;
                                   lstPlatform = [Select Id
                                                           from     Platform_Specifics__c
                                                            where CAG_ID__c = :CAGID and FAF_Client_Information__c=:ClientInfoId
                                                           ]; 
             integer count = lstPlatform.size();
             integer i = count - 1; ** END ***/
       try{
        /* Sneha commented to stop duplicacy check as it handled from trigger Rally US30583
             if (lstPlatform != null && !lstPlatform.isEmpty())

                 
                    {  
                        system.debug('comes');
                        if (PlatformID != lstPlatform[i].Id) { 
                          duplicate = 1;
                          return duplicate; 
                        }
                        else {
                            system.debug('comes1');
                                Platform_Specifics__c psu;
                                psu = (Platform_Specifics__c) Platformspec;
                                psu.XAE__c= false;
                                Database.upsert(psu); 
                                duplicate = 0;
                                return duplicate;
                             }
                    }
            else { *** END **/
                //system.debug('test1');
                if (LOB == null)
                    {
                        duplicate = 2;
                        return duplicate;
                    }
                Platform_Specifics__c psu;
                psu = (Platform_Specifics__c) Platformspec;
                psu.XAE__c= false;
                Database.upsert(psu); 
                duplicate = 0;
                return duplicate;
            //***}
        }catch(dmlexception e){
            throw new AuraHandledException(e.getdmlMessage(0));
        }
        catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
     }
    @AuraEnabled
    public static String updatePS(String jsonData) {
        PlatformSpecificData data = (PlatformSpecificData)JSON.deserialize(jsonData, PlatformSpecificData.class);
        Map<Id, String> failedIdErrorMap = new Map<Id, String>();
        try{
            if(data!=null && data.platformSpecifics!=null && (!data.platformSpecifics.isEmpty())){
                list<Platform_Specifics__c> upsertItems=new list<Platform_Specifics__c>();
                for(PlatFormSpecificItem pItem: data.platformSpecifics){
                            //record is existed, then this needs to be add to upsert list
                            upsertItems.add(pItem.PlatformSpecific);
                 }
                if(!upsertItems.isEmpty()){
                    update upsertItems;/*
                    Database.SaveResult[] srList = Database.update(upsertItems, false);
                    for (Database.SaveResult sr : srList) {
                        system.debug('test');
                        if(!sr.isSuccess()) {
                            system.debug(sr);
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Fields that affected this error: ' + err.getFields());    
                            }
                        }
                    }*/
                }
            }
        }
        catch(System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                failedIdErrorMap.put(e.getDmlId(i), e.getDmlMessage(i));
            }
            data.isValidSave = false;           
        }
        if(data!=null && data.platformSpecifics!=null && (!data.platformSpecifics.isEmpty())){
            for(PlatFormSpecificItem pItem: data.platformSpecifics){
                //record is existed, then this needs to be add to upsert list
                pItem.isLevelrequiredMsg = (failedIdErrorMap.get(pItem.PlatformSpecific.Id)!=null)?failedIdErrorMap.get(pItem.PlatformSpecific.Id):'';
                pItem.isLevelrequired = (pItem.isLevelrequiredMsg!='');
            }
        }
        String retData = JSON.serialize(data);
        return retData;
    }
    /*@AuraEnabled
    public static String SavePlaformSpec(String jsonData){
        String retData = '';
        System.debug('hijosnData'+jsonData);
        PlatformSpecificData data = (PlatformSpecificData)JSON.deserialize(jsonData, PlatformSpecificData.class);
        try{
            system.debug('bbbbb');
            if(data!=null && data.platformSpecific!=null && (!data.platformSpecific.isEmpty())){
                list<Platform_Specifics__c> upsertItems=new list<Platform_Specifics__c>();
                for(PlatFormSpecificItem pItem: data.platformSpecific){
                            //record is existed, then this needs to be add to upsert list
                            upsertItems.add(pItem.PlatformSpecific);
                    system.debug('aaaaaa');
                    }
                if(!upsertItems.isEmpty()){
                    Database.upsert(upsertItems);
                }
                retData = aura_getPlatformSpecificData(data.clientInfoRecId);
            }
        }catch(Exception e){
            data.isValidSave = false;
            data.errorMessage= ''+e.getMessage();            
            retData= JSON.serialize(data);
        }
        return retData;
    }*/
    
    @AuraEnabled
    public static string aura_doDelete(String jsonData){
        String retData = '';
        PlatformSpecificData data = (PlatformSpecificData)JSON.deserialize(jsonData, PlatformSpecificData.class);
        try{
            if(data!=null && data.platformSpecifics!=null && (!data.platformSpecifics.isEmpty())){
                data.isValidSave = true;
                list<Platform_Specifics__c> deleteItems=new list<Platform_Specifics__c>();
                for(PlatFormSpecificItem pItem: data.platformSpecifics){
                    if(pItem.isNewDelete){
                        //new Item deleted, then continue with next item
                        continue;
                    }
                    if(pItem.isSelected){
                        //This is selected for delete
                        if(pItem.PlatformSpecific.Id!=null){
                            //record is existed, then this needs to be add to delete list
                            deleteItems.add(pItem.PlatformSpecific);
                        }
                    }
                }
                if(!deleteItems.isEmpty()){
                    Database.delete(deleteItems);
                }
                retData = aura_getPlatformSpecificData(data.clientInfoRecId, null);
            }
        }catch(Exception e){
            data.isValidSave = false;
            data.errorMessage= ''+e.getMessage();            
            retData= JSON.serialize(data);
        }
        return retData;
    }
    
    public class PlatformSpecificData{
        public boolean isValidSave;
        public String errorMessage;
        public String clientInfoRecId;
        public string clientSubType = '';
        public Boolean disableEffectiveDate = true;
        public Boolean nsfSectionRequired = false;      
        public Boolean gstpSectionRequired = false;     
        public Boolean sfSectionRequired = false;
        public Boolean isHavingInvalidLineItems;
        //below variable is used to add as a new Platform specifics in lightning: New Button logic contrller variable
        public PlatFormSpecificItem newPlatFormSpecificItem;
        public list<PlatFormSpecificItem> platformSpecific;
        public list<PlatFormSpecificItem> platformSpecifics;
        public integer pslistsize= 0;
        public integer navigatePage= 0;
        PlatformSpecificData(){
            isValidSave = true;
            isHavingInvalidLineItems = false;
            errorMessage = '';
            newPlatFormSpecificItem=new PlatFormSpecificItem();
            platformSpecifics =new list<PlatFormSpecificItem>();
            platformSpecific =new list<PlatFormSpecificItem>();
        }
    }
    
    public class PlatFormSpecificItem{
        public Boolean isSelected{set;get;}
        public Boolean isNewDelete{set;get;}
        public Boolean disableEffectiveDate {set;get;}
        public Boolean isInvalidEffectiveDate {set;get;}
        public String isInvalidEffectiveDateMsg {set;get;}
        public Boolean isLevelrequired {set;get;}
        public String isLevelrequiredMsg {set; get;}
        public Date pricingEffectiveDate;
        public Platform_Specifics__c platformSpecific{set;get;}
        
        public list<SelectOptionItem> platformOptions;
        public list<SelectOptionItem> lobOptions;
        public list<SelectOptionItem> instructionOptions;
        PlatFormSpecificItem(){
            isSelected = false;
            isNewDelete = false;
            disableEffectiveDate = true;
            isInvalidEffectiveDate = true;
            isInvalidEffectiveDateMsg = '';
            platformSpecific=new Platform_Specifics__c();
            pricingEffectiveDate = null;
            platformOptions=new list<SelectOptionItem>();
            lobOptions=new list<SelectOptionItem>();
            instructionOptions=new list<SelectOptionItem>();
        }
        public void removeItem(){
            isNewDelete = true;
        }
    }
    public class SelectOptionItem{
        public String label;
        public String value;
        SelectOptionItem(String label, String value){
            this.label = label;
            this.value = value;
        }
    }
    
    //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Platform_Specifics__c.isCreateable();
        return isCreateable; // if user has create access for client information object this method returns true
    }
    //Ajay added
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isEditable = false;
        isEditable = Schema.sObjectType.Platform_Specifics__c.isUpdateable();
        return isEditable; // if user has Edit access for client information object this method returns true
    }
    //Ajay added
    @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Platform_Specifics__c.isDeletable();
        return isDeletable; // if user has delete access for client information object this method returns true
    }
    //Ajay added
    @AuraEnabled
    public static Boolean isCagSearchNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Platform_Specifics__c.isCreateable();
        return isCreateable; // if user has create access for client information object this method returns true
    }
    
//*** providing the access of new, edit and delete for  Platform Specifics  to the salesuser, if salesuser 
    //*** added to the permission set  E_Apttus_Sales 
    @AuraEnabled
    public static String getAccessForSalesUser()
      {        
        String val='2';
        user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];
        if(u.profile.Id==Label.Apttus_sales_Profile){
            try{
            val='0';
            Permissionset ps= [select id,Name from permissionset where Id =:Label.Apttus_Sales_Permissionset];
            if(ps.Name !=null){
              PermissionSetAssignment psa=[select id ,PermissionSet.Name,PermissionSet.Id,AssigneeId  from PermissionSetAssignment where permissionset.id=:ps.id and AssigneeId=:Userinfo.getUserId()];
                if(psa.PermissionSet.Name !=null){
                    val='1';
                }else{
                     val='0';
                } 
            }
            }catch(Exception ex){
               val='0';
            }
       }
       if(u.profile.Id==Label.Apttus_Operations_Profile_Id){
          val='3';
      }
        if(u.profile.Id==Label.Apttus_Underwriter_Profile_ID){
          val='4';
      }
       return val;
    }
    
 
//lightning controller logic to get Account Subtype
 @AuraEnabled
    public static String getAccountSubtype(String clientInfoRecId)
    {
    //list of account owner manager
    String val='0';
    List<String> ownerManagerList= new List<String>();
    user u =[select Name,id ,profile.Id from user where id=:Userinfo.getUserId()];
    Client_Information__c clientInfo = [select Client_Subtype__c,FAF_ID__r.Account_Name__c, Account_Owner__c, Account_Manager__c, FAF_ID__r.Id,FAF_ID__r.Opportunity_Name__c,FAF_ID__r.Oppty_Winner_Formula__c,FAF_ID__r.Med_D_Sales_Lead_Formula__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where id=: clientInfoRecId];
    String accOwnerManager= clientInfo.Account_Manager__c;
    //adding the account manager list of strings.
    if(accOwnerManager!= null){
        ownerManagerList=accOwnerManager.split(',');
    }
    
   try {
    if(clientInfo.Client_Subtype__c != null){
       if(clientInfo.Client_Subtype__c == Label.Subtype_Health_Plan_Master || clientInfo.Client_Subtype__c == Label.Subtype_Coalition_Master || clientInfo.Client_Subtype__c == Label.Subtype_TPA_Master)     
        {
            if (clientInfo.FAF_ID__r.Med_D_Sales_Lead_Formula__c == u.Name || clientInfo.FAF_ID__r.Oppty_Winner_Formula__c == u.Name ||clientInfo.Account_Owner__c==u.id ||ownerManagerList.contains(u.Name))
            {
                val='1';
                return val;
            } 
            List<Central_Hub__c> sales = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id];
            if(sales.size() > 0 )   
            {
                             for(Central_Hub__c salesitem : sales)
                              {
                              if (salesitem.Salesperson__c == u.Id)
                              {
                                  val='1';
                                  return val;  
                                  
                              }
                              }   
            }  
             
            List<User>  man1 = [Select Id from User where ManagerId = :u.Id];
            if (man1.size() > 0 )
            {
             for(User man1item : man1)
             {
              List<Central_Hub__c> salesman1 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man1item.Id];
              if (salesman1.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            
            List<User>  man2level = [Select Name from User where Id = :u.Id];
            if (man2level.size() > 0 )
            {
            for(User man2levelitem : man2level)
            {
            List<User>  man2 = [Select Id from User where Manager_Level_2__c = :man2levelitem.Name];
            if (man2.size() > 0 )
            {
             for(User man2item : man2)
             {
              List<Central_Hub__c> salesman2 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man2item.Id];
              if (salesman2.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}
               
            List<User>  man3level = [Select Name from User where Id = :u.Id];
            if (man3level.size() > 0 )
            {
            for(User man3levelitem : man2level)
            {
            List<User>  man3 = [Select Id from User where Manager_Level_3__c = :man3levelitem.Name];
            if (man3.size() > 0 )
            {
             for(User man3item : man3)
             {
              List<Central_Hub__c> salesman3 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man3item.Id];
              if (salesman3.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}
               
            List<User>  man4level = [Select Name from User where Id = :u.Id];
            if (man4level.size() > 0 )
            {
            for(User man4levelitem : man4level)
            {
            List<User>  man4 = [Select Id from User where Manager_Level_4__c = :man4levelitem.Name];
            if (man4.size() > 0 )
            {
             for(User man4item : man4)
             {
              List<Central_Hub__c> salesman4 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man4item.Id];
              if (salesman4.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}   
               
           List<User>  man5level = [Select Name from User where Id = :u.Id];
            if (man5level.size() > 0 )
            {
            for(User man5levelitem : man5level)
            {
            List<User>  man5 = [Select Id from User where Manager_Level_5__c = :man5levelitem.Name];
            if (man5.size() > 0 )
            {
             for(User man5item : man5)
             {
              List<Central_Hub__c> salesman5 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man5item.Id];
              if (salesman5.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}                 
            
            List<User>  man6level = [Select Name from User where Id = :u.Id];
            if (man6level.size() > 0 )
            {
            for(User man6levelitem : man6level)
            {
            List<User>  man6 = [Select Id from User where Manager_Level_6__c = :man6levelitem.Name];
            if (man6.size() > 0 )
            {
             for(User man6item : man6)
             {
              List<Central_Hub__c> salesman6 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man6item.Id];
              if (salesman6.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}         
            
           List<User>  man7level = [Select Name from User where Id = :u.Id];
            if (man7level.size() > 0 )
            {
            for(User man7levelitem : man7level)
            {
            List<User>  man7 = [Select Id from User where Manager_Level_7__c = :man7levelitem.Name];
            if (man7.size() > 0 )
            {
             for(User man7item : man7)
             {
              List<Central_Hub__c> salesman7 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man7item.Id];
              if (salesman7.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}             
               
            list<AccountTeamMember> atm = [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,CreatedById,CreatedDate,TeamMemberRole,Title,UserId FROM AccountTeamMember where AccountId = :clientInfo.FAF_ID__r.Account_Name__c and
                                    UserId = :u.id];
            if(atm.size() > 0 ){
            for(AccountTeamMember atmItem : atm)
            {
                List<PlatformSpecific_Roles__mdt> psrmdt = [select Label  from PlatformSpecific_Roles__mdt where Label  = :atmItem.TeamMemberRole];
                 if(psrmdt.size() > 0 )       
                 {
                  val='1';
                  return val;            
                 }
                 else {val='0'; return val;}
             }
            } 
            else 
            { 
            val='0'; return val;  
            
            }
            
        }
            else{
                val='0'; return val;
            }
    }
     else { val='0'; return val;}  }
           catch(Exception ex){
               val='0'; return val;}
     return val;
    } 

    /*=================================================================================
    * @Method Name       : getGfriData
    * @author            : Vishakha(Accenture)
    * @created date      : 06/04/2020
    * @Last modified by  : Vishakha(Accenture)
    * @Purpose           : To create a record for GFRI
    =======================================================================================*/
        @AuraEnabled
        public static List<sObject> getGfriData(ID clientId, string platformSpecifics){
            List<sObject> gfriList = new List<sObject>();
            system.debug('platformSpecifics new' +  platformSpecifics);
            
            try{
                PlatformSpecificData data = (PlatformSpecificData)JSON.deserialize(platformSpecifics, PlatformSpecificData.class);
                
                if(data!=null && data.platformSpecifics!=null && (!data.platformSpecifics.isEmpty()))
                {
                    list<Platform_Specifics__c> updateChangeOrderOnPsList = new List<Platform_Specifics__c>();
                    for(PlatFormSpecificItem pItem: data.platformSpecifics){
                        if(pItem.isSelected){
                            //This is selected for delete
                            if(pItem.PlatformSpecific.Id!=null){
                                //record is existed, then this needs to be add to delete list
                                updateChangeOrderOnPsList.add(pItem.PlatformSpecific);
                            }
                        }
                    }
                    // Client info
                    Client_Information__c  clientInfo  = [Select Id ,FAF_ID__r.Id, FAF_ID__r.Name , FAF_ID__r.Account_Name__c, 
                                                          FAF_ID__r.Account_Name_1__c From Client_Information__c 
                                                          Where Id =:clientId limit 1];
                    system.debug('In class- Query complete');
					Id userId = userinfo.getUserId();
					User userDetails =[SELECT Id, UserRole.Name FROM User where Id=:userId limit 1 ];
					system.debug('Role Name:' + userDetails.UserRole.Name);
                    Group npGroupDetails = [Select ID from Group where Type = 'Queue' and name = 'Network Pricing Queue' limit 1];
                    Group iaGroupDetails = [Select ID from Group where Type = 'Queue' and name = 'Industry Analytics Queue' limit 1];
                    if(clientInfo!=null){
                        Id gfriRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GFRI').getRecordTypeId();
                        
                        Case gfriChangeOrder = New Case();
                        gfriChangeOrder.FAF__c = clientInfo.FAF_ID__r.Id;
                        gfriChangeOrder.RecordTypeId = GFRIRecordTypeAssignmentTriggerHandler.getUserWithRecordType(new set<id>{userinfo.getUserId()}).get(userinfo.getUserId());
                        gfriChangeOrder.Request_Due_Date__c = AddBusinessDays(date.today() , 1);
						gfriChangeOrder.AccountId = clientInfo.FAF_ID__r.Account_Name__c;
                        List<groupMember> grpMemberList = GFRIRecordTypeAssignmentTriggerHandler.getuserGroup(new set<id>{userinfo.getUserId()},'Regular');
                        
                        if(!grpMemberList.isEmpty()){
                            system.debug('group.Name:' + grpMemberList[0].Group.Name);
                            if(grpMemberList[0].group.Name=='Industry Analyst'){
                                gfriChangeOrder.GFRI_Effective_Date__c =AddBusinessDays(date.today() , 10);
                                gfriChangeOrder.Status = 'NP Request';
                                gfriChangeOrder.Request_Type__c = 'IA Initiated';
                            }
                            if(grpMemberList[0].group.Name=='Network Pricing Analyst'){
                                gfriChangeOrder.Status = 'IA Request';
                                gfriChangeOrder.Request_Type__c = 'NP Initiated';
                            }
                        }else{
                                gfriChangeOrder.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GFRI-IA').getRecordTypeId();
                            	gfriChangeOrder.GFRI_Effective_Date__c =AddBusinessDays(date.today() , 10);
                                gfriChangeOrder.Status = 'NP Request';
                                gfriChangeOrder.Request_Type__c = 'IA Initiated';
                            }
                        
                        if(gfriChangeOrder!=null){
                            database.insert(gfriChangeOrder, true);
                            gfriList.add(gfriChangeOrder);
                            system.debug('In class insert');
                        }
                        
                        Map<String,List<MAC_Validation_lookup__c>> psMap = getPSMappingWithMacValidationLookup(updateChangeOrderOnPsList);
                        
                        list<GFRI_MAC__c> newMACList = new List<GFRI_MAC__c>();
                        
                        list<sObject> upsertsObjectList = new List<sObject>();
                        
                        // Update Change order id to ps records and create mac records.
                        system.debug('psMap:' + psMap);
						if(!updateChangeOrderOnPsList.isEmpty())
                        
						for(Platform_Specifics__c pfsitem :updateChangeOrderOnPsList) 
						{
							system.debug('pfsitem:' + pfsitem.Level_1_ID__c);
							for(MAC_Validation_lookup__c vl :psMap.get(pfsitem.Level_1_ID__c)) 
							{
								newMACList.add(new GFRI_MAC__c(GFRI_CAG__c = pfsitem.Id,
                                                           MAC_Validation_lookup__c = vl.Id ));
							}
							pfsitem.Change_order_GFRI__c = gfriChangeOrder.Id; 
						}
                        
                        // Update PS parent change order    
                        if(!updateChangeOrderOnPsList.isEmpty()) {
                            upsertsObjectList.addAll(updateChangeOrderOnPsList);
                        }
                                                
                        // Create PS Mac records
                        if(!newMACList.isEmpty()) {
                            upsertsObjectList.addAll(newMACList);
                        }
                        
                        system.debug('upsertsObjectList>>'+upsertsObjectList);
                        if(!upsertsObjectList.isEmpty()){
                            database.upsert(upsertsObjectList);
                        }
                        
                        gfriList.addAll(upsertsObjectList);
                    }	
                }
                return gfriList;
            }catch(exception e){
                system.debug('e.getMessage()>>'+e.getMessage()+'E LineNumber'+e.getLineNumber());
                throw new AuraHandledException(e.getMessage());
            }
        }
		
	//logic for mac validation lookup and platform specific for GFRI MAC added by Vishakha 	
    @AuraEnabled
    public static Map<String,List<MAC_Validation_lookup__c>> getPSMappingWithMacValidationLookup(List<Platform_Specifics__c> psSelectedList)
    {
        Map<String,List<MAC_Validation_lookup__c>>  maplevel1WithValidationLoookupId = new Map<String,List<MAC_Validation_lookup__c>>();
        Set<String> setValidationLookup = new Set<String>();
        system.debug('psSelectedList>>'+psSelectedList);
        for(Platform_Specifics__c ps :psSelectedList) {
                setValidationLookup.add(ps.Level_1_ID__c);
        }
        system.debug('setValidationLookup>>'+setValidationLookup);
        List<MAC_Validation_lookup__c> validationLookupobjectList = [Select Id,Carrier_ID__c 
                                                                     From MAC_Validation_lookup__c 
                                                                     Where Carrier_ID__c in :setValidationLookup];
        system.debug('validationLookupobjectList>>'+validationLookupobjectList);
        for(MAC_Validation_lookup__c  mcvalidationlookup :validationLookupobjectList)
        {
            if (!maplevel1WithValidationLoookupId.containskey(mcvalidationlookup.Carrier_ID__c))
                maplevel1WithValidationLoookupId.put(mcvalidationlookup.Carrier_ID__c,new List<MAC_Validation_lookup__c>{mcvalidationlookup});
            else
                maplevel1WithValidationLoookupId.get(mcvalidationlookup.Carrier_ID__c).add(mcvalidationlookup);
        }  system.debug('maplevel1WithValidationLoookupId>>'+maplevel1WithValidationLoookupId);
       return maplevel1WithValidationLoookupId;
    }
    
	// to get User role and profile for GFRI added by Vishakha
    @AuraEnabled
    public static boolean getGfriUserRole()
   {
      boolean enableGFRIButton = false;
      User loguser = [select id, name, userrole.name, profile.name from user Where Id=: UserInfo.getUserId()];
      system.debug('loguser.Profile.Name = '+ loguser.Profile.Name);
       
	  if(loguser.Profile.Name == 'System Administrator') {
               enableGFRIButton = true; 
           }       
       
      List<groupMember> grpMemberList = GFRIRecordTypeAssignmentTriggerHandler.getuserGroup(new set<id>{userinfo.getUserId()},'Regular');
       
       if(!grpMemberList.isEmpty()) {
           if(grpMemberList[0].group.Name == 'Industry Analyst') {
               enableGFRIButton = true; 
           }
           else if(grpMemberList[0].group.Name=='Network Pricing Analyst') {
               enableGFRIButton = true;
           }
       }
       
       return enableGFRIButton; 
   }
    
    
	//Calculation for date for GFRI added by Vishakha
    @AuraEnabled
    public static Boolean IsWeekendDay(Date dateParam)
   {
      boolean result    = false;
      system.debug('dateParam = '+dateParam);
      //Recover the day of the week
      Date startOfWeek  = dateParam.toStartOfWeek();
      system.debug('startOfWeek = '+startOfWeek);
      Integer dayOfWeek = startOfWeek.daysBetween(dateParam);
      system.debug('dayOfWeek = '+dayOfWeek); 
      result = dayOfWeek == 0 || dayOfWeek == 6 ? true : false;
      system.debug('result = '+result);
      return result;
   }
    
	//Calculation for date for GFRI added by Vishakha
    @AuraEnabled
    public static Date AddBusinessDays(Date StartDate, integer BusinessDaysToAdd )
   {
      //Add or decrease in BusinessDaysToAdd days
      Date finalDate = StartDate;
      system.debug('finaldate = '+finalDate);
      integer direction = BusinessDaysToAdd < 0 ? -1 : 1;
      system.debug('direction = '+direction);
       while(BusinessDaysToAdd != 0)
       {
           finalDate = finalDate.AddDays(direction);
           system.debug('BusinessDaysToAdd = '+BusinessDaysToAdd); 
           system.debug('finaldate = '+finalDate);
           if (!isWeekendDay(finalDate))
           {
               BusinessDaysToAdd -= direction;

           }
       }
       return finalDate;
   }
}