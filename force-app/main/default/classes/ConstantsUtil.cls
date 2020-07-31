/* ===============================================================================================================
 * @Trigger Name      : ConstantsUtil
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 03/10/2018
 * @Purpose           : This Utility class is used to store all constants which are referenced across all classes          
====================================================================================================================*/


public with sharing class ConstantsUtil {
/**********************************************************************************************
 * @Description : Constants used in BillingOperationsNewEditClass
 **********************************************************************************************/
    public static final String ID ='id';
    public static final String PHARMACYAUDITRET_BASE ='Base (Custom)';
    public static final String PHARMACYAUDITRET_PREMIER ='Premier (Custom)';
    public static final String PAYMENTTERMS ='Non-Standard';
    public static final String PHARMACYAUDITRET_BASE100 ='Base (100/0)';
    public static final String PHARMACYAUDITRET_PREMIER75 ='Premier (75/25)';
    public static final String PHARMACYAUDITRET_BASE80 ='Base (80/20)';
    public static final String Billing_Operations = 'Billing_Operations';
    public static final String Billing_Other_Payments = 'Billing_Other_Payments';
    public static final String Content_Document_Link = 'Content_Document_Link';
    
/**********************************************************************************************
 * @Description : Constants used in RebateGuaranteeNewEditClass
 **********************************************************************************************/
    
    public static final String GRPPURCHASEORG_GPO ='Group Purchase Organization (GPO)';
    public static final String GUARANTEE_ONLY ='Guarantee Only';
    public static final String SPLIT_WITH_MIN_GUARANTEE ='Split with Min Guarantee';
    public static final String MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER ='Minimum Guarantee with Split of Over Performance';
    public static final String GRPPURCHASEORG_GPO_MAF ='Group Purchase Organization (GPO+MAF)';
    public static final String GRPPURCHASEORG_GPO_MAF_PP ='Group Purchase Organization (GPO+MAF+PP)';  
    public static final String SPLIT_TYPE ='Split Only';  
    public static final String REBATE_GUARANTEE_ERROR1 ='Rebate Guarantee cannot be created when Rebate Offering Type is Split Only and Specialty Rebate Offering Type is Split Only or not selected.';
    public static final String REBATE_GUARANTEE_ERROR2 ='Year is required';
    public static final String REBATE_GUARANTEE_ERROR3 ='Mail(%) must be between 0.00% and 100.00%';
    public static final String REBATE_GUARANTEE_ERROR4 ='Mchoice(%) must be between 0.00% and 100.00%';
    public static final String REBATE_GUARANTEE_ERROR5 ='Specialty Retail(%) must be between 0.00% and 100.00%';
    public static final String REBATE_GUARANTEE_ERROR6 ='Client Owned (30)(%) must be between 0.00% and 100.00%';
    public static final String REBATE_GUARANTEE_ERROR7 ='Client Owned (90)(%) must be between 0.00% and 100.00%';
    public static final String REBATE_GUARANTEE_ERROR8 ='Mail must be between $0.00 and $99,999.00';
    public static final String REBATE_GUARANTEE_ERROR9 ='Retail 30 must be between $0.00 and $99,999.00';
    public static final String REBATE_GUARANTEE_ERROR10 ='Retail 90 must be between $0.00 and $99,999.00';
    public static final String REBATE_GUARANTEE_ERROR11 ='Mchoice must be between $0.00 and $99,999.00';
    public static final String REBATE_GUARANTEE_ERROR12 ='Specialty Retail must be between $0.00 and $99,999.00';
    public static final String REBATE_GUARANTEE_ERROR13 ='Client Owned (30) must be between $0.00 and $99,999.00';
    public static final String REBATE_GUARANTEE_ERROR14 ='Client Owned (90) must be between $0.00 and $99,999.00';
    public static final String REBATE_DOLLAR_REQD ='At least one of the Dollar amount fields needs to be entered';
    public static final String REBATE_PERCENTAGE_REQD ='At least one of the Percentage amount fields needs to be entered';
    public static final String CLOSED ='Closed'; 
    public static final String TIERQ ='2 Tier Q'; 
    public static final String TIER_NQ ='3 Tier NQ'; 
    public static final String TIER_Q ='3 Tier Q'; 
    public static final String VALUE_FORMULARY_STAND = 'Value Formulary Standard' ;
    public static final String VALUE_FORMULARY_INCENT = 'Value Formulary Incentivized' ;
    
/***********************************************************************************************
 * @Description : Constants used in RebateOperationNewEditClass
 **********************************************************************************************/
    
    public static final String RTMD_PEPM ='RTMD PEPM';
    public static final String RTMD_Per_All_Claims ='RTMD Per All Claims';
    public static final String RTMD_PMPM ='RTMD PMPM';
    public static final String PASS_TO_CLIENT ='Pass To Client';    
    public static final String GRPPURCHASEORG_GPO_PP ='Group Purchase Organization (GPO+PP)'; 
    public static final String SILVERSCRIPT_SSI='Silver Script, Inc. (SSI)'; 
    public static final String SILVERSCRIPT_SSI_MAF ='Silver Script, Inc. (SSI+MAF)'; 
    public static final String SILVERSCRIPT_SSI_MAF_PP ='Silver Script, Inc. (SSI+MAF+PP)'; 
    public static final String SILVERSCRIPT_SSI_PP ='Silver Script, Inc. (SSI+PP)';  
    public static final String REINVESTED_REBATES_GPO ='Reinvested Rebates (GPO)';  
    public static final String REINVESTED_REBATES_GPO_MAF='Reinvested Rebates (GPO+MAF)' ;
    public static final String REINVESTED_REBATES_GPO_MAF_PP='Reinvested Rebates (GPO+MAF+PP)';
    public static final String REINVESTED_REBATES_GPO_WR ='Reinvested Rebates (GPO) w/Recon';  
    public static final String REINVESTED_REBATES_GPO_MAF_WR ='Reinvested Rebates (GPO+MAF) w/Recon';
    public static final String REINVESTED_REBATES_GPO_MAF_PP_WR ='Reinvested Rebates (GPO+MAF+PP) w/ Recon';
    public static final String Guaranteed_Net_Cost_GPO ='Guaranteed Net Cost (GPO) w/Recon';
    public static final String Guaranteed_Net_Cost_GPO_MAF ='Guaranteed Net Cost (GPO+MAF) w/Recon';
    public static final String Guaranteed_Net_Cost_GPO_MAF_PP ='Guaranteed Net Cost (GPO+MAF+PP) w/Recon';
    public static final String Rebate_Operations = 'Rebate_Operations';
    public static final String EXPANDABLEVIEW = 'isExpandableView'; 
    public static final String SLASH= '/'; 
    public static final String CHOICE = 'Choice';
    public static final Decimal NUMBER_DEFAULT= 100;
    public static final String OfferingTypeBool = 'OfferingTypeBool'; 
    public static final String clientShareBool = 'clientShareBool';
    public static final String passMAFBool = 'passMAFBool';
    public static final String passPPBool = 'passPPBool'; 
    public static final String clientMAFShareBool = 'clientMAFShareBool';
    public static final String clientPPShareBool = 'clientPPShareBool'; 
    public static final String rebatePayTermBool = 'rebatePayTermBool'; 
    public static final String payOnBool = 'payOnBool'; 
    public static final String freqBool = 'freqBool'; 
    public static final String speedBool = 'speedBool'; 
    public static final String payAfterBool = 'payAfterBool'; 
    public static final String reconBasisBool = 'reconBasisBool'; 
    public static final String reconMethodBool = 'reconMethodBool'; 
    public static final String reconFreqBool = 'reconFreqBool';
    public static final String recontimeFrameBool = 'recontimeFrameBool'; 
    public static final String reconLevelBool = 'reconLevelBool'; 
    public static final String perGuaranteeFlagBool = 'perGuaranteeFlagBool'; 
    public static final String retailDaysSupplyBool = 'retailDaysSupplyBool'; 
    public static final String daysSupplyBool = 'daysSupplyBool';
    public static final String basedOnDaysSupplyBool = 'basedOnDaysSupplyBool';
    public static final String YES = 'YES';
    public static final String No = 'No';
    public static final String Yes1 = 'Yes';

/**********************************************************************************************
 * @Description : Constants used in BillingBrokerTPAPageNewEditClass
 **********************************************************************************************/
    public static final String CUSTOM='Custom'; 
    public static final String Billing_Broker_TPA = 'Billing_Broker_TPA';
    public static final String New_Billing_Broker_TPA = 'New Billing Broker/TPA';
    public static final String See_Notes = 'See Notes';
/**********************************************************************************************
 * @Description : Constants used in MedicareFeesScheduleNewEditClass
 **********************************************************************************************/
    public static final String EGFI ='EGFI';
    public static final String EGWP ='EGWP';
    public static final String MAPD ='MAPD';
    public static final String MMP ='MMP';    
    public static final String MSB ='MSB'; 
    public static final String PDP ='PDP'; 
    public static final String SUBS ='SUBS'; 
    
/**********************************************************************************************
 * @Description : Constants used in billingAncFeeTriggerHelper, billingBrokerTPATriggerHelper

 **********************************************************************************************/    
    public static final String YEAR_LOB_ERROR ='Record already exists for Year & LOB combination specified. Please enter a unique combination';
    public static final String DUPLICATE_CHECK_ANC_ERROR ='Record already exists for Year, LOB, Ancillary Fee Type, Ancillary Fee Description and Fee Basis combination specified. Please enter a unique combination';
    public static final String ALL = 'All';
    public static final String DOLLAR = '$';
    public static final String PERC = '%';
    public static final String BLANK = '';
    public static final String hyphenStr = '-';
    public static final String NONE = '--None--';
    public static final String Check_PBM_Services = 'You must first load PBM Services Records before you add this Billing Ancillary Fees Record.';
    public static final String Billing_Ancillary_Fees = 'Billing_Ancillary_Fees';
    public static final String Billing_Ancillary_Election_Check_ERROR = 'Update associated Fee Services record Set election= False.';
    public static final String Billing_Administrative_Fees = 'Billing_Administrative_Fees';
    public static final String YEAR_LOB_BASIS_TYPE_ERROR ='Record already exists for Year, LOB, Basis & Type combination specified. Please enter a unique combination';
    public static final String BILL_BRO_YEAR_LOB_ERROR ='Record already exists for Year, LOB, Broker/TPA Name, Pay On, Type, Effective Date and Termination combination specified. Please enter a unique combination';
/**********************************************************************************************
 * @Description : Constants used in BillingOperationsTriggerHelper
 **********************************************************************************************/    
    public static final String PARTIAL_FAF_ERROR = 'The current Partial FAF needs to be linked to an existing Full FAF';
    public static final String BILLING_OPP_FAF_ERROR = 'Cannot add more than One Billing Operations to FAF';
    public static final String BILLING_OPP_Election_Check_ERROR = 'Fee Services contains Elections.  You must first un select all Fee Service elections before you take this action.';

    /**********************************************************************************************
 * @Description : Constants used in BillOtherFeesTriggerHelper
 **********************************************************************************************/    
 	public static final String Check_PBM_Services_BOF = 'You must first load PBM Services Records before you add this Billing Other Fees Record.';    
    public static final String Check_PBM_Services_CS = 'You must first load PBM Services Records before you add this Clinical Solutions Record.';
public static final String Check_RDS_Services_Med = 'You must first load Retiree Drug Subsidy Records before you add this Medicare Part D Fees Record.';        
    
/**********************************************************************************************
 * @Description : Constants used in RebtGtesSpecClassTriggerHelper
 **********************************************************************************************/    
    public static final String REBATE_GTEE_TRIG_HELP_ERROR = 'Rebate Guarantee Specialty Class Carve Outs Record already exists for Year, LOB and Drug Therapy Class';
    public static final String Rebate_Gtees_Specialty_Class_Carve_Outs = 'Rebate_Gtees_Specialty_Class_Carve_Outs';
    
/**********************************************************************************************
 * @Description : Constants used in RebateGteeTriggerHelper
 **********************************************************************************************/    
     public static final String YEAR_LOB_BASIS_ERROR = 'Rebate Guarantee Record already exists for Year, LOB, Basis, GSTP, Non-Specialty Formulary, Plan Design and Specialty Formulary specified';    
     public static final String Rebate_Guarantees = 'Rebate_Guarantees';

/**********************************************************************************************
 * @Description : Constants used in BillingAdminFeesTriggerHelper
 **********************************************************************************************/    
     public static final String YEAR_LOB_ADMIN_FEE_TYPE_ERROR = 'Record already exists for Year, LOB and Admin Fee Type combination specified. Please enter a unique combination';
     
/**********************************************************************************************
 * @Description : Constants used in userTriggerHelper
 **********************************************************************************************/    
     public static final String AETNA =   'Aetna';
     public static final String ANTHEM =   'Anthem';

/**********************************************************************************************
 * @Description : Constants used in BillAncillaryNewEditClass
 **********************************************************************************************/    
     public static final String MA_PAPER_PER_CLAIM_ADMINFEE = 'Match Paper Per Claim Admin Fee';
     public static final String MA_RETAIL_PER_CLAIM_ADMINFEE = 'Match Retail Per Claim Admin Fee';
     public static final String MA_MAIL_PER_CLAIM_ADMINFEE = 'Match Mail Per Claim Admin Fee';
     public static final String MA_MAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC = 'Match Mail Per Claim Admin Fee (both primary and secondary claim)';
     public static final String MA_RETAIL_PER_CLAIM_ADMINFEE_BOTH_PRIM_SEC = 'Match Retail Per Claim Admin Fee (both primary and secondary claim)';
     public static final String PRE_PROCESSED_DIRECT_CLAIMS = 'Pre-Processed Direct Claims';
     public static final String MEDICAID_CLAIMS_BATCH = 'Medicaid Claims Batch';
     public static final String PAPER_MEDICAID_CLAIMS = 'Paper Medicaid Claims';
     public static final String STCOB_RETAIL = 'Single Transaction Coordination of Benefits (STCOB) – Retail';
     public static final String STCOB_MAIL = 'Single Transaction Coordination of Benefits (STCOB) – Mail';
     public static final String COORDINATN_RETAIL_ELEC = 'Coordination of Benefits – Retail Electronic';
     public static final String COORDINATN_MAIL_ELEC = 'Coordination of Benefits – Mail Electronic';
     public static final String COORDINATN_PAPER = 'Coordination of Benefits – Paper';
     public static final String COORDINATN_BATCH_PAY_CHASE = 'Coordination of Benefits – Batch Pay-and-Chase (e.g., SPAP, Medicaid, commercial, etc.)';
     public static final String MAIL_PER_CLAIM = 'Mail Per Claim' ;
     public static final String PAPER_PER_CLAIM = 'Paper Per Claim';
     public static final String PER_ALL_CLAIMS = 'Per All Claims';
     public static final String PER_EMP_PER_MON = 'Per Employee Per Month';
     public static final String PER_MEM_PER_MON = 'Per Member Per Month';
     public static final String RETAIL_PER_CLAIM = 'Retail Per Claim';
     public static final String CORDNTION_OF_BENFITS = 'Coordination of Benefits – Batch Pay-and-Chase (e.g., SPAP, Medicaid, commercial, etc.)';
     public static final String ADD_TO_RETAIL_PER_CLAIM = 'Add To Retail Per Claim Admin Fee';
     public static final String DENIED_REJ_CLAIMS = 'Denied/Rejected Claims';
     public static final String PAPER_CLAIM = 'Paper Claim';
     public static final String CLIENT_SPEC_PROG = 'Client Specific Programming';
     public static final String PER_PROG_HOUR_FEE = 'Per Programming Hour Fee';
     public static final String PA_FILE = 'PA File';
     public static final String PER_FILE = 'Per File';
     public static final String HIS_CLAIMS_CURRENT_PREV_YEAR = 'Historical – Claims Data Extract – Current and or Previous Year';
     public static final String PER_MONTH = 'Per Month';
     public static final String HIS_CLAIMS_OVER_CURRENT_PREV_YEAR = 'Historical – Claims Data Extract – Over the Current and or Previous Year';
     public static final String PER_QUARTER = 'Per Quarter';
     public static final String ONGOING_CLAIMS_DATA_EXT = 'Ongoing - Claims Data Extract';
     public static final String ENROLMNT_MAT_STAND_MARKET = 'Enrollment Material Standard Marketing & 1 Pg of PDL Sheet';
     public static final String PER_BOOKLET = 'Per Booklet';
     public static final String ENROLMNT_MAT_CUSTM_MATERIALS = 'Enrollment Material Custom Materials';
     public static final String PER_PAGE = 'Per Page';
     public static final String ENROLMNT_MAT_ASSEM_COSTS = 'Enrollment Material Assembly Costs';
     public static final String PER_ENVELOPE = 'Per Envelope';
     public static final String ENROLMNT_MAT_POST_1ST_OZ_6SHEETS = 'Enrollment Material Postage 1st Oz. (6 Sheets)';
     public static final String PER_OZ = 'Per Oz.';
     public static final String ENROLMNT_MAT_POST_1ST_OZ = 'Enrollment Material Postage After 1st Oz.';
     public static final String BENEFITS_CARDS_IND_POST = 'Benefit Cards Individual Postage';
     public static final String PER_CARD_FEE = 'Per Card Fee';
     public static final String BEN_CARDS_ASSEM_BULK_MAILING = 'Benefit Cards Assembly Bulk Mailing';
     public static final String BENEFIT_CARDS_CARRIER = 'Benefit Cards Card Carrier';
     public static final String BENEFIT_CARDS_BULK_MAILING = 'Benefit Cards Bulk Mailing';
     public static final String WELCOME_KITS_BENEFIT_CARDS_BOOKLET = 'Welcome Kits (Benefit Cards & Booklet)';
     public static final String PER_KIT = 'Per Kit';
     public static final String ENTIRE_CLIENT_CARD_REISSUE = 'Entire Client Card Reissue - Client Requested';
     public static final String DECENTRALIZED_ADMIN = 'Decentralized Administration';
     public static final String FLAT_FEE = 'Flat Fee';
     public static final String PAPER_CLIENT_DETAIL_REPORTING = 'Paper Client Detail Reporting';
     public static final String PER_REPORT = 'Per Report';
     public static final String TOLL_FREE_MEMBER_SER = 'Toll Free Member Services';
     public static final String ELEC_MAN_ACCESS = 'Electronic Managed Access';
     public static final String PER_TRANS_FEE = 'Per Transaction Fee';
     public static final String CLIENT_SETUP = 'Client Set Up';
     public static final String PER_GROUP_FEE = 'Per Group Fee';
     public static final String ELEC_CORDNATN_OF_BEN = 'Electronic Coordination of Benefits';
     public static final String PER_CLAIM_FEE = 'Per Claim Fee';
     public static final String ADMN_OF_DEDCTBLES_AND_MAX = 'Administration of Deductibles and Maximums';
     public static final String CLIENT_GRP_IMPLEMTATION = 'Client/Group Implementation';
     public static final String CO_BRAND_WEBSITE = 'Co-Branded Website';
     public static final String PER_WEBSITE = 'Per Website';
     public static final String MAN_ACCESS_MAN_DRUG_LIMIT = 'Managed Access/Managed Drug Limitations';
     public static final String MEM_ELIG_TRANS_ELEC = 'Member Eligibility Transmission - Electronic';
     public static final String PER_TRANSMISSION = 'Per Transmission';
     public static final String MEMBER_SERVICES = 'Member Services';
     public static final String PHARMACY_DIRECT_ON_LINE = 'Pharmacy Directories, On Line';
     public static final String PHARMACY_HELP_DESK = 'Pharmacy Help Desk for Pharmacists';
     public static final String  PHYSICIAN_CONNECTIVITY = 'Physician Connectivity';
     public static final String RX_HUB_CAREMARK = 'RxHub/Caremark Connected Network';
     public static final String EOB_FOR_PAPER_CLAIMS = 'EOB for paper claims';
     public static final String PAPER_ELIG_SUBMISSION = 'Paper Eligibility Submission';
     public static final String PER_SUBMISSION = 'Per Submission';
     public static final String PER_CLAIM = 'Per Claim';
     public static final String exec_Retail_Lock = 'Exclusive (Retail Lockout)';
     public static final String const_None = 'None';
     public static final String open = 'Open';
     public static final String preferred = 'Preferred';
     public static final String STRING_ID = 'id';
     public static final String FORWARD_SlASH = '/';
 /**********************************************************************************************
 * @Description : Constants used in TrendGuaranteeTriggerHelper
 **********************************************************************************************/    
    public static final String YEARLOBERROR = 'Gnc Guarantee Record already exists for Year, LOB and Channel specified';
 /**********************************************************************************************
 * @Description : Constants used in ASPGuaranteeTriggerHelper
 **********************************************************************************************/    
    public static final String YEARLOBTYPEERROR = 'A Trend Guarantee Record already exists for Year, LOB, Guarantee Type and Drug Type specified';
/**********************************************************************************************
 * @Description : Constants used in GDRGuaranteeTriggerHelper
 **********************************************************************************************/    
    public static final String TYPEERROR = 'A GDR Guarantee record already exists for Type specified';
 /**********************************************************************************************
 * @Description : Constants used in FAFTriggerHelper
 **********************************************************************************************/   
    public static final String GDRGTEEERROR = 'At least one GDR Guarantee record is required when the Generic Dispensing Rate (GDR) Guarantee? is Yes.';
    public static final String TRENDGTEEERROR = 'At least one Trend Guarantee record is required when the Trend Guarantee flag is Yes.';
    public static final String ASPGTEEERROR = 'At least one ASP Guarantee record is required when the ASP Guarantee flag is True.';
 /**********************************************************************************************
 * @Description : Constants used in Speciality Pricing and Drug Level Pricing
 **********************************************************************************************/   
    public static final String CLIENT_CHOICE = 'Client Choice';
    public static final String SPECIALITYPRICINGERRORMESSAGE = 'Platform Specific record(s) exist with Specialty'+' '+ '\'Pharmacy Benefit & Price List\'' + ' ' + 'value'+ ' ' +
 '\'None\'.'+ ' ' + 'Please modify the platform specifics records which are utilizing the Specialty'+ ' ' + '\'Pharmacy Benefit\''+ ' '+ 'value of'+ ' ' +'\'None\'' + ' '+ 'before updating the value on'+ ' ' +'\'Specialty Pricing record\'.';
    public static final String SPECIALITYPRICINGERRORMESSAGE1 = 'Platform Specific record(s) exist with '+'\'Specialty Pharmacy Benefit  & Price List\''+' value(s) which is/are being updated/removed on Specialty Pricing. Please modify the platform specifics records which are utilizing the specific Specialty '+'\'Pharmacy Benefit\''+' and '+'\'Price List\'' +' value combination.';
 /**********************************************************************************************
 * @Description : Constants used in SpecLegacyDrugLevelPricingTriggerHelper
 **********************************************************************************************/   
    public static final String SPECLEGVALIDATEERROR =  'A Specialty Legacy Drug Level Pricing record already exists for Year, LOB, Price List Type, Pharmacy Benefit. Please enter a unique combination';
 /**********************************************************************************************
 * @Description : Constants used in SpecialtyGuaranteeTriggerHelper
 **********************************************************************************************/
    public static final String SPECGTEEVALIDATEERROR =  'A Specialty Guarantee record already exists for Type and Subtype specified.  Please enter a unique combination'; 
    
    public static final String SPECPRICVALMSG=  'A Specialty Pricing record already exists for Year, LOB and Pharmacy Benefit specified.  Please enter a unique combination';
    
    public static final String SPECDRUGLEVELPRICEMSG = 'A Specialty Drug Level Pricing record already exists for Year, LOB, Pharmacy Benefit, Drug Therapy and Drug Name specified. Please enter a unique combination';
    
    public static final String LIGHTNING = 'lightning';
    
    public static final String ApttusPricingEV = '/c/Apttus_Specialty_Pricing_EV.app';
    
    public static final String Specialty_Drug_Level_Pricing = 'Specialty_Drug_Level_Pricing';
    public static final String Specialty_Legacy_Drug_Level_Pricing ='Specialty_Legacy_Drug_Level_Pricing';    
    public static final String Specialty_Guarantee = 'Specialty_Guarantee';
    public static final String Specialty_Pricing= 'Specialty_Pricing';
    
    public static final String specContrartTypeBool= 'specContrartTypeBool';
    public static final String specPriceList= 'specPriceList';
    public static final String specOfferingTypeBool= 'specOfferingTypeBool';
    public static final String specClintShareBool= 'specClintShareBool';
    public static final String specpassMafBool= 'specpassMafBool';
    public static final String specClientMAFShaBool= 'specClientMAFShaBool';
    public static final String specPassPPBool= 'specPassPPBool';
    public static final String specClientPPSharbool= 'specClientPPSharbool';
    public static final String specPayTermMethBool= 'specPayTermMethBool';
    public static final String specPayOnBool= 'specPayOnBool';
    public static final String specFreqBool= 'specFreqBool';
    public static final String specSpeedBool= 'specSpeedBool';
    public static final String specPayAftBool= 'specPayAftBool';
    public static final String specRecBasisBool= 'specRecBasisBool';
    public static final String specRecMethBool= 'specRecMethBool';
    public static final String specRecFreqBool= 'specRecFreqBool';
    public static final String specRecTimeFrmBool= 'specRecTimeFrmBool';
    public static final String specRecLevelBool= 'specRecLevelBool';
    
   public static boolean OFF_TRIGGERS_DUPLICATECHECK = true;
   
/**********************************************************************************************
 * @Description : Constants used in clientInfomationDetails
 **********************************************************************************************/
    public static final String ONE ='1';
    public static final String TWO ='2';
    public static final String THREE ='3';
    public static final String FOUR ='4';
    public static final String FIVE ='5';
/**********************************************************************************************
 * @Description : Constants used in TrendGuaranteeNewEditClass
 **********************************************************************************************/    
    public static final String BYCOMPONENT ='By Component';
    
/**********************************************************************************************
 * @Description : Constants used in GDRGuaranteeNewEditClass
 **********************************************************************************************/    
    public static final String MAXCAP ='$ for $ with Max. Cap';   
    public static final String GDRGUARANTEEMSG ='A GDR Guarantee record already exists for Type specified'; 
    
/**********************************************************************************************
 * @Description : Constants used for the null values in classes
 **********************************************************************************************/    
    public static final String NULLVALUE='';   
    
    /**********************************************************************************************
     * @Description : Constants used for semicolon as a sting 
     **********************************************************************************************/    
    public static final String SEMICOLONSTRSTR =';';
    
    /**********************************************************************************************
     * @Description : Constants used for semicolon as a sting 
     **********************************************************************************************/    
    public static final String COMMASTR=',';
    
    /**********************************************************************************************
     * @Description : Constants used for semicolon as a sting 
     **********************************************************************************************/    
    public static final String SPACESTR =' ';
    
    /**********************************************************************************************
     * @Description : Constants used in clientInfoTriggerHelper
     **********************************************************************************************/ 
    public static final String PRICEEFFECTIVEDATEERROR =  'Modify the Billing Broker/TPA Payment Effective Date on the records to a date equal to, or after, the intended Pricing Effective date, or enter a Pricing Effective Date which is equal to or before the Billing Broker/TPA Payment Effective Date on the Billing Broker/TPA Payment record(s).'; 
  //public static final String CONTRACTENDDATEERROR =  'Modify the Billing Other Payments Expiration Date on the records to a date equal to, or after, the intended Contract End date or enter a Contract End Date which is equal to or before the Billing Other Payments Expiration Date on the Billing Other Payments record(s).'; 
    
    /**********************************************************************************************
     * @Description : Constants used in TR_FAFLink_validate
     **********************************************************************************************/ 
    public static final String FAF_Link = 'FAF_Link';
    
    public static final String TYPE = 'type';
    public static final String CLONE = 'clone';
    
    /**********************************************************************************************
     * @Description : Constants used in AccountTriggerHandler and 
     **********************************************************************************************/ 
     public static final String Manual = 'Manual';
     public static final String Owner = 'Owner';
     public static final String Read = 'Read';
     public static final String Edit = 'Edit';
     public static final String Master = 'Master';
     public static final String SPACESTRNew = ' ';
     
     
     /**********************************************************************************************
     * @Description : Constants used in CentralHubShareModifyTriggerHelper 
     **********************************************************************************************/ 
     public static final String DeleteStr = 'DELETE';
     public static final String Central_Hub_Share_Modify = 'Central_Hub_Share_Modify';
     
    /**********************************************************************************************
    * @Description : Constants used in GuaranteeInfoNewEditClass
    **********************************************************************************************/ 
    public static final String REBATEGNCYESNOERROR = 'Guaranteed Net Cost (Gnc) Guarantee?: You must change the value of the Rebate Guaranteed Net Cost (Gnc) Guarantee? from Yes to No before you proceed';
    public static final String REBATEGNCNOYESERROR = 'Guaranteed Net Cost (Gnc) Guarantee?: You must change the value of the Rebate Guaranteed Net Cost (Gnc) Guarantee? from No to Yes before you proceed';
    public static final String GNCCLAIMERROR = 'Gnc Claim Exclusions: You must include an attachment when Gnc Claim Exclusions is equal to See Files';
    public static final String GNCCLAIMSEEFILES = 'See Files';
    public static final String SHARETYPEPERCENT = 'Percent';
    public static final String SHARETYPEAMOUNT = 'Amount'; 
    
    
     /**********************************************************************************************
     * @Description : Constants used in TR_FAF_Copy_Request 
     **********************************************************************************************/ 
     public static final String FAF_Copy_Request = 'FAF_Copy_Request';
     
     /**********************************************************************************************
     * @Description : Constants used in TR_iUMS_Task_Setup 
     **********************************************************************************************/ 
     public static final String iUMS_Task_Setup = 'iUMS_Task_Setup';
}