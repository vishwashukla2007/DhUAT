/*********************************************************************************************
 * @ClassName         : RebateOperationNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 25/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for RebateOperationNewEditPage  
 **********************************************************************************************/
public with sharing class RebateOperationNewEditClass{
    Public Rebate_Operations__c rebOpr {get;set;} //For Insert update record
    public string NonSpecialtyFormlryValue{get;set;} //String for pass value of Non_Specialty_Formulary_Option__c from Page to class
    public string SpecialtyFormlryValue{get;set;} //String for pass value of Specialty_Formulary_Option__c from Page to class
    public string GSTPOptionValue{get;set;} //String for pass value of GSTP_Option__c from Page to class
    public string GSTPValue{get;set;} //String for pass value of GSTP__c from Page to class
    public string specRebtContractType{get;set;} //String for pass value of Spec contract Type from Page to class
    public string specRebtOfferingType{get;set;} //Stringfor for pass value of Spec Offering Type from Page to class
    public Boolean specialtyRebateSetupCheck{get;set;} //Boolean used for pass the avlue of Specialty_Rebate_Setup_different_than__c from page to Class
    public Boolean specialityPaymentTerm{get;set;} 
    public Boolean contTypOfferTypeBool{get;set;} //For make the field Spec Contract Type and Offering Type conditionally required
    public Boolean specialitypaymentTermReq{get;set;} //Boolean for make the Specialty Rebate Payment Terms section and Specialty Rebate Reconciliation field required
    public String SpecialtyPDPDParam{get;set;} //Variable to hold the value of Specialty_PDPD__c picklist on change
    public Boolean SpecialtyPDPDBool{get;set;} // Boolean used for make the field Select_Specialty_PDPD_Therapy_Class_es__c conditionally required
    public String excludeRebateTheraputic{get;set;} // String for pass the value of Exclude_Rebate_Specialty_Therapeutic__c from page to class
    public Boolean excludeRebateTherapticBool{get;set;}
    public Id roId;
    public Boolean condition1{get;set;}
    public Map<string, Boolean>enableDisableMap{get;set;} //Map which isused for made the field enable disable conditionally in Rebate Operations Information Section
    public string specialityRebateStr{get;set;} //Boolean which pass the value of Specialty_Rebates__c from Page to class on change
    public Boolean specialityRebateBool{get;set;}//
    public Boolean perguaranteeFlag{get;set;}
    public Boolean retailSupplyFlag{get;set;}
    public Map<string, Boolean>rebateenableDisableMap{get;set;}
    public string RebtContractType{get;set;}  //String for pass value of Spec contract Type from Page to class
    public string RebtOfferingType{get;set;}  //String for pass value of Spec offering Type from Page to class
    public string RebtGNC{get;set;}  //String for pass value of reb GNC from Page to class    
    public Boolean specClientShare{get;set;}  
    Public Boolean defaultValBool;
    Public Boolean clientShareDefaultBool;  // To default 0 in Client Share
    Public List<Rebate_Guarantees__c> rebtGuarntList;
    Public List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> rebtCarveOutList; 
    public Boolean mirrorPopupBool{get;set;}
    public Boolean RTMDadminFlag{get;set;}  // Boolean to give pop up on check and uncheck of RTMD when there is an admin fee related record
    Public List<Billing_Administrative_Fees__c> billingAdmList;
    Public boolean validateRequiredFlag;
    Public Boolean showerrorBool{get;set;} //for show messsage that one FAF can have only one Rebate Operation Record
    Public List<SelectOption> specofferingTypeList{get;set;}     // for populate the Specialty Rebate Contract Type dropdown 
    Public List<SelectOption> offeringTypeList{get;set;}     // To populate the Rebate Offering Type dropdown  based on the selection in Rebate Contract Type   
    Public Boolean specPassMAFCheck{get;set;}  //Boolean pass from page to controller onchange the Specialty Pass MAF checkbox
    Public Boolean specPassPPCheck{get;set;}   //Boolean pass from page to controller onchange the Specialty Pass PP checkbox           
     Public Boolean rebatePassMAFCheck{get;set;} //Boolean value passed from page to controller onchange of the rebate Pass MAF checkbox
    Public Boolean rebatePassPPCheck{get;set;}  //Boolean value passed from page to controller onchange of the rebate Pass PP checkbox
    Public Boolean showPopUpWarningFlag{get;set;} 
    Public Boolean guaranteeChildFlag{get;set;}
    Public Boolean carveOutChildFlag{get;set;}
    Public Boolean showerrorFlag{get;set;}  
    public static final String RTMD_PEPM ='RTMD PEPM';
    public static final String RTMD_ALL_CLAIMS ='RTMD Per All Claims';
    public static final String RTMD_PMPM ='RTMD PMPM';
    public Boolean showPopupForNonSpecialty{get;set;} //Boolean to check the popup condition
    public Boolean showPopupForSpecialty{get;set;} //Boolean to check the popup condition
    public Boolean showPopupForGSTP{get;set;} //Boolean to check the popup condition
    public string warningMessage{get;set;} // string to hold the warning msg in the popup
    public Boolean GuarantExistsBool{get;set;} //Boolean to check if any existing guarantee info
    public String infoGNCVal{get;set;} //String to hold the guarantee info gnc value
    public Boolean checkcontracttype{get;set;}
    public Boolean checkspecialR{get;set;}
    public string FAFClientsubtype;
    
    public boolean RTMDTypeRequired{get;set;}
/*********************************************************************************************
 Constructor for RebateOperationNewEditClass
 **********************************************************************************************/
    public RebateOperationNewEditClass(ApexPages.StandardController controller) {
        showerrorFlag = false;
        showPopupForNonSpecialty = false;
        showPopupForSpecialty = false;
        showPopupForGSTP = false;
        showerrorBool = false;
        GuarantExistsBool = false;
        showPopUpWarningFlag = false;
        guaranteeChildFlag = false;
        carveOutChildFlag = false;
        validateRequiredFlag = false;
        rebtGuarntList = new List<Rebate_Guarantees__c>();
        rebtCarveOutList = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
        billingAdmList = new List<Billing_Administrative_Fees__c>();
        mirrorPopupBool = false;
        rebOpr = new Rebate_Operations__c();
        specialityRebateBool = false;
        specClientShare = false;
        perguaranteeFlag = false;
        retailSupplyFlag = false;
        checkcontracttype = false;
        checkspecialR = false;
        RTMDadminFlag = false;
        specPassMAFCheck = false;
        specPassPPCheck = false;
        rebatePassMAFCheck = false;
        rebatePassPPCheck = false;
        RTMDTypeRequired=false;
        FAFClientsubtype='';
        specRebtContractType = ConstantsUtil.NULLVALUE;
        NonSpecialtyFormlryValue = ConstantsUtil.NULLVALUE;
        SpecialtyFormlryValue = ConstantsUtil.NULLVALUE;
        GSTPOptionValue = ConstantsUtil.NULLVALUE;
        GSTPValue= ConstantsUtil.NULLVALUE;
        specRebtOfferingType = ConstantsUtil.NULLVALUE;
        warningMessage = ConstantsUtil.NULLVALUE;
        specofferingTypeList = new List<SelectOption>(); 
        offeringTypeList = new List<SelectOption>(); 
        roId = ApexPages.currentPage().getParameters().get('id'); // Get Rebate Operation Record Id from URL
        Id fafIdId = ApexPages.currentPage().getParameters().get(Label.rebateOperationLabel);// Get Parent FAF record Id from URL
        
        //Create Map for enabel disable condition for Specialty Rebate Setup
        enableDisableMap = new Map<string, Boolean>{ConstantsUtil.specContrartTypeBool => false, ConstantsUtil.specPriceList => false, ConstantsUtil.specOfferingTypeBool=>false, ConstantsUtil.specClintShareBool => false, ConstantsUtil.specpassMafBool => false,        ConstantsUtil.specClientMAFShaBool => false, ConstantsUtil.specPassPPBool => false, ConstantsUtil.specClientPPSharbool => false,         ConstantsUtil.specPayTermMethBool => false, ConstantsUtil.specPayOnBool => false, ConstantsUtil.specFreqBool => false, ConstantsUtil.specSpeedBool => false, ConstantsUtil.specPayAftBool => false, ConstantsUtil.specRecBasisBool => false, ConstantsUtil.specRecMethBool => false, ConstantsUtil.specRecFreqBool => false, ConstantsUtil.specRecTimeFrmBool => false,
        ConstantsUtil.specRecLevelBool => false};
        
         rebateenableDisableMap = new Map<string, Boolean>{ConstantsUtil.OfferingTypeBool => true,ConstantsUtil.clientShareBool => false,ConstantsUtil.passMAFBool => false,ConstantsUtil.passPPBool => false, ConstantsUtil.clientMAFShareBool => false, ConstantsUtil.clientPPShareBool => false, ConstantsUtil.rebatePayTermBool => false, ConstantsUtil.payOnBool => false, 
        ConstantsUtil.freqBool => false, ConstantsUtil.speedBool => false,ConstantsUtil.payAfterBool => false, ConstantsUtil.reconBasisBool => false, ConstantsUtil.reconMethodBool => false, ConstantsUtil.reconFreqBool => false, ConstantsUtil.recontimeFrameBool => false, ConstantsUtil.reconLevelBool => false ,ConstantsUtil.perGuaranteeFlagBool => false,
        ConstantsUtil.retailDaysSupplyBool => false, ConstantsUtil.daysSupplyBool => false, ConstantsUtil.basedOnDaysSupplyBool => false};
        
        SpecialtyPDPDBool = false;
        if(roId == null){ //In New record creation this condition will execute
            specofferingTypeList = new List<SelectOption>(); 
            specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
            offeringTypeList = new List<SelectOption>(); 
            offeringTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
            RebtContractType = ConstantsUtil.BLANK;
            RebtOfferingType = ConstantsUtil.BLANK;
            if(fafIdId != null){
                rebOpr.FAF_Id__c = fafIdId;
                Central_Hub__c FAFInfo=[select id,Client_Subtype__c from Central_Hub__c where id=:fafIdId];
                FAFClientsubtype=FAFInfo.Client_Subtype__c;
                List<Rebate_Operations__c>rebOprSizeCheckLst = new List<Rebate_Operations__c>();                
                rebOprSizeCheckLst = [select id from Rebate_Operations__c where Faf_Id__c=:fafIdId];
                if(rebOprSizeCheckLst.size()>0){
                    showerrorBool = true;                    
                }
            }
            if(!string.isBlank(rebOpr.FAF_Id__c)){
                billingAdmList = [select id,Admin_Fee_Type__c,FAF_ID__c from
                Billing_Administrative_Fees__c where FAF_ID__c =:rebOpr.FAF_Id__c and (Admin_Fee_Type__c =: RTMD_PEPM or Admin_Fee_Type__c =:RTMD_ALL_CLAIMS or Admin_Fee_Type__c =:RTMD_PMPM)];
                
            }
            if(! billingAdmList.isempty()){
                RTMDadminFlag = true;
            }
            
            specialityRebateBool = true;
            enableDisableMap = new Map<string, Boolean>{ConstantsUtil.specContrartTypeBool => true, ConstantsUtil.specPriceList => true, ConstantsUtil.specOfferingTypeBool =>true, ConstantsUtil.specClintShareBool => true, ConstantsUtil.specpassMafBool => true,  ConstantsUtil.specClientMAFShaBool => true, ConstantsUtil.specPassPPBool => true, ConstantsUtil.specClientPPSharbool => true,ConstantsUtil.specPayTermMethBool => true, ConstantsUtil.specPayOnBool => true, ConstantsUtil.specFreqBool => true, ConstantsUtil.specSpeedBool => true, ConstantsUtil.specPayAftBool => true, 
        ConstantsUtil.specRecBasisBool => true, ConstantsUtil.specRecMethBool => true, ConstantsUtil.specRecFreqBool => true, ConstantsUtil.specRecTimeFrmBool => true,
        ConstantsUtil.specRecLevelBool => true};
            rebatechangeTypeField(); // action method for rebate contract type and rebate offering type
            defaultValBool = true; 
            clientShareDefaultBool = true;          // Boolean value set to True to check for new rebate operations record 
        
        }else{ //In Edit case this condition will execute
            defaultValBool = false; 
            clientShareDefaultBool = false;// Boolean value set to False when existing rebate operations record is edited
            
            //Query For fetch the data of Rebate Operation Object
            rebOpr = [select id, FAF_ID__c,FAF_ID__r.Client_Subtype__c, Rebate_Contract_Type__c, Specialty_Rebates__c, Rebate_Offering_Type__c,
            Client_Share__c, Pass_MAF__c, Rebate_RTMD__c, Rebate_RTMD_Type__c, RTMD_Options__c,Pass_PP__C, Client_MAF_Share__c, Client_PP_Share__c,
            X340B__c, Custom_Exclusion_s__c, X340B_Exclusion_Option__c,Select_Custom_Exclusion_s__c, LDD__c,
            Exclude_Rebate_Class__c, LDD_Exclusion_Option__c, Select_Rebate_Exclusion_Class_es__c, Biosimilars__c,
            OTC__c, OTC_Exclusion_Option__c, GSTP__c, GSTP_Option__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c,
            Rebate_Payment_Term_Method_by_Contract__c, Pay_On__c, Frequency__c, Speed__c, Pay_After__c,
            Recon_Basis__c, Recon_Method__c, Recon_Frequency__c, Recon_Timeframe__c, Recon_Level__c,
            Specialty_Retail_Mirror_Retail_30__c, Retail_90_Mirror_Retail_30__c, MChoice_Mirror_Mail__c,
            Percentage_Guarantee__c, Rebate_Retail_90_Days_Supply_84__c, Days_Supply__c,
            Specialty_Rebate_Setup_different_than__c, Specialty_Rebate_Contract_Type__c, Specialty_Price_List__c,
            Specialty_Rebate_Offering_Type__c, Specialty_Client_Share__c, Specialty_Pass_MAF__c,
            Specialty_Client_MAF_Share__c, Specialty_Pass_PP__c, Specialty_Client_PP_Share__c,
            Rebate_Specialty_Payment_Term_Method__c, Specialty_Pay_On__c, Specialty_Frequency__c, Specialty_Speed__c,
            Specialty_Pay_After__c, Specialty_Recon_Basis__c, Specialty_Recon_Method__c, Specialty_Recon_Frequency__c,
            Specialty_Recon_Timeframe__c, Specialty_Recon_Level__c, Specialty_PDPD__c, Select_Specialty_PDPD_Therapy_Class_es__c,
            Exclude_Rebate_Specialty_Therapeutic__c, Select_Specialty_Therapy_Class_es__c, Guaranteed_Net_Cost_Gnc_Guarantee__c,
            Class_Carve_Out_Guarantee_Percentage__c, Additional_Rebate_Information__c, COB__c, Compound__c, Paper__c, SSG__c,
            Vaccine__c, Vaccine_Exclusion_Option__c, ZBD__c, Based_on_Days_Supply__c, Custom_Strategy_Description__c         
            from Rebate_Operations__c where id=: roId];  //18th March 2018  Prakarsh Jain W-000621 Added the fields in query
            specRebtContractType =  rebOpr.Specialty_Rebate_Contract_Type__c; // Value assignmet in Edit case
            specRebtOfferingType =  rebOpr.Specialty_Rebate_Offering_Type__c; 
            NonSpecialtyFormlryValue = rebOpr.Non_Specialty_Formulary_Option__c;
            SpecialtyFormlryValue = rebOpr.Specialty_Formulary_Option__c;
            GSTPOptionValue = rebOpr.GSTP_Option__c;
            GSTPValue = rebOpr.GSTP__c;
            RebtContractType = rebOpr.Rebate_Contract_Type__c;
            RebtOfferingType = rebOpr.Rebate_Offering_Type__c;
            perguaranteeFlag = rebOpr.Percentage_Guarantee__c;
            retailSupplyFlag = rebOpr.Rebate_Retail_90_Days_Supply_84__c;
            specPassMAFCheck = rebOpr.Specialty_Pass_MAF__c;
            specPassPPCheck = rebOpr.Specialty_Pass_PP__c;
            rebatePassPPCheck = rebOpr.Pass_PP__c;
            rebatePassMAFCheck = rebOpr.Pass_MAF__c;
            
            RTMDTypeRequired=rebOpr.Rebate_RTMD__c;
            
            FAFClientsubtype=rebOpr.FAF_ID__r.Client_Subtype__c;
            
            changeTypeField();
            rebatechangeTypeField(); // action method for rebate contract type and rebate offering type
            
            specialtyRebateSetupCheck = rebOpr.Specialty_Rebate_Setup_different_than__c;
            specialityRebateStr = rebOpr.Specialty_Rebates__c;
            RebtGNC = rebOpr.Guaranteed_Net_Cost_Gnc_Guarantee__c;
            if(specialityRebateStr == ConstantsUtil.PASS_TO_CLIENT && RebtGNC == 'Yes'){ //New if condition for Rebate gnc Yes
                specialityRebateBool = true;
                specialtyRebateSetupCheck = false;
            }    
            else if(specialityRebateStr != ConstantsUtil.PASS_TO_CLIENT){
                specialityRebateBool = true;
                specialtyRebateSetupCheck = false;
            }
            if(specialtyRebateSetupCheck == true){
                contTypOfferTypeBool = true;
            }else{
                contTypOfferTypeBool = false;
                enableDisableMap = new Map<string, Boolean>{ConstantsUtil.specContrartTypeBool => true, ConstantsUtil.specPriceList => true, ConstantsUtil.specOfferingTypeBool =>true, ConstantsUtil.specClintShareBool => true, ConstantsUtil.specpassMafBool => true,  ConstantsUtil.specClientMAFShaBool => true, ConstantsUtil.specPassPPBool => true, ConstantsUtil.specClientPPSharbool => true,ConstantsUtil.specPayTermMethBool => true, ConstantsUtil.specPayOnBool => true, ConstantsUtil.specFreqBool => true, ConstantsUtil.specSpeedBool => true, ConstantsUtil.specPayAftBool => true, ConstantsUtil.specRecBasisBool => true, ConstantsUtil.specRecMethBool => true, ConstantsUtil.specRecFreqBool => true, ConstantsUtil.specRecTimeFrmBool => true,
                ConstantsUtil.specRecLevelBool => true};
            }
            
            specialityPaymentTerm = rebOpr.Rebate_Specialty_Payment_Term_Method__c;
            SpecialtyPDPDParam = rebOpr.Specialty_PDPD__c;
            excludeRebateTheraputic = rebOpr.Exclude_Rebate_Specialty_Therapeutic__c;
            
            //specPassMAFAction();
            
            system.debug('==========specPassPPCheck1============='+specPassPPCheck);
            //specPassPPAction();
            rebtGuarntList = [select id,Specialty_Formulary__c,Non_Specialty_Formulary_2__c from Rebate_Guarantees__c where Rebate_Operations__c = :roId];
            if(!rebtGuarntList.isEmpty()){
                mirrorPopupBool = true;
                guaranteeChildFlag = true;
            }
            // Query to check Rebate Carve Out child records PT US 231B by Sneha Inturi
            rebtCarveOutList = [select id,Specialty_Formulary__c from Rebate_Gtees_Specialty_Class_Carve_Outs__c where Rebate_Operations__c = :roId];
            if(!rebtCarveOutList.isEmpty()){
                carveOutChildFlag = true;
            }
            
            if(!string.isBlank(rebOpr.FAF_Id__c)){
                    billingAdmList = [select id,Admin_Fee_Type__c,FAF_ID__c from
                     Billing_Administrative_Fees__c where FAF_ID__c =:rebOpr.FAF_Id__c and (Admin_Fee_Type__c =:RTMD_PEPM or Admin_Fee_Type__c =:RTMD_ALL_CLAIMS or Admin_Fee_Type__c =:RTMD_PMPM)];
                 }
            if(! billingAdmList.isempty()){
            RTMDadminFlag = true;
            }
        }
        //Sindhu-W-000697 Populating Gnc value-2/19/2019
        List<Guarantees_Information__c > infoList = [Select id,FAF_ID__c,Guaranteed_Net_Cost_Gnc_Guarantee__c from Guarantees_Information__c where FAF_ID__c =:rebOpr.FAF_ID__c];
        Map<id,String> GNCMap = new Map<id,String>();        
        for(Guarantees_Information__c  info: infoList){
           GNCMap.put(info.FAF_ID__c,info.Guaranteed_Net_Cost_Gnc_Guarantee__c);     
        }             
        if(roId == null){
            rebOpr.Guaranteed_Net_Cost_Gnc_Guarantee__c = GNCMap.get(rebOpr.FAF_ID__c);
        }        
        if(!infoList.isempty()){
            GuarantExistsBool = true;
            infoGNCVal = infoList[0].Guaranteed_Net_Cost_Gnc_Guarantee__c;
        } //Populating Gnc value 
        if(rebOpr.Guaranteed_Net_Cost_Gnc_Guarantee__c == ''){
            checkcontracttype = false;
        }else{
            checkcontracttype = true;
        }
        if(rebOpr.Rebate_Contract_Type__c == ''){
            checkspecialR = false;
        }else{
            checkspecialR = true;
          }     
       }
    /******************************************************************************************************************************
     * @Method Name       : changeNonSpecOptionAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/10/2018
     * @Purpose           : On change of Non_Specialty_Formulary_Option__c this condition will execute
     *******************************************************************************************************************************/
    public void changeNonSpecOptionAction(){
        if(NonSpecialtyFormlryValue != 'Client Choice' && guaranteeChildFlag){
            showPopupForNonSpecialty = true;
            //warningMessage = 'Changing the Non Specialty Formulary Option will result in updating any existing Rebate Guarantees records for Non Specialty Formulary to this value do you want to continue?';
        }else{
            showPopupForNonSpecialty = false;
        }
    }
    
    /******************************************************************************************************************************
     * @Method Name       : changeSpecFormOptionAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/10/2018
     * @Purpose           : On change of Specialty_Formulary_Option__c this condition will execute
     *******************************************************************************************************************************/
    public void changeSpecFormOptionAction(){
        if(SpecialtyFormlryValue != 'Client Choice' && ( guaranteeChildFlag || carveOutChildFlag )){
            showPopupForSpecialty = true;
        }else{
            showPopupForSpecialty = false;
        }
    }
    
    /******************************************************************************************************************************
     * @Method Name       : changeGSTPOptionAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/10/2018
     * @Purpose           : On change of Specialty_Formulary_Option__c this condition will execute
     *******************************************************************************************************************************/
    public void changeGSTPOptionAction(){
        if(GSTPOptionValue != 'Choice' && guaranteeChildFlag){
            showPopupForGSTP = true;
        }else{
            showPopupForGSTP = false;
        }
    }
    public void changeGSTPAction(){
        if((GSTPValue == 'No' || GSTPValue == '') && guaranteeChildFlag && GSTPOptionValue != null){
            showPopupForGSTP = true;
        }
    }   
 
     /******************************************************************************************************************************
     * @Method Name       : changeTypeField
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : On change the Speciality Contract type and Speciality Offering Type this condition will execute
     *******************************************************************************************************************************/
    public void changeTypeField(){
      try{
        rebOpr.Specialty_Client_Share_Validation__c = false;
        specofferingTypeList = new List<SelectOption>(); 
        system.debug('==============specRebtOfferingType======='+specRebtOfferingType);
        if(string.ISBLANK(specRebtOfferingType)){
            system.debug('=======true========');
            rebOpr.Specialty_Rebate_Offering_Type__c = ConstantsUtil.BLANK;
            specRebtOfferingType = ConstantsUtil.BLANK ;
        }else{
            rebOpr.Specialty_Rebate_Offering_Type__c = specRebtOfferingType; 
        }
        enableDisableMap.put(ConstantsUtil.specClintShareBool,true);
        enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
        enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
        enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
        enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
        enableDisableMap.put(ConstantsUtil.specPayTermMethBool,true);
        enableDisableMap.put(ConstantsUtil.specPayOnBool,true);
        enableDisableMap.put(ConstantsUtil.specFreqBool,true);
        enableDisableMap.put(ConstantsUtil.specSpeedBool,true);
        enableDisableMap.put(ConstantsUtil.specPayAftBool,true);
        enableDisableMap.put(ConstantsUtil.specRecBasisBool,true);
        enableDisableMap.put(ConstantsUtil.specRecMethBool,true);
        enableDisableMap.put(ConstantsUtil.specRecFreqBool,true);
        enableDisableMap.put(ConstantsUtil.specRecTimeFrmBool,true);
        enableDisableMap.put(ConstantsUtil.specRecLevelBool,true);
        specClientShare = false;
        
        if(!string.ISBLANK(specRebtContractType)){
            if(specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO) || specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI) || specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF)){
                enableDisableMap.put(ConstantsUtil.specOfferingTypeBool,false);
                specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.GUARANTEE_ONLY , ConstantsUtil.GUARANTEE_ONLY));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE , ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER , ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER));
            }else if(specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF) || specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) || specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) || specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) || specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP)){
                enableDisableMap.put(ConstantsUtil.specOfferingTypeBool,false);
                specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE , ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER , ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER));
            }else if(specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO) || specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF) ||
            specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP) || specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_WR) || specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_WR) || specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP_WR)){
                enableDisableMap.put(ConstantsUtil.specOfferingTypeBool,false);
                specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
                specofferingTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
            }else{
                specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
                enableDisableMap.put(ConstantsUtil.specOfferingTypeBool,true);
            }
        }else{
            specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
            enableDisableMap.put(ConstantsUtil.specOfferingTypeBool,true);
        }


          if(!string.ISBLANK(specRebtContractType) && (specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO) ||specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF)
        || specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) ||specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) 
        || specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI) ||specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF)
        || specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) ||specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP))) {
            specialitypaymentTermReq = true;
            enableDisableMap.put(ConstantsUtil.specPayTermMethBool,false);
            enableDisableMap.put(ConstantsUtil.specPayOnBool,false);
            enableDisableMap.put(ConstantsUtil.specFreqBool,false);
            enableDisableMap.put(ConstantsUtil.specSpeedBool,false);
            enableDisableMap.put(ConstantsUtil.specPayAftBool,false);
            enableDisableMap.put(ConstantsUtil.specRecBasisBool,false);
            enableDisableMap.put(ConstantsUtil.specRecMethBool,false);
            enableDisableMap.put(ConstantsUtil.specRecFreqBool,false);
            enableDisableMap.put(ConstantsUtil.specRecTimeFrmBool,false);
            enableDisableMap.put(ConstantsUtil.specRecLevelBool,false);
        }else{
            specialitypaymentTermReq = false;
            enableDisableMap.put(ConstantsUtil.specPayTermMethBool,true);
            enableDisableMap.put(ConstantsUtil.specPayOnBool,true);
            enableDisableMap.put(ConstantsUtil.specFreqBool,true);
            enableDisableMap.put(ConstantsUtil.specSpeedBool,true);
            enableDisableMap.put(ConstantsUtil.specPayAftBool,true);
            rebOpr.Rebate_Specialty_Payment_Term_Method__c = false;
            rebOpr.Specialty_Pay_On__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Frequency__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Speed__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Pay_After__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Recon_Basis__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Recon_Method__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Recon_Frequency__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Recon_Timeframe__c = ConstantsUtil.BLANK;
            rebOpr.Specialty_Recon_Level__c = ConstantsUtil.BLANK;
        }
        if(specRebtContractType == null || string.ISBLANK(specRebtContractType) || specRebtOfferingType == null  || string.ISBLANK(specRebtOfferingType)){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,true);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            rebOpr.Specialty_Client_Share__c = null;
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            rebOpr.Specialty_Client_Share_Validation__c = true;
            specPassMAFCheck = false;
            specPassPPCheck = false;
        }else if((specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO) && specRebtOfferingType.equals(ConstantsUtil.GUARANTEE_ONLY)) ||
        (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI) && specRebtOfferingType.equals(ConstantsUtil.GUARANTEE_ONLY)) ||
        (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF) && specRebtOfferingType.equals(ConstantsUtil.GUARANTEE_ONLY))){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,true);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            rebOpr.Specialty_Client_Share__c = null;
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            rebOpr.Specialty_Client_Share_Validation__c = true;
            specPassMAFCheck = false;
            specPassPPCheck = false;
        }else if((specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO) && (specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) ||
        specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) || specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER))) ||
        (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI) && (specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) ||
        specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) || specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)))){
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            enableDisableMap.put(ConstantsUtil.specClintShareBool,false);
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            specPassMAFCheck = false;
            specPassPPCheck = false;
        }else if((specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF) && (specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) ||
        specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) || specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER))) ||
        (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF) && (specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) ||
        specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) || specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)))){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,false);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,false);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            specPassPPCheck = false;
        }else if((specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) && (specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) ||
        specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) || specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER))) ||
        (specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||
        (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP) && (specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) ||
        specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) || specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)))){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,false);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,false);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            specPassMAFCheck = false;
        }else if((specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE))  || (specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) || (specRebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) && specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) || (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) || (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) || (specRebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) && specRebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER))){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,false);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,false);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,false);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
        }
        else if((specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO) || specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF)||
        specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP)) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,false);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            specClientShare = true;
            if(defaultValBool){
                rebOpr.Specialty_Client_Share__c = 0;
            }
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            specialityPaymentTerm = false;
            specPassMAFCheck = false;
            specPassPPCheck = false;
        }else if((specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_wR) || specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_wR) ||
        specRebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP_wR)) && specRebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)){
            enableDisableMap.put(ConstantsUtil.specClintShareBool,false);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            specClientShare = true;
            if(defaultValBool == true){
                rebOpr.Specialty_Client_Share__c = 0;
            }
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            specialityPaymentTerm = false;
            specPassMAFCheck = false;
            specPassPPCheck = false;
        }else{
            enableDisableMap.put(ConstantsUtil.specClintShareBool,true);
            enableDisableMap.put(ConstantsUtil.specpassMafBool,true);
            enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
            enableDisableMap.put(ConstantsUtil.specPassPPBool,true);
            enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
            rebOpr.Specialty_Client_Share__c = null;
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            rebOpr.Specialty_Client_Share_Validation__c = true;
            specPassMAFCheck = false;
            specPassPPCheck = false;
        }
        defaultValBool = true;
        system.debug('=======rebOpr.Specialty_Client_MAF_Share__c====='+rebOpr.Specialty_Client_MAF_Share__c);
        system.debug('=======rebOpr.Specialty_Client_PP_Share__c====='+rebOpr.Specialty_Client_PP_Share__c);
        system.debug('==========specPassPPCheck2============='+specPassPPCheck);
        specPassMAFAction();
        specPassPPAction();
        system.debug('=======rebOpr.Specialty_Client_MAF_Share__c====='+rebOpr.Specialty_Client_MAF_Share__c);
        system.debug('=======rebOpr.Specialty_Client_PP_Share__c====='+rebOpr.Specialty_Client_PP_Share__c);
        system.debug('==============rebOpr.Specialty_Rebate_Offering_Type__c======='+rebOpr.Specialty_Rebate_Offering_Type__c);
        
        /** To show guarantee records delete popup PT US260C added by Sneha Inturi **/           
          if(rebOpr.Rebate_Offering_Type__c==ConstantsUtil.SPLIT_TYPE && guaranteeChildFlag &&
                (specRebtOfferingType==null || specRebtOfferingType=='' || specRebtOfferingType==ConstantsUtil.SPLIT_TYPE)){
                showPopUpWarningFlag = true;
                }else{
                showPopUpWarningFlag = false;
                }
        
        //rebOpr.Specialty_Rebate_Offering_Type__c
      }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
    }
    
    /***********************************************************************************************************************************
    * @author   Akanksha Singh
    * @Created date     06 07 2018
    * @description:This is the action method called when the picklist values change in rebate contract type and rebate offering type 
    ************************************************************************************************************************************/  
    public void rebatechangeTypeField(){ 
     if(RebtGNC == 'No' || RebtGNC == 'Yes' || RebtGNC ==''){
        rebOpr.Client_Share__c = null;
        rebOpr.Specialty_Rebates__c = null;
     }
     if(RebtGNC ==''){     
         checkcontracttype = false;
         checkspecialR = false;
     }else{
         checkcontracttype = true;
     }
     if(RebtContractType == ''){
         checkspecialR = false;
     }else{
         checkspecialR = true;
     }           
     showPopUpWarningFlag = false;
     offeringTypeList = new List<SelectOption>(); 
     if(string.ISBLANK(RebtOfferingType)){
            rebOpr.Rebate_Offering_Type__c = ConstantsUtil.BLANK;
            RebtOfferingType = ConstantsUtil.BLANK;
        }else{
        rebOpr.Rebate_Offering_Type__c = RebtOfferingType; 
        }
        rebateenableDisableMap.put(ConstantsUtil.clientPPShareBool,true);
        rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,true);
        rebateenableDisableMap.put(ConstantsUtil.passMAFBool,true);
        rebateenableDisableMap.put(ConstantsUtil.passPPBool,true);

     if(RebtContractType == ConstantsUtil.GRPPURCHASEORG_GPO || RebtContractType == ConstantsUtil.SILVERSCRIPT_SSI || RebtContractType == ConstantsUtil.SILVERSCRIPT_SSI_MAF){
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,false);
            offeringTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
            offeringTypeList.add(new SelectOption(ConstantsUtil.GUARANTEE_ONLY , ConstantsUtil.GUARANTEE_ONLY));
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE , ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE));
            offeringTypeList.add(new SelectOption(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER , ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER));
        }else if(RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF) || RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) || RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) || RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) || RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP)){
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,false);
            offeringTypeList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE , ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE));
            offeringTypeList.add(new SelectOption(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER , ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER));
        }else if(RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF) ||
        RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_wR) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_wR) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP_wR)){
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,false);
            offeringTypeList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.None));
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
        //Sindhu-W-000697-New GNC Contract Type Value Conditions    
        }else if(RebtContractType.equals(ConstantsUtil.Guaranteed_Net_Cost_GPO)){
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,false);
            rebateenableDisableMap.put(ConstantsUtil.clientShareBool,false);
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
            rebOpr.Rebate_Offering_Type__c = ConstantsUtil.SPLIT_TYPE;
            rebOpr.Specialty_Rebates__c = ConstantsUtil.PASS_TO_CLIENT;
            rebOpr.Client_Share__c = ConstantsUtil.NUMBER_DEFAULT;
        }else if(RebtContractType.equals(ConstantsUtil.Guaranteed_Net_Cost_GPO_MAF)){
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,false);
            rebateenableDisableMap.put(ConstantsUtil.clientShareBool,false);
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
            rebOpr.Rebate_Offering_Type__c = ConstantsUtil.SPLIT_TYPE;
            rebOpr.Specialty_Rebates__c = ConstantsUtil.PASS_TO_CLIENT;
            rebOpr.Client_Share__c = ConstantsUtil.NUMBER_DEFAULT;
        }else if(RebtContractType.equals(ConstantsUtil.Guaranteed_Net_Cost_GPO_MAF_PP)){
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,false);
            rebateenableDisableMap.put(ConstantsUtil.clientShareBool,false);
            offeringTypeList.add(new SelectOption(ConstantsUtil.SPLIT_TYPE , ConstantsUtil.SPLIT_TYPE));
            rebOpr.Rebate_Offering_Type__c = ConstantsUtil.SPLIT_TYPE;
            rebOpr.Specialty_Rebates__c = ConstantsUtil.PASS_TO_CLIENT;
            rebOpr.Client_Share__c = ConstantsUtil.NUMBER_DEFAULT; 
            rebOpr.Specialty_Rebate_Setup_different_than__c = false;
            specialtyRebateSetupCheck = false; //New GNC Contract Type Value Conditions
        }else{
            offeringTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
            rebateenableDisableMap.put(ConstantsUtil.OfferingTypeBool,true);
        }
                 
                // Conditions to check enable disable for Client Share field                      
                 if((RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO) || RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF) || 
                 RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) ||
                 RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) ||
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI) || 
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF) || 
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) || RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP))
                  && RebtOfferingType != ConstantsUtil.GUARANTEE_ONLY && RebtOfferingType != ConstantsUtil.NULLVALUE && RebtContractType != ConstantsUtil.NULLVALUE) {
                 rebateenableDisableMap.put(ConstantsUtil.clientShareBool,false);
                 
                 }
                 else if((RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_wR) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF) ||
                 RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_wR) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP_wR)) && (RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) && (clientShareDefaultBool  ||(!string.ISBLANK(RebtOfferingType) && !string.ISBLANK(RebtContractType) && rebOpr.Client_Share__c == null)))
                 {
                 rebateenableDisableMap.put(ConstantsUtil.clientShareBool,false);
                 rebOpr.Client_Share__c = 0;
                 }else if((RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_wR) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF) ||
                 RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_wR) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP) || RebtContractType.equals(ConstantsUtil.REINVESTED_REBATES_GPO_MAF_PP_wR)) && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE) && !(clientShareDefaultBool) && !string.ISBLANK(RebtOfferingType) && !string.ISBLANK(RebtContractType) && rebOpr.Client_Share__c != null)
                 {
                 rebateenableDisableMap.put(ConstantsUtil.clientShareBool,false);
                 }
                 else{
                 rebateenableDisableMap.put(ConstantsUtil.clientShareBool,true);                 
                 //rebOpr.Client_Share__c = null;                 
                 }
                                             
                // Conditions to check enable disable for Client MAF Share and Pass MAF fields
                
                if(                
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) ||
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF)  && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) || 
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||                
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) ||
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP)  && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) || 
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF) && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF)  && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP)  && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP)  && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) || 
                (RebtContractType.equals(ConstantsUtil.Guaranteed_Net_Cost_GPO_MAF)) ||  
                (RebtContractType.equals(ConstantsUtil.Guaranteed_Net_Cost_GPO_MAF_PP))){
                rebateenableDisableMap.put(ConstantsUtil.passMAFBool,false);
                rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,true);
                }
                else{
                 rebateenableDisableMap.put(ConstantsUtil.passMAFBool,true);
                 rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,true);
                 rebOpr.Pass_MAF__c = false;
                 rebatePassMAFCheck = false;
                 rebOpr.Client_MAF_Share__c = null;
                }
                
                 // Conditions to check enable disable for Client PP Share and Pass PP fields
                 
                if(
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) || 
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) || 
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) || 
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) || 
                (RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_TYPE)) || 
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP) && RebtOfferingType.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE))  ||
                (RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP) && RebtOfferingType.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER)) || (RebtContractType.equals(ConstantsUtil.Guaranteed_Net_Cost_GPO_MAF_PP))){
                rebateenableDisableMap.put(ConstantsUtil.passPPBool,false);
                rebateenableDisableMap.put(ConstantsUtil.clientPPShareBool,true);
                }
                else{
                rebateenableDisableMap.put(ConstantsUtil.passPPBool,true);
                rebateenableDisableMap.put(ConstantsUtil.clientPPShareBool,true);
                rebatePassPPCheck = false;
                rebOpr.Pass_PP__c = false;
                rebOpr.Client_PP_Share__c = null;
                }               
                 // Conditions to check enable disable for rebate payment terms,Pay On,Frequency,Speed,pay After,ren basis,recon Method,recon Frequency,recon Timeframe and recon level  fields

                if(RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO) || 
                 RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF) || 
                 RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_MAF_PP) || 
                 RebtContractType.equals(ConstantsUtil.GRPPURCHASEORG_GPO_PP) || 
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI) || 
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF) ||
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_MAF_PP) ||
                 RebtContractType.equals(ConstantsUtil.SILVERSCRIPT_SSI_PP )){
                 rebateenableDisableMap.put(ConstantsUtil.rebatePayTermBool,false);
                rebateenableDisableMap.put(ConstantsUtil.payOnBool,false);
                rebateenableDisableMap.put(ConstantsUtil.freqBool,false);
                rebateenableDisableMap.put(ConstantsUtil.speedBool,false);
                rebateenableDisableMap.put(ConstantsUtil.payAfterBool,false);
                rebateenableDisableMap.put(ConstantsUtil.reconBasisBool,false);
                rebateenableDisableMap.put(ConstantsUtil.reconMethodBool,false);
                rebateenableDisableMap.put(ConstantsUtil.reconFreqBool,false);
                rebateenableDisableMap.put(ConstantsUtil.recontimeFrameBool,false);
                rebateenableDisableMap.put(ConstantsUtil.reconLevelBool,false);
                 }else{
                rebateenableDisableMap.put(ConstantsUtil.rebatePayTermBool,true);
                rebateenableDisableMap.put(ConstantsUtil.payOnBool,true);
                rebateenableDisableMap.put(ConstantsUtil.freqBool,true);
                rebateenableDisableMap.put(ConstantsUtil.speedBool,true);
                rebateenableDisableMap.put(ConstantsUtil.payAfterBool,true);
                rebateenableDisableMap.put(ConstantsUtil.reconBasisBool,true);
                rebateenableDisableMap.put(ConstantsUtil.reconMethodBool,true);
                rebateenableDisableMap.put(ConstantsUtil.reconFreqBool,true);
                rebateenableDisableMap.put(ConstantsUtil.recontimeFrameBool,true);
                rebateenableDisableMap.put(ConstantsUtil.reconLevelBool,true);
                rebOpr.Rebate_Payment_Term_Method_by_Contract__c = false;
                rebOpr.Pay_On__c = ConstantsUtil.BLANK;
                rebOpr.Frequency__c = ConstantsUtil.BLANK;
                rebOpr.Speed__c = ConstantsUtil.BLANK;
                rebOpr.Pay_After__c = ConstantsUtil.BLANK;
                rebOpr.Recon_Basis__c = ConstantsUtil.BLANK;
                rebOpr.Recon_Method__c = ConstantsUtil.BLANK;
                rebOpr.Recon_Frequency__c = ConstantsUtil.BLANK;
                rebOpr.Recon_Timeframe__c = ConstantsUtil.BLANK;
                rebOpr.Recon_Level__c = ConstantsUtil.BLANK;
                }
                
                // Conditions to check enable disable for percentage guarantee?,rebate retail 90 Days Supply <84? and Days Supply  fields
                if(RebtOfferingType != ConstantsUtil.SPLIT_TYPE && !string.ISBLANK(RebtOfferingType)){
                rebateenableDisableMap.put(ConstantsUtil.perGuaranteeFlagBool,false);
                rebateenableDisableMap.put(ConstantsUtil.retailDaysSupplyBool,false);
                rebateenableDisableMap.put(ConstantsUtil.basedOnDaysSupplyBool,false);
               // rebateenableDisableMap.put(ConstantsUtil.daysSupplyBool,false);
                }
                else{
                rebateenableDisableMap.put(ConstantsUtil.perGuaranteeFlagBool,true);
                rebateenableDisableMap.put(ConstantsUtil.retailDaysSupplyBool,true);
                rebateenableDisableMap.put(ConstantsUtil.daysSupplyBool,true);
                rebateenableDisableMap.put(ConstantsUtil.basedOnDaysSupplyBool,true);
                rebOpr.Percentage_Guarantee__c = false;
                rebOpr.Rebate_Retail_90_Days_Supply_84__c = false;
                rebOpr.Days_Supply__c = null;
                rebOpr.Based_on_Days_Supply__c = null;
                }
                
                /** To show guarantee records delete popup PT US260C added by Sneha Inturi **/ 
              if(RebtOfferingType == ConstantsUtil.SPLIT_TYPE && guaranteeChildFlag &&
                (specRebtOfferingType==null || specRebtOfferingType=='' || specRebtOfferingType==ConstantsUtil.SPLIT_TYPE)){
                showPopUpWarningFlag = true;
                }else{
                showPopUpWarningFlag = false;
                }
                                               
                rebatePassMAFAction();
                rebatePassPPAction();   
            
            /*****US 163 Srini Bathini****/

             if(!rebateenableDisableMap.get(ConstantsUtil.passMAFBool)){
                 rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,false);
                  if(rebOpr.Client_MAF_Share__c==null)
                  rebOpr.Client_MAF_Share__c = rebOpr.Client_Share__c;                
                  rebOpr.Pass_MAF__c=true;  
                  rebatePassMAFCheck=true; 
                  rebateenableDisableMap.put(ConstantsUtil.passMAFBool,true) ;
            } 
            else{
                 rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,true);
                 rebOpr.Client_MAF_Share__c =null;
                  rebOpr.Pass_MAF__c=false;
                 
            } 
            /*****end****/
    }
        
/*********************************************************************************************
 Save method invoked when user clicks save button on Page
 **********************************************************************************************/   
    public pagereference saveUpdateRO(){
        try{
            List<Rebate_Guarantees__c> newRebateGuarList = new  List<Rebate_Guarantees__c>();  //for store the value of Rebate Guarantees
            //List<Rebate_Guarantees__c> newRebateGuarList2 = new  List<Rebate_Guarantees__c>();  //for store the value of Rebate Guarantees
            //List<Rebate_Guarantees__c> newRebateGuarList3 = new  List<Rebate_Guarantees__c>();  //for store the value of Rebate Guarantees
             if(rebOpr.Custom_Exclusion_s__c=='Yes' && (rebOpr.Custom_Strategy_Description__c=='' || rebOpr.Custom_Strategy_Description__c==null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'If you select Custom Exclusion(s)? to Yes then Custom Strategy Description is required.'));
                return null;
            }
            
            /**US 117***/
            if( FAFClientsubtype=='Stand-alone'  && ( ( rebOpr.GSTP__c == 'Yes' && rebOpr.GSTP_Option__c == ConstantsUtil.CHOICE ) ||  rebOpr.Specialty_Formulary_Option__c==  ConstantsUtil.CLIENT_CHOICE || rebOpr.Non_Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE )){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'For Standalone Clients, you cannot select \'Choice\' for GSTP Option or \'Client Choice\' for Formulary Options.')); 
                return null;
            }
            
            pagereference pr;
            system.debug('@@1before new save method'+roId);
            system.debug('@@2before new save method'+rebOpr);
            if(roId == null){
            system.debug('@@in save method');
                insert rebOpr;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + rebOpr.id);
            }else{
                system.debug('@@in update save method');
                update rebOpr;
                if(rebOpr.Rebate_Offering_Type__c != ConstantsUtil.SPLIT_TYPE){
                    if(!rebOpr.Non_Specialty_Formulary_Option__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE) 
                                || !rebOpr.Specialty_Formulary_Option__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE) 
                                    || rebOpr.GSTP_Option__c != ConstantsUtil.CHOICE || rebOpr.GSTP_Option__c != ConstantsUtil.NULLVALUE){
                        for(Rebate_Guarantees__c rg: rebtGuarntList){
                            if(!rebOpr.Non_Specialty_Formulary_Option__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE)){
                                rg.Non_Specialty_Formulary_2__c = rebOpr.Non_Specialty_Formulary_Option__c;
                            }
                            if(!rebOpr.Specialty_Formulary_Option__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE)){
                                rg.Specialty_Formulary__c = rebOpr.Specialty_Formulary_Option__c;
                            }
                            if(rebOpr.GSTP_Option__c != ConstantsUtil.CHOICE &&  rebOpr.GSTP_Option__c != ConstantsUtil.NULLVALUE){
                                rg.GSTP__c = rebOpr.GSTP_Option__c;
                            }
                            newRebateGuarList.add(rg);                            
                        }
                        if(!newRebateGuarList.isEmpty()){
                            update newRebateGuarList;
                        }                        
                    }                    
                }
                //Update Rebate carve out related list PT US231B added by Sneha Inturi
                if(showPopupForSpecialty && carveOutChildFlag && rebOpr.Specialty_Formulary_Option__c!=null && !rebOpr.Specialty_Formulary_Option__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE) ){
                    for(Rebate_Gtees_Specialty_Class_Carve_Outs__c rgs: rebtCarveOutList){
                        rgs.Specialty_Formulary__c=rebOpr.Specialty_Formulary_Option__c;
                    }
                    update rebtCarveOutList;
                }
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + rebOpr.id);  
            }
            return pr;
            
        }catch(Exception excp){
            system.debug('excp>>> '+excp);
            ApexPages.addMessages(excp);
            return null;
        }
    }
    
    public void contractReq(){
     if(RebtGNC ==''){     
         checkcontracttype = false;
         checkspecialR = false;
     }else{
         checkcontracttype = true;
     }
    }    
 /*********************************************************************************************
 Method called onchange the "Specialty Rebate Setup different than" field
 **********************************************************************************************/   
    public void oncheckspecialityAction(){
        if(specialtyRebateSetupCheck){
        
            contTypOfferTypeBool = true;
            enableDisableMap = new Map<string, Boolean>{ConstantsUtil.specContrartTypeBool => false, ConstantsUtil.specPriceList => false,ConstantsUtil.specOfferingTypeBool =>true, ConstantsUtil.specClintShareBool => true, ConstantsUtil.specpassMafBool => true,  ConstantsUtil.specClientMAFShaBool => true, ConstantsUtil.specPassPPBool => true, ConstantsUtil.specClientPPSharbool => true, ConstantsUtil.specPayTermMethBool => true, ConstantsUtil.specPayOnBool => true, ConstantsUtil.specFreqBool => true, ConstantsUtil.specSpeedBool => true, ConstantsUtil.specPayAftBool => true, 
        ConstantsUtil.specRecBasisBool => true, ConstantsUtil.specRecMethBool => true, ConstantsUtil.specRecFreqBool => true, ConstantsUtil.specRecTimeFrmBool => true,
        ConstantsUtil.specRecLevelBool => true};
            
        }else{
            specialitypaymentTermReq = false;   
            contTypOfferTypeBool = false;
            enableDisableMap = new Map<string, Boolean>{ConstantsUtil.specContrartTypeBool => true, ConstantsUtil.specPriceList => true, ConstantsUtil.specOfferingTypeBool =>true, ConstantsUtil.specClintShareBool => true, ConstantsUtil.specpassMafBool => true,  ConstantsUtil.specClientMAFShaBool => true, ConstantsUtil.specPassPPBool => true, ConstantsUtil.specClientPPSharbool => true, ConstantsUtil.specPayTermMethBool => true, ConstantsUtil.specPayOnBool => true, ConstantsUtil.specFreqBool => true, ConstantsUtil.specSpeedBool => true, ConstantsUtil.specPayAftBool => true, 
        ConstantsUtil.specRecBasisBool => true, ConstantsUtil.specRecMethBool => true, ConstantsUtil.specRecFreqBool => true, ConstantsUtil.specRecTimeFrmBool => true,
        ConstantsUtil.specRecLevelBool => true};
            rebOpr.Specialty_Rebate_Contract_Type__c = null;
            rebOpr.Specialty_Price_List__c = null;
            rebOpr.Specialty_Rebate_Offering_Type__c = null;
            rebOpr.Specialty_Client_Share__c = null;
            rebOpr.Specialty_Pass_MAF__c = false;
            rebOpr.Specialty_Client_MAF_Share__c = null;
            rebOpr.Specialty_Pass_PP__c = false;
            rebOpr.Specialty_Client_PP_Share__c = null;
            rebOpr.Rebate_Specialty_Payment_Term_Method__c = false;
            rebOpr.Specialty_Pay_On__c = null;
            rebOpr.Specialty_Frequency__c = null;
            rebOpr.Specialty_Speed__c = null;
            rebOpr.Specialty_Pay_After__c = null;
            rebOpr.Specialty_Recon_Basis__c = null;
            rebOpr.Specialty_Recon_Method__c = null;
            rebOpr.Specialty_Recon_Frequency__c = null;
            rebOpr.Specialty_Recon_Timeframe__c = null;
            rebOpr.Specialty_Recon_Level__c = null;
            specialityPaymentTerm = false;
            specialityPaymentTerm = false;
        }
        specofferingTypeList = new List<SelectOption>(); 
        specofferingTypeList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
        
        /** To show guarantee records delete popup PT US260C added by Sneha Inturi **/
                if(rebOpr.Rebate_Offering_Type__c == ConstantsUtil.SPLIT_TYPE && guaranteeChildFlag &&
                (rebOpr.Specialty_Rebate_Offering_Type__c==null || rebOpr.Specialty_Rebate_Offering_Type__c=='' || rebOpr.Specialty_Rebate_Offering_Type__c==ConstantsUtil.SPLIT_TYPE)){
                showPopUpWarningFlag = true;
                }else{
                showPopUpWarningFlag = false;
                }
    }
    
 /*********************************************************************************************
 Method called onchange the "Specialty Rebate Setup different than" field
 **********************************************************************************************/  
 public void oncheckspecialityPmntTermAction(){
        try{
            if(specialityPaymentTerm){
                specialitypaymentTermReq = true;
            }else{
                specialitypaymentTermReq = false;
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
    }
    /*
    public void changespecialityPDPDAction(){
        if(SpecialtyPDPDParam.equals(ConstantsUtil.YES)){
            SpecialtyPDPDBool = true;
        }else{
            SpecialtyPDPDBool = false;
            rebOpr.Select_Specialty_PDPD_Therapy_Class_es__c = null;
        }
    }
    public void excluedeRebateSpecialityAction(){
        if(excludeRebateTheraputic.equals(ConstantsUtil.YES)){
            excludeRebateTherapticBool = true;
        }else{
            excludeRebateTherapticBool = false;
            rebOpr.Select_Specialty_Therapy_Class_es__c = null;
        }
    }*/
    public void changeSpecialityRebateAction(){
        try{
            if(RebtGNC == 'Yes'){ //New if condition for Rebate gnc Yes
                rebOpr.Specialty_Rebate_Setup_different_than__c = false;
                specialtyRebateSetupCheck = false;
                specialitypaymentTermReq = false;
                specialityRebateBool = true;
                oncheckspecialityAction();
                specialityPaymentTerm = false;
            }else if( specialityRebateStr != ConstantsUtil.PASS_TO_CLIENT){
                rebOpr.Specialty_Rebate_Setup_different_than__c = false;
                specialtyRebateSetupCheck = false;
                specialitypaymentTermReq = false;
                specialityRebateBool = true;
                oncheckspecialityAction();
                specialityPaymentTerm = false;                
            }else{
                specialityRebateBool = false;
            }
            /** To show guarantee records delete popup PT US260C added by Sneha Inturi **/
                if(rebOpr.Rebate_Offering_Type__c == ConstantsUtil.SPLIT_TYPE && guaranteeChildFlag &&
                (rebOpr.Specialty_Rebate_Offering_Type__c==null || rebOpr.Specialty_Rebate_Offering_Type__c=='' || rebOpr.Specialty_Rebate_Offering_Type__c==ConstantsUtil.SPLIT_TYPE)){
                showPopUpWarningFlag = true;
                }else{
                showPopUpWarningFlag = false;
                }
            }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}     
    }
    
 /*********************************************************************************************
 action method called when the percentage guarantee? checkbox value changes  - commenting the method for defect fix for DD-000122
 **********************************************************************************************/  
    public void perGuaranteeretailDaysAction(){
        try{
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));} 
    }
    
       
 /*********************************************************************************************
 action method called when the rebate retail 90 Days Supply < 84 checkbox value changes
 **********************************************************************************************/  
    public void retailDaysSupplyAction(){
        try{
            if(retailSupplyFlag){           
                rebateenableDisableMap.put(ConstantsUtil.daysSupplyBool, false);
            }else{
            rebOpr.Days_Supply__c = null;
            rebateenableDisableMap.put(ConstantsUtil.daysSupplyBool, true);
            }
         }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}    
    }
    
    /******************************************************************************************************************************
     * @Method Name       : specPassMAFAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method used oncheck Specialty Pass MAF? checkbox
     *******************************************************************************************************************************/
    public void specPassMAFAction(){
         try{
             if(specPassMAFCheck){
                enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,false);
                rebOpr.Specialty_Client_MAF_Share_Validation__c = false;
            }else{
                enableDisableMap.put(ConstantsUtil.specClientMAFShaBool,true);
                rebOpr.Specialty_Client_MAF_Share_Validation__c = true;
                rebOpr.Specialty_Client_MAF_Share__c = null;
            }
         }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));} 
    }
    
    /******************************************************************************************************************************
     * @Method Name       : specPassPPAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method used oncheck Specialty Pass PP? checkbox
     *******************************************************************************************************************************/
    public void specPassPPAction(){
        try{
            if(specPassPPCheck){
                enableDisableMap.put(ConstantsUtil.specClientPPSharbool,false);
                rebOpr.Specialty_Client_PP_Share_Validation__c = false;
            }else{
                enableDisableMap.put(ConstantsUtil.specClientPPSharbool,true);
                rebOpr.Specialty_Client_PP_Share_Validation__c = true;
                rebOpr.Specialty_Client_PP_Share__c = null;
            }
         }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}    
    }
    

         /******************************************************************************************************************************
     * @Method Name       : rebatePassMAFAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method used oncheck Rebate Pass MAF? checkbox
     *******************************************************************************************************************************/
    public void rebatePassMAFAction(){
        try{   
            if(rebatePassMAFCheck){
                rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,false);
                if(rebOpr.Client_MAF_Share__c==null)
                rebOpr.Client_MAF_Share__c = rebOpr.Client_Share__c;
                rebOpr.Pass_MAF__c=true;
                
            }else{
                rebateenableDisableMap.put(ConstantsUtil.clientMAFShareBool,true);
                rebOpr.Client_MAF_Share__c = null;
            }                     
         }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}    
    }
    
    /******************************************************************************************************************************
     * @Method Name       : rebatePassPPAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method used oncheck Rebate Pass PP? checkbox
     *******************************************************************************************************************************/
    public void rebatePassPPAction(){
        try{
            if(rebatePassPPCheck){
                rebateenableDisableMap.put(ConstantsUtil.clientPPShareBool,false);
            }else{
                rebateenableDisableMap.put(ConstantsUtil.clientPPShareBool,true);
                rebOpr.Client_PP_Share__c = null;
            }
         }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}    
    }
}