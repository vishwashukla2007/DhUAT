/* ====================================================================
* @Class Name      : BillingAncFeeTriggerHelper
* @author            : Akanksha Singh(Accenture)
* @created date      : 12 07 2018
* @Last modified by  : Akanksha Singh(Accenture)
* @Last modified date: 25/07/2018
* @Purpose           : This is the Helper class for Billing Ancillary Fee
========================================================================*/
public with sharing class BillingAncFeeTriggerHelper{
    //Method used to Validate when updating with X-Author 
    public static void validateXAE(List<Billing_Ancillary_Fee__c> billAncList, Boolean isInsertBool, Boolean isUpdateBool) {
        for( Billing_Ancillary_Fee__c ba : billAncList){
            if (ba.DeleteRow__c != true && ba.XAE__c == true && ba.FAF_ID__r.Copy_Pending__c == false) {
                if (ba.Year__c == null || ba.LOB2__c == null || ba.Ancillary_Fee_Type__c == null || ba.Ancillary_Fee_Description__c == null || ba.Fee_Basis__c == null) {
                    ba.adderror('Year, LOB, Ancillary Fee Type, Ancillary Fee Description, and Fee Basis are required.');
                }                
            }
        }            
    }
    public static void DeleteXAE(List<Billing_Ancillary_Fee__c> billAncList, Boolean isInsertBool, Boolean isUpdateBool) {
        for( Billing_Ancillary_Fee__c ba : billAncList){                          
            if (ba.DeleteRow__c == true && ba.XAE__c == true && ba.FAF_ID__r.Copy_Pending__c == false) {
                
                list<Billing_Ancillary_Fee__c> bae= [select id from Billing_Ancillary_Fee__c where id =: ba.id];             
                delete bae;    
            }            
        }    
    }
    
    //Method used to validate PBM Services exist
    public static void validatePBMServices(List<Billing_Ancillary_Fee__c> billAncList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            set<Id> FAFIds = new set<Id>();
            List<Fee_Services__c> feeServiceLst = new List<Fee_Services__c>();
            List<Fee_Service_Template__c> templateLst = new List<Fee_Service_Template__c>();
            for( Billing_Ancillary_Fee__c ba : billAncList){
                FAFIds.add(ba.FAF_ID__c);
            }
            feeServiceLst = [select id,PBM_Count__c from Fee_Services__c where FAF_ID__c =:FAFIds AND PBM_Count__c=0];
            if(feeServiceLst.Size()>0){
// Read Schedule Type from Fee Services
// Use the Scehedule Type to add to where clause of Template Fee_Services__c.Fee_Service_type__c = Fee_Service_Template__c.Schedule_Type__c
                templateLst = [select id,FAF_Component_Type__c,Item__c from Fee_Service_Template__c where Active__c = True AND FAF_Component__c = 'Billing Ops.Ancillary Fees'];
                if(templateLst.size()>0)
                {
                    for(Billing_Ancillary_Fee__c ancObj : billAncList)
                    {
                        for(Fee_Service_Template__c tempObj : templateLst){
                            if(tempObj.FAF_Component_Type__c == ancObj.Ancillary_Fee_Type__c && tempObj.Item__c == ancObj.Ancillary_Fee_Description__c){
                                ancObj.addError(ConstantsUtil.Check_PBM_Services);
                            }
                        }
                    }
                }
            }
        }catch(exception e){billAncList[0].addError(e.getDmlMessage(0)); }
    }
    
    //Method used to check duplicacy on LOB and Year in Billing Ancillary Fee     
    public static void validateLobYearCombinalion(List<Billing_Ancillary_Fee__c> billAncList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            system.debug('Billing Anciliary****************** '+System.URL.getCurrentRequestUrl());
            Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>();        //Map used to add Billing operation Id and year, Lob combination in all associated Billing Ancillary Fee
            Map<string, MAP<string, Id>> billingAncIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Billing Operation Id and Billing Ancillary Fee id
            MAP<string, Id> tempMap;
            set<Id> billingOpsIdSet = new set<Id>(); //Set contain the Billing operation id
            set<string> concatinateStr = new set<string>(); //set created to add year and LOB combination in set
            Set<Id>billingOprIdSet = new Set<Id>(); //Used to add billing operation id for pass in the query
            String str;
            String str1;
            //  List<Billing_Ancillary_Fee__c> billAncFeeList = new List<Billing_Ancillary_Fee__c>();
            for(Billing_Ancillary_Fee__c billAnc: billAncList){
                if (!billAnc.FAF_ID__r.Copy_Pending__c)       
                    billingOprIdSet.add(billAnc.billing_operations__c);
            }
            //  billAncFeeList = [select id, billing_operations__c, year__c, LOB2__c from Billing_Ancillary_Fee__c
            //  where billing_operations__c in: billingOprIdSet];
            for(Billing_Ancillary_Fee__c billAnc: [select id, billing_operations__c, year__c, LOB2__c,Ancillary_Fee_Type__c,Ancillary_Fee_Description__c,Fee_Basis__c from Billing_Ancillary_Fee__c
                                                   where FAF_ID__r.Copy_Pending__c = False and billing_operations__c in: billingOprIdSet]){
                                                       tempMap = new Map<string,Id>();
                                                       concatinateStr = new set<string>();
                                                       if(billingOpsIdSet.size()>0){
                                                           if(billingOpsIdSet.contains(billAnc.billing_operations__c)){
                                                               concatinateStr.addall(parentChildMap.get(billAnc.billing_operations__c)); //add all value present with the concerned billing operation
                                                               concatinateStr.add(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c); //concatenate and add new value in the set
                                                               parentChildMap.put(billAnc.billing_operations__c, concatinateStr); 
                                                               tempMap.put(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c, billAnc.Id); //temp map which contain the year,LOB combination as key and Billing Ancillary Fee id and value
                                                               str = string.valueOf(billAnc.billing_operations__c)+string.valueOf(billAnc.Id); //concatenate Billing operation id and Billing Ancillary Fee Id 
                                                               billingAncIdRelatMap.put(str,tempMap);
                                                           }else{
                                                               concatinateStr.add(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c); //concatenate and add new value in the set
                                                               billingOpsIdSet.add(billAnc.billing_operations__c); 
                                                               parentChildMap.put(billAnc.billing_operations__c, concatinateStr); 
                                                               tempMap.put(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c, billAnc.Id); //temp map which contain the year,LOB combination as key and Billing Ancillary Fee id and value 
                                                               str = string.valueOf(billAnc.billing_operations__c)+string.valueOf(billAnc.Id); //concatenate Billing operation id and Billing Ancillary Fee Id
                                                               billingAncIdRelatMap.put(str,tempMap);
                                                           }
                                                       }else{ //This condition will execute first time the loop will execute
                                                           concatinateStr.add(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c);  //concatenate and add new value in the set
                                                           billingOpsIdSet.add(billAnc.billing_operations__c);
                                                           parentChildMap.put(billAnc.billing_operations__c, concatinateStr);
                                                           tempMap.put(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c, billAnc.Id); //temp map which contain the year,LOB combination as key and Billing Ancillary Fee id and value
                                                           str = string.valueOf(billAnc.billing_operations__c)+string.valueOf(billAnc.Id); //concatenate Billing operation id and Billing Ancillary Fee Id
                                                           billingAncIdRelatMap.put(str,tempMap);
                                                       }
                                                   }
            
            if(isUpdateBool){
                for(Billing_Ancillary_Fee__c billAnc: billAncList){
                    if(billingOpsIdSet.contains(billAnc.billing_operations__c)){ //check billingOpsIdSet set contain billing operation
                        if(parentChildMap.get(billAnc.billing_operations__c).contains(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c)){ //verify that set associated with unique billing operation 
                            str1 = billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c;
                            str = string.valueOf(billAnc.billing_operations__c)+string.valueOf(billAnc.Id); //concatenate billing operation and Billing Ancillary Fee id
                            if(billingAncIdRelatMap.get(str).get(str1) != billAnc.id){ //For exclude the update condition
                                billAnc.addError(ConstantsUtil.DUPLICATE_CHECK_ANC_ERROR); //Display error
                            }
                        }
                    }     
                }
            }
            if(isInsertBool){
                for(Billing_Ancillary_Fee__c billAnc: billAncList){
                    if(billingOpsIdSet.contains(billAnc.billing_operations__c)){
                        if(parentChildMap.get(billAnc.billing_operations__c).contains(billAnc.year__c + billAnc.LOB2__c + billAnc.Ancillary_Fee_Type__c + billAnc.Ancillary_Fee_Description__c + billAnc.Fee_Basis__c)){ //verify that set associated with unique billing operation contains the year, Lob combination
                            billAnc.addError(ConstantsUtil.DUPLICATE_CHECK_ANC_ERROR); //Display error
                        }
                    }     
                }
            }
        }catch(exception e)
        {
            string catchUrl=String.valueOf(System.URL.getCurrentRequestUrl());
            for(Billing_Ancillary_Fee__c ps : billAncList){
                if(catchUrl.contains('/apex/')){
                    ps.adderror(e.getDmlMessage(0));
                }
                else{
                    system.debug('XAE Exception');
                }
            } 
            
        }
        
    }
    
    
    
    
    //Below Method to Update Fee Amount based on matching Billing Admin Record when record inserted through XAE
    public static void BillAncillaryFeeAmountUpdateXAE(List<Billing_Ancillary_Fee__c> billAncList){
        try {
            String feeBasisValue;
            List<Billing_Ancillary_Fee__c> bafupdate= new List<Billing_Ancillary_Fee__c>();
            for(Billing_Ancillary_Fee__c billAnc: billAncList){
                if(billAnc.XAE__c == true && billAnc.FAF_ID__r.Copy_Pending__c == false)
                {
                    list<Billing_Administrative_Fees__c>  billadmList = new list<Billing_Administrative_Fees__c>();
                    billadmList = [Select Id,Billing_Operations__c,LOB__c,Year__c ,Admin_Fee_Type__c,Base_Amount__c from Billing_Administrative_Fees__c where FAF_ID__r.Copy_Pending__c = False and Billing_Operations__c  =: billAnc.Billing_Operations__c];
                    feeBasisValue = billAnc.Fee_Basis__c;
                    for(Billing_Administrative_Fees__c ba :billadmList){
                        if(((feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))) || ((feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)) && (ba.Admin_Fee_Type__c == ConstantsUtil.MAIL_PER_CLAIM || ba.Admin_Fee_Type__c == ConstantsUtil.PER_ALL_CLAIMS)) || ((feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE)) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS)))) && ba.LOB__c.equals(billAnc.LOB2__c)  && ba.Year__c.equals(billAnc.Year__c)){
                            billAnc.Fee_Amount__c = ba.Base_Amount__c;
                        }
                        bafupdate.add(billAnc);
                    }}
                
            } database.update(bafupdate);
        }
        catch(exception e) { System.debug('Error' + e.getMessage());}
    }
    //Below Method is used to check the Elections on Fee services record before detete the Billing Ancillary Fees record.
    public static void checkElectionOnDelete(List<Billing_Ancillary_Fee__c> billingAncList) {
        try{
            
            set<id> fafIds = new set<Id>();
            List<id> FeeServicesIds = new List<Id>();
            List<PBM_Services__c> PBMLst = new List<PBM_Services__c>();
            
            for(Billing_Ancillary_Fee__c billingAnc: billingAncList)
            {   
                fafIds.add(billingAnc.FAF_ID__c); 
                FeeServicesIds.add(billingAnc.Id);          
            }
            
            PBMLst = [SELECT Id,FAF_ID__c,Election__c,Sync_Source__c,Billing_Ancillary_Fees__c,DelFlag__c FROM PBM_Services__c WHERE Billing_Ancillary_Fees__c =: FeeServicesIds AND Election__c =true];
            if(PBMLst.size()>0)
            {
                for(PBM_Services__c PBMObj : PBMLst)
                {
                    PBMObj.Election__c= false;
                    PBMObj.DelFlag__c = true;
                    PBMObj.Sync_Source__c = 'Target';
                    PBMObj.Billing_Ancillary_Fees__c = null;
                }
                update PBMLst;
            }
            
        }catch(exception e){billingAncList[0].addError(e.getDmlMessage(0)); }
    }
}