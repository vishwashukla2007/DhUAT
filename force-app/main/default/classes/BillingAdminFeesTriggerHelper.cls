/* ================================================
 * @Trigger Name      :BillingAdminFeesTriggerHelper
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Priyanka Goyal(Accenture)
 * @Last modified date: 26/07/2018
 * @Purpose           : Helper Class of Trigger for LOB, Year & Admin Fee Validation
================================================*/ 
public with sharing class BillingAdminFeesTriggerHelper{
    //Method used to check duplicacy on LOB, Year & Admin Fee in Billing Admin Fees
    public static void validateLobYearCombinalion(List<Billing_Administrative_Fees__c> billAdmList, Boolean isInsertBool, Boolean isUpdateBool) {
    try{
        Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Billing operation Id and LOB, Year & Admin Fee combination in all associated Billing Admin Fees
        Map<string, MAP<string, Id>> billingBrokerIdRelatMap = new Map<string, MAP<string, Id>>(); //Map used to check the combination of Billing Operation Id and Billing Admin Fees Id
        MAP<string, Id> tempMap;
        set<Id> billingOpsIdSet = new set<Id>();  //Set contain the Billing operation id
        set<string> concatinateStr = new set<string>();  //set created to add LOB, Year & Admin Fee combination in set
        Set<Id>billingOprIdSet = new Set<Id>();  //Used to add billing operation id for pass in the query
        String str;
        String str1;
        // List<Billing_Administrative_Fees__c> billAdmFeesList = new List<Billing_Administrative_Fees__c>();
        
        //Iterate over all Billing Admin Fees which are present in the billAdmList list
        for(Billing_Administrative_Fees__c billAdm: billAdmList){
            billingOprIdSet.add(billAdm.Billing_Operations__c);
        }
        
        //Query data from Billing Operation Object
       // billAdmFeesList = [select id, Billing_Operations__c, Year__c, LOB__c , Admin_Fee_Type__c from Billing_Administrative_Fees__c
       // where Billing_Operations__c in: billingOprIdSet];
        
        //Iterate over all Billing Admin Fees which are present in the billAdmList list
        for(Billing_Administrative_Fees__c billAdm: [select id, Billing_Operations__c, Year__c, LOB__c , Admin_Fee_Type__c from Billing_Administrative_Fees__c
        where Billing_Operations__c in: billingOprIdSet]){
            tempMap = new Map<string,Id>();
            concatinateStr = new set<string>();
            if(billingOpsIdSet.size()>0){
                if(billingOpsIdSet.contains(billAdm.Billing_Operations__c)){
                    concatinateStr.addall(parentChildMap.get(billAdm.Billing_Operations__c));  //add all value present with the concerned billing operation
                    concatinateStr.add(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c);  //concatenate and add new value in the set
                    parentChildMap.put(billAdm.Billing_Operations__c, concatinateStr);
                    tempMap.put(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c, billAdm.Id);  //temp map which contain the LOB, Year & Admin Fee combination as key and billing Admin Fees id and value
                    str = string.valueOf(billAdm.Billing_Operations__c)+string.valueOf(billAdm.Id);   //concatenate Billing operation id and Billing Admin Fees Id
                    billingBrokerIdRelatMap.put(str,tempMap);
                }else{
                    concatinateStr.add(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c);   //concatenate and add new value in the set
                    billingOpsIdSet.add(billAdm.Billing_Operations__c);
                    parentChildMap.put(billAdm.Billing_Operations__c, concatinateStr);
                    tempMap.put(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c, billAdm.Id);    //temp map which contain the LOB, Year & Admin Fee combination as key and billing Admin Fees id and value
                    str = string.valueOf(billAdm.Billing_Operations__c)+string.valueOf(billAdm.Id);       //concatenate Billing operation id and Billing Admin Fees Id
                    billingBrokerIdRelatMap.put(str,tempMap);
                }
            }else{    //This condition will execute first time the loop will execute
                concatinateStr.add(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c);  //concatenate and add new value in the set
                billingOpsIdSet.add(billAdm.Billing_Operations__c);
                parentChildMap.put(billAdm.Billing_Operations__c, concatinateStr);
                tempMap.put(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c, billAdm.Id);  //temp map which contain the LOB, Year & Admin Fee combination as key and billing Admin Fees id and value
                str = string.valueOf(billAdm.Billing_Operations__c)+string.valueOf(billAdm.Id);     //concatenate Billing operation id and Billing Admin Fees Id 
                billingBrokerIdRelatMap.put(str,tempMap);
            }
        }
        
        if(isUpdateBool){      //Value to check it is insert case or Update
            for(Billing_Administrative_Fees__c billAdm: billAdmList){
                if(billingOpsIdSet.contains(billAdm.Billing_Operations__c)){   //check billingOpsIdSet set contain billing operation
                    system.debug('========billAdm.Billing_Operations__c========'+billAdm.Billing_Operations__c);
                    system.debug('========billAdm.id========'+billAdm.id);
                    if(parentChildMap.get(billAdm.Billing_Operations__c).contains(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c)){  //verify that set associated with unique billing operation contains the LOB, Year & Admin Fee combination
                        str1 = billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c;
                        str = string.valueOf(billAdm.Billing_Operations__c)+string.valueOf(billAdm.Id);  //concatenate billing operation and Billing Admin Fees id                   
                        if(billingBrokerIdRelatMap.get(str).get(str1) != billAdm.id){     //For exclude the update condition
                            billAdm.addError(ConstantsUtil.YEAR_LOB_ADMIN_FEE_TYPE_ERROR);  //Display error
                        }
                    }
                }     
            }
        }
        if(isInsertBool){  //Boolean used to identify the insert scenario
            for(Billing_Administrative_Fees__c billAdm: billAdmList){
                if(billingOpsIdSet.contains(billAdm.Billing_Operations__c)){
                    if(parentChildMap.get(billAdm.Billing_Operations__c).contains(billAdm.Year__c + billAdm.LOB__c + billAdm.Admin_Fee_Type__c)){  //verify that set associated with unique billing operation contains the LOB, Year & Admin Fee combination
                        billAdm.addError(ConstantsUtil.YEAR_LOB_ADMIN_FEE_TYPE_ERROR); //Display error
                    }
                }     
            }
        }
    }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
}

public static void updateancillaryRec(List<Billing_Administrative_Fees__c> billAdmList) {
    try{
        List<Billing_Administrative_Fees__c> billAdmFeesList = new List<Billing_Administrative_Fees__c>();
        Set<Id>billingOprIdSet = new Set<Id>();
        Map<id,id> billingAdminOpsMap = new Map<id,id>();
        Map<id,List<Billing_Ancillary_Fee__c>> billingAncOpsMap = new Map<id,List<Billing_Ancillary_Fee__c>>();
        List<Billing_Ancillary_Fee__c> billingancillaryList = new List<Billing_Ancillary_Fee__c>();
        List<Billing_Ancillary_Fee__c> ancillaryUpdateList = new List<Billing_Ancillary_Fee__c>();
        //Iterate over all Billing Admin Fees which are present in the billAdmList list
        
        for(Billing_Administrative_Fees__c billAdm: billAdmList){
            if(billadm.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM)  || billadm.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS) || billadm.Admin_Fee_Type__c.equals(ConstantsUtil.MAIL_PER_CLAIM)  || billadm.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM)){
                billingOprIdSet.add(billAdm.Billing_Operations__c);
                billingAdminOpsMap.put(billAdm.id,billAdm.Billing_Operations__c);
            }
            
        }
        system.debug('billingOprIdSet.size()'+billingOprIdSet.size());
        if(billingOprIdSet.size() > 0){     
            for(Billing_Ancillary_Fee__c ba :[select id, Billing_Operations__c, Year__c, LOB2__c , Fee_Basis__c from Billing_Ancillary_Fee__c
                    where Billing_Operations__c in: billingOprIdSet]){
                    
                if(ba.Fee_Basis__c.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE) || 
                        ba.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) 
                            || ba.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)
                                ||ba.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) 
                                    || ba.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE)){
                        billingancillaryList.add(ba);

                }
                    billingAncOpsMap.put(ba.Billing_Operations__c,billingancillaryList);
            }
        }

        for( Billing_Administrative_Fees__c billadm:billAdmList){
            if(billingAncOpsMap.get(billingAdminOpsMap.get(billadm.id)) != null){
                
                for(Billing_Ancillary_Fee__c baf: billingAncOpsMap.get(billingAdminOpsMap.get(billadm.id))){
                        
                    if((baf.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || baf.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  && baf.LOB2__c.equals(billadm.LOB__c) && baf.Year__c.equals(billadm.Year__c) && (billadm.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM)  || billadm.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))){
                            baf.Fee_Amount__c =  billadm.Base_Amount__c;                          
                                           
                    }else if((baf.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || baf.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  && baf.LOB2__c.equals(billadm.LOB__c) && baf.Year__c.equals(billadm.Year__c) && (billadm.Admin_Fee_Type__c.equals(ConstantsUtil.MAIL_PER_CLAIM) || billadm.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))){ 
                    baf.Fee_Amount__c =  billadm.Base_Amount__c; 
                            
                    }else if(baf.Fee_Basis__c.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE)  && baf.LOB2__c.equals(billadm.LOB__c) && baf.Year__c.equals(billadm.Year__c) && (billadm.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || billadm.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))){ 
                            baf.Fee_Amount__c =  billadm.Base_Amount__c;
                            
                    }
                ancillaryUpdateList.add(baf);
                }
            }
        }        
        if(ancillaryUpdateList.size() > 0 ){
        update ancillaryUpdateList;
        }
    }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}

    }
    }