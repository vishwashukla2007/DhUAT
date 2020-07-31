/* ===================================================================================================
 * @Class Name        : BillingAdminDeleteClass
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 17/10/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 17/10/2018
 * @Purpose           : This class is use to override the delete button on Billing Administrative Fees Page
======================================================================================================*/
public class BillingAdminDeleteClass{   
    Public boolean showErrorMessage{get;set;}
    Public string recordId{get; set;}
    Id billOpsId;
    Billing_Administrative_Fees__c billingAdminRec  = new Billing_Administrative_Fees__c();
    list<Billing_Ancillary_Fee__c > billancList = new list<Billing_Ancillary_Fee__c>();
    List<Billing_Ancillary_Fee__c > todeletebillancList = new List<Billing_Ancillary_Fee__c>();
    public BillingAdminDeleteClass(ApexPages.StandardController stdController){
        showErrorMessage = false;
        recordId = ApexPages.Currentpage().getParameters().get(ConstantsUtil.ID);   
    }  
 /******************************************************************************************************************************
 * @Method Name       : checkRecord
 * @author            : Accenture
 * @Last modified by  : Accenture
 * @Last modified date: 10/08/2018
 * @Purpose           : Method Use to check the criteria before deleting Billing Administrative Fees Record
 *******************************************************************************************************************************/
    public pageReference checkRecord(){
    try{
        PageReference pageRef;
        Billing_Administrative_Fees__c billingAdminRec = [Select id, FAF_ID__c,Billing_Operations__c, Year__c,LOB__c,Admin_Fee_Type__c,Base_Amount__c from Billing_Administrative_Fees__c where id =: recordId];
            
        billOpsId = billingAdminRec.Billing_Operations__c;
        if(!string.isBlank(billOpsId)){
                 list<Billing_Ancillary_Fee__c > billancList = [Select id,Year__c,LOB2__c,Fee_Basis__c,Fee_Amount__c,Billing_Operations__c from Billing_Ancillary_Fee__c where Billing_Operations__c =:billOpsId];
                
                if(billancList.size() > 0){
                    for(Billing_Ancillary_Fee__c baf :billancList){
                        if(((baf.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || baf.Fee_Basis__c.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)) 
                        && baf.LOB2__c.equals(billingAdminRec.LOB__c) && baf.Year__c.equals(billingAdminRec.Year__c) && (billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM)  || billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))) || 
                        ((baf.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || baf.Fee_Basis__c.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  
                        && baf.LOB2__c.equals(billingAdminRec.LOB__c) && baf.Year__c.equals(billingAdminRec.Year__c) && (billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.MAIL_PER_CLAIM) || billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))) ||
                        (baf.Fee_Basis__c.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE)  && baf.LOB2__c.equals(billingAdminRec.LOB__c) && baf.Year__c.equals(billingAdminRec.Year__c) 
                        && (billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || billingAdminRec.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS)))){
                        todeletebillancList.add(baf);                   
                        }
                    }
                }
                if(!todeletebillancList.isEmpty()){
                showErrorMessage=true;
                }
                else{
                    delete billingAdminRec;
                }
                
        }
        return null;
    }
    catch(Exception excp){
    ApexPages.addMessages(excp);
    return null;
    }
    }

/******************************************************************************************************************************
 * @Method Name       : deleteRecord
 * @author            : Accenture
 * @Last modified by  : Accenture
 * @Last modified date: 10/08/2018
 * @Purpose           : Method Use to delete Billing Administrative Fees Record
 *******************************************************************************************************************************/    
 public pageReference deleteRecord(){
        try{
        Billing_Administrative_Fees__c billingAdminRec = [Select id, FAF_ID__c,Billing_Operations__c, Year__c,LOB__c,Admin_Fee_Type__c,Base_Amount__c from Billing_Administrative_Fees__c where id =: recordId];
        delete billingAdminRec;
        delete todeletebillancList;
        showErrorMessage=false;
        }catch(Exception excp){
        ApexPages.addMessages(excp);
       
        }
         return null;
    }

/******************************************************************************************************************************
 * @Method Name       : okMethod
 * @author            : Accenture
 * @Last modified by  : Accenture
 * @Last modified date: 10/08/2018
 * @Purpose           : Confirmation message on delete of Billing Administrative Fees Record
 *******************************************************************************************************************************/  
 public pageReference okMethod(){
        try{
        PageReference pageRef = new PageReference(ConstantsUtil.SLASH+billOpsId);
        pageRef.setRedirect(true);
        return pageRef;
        }catch(Exception excp){
        ApexPages.addMessages(excp);
        return null;
        }
    }   
}