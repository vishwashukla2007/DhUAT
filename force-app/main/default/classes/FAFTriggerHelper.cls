public with sharing class FAFTriggerHelper { 
    
    Public static String strErrorMessages='';
    public static Boolean rebateCheck=false;
     public static Boolean rebateBillingCheck=false;
     
     public static boolean DisableValidations(Map<Id, Central_Hub__c> oldFAFMap, List<Central_Hub__c> newFAFList) {
        boolean bRet = False;
        for(Central_Hub__c faf : newFAFList){
         string DV = Label.Disable_FAF_Validations;
         string oldStatus = oldFAFMap.get(faf.id).FAF_Status__c;
         string newStatus = faf.FAF_Status__c;
          if (DV.indexOf(newStatus) >= 0 ) {
             faf.ComponentValidation__c=false;
             faf.Source_Copy_FAF_Status__c = 'Disable Validations';
             faf.FAF_Copy_In_Progress__c = true;
     //      faf.Peer_Reviewed__c = false;
     //      faf.Approved_By_Sales__c = false;
             bRet= True;
         }
         else
         {
            faf.FAF_Copy_In_Progress__c = false;
            faf.Source_Copy_FAF_Status__c = oldStatus;
          }       
        }
       return bRet; 
    }   
    public static boolean BulkUpdate(List<Central_Hub__c> FAFList) {
    for(Central_Hub__c faf : FAFList){
        return faf.Bulk_Update__c;
    }
    return false;
    } 
    
    public static void LinkToLOB(List<Central_Hub__c> FAFList) {
    for(Central_Hub__c faf : FAFList){     
        if (faf.LOB_ID__c != null && faf.FAF_Status__c == 'Uploaded') {
        try{
             for (LOB__c lob: [Select id, FAF__c,Lob__c,Client_Pricing_Offer__c,Agreement__c from LOB__c where FAF__c = null AND Id = : faf.LOB_ID__c]) {
                    lob.FAF__c = faf.Id;
                    lob.Lob__c = faf.LOB2__c;
                    update lob;
                 
                 for(Central_Hub__c faf1 : [Select id from Central_Hub__c where Id = : faf.Id]) {
                        faf1.Offer_ID1__c = lob.Client_Pricing_Offer__c;
                        update faf1;                    
                 }     
             }
             
          }
          Catch(Exception ex){
          
           for(Central_Hub__c newFafRec : FAFList){
             newFafRec.adderror(ex.getDMLMessage(0));
            }            
          }
        }
     }   
    }     
    
    public static void FromandTodatespopulate(List<Central_Hub__c> FAFList) {    
        for(Central_Hub__c faf : FAFList){
            if( (faf.FAF_Status__c == 'Draft' || faf.FAF_Status__c =='Sales Review') && ( faf.Approval_Status__c == 'Approval Required' && faf.From_Date__c != system.Today()) ){                
                faf.From_Date__c = system.Today();
                faf.To_Date__c = Label.WMQ_TAT_Mode == 'Test' ? system.Today() : (system.Today() + (Integer)faf.TAT_Priority__c + (Integer)faf.TAT_Workday__c);               
                if (faf.From_Date__c == faf.To_Date__c)
                    faf.To_Date__c = Label.WMQ_TAT_Mode == 'Test' ? system.Today() : (system.Today() + 2 + (Integer)faf.TAT_Workday__c);                              
                    }
                                           
        }   
    }    
    
     //It will validate the FAF error messages
    public static void FAFErrorValidator(List<Central_Hub__c> FAFList) {    
        for(Central_Hub__c faf : FAFList){
           
        if (faf.Initiate_FAF_Release__c == true && faf.Source_Copy_FAF_Status__c != 'Disable Validations' )
        {         
            if( faf.FAF_Status__c == 'Draft' && faf.Approval_Status__c == 'Approval Required'  
            && faf.Peer_Reviewer__c == null && faf.Peer_Reviewed__c == false){
            
                faf.addError('"Peer Reviewer Name" is required for Peer Review/Approval. ');                
            }
            if( faf.FAF_Status__c == 'Draft' && faf.Approval_Status__c == 'Approval Required'  
            && faf.Underwriter__c == null && faf.Action_Source__c != 'Auto'){
            
                faf.addError('Underwriter required for Peer Review. ');
            }   
            if( faf.FAF_Status__c == 'Draft' && (faf.Approval_Status__c == 'Approval Required' || faf.Approval_Status__c == 'In Review')  
            && faf.Peer_Reviewer_Active__c == 'Inactive' && faf.Peer_Reviewer__c != null && faf.Action_Source__c != 'Auto'){
            
                faf.addError('The Peer Reviewer is inactive, please select/enter a different Peer Reviewer on the FAF.');
            }   
           /* if( faf.FAF_Status__c == 'Sales Review' && faf.Approval_Status__c == 'Approval Required' && faf.Preview_Submit_Approvals__c != null 
            && faf.Sales_Approver__c == null && faf.Approved_By_Sales__c == FALSE && faf.Action_Source__c != 'Auto' && faf.Peer_Reviewed__c == true){
            
                faf.addError('Sales Approver Name is required for Sales Review/Approval. ');
            }  */
            if( (faf.FAF_Status__c == 'Draft' || faf.FAF_Status__c == 'Sales Review' || faf.FAF_Status__c == 'Peer Review') && (faf.Approval_Status__c == 'Approval Required' || faf.Approval_Status__c == 'In Review')   
            && faf.Sales_Approver_Active__c == 'Inactive' && faf.Salesperson__c != null && faf.Action_Source__c != 'Auto'){
            
                faf.addError('The Salesperson is inactive, please select/enter a different Salesperson on the FAF. ');
            }
 
           if( faf.FAF_Status__c == 'Implemented' && faf.Approval_Status__c == 'Approval Required' && faf.Pricing_Effective_Date__c == null && faf.Action_Source__c != 'Auto'){
            
                faf.addError('The Pricing Effective Date must be entered prior to releasing the FAF for Implementation.' );
            }            
            
            if (faf.Error_Message__c != null && faf.Action_Source__c != 'Auto')
            {
 
                String[] ErrorMessageList = new String[] {};
                for (String em : faf.Error_Message__c.split('\\.')) {                    
                    
                    String emtrimmed = em.trim();
                    
                    if (emtrimmed.length() > 0) 
                    ErrorMessageList.add(emtrimmed);
                }
                    if(ErrorMessageList.size()>0){                                        
                    for(integer i=0; i<ErrorMessageList.size(); i++){                        
                        faf.addError(ErrorMessageList[i]+'.');                        
                    }                                                           
                }                                
                else
                faf.addError(faf.Error_Message__c);
            }
        }                   
        } 
    }    
    public static void updateOpsBeforeUpdate(List<Central_Hub__c> FAFList) {    
        for(Central_Hub__c faf: FAFList)
        {   
            if (faf.Network_Operations__c == True && faf.Specialty_Operations__c == True && faf.Mail_Operations__c == true) {
                faf.FAF_Type__c = 'Full';
            }
            if (faf.Network_Operations__c == True && faf.Mail_Operations__c == True && faf.Specialty_Operations__c == False) {
                faf.FAF_Type__c = 'Full - Retail and Mail Only';
            }
            if (faf.Network_Operations__c == True && faf.Mail_Operations__c == False && faf.Specialty_Operations__c == True) {
                faf.FAF_Type__c = 'Full - Retail and Specialty Only';
            }
            if (faf.Network_Operations__c == False && faf.Mail_Operations__c == True && faf.Specialty_Operations__c == True) {
                faf.FAF_Type__c = 'Full - Mail and Specialty Only';
            }
            if (faf.Network_Operations__c == False && faf.Mail_Operations__c == True && faf.Specialty_Operations__c == False) {
                faf.FAF_Type__c = 'Full - Mail Only';
            }
            if (faf.Network_Operations__c == True && faf.Mail_Operations__c == False && faf.Specialty_Operations__c == False) {
                faf.FAF_Type__c = 'Full - Retail Only';
            }
            if (faf.Network_Operations__c == False && faf.Mail_Operations__c == False && faf.Specialty_Operations__c == True) {
                faf.FAF_Type__c = 'Full - Specialty Only';
            }  
            if ( (faf.Network_Operations__c == False && faf.Mail_Operations__c == False && faf.Specialty_Operations__c == False) && 
                (faf.Billing_Operations__c == True || faf.Rebate_Operations__c == True || faf.Clinical_Operations__c == True || faf.Guarantee_Information__c == True)) {
                    faf.FAF_Type__c = 'Partial';
                }
            
            if (faf.Network_Operations__c == False && faf.Mail_Operations__c == False && faf.Specialty_Operations__c == False && 
                faf.Billing_Operations__c == False && faf.Rebate_Operations__c == False && faf.Clinical_Operations__c == False && faf.Guarantee_Information__c == False ) {
                    faf.FAF_Type__c = null;
                }
            
        } 
    }  
    
    //Added by Sridevi for Req. BR 33, 34, 1.8 in I-7 
    public static void updateClientInfoEffectiveDate(Map<Id, Central_Hub__c> newFaf, Map<Id, Central_Hub__c> oldFaf){
        Set<Id> fafIds = new Set<Id>();
        for(Central_Hub__c newFafRec : newFaf.values()){
            if(newFafRec.Business_Type__c != oldFaf.get(newFafRec.Id).Business_Type__c){
                fafIds.add(newFafRec.Id);    
            }
        }
        
        List<Client_Information__c> fafClientInfo = [Select Rebate_Effective_Date__c, 
                                                     Pricing_Effective_Date__c,
                                                     FAF_ID__r.Business_Type__c
                                                     from 
                                                     Client_Information__c
                                                     Where
                                                     FAF_ID__c IN: fafIds];
        //newFaf.values()[0].addError('the error is' + fafClientInfo[0].FAF_ID__r.Business_Type__c);
        List<Client_Information__c> fafClientInfoToUpdate = new List<Client_Information__c>();
        for(Client_Information__c fafClientInfoRec : fafClientInfo){
            if(fafClientInfoRec.FAF_ID__r.Business_Type__c == 'New' || fafClientInfoRec.FAF_ID__r.Business_Type__c == 'Add On'){
                fafClientInfoRec.Rebate_Effective_Date__c = fafClientInfoRec.Pricing_Effective_Date__c;
                //newFaf.values()[0].addError('the error is' + fafClientInfo);
                
            }
            else if(fafClientInfoRec.FAF_ID__r.Business_Type__c == 'Existing' && fafClientInfoRec.Pricing_Effective_Date__c <> null){
                Date quaterStartDate;
                if(fafClientInfoRec.Pricing_Effective_Date__c.Month() <= 3){
                    quaterStartDate = Date.newInstance(fafClientInfoRec.Pricing_Effective_Date__c.Year(), 1,1);   
                }
                else if(fafClientInfoRec.Pricing_Effective_Date__c.Month() <= 6){ 
                    quaterStartDate = Date.newInstance(fafClientInfoRec.Pricing_Effective_Date__c.Year(), 4,1);
                }
                else if(fafClientInfoRec.Pricing_Effective_Date__c.Month() <= 9){
                    quaterStartDate = Date.newInstance(fafClientInfoRec.Pricing_Effective_Date__c.Year(), 7,1);   
                }
                else{ 
                    quaterStartDate = Date.newInstance(fafClientInfoRec.Pricing_Effective_Date__c.Year(), 10,1);
                }
                //System.debug(clientInfo.Pricing_Effective_Date__c+'******** Effective Date ********'+clientInfo.Pricing_Effective_Date__c);
                //System.debug('******** Quater Start Date ********'+quaterStartDate);
                if(fafClientInfoRec.Pricing_Effective_Date__c == quaterStartDate){
                    fafClientInfoRec.Rebate_Effective_Date__c = quaterStartDate;
                }
                else{
                    fafClientInfoRec.Rebate_Effective_Date__c =  quaterStartDate.AddMonths(3);
                }
                //newFaf.values()[0].addError('the error is' +  fafClientInfoRec.Rebate_Effective_Date__c);
            }
            else if(fafClientInfoRec.Pricing_Effective_Date__c == null){
                fafClientInfoRec.Rebate_Effective_Date__c = null;
            }
            fafClientInfoToUpdate.add(fafClientInfoRec);
        }
        
        if(!fafClientInfoToUpdate.isEmpty()){
           try{
            Config_Validation_for_Clientinfo__c cs = Config_Validation_for_Clientinfo__c.getOrgDefaults();
            cs.By_Pass_CI_Validation__c = true;
            
            upsert cs;
            update fafClientInfoToUpdate;
            cs.By_Pass_CI_Validation__c = false;
            //Exception Handling :OffShore,Mohit Srivastava
            
              upsert cs;
            }
            catch(Exception ex){
                for(Central_Hub__c newFafRec : newFaf.values()){
                 newFafRec.adderror(ex.getDMLMessage(0));
                }
            }
            
            
        }
        
    }
    public static void underwriterCheck(Map<Id, Central_Hub__c> oldFAFMap, List<Central_Hub__c> newFAFList) {
        
        List<ID> accountIds = new List<ID>();
        List<ID> underwriterIds = new List<ID>();
        Map<id,String> accSegmentMap = new Map<id,String>();
        Map<id,List<String>> userSegmentMap = new Map<id,List<String>>();
        
        for(Central_Hub__c faf: newFAFList){ 
            if((Trigger.isInsert && faf.Underwriter__c !=null) || (Trigger.isUpdate && faf.Underwriter__c !=null && oldFAFMap.get(faf.Id).Underwriter__c != faf.Underwriter__c)){ 
                accountIds.add(faf.Account_Name__c);   
                underwriterIds.add(faf.Underwriter__c);      
            }
        } 
        
        List<Account> accountList = [select id,Market_Segment__c from account where id in:accountIds and Market_Segment__c!= null ];
        List<User> userList = [select id,Market_Segment__c from user where id in:underwriterIds and Market_Segment__c!= null ];
        
        for(Account a: accountList){
            accSegmentMap.put(a.id,a.Market_Segment__c);
        }
        
        for(user u: userList){
            List<String> segmentList = new List<String>();
            segmentList.addAll(u.Market_Segment__c.split(';'));
            userSegmentMap.put(u.id,segmentList);
        }
        
        for(Central_Hub__c faf: newFAFList){
            string accountSegment;
            if((Trigger.isInsert && faf.Underwriter__c !=null) || (Trigger.isUpdate && faf.Underwriter__c !=null && oldFAFMap.get(faf.Id).Underwriter__c != faf.Underwriter__c)){ 
                if(accSegmentMap.containskey(faf.Account_Name__c)){
                    accountSegment =  accSegmentMap.get(faf.Account_Name__c); 
                    if(userSegmentMap.containskey(faf.Underwriter__c)){
                        List<String> userSegment = userSegmentMap.get(faf.Underwriter__c);
                        if(!userSegment.contains(accountSegment)){
                            faf.addError('Selected Underwriter is not assigned to the same  ‘Market Segment’ as on the Account.');  
                        }
                    }else{
                        faf.addError('Selected ‘Underwriter’ is not assigned to any ‘Market Segment’.');   
                    }
                }else{
                    faf.addError('Please add Segment to Account'); 
                }
            }        
            if(faf.Underwriter__c == null)  {
                //faf.addError('Please populate the underwriter');          
            }      
        } 
        
    }
    
    public static void peerReviewCheck(Map<Id, Central_Hub__c> oldFAFMap, List<Central_Hub__c> newFAFList) {
        
        List<ID> accountIds = new List<ID>();
        List<ID> peerReviewIds = new List<ID>();
        Map<id,String> accSegmentMap = new Map<id,String>();
        Map<id,List<String>> userSegmentMap = new Map<id,List<String>>();
        
        for(Central_Hub__c faf: newFAFList){
            
            if((Trigger.isInsert && faf.Peer_Reviewer__c != null) || (Trigger.isUpdate && faf.Peer_Reviewer__c != null && oldFAFMap.get(faf.Id).Peer_Reviewer__c != faf.Peer_Reviewer__c)) { 
                accountIds.add(faf.Account_Name__c);             
                peerReviewIds.add(faf.Peer_Reviewer__c);   
                
            }     
        } 
        
        List<Account> accountList = [select id,Market_Segment__c from account where id in:accountIds and Market_Segment__c!= null ];
        List<User> userList = [select id,Market_Segment__c from user where id in:peerReviewIds and Market_Segment__c!= null ];
        
        if(accountList.size()>0){
            for(Account a: accountList){
                accSegmentMap.put(a.id,a.Market_Segment__c);
            }
        }
        if(userList.size()>0){
            for(user u: userList){
                List<String> segmentList = new List<String>();
                segmentList.addAll(u.Market_Segment__c.split(';'));
                userSegmentMap.put(u.id,segmentList);
            }
        }
        
        for(Central_Hub__c faf: newFAFList){
            if((Trigger.isInsert && faf.Peer_Reviewer__c != null) || (Trigger.isUpdate && faf.Peer_Reviewer__c != null && oldFAFMap.get(faf.Id).Peer_Reviewer__c != faf.Peer_Reviewer__c)) { 
                string accountSegment;
                if(accSegmentMap.containskey(faf.Account_Name__c)){
                    accountSegment =  accSegmentMap.get(faf.Account_Name__c); 
                    if(userSegmentMap.containskey(faf.Peer_Reviewer__c)){
                        List<String> userSegment = userSegmentMap.get(faf.Peer_Reviewer__c);
                        if(!userSegment.contains(accountSegment)){
                            faf.addError('Selected ‘Peer Reviewer’ is not assigned to the same  ‘Market Segment’ as on the Account.');  
                        }
                    }else{
                        faf.addError('Selected ‘Peer Reviewer’ is not assigned to any ‘Market Segment’.');   
                    }
                }else{
                    faf.addError('Please add the Market segment to Account'); 
                }
            }        
        } 
        
    }  
    
    public static void validateLinkFAF(List<Central_Hub__c> FAFList) {
        ValidateFAFlinkhelper.validateLinkFAF(FAFList);
    }
    
    public static void populateUnderwriter(List<Central_Hub__c> FAFList) {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        Set<ID> fafIds = new Set<ID>();       
        for(Central_Hub__c faf: FAFList){
            if(faf.Underwriter__c == null && profileName =='Apttus Underwriting'){
                faf.Underwriter__c = Userinfo.getuserID();
            } 
        }            
    }
    
    
    public static void populateUnderwriterCreatedBy(List<Central_Hub__c> FAFList) {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        Set<ID> fafIds = new Set<ID>();       
        for(Central_Hub__c faf: FAFList){
            if(faf.Underwriter__c == null && profileName =='Apttus Underwriting'){
                faf.Underwriter__c = faf.CreatedbyID;
            }
        }            
    }    
    
    //changes by Sonal Sharma for US47416
    public static void populateMarketSegment(List<Central_Hub__c> FAFList) {
        
        Set<id> accountIds = new Set<id>();
        
        for(Central_Hub__c faf: FAFList){
            accountIds.add(faf.Account_Name__c);
        }
        
        List<Account> accList = [Select id,Market_Segment__c from Account where id in:accountIds ];
        Map<id,String> accountMarketsegmentMap = new Map<id,String>();
        
        if(!accList.isEmpty()){
            for(Account acc: accList){
                accountMarketsegmentMap.put(acc.id,acc.Market_Segment__c);     
            }
        }
        if(!accountMarketsegmentMap.isEmpty()){
            for(Central_Hub__c faf: FAFList){  
                faf.Segment__c = accountMarketsegmentMap.get(faf.Account_Name__c);  
           } 
        }
    }
    
    
    
    /***********************************************
Added by Sai Sivamgula for Apttus IPI call
This method will call Apex class FAFIPITriggerCall
************************************************/
    public static void updateFAFIDonIPIWAs(List<Central_Hub__c> FAFtgrList, MAP<Id, Central_Hub__c> fafOldMap) {
        
        FAFIPITriggerCall.UpdateFAFIDWAstatus(FAFtgrList, fafOldMap); 
        
    }
    
    
    // Added by Kiranmai for Rqe BR 33, 34, 1.2.1
    public static boolean validateFAFStatusCheck = true;
    public static void validateFAFStatus( map<Id,Central_Hub__c>FAFMap, map<Id,Central_Hub__c>FAFOldMap)
    {
        
        if( validateFAFStatusCheck ){
            set<Id> fafIdSet = new set<Id>();   
            set<string> setFAFStatus = new set<string>{'Peer Review','Sales Review','Sales Approved','Implemented'};
                for( Central_Hub__c faf:FAFMap.values() )
            {
                
                if(faf.Source_Copy_FAF_Status__c != 'Disable Validations' && faf.FAF_Status__c <> null && (((setFAFStatus.contains(faf.FAF_Status__c) && FAFOldMap.get(faf.id).FAF_Status__c != FAFMap.get(faf.id).FAF_Status__c)) || FAFMap.get(faf.id).Peer_Reviewed__c==true) )
                {
                    
                    fafIdSet.add(faf.Id);
                }
            }
            
            if( !fafIdSet.isEmpty() ){
                for( Mail_Operations__c mo : [ SELECT Id, FAF_Id__c, (SELECT Id FROM FAF_Mail_Pricing__r LIMIT 1) FROM Mail_Operations__c WHERE FAF_ID__c IN :fafIdSet ] )
                {
                    if( mo.FAF_Mail_Pricing__r.isempty() )
                    {
                        FAFMap.get( mo.FAF_Id__c ).addError('At least one Mail Pricing record is required for Mail Operations component.');
                    }
                }
                
                for( Network_Operations__c NO : [ SELECT Id, FAF_Id__c, (SELECT Id FROM FAF_Network_Pricing__r LIMIT 1) FROM Network_Operations__c WHERE FAF_ID__c IN :fafIdSet ] )
                {
                    if( NO.FAF_Network_Pricing__r.isempty() )
                    {
                        FAFMap.get( NO.FAF_Id__c ).addError('At least one Network Pricing record is required for the Network Operations.');
                    }
                }
                
                for( Network_Operations__c NOP : [ SELECT Id, FAF_Id__c, Type__c, (SELECT Id FROM Transaction_Fee_Sharing_Tier__r LIMIT 1) FROM Network_Operations__c WHERE FAF_ID__c IN :fafIdSet ] )
                {
                    
                    if( NOP.Transaction_Fee_Sharing_Tier__r.isempty() && NOP.Type__c == 'Tiered')
                    {
                        FAFMap.get( NOP.FAF_Id__c ).addError('At least one Transaction Fee Sharing Tier is required when Retail Network Transaction Fee Sharing Type is selected as Tiered on Network Operations.');
                    }
                }
                
                
                //Adding the conditions by offshore for Guarantee Information objects 
                //Prakarsh W-000726 removed Average_Sales_Price_Per_Client_ASP__c reference
                for( Guarantees_Information__c GI : [SELECT Id, FAF_Id__c, Generic_Dispensing_Rate_GDR_Guarantee__c, Trend_Guarantee__c, (SELECT Id FROM GDR_Guarantee_Details__r LIMIT 1),(SELECT Id FROM Trend_Guarantee_Details__r LIMIT 1),(SELECT Id FROM Gnc_Guarantee_Details__r LIMIT 1) FROM Guarantees_Information__c WHERE FAF_ID__c IN :fafIdSet ] )
                {
                    //Prakarsh Commented Code as per W-000726
                    /*if( GI.ASP_Guarantee_Details__r.isempty() && GI.Average_Sales_Price_Per_Client_ASP__c== True )
                    {
                        FAFMap.get(GI.FAF_Id__c ).addError(ConstantsUtil.ASPGTEEERROR);
                    }*/
                    if( GI.Trend_Guarantee_Details__r.isempty() && GI.Trend_Guarantee__c== 'Yes' )
                    {
                        FAFMap.get(GI.FAF_Id__c ).addError(ConstantsUtil.TRENDGTEEERROR);
                    }                   
                    if( GI.GDR_Guarantee_Details__r.isempty() && GI.Generic_Dispensing_Rate_GDR_Guarantee__c== 'Yes'  )
                    {
                        FAFMap.get(GI.FAF_Id__c ).addError(ConstantsUtil.GDRGTEEERROR);
                    }
                } 
            }    
            
        }
    }
    
    
    /* =================================================================================
* @Method Name        : UpdateFafstatusOnClient
* @author            : Mohit Srivastava(Accenture Offshore)
* @created date      : NA
* @Purpose           : To Nullify the Rebate Effective Date and Pricing Effective Date according to FAF status
=======================================================================================*/
    public static void UpdateFafstatusOnClient(List<Central_Hub__c> FAFList, Map<Id, Central_Hub__c> oldFAFMap) {
        Set<ID> fafsetID=new Set<ID>();
        Set<ID> fafsetIDforClientInfo = new Set<ID>();
        Set<ID> fafsetIDforAccount = new Set<ID>();
        Set<ID> accountIdSetFinal = new Set<ID>();
        Set<ID> filalFafIdSet = new Set<ID>();
        List<Account> accList = new List<Account>();
        List<Client_Information__c> fafClientInfoUpdate =new List<Client_Information__c>();
        for(Central_Hub__c faf: FAFList){
            
            if(faf.FAF_Status__c!='Implemented'){
                fafsetID.add(faf.id);                                                                   
            }
            if(faf.Account_Name__c != oldFAFMap.get(faf.id).Account_Name__c){
                fafsetIDforClientInfo.add(faf.id);
                fafsetIDforAccount.add(faf.Account_name__c);
            }
        }
        if(fafsetIDforAccount.size() > 0){
            accList = [select id, iUMS_Client_Subtype__c from Account where id in: fafsetIDforAccount];
            for(Account acc: accList){
                if((acc.iUMS_Client_Subtype__c == 'Coalition Master' || acc.iUMS_Client_Subtype__c == 'Health Plan Master' || acc.iUMS_Client_Subtype__c == 'TPA Master' ) && acc.iUMS_Client_Subtype__c != null){
                    accountIdSetFinal.add(acc.id);
                }
            }
        }
        filalFafIdSet.addall(fafsetID);
        filalFafIdSet.addall(fafsetIDforClientInfo);
        if(filalFafIdSet.size()>0){
            List<Client_Information__c> fafClientInfo = [Select Rebate_Effective_Date__c,Pricing_Effective_Date__c, FAF_ID__c, Master_Client_Name__c, FAF_Status__c, Faf_Id__r.Account_name__c from Client_Information__c Where FAF_ID__c in: filalFafIdSet];
            for(Client_Information__c clientinf :fafClientInfo){
                if(fafsetID.contains(clientinf.FAF_ID__c)){
                    clientinf.Pricing_Effective_Date__c=null;
                    clientinf.Rebate_Effective_Date__c=null;
                }
                if(fafsetIDforClientInfo.contains(clientinf.FAF_ID__c) && accountIdSetFinal.contains(clientinf.Faf_Id__r.Account_name__c)){
                    clientinf.Master_Client_Name__c = null;
                    //clientinf.Rebate_Effective_Date__c=null;
                }
             if(clientinf.FAF_Status__c=='Closed'){     
                clientinf.bulk_update__c = True;
                }
                fafClientInfoUpdate.add(clientinf);
            }
            if(!fafClientInfoUpdate.isEmpty()){
            //Exception Handling :Mohit Srivastava
                try{
                    update fafClientInfoUpdate;
                }
                Catch(Exception ex){
                          for(Central_Hub__c faf: FAFList){
                                faf.adderror(ex.getDMLMessage(0));
                          }
                }
            }
        }
    }
    /* =================================================================================
* @Method Name        : CreateClientAndLegalInfo
* @author            : Mohit Srivastava(Accenture Offshore)
* @created date      : NA
* @Purpose           : To create legal information and client information after FAF is inserted
=======================================================================================*/
    public static void CreateClientAndLegalInfo(List<Central_Hub__c> FAFList){
        
        List<Client_Information__c> ClientInfoUpdateList =new List<Client_Information__c>();
        List<Legal_Information__c> LegalInfoListUpdate=new List<Legal_Information__c>();
        
        for(Central_Hub__c fafObj: FAFList){
            if (fafObj.FAF_Status__c != 'Uploaded' && !fafObj.Copy_Pending__c) {
                Client_Information__c ClientInfoObj =new Client_Information__c(); 
                ClientInfoObj.FAF_ID__c=fafObj.id;
                ClientInfoUpdateList.add(ClientInfoObj);
                Legal_Information__c legalInfoObj=new Legal_Information__c();
                legalInfoObj.FAF_ID__c=fafObj.id;
                LegalInfoListUpdate.add(legalInfoObj);
           }
        }
        if(!ClientInfoUpdateList.isEmpty()){
        //Exception Handling Changes:Offshore, Mohit Srivastava
           try{
            insert ClientInfoUpdateList;
            }
            Catch(Exception ex){
                 for(Central_Hub__c fafObj: FAFList){
                fafObj.adderror(ex.getDMLMessage(0));
                }
            }
        }
        if(!LegalInfoListUpdate.isEmpty()){
        //Exception Handling Changes:Offshore, Mohit Srivastava
        try{
            insert LegalInfoListUpdate;
        }
        Catch(Exception ex){
            for(Central_Hub__c fafObj: FAFList){
                fafObj.adderror(ex.getDMLMessage(0));
            }
        }
        
        }
        
        
    }
    /* =================================================================================
* @Method Name        : CrossComponentValidations 
* @author            : Mohit Srivastava(Accenture Offshore)
* @created date      : NA
* @Purpose           : Validate components(child record) of FAF
=======================================================================================*/
    public static void CrossComponentValidations(Map<Id, Central_Hub__c> oldFAFMap,List<Central_Hub__c> FAFList){
        
        Set<ID> FAFsetId=new Set<ID>();
        Set<ID> FAFClientId=new Set<ID>();
        Set<ID> AccountSetID=new Set<ID>();
        Integer billingsize;
        Map<ID,Set<String>> mapFAFIDretail=new Map<ID,Set<String>>();
        Map<ID,Set<String>> mapFAFIDmail=new Map<ID,Set<String>>();
        Map<ID,Boolean> mapRPTDMflag=new Map<ID,Boolean>();
        Map<ID,List<String>> mapFAFIDBillingOps=new Map<ID,List<String>>();
        Map<ID,String> mapRebateOps=new Map<ID,String>();
        Map<ID,String> mapFAFIDRebateOps=new Map<ID,String>();
        Map<ID,String> mapPlatformOps=new Map<ID,String>();
        List<Central_Hub__c> FAFListUpdate=new List<Central_Hub__c>();
        List<Account> AccountCheckList=new List<Account>();
        Set<String> StrRetailList=new Set<String>();
        Set<String> StrMailList=new Set<String>();
        Map<ID,List<Billing_Administrative_Fees__c>> mapBillingOpsForRebate=new Map<ID,List<Billing_Administrative_Fees__c>>();
        List<Billing_Administrative_Fees__c> BillAdminList=new List<Billing_Administrative_Fees__c>();
        List<Billing_Administrative_Fees__c> BillAdminRebateList=new List<Billing_Administrative_Fees__c>();
        Map<Id,Central_Hub__c> FAFMap= new Map<Id,Central_Hub__c>();
        Map<Id, String> mailOpsMap = new Map<Id, String>();
        Map<Id, String> networkOpsMap = new Map<Id, String>();
        Map<Id, String> networkOpsTMap = new Map<Id, String>();
        Map<Id, String> guaranteeMap = new Map<Id, String>();
        Map<Id, String> guaranteeAMap = new Map<Id, String>();
        Map<Id, String> guaranteeGMap = new Map<Id, String>();
        String StrPCDWarning =''; // PCD Warning 06/12
        /*** start W-000540 ***/
        boolean skipRTMDandAFTypeCheck=true;
        /*** End W-000540 ***/
        for(Central_Hub__c FAFObj:FAFList){
           // FAFsetId.add(FAFObj.ID);
            if((FAFObj.ComponentValidation__c==true
               && (( FAFObj.FAF_Status__c=='Draft')
                   ||(FAFObj.FAF_Status__c =='Sales Review')
                   ||(FAFObj.FAF_Status__c=='Implemented' )) 
               && FAFObj.Approval_Status__c =='Approval Required' && FAFObj.Error_Flag__c==true ) ||(FAFObj.FAF_Status__c=='Uploaded')){ // PCD Warning Change
               
                   if (FAFObj.Source_Copy_FAF_Status__c != 'Disable Validations') {
                   FAFsetId.add(FAFObj.ID);
                   FAFMap.put(FAFObj.ID,FAFObj);
                   /*** start W-000540 ***/
                   if(FAFObj.Client_Subtype__c!='Coalition Master' && FAFObj.Client_Subtype__c!='TPA Master' && FAFObj.Client_Subtype__c!='Health Plan Master'){
                       skipRTMDandAFTypeCheck=false;
                   }
                   }
                   /*** End W-000540 ***/
               }
            
            /***********Client Information Component Validation*********/
            if(FAFObj.FAF_Status__c=='Implemented' && FAFObj.Source_Copy_FAF_Status__c != 'Disable Validations'){
                FAFClientId.add(FAFObj.id);
                AccountSetID.add(FAFObj.Account_Name__c);
            }            
            
        }
        if(!FAFsetId.isEmpty()){
                for( Mail_Operations__c mo : [ SELECT Id, FAF_Id__c, (SELECT Id FROM FAF_Mail_Pricing__r LIMIT 1) FROM Mail_Operations__c WHERE FAF_ID__c IN :FAFsetId] )
                {
                    if( mo.FAF_Mail_Pricing__r.isempty() )
                    {
                        mailOpsMap.put(mo.FAF_Id__c, 'At least one Mail Pricing record is required for Mail Operations component.');
                    }
                }
                for( Network_Operations__c NO : [ SELECT Id, FAF_Id__c, Type__c,Speciality_Pricing__c, (SELECT Id FROM FAF_Network_Pricing__r LIMIT 1),(SELECT Id FROM Transaction_Fee_Sharing_Tier__r LIMIT 1) FROM Network_Operations__c WHERE FAF_ID__c IN :FAFsetId] )
                {
                    if( NO.FAF_Network_Pricing__r.isempty()) // PCD Warning Change
                    {
                        networkOpsMap.put(NO.FAF_Id__c,'At least one Network Pricing record is required for the Network Operations.');
                        StrPCDWarning = 'FAF - ' + FAFList[0].Name + '\n\n' + String.ValueOf(Label.PCD_Warning_Specialty_Network + '\n\n'); // PCD Warning Change
                    }
                    if( NO.Transaction_Fee_Sharing_Tier__r.isempty() && NO.Type__c == 'Tiered')
                    {
                        networkOpsTMap.put(NO.FAF_Id__c,'At least one Transaction Fee Sharing Tier is required when Retail Network Transaction Fee Sharing Type is selected as Tiered on Network Operations.');
                    }
                    //PCD Warning Change
                    if( NO.Speciality_Pricing__c == 0 )
                    {
                        StrPCDWarning = 'FAF - ' + FAFList[0].Name + '\n\n' + String.ValueOf(Label.PCD_Warning_Specialty_Network + '\n\n');
                    }
                }
                //Prakarsh W-000726 removed Average_Sales_Price_Per_Client_ASP__c reference
                for( Guarantees_Information__c GI : [SELECT Id, FAF_Id__c, Generic_Dispensing_Rate_GDR_Guarantee__c, Trend_Guarantee__c, (SELECT Id FROM GDR_Guarantee_Details__r LIMIT 1),(SELECT Id FROM Trend_Guarantee_Details__r LIMIT 1),(SELECT Id FROM Gnc_Guarantee_Details__r LIMIT 1) FROM Guarantees_Information__c WHERE FAF_ID__c IN :FAFsetId] )
                {
                    //Prakarsh Commented Code as per W-000726
                    /*if( GI.ASP_Guarantee_Details__r.isempty() && GI.Average_Sales_Price_Per_Client_ASP__c== True )
                    {
                        guaranteeMap.put(GI.FAF_Id__c,(ConstantsUtil.ASPGTEEERROR));
                    }*/
                    if( GI.Trend_Guarantee_Details__r.isempty() && GI.Trend_Guarantee__c== 'Yes')
                    {
                        guaranteeAMap.put(GI.FAF_Id__c,(ConstantsUtil.TRENDGTEEERROR));
                    }                   
                    if( GI.GDR_Guarantee_Details__r.isempty() && GI.Generic_Dispensing_Rate_GDR_Guarantee__c== 'Yes')
                    {
                        guaranteeGMap.put(GI.FAF_Id__c,(ConstantsUtil.GDRGTEEERROR));
                    }
                } 
            /***For Retail Network Guarantee**************/
            List<Retail_Network_Guarantees__c> retailnetworkgrList=new List<Retail_Network_Guarantees__c>();
            retailnetworkgrList=[Select Id,Name,Network_Pricing__c,FAF_ID__c,SSG__c,Network_Pricing__r.SSG_Exclusion_List__c,
                                 Network_Pricing__r.SSG_Exclusivity_Period__c,Network_Pricing__r.Network_Name__c,Network_Pricing__r.Year__c,Network_Pricing__r.LOB__c,Type__c,
                                 Network_Pricing__r.GER_with_SSG_Excluded__c,Network_Pricing__r.SSG_Guarantee__c   // PCD Warning Change
                                 from Retail_Network_Guarantees__c 
                                 where FAF_ID__c IN :FAFsetId];
             Integer SSGcheck =1;
            /* if (retailnetworkgrList.isempty()) // PCD Warning Change
                {
                
                }
            else
               {
                if (retailnetworkgrList[0].Network_Pricing__r.GER_with_SSG_Excluded__c > 0 && retailnetworkgrList[0].Network_Pricing__r.SSG_Guarantee__c == 0) // PCD Warning change 
                  {
                   SSGcheck =0;
                  }
               } */
           
            for(Retail_Network_Guarantees__c networkObj:retailnetworkgrList){
                if(networkObj.SSG__c=='No'){
                  if (networkObj.Network_Pricing__r.GER_with_SSG_Excluded__c > 0 && networkObj.Network_Pricing__r.SSG_Guarantee__c == 0) // PCD Warning change 
                  {
                   SSGcheck =0;
                  }
                    if(String.isBlank(networkObj.Network_Pricing__r.SSG_Exclusion_List__c)&& 
                       String.isBlank(networkObj.Network_Pricing__r.SSG_Exclusivity_Period__c)){
                           StrRetailList.add(String.ValueOf(networkObj.Network_Pricing__r.Year__c)+', '+String.ValueOf(networkObj.Network_Pricing__r.LOB__c)+', '+String.ValueOf(networkObj.Network_Pricing__r.Network_Name__c));
                           mapFAFIDretail.put(networkObj.FAF_ID__c,StrRetailList);
                       }
                }
               
            }
            If (SSGcheck == 0)  // PCD Warning change 
            {
               if (StrPCDWarning == '')
               {
                 StrPCDWarning += 'FAF - ' + FAFList[0].Name + '\n\n' + String.ValueOf(Label.PCD_Warning_SSG + '\n\n');
               }
               else
               {
                 StrPCDWarning += String.ValueOf(Label.PCD_Warning_SSG + '\n\n');
               }
            }
            /****For Mail Pricing**************/
            List<Mail_Guarantees__c> retailMailList=new List<Mail_Guarantees__c>();
            retailMailList=[Select Id,Name,Mail_Pricing__c,FAF_ID__c,SSG__c,Mail_Pricing__r.SSG_Exclusion_List__c,Mail_Pricing__r.SSG_Exclusivity_Period__c,Mail_Pricing__r.LOB__c,Mail_Pricing__r.Year__c 
                            from Mail_Guarantees__c 
                            where FAF_ID__c IN :FAFsetId];
            for(Mail_Guarantees__c mailObj:retailMailList){
                if(mailObj.SSG__c=='No'){
                    if(String.isBlank(mailObj.Mail_Pricing__r.SSG_Exclusion_List__c)&& 
                       String.isBlank(mailObj.Mail_Pricing__r.SSG_Exclusivity_Period__c)){
                           StrMailList.add(String.ValueOf(mailObj.Mail_Pricing__r.Year__c)+', '+String.ValueOf(mailObj.Mail_Pricing__r.LOB__c));
                           mapFAFIDmail.put(mailObj.FAF_ID__c,StrMailList);
                       }
                }
            }

            /****For Billing Opertaion and Rebate Operation**********/
            List<String> StrList=new List<String>();
            List<Rebate_Operations__c> rebateOperationFlagList=new List<Rebate_Operations__c>();
             /*** start W-000540 ***/
             //Skip this check if the client subtype is Coalition Master or TPA Master or Health Plan Master client.
           // if(!skipRTMDandAFTypeCheck){  PCD Warning Change
                    rebateOperationFlagList=[Select Id,Name,Rebate_RTMD__c,FAF_ID__c,Specialty_Rebate__c,Specialty_Rebate_Percentage__c  from Rebate_Operations__c 
                                             where FAF_ID__c IN :FAFsetId];
                    if (rebateOperationFlagList.isEmpty())
                    {
                    if (StrPCDWarning == '')
                        {
                          StrPCDWarning += 'FAF - ' + FAFList[0].Name + '\n\n' + String.ValueOf(Label.PCD_Warning_Specialty_Retail + '\n\n');
                        }
                      else 
                        {
                          StrPCDWarning += String.ValueOf(Label.PCD_Warning_Specialty_Retail + '\n\n');
                        }
                    }
                    for(Rebate_Operations__c rebateObj:rebateOperationFlagList){
                    //Start:Changes Done By Mohit Srivastava  Dated 10/Nov as a part of defect fix
                       if(!skipRTMDandAFTypeCheck){ // PCD Warning Change
                        mapRPTDMflag.put(rebateObj.FAF_ID__c,rebateObj.Rebate_RTMD__c);
                        mapFAFIDRebateOps.put(rebateObj.FAF_ID__c,rebateObj.Name);
                                                 }
                      if(rebateObj.Specialty_Rebate__c == 0 && rebateObj.Specialty_Rebate_Percentage__c==0) // PCD Warning change 
                      {
                      if (StrPCDWarning == '')
                        {
                          StrPCDWarning += 'FAF - ' + FAFList[0].Name + '\n\n' + String.ValueOf(Label.PCD_Warning_Specialty_Retail + '\n\n');
                        }
                      else {
                          StrPCDWarning += String.ValueOf(Label.PCD_Warning_Specialty_Retail + '\n\n');
                           }
                      }                          
                    }
                    
                    List<Billing_Administrative_Fees__c> BillingAdminList=new List<Billing_Administrative_Fees__c>();
                    BillingAdminList=[Select Id,Year__c,Admin_Fee_Type__c,FAF_ID__c,LOB__c  
                                      from Billing_Administrative_Fees__c 
                                      where FAF_ID__c IN :FAFsetId];
                    
                    billingsize=BillAdminList.size();
                    for(Billing_Administrative_Fees__c billiObj:BillingAdminList){
                        BillAdminList.add(billiObj);
                        
                        mapBillingOpsForRebate.put(billiObj.FAF_ID__c,BillAdminList);
                        if((billiObj.Admin_Fee_Type__c=='RTMD PEPM' ||billiObj.Admin_Fee_Type__c=='RTMD Per All Claims' 
                            || billiObj.Admin_Fee_Type__c=='RTMD PMPM') && (mapRPTDMflag.get(billiObj.FAF_ID__c)==false||mapRPTDMflag.get(billiObj.FAF_ID__c)==null)){
                                StrList.add(String.ValueOf(billiObj.Year__c)+', '+String.ValueOf(billiObj.LOB__c)+', '+String.ValueOf(billiObj.Admin_Fee_Type__c));
                                mapFAFIDBillingOps.put(billiObj.FAF_ID__c,StrList);
                            }   
                    }
                    for(Rebate_Operations__c rebateObj:rebateOperationFlagList){
                    //Start:Changes Done By Mohit Srivastava  Dated 10/Nov as a part of defect fix
                        if(!skipRTMDandAFTypeCheck){  // PCD Warning Change
                        if(rebateObj.Rebate_RTMD__c==true){
                        //rebateBillingCheck=true;
                            if(mapBillingOpsForRebate.get(rebateObj.FAF_ID__c)!=null){
                                BillAdminRebateList.addAll(mapBillingOpsForRebate.get(rebateObj.FAF_ID__c));
                                rebateCheck=true;
                            }
                            if(mapBillingOpsForRebate.get(rebateObj.FAF_ID__c)==null && mapRPTDMflag.get(rebateObj.FAF_ID__c)==true){
                                //BillAdminRebateList.addAll(mapBillingOpsForRebate.get(rebateObj.FAF_ID__c));
                                rebateBillingCheck=true;
                            }
                          }
                        }
                    }
                    for(Billing_Administrative_Fees__c billOb:BillAdminRebateList){
                        if((billOb.Admin_Fee_Type__c=='RTMD PEPM' || billOb.Admin_Fee_Type__c=='RTMD Per All Claims' 
                            || billOb.Admin_Fee_Type__c=='RTMD PMPM')){
                                mapRebateOps.put(billOb.FAF_ID__c,mapFAFIDRebateOps.get(billOb.FAF_ID__c));
                            }
                    }
                    
           // }  PCD Warning Change
            
            /**************For Platform Specifics***********/
            List<Platform_Specifics__c> PlatformList=new List<Platform_Specifics__c>();
            List<Account> accountList=new List<Account>();
            for(Account acc:[Select ID,iUMS_Client_Subtype__c from Account Where ID IN:AccountSetID]){
            /** W-000555 :Production - Platform Specifics CAG record required needs to be relaxed for TPA and Coalition Member clients (Code) :Accenture OffShore***/
                
                String cLabel = System.Label.ClientSubType_All_Cross_Component_Exclusion;
                List<String> choosingClientType = new List<String>();
                choosingClientType=cLabel.split(',');
                        if(!choosingClientType.contains(acc.iUMS_Client_Subtype__c)){
                             AccountCheckList.add(acc);
                             
                        }
                       
            }
            if(!AccountCheckList.isEmpty()){
                PlatformList=[Select ID,Name,FAF_ID__c, Client_Information__c From Platform_Specifics__c where FAF_ID__c IN :FAFClientId];
                for(Platform_Specifics__c platObj:PlatformList)
                    mapPlatformOps.put(platObj.FAF_ID__c,platObj.Name);
            }
        }
        List<Central_Hub__c> faflistError=new  List<Central_Hub__c>();       
        faflistError=[Select ID,Error_Message__c from Central_Hub__c where ID IN:FAFsetId];
        for(Central_Hub__c FAFObj:faflistError){
            strErrorMessages=' ';
            if(mailOpsMap.get(FAFObj.ID) !=null){            
                strErrorMessages+=mailOpsMap.get(FAFObj.ID)+'\n';
            }
            if(networkOpsMap.get(FAFObj.ID) !=null){            
                strErrorMessages+=networkOpsMap.get(FAFObj.ID)+'\n';
            } 
            if(networkOpsTMap.get(FAFObj.ID) !=null){            
                strErrorMessages+=networkOpsTMap.get(FAFObj.ID)+'\n';
            }           
            if(guaranteeMap.get(FAFObj.ID) !=null){            
                strErrorMessages+=guaranteeMap.get(FAFObj.ID)+'\n';
            }
            if(guaranteeAMap.get(FAFObj.ID) !=null){            
                strErrorMessages+=guaranteeAMap.get(FAFObj.ID)+'\n';
            }
            if(guaranteeGMap.get(FAFObj.ID) !=null){            
                strErrorMessages+=guaranteeGMap.get(FAFObj.ID)+'\n';
            }
            if(mapFAFIDretail.get(FAFObj.ID) !=null){
                for(String Str:mapFAFIDretail.get(FAFObj.ID)){
                    strErrorMessages+=Label.ComponentValidation_Retail+':'+ '  '+' '+ '  '+str + '  ' + ' '+Label.Component_Validation_Retail_Err +'\n';
                }
            }
           //Start:Changes Done By Mohit Srivastava  Dated 10/Nov as a part of defect fix
                if(mapFAFIDBillingOps.get(FAFObj.ID) !=null && skipRTMDandAFTypeCheck ==false) {
                    for(String str:mapFAFIDBillingOps.get(FAFObj.ID)){
                        strErrorMessages+=Label.Billing_Administrative_Fees_Component_Validation+':'+ '  '+' '+ '  '+str + '  ' + ' '+Label.Component_Validation_Billing_Ops+'\n';
                    }
                }
           
            if(mapFAFIDmail.get(FAFObj.ID) !=null){
                for(String str:mapFAFIDmail.get(FAFObj.ID)){
                    strErrorMessages+=Label.Component_Validation_Mail_Pricing+':'+ '  '+' '+ '  '+str + '  ' + ' '+Label.Component_Validation_Mail_Pricing_Error +'\n';
                }
            }
            
            //Start:Changes Done By Mohit Srivastava  Dated 10/Nov as a part of defect fix
            if((mapRebateOps.get(FAFObj.ID)==null && skipRTMDandAFTypeCheck ==false &&  mapRPTDMflag.get(FAFObj.ID)==true) ||(mapBillingOpsForRebate.get(FAFObj.ID)==null  && mapRPTDMflag.get(FAFObj.ID)==true)){
                 //End:Changes Done By Mohit Srivastava  Dated 10/Nov as a part of defect fix
                            
                strErrorMessages+='Rebate Operations - '+ Label.Component_Validation_Rebate_Operation+'\n';
            }
            if(!AccountCheckList.isEmpty()&& !FAFClientId.isEmpty()){
                if(mapPlatformOps.get(FAFObj.ID)==null){
                    strErrorMessages+=label.Component_Validation_Platform;
                }
            }
            FAFObj.Error_Message__c=strErrorMessages;
            FAFObj.PCD_Warning__c=StrPCDWarning;
            FAFObj.AfterUpdateTriggerRun__c=true;
            FAFListUpdate.add(FAFObj);
            //break;
           
        }
        
        
        if(!FAFListUpdate.isEmpty()){
             DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
            //Exception Handling Changes:Offshore, Mohit Srivastava
            try{
              update FAFListUpdate;
            }
            catch(Exception ex){
                for(Central_Hub__c FAFObj:FAFList){
                 FAFObj.adderror(ex.getDMLMessage(0));
                }
            }
            
            
        }
    }
}