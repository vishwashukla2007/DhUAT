public with sharing class FAFInfoEditButton {
    public Id fafId;
    public Id currentUserId;
    public Central_Hub__c fafObj;
    public Boolean flag{get;set;}
   
    public Profile systemAdminProfile;
    public Profile underwriterProfile;
    

    @AuraEnabled
    public static boolean createapproval(String FAFRecId)
    {  
    boolean flag;
     system.debug('##########'+FAFRecId);
       //fafId = ApexPages.currentPage().getParameters().get('id'); 
      
        Central_Hub__c fafObj= [select id,Salesperson__c from Central_Hub__c where id =: FAFRecId];
       
        if(UserInfo.getUserId() == fafObj.Salesperson__c){
           flag=true;
           return flag;
        }
        
           List<User>  man1 = [Select Id from User where ManagerId = :UserInfo.getUserId()];
            if (man1.size() > 0 )
            {
             for(User man1item : man1)
             {
              List<Central_Hub__c> salesman1 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man1item.Id];
              if (salesman1.size() > 0 )
              {
                  flag=true;
                  return flag;
              }
             }  
            }
            
            List<User>  man2level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man2level.size() > 0 )
            {
            for(User man2levelitem : man2level)
            {
            List<User>  man2 = [Select Id from User where Manager_Level_2__c = :man2levelitem.Name];
            if (man2.size() > 0 )
            {
             for(User man2item : man2)
             {
              List<Central_Hub__c> salesman2 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man2item.Id];
              if (salesman2.size() > 0 )
              {
                  flag=true;
                  return flag;
              }
             }  
            }
            }}
               
            List<User>  man3level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man3level.size() > 0 )
            {
            for(User man3levelitem : man2level)
            {
            List<User>  man3 = [Select Id from User where Manager_Level_3__c = :man3levelitem.Name];
            if (man3.size() > 0 )
            {
             for(User man3item : man3)
             {
              List<Central_Hub__c> salesman3 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man3item.Id];
              if (salesman3.size() > 0 )
              {
                   flag=true;
                  return flag;
              }
             }  
            }
            }}
               
            List<User>  man4level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man4level.size() > 0 )
            {
            for(User man4levelitem : man4level)
            {
            List<User>  man4 = [Select Id from User where Manager_Level_4__c = :man4levelitem.Name];
            if (man4.size() > 0 )
            {
             for(User man4item : man4)
             {
              List<Central_Hub__c> salesman4 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man4item.Id];
              if (salesman4.size() > 0 )
              {
                  flag=true;
                  return flag; 
              }
             }  
            }
            }}   
               
           List<User>  man5level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man5level.size() > 0 )
            {
            for(User man5levelitem : man5level)
            {
            List<User>  man5 = [Select Id from User where Manager_Level_5__c = :man5levelitem.Name];
            if (man5.size() > 0 )
            {
             for(User man5item : man5)
             {
              List<Central_Hub__c> salesman5 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man5item.Id];
              if (salesman5.size() > 0 )
              {
                   flag=true;
                  return flag;
              }
             }  
            }
            }}                 
            
            List<User>  man6level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man6level.size() > 0 )
            {
            for(User man6levelitem : man6level)
            {
            List<User>  man6 = [Select Id from User where Manager_Level_6__c = :man6levelitem.Name];
            if (man6.size() > 0 )
            {
             for(User man6item : man6)
             {
              List<Central_Hub__c> salesman6 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man6item.Id];
              if (salesman6.size() > 0 )
              {
                   flag=true;
                  return flag;
              }
             }  
            }
            }}         
            
           List<User>  man7level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man7level.size() > 0 )
            {
            for(User man7levelitem : man7level)
            {
            List<User>  man7 = [Select Id from User where Manager_Level_7__c = :man7levelitem.Name];
            if (man7.size() > 0 )
            {
             for(User man7item : man7)
             {
              List<Central_Hub__c> salesman7 = [select Salesperson__c from Central_Hub__c where Id = : FAFRecId and Salesperson__c = :man7item.Id];
              if (salesman7.size() > 0 )
              {
                  flag=true;
                  return flag;
              }
             }  
            }
            }}             
        flag=false;
        return flag;
    }
    
    @AuraEnabled
    //Added by: ryan.francis.m.roque@accenture.com
    //Date Modified: 01/21/2020
    //CLM US: US22856
    public static boolean checkPBMCustomPermission(String FAFRecId){
        boolean showReqCRF = false;
        boolean pbmCustomPerm = FeatureManagement.checkPermission('Allow_request_PBM_contract');
        boolean validFafStat = false;
        Central_Hub__c fafObj= [select FAF_Status__c, Master_Agreement__c from Central_Hub__c where id =: FAFRecId];
        if(fafObj != null){
            if(fafObj.FAF_Status__c != 'Closed' && fafObj.FAF_Status__c != 'Deleted' && fafObj.FAF_Status__c != 'Template'){
                validFafStat = true;
            }
        }
        if(pbmCustomPerm && validFafStat){
            showReqCRF = true;
        }
        
		if(fafObj != null){
            if(fafObj.Master_Agreement__c != null){
                showReqCRF = false;
            }
        }
        return showReqCRF; 
    }
    
    @AuraEnabled
    public static wrapperClass getFAF(id FAFId){
        // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
        wrapperClass returnwrapperClass = new  wrapperClass ();
                
        //Collect FAF and child objects
        map<id,Central_Hub__c> fafMap = new map<id,Central_Hub__c>([SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                        Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c,Account_Name__r.Market_Segment__c,
                                        LastModifiedBy.Name,LastModifiedDate, Master_Agreement__c, FAF_Status__c,
                                        (SELECT Contract_Effective_Date__c, Contract_End_Date__c, Master_Client_Name__c, Pricing_Effective_Date__c FROM Client_Info__r LIMIT 1),
                                        (SELECT Adjudicate_at_Actual_Package_Size__c FROM Mail_Ops__r LIMIT 1),
                                        (SELECT Pass_MAF__c, Specialty_Rebates__c, Vaccine_Exclusion_Option__c, 
                                        Rebate_RTMD__c, Rebate_Contract_Type__c, Rebate_Offering_Type__c, X340B__c, 
                                        Compound__c, Paper__c, COB__c, Vaccine__c, LDD__c, ZBD__c, Select_Specialty_PDPD_Therapy_Class_es__c, 
                                        Rebate_Effective_Date__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c 
                                        FROM Rebate_Operations__r LIMIT 1),
                                        (SELECT Performance_Guarantee__c FROM Guarantee_Info__r LIMIT 1),
                                        (SELECT id FROM FAF_Network_Ops__r LIMIT 1),
                                        (SELECT Days_Written_Notice_Before_Termination__c,Frequency_1__c, Term_Without_Cause__c FROM Legal__r LIMIT 1),
                                        (SELECT id, Pharmacy_Benefit__c FROM Specialty_Ops__r LIMIT 1),
                                        (SELECT id FROM Clinical_Ops__r LIMIT 1),
                                        (SELECT id FROM PBMRequest__r LIMIT 1),
                                        (SELECT Pharmacy_Audit_Retention__c, Client_Share__c, CVS_Share__c, Claim_Billing__c, 
                                        Admin_Fee_Billing__c, Billing_Claim_Payment_Terms__c, Billing_Admin_Payment_Terms__c,
                                        Additional_Admin_Fee_Payment_Term_Info__c, Additional_Claim_Payment_Term_Info__c FROM Billing_Ops__r LIMIT 1)
                                        FROM Central_Hub__c WHERE id =: FAFId]);   
                                
        if(fafMap.size() > 0){
        	returnwrapperClass.FAFName = fafMap.get(FAFId).Name;
            returnwrapperClass.masterAgreementId = fafMap.get(FAFId).Master_Agreement__c;
            returnwrapperClass.FAFStatus = fafMap.get(FAFId).FAF_Status__c;
            list<PBMRequest__c> pbmReq = fafMap.get(FAFId).PBMRequest__r;
            if(pbmReq.size() > 0){
                returnwrapperClass.pbmRequestId = pbmReq[0].id;
            }else{
                returnwrapperClass.pbmRequestId = null;
            }
        }
                                    
        return returnwrapperClass;    
    }
    
    public class wrapperClass{
        @AuraEnabled public String FAFName {get;set;}
        @AuraEnabled public Id FAFId {get;set;}
        @AuraEnabled public String FAFStatus {get;set;}
        @AuraEnabled public String pbmRequestId {get;set;}
        @AuraEnabled public String masterAgreementId {get;set;}
        @AuraEnabled public Boolean isValidRequest {get;set;}
        @AuraEnabled public String invalidMessage {get;set;}
		@AuraEnabled public String successRequest {get;set;}                         
    }

}