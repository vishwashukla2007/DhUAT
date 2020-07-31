/* =============================================================================================================
* @Class Name        : BillAncillaryNewEditClass
* @author            : Akanksha Singh(Accenture)
* @created date      : 16/07/2018
* @Last modified by  : Akanksha Singh(Accenture)
* @Last modified date: 25/07/2018
* @Purpose           : This is the controller class for BillAncillaryNewEditPage
================================================================================================================*/
public with sharing class BillAncillaryNewEditClass {
    Public Billing_Ancillary_Fee__c baf{get;set;}   // To bind the Rebate Guarantees Object 
    Public Billing_Operations__c billingOpsObj{get;set;} // To store the value of Rebate Operation
    // Public Client_Information__c clintInfoObj{get;set;}
    Public List<Client_Information__c> clintInfoList;  // To store the year list from Client Information Object
    Public set<string> checkClientYearCount;
    Public Id bafID{get;set;}   // To store the id of Rebate Guarantees Object
    Public String yearVal{get;set;}
    public String feeTypeValue{get;set;}  // To bind Fee Type value from Page
    public String feeDescptionValue{get;set;} // To bind Fee Description value from Page 
    public String feeBasisValue{get;set;} // To bind Fee Basis value from Page
    public Decimal feeAmountValue{get;set;}
    public Boolean feeAdditiveValue{get;set;}
    public Boolean feeAdditiveFlag{get;set;}
    public Boolean feeBasisFlag{get;set;}
    public Boolean EnableDisableValue{get;set;}
    public Boolean NoAdminFeeFlag{get;set;}
    public String changeLOB{get;set;}
    public String changeYear{get;set;}
    public Boolean adminFeePopUpFlag{get;set;}  // To pop up warning message when no matching admin feee type
    public Boolean adminRecordPopUpFlag{get;set;} 
    public Boolean miscellaneousFlag{get;set;} // To pop up warning message when no matching admin fee record
    Public Boolean defaultValBool;  
    Public List<SelectOption> yearList{get;set;}
    Public List<SelectOption> feeBasisList{get;set;}
    public String operationType;
    map<ID,Decimal> mapbillOpsAdm = new map<ID,Decimal>();   
    Id billingOprId;
    Public Boolean makeRequireBool{get;set;}
    Public Boolean saveBoolValue{get;set;}
    
    /******************************************************************************************************************************
* @Method Name       : BillAncillaryNewEditClass
* @author            : Accenture
* @Last modified by  : Accenture
* @Last modified date: 22/08/2018
* @Purpose           : Constructor of the BillAncillaryNewEditClass
*******************************************************************************************************************************/
    public BillAncillaryNewEditClass(ApexPages.StandardController controller) {
        //feeAdditiveValue = false;
        feeAdditiveFlag = true;
        feeBasisFlag = true;
        miscellaneousFlag = false;
        saveBoolValue = false;
        makeRequireBool = true;
        feeAmountValue = null;
        baf = new Billing_Ancillary_Fee__c();
        billingOpsObj = new Billing_Operations__c();
        adminFeePopUpFlag = false;
        adminRecordPopUpFlag = false;
        NoAdminFeeFlag = true;
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        yearList = new List<SelectOption>();
        feeBasisList = new List<SelectOption>();
        bafID = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID);
        operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
        
        billingOprId = ApexPages.currentPage().getParameters().get(Label.BillingAncillaryBillingOps); 
        system.debug('id'+billingOprId); 
        //Condition for new ancillary record getting created 
        if(bafID == null){
            if(billingOprId != null){
                billingOpsObj = [select id, FAF_ID__c, FAF_ID__r.Client_Info__c from Billing_Operations__c where id =:billingOprId];
                baf.FAF_Id__c = billingOpsObj.FAF_ID__C;
                baf.Billing_Operations__c = billingOprId;
                miscellaneousFlag = false;
                feeBasisList = new List<SelectOption>(); 
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
                if(!(string.isBlank(billingOpsObj.FAF_ID__C))){              
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                     Client_Information__c where FAF_ID__c =:billingOpsObj.FAF_ID__c limit 1];
                }
                if(!clintInfoList.isEmpty()){ //check whether Client Info list is empty or not
                    if(!(string.isBlank(clintInfoList[0].year_1__c))){
                        yearList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.BLANK)); //Populate empty value in Year field
                        yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
                        checkClientYearCount.add(clintInfoList[0].year_1__c); // associate value from client Information object
                    }
                    if(!(string.isBlank(clintInfoList[0].year_2__c))){ //for check value is not empty 
                        if(checkClientYearCount.isEmpty()){
                            yearList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.BLANK));
                        }
                        yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                        checkClientYearCount.add(clintInfoList[0].year_2__c); // associate value from client Information object
                    }
                    if(!(string.isBlank(clintInfoList[0].year_3__c))){ //for check value is not empty 
                        if(checkClientYearCount.isEmpty()){
                            yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK)); 
                        }
                        yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                        checkClientYearCount.add(clintInfoList[0].year_3__c); // associate value from client Information object
                    }
                    if(!(string.isBlank(clintInfoList[0].year_4__c))){ //for check value is not empty 
                        if(checkClientYearCount.isEmpty()){
                            yearList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.BLANK));
                        }
                        yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                        checkClientYearCount.add(clintInfoList[0].year_4__c); // associate value from client Information object
                    }
                    if(!(string.isBlank(clintInfoList[0].year_5__c))){ //for check value is not empty 
                        if(checkClientYearCount.isEmpty()){
                            yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));
                        }
                        yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
                        checkClientYearCount.add(clintInfoList[0].year_5__c); // associate value from client Information object
                    }
                    yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));
                    if(yearList.size() == 1){
                        changeYear = ConstantsUtil.ALL;
                    }
                }
            }        
        }else{                         
            // When exising Billing Ancillary Fees is edited             
            baf = [select id,PBM_Services__c, name,Service_Effective_Date__c, Ancillary_Fee_Description_2__c,Fee_Basis2__c,Additive__c, Additive_Amount__c, Ancillary_Fee_Description__c, Ancillary_Fee_Type__c, Sync_Source__c,
                   Billing_Operations__c,Billing_Operations__r.FAF_ID__r.Client_Info__c, FAF_ID__c, Fee_Amount__c, Fee_Basis__c, Link__c,
                   LOB2__c, Total__c, Year__c from Billing_Ancillary_Fee__c where id =: bafID];
            billingOprId = baf.Billing_Operations__c;
            changeYear = baf.Year__c;
            changeLOB = baf.LOB2__c;
            feeTypeValue = baf.Ancillary_Fee_Type__c;
            feeDescptionValue = String.isBlank(baf.PBM_Services__c)? baf.Ancillary_Fee_Description__c : baf.Ancillary_Fee_Description_2__c;
            feeAdditiveValue = baf.Additive__c; 
            feeBasisValue = String.isBlank(baf.PBM_Services__c)? baf.Fee_Basis__c : baf.Fee_Basis2__c;
            if(feeAdditiveValue){
                feeAdditiveFlag = false;
            } 
            if(!string.isBlank(feeDescptionValue)){
                feeBasisFlag = false;
            } 
            miscellaneousFlag = true;
            FeeAmountAction();
            
            if(!(string.isBlank(baf.Billing_Operations__r.FAF_ID__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                 Client_Information__c where FAF_ID__c =:baf.Billing_Operations__r.FAF_ID__c];
            }
            if(!clintInfoList.isEmpty()){
                if(!(string.isBlank(clintInfoList[0].year_1__c))){
                    // Associate the value of ClientInfoList year 1 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c)); 
                }
                if(!(string.isBlank(clintInfoList[0].year_2__c))){
                    // Associate the value of ClientInfoList year 2 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                }
                if(!(string.isBlank(clintInfoList[0].year_3__c))){
                    // Associate the value of ClientInfoList year 3 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                }
                if(!(string.isBlank(clintInfoList[0].year_4__c))){
                    // Associate the value of ClientInfoList year 4 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                }
                if(!(string.isBlank(clintInfoList[0].year_5__c))){
                    // Associate the value of ClientInfoList year 5 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
                }
            }                 
            yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));
            if(yearList.size() == 1){
                changeYear = ConstantsUtil.ALL;
            }
        }
        system.debug('2@@fee addtive value'+feeAdditiveValue+'@@fee additive field'+baf.Additive_Amount__c);
    }
    
    /*******************************************************************************************************************************
* @Method Name       : FeeAmountAction
* @author            : Accenture
* @Last modified by  : Accenture
* @Last modified date: 22/08/2018
* @Purpose           : action method called onchange of Fee Type, Fee Description and Fee Basis
*******************************************************************************************************************************/
    public void FeeAmountAction(){
        try{
            saveBoolValue = false;
            Boolean claimfeeBool=true;
            Boolean tempBool = false;
            Boolean warnigBool = true;
            Boolean warnigRecordBool = true;
            adminFeePopUpFlag = false;
            makeRequireBool = true;
            adminRecordPopUpFlag = false;
            feeBasisList = new List<SelectOption>();
            if(string.ISBLANK(feeBasisValue)){
                baf.Fee_Basis__c = ConstantsUtil.BLANK;
                feeBasisValue = ConstantsUtil.BLANK;
            }else{
                baf.Fee_Basis__c = feeBasisValue;
            }
            if(!string.isBlank(feeDescptionValue)){
                feeBasisFlag = false;
            }else{
                feeBasisFlag = true;
                baf.Fee_Basis__c = null;
            }
            if(string.isblank(feeDescptionValue) || string.isblank(feeBasisValue)){
                baf.Fee_Amount__c = null;
                system.debug('@@baf.Fee_Amount__c'+baf.Fee_Amount__c);
            }
            
            if(string.isblank(feeDescptionValue)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
            }else if(feeDescptionValue.equals(ConstantsUtil.PRE_PROCESSED_DIRECT_CLAIMS) || feeDescptionValue.equals(ConstantsUtil.PAPER_MEDICAID_CLAIMS) || feeDescptionValue.equals(ConstantsUtil.COORDINATN_PAPER)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE , ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_CLAIM , ConstantsUtil.PER_CLAIM));
            }else if(feeDescptionValue.equals(ConstantsUtil.MEDICAID_CLAIMS_BATCH) || feeDescptionValue.equals(ConstantsUtil.COORDINATN_RETAIL_ELEC)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE , ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_CLAIM , ConstantsUtil.PER_CLAIM));      
            }else if(feeDescptionValue.equals(ConstantsUtil.STCOB_RETAIL)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC , ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC ));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_CLAIM , ConstantsUtil.PER_CLAIM));
            }else if(feeDescptionValue.equals(ConstantsUtil.STCOB_MAIL)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC , ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC ));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_CLAIM , ConstantsUtil.PER_CLAIM));
            }else if(feeDescptionValue.equals(ConstantsUtil.COORDINATN_MAIL_ELEC)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE  , ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_CLAIM , ConstantsUtil.PER_CLAIM));
            }else if(feeDescptionValue.equals(ConstantsUtil.COORDINATN_BATCH_PAY_CHASE )){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.ADD_TO_RETAIL_PER_CLAIM , ConstantsUtil.ADD_TO_RETAIL_PER_CLAIM));
            }else if(feeDescptionValue.equals(ConstantsUtil.DENIED_REJ_CLAIMS)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PAPER_CLAIM , ConstantsUtil.PAPER_CLAIM));
            }else if(feeDescptionValue.equals(ConstantsUtil.CLIENT_SPEC_PROG)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_PROG_HOUR_FEE , ConstantsUtil.PER_PROG_HOUR_FEE ));
            }else if(feeDescptionValue.equals(ConstantsUtil.PA_FILE )){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_FILE , ConstantsUtil.PER_FILE));
            }else if(feeDescptionValue.equals(ConstantsUtil.HIS_CLAIMS_CURRENT_PREV_YEAR)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_MONTH , ConstantsUtil.PER_MONTH));
            }else if(feeDescptionValue.equals(ConstantsUtil.HIS_CLAIMS_OVER_CURRENT_PREV_YEAR ) || feeDescptionValue.equals(ConstantsUtil.ONGOING_CLAIMS_DATA_EXT )){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_QUARTER ,ConstantsUtil.PER_QUARTER ));
            }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_STAND_MARKET)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_BOOKLET ,ConstantsUtil.PER_BOOKLET));
            }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_CUSTM_MATERIALS )){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_PAGE  ,ConstantsUtil.PER_PAGE ));
            }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_ASSEM_COSTS )){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_ENVELOPE ,ConstantsUtil.PER_ENVELOPE));
            }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_POST_1ST_OZ_6SHEETS ) || feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_POST_1ST_OZ)){
                feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                feeBasisList.add(new SelectOption(ConstantsUtil.PER_OZ  ,ConstantsUtil.PER_OZ));
            }else if(feeDescptionValue.equals(ConstantsUtil.BENEFITS_CARDS_IND_POST) || feeDescptionValue.equals(ConstantsUtil.BEN_CARDS_ASSEM_BULK_MAILING) || feeDescptionValue.equals(ConstantsUtil.BENEFIT_CARDS_CARRIER)
                     || feeDescptionValue.equals(ConstantsUtil.BENEFIT_CARDS_BULK_MAILING ) || feeDescptionValue.equals(ConstantsUtil.ENTIRE_CLIENT_CARD_REISSUE)){
                         feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                         feeBasisList.add(new SelectOption(ConstantsUtil.PER_CARD_FEE,ConstantsUtil.PER_CARD_FEE ));
                     }else if(feeDescptionValue.equals(ConstantsUtil.WELCOME_KITS_BENEFIT_CARDS_BOOKLET )){
                         feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                         feeBasisList.add(new SelectOption(ConstantsUtil.PER_KIT ,ConstantsUtil.PER_KIT));
                     }else if(feeDescptionValue.equals(ConstantsUtil.DECENTRALIZED_ADMIN) || feeDescptionValue.equals(ConstantsUtil.TOLL_FREE_MEMBER_SER ) || feeDescptionValue.equals(ConstantsUtil.ADMN_OF_DEDCTBLES_AND_MAX) || 
                              feeDescptionValue.equals(ConstantsUtil.CLIENT_GRP_IMPLEMTATION) || feeDescptionValue.equals(ConstantsUtil.MAN_ACCESS_MAN_DRUG_LIMIT) || feeDescptionValue.equals(ConstantsUtil.MEMBER_SERVICES) || 
                              feeDescptionValue.equals(ConstantsUtil.PHARMACY_DIRECT_ON_LINE) || feeDescptionValue.equals(ConstantsUtil.PHARMACY_HELP_DESK) || feeDescptionValue.equals(ConstantsUtil.PHYSICIAN_CONNECTIVITY) || 
                              feeDescptionValue.equals(ConstantsUtil.RX_HUB_CAREMARK)  || feeDescptionValue.equals(ConstantsUtil.EOB_FOR_PAPER_CLAIMS)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.FLAT_FEE ,ConstantsUtil.FLAT_FEE ));
                              }else if(feeDescptionValue.equals(ConstantsUtil.PAPER_CLIENT_DETAIL_REPORTING )){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_REPORT ,ConstantsUtil.PER_REPORT));
                              }else if(feeDescptionValue.equals(ConstantsUtil.ELEC_MAN_ACCESS)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_TRANS_FEE ,ConstantsUtil.PER_TRANS_FEE));
                              }else if(feeDescptionValue.equals(ConstantsUtil.CLIENT_SETUP)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_GROUP_FEE,ConstantsUtil.PER_GROUP_FEE));
                              }else if(feeDescptionValue.equals(ConstantsUtil.ELEC_CORDNATN_OF_BEN)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_CLAIM_FEE,ConstantsUtil.PER_CLAIM_FEE));
                              }else if(feeDescptionValue.equals(ConstantsUtil.CO_BRAND_WEBSITE)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_WEBSITE,ConstantsUtil.PER_WEBSITE));
                              }else if(feeDescptionValue.equals(ConstantsUtil.MEM_ELIG_TRANS_ELEC)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_TRANSMISSION ,ConstantsUtil.PER_TRANSMISSION));
                              }else if(feeDescptionValue.equals(ConstantsUtil.PAPER_ELIG_SUBMISSION)){
                                  feeBasisList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
                                  feeBasisList.add(new SelectOption(ConstantsUtil.PER_SUBMISSION ,ConstantsUtil.PER_SUBMISSION ));
                              }
            
            
            List<Billing_Administrative_Fees__c> billAdmList = [SELECT Base_Amount__c,LOB__c,Year__c,Admin_Fee_Type__c,Billing_Operations__c FROM Billing_Administrative_Fees__c where Billing_Operations__c =:billingOprId];
            if(!string.IsBlank(feeBasisValue) && !string.IsBlank(feeDescptionValue)){
                if(!billAdmList.isempty()){
                    for(Billing_Administrative_Fees__c ba :billAdmList){
                        // If condition when fee type is Claim Fees and related admin fee type is not present in the administrative fees
                        if(((feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON))) || ((feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)) && (ba.Admin_Fee_Type__c == ConstantsUtil.MAIL_PER_CLAIM || ba.Admin_Fee_Type__c == ConstantsUtil.PER_ALL_CLAIMS || ba.Admin_Fee_Type__c == ConstantsUtil.PER_EMP_PER_MON || ba.Admin_Fee_Type__c == ConstantsUtil.PER_MEM_PER_MON)) || ((feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE)) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON)))) && ba.LOB__c.equals(baf.LOB2__c)  && ba.Year__c.equals(baf.Year__c)){
                            adminFeePopUpFlag = false;  
                            warnigBool = false;   // Boolean set to false so that both warning messages doesnot appear together
                        }
                        // Warning message condition when no matching Admin Fee Type
                        if(warnigBool){
                            if(((feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE) && !(ba.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON))) || ((feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)) && !(ba.Admin_Fee_Type__c.equals(ConstantsUtil.MAIL_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON))) || ((feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE)) && !(ba.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON)))) && ba.LOB__c.equals(baf.LOB2__c)  && ba.Year__c.equals(baf.Year__c)){
                                adminFeePopUpFlag = true;
                            }
                        }
                        if(ba.LOB__c.equals(baf.LOB2__c)  && ba.Year__c.equals(baf.Year__c)){ // Warning message condition when no matching Admin Fee Type
                            warnigRecordBool = false;
                            adminRecordPopUpFlag = false;
                            tempBool = false;
                        }
                        if(warnigRecordBool){
                            if(ba.LOB__c != baf.LOB2__c  || ba.Year__c != baf.Year__c){ // Warning message condition when no matching Admin Fee Record
                                tempBool = true;
                            }
                        }
                    }
                    // Warning message condition when no matching Admin Fee Record
                    if(tempBool && (feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE))){
                        adminRecordPopUpFlag = true;
                    }
                }
                // To make the Fe Amount field not required when no matching Admin Fee Record and Fee Type is Claim Fees       
                if(feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)){
                    makeRequireBool = false;
                }
                
                if(!billAdmList.isempty()){
                    for(Billing_Administrative_Fees__c ba :billAdmList){
                        if((feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  && ba.LOB__c.equals(baf.LOB2__c) && ba.Year__c.equals(baf.Year__c) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.RETAIL_PER_CLAIM)  || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))){ // When Fee Type is Claim Fees and Fee Amount is read only and getting populated from Billing Admin Fees on the basis of Fee Basis
                            baf.Fee_Amount__c =  ba.Base_Amount__c;
                            NoAdminFeeFlag = true; 
                            claimfeeBool = false;                           
                            break;                  
                        }else if((feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  && ba.LOB__c.equals(baf.LOB2__c) && ba.Year__c.equals(baf.Year__c) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON))){ // When Fee Type is Claim Fees and Fee Amount is read only and getting populated from Billing Admin Fees on the basis of Fee Basis
                            baf.Fee_Amount__c = 0;
                            NoAdminFeeFlag = true;
                            claimfeeBool = false;   
                            break;                  
                        }else if((feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  && ba.LOB__c.equals(baf.LOB2__c) && ba.Year__c.equals(baf.Year__c) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.MAIL_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))){ // When Fee Type is Claim Fees and Fee Amount is read only and getting populated from Billing Admin Fees on the basis of Fee Basis
                            baf.Fee_Amount__c =  ba.Base_Amount__c;
                            NoAdminFeeFlag = true;
                            claimfeeBool = false;   
                            break;  
                        }else if((feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC))  && ba.LOB__c.equals(baf.LOB2__c) && ba.Year__c.equals(baf.Year__c) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON))){ // When Fee Type is Claim Fees and Fee Amount is read only and getting populated from Billing Admin Fees on the basis of Fee Basis
                            baf.Fee_Amount__c =  0;
                            NoAdminFeeFlag = true;
                            claimfeeBool = false;   
                            break;  
                        }else if(feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE)  && ba.LOB__c.equals(baf.LOB2__c) && ba.Year__c.equals(baf.Year__c) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.PAPER_PER_CLAIM) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_ALL_CLAIMS))){ // When Fee Type is Claim Fees and Fee Amount is read only and getting populated from Billing Admin Fees on the basis of Fee Basis
                            baf.Fee_Amount__c =  ba.Base_Amount__c;
                            NoAdminFeeFlag = true;
                            claimfeeBool = false;   
                            break;  
                        }else if(feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE)  && ba.LOB__c.equals(baf.LOB2__c) && ba.Year__c.equals(baf.Year__c) && (ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_EMP_PER_MON) || ba.Admin_Fee_Type__c.equals(ConstantsUtil.PER_MEM_PER_MON))){ // When Fee Type is Claim Fees and Fee Amount is read only and getting populated from Billing Admin Fees on the basis of Fee Basis
                            baf.Fee_Amount__c =  0;
                            NoAdminFeeFlag = true;
                            claimfeeBool = false;   
                            break;  
                        }
                    }
                }
                
                if(claimfeeBool){
                    if(feeBasisValue.equals(ConstantsUtil.MA_PAPER_PER_CLAIM_ADMINFEE)  || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE) || feeBasisValue.equals(ConstantsUtil.MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC) || feeBasisValue.equals(ConstantsUtil.MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC)){ // When no matching Admin Fee Record,Fee Amount is editable for the Fee Type Claim Fees
                        NoAdminFeeFlag = false;
                    }else if(feeBasisValue.equals(ConstantsUtil.PER_CLAIM)){ // When Fee Basis is Per Claim
                        if( !miscellaneousFlag ){         
                            baf.Fee_Amount__c = null;
                            NoAdminFeeFlag = false;                                                                        
                        }else{
                            baf.Fee_Amount__c = baf.Fee_Amount__c;
                            NoAdminFeeFlag = false;                                                
                        }  
                    }else if(feeDescptionValue.equals(ConstantsUtil.CORDNTION_OF_BENFITS) && feeBasisValue.equals(ConstantsUtil.ADD_TO_RETAIL_PER_CLAIM )){ // When Fee Type is Claim Fees and  Fee Description is 'Coordination of Benefits' and Fee Basis is 'Add to Retail Per Claim'
                        if( !miscellaneousFlag){         
                            baf.Fee_Amount__c = 0.25;
                            NoAdminFeeFlag = false;
                        }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                            baf.Fee_Amount__c = 0.25;
                            NoAdminFeeFlag = false;
                        }else{
                            baf.Fee_Amount__c = baf.Fee_Amount__c;
                            NoAdminFeeFlag = false;
                        }
                    }else if(feeDescptionValue.equals(ConstantsUtil.DENIED_REJ_CLAIMS)  && feeBasisValue.equals(ConstantsUtil.PAPER_CLAIM)){ // When Fee Type is Claim Fees and Fee Description is 'Denied/Rejected Claims' and Fee Basis is 'Paper Claim'
                        if( !miscellaneousFlag){          
                            baf.Fee_Amount__c = 0.00;
                            NoAdminFeeFlag = false;
                        }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                            baf.Fee_Amount__c = 0.00;
                            NoAdminFeeFlag = false;
                        }else{
                            baf.Fee_Amount__c = baf.Fee_Amount__c;
                            NoAdminFeeFlag = false;
                        }
                    }
                }
                
                if(feeDescptionValue.equals(ConstantsUtil.CLIENT_SPEC_PROG)  && feeBasisValue.equals(ConstantsUtil.PER_PROG_HOUR_FEE)){ // When Fee Type is 'Miscellaneous Fees' and  Fee Description is 'Client Specific Programming' and Fee Basis is 'Per Programming Hour Fee' 
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 150.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 150.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }
                }else if(feeDescptionValue.equals(ConstantsUtil.PA_FILE)  && feeBasisValue.equals(ConstantsUtil.PER_FILE)){ // When Fee Type is 'Miscellaneous Fees' and  Fee Description is 'PA File' and Fee Basis is 'Per File'
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 3500.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 3500.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }       
                }else if(feeDescptionValue.equals(ConstantsUtil.HIS_CLAIMS_CURRENT_PREV_YEAR)  && feeBasisValue.equals(ConstantsUtil.PER_MONTH)){ // When Fee Type is 'Miscellaneous Fees' and  Fee Description is 'Historical – Claims Data Extract – Current and or Previous Year' and Fee Basis is 'Per Month'
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 125.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 125.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }          
                }else if(feeDescptionValue.equals(ConstantsUtil.HIS_CLAIMS_OVER_CURRENT_PREV_YEAR)  && feeBasisValue.equals(ConstantsUtil.PER_QUARTER)){ // When Fee Type is  'Miscellaneous Fees' and  Fee Description is 'Historical – Claims Data Extract – Over the Current and or Previous Year' and Fee Basis is 'Per Quarter'
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 1250.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 1250.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }    
                }else if(feeDescptionValue.equals(ConstantsUtil.ONGOING_CLAIMS_DATA_EXT) && feeBasisValue.equals(ConstantsUtil.PER_QUARTER)){ // When Fee Type is 'Miscellaneous Fees' and  Fee Description is 'Ongoing - Claims Data Extract' and Fee Basis is 'Per Quarter'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 375.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 375.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }    
                }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_STAND_MARKET)  && feeBasisValue.equals(ConstantsUtil.PER_BOOKLET)){ // When Fee Type is 'Enrollment Materials' and  Fee Description is 'Enrollment Material Standard Marketing & 1 Pg of PDL Sheet' and Fee Basis is 'Per Booklet'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_CUSTM_MATERIALS)  && feeBasisValue.equals(ConstantsUtil.PER_PAGE)){ // When Fee Type is 'Enrollment Materials' and  Fee Description is 'Enrollment Material Custom Materials' and Fee Basis is 'Per Page'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.03;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.03;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }          
                }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_ASSEM_COSTS)  && feeBasisValue.equals(ConstantsUtil.PER_ENVELOPE)){ // When Fee Type is 'Enrollment Materials' and  Fee Description is 'Enrollment Material Assembly Costs' and Fee Basis is 'Per Envelope'
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 0.05;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag  && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.05;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_POST_1ST_OZ_6SHEETS)  && feeBasisValue.equals(ConstantsUtil.PER_OZ)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Enrollment Material Postage 1st Oz. (6 Sheets)' and Fee Basis is 'Per Oz.'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.39;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag  && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.39;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ENROLMNT_MAT_POST_1ST_OZ)  && feeBasisValue.equals(ConstantsUtil.PER_OZ)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Enrollment Material Postage After 1st Oz.' and Fee Basis is 'Per Oz.'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.23;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.23;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.BENEFITS_CARDS_IND_POST)  && feeBasisValue.equals(ConstantsUtil.PER_CARD_FEE)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Benefit Cards Individual Postage' and Fee Basis is 'Per Card Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.50;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.50;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.BEN_CARDS_ASSEM_BULK_MAILING)  && feeBasisValue.equals(ConstantsUtil.PER_CARD_FEE)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Benefit Cards Assembly Bulk Mailing' and Fee Basis is 'Per Card Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.30;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.30;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.BENEFIT_CARDS_CARRIER)  && feeBasisValue.equals(ConstantsUtil.PER_CARD_FEE)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Benefit Cards Card Carrier' and Fee Basis is 'Per Card Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.20;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.20;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.BENEFIT_CARDS_BULK_MAILING)  && feeBasisValue.equals(ConstantsUtil.PER_CARD_FEE)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Benefit Cards Bulk Mailing' and Fee Basis is 'Per Card Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.WELCOME_KITS_BENEFIT_CARDS_BOOKLET)  && feeBasisValue.equals(ConstantsUtil.PER_KIT)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Welcome Kits (Benefit Cards & Booklet)' and Fee Basis is 'Per Kit'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ENTIRE_CLIENT_CARD_REISSUE)  && feeBasisValue.equals(ConstantsUtil.PER_CARD_FEE)){ // When Fee Type is 'Enrollment Materials' and Fee Description is 'Entire Client Card Reissue - Client Requested' and Fee Basis is 'Per Card Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.50;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.50;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.DECENTRALIZED_ADMIN)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Decentralized Administration' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.PAPER_CLIENT_DETAIL_REPORTING)  && feeBasisValue.equals(ConstantsUtil.PER_REPORT)){ // When Fee Type is 'No Charge' and Fee Description is 'Paper Client Detail Reporting' and Fee Basis is 'Per Report'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.TOLL_FREE_MEMBER_SER)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Toll Free Member Services' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag  && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ELEC_MAN_ACCESS)  && feeBasisValue.equals(ConstantsUtil.PER_TRANS_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Electronic Managed Access' and Fee Basis is 'Per Transaction Fee'
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.CLIENT_SETUP)  && feeBasisValue.equals(ConstantsUtil.PER_GROUP_FEE)){ // When Fee Type is 'No Charge' and  Fee Description is 'Client Set Up' and Fee Basis is 'Per Group Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ELEC_CORDNATN_OF_BEN)  && feeBasisValue.equals(ConstantsUtil.PER_CLAIM_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Electronic Coordination of Benefits' and Fee Basis is 'Per Claim Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag  && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.ADMN_OF_DEDCTBLES_AND_MAX)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Administration of Deductibles and Maximums' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                    
                }else if(feeDescptionValue.equals(ConstantsUtil.CLIENT_GRP_IMPLEMTATION)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Client/Group Implementation' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                    
                }else if(feeDescptionValue.equals(ConstantsUtil.CO_BRAND_WEBSITE)  && feeBasisValue.equals(ConstantsUtil.PER_WEBSITE)){ // When Fee Type is 'No Charge' and Fee Description is 'Co-Branded Website' and Fee Basis is 'Per Website'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    }         
                }else if(feeDescptionValue.equals(ConstantsUtil.MAN_ACCESS_MAN_DRUG_LIMIT)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Managed Access/Managed Drug Limitations' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.MEM_ELIG_TRANS_ELEC) && feeBasisValue.equals(ConstantsUtil.PER_TRANSMISSION)){ // When Fee Type is 'No Charge' and Fee Description is 'Member Eligibility Transmission - Electronic' and Fee Basis is 'Per Transmission'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.MEMBER_SERVICES)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Member Services' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.PHARMACY_DIRECT_ON_LINE)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Pharmacy Directories, On Line' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.PHARMACY_HELP_DESK)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Pharmacy Help Desk for Pharmacists' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.PHYSICIAN_CONNECTIVITY)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'Physician Connectivity' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag ){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.RX_HUB_CAREMARK)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'RxHub/Caremark Connected Network' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.EOB_FOR_PAPER_CLAIMS)  && feeBasisValue.equals(ConstantsUtil.FLAT_FEE)){ // When Fee Type is 'No Charge' and Fee Description is 'EOB for paper claims' and Fee Basis is 'Flat Fee'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }else if(feeDescptionValue.equals(ConstantsUtil.PAPER_ELIG_SUBMISSION) && feeBasisValue.equals(ConstantsUtil.PER_SUBMISSION)){ // When Fee Type is 'No Charge' and Fee Description is 'Paper Eligibility Submission' and Fee Basis is 'Per Submission'
                    if( !miscellaneousFlag){          
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else if(miscellaneousFlag && baf.Fee_Amount__c == null){
                        baf.Fee_Amount__c = 0.00;
                        NoAdminFeeFlag = false;
                    }else{
                        baf.Fee_Amount__c = baf.Fee_Amount__c;
                        NoAdminFeeFlag = false;
                    } 
                }
            }
            baf.Fee_Basis__c = feeBasisValue;
            miscellaneousFlag = false;
            system.debug('=============baf.Fee_Amount__c============='+baf.Fee_Amount__c);
        }catch(Exception excp){
            //ApexPages.addMessages(excp);           
        }  
    }
    /******************************************************************************************************************************
* @Method Name       : FeeAdditiveAction
* @author            : Accenture
* @Last modified by  : Accenture
* @Last modified date: 10/08/2018
* @Purpose           : Action method to make the Additive Amount enable/disable on basis of Addtive checkbox 
*******************************************************************************************************************************/     
    public void FeeAdditiveAction(){ 
        try{
            saveBoolValue = false;
            if(feeAdditiveValue){
                feeAdditiveFlag = false;
                
            }else {
                feeAdditiveFlag = true;
                baf.Additive_Amount__c = null;
            }
        }catch(Exception excp){
            //ApexPages.addMessages(excp);           
        }  
    }
    
    /******************************************************************************************************************************
* @Method Name       : changeAction
* @author            : Accenture
* @Last modified by  : Accenture
* @Last modified date: 10/08/2018
* @Purpose           : Action method invoked when picklist values of LOB and Year changes 
*******************************************************************************************************************************/    
    public void changeAction(){
        try{
            saveBoolValue = false;
            baf.Year__c = changeYear;
            baf.LOB2__c = changeLOB;
            if(feeBasisValue != null){
                FeeAmountAction();
            }
        }catch(Exception excp){
            //ApexPages.addMessages(excp);           
        }
    } 
    
    /******************************************************************************************************************************
* @Method Name       : saveUpdateBAF
* @author            : Accenture
* @Last modified by  : Accenture
* @Last modified date: 10/08/2018
* @Purpose           : Method for save and update the record
*******************************************************************************************************************************/        
    public pagereference saveUpdateBAF(){
        system.debug('hi');
        try{            
            saveBoolValue = false;
            system.debug('baf : ' + baf);
            pagereference pr; 
            if(operationType=='Clone'){
                system.debug('################');
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(baf);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{ 
                string feeDescription = String.isBlank(baf.PBM_Services__c)? baf.Ancillary_Fee_Description__c : baf.Ancillary_Fee_Description_2__c;
                
                List<Fee_Service_Template__c> feetempLst =[select id,Max_Amount__c from Fee_Service_Template__c where Active__c = true AND FAF_Component__c = 'Billing Ops.Ancillary Fees' AND FAF_Component_Type__c =: baf.Ancillary_Fee_Type__c AND Item__c =:feeDescription ];
                If(feetempLst.size()>0){
                    if(feetempLst[0].Max_Amount__c < baf.Fee_Amount__c)
                    {
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.error, 'Fee Amount must be between $0.00 and $'+feetempLst[0].Max_Amount__c));
                        Return null;                                
                    }
                }
                if(bafID == null){
                    insert baf;
                }else{
                    baf.Sync_Source__c ='Target';
                    update baf;
                }
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + baf.id);
            }
            return pr;
        }catch(Exception excp){
            system.debug('exception'+excp);
            // ApexPages.addMessages(excp);
            return null;
        }        
    }
}