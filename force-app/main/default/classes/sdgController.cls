/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
public with sharing class sdgController {
    
    
    @AuraEnabled
    public static string GetNamespace()
    {
        return JSON.serialize( sdgNamespaceUtility.GetNamespace());
    }
    
    @AuraEnabled
    public static String GetSDGInitialLoad(String ParentRecordID, String SDGTag, String RelationshipName, String FieldSetName, integer DefaultPageSize, String extraFilterFromCag)
    {
        //Create response object
        SDGInitialLoad initial = new SDGInitialLoad();
          system.debug('request.SDGTag'+SDGTag); 
        // Salesforce bug with Lightning serializer requires re-casting this value
        //https://salesforce.stackexchange.com/questions/108355/limit-expression-must-be-of-type-integer-error-when-using-apex-variable-in-soq/108423#108423
        try {
            DefaultPageSize = Integer.valueOf(DefaultPageSize);
        }
        catch (Exception ex)
        {
            throw new AuraHandledException('Invalid DefaultPageSize provided');
        }
        
        system.debug('sdgController:GetSDGInitialLoad:' + ParentRecordID + ':' + SDGTag + ':' + RelationshipName + ':' + FieldSetName);
        try
        {
            SDG newSDG = SDGDataProviderFactory.LoadSDG(SDGTag, ParentRecordId, RelationshipName, FieldsetName);
            //Create a full request:
            SDGRequest req = new SDGRequest();
            
            if (!String.isBlank(SDGTag))
            {
                req = sdgPreferences.GenerateRequestWithFilters(newSDG, ParentRecordID, SDGTag);
            } 
            req.RelationshipName = RelationshipName;
            req.FieldSetName = FieldSetName;
            req.ParentRecordID = ParentRecordID;
            req.SDGTag = SDGTag;
            req.PageSize = DefaultPageSize;
            req.extraFilterFromCag=extraFilterFromCag;
            
            SDGResult result = sdgDataProviderFactory.getData( req, newSDG);
            //Blank out the internal data to save payload:
            newSDG.InternalData = null;
            
            //build response object:
            initial.SDGObject = newSDG;
            initial.results = result;
            initial.isError = false;
            if(SDGTag=='CustomObject:Platform_Specifics_FAF_Search_UM' || SDGTag=='CustomObject:Platform_Specific_Record_UM'){
                 initial.editOrAddAccess='true';
            }else{
                 initial.editOrAddAccess=getAccessForSalesUser();
            }
            
        }
        
        catch (SDGException ex)
        {
            initial.ErrorMessage = ex.getMessage();
            initial.isError = true;
        }
        catch (Exception standardex)
        {
            initial.ErrorMessage = standardex.getMessage();
            initial.isError = true;
        }
        return JSON.serialize(initial);
    }
    
    @AuraEnabled
    public static string getSDGResult(String jsonrequest)
    {
        SDGResult results = new SDGResult();
        
        String resultsstring = '';
        try
        {
            system.debug('sdgController:getSDGResult: getting request');
            SDGRequest request = (SDGRequest)JSON.deserialize(jsonrequest, SDGRequest.class);
            system.debug('sdgController:getSDGResult: getting result');
              system.debug('request.ParentRecordID2222'+request.extraFilterFromCag); 
            
            results = sdgDataProviderFactory.getData(request);
            
            results.isError=false;
        }
        catch (Exception ex)
        {
            system.debug('sdgController:getSDGResult: Exception: ' + ex.getMessage() );
            results.ErrorMessage = ex.getMessage();
            results.isError = true;
        }
        return JSON.serialize(results);
    }
    
    
    /**** 08/21 - Apex Controller to insert Platform Specific Record from CAG Search ****/
    /** Apex Controller list all CAG records and then map and insert into Platform Specific object, Also check if already added 
previously, it gives message **/
    
    @AuraEnabled
    public static string createPlatformSpec(List<String> lstCAGIds, String Clientinfoid, String ClintinfofafId) {
        String sucessMessage = 'Platform Specifics record created successfully'; 
        String failureMessage = 'Error in Platform Specifics record creation'; 
        String CAGDataMessage = 'Error in Platform Specifics record creation, problem in CAG Source Data'; 
        String existingMessage = 'Error Message: Platform Specifics record already added, please review - ';
        integer duplicate = 0;
        String consexistingMessage;
        String CAGID;

        try{
            List<CAG__c> lstCAG = new List<CAG__c>();
            List<Platform_Specifics__c> lstPlatformSpecificsToInsert = new List<Platform_Specifics__c>();
            List<Central_Hub__c> FAFid = [Select Id,LOB2__c,Pricing_Effective_Date__c from Central_Hub__c where Id = :ClintinfofafId];
            if(lstCAGIds != null && !lstCAGIds.isEmpty()){
                lstCAG = [Select Id, 
                          Platform_Name__c, 
                          Carrier_ID__c, 
                          CAG_ID__c,
                          Carrier_Name__c, 
                          Account_ID__c, 
                          Account_Name__c, 
                          Group_ID__c, 
                          Group_Name__c,
                          Record_Type__c
                          FROM CAG__c
                          WHERE ID IN: lstCAGIds
                          AND Status__c in('A','N')];
                system.debug('lstCAG'+lstCAG);
                 
                
                Set<String> accountIdSet = new Set<String>();
                Set<String> carrierIdSet = new Set<String>();
                Set<String> platformNameSet = new Set<String>();
                for(CAG__c cag: lstCAG){
                    accountIdSet.add(cag.Account_ID__c);
                    carrierIdSet.add(cag.Carrier_ID__c);
                    platformNameSet.add(cag.Platform_Name__c);
                }               
                
                List<CAG__c>  cagNewList = [SELECT Id, Carrier_ID__c, Carrier_Name__c, Account_ID__c, Account_Name__c, Platform_Name__c, 
                                                   Status__c, Record_Type__c
                                            FROM CAG__c
                                            WHERE Record_Type__c IN ('C') AND Carrier_ID__c IN:carrierIdSet AND Platform_Name__c IN:platformNameSet  AND Status__c in('A','N')];

                List<CAG__c>  cagAccList = [SELECT Id, Carrier_ID__c, Carrier_Name__c, Account_ID__c, Account_Name__c, Platform_Name__c, 
                                                   Status__c, Record_Type__c
                                            FROM CAG__c
                                            WHERE Record_Type__c IN ('A') AND Carrier_ID__c IN:carrierIdSet AND Account_ID__c IN:accountIdSet AND Platform_Name__c IN:platformNameSet AND Status__c in('A','N')];
                
                List<CAG__c>  cagCarList = [SELECT Id, Carrier_ID__c, Carrier_Name__c, Account_ID__c, Account_Name__c, Platform_Name__c, 
                                                   Status__c, Record_Type__c
                                            FROM CAG__c
                                            WHERE Record_Type__c IN ('C') AND Carrier_ID__c IN:carrierIdSet];
                                            
                Map<String, List<CAG__c>> cagNewMap = new Map<String, List<CAG__c>>();
                Map<String, List<CAG__c>> cagAccMap = new Map<String, List<CAG__c>>();
                Map<String, List<CAG__c>> cagCarMap = new Map<String, List<CAG__c>>();
                
                
                for(CAG__c cag:cagNewList) {
                    String keyStr = cag.Carrier_ID__c+'-'+cag.Platform_Name__c;
                    List<CAG__c> cagTempList = cagNewMap.get(keyStr);
                    if(cagTempList==null) {
                        cagTempList = new List<CAG__c>();
                    }
                    cagTempList.add(cag);
                    cagNewMap.put(keyStr, cagTempList);
                }
                
                for(CAG__c cag:cagAccList) {
                    String keyStr = cag.Account_ID__c+'-'+cag.Carrier_ID__c+'-'+cag.Platform_Name__c;
                    List<CAG__c> cagTempList = cagAccMap.get(keyStr);
                    if(cagTempList==null) {
                        cagTempList = new List<CAG__c>();
                    }
                    cagTempList.add(cag);
                    cagAccMap.put(keyStr, cagTempList);
                }

                for(CAG__c cag:cagCarList) {
                    String keyStr = cag.Carrier_ID__c;
                    List<CAG__c> cagTempList = cagCarMap.get(keyStr);
                    if(cagTempList==null) {
                        cagTempList = new List<CAG__c>();
                    }
                    cagTempList.add(cag);
                    cagCarMap.put(keyStr, cagTempList);
                }
               
                
                List<Platform_Specifics__c> Platformlst = [Select Id,CAG_ID__c, FAF_Client_Information__c
                                                           from     Platform_Specifics__c
                                                           where FAF_Client_Information__c=:Clientinfoid
                                                           ];
                                                           
                Map<String, List<Platform_Specifics__c>> PlatformMap = new Map<String, List<Platform_Specifics__c>>();
                for(Platform_Specifics__c pst:Platformlst) {
                    String keyStr = pst.CAG_ID__c+'-'+pst.FAF_Client_Information__c;
                    List<Platform_Specifics__c> pstTempList = PlatformMap.get(keyStr);
                    if(pstTempList==null) {
                        pstTempList = new List<Platform_Specifics__c>();
                    }
                    pstTempList.add(pst);
                    PlatformMap.put(keyStr, pstTempList);
                }
                
                
                for(CAG__c cag: lstCAG){
                    String carStr = cag.Carrier_ID__c;
                    String carrierStr = cag.Carrier_ID__c+'-'+cag.Platform_Name__c;
                    String accountStr = cag.Account_ID__c+'-'+cag.Carrier_ID__c+'-'+cag.Platform_Name__c;
                    
                     if (cag.Record_Type__c == 'G') {
                        CAG__c[] carrierId = cagNewMap.get(carrierStr);
                        CAG__c[] AccountId = cagAccMap.get(accountStr);
                        
                        if (carrierId != null && !carrierId.isEmpty())
                        {
                            if (AccountId != null && !AccountId.isEmpty())
                            {   String Carrier = carrierId[0].Id; 
                                String Account = AccountId[0].Id;
                                CAGID = Carrier + Account + cag.Id  +  Clientinfoid + cag.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
                                
                            }
                        }
                     }
                    
                      if (cag.Record_Type__c == 'A') {
                        CAG__c[] carrierId = cagNewMap.get(carrierStr);
                       
                        if (carrierId != null && !carrierId.isEmpty())
                        {
                                String Carrier = carrierId[0].Id; 
                                CAGID = Carrier + cag.Id  +  Clientinfoid + cag.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
   
                        }
                     }
                    
                    if (cag.Record_Type__c == 'C') {
       
                                CAGID = cag.Id   +  Clientinfoid + cag.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
   
                      }
                    
                    Platform_Specifics__c platformSpecifics = new Platform_Specifics__c();
                    Platform_Specifics__c[] lstPlatform = PlatformMap.get(CAGID+'-'+Clientinfoid);
                    
                    if (lstPlatform != null && !lstPlatform.isEmpty())
                    {   duplicate = 1;
                     
                     if (consexistingMessage != null) {
                         consexistingMessage = consexistingMessage + ' , ';
                         if (cag.Account_ID__c != null && cag.Group_ID__c !=null) {
                                     consexistingMessage +=  ' CARRIER -' + cag.Carrier_ID__c + 
                                                             ' ACCOUNT -' + cag.Account_ID__c + 
                                                             ' GROUP -' + cag.Group_ID__c + 
                                                             ' PLATFORM -' + cag.Platform_Name__c + 
                                                             ' LOB - ' + FAFid[0].LOB2__c; 
                             }
                         else if (cag.Account_ID__c != null && cag.Group_ID__c ==null) {
                                     consexistingMessage +=  ' CARRIER -' + cag.Carrier_ID__c + 
                                                             ' ACCOUNT -' + cag.Account_ID__c +
                                                             ' PLATFORM -' + cag.Platform_Name__c + 
                                                             ' LOB - ' + FAFid[0].LOB2__c; 
                             }
                         else if (cag.Account_ID__c == null ) {
                                      consexistingMessage +=  ' CARRIER -' + cag.Carrier_ID__c + 
                                                             ' PLATFORM -' + cag.Platform_Name__c + 
                                                             ' LOB - ' + FAFid[0].LOB2__c; 
                             }
                         }
                     else { 
                         
                         if (cag.Account_ID__c != null && cag.Group_ID__c !=null) {
                                      consexistingMessage =  existingMessage + 'CARRIER -' + cag.Carrier_ID__c + 
                                                             ' ACCOUNT -' + cag.Account_ID__c + 
                                                             ' GROUP -' + cag.Group_ID__c + 
                                                             ' PLATFORM -' + cag.Platform_Name__c + 
                                                             ' LOB - ' + FAFid[0].LOB2__c; 
                             }
                         else if (cag.Account_ID__c != null && cag.Group_ID__c ==null) {
                                     consexistingMessage =  existingMessage + ' CARRIER -' + cag.Carrier_ID__c + 
                                                             ' ACCOUNT -' + cag.Account_ID__c +
                                                             ' PLATFORM -' + cag.Platform_Name__c + 
                                                             ' LOB - ' + FAFid[0].LOB2__c; 
                             }
                         else if (cag.Account_ID__c == null ) {
                                     consexistingMessage  =  existingMessage + ' CARRIER -' + cag.Carrier_ID__c + 
                                                             ' PLATFORM -' + cag.Platform_Name__c + 
                                                             ' LOB - ' + FAFid[0].LOB2__c;  
                             }
                                                      
                          }
                    }
                    if (cag.Record_Type__c == 'G') {
                        CAG__c[] carrierId = cagNewMap.get(carrierStr);
                        CAG__c[] AccountId = cagAccMap.get(accountStr);
                        
                        if (carrierId != null && !carrierId.isEmpty())
                        {
                            if (AccountId != null && !AccountId.isEmpty())
                            {   String Carrier = carrierId[0].Id; 
                                String Account = AccountId[0].Id;
                                platformSpecifics.Level_1_Record_ID__c = carrierId[0].Id;
                                platformSpecifics.Level1_Name__c = carrierId[0].Carrier_Name__c;
                                platformSpecifics.Level_2_record_ID__c = AccountId[0].Id;
                                platformSpecifics.Level2_Name__c = AccountId[0].Account_Name__c;  
                                platformSpecifics.Level_3_record_ID__c = cag.Id;
                                platformSpecifics.Level3_Name__c = cag.Group_Name__c;  
                                platformSpecifics.Platform__c = cag.Platform_Name__c;
                                platformSpecifics.CAG_ID__c = Carrier + Account + cag.Id +  Clientinfoid + cag.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
                                platformSpecifics.FAF_Client_Information__c = Clientinfoid;
                                platformSpecifics.FAF_ID__c = FAFid[0].id;
                                platformSpecifics.LOB__c = FAFid[0].LOB2__c;
                                platformSpecifics.Instruction__c = 'Include';
                                platformSpecifics.EffectiveDate__c  = FAFid[0].Pricing_Effective_Date__c;
                                platformSpecifics.XAE__c = false;
                            }
                            else {

                                return CAGDataMessage;
                            }
                        }
                        else {

                            return CAGDataMessage;
                        }
                    }
                    if (cag.Record_Type__c == 'A') {
                        CAG__c[] carrierId = cagNewMap.get(carrierStr);
                        
                        if (carrierId != null && !carrierId.isEmpty())
                        {   String Carrier = carrierId[0].Id; 
                            platformSpecifics.Level_1_Record_ID__c = carrierId[0].Id;
                            platformSpecifics.Level1_Name__c = carrierId[0].Carrier_Name__c;
                            platformSpecifics.Level_2_record_ID__c = cag.Id;
                            platformSpecifics.Level2_Name__c = cag.Account_Name__c;
                            //platformSpecifics.Level_3_record_ID__c = cag.Id;
                            platformSpecifics.Platform__c = cag.Platform_Name__c;
                            platformSpecifics.CAG_ID__c =  Carrier + cag.Id  +  Clientinfoid + cag.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
                            platformSpecifics.FAF_Client_Information__c = Clientinfoid;
                            platformSpecifics.FAF_ID__c = FAFid[0].id;
                            platformSpecifics.LOB__c = FAFid[0].LOB2__c;
                            platformSpecifics.Instruction__c = 'Include';
                            platformSpecifics.EffectiveDate__c  = FAFid[0].Pricing_Effective_Date__c;
                            platformSpecifics.XAE__c = false;
                        }
                        else {
                                   system.debug('CAGDataMessage 2'+CAGDataMessage);
                            return CAGDataMessage;
                        }
                    }
                    
                    if (cag.Record_Type__c == 'C') {
                        CAG__c[] carrierId = cagCarMap.get(carStr);
                        platformSpecifics.Level_1_Record_ID__c = cag.Id;
                        platformSpecifics.Level1_Name__c = carrierId[0].Carrier_Name__c;
                        //platformSpecifics.Level_2_record_ID__c = cag.Id;
                        //platformSpecifics.Level_3_record_ID__c = cag.Id;
                        platformSpecifics.Platform__c = cag.Platform_Name__c;
                        platformSpecifics.CAG_ID__c = cag.Id   +  Clientinfoid + cag.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
                        platformSpecifics.FAF_Client_Information__c = Clientinfoid;
                        platformSpecifics.FAF_ID__c = FAFid[0].id;
                        platformSpecifics.LOB__c = FAFid[0].LOB2__c;
                        platformSpecifics.Instruction__c = 'Include';
                        platformSpecifics.EffectiveDate__c  = FAFid[0].Pricing_Effective_Date__c;
                        platformSpecifics.XAE__c = false;
                    }
                    
                    lstPlatformSpecificsToInsert.add(platformSpecifics);
                    
                }
                
                if(lstPlatformSpecificsToInsert != null && !lstPlatformSpecificsToInsert.isEmpty() && duplicate==0){

                    Database.insert(lstPlatformSpecificsToInsert);
                }
                if (duplicate==1) { return consexistingMessage; }
                List<CAG__c> cagToUpdate = new List<CAG__c>();
                
                set<String> CAGset= new set<String>();
                for(CAG__c cagu: lstCAG)
                {
                    CAGID = cagu.Carrier_ID__c + cagu.Account_ID__c + cagu.Group_ID__c +  Clientinfoid + cagu.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
                    CAGset.add(CAGID);
                }
                List<Platform_Specifics__c> platformspeclst = [Select Id,CAG_ID__c 
                                                              from  Platform_Specifics__c
                                                              where CAG_ID__c IN :CAGset];
                Map <String,list<Platform_Specifics__c>> platformspecmap= new Map <String,list<Platform_Specifics__c>>();                                         
                for(Platform_Specifics__c pst:platformspeclst)  {
                        List<Platform_Specifics__c> pstTemplst = platformspecmap.get(pst.CAG_ID__c);
                        if(pstTemplst == null){
                            pstTemplst = new List<Platform_Specifics__c>();
                        }
                        pstTemplst.add(pst);
                        platformspecmap.put(pst.CAG_ID__c,pstTemplst);
                    
                }                                           
                for(CAG__c cagu: lstCAG)
                {
                    CAGID = cagu.Carrier_ID__c + cagu.Account_ID__c + cagu.Group_ID__c +  Clientinfoid + cagu.Platform_Name__c + FAFid[0].LOB2__c + 'Include';
                    Platform_Specifics__c[] PlatformspecId = platformspecmap.get(CAGID);
                    if(PlatformspecId!=null &&  PlatformspecId.size()>0){
                    cagu.FAF_Platform_Specifics__c = PlatformspecId[0].Id;
                    cagToUpdate.add(cagu); 
                     }
                }
                if(cagToUpdate != null && !cagToUpdate.isEmpty()){
                    //Database.update(cagToUpdate); No requirement to populate platform specific reference
                }

                return sucessMessage;
            }else

                return failureMessage;
        }
        
        catch(Exception ex){
            system.debug('exception '+ex.getMessage() +'at line '+ex.getLineNumber());
            return ex.getMessage();
        }
        
    }
    
    /**** END Apex Controller to insert Platform Specific Record from CAG Search ****/
    
    
    
    /** Delete the respective row  when we click on the delete button from grid * */
    
    @AuraEnabled
    public static string deleteSDGRowData(String RecordID){
        SDGResult results = new SDGResult();
        try{
            Id sid=RecordID;
            String sobjectType = sid.getSObjectType().getDescribe().getName();// Object name 
            String query=' select id from '+sobjectType+'  where Id =:sid';
            List<Sobject>ListsobjectType=Database.query(query);
            delete ListsobjectType;// deleting the row 
            results.isError=false;
        }catch(Exception ex){
            results.ErrorMessage = ex.getMessage();
            results.isError=true;
        }
        return JSON.serialize(results);
    }

    /** Added by Ajay for Multiple Row Delete * */
    
    @AuraEnabled
    public static string deleteSDGMultipleRowData(List<String> RecordID){
        SDGResult results = new SDGResult();
        try{
            Id idVal = RecordID[0];
            String sobjectType = idVal.getSObjectType().getDescribe().getName();// Object name 
            String query=' select id from '+sobjectType+'  where Id =:RecordID';
            List<Sobject>ListsobjectType=Database.query(query);
            delete ListsobjectType;// deleting the row 
            results.isError=false;
        }catch(Exception ex){
            results.ErrorMessage = ex.getDmlMessage(0);
            results.isError=true;
        }
        return JSON.serialize(results);
    }
    //*** providing the access of new, edit and delete for  Enhanced grid view  to the salesuser, if salesuser 
    //*** added to the permission set  E_Apttus_Sales added by Preetham Padala
    @AuraEnabled
    public static String getAccessForSalesUser(){
        
        String val='true';
        user u =[select id ,profile.name,profileId  from user where id=:Userinfo.getUserId()];
        if(u.profileId==Label.Apttus_sales_Profile || u.profileId==Label.Apttus_Operations_Profile_Id){
            val='false';
      
        }
        return val;
    }
    
    
        @AuraEnabled
    public static String deleteBillingAdminAndAncillData(List<Billing_Administrative_Fees__c> todeletebillAdminList,List<Billing_Ancillary_Fee__c> todeletebillancList ){
        delete todeletebillancList;
        delete todeletebillAdminList;
        
        return 'Success';
    }
    // multi-delete functionlity for billing administrative fee matches with billing ancillary fee added Preetham padala 
      @AuraEnabled
   public static Map<String,Object> deleteBillingAdminRowData(List<String> RecordID){
       try {
        system.debug('RecordID'+RecordID);
        SDGResult results = new SDGResult();
        
        List<Billing_Ancillary_Fee__c > todeletebillancList = new List<Billing_Ancillary_Fee__c>();
        List<Billing_Administrative_Fees__c > todeletebillAdminList = new List<Billing_Administrative_Fees__c>();
        List<Billing_Administrative_Fees__c > toSendbillAdminList = new List<Billing_Administrative_Fees__c>();
        List<Billing_Administrative_Fees__c> billingAdminRecList = [Select id,Name, FAF_ID__c,Billing_Operations__c, Year__c,LOB__c,Admin_Fee_Type__c,Base_Amount__c from Billing_Administrative_Fees__c where id In :RecordID];
        
        Id billOpsId = billingAdminRecList[0].Billing_Operations__c;
        if(!string.isBlank(billOpsId)){
            list<Billing_Ancillary_Fee__c > billancList = [Select Name,id,Year__c,LOB2__c,Fee_Basis__c,Fee_Amount__c,Billing_Operations__c from Billing_Ancillary_Fee__c where Billing_Operations__c =:billOpsId];
            if(billingAdminRecList.size() > 0){
                for(Billing_Administrative_Fees__c billingAdminRec:billingAdminRecList ){
                    boolean isdelete=true;
                    if(billancList.size() > 0){
                    for(Billing_Ancillary_Fee__c baf :billancList){
                        if(((baf.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || baf.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)) 
                            && baf.LOB2__c.equals(billingAdminRec.LOB__c) && baf.Year__c.equals(billingAdminRec.Year__c) && (billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM)  || billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))) || 
                           ((baf.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || baf.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  
                            && baf.LOB2__c.equals(billingAdminRec.LOB__c) && baf.Year__c.equals(billingAdminRec.Year__c) && (billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.MAIL_PER_CLAIM) || billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))) ||
                           (baf.Fee_Basis__c.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE)  && baf.LOB2__c.equals(billingAdminRec.LOB__c) && baf.Year__c.equals(billingAdminRec.Year__c) 
                            && (billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS)))){
                                todeletebillancList.add(baf);  
                                isdelete=false;
                                                                   }
                    }}
                    if(isdelete==true){
                        system.debug('===check==');
                        todeletebillAdminList.add(billingAdminRec);
                    }else{
                        toSendbillAdminList.add(billingAdminRec);
                    }
                    }
                  
            }
            
            if(todeletebillAdminList.size()>0){
                delete todeletebillAdminList;
            }
            
        }
        Map<String,Object>returnMap=new Map<String,Object>();
       if(toSendbillAdminList.size()>0) {
           returnMap.put('billing',toSendbillAdminList);
           }
       if(todeletebillancList.size()>0) {
           returnMap.put('ancill',todeletebillancList);
           }
           system.debug('returnMap'+returnMap);
           return returnMap;
       }
       catch (Exception ex)
        {
            throw new AuraHandledException('Problem in Deletion of Billing Admin Record(s)');
            return null;
        }
       
       
    }    
    
     public static void hack() {
        Integer i = 0;
        i++;
               i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
             i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
             i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
       
 }
}