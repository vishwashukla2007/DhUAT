/*********************************************************************************************
 * @ClassName         : GuaranteeInfoNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 23/07/2018
 * @Last modified by  : 
 * @Last modified date: 07/05/2019
 * @Purpose           : This is the controller class for GuaranteeInfoNewEditPage         
 **********************************************************************************************/
public with sharing class GuaranteeInfoNewEditClass{
    //public ApexPages.StandardController con;
    Public Guarantees_Information__c guaranteeInfoObj{get;set;} // Object declair for insert update
    Public Id guaranteeInfoID{get;set;}  //For get the Record id
    Public Boolean showerrorBool{get;set;} //for show messsage that one FAF can have only one Rebate Operation Record 
    public Map<string, Boolean>enableDisableMap{get;set;}    //Map which is used for made the field enable disable conditionally in Trend Guarantee Information section
    public Boolean aspEnableDisableBool{get;set;} //variable which is used for made the field enable disable conditionally in ASP Guarantee Information section
    public String trendGuarValue{get;set;} //variable for pass value of Trend Guarantee from Page to class
    public Boolean sharedRiskValue{get;set;} //variable for pass value of Shared Risk from Page to class
    public Boolean aspGuarValue{get;set;} //variable for pass value of ASP Guarantee from Page to class
    public Boolean aspSpcDgnValue{get;set;} //variable for pass value of ASP Specific Plan Design from Page to class
    public Boolean aspSpcDgnBool{get;set;} //variable which is used for made enable/disable on change of ASP Specific Plan Design
    public Boolean perfGuaranteeBool{get;set;}   //Boolean used for made the field enable disable conditionally in Performance Guarantee section
    public Boolean enbDisbperfGuarantee{get;set;}   //enable Disable Performance Guarantee Boolean which pass value from class to page
    public Boolean valueFormBool{get;set;} //variable for pass value of ASP Value Based Formulary from Page to class
    public Boolean otherFormBool{get;set;} //variable for pass value of ASP Other Based Formulary from Page to class
    public Boolean trendRequiredBool{get;set;} //variable used to make trend dependant fields required conditionally
    public Boolean gncGuaranteeBool{get;set;}  //variable to make GncGuarantee dependent fields required conditionally
    public String gncGuaranteeVal{get;set;}  //variable for pass value of Gnc Guarantee from Page to Class
    public String shareTypeVal{get;set;} //variable to show Percent or Amount fields as per Gnc Share Type value field
    public Boolean shareTypePercentShowBool{get;set;} //variable to show Percent(%) fields 
    public Boolean shareTypeAmountShowBool{get;set;} //variable to show Amount($) fields
    public Boolean shareTypePercentDisBool{get;set;} //variable to disable Percent(%) fields
    public Boolean shareTypeAmountDisBool{get;set;} //variable to disable Amount($) fields
    public Boolean gncGuarRiskSharingEnaDisBool{get;set;} //variable to enable disable Guarantee Risk Sharing dependent fields
    public String gncGuarRiskSharingVal{get;set;} //variable to store the value of Guarantee Risk Sharing field
    public String gncCorridorThresholdVal{get;set;} //variable to store the value of Guarantee Corridor Threshold field
    public Boolean gncShareType{get;set;} //variable to store the value for Guarantee Share Type
    public Boolean gncCorridorThresholdBool{get;set;} //variable to make Gnc Guarantee Threshold field as required
    public Boolean gncGuarShareTypeBool{get;set;} //variable to make Gnc Guarantee Share Type field as required
    public Boolean customReqEnaDisBool{get;set;} //variable to enable/disable Custom Requirements or Restrictions field as required
    public Boolean gncbasisEnaDisBool{get;set;}
    public Boolean gncfrequencyEnaDisBool{get;set;}
    public Boolean gnctimeframeEnaDisBool{get;set;}
    public Boolean gncreconlevelEnaDisBool{get;set;}
    public Boolean clientSharePercentBool{get;set;} //variable to make Client Share Percent field as required
    public Boolean gncPayoutCapBool{get;set;} //variable to make Gnc Payout Cap field as required
    public String gncPayOutCapStr{get;set;}
    public Boolean gncPayoutCapAmtBool{get;set;} //variable to make Gnc Payout Capital Amount field as required
    public Boolean gncReconciliationEnaDisBool{get;set;} //variable to make Gnc Reconcilitaion field to enable/disable
    public Boolean RebateExistsBool{get;set;}
    public Boolean upperLowerPercentBool{get;set;} //variable to make Gnc Upper and Lower Corridor % field as required
    public Boolean upperLowerAmountBool{get;set;} //variable to make Gnc Upper and Lower Corridor $ field as required
    public String gdrGuarValue{get; set;}
    public Boolean gdrGuarBoolean{get; set;}
    //Constructor of the GuaranteeInfoNewEditClass
    public GuaranteeInfoNewEditClass(ApexPages.StandardController controller) {
        initialiseVariable();
        guaranteeInfoID = ApexPages.currentPage().getParameters().get('id'); //Get Id fo the record from URL
        Id fafId = ApexPages.currentPage().getParameters().get(Label.fafIdInGuaranteeInfo); //Get FAF Id from URL
        //If the record is new this condition will execute        
        if(String.IsBlank(guaranteeInfoID)){
            if(!String.IsBlank(fafId)){
                List<Guarantees_Information__c>fafDataCount = new List<Guarantees_Information__c>();
                fafDataCount = [select id from Guarantees_Information__c where FAF_Id__c=:fafId];
                if(!fafDataCount.isEmpty()){
                    showerrorBool = true;
                }
                guaranteeInfoObj.Faf_Id__c = fafId;
                enableDisableMap = new Map<string, Boolean>{'payoutAmtPerBasisBool' => true, 'maxAmtAtRiskBool' => true, 'sharedRiskBool' => true, 'cvssharedRiskBool' => true, 'clientsharedRiskBool' => true  };
                aspEnableDisableBool = true;
                gncGuarRiskSharingEnaDisBool = true;
                gncShareType = true;
                gncPayoutCapAmtBool = true;
                customReqEnaDisBool = true;
                gncReconciliationEnaDisBool = true;
                gncbasisEnaDisBool = true;
                gncfrequencyEnaDisBool = true;
                gnctimeframeEnaDisBool = true;
                gncreconlevelEnaDisBool = true;
                
            }
            perfGuaranteeBool = false;
            aspSpcDgnBool = true;
            
            if(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c == ConstantsUtil.Yes1){
                gncGuarDependentEnaDisReq();
            }
            gdrGuarBoolean = true;
            gdrGuarValue = '';
        }else{ // //In User edit a record then this condition will execute
        
            //Fetch Guarantee Information object info
            guaranteeInfoObj = [select id, name, Gnc_Recon_Timeframe__c, Additional_Guarantee_Information__c,
            Gnc_Guarantee_Basis__c, //Prakarsh W-000726 Removed reference of fields from query
            Gnc_Guarantee_Frequency__c, //Prakarsh W-000726 Removed reference of fields from query
            Gnc_Recon_Level__c, //Prakarsh W-000726 Removed reference of fields from query
            Client_Trend_Gtee_Shared_Risk_Client__c,    //Prakarsh W-000726 Removed reference of fields from query
            CVS_Health_Trend_Gtee_Shared_Risk_CV__c, FAF_ID__c, GDR_Guarantee_Basis__c, GDR_Guarantee_Count__c,
            GDR_Guarantee_Payout__c, GDR_Recon_Level__c, GDR_Recon_Method__c, GDR_Recon_Timeframe__c,
            Generic_Dispensing_Rate_GDR_Guarantee__c, Guarantee_Payout_Basis__c, Legacy_PG_Path__c,
            Performance_Guarantee__c, PG_At_Risk_Dollar_Amount__c, PG_Client_Specific_Are_there__c,
            PG_Maximum_Dollar_Amount_at_Risk__c, PG_Metric__c, PG_Path__c, Trend_Guarantee__c,
            Trend_Guarantee_Max_Amount_at_Risk__c, Trend_Guarantee_Payout_Amount_Per_Basis__c,
            Trend_Guarantee_Shared_Risk__c, Trend_Recon_Level__c, Trend_Recon_Method__c, Trend_Recon_Timeframe__c,
            Gnc_Corridor_Lower__c, Gnc_Corridor_Upper__c, Gnc_Guarantee_Corridor_Threshold__c
            ,Gnc_Guarantee_Risk_Sharing__c, Gnc_Guarantee_Share_Type__c, Guaranteed_Net_Cost_Gnc_Guarantee__c,
            Client_Share_Percent__c, Gnc_Payout_Cap__c, Gnc_Payout_Cap_Amount__c, CVSH_Share_Percent__c, Gnc_Corridor_Lower_Amount__c,
            Gnc_Corridor_Upper_Amount__c, Gnc_Claim_Exclusions__c, Custom_Requirements_or_Restrictions__c,
            Gnc_Retain_Rebates_After_Reconciliation__c
            from Guarantees_Information__c where id =: guaranteeInfoID];
            
            trendGuarValue = guaranteeInfoObj.Trend_Guarantee__c;   // assign value in edit case
            sharedRiskValue = guaranteeInfoObj.Trend_Guarantee_Shared_Risk__c;   // assign value in edit case
            //Prakarsh W-000726 Commented reference of fields
            //aspGuarValue = guaranteeInfoObj.Average_Sales_Price_Per_Client_ASP__c;   // assign value in edit case
            //aspSpcDgnValue = guaranteeInfoObj.ASP_Specific_Plan_Design__c;   // assign value in edit case
            aspGuarValue = (guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c=='Yes')?true:false;
            perfGuaranteeBool = guaranteeInfoObj.Performance_Guarantee__c;   //assign value of Perforrmance Gurantee checkbox
            
            //when Trend Guarantee is not checked then all fields are disable
            if(guaranteeInfoObj.Trend_Guarantee__c != ConstantsUtil.Yes1){
                enableDisableMap = new Map<string, Boolean>{'payoutAmtPerBasisBool' => true, 'maxAmtAtRiskBool' => true, 'sharedRiskBool' => true, 'cvssharedRiskBool' => true, 'clientsharedRiskBool' => true  };
            }else{
                trendRequiredBool = true;
                //when Trend Guarantee is checked & Shared Risk is not checked then 2 fields are disable
                if(!guaranteeInfoObj.Trend_Guarantee_Shared_Risk__c){
                    enableDisableMap = new Map<string, Boolean>{'payoutAmtPerBasisBool' => false, 'maxAmtAtRiskBool' => false, 'sharedRiskBool' => false, 'cvssharedRiskBool' => true, 'clientsharedRiskBool' => true  };
                }
            }
            //when ASP Guarantee is not checked then all fields are disable

            enableDisableGncFieldOnLoad();    
        }
        actionOnChangePerfGuarantee();
        List<Rebate_Operations__c> rebList = [Select id,FAF_ID__c,Guaranteed_Net_Cost_Gnc_Guarantee__c from Rebate_Operations__c where FAF_ID__c =:guaranteeInfoObj.Faf_Id__c];
        Map<id,String> RebateGNCMap = new Map<id,String>();
        
        for(Rebate_Operations__c reb: rebList){
           RebateGNCMap.put(reb.FAF_ID__c,reb.Guaranteed_Net_Cost_Gnc_Guarantee__c);     
        }
        if(guaranteeInfoID == null){
            guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c = RebateGNCMap.get(guaranteeInfoObj.Faf_Id__c);
        }
        if(!rebList.isempty()){
            RebateExistsBool = true;
        }

        if(guaranteeInfoObj.Generic_Dispensing_Rate_GDR_Guarantee__c == 'Yes'){
            gdrGuarBoolean = false;
        }else{
            gdrGuarBoolean = true;
        }
    }
    
    //Method for save and update the recoed
    public pagereference saveUpdateguaranteeInfoObj(){
        try{
            //List to check no gnc field changes are made from guarantee info -W-000718/W-000719- Sindhu A
            List<Rebate_Operations__c> rebList = new List<Rebate_Operations__c>();
            rebList = [Select id,FAF_ID__c,Guaranteed_Net_Cost_Gnc_Guarantee__c from Rebate_Operations__c where FAF_ID__c =:guaranteeInfoObj.Faf_Id__c];
            Map<id,String> RebateGNCMap = new Map<id,String>();
            
            for(Rebate_Operations__c reb: rebList){
               RebateGNCMap.put(reb.FAF_ID__c,reb.Guaranteed_Net_Cost_Gnc_Guarantee__c);     
            }
            if(!ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c) && ConstantsUtil.Yes1.equals(RebateGNCMap.get(guaranteeInfoObj.FAF_ID__c))){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ConstantsUtil.REBATEGNCYESNOERROR));
                            return null; 
            } else if(ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c) && ConstantsUtil.No.equals(RebateGNCMap.get(guaranteeInfoObj.FAF_ID__c))){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ConstantsUtil.REBATEGNCNOYESERROR));
                            return null;
            }
            if(guaranteeInfoObj.Client_Share_Percent__c != null && guaranteeInfoObj.Client_Share_Percent__c >= 0 && guaranteeInfoObj.Client_Share_Percent__c <= 100){
                guaranteeInfoObj.CVSH_Share_Percent__c = 100 - guaranteeInfoObj.Client_Share_Percent__c;
            }
            //list to check if the guarantee info record has files records associated to it - W-000739 - Prakarsh Jain
            List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
            if(guaranteeInfoID == null){
                insert guaranteeInfoObj;  //Insert Guarantee info
            }else{
                /*if(ConstantsUtil.GNCCLAIMSEEFILES.equals(guaranteeInfoObj.Gnc_Claim_Exclusions__c)){
                    contentDocumentLinkList = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =: guaranteeInfoObj.Id];
                    if(contentDocumentLinkList.size() == 0){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ConstantsUtil.GNCCLAIMERROR));
                        return null;
                    }
                }*/
                if(guaranteeInfoObj.Gnc_Claim_Exclusions__c != null){
                    if((guaranteeInfoObj.Gnc_Claim_Exclusions__c).contains(ConstantsUtil.GNCCLAIMSEEFILES)){
                        contentDocumentLinkList = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =: guaranteeInfoObj.Id];
                        if(contentDocumentLinkList.size() == 0){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ConstantsUtil.GNCCLAIMERROR));
                            return null;
                        }
                    }
                }
                update guaranteeInfoObj;  //Update Guarantee info
            }
            pagereference pr = new pagereference(ConstantsUtil.SLASH + guaranteeInfoObj.id);
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            system.debug(excp.getlinenumber());
            return null;
        }
    }
    
    //Method call on change of Trend Guarantee checkbox
    public void changeTrendGuarField(){
        try{
            sharedRiskValue = false;
            if(trendGuarValue.equals(ConstantsUtil.Yes1)){
                trendRequiredBool = true;
                enableDisableMap.put('payoutAmtPerBasisBool',false);
                enableDisableMap.put('maxAmtAtRiskBool',false);
                enableDisableMap.put('sharedRiskBool',false);
            }else{
                trendRequiredBool = false;
                enableDisableMap.put('payoutAmtPerBasisBool',true);
                enableDisableMap.put('maxAmtAtRiskBool',true);
                enableDisableMap.put('sharedRiskBool',true);
                enableDisableMap.put('cvssharedRiskBool',true);
                enableDisableMap.put('clientsharedRiskBool',true);
                
                guaranteeInfoObj.Trend_Guarantee_Payout_Amount_Per_Basis__c = null;
                guaranteeInfoObj.Trend_Guarantee_Max_Amount_at_Risk__c = null;
                guaranteeInfoObj.Trend_Guarantee_Shared_Risk__c = false;
                guaranteeInfoObj.CVS_Health_Trend_Gtee_Shared_Risk_CV__c = null;
                guaranteeInfoObj.Client_Trend_Gtee_Shared_Risk_Client__c = null; 
            }
        }catch(Exception ex){ 
            ApexPages.addMessages(ex);
        }        
    }
    
    //Method call on change of Trend Guarantee checkbox
    public void changeGdrGuarField(){
        try{
           if(gdrGuarValue == 'Yes'){
                gdrGuarBoolean = false;
           }else{
                gdrGuarBoolean = true;
                guaranteeInfoObj.GDR_Guarantee_Basis__c = '';
           }
        }catch(Exception ex){ 
            ApexPages.addMessages(ex);
        }        
    }
    
    //Method call on change of Shared Risk checkbox
    public void changeSharedRiskField(){
        try{
            if(sharedRiskValue){
                enableDisableMap.put('cvssharedRiskBool',false);
                enableDisableMap.put('clientsharedRiskBool',false);           
            }else{
                enableDisableMap.put('cvssharedRiskBool',true);
                enableDisableMap.put('clientsharedRiskBool',true);
                
                guaranteeInfoObj.CVS_Health_Trend_Gtee_Shared_Risk_CV__c = null;
                guaranteeInfoObj.Client_Trend_Gtee_Shared_Risk_Client__c = null;           
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
    
    //Method call on change of ASP Guarantee checkbox
    public void changeASPGuarField(){
        try{
        if(aspGuarValue){
                aspEnableDisableBool = false;     //all dependent fields are enable in this case                    
            }else{
                aspSpcDgnValue = false;         //assigning ASP Specific Plan Design checkbox value
                aspSpcDgnBool = true;
                //Prakarsh W-000726 Commented reference of fields
                //guaranteeInfoObj.ASP_Specific_Plan_Design_Details__c = null;       
                //guaranteeInfoObj.ASP_Expected_Payout_Amount__c = null;
                //guaranteeInfoObj.ASP_Value_Formulary__c = false;
                //guaranteeInfoObj.ASP_Specific_Plan_Design__c = false;
                //guaranteeInfoObj.ASP_Other_Formulary__c = false;
                //guaranteeInfoObj.ASP_GSTP__c = false;
                //guaranteeInfoObj.ASP_Maintenance_Choice__c = false;
                //guaranteeInfoObj.ASP_Exclusive_Specialty__c = false;
                //guaranteeInfoObj.ASP_SGM__c = false;
                aspEnableDisableBool = true;   //all dependent fields are disable in this case 
                guaranteeInfoObj.Gnc_Guarantee_Basis__c = null;
                guaranteeInfoObj.Gnc_Guarantee_Frequency__c = null;
                guaranteeInfoObj.Gnc_Recon_Timeframe__c = null;
                guaranteeInfoObj.Gnc_Recon_Level__c = null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
    
    //Method Used to enable disable the field in Performance Guarantee Section and set them Null/False in case of disable
    Public void actionOnChangePerfGuarantee(){
        try{
            if(perfGuaranteeBool){
                enbDisbperfGuarantee = false;
            }else{
                enbDisbperfGuarantee = true;
                guaranteeInfoObj.PG_Client_Specific_Are_there__c = false;            
                guaranteeInfoObj.PG_At_Risk_Dollar_Amount__c = null; 
                guaranteeInfoObj.PG_Metric__c = null;
                guaranteeInfoObj.PG_Maximum_Dollar_Amount_at_Risk__c = null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }        
    }

    //Method Used to enable disable the field onchange of ASP Specific Plan Design and set them Null/False in case of disable
    Public void changeASPDesignField(){
        try{
            if(aspSpcDgnValue){
                aspSpcDgnBool = false;
            }else{
                aspSpcDgnBool = true;
                //Prakarsh W-000726 Commented reference of fields
                //guaranteeInfoObj.ASP_Specific_Plan_Design_Details__c = null;                        
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
    
    //Method call on change of ASP Value Based Formulary checkbox
    Public void actionOnChangeValueForm(){
        try{
            if(valueFormBool){
                otherFormBool = false;
                //Prakarsh W-000726 Commented reference of fields
                //guaranteeInfoObj.ASP_Other_Formulary__c = false;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
    
    //Method call on change of ASP Other Based Formulary checkbox
    Public void actionOnChangeOtherForm(){
        try{
            if(otherFormBool){
                valueFormBool = false;
                //Prakarsh W-000726 Commented reference of fields
                //guaranteeInfoObj.ASP_Value_Formulary__c = false;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }    
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method called from page when Guaranteed Net Cost (Gnc) Guarantee Value is changed
                             (W-000683, W-000713, W-000718, W-000719, W-000694, W-000695)
    ========================================================================*/
    public void GncGuaranteeChange(){
        try{
            //If Guaranteed_Net_Cost_Gnc_Guarantee__c is Yes then make Guaranteed_Net_Cost_Gnc_Guarantee__c dependent fields enabled and required
            if(ConstantsUtil.Yes1.equals(gncGuaranteeVal)){
                gncGuaranteeBool = true;
                customReqEnaDisBool = false;
                gncReconciliationEnaDisBool = false;
                gncbasisEnaDisBool = false;
                gncfrequencyEnaDisBool = false;
                gnctimeframeEnaDisBool = false;
                gncreconlevelEnaDisBool = false;
                aspGuarValue = true;
                if(guaranteeInfoObj.Gnc_Guarantee_Risk_Sharing__c != 'Yes'){               
                    gncPayoutCapBool = false;
                }
                if(guaranteeInfoObj.Gnc_Payout_Cap__c != 'Yes'){
                    gncPayoutCapAmtBool = true;
                }
                system.debug('====================In If');
            } 
            else{//If Guaranteed_Net_Cost_Gnc_Guarantee__c is No then make Guaranteed_Net_Cost_Gnc_Guarantee__c dependent fields enabled and required
                gncCorridorThresholdBool = false;
                gncGuarShareTypeBool = false;
                gncGuaranteeBool = false;
                gncShareType = true;
                gncPayoutCapAmtBool = true;
                shareTypePercentDisBool = true;
                gncGuarRiskSharingEnaDisBool = true;
                shareTypeAmountShowBool = false;
                shareTypePercentShowBool = true;
                upperLowerPercentBool = false;
                upperLowerAmountBool = false;
                customReqEnaDisBool = true;
                gncbasisEnaDisBool = true;
                gncfrequencyEnaDisBool = true;
                gnctimeframeEnaDisBool = true;
                gncreconlevelEnaDisBool = true;
                GncReconciliationEnaDisBool = true;
                clientSharePercentBool = false;
                gncPayoutCapBool = false;
                system.debug('====================In Else');
                makeGncGuarFieldsNull();
                makeGuarRiskSharFieldsNull();
                makePerAmountFieldsNull();
                aspGuarValue = false;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method called from page when Gnc Share Type Value is changed
                             (W-000687, W-000688, W-000689, W-000690, W-000745, W-000746, W-000747, W-000748, W-000751, W-000752,
                              W-000749, W-000750)
    ========================================================================*/
    public void showHidePercentDollarField(){
        try{
            //If share type field value is Percent then enable Corridor % fields and make them required
            if(ConstantsUtil.SHARETYPEPERCENT.equals(shareTypeVal)){
                shareTypePercentDisBool = false;
                shareTypeAmountDisBool = true;
                upperLowerPercentBool = true;
                guaranteeInfoObj.Gnc_Corridor_Lower_Amount__c = null;
                guaranteeInfoObj.Gnc_Corridor_Upper_Amount__c = null;
                shareTypeAmountShowBool = false;
                shareTypePercentShowBool = true;
                upperLowerAmountBool = false;
            }
            else if(ConstantsUtil.SHARETYPEAMOUNT.equals(shareTypeVal)){//If share type field value is Amount then show, enable Corridor $ fields and make them required
                shareTypePercentDisBool = true;
                shareTypeAmountDisBool = false;
                upperLowerPercentBool = false;
                upperLowerAmountBool = true;
                guaranteeInfoObj.Gnc_Corridor_Upper__c = null;
                guaranteeInfoObj.Gnc_Corridor_Lower__c = null;
                shareTypeAmountShowBool = true;
                shareTypePercentShowBool = false;
            }
            else{//If share type field value is Percent then disable Corridor % fields hide amount fields
                shareTypePercentDisBool = true;
                shareTypeAmountDisBool = true;
                shareTypeAmountShowBool = false;
                upperLowerPercentBool = false;
                upperLowerAmountBool = false;
                shareTypePercentShowBool = true;
                makePerAmountFieldsNull();
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }        
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method called from page when Gnc Guarantee Risk Sharing Value is changed
                             (W-000684, W-000715, W-000716, W-000691, W-000692, W-000693, )
    ========================================================================*/
    public void enableRiskDependentFields(){
        try{
            //If Gnc Guarantee Risk Sharing field is Yes then enable Gnc Guarantee Risk Sharing dependent fields and make them required
            if(ConstantsUtil.Yes1.equals(gncGuarRiskSharingVal)){
                gncGuarRiskSharingEnaDisBool = false;
                gncShareType = true;
                gncGuarRiskSharDependentReq();
            }
            else{//If Gnc Guarantee Risk Sharing field is No then disable Gnc Guarantee Risk Sharing dependent fields and make them null
                gncGuarShareTypeBool = false;
                gncCorridorThresholdBool = false;
                gncShareType = true;
                shareTypePercentDisBool = true;
                gncGuarRiskSharingEnaDisBool = true;
                shareTypeAmountDisBool = true;
                clientSharePercentBool = false;
                gncPayoutCapBool = false;
                gncPayoutCapAmtBool = true;
                shareTypeAmountShowBool = false;
                upperLowerAmountBool = false;
                shareTypePercentShowBool = true;
                upperLowerPercentBool = false;
                makeGuarRiskSharFieldsNull();
                makePerAmountFieldsNull();
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }        
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method called from page when Gnc Corridor Threshold Value is changed(W-000685, W-000722, W-000721)
    ========================================================================*/  
    public void enableShareType(){
        try{
            //If Gnc Corridor Threshold value is Yes then make Gnc Corridor Threshold dependent fields enable and required
            if(ConstantsUtil.Yes1.equals(gncCorridorThresholdVal)){
                gncGuarShareTypeBool = true;
                gncShareType = false;
                shareTypePercentDisBool = true;
            }
            else{//If Gnc Corridor Threshold value is No then make Gnc Corridor Threshold dependent fields disable and null
                guaranteeInfoObj.Gnc_Guarantee_Share_Type__c = null;
                gncGuarShareTypeBool = false;
                gncShareType = true;
                shareTypePercentDisBool = true;
                shareTypeAmountDisBool = true;
                shareTypeAmountShowBool = false;
                shareTypePercentShowBool = true;
                upperLowerPercentBool = false;
                upperLowerAmountBool = false;
                makePerAmountFieldsNull();
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }        
    }
    
    /* ========================================================================================
     * @author            : Abhishek Tiwari(Accenture)
     * @created date      : 09/05/2019
     * @Last modified by  : Abhishek Tiwari(Accenture)
     * @Last modified date: 09/05/2019
     * @Purpose           : Method called from page when Gnc Payout Cap value is changed
    ===========================================================================================*/  
    public void changePayOutCapMeth(){
        try{
            //If Gnc Corridor Threshold value is Yes then make Gnc Corridor Threshold dependent fields enable and required
            if(ConstantsUtil.Yes1.equals(gncPayOutCapStr)){
                gncPayoutCapAmtBool = false;
            }
            else{//If Gnc Corridor Threshold value is No then make Gnc Corridor Threshold dependent fields disable and null
                guaranteeInfoObj.Gnc_Payout_Cap_Amount__c = null;
                gncPayoutCapAmtBool = true;
                makePerAmountFieldsNull();
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }        
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method to make certain fields null
    ========================================================================*/
    private void makePerAmountFieldsNull(){
        guaranteeInfoObj.Gnc_Corridor_Lower_Amount__c = null;
        guaranteeInfoObj.Gnc_Corridor_Upper_Amount__c = null;
        guaranteeInfoObj.Gnc_Corridor_Upper__c = null;
        guaranteeInfoObj.Gnc_Corridor_Lower__c = null;
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method called from from constructor to make fields enable/disable/required
    ========================================================================*/
    private void enableDisableGncFieldOnLoad(){
        //Enable Corridor % fields and show on page
        if(ConstantsUtil.SHARETYPEPERCENT.equals(guaranteeInfoObj.Gnc_Guarantee_Share_Type__c)){
            shareTypePercentDisBool = false;
            shareTypeAmountDisBool = true;
            shareTypeAmountShowBool = false;
        }
        //Enable Corridor $ fields and show on page
        else if(ConstantsUtil.SHARETYPEAMOUNT.equals(guaranteeInfoObj.Gnc_Guarantee_Share_Type__c)){
            shareTypePercentDisBool = true;
            shareTypeAmountDisBool = false;
            shareTypeAmountShowBool = true;
            shareTypePercentShowBool = false;
        }
        else{
            shareTypePercentDisBool = true;
            shareTypeAmountDisBool = true;
            shareTypeAmountShowBool = false;
        }
        //Disable Gnc Guarantee Risk Sharing Dependent fields
        if(!ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Risk_Sharing__c)){
            gncGuarRiskSharingEnaDisBool = true;
        }
        //Disable Gnc Guarantee Risk Sharing Dependent fields
        if(ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c)){
            gncGuarDependentEnaDisReq();
        }
        //Disable Gnc Guarantee Corridor Threshold Dependent fields
        if(!ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Corridor_Threshold__c)){
            gncShareType = true;
        }
        //Disable Gnc Guarantee Corridor Threshold Dependent fields
        if(!ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_payout_cap__c)){
            gncPayoutCapAmtBool = true;
        }
        //Make the Risk Sharing Dependent fields required
        if(ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c) && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Risk_Sharing__c)){
            gncGuarRiskSharDependentReq();
        }
        //Make Gnc Guarantee Share Type required
        if(ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c) && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Risk_Sharing__c)
           && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Corridor_Threshold__c)){
            gncGuarShareTypeBool = true;
        }    
        //Make Gnc Upper Corridor % fields required
        if(ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c) && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Risk_Sharing__c)
           && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Corridor_Threshold__c) && ConstantsUtil.SHARETYPEPERCENT.equals(guaranteeInfoObj.Gnc_Guarantee_Share_Type__c)){
            upperLowerPercentBool = true;
        }    
        //Make Gnc Upper Corridor $ fields required
        if(ConstantsUtil.Yes1.equals(guaranteeInfoObj.Guaranteed_Net_Cost_Gnc_Guarantee__c) && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Risk_Sharing__c)
           && ConstantsUtil.Yes1.equals(guaranteeInfoObj.Gnc_Guarantee_Corridor_Threshold__c) && ConstantsUtil.SHARETYPEAMOUNT.equals(guaranteeInfoObj.Gnc_Guarantee_Share_Type__c)){
            upperLowerAmountBool = true;
        }
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method to Enable/Disable/Require Gnc Guarantee Dependent fields
    ========================================================================*/
    private void gncGuarDependentEnaDisReq(){
        gncGuaranteeBool = true;
        customReqEnaDisBool = false;
        gncReconciliationEnaDisBool = false;
        gncbasisEnaDisBool = false;
        gncfrequencyEnaDisBool = false;
        gnctimeframeEnaDisBool = false;
        gncreconlevelEnaDisBool = false;
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method to make Gnc Guarantee Risk Sharing Dependent fields required
    ========================================================================*/
    private void GncGuarRiskSharDependentReq(){
        gncCorridorThresholdBool = true;
        gncPayoutCapBool = true;
        clientSharePercentBool = true;
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method to make Gnc Guarantee Risk Sharing Dependent fields null
    ========================================================================*/
    private void makeGuarRiskSharFieldsNull(){
        guaranteeInfoObj.Gnc_Guarantee_Share_Type__c = null;
        guaranteeInfoObj.Gnc_Guarantee_Corridor_Threshold__c = null;
        guaranteeInfoObj.Client_Share_Percent__c = null;
        guaranteeInfoObj.CVSH_Share_Percent__c = null;
        guaranteeInfoObj.Gnc_Payout_Cap__c = null;
        guaranteeInfoObj.Gnc_Payout_Cap_Amount__c = null;
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method to make Gnc Guarantee Dependent fields null
    ========================================================================*/
    private void makeGncGuarFieldsNull(){
        guaranteeInfoObj.Gnc_Claim_Exclusions__c = null;
        guaranteeInfoObj.Custom_Requirements_or_Restrictions__c = null;
        guaranteeInfoObj.Gnc_Retain_Rebates_After_Reconciliation__c = null;
        guaranteeInfoObj.Gnc_Guarantee_Basis__c = null;
        guaranteeInfoObj.Gnc_Guarantee_Frequency__c = null;
        guaranteeInfoObj.Gnc_Recon_Timeframe__c = null;
        guaranteeInfoObj.Gnc_Recon_Level__c = null;
        guaranteeInfoObj.Gnc_Payout_Cap__c = null;
        guaranteeInfoObj.Gnc_Payout_Cap_Amount__c = null;
    }
    
    /* ====================================================================
     * @author            : Prakarsh Jain(Accenture)
     * @created date      : 17 04 2019
     * @Last modified by  : Prakarsh Jain(Accenture)
     * @Last modified date: 17/04/2019
     * @Purpose           : Method called from constructor to initialise variables
    ========================================================================*/
    private void initialiseVariable(){
        showerrorBool = false;
        trendRequiredBool = false;
        gncGuaranteeBool = false;
        trendGuarValue = 'None';
        sharedRiskValue = false;
        aspGuarValue = false;
        aspSpcDgnValue = false;
        aspSpcDgnBool = false;
        valueFormBool = false;
        otherFormBool = false;
        RebateExistsBool = false;
        shareTypePercentDisBool = true;
        shareTypeAmountDisBool = true;
        shareTypePercentShowBool = true;
        shareTypeAmountShowBool = false;
        guaranteeInfoObj = new Guarantees_Information__c();
        enableDisableMap = new Map<string, Boolean>{'payoutAmtPerBasisBool' => false, 'maxAmtAtRiskBool' => false, 'sharedRiskBool' => false, 'cvssharedRiskBool' => false, 'clientsharedRiskBool' => false   };
        aspEnableDisableBool = false;
        gncGuarRiskSharingEnaDisBool = false;
        gncShareType = false;
        gncCorridorThresholdBool = false;
        gncGuarShareTypeBool = false;
        upperLowerPercentBool = false;
        upperLowerAmountBool= false;
        customReqEnaDisBool = true;
        gncbasisEnaDisBool = true;
        gncfrequencyEnaDisBool = true;
        gnctimeframeEnaDisBool = true;
        gncreconlevelEnaDisBool = true;
        clientSharePercentBool = false;
        gncPayoutCapBool = false;
        gncReconciliationEnaDisBool = true;
        
        //defaulting the value of the map
        perfGuaranteeBool = false;
    }
    
}