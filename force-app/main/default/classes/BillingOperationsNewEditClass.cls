/* ================================================
 * @Class Name        : BillingOperationsNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for BillingOperationsNewEditPage 
================================================*/
public with sharing class BillingOperationsNewEditClass{ 
    public Billing_Operations__c billngOprationObj{get;set;}
    public Id billingOprId;
    Public Boolean showerrorBool{get;set;}      //for show messsage that one FAF can have only one Billing Operation Record 
    public string pharmacyauditRet{get;set;}    // For get the value of pharmacy Audit Picklist from page
    public Boolean auditRetEnbDisbBool{get;set;}  //For Enable Disable Client Share Field
    public string changeClaimFlag{get;set;}   //For get change the Payment Term
    public string changeAdminFlag{get;set;}    //For get Admin Flag from page
    public Boolean changeClaimBool{get;set;}   //For get Admin Flag from page
    public Boolean changeAdminBool{get;set;}    //For pass the value in page
    
    //
/* ================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Constructor for BillingOperationsNewEditClass
================================================*/
    public BillingOperationsNewEditClass(ApexPages.StandardController controller) {
        showerrorBool = false;
        //get Billing Operation Id from Billing from URL
        billingOprId = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID);
        
        //get Billing Operation Id from Billing
        Id fafIdId = ApexPages.currentPage().getParameters().get(Label.BillingOperationLabel);
        billngOprationObj = new Billing_Operations__c();
        auditRetEnbDisbBool = false;
        changeClaimBool = true;
        changeAdminBool =  true;
        if(billingOprId == null){ //Code will execute when we are creating a new record
            if(fafIdId != null){
                billngOprationObj.FAF_Id__c = fafIdId;
                List<Billing_Operations__c>billOpr = new List<Billing_Operations__c>();
                billOpr = [select id from Billing_Operations__c where Faf_Id__c=:fafIdId];
                if(billOpr.size()>0){
                    showerrorBool = true;
                }
            }
            auditRetEnbDisbBool = true;
        }else{  //Code will execute when we are Editing a record
            
            //For query the recordt info to shaow data on page
            billngOprationObj = [select id, name, FAF_ID__c, Platform__c, Claim_Billing__c, Method__c,
                                 Admin_Fee_Billing__c, Billing_Claim_Payment_Terms__c, Billing_Admin_Payment_Terms__c,
                                 Additional_Claim_Payment_Term_Info__c, Additional_Admin_Fee_Payment_Term_Info__c,
                                 Fee_Schedule_Type__c, Fee_Schedule_Path__c, Deviation_from_Current_Fees__c,
                                 Describe_Deviation_from_Current_Fees__c, Pharmacy_Audit_Retention__c, Client_Share__c,
                                 CVS_Share__c, Additional_Broker_TPA_Information__c, Additional_Billing_Information__c
                                 from Billing_Operations__c where id=: billingOprId];
             
             pharmacyauditRet = billngOprationObj.Pharmacy_Audit_Retention__c;
             changeClaimFlag = billngOprationObj.Billing_Claim_Payment_Terms__c;
             changeAdminFlag = billngOprationObj.Billing_Admin_Payment_Terms__c;
             
             //for check Client share field fill be enable or disable
             if(billngOprationObj.Pharmacy_Audit_Retention__c == ConstantsUtil.PHARMACYAUDITRET_BASE || 
             billngOprationObj.Pharmacy_Audit_Retention__c == ConstantsUtil.PHARMACYAUDITRET_PREMIER){
                 auditRetEnbDisbBool = false;
             }else{
                 auditRetEnbDisbBool = true;
             }
             
             if(billngOprationObj.Billing_Claim_Payment_Terms__c == ConstantsUtil.PAYMENTTERMS ){
             changeClaimBool = false;
             }
             
             if(billngOprationObj.Billing_Admin_Payment_Terms__c == ConstantsUtil.PAYMENTTERMS ){
             changeAdminBool = false;
             }
        }   
    } 
    
/* ================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Method for create and Update record in Org
================================================*/
    public pagereference saveUpdateBillOp(){
        try{
            //For check the pharmacy Audit Value
            if(pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_BASE || pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_PREMIER){
                system.debug('======in if=====');
                if(billngOprationObj.Client_share__c != null){
                    if(billngOprationObj.Client_share__c >100 || billngOprationObj.Client_share__c <0){
                        billngOprationObj.CVS_Share__c = 0;
                    }else{
                        billngOprationObj.CVS_Share__c = 100-billngOprationObj.Client_share__c;//Assign value in CVS share by subtracting Client Share value from 100
                    }
                }
            }else if(pharmacyauditRet == ConstantsUtil.BLANK) {     //Condition will execute if pharmacy audit Retention is blank 
                system.debug('======in else=====');
                billngOprationObj.Client_share__c = null;
                billngOprationObj.CVS_Share__c = null;
            }else{
            }  
            system.debug('==========billngOprationObj====='+billngOprationObj);
            if(billingOprId == null){
                insert billngOprationObj;  //Insert the Billing Operation
            }else{
                update billngOprationObj;   //Update the Billing Operation
            }
            pagereference pr = new pagereference(ConstantsUtil.FORWARD_SlASH + billngOprationObj.id);
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    } 
    
/* ================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Method called on change pharmacy Audit
================================================*/
    public void billingAuditRetenAct(){
    try{
        if(pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_BASE || 
         pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_PREMIER ){
             system.debug('===========inIf-------');
             auditRetEnbDisbBool = false;
             billngOprationObj.Client_share__c = null;
             billngOprationObj.CVS_Share__c = null;
         }else if(pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_BASE100 ){  //For check the value of Pharmacy Audit Retention is Base100/0
             system.debug('===========inelse-------');
             auditRetEnbDisbBool = true;
             billngOprationObj.Client_share__c = 100;
             billngOprationObj.CVS_Share__c = 0;
         }else if(pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_PREMIER75){  //For check the value of Pharmacy Audit Retention is Base75/25
             auditRetEnbDisbBool = true;
             billngOprationObj.Client_share__c = 75;
             billngOprationObj.CVS_Share__c = 25;
         }else if(pharmacyauditRet == ConstantsUtil.PHARMACYAUDITRET_BASE80){   //For check the value of Pharmacy Audit Retention is Base80/20
             auditRetEnbDisbBool = true;
             billngOprationObj.Client_share__c = 80;
             billngOprationObj.CVS_Share__c = 20;
         }else{
             auditRetEnbDisbBool = true;
             billngOprationObj.Client_share__c = null;
             billngOprationObj.CVS_Share__c = null;
         }
    }catch(Exception excp){
            ApexPages.addMessages(excp);
    }
    }
    
/* =======================================================================================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This method is created for req 1.6.4.1 and 1.6.7.1 for dependancy when Billing Admin Payment Term  and Billing Claim Payment Term  = 'Non-Standard' 
===========================================================================================================================*/   
    public void changePaymentTerms(){
    try{
        changeClaimBool = true;
        //  billngOprationObj.Additional_Claim_Payment_Term_Info__c = '';
        changeAdminBool = true;
        //   billngOprationObj.Additional_Admin_Fee_Payment_Term_Info__c = '';
        if(changeClaimFlag == ConstantsUtil.PAYMENTTERMS ){
            changeClaimBool = false;
        }
        if(changeAdminFlag == ConstantsUtil.PAYMENTTERMS ){
            changeAdminBool = false;
        }
    }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }
    
}