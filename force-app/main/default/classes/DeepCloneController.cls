/* =================================================================================
 * @Class Name        : DeepCloneController
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 13/07/2018
 * @Purpose           : Deep Clone functionality
=======================================================================================*/
public without sharing class DeepCloneController {

    public id recordID=null;
    
    /*******Static Variable containing Object and Fields Name**********/
    
    static final String CENTRAL_HUB = 'Central_Hub__c'; 
    static final String ID_FIELD = 'Id';
    static final String BILLINGOPS='Billing_Operations__c';
    static final String BILLINGADMIN='Billing_Administrative_Fees__c';
    static final String BILLINANCILLARY='Billing_Ancillary_Fee__c';
    static final String BILLINGBROKERTPA='Billing_Broker_TPA_Payments__c';
    static final String BILLINGOTHERPAYMENT='Contractual_Payments__c';
    static final String MEDICAREPART='Medicare_Part_D_Fees_Schedule__c';
    static final String NETWORKOPS='Network_Operations__c';
    static final String NETWORKPRICINGOPS='Network_Pricing__c';
    static final String FAF='FAF_ID__c';
    static final String NETWORKGURANTEE='Retail_Network_Guarantees__c';
    static final String NETWORKPRICINGOPSFIELD='FAF_Network_Ops__c';
    static final String MAILOPERATION='Mail_Operations__c';
    static final String MAILPRICING='Mail_Pricing__c';
    static final String REBATEOPERATION='Rebate_Operations__c';
    static final String REBATEGURANTEE='Rebate_Guarantees__c';
    static final String REBATECARVEOUT='Rebate_Gtees_Specialty_Class_Carve_Outs__c';
    static final String GUARNTEE='Guarantees_Information__c';
    static final String GDR_GUARNTEE='GDR_Guarantee__c';
    static final String TRNDGUARNTEE='Trend_Guarantee__c';
    static final String ASPGUARNTEE='Gnc_Guarantee__c'; 
    static final String CLINICAL='Clinical_Operations__c';
    static final String CLINICALSOL='Clinical_Solutions__c';
    static final String SECIALOPS='Specialty_Operations__c';
    static final String SECIALPRICING='Specialty_Pricing__c';
    static final String SECDRUGPRICING='Specialty_Drug_Level_Pricing__c';
    static final String SECLEGACYPRICING='Specialty_Legacy_Drug_Level_pricing__c';
    static final String MAILPRICINGFIELD='FAF_Mail_Operations__c';
    static final String GRADGAURANTEEFIELD='Guarantee_Information__c';
    static final String SPECIALTYLEGACYOPS='Specialty_Ops__c';
    static final String CLIENTINFO='Client_Information__c'; 
    static final String PlATFORMSPECIFIC='Platform_Specifics__c';
    static final String PlATFORMSPECIFICFIELD='FAF_Client_Information__c';
    static final String FAFINSTRUCTION='FAF_Instructions__c';
    static final String LEGALINFO='Legal_Information__c';
    static final String STRFAFLINKS='FAF_Link__c';
    static final String PARTIALFAFLINKSFIELD1='Partial_FAF__c';
    static final String FULLFAFLINKSFIELD2='Full_FAF__c';
    static final String TRANSACTIONFEE='Transaction_Fee_Sharing_Tier__c';
    static final String SPECIALITYGURANTEE='Specialty_Guarantee__c';
     static final String MAILGURANTEE='Mail_Guarantees__c';
    
    /******** Static Variable for FAF Type********/
    
    static final String FULLFAF='Full';
    static final String FULLRETAILMAIL='Full - Retail and Mail Only';
    static final String FULLRETAILSPECIALTY='Full - Retail and Specialty Only';
    static final String FULLMAILSPECIALTY='Full - Mail and Specialty Only';
    static final String FULLMAILONLY='Full - Mail Only';
    static final String FULLRETAILONLY='Full - Retail Only';
    static final String FULLSPECIALTYONLY='Full - Specialty Only';
    static final String PARTIALONLY='Partial';
    static final String PROFILENAME='Apttus Underwriting';
    static final String ERRORMESSAGE='Account Name and Opportunity Name are required.';
    
    /******Visualforce page variables*********/
    
    public string searchCategory{get;set;}
    public Boolean CentralHub{get;set;}
    public Boolean FAFInstructions{get;set;}
    public Boolean FAFLinks{get;set;}
    public Boolean ClientInformation{get;set;}
    public Boolean PlatformSpecifics{get;set;}
    public Boolean LegalInformation{get;set;}
    public Boolean NetworkOperations{get;set;}
    public Boolean MailOperations{get;set;}
    public Boolean SpecialtyOperations{get;set;}
    public Boolean BillingOperations{get;set;}
    public Boolean RebateOperations{get;set;}
    public Boolean ClinicalOperations{get;set;}
    public Boolean GuaranteeInformation{get;set;}  
    Central_Hub__c fafObj=null;
    public List<SelectOption> AccountType { get; set; }
    public String AccountValue { get; set; }
    public List<SelectOption> OpportunityType { get; set; }
    public String OpportunityValue{ get; set; }
    public String BooleanRadioButton1{ get; set; }
    public String BooleanRadioButton2{ get; set; }
    public boolean DiabledBool{ get; set; }
    public Central_Hub__c fafextensionobj {get;set;}
    public Central_Hub__c fafObjConstructor{get;set;}
    
    /*******Check Box varibale**************/
    
    public boolean billBool{ get; set; }
    public boolean rebatBool{ get; set; }
    public boolean guarBool{ get; set; }
    public boolean specBool{ get; set; }
    public boolean mailBool{ get; set; }
    public boolean cilnicalBool{ get; set; }
    public boolean fafiBool{ get; set; }
    public boolean DiabledInput{ get; set; }
    public boolean networkBool{ get; set; }
    public boolean plaformBool{ get; set; }
    public boolean plaformExcludeBool{ get; set; }
    public boolean ShowPopup{ get; set; }
    public boolean faflinkBool{ get; set; }
    public boolean PlatformBoolOnchange{ get; set; }
    public Boolean BackgroundCopyBool{get;set;}      
    public boolean boolClient=false;
    public integer Thresholdcopy =0;
    
    
    /******picklistvalue*********/
    
     private  String strFAFTYpe;
     
    /* =================================================================================
    * @Method Name       : DeepCloneController
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Last modified by  : Mohit Srivastava(Accenture)
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public DeepCloneController() {
        searchCategory='YES';
        PlatformBoolOnchange = false;
        ShowPopup=false;
    }
    /* =================================================================================
    * @Method Name       : enablePicklist
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Last modified by  : Mohit Srivastava(Accenture)
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public void enablePicklist() {
    string Condition='true';
    string Condition1='false';
        if(searchCategory=='NO'){
            DiabledInput=true;
            BackgroundCopyBool=false;
            DiabledBool=false;
            fafiBool=true;
            FAFInstructions=false;
            FAFLinks=false;
            plaformBool=true;
            plaformExcludeBool = false;
            PlatformSpecifics=false;
            PlatformBoolOnchange=true;
            faflinkBool=true;
            enableObjectschkSecondOption();
            fafObjConstructor= new Central_Hub__c(); 
        }
        else{
            DiabledInput=false;
            DiabledBool=true;
            enableObjectschk();
            AccountValue=null;
            OpportunityValue=null;
            
            
        }
    }
   /* =================================================================================
    * @Method Name       : DeepCloneController(Constructor)
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public DeepCloneController(ApexPages.StandardController controller) {
        recordId =ApexPages.currentPage().getParameters().get('Id');
        PlatformBoolOnchange = false; 
        searchCategory='YES';
        DiabledBool=true;
        DiabledInput=false;
        fafObjConstructor= new Central_Hub__c(); 
        this.fafObj=(Central_Hub__c) controller.getRecord();
        fafextensionobj=[select id,Name,Opportunity_Name__c,Account_Name__c,Source_Copy_FAF_Status__c,FAF_Status__c from Central_Hub__c where id=:recordId ];
        enableObjectschk();
    }
    /* =================================================================================
    * @Method Name       : cloneFafrecord
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public PageReference cloneFafrecord(){
    
    DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER =false;
    Central_Hub__c cloneQS = null;
if (!BackgroundCopyBool || Label.Background_Copy != 'True'){        
        if(searchCategory=='NO'&& (string.isBlank(OpportunityValue)|| string.isBlank(AccountValue)))
        {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,ERRORMESSAGE));
                //return null;
        }
        ShowPopup=false;
        String resetValue;
        Boolean resetBool;
        ID fafcloneID;
        SObject cloneSObj1=DeepCloneUtility.getSObjectRecords(CENTRAL_HUB,ID_FIELD, new Set<Id>{recordId}, null, null)[0];
        SObject  cloneSObj=cloneSObj1 .clone(false,false);
       // if()
        
        Map<String, Schema.SObjectField> fieldMap =  DeepCloneUtility.getSObjectFieldSet(CENTRAL_HUB);
        Map<String, String> fieldsToReset = new Map<String, String>();
        if(searchCategory=='NO'){
            List<FAFDeepClone__c> fafcustObj =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:CENTRAL_HUB and Selection__c=true];
            for(FAFDeepClone__c fbobj:fafcustObj){
                     fieldsToReset.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
        }
        else{
        List<FAFDeepClone__c> fafcustObj =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:CENTRAL_HUB and Selection__c=false];
            for(FAFDeepClone__c fbobj:fafcustObj){
                     fieldsToReset.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
        }
        // resets the field value
            for (String fieldName: fieldsToReset.keySet()) {
                 if (fieldMap.containsKey(fieldName)) {
                        resetValue = fieldsToReset.get(fieldName);
                        if(resetValue=='FALSE'){
                        resetBool=false;
                        cloneSObj.put(fieldName, resetBool); 
                        }
                        else if(resetValue=='Null'){
                        resetValue=Null;
                        cloneSObj.put(fieldName, resetValue); 
                        }
                        else{
                        cloneSObj.put(fieldName, resetValue); 
                        
                        }
                    }
            }
 //           Central_Hub__c cloneQS=(Central_Hub__c)cloneSObj;
            cloneQS=(Central_Hub__c)cloneSObj;
            if(searchCategory=='NO'){
                List<Account> acc=[Select id,iUMS_Client_Subtype__c,Market_Segment__c from Account where id=:AccountValue limit 1];
                   if(acc.size()>0 ){
                    cloneQS.Account_Name__c=acc[0].id;
                    cloneQS.Opportunity_Name__c=OpportunityValue ;
                    cloneQS.Segment__c=acc[0].Market_Segment__c;
                    if(acc[0].iUMS_Client_Subtype__c!='Coalition Member'
                             &&acc[0].iUMS_Client_Subtype__c!='TPA Member'
                                && acc[0].iUMS_Client_Subtype__c!='Health Plan Member'){
                                boolClient=true;
                    }
                 }
            }
            if(searchCategory=='NO'){
            cloneQs.Salesperson__c=null;
            }
            cloneQs.Clone_Flag__c=true;
            cloneQs.FAF_Status__c='Draft';
            
            
            /*****Assigning Logged in user UnderWritter ID**************/
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name; 
            if(profileName=='Apttus Underwriting'){
            cloneQs.Underwriter__c=UserInfo.getUserId();
            }
            cloneQs.Clone_Source_FAF_ID__c=fafextensionobj.Name;
            cloneQs.FAF_Copy_In_Progress__c = true; // Identify during Copy FAF and exclude validation
            cloneQs.Source_Copy_FAF_Status__c= fafextensionobj.FAF_Status__c; // Identify during Copy FAF and exclude validation
            if (NetworkOperations == True && SpecialtyOperations == True && MailOperations == true) {
                strFAFTYpe=FULLFAF;
            }
            if (NetworkOperations == True && MailOperations == True && (SpecialtyOperations == False||SpecialtyOperations==null )) {
                strFAFTYpe=FULLRETAILMAIL;
            }
            if (NetworkOperations == True && (MailOperations == False||MailOperations == null) && SpecialtyOperations == True) {
               strFAFTYpe =FULLRETAILSPECIALTY;
            }
            if ((NetworkOperations == False|| NetworkOperations == null) && MailOperations == True && SpecialtyOperations == True) {
                strFAFTYpe=FULLMAILSPECIALTY;
            }
            if ((NetworkOperations == False|| NetworkOperations == null) && MailOperations == True && (SpecialtyOperations == False||SpecialtyOperations==null )) {
                strFAFTYpe =FULLMAILONLY;
            }
            if (NetworkOperations == True && (MailOperations == False||MailOperations ==null) && (SpecialtyOperations == False||SpecialtyOperations==null )) {
                strFAFTYpe =FULLRETAILONLY;
            }
            if ((NetworkOperations == False|| NetworkOperations==null)&& (MailOperations == False ||MailOperations ==null) && SpecialtyOperations == True) {
                strFAFTYpe=FULLSPECIALTYONLY;
            }
            if ( (NetworkOperations == False ||NetworkOperations ==null) 
                    && (MailOperations == False ||MailOperations == null) 
                            && (SpecialtyOperations == False ||SpecialtyOperations == null) 
                                &&(BillingOperations==True || RebateOperations == True || 
                                    ClinicalOperations == True || GuaranteeInformation == True)) {
                  strFAFTYpe=PARTIALONLY;
                }
            if (NetworkOperations == False && MailOperations == False && SpecialtyOperations == False && 
                            BillingOperations == False && RebateOperations == False &&  
                                               ClinicalOperations == False && GuaranteeInformation == False ) {
                   strFAFTYpe = null;
                }
            cloneQs.FAF_Type__c =strFAFTYpe;
            if(NetworkOperations!=null){
            cloneQs.Network_Operations__c=NetworkOperations;
            }
            if(MailOperations!=null){
            cloneQs.Mail_Operations__c=MailOperations;
            }
            if(ClinicalOperations!=null){
            cloneQs.Clinical_Operations__c=ClinicalOperations;
            }
            if(SpecialtyOperations!=null){
            cloneQs.Specialty_Operations__c=SpecialtyOperations;
            }
            if(BillingOperations!=null){
            cloneQs.Billing_Operations__c=BillingOperations;    
            }
            if(GuaranteeInformation!=null){
            cloneQs.Guarantee_Information__c=GuaranteeInformation;
            }
            try{
            Insert cloneQs;                      
            }
            catch(Exception ex){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,ex.getDMLMessage(0)));
                //return null;
            }
            fafcloneID=cloneQS.ID;
            
         Map<Id, SObject> quoteStrategies = new Map<Id, SObject>{recordId => Schema.getGlobalDescribe().get(CENTRAL_HUB).newSObject(cloneSObj.id)};
        
       /* =================================================================================
                Billing Operations ad all his child 
        =======================================================================================*/
        if(BillingOperations==true){ 
        List<FAFDeepClone__c> BillingOppsSeting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c 
                                                 where sObjectType__c=:BILLINGOPS 
                                                 OR sObjectType__c=:BILLINGADMIN 
                                                 OR sObjectType__c=:BILLINANCILLARY
                                                 OR sObjectType__c=:BILLINGBROKERTPA
                                                 OR sObjectType__c=:MEDICAREPART
                                                 OR sObjectType__c=:BILLINGOTHERPAYMENT
                                                 ];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
        Map<String, String> fieldsToResetChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild2 = new Map<String, String>();
         Map<String, String> fieldsToResetGrandChild3 = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild4 = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild5 = new Map<String, String>();
         Map<String, String> fieldsToResetBillingOtherPayment = new Map<String, String>();
        if(searchCategory=='NO'){
            List<FAFDeepClone__c> BillingOppsSettingData =[Select FieldName__c,sObjectType__c,Field_Value__c 
                                                           from FAFDeepClone__c 
                                                           where (sObjectType__c=:BILLINGBROKERTPA  
                                                           or sObjectType__c=:BILLINGOTHERPAYMENT) and Selection__c=true];
            
                for(FAFDeepClone__c fbobj:BillingOppsSettingData ){
                    if(fbobj.sObjectType__c==BILLINGBROKERTPA){
                        fieldsToResetGrandChild3.put(fbobj.FieldName__c,fbobj.Field_Value__c);
                    }
                    if(fbobj.sObjectType__c==BILLINGOTHERPAYMENT){
                        fieldsToResetBillingOtherPayment.put(fbobj.FieldName__c,fbobj.Field_Value__c);
                    }
                }
        }
        else{
            List<FAFDeepClone__c> BillingOppsSettingData =[Select FieldName__c,sObjectType__c,Field_Value__c 
                                                           from FAFDeepClone__c 
                                                           where (/*sObjectType__c=:BILLINGBROKERTPA 
                                                           or*/ sObjectType__c=:BILLINGOTHERPAYMENT) and Selection__c=false];
            for(FAFDeepClone__c fbobj:BillingOppsSeting){
            
                if(fbobj.sObjectType__c==BILLINGBROKERTPA){
                    fieldsToResetGrandChild3.put(fbobj.FieldName__c,fbobj.Field_Value__c);
                }
            }
            for(FAFDeepClone__c fbobj:BillingOppsSettingData){
            
                if(fbobj.sObjectType__c==BILLINGOTHERPAYMENT){
                        fieldsToResetBillingOtherPayment.put(fbobj.FieldName__c,fbobj.Field_Value__c);
                }
            }
        }
       
        for(FAFDeepClone__c fbobj:BillingOppsSeting){
        
           if(fbobj.sObjectType__c==BILLINGOPS){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==BILLINGADMIN){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==BILLINANCILLARY){
            fieldsToResetGrandChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==MEDICAREPART){
           fieldsToResetGrandChild5.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
        }
        //Billing Operation 
         Map<Id, SObject> Billing = DeepCloneUtility.cloneRelatedSObject(BILLINGOPS,FAF, quoteStrategies, null, fieldsToReset1,'test');
        
        //Billind Admin
         Map<Id, SObject> BillingAdmin = DeepCloneUtility.cloneRelatedSObject(BILLINGADMIN,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    BILLINGOPS=>DeepCloneUtility.getSObjectIds(Billing)
                                                                                }, 
                                                                               null,fieldsToResetChild,'test');
                                                                               
        //Billing Ancilliary
         Map<Id, SObject> BillingAncilliary = DeepCloneUtility.cloneRelatedSObject(BILLINANCILLARY,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    BILLINGOPS=>DeepCloneUtility.getSObjectIds(Billing)
                                                                                }, 
                                                                               null,fieldsToResetGrandChild2,'test');
                                                                               
                                                                               
        //Billing broker tpa
         Map<Id, SObject> BrokerTPA = DeepCloneUtility.cloneRelatedSObject(BILLINGBROKERTPA,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    BILLINGOPS=>DeepCloneUtility.getSObjectIds(Billing)
                                                                                }, 
                                                                               null,fieldsToResetGrandChild3,'test');
                                                                               
        //Billing other payment
         Map<Id, SObject> BrokerOtherPayment= DeepCloneUtility.cloneRelatedSObject(BILLINGOTHERPAYMENT,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    BILLINGOPS=>DeepCloneUtility.getSObjectIds(Billing)
                                                                                }, 
                                                                               null,fieldsToResetBillingOtherPayment,'test');
        
         //Billing Medicare_Part_D_Fees_Schedule__c
         Map<Id, SObject> medicarepartObj= DeepCloneUtility.cloneRelatedSObject(MEDICAREPART,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    BILLINGOPS=>DeepCloneUtility.getSObjectIds(Billing)
                                                                                }, 
                                                                               null,fieldsToResetGrandChild5,'test');
        }
        
         /* =================================================================================
                                 Network Operations and all his child 
        =======================================================================================*/
        if(NetworkOperations==true){
        
        List<FAFDeepClone__c> NetworkoppsSeting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c 
                                                 where sObjectType__c=:NETWORKPRICINGOPS 
                                                 OR sObjectType__c=:NETWORKGURANTEE OR sObjectType__c=:NETWORKOPS];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
        Map<String, String> fieldsToResetChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild1 = new Map<String, String>();
        for(FAFDeepClone__c fbobj:NetworkoppsSeting){
           if(fbobj.sObjectType__c==NETWORKOPS){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==NETWORKPRICINGOPS){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
            if(fbobj.sObjectType__c==NETWORKGURANTEE){
           fieldsToResetGrandChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==TRANSACTIONFEE){
           fieldsToResetGrandChild1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
        }
        
        //Network Operations
        Map<Id, SObject> networkobj = DeepCloneUtility.cloneRelatedSObject(NETWORKOPS,FAF,quoteStrategies, null,fieldsToReset1,null);
        
        
    
         //Network Pricing
        Map<Id, SObject> networkpriceObj= DeepCloneUtility.cloneRelatedSObject(NETWORKPRICINGOPS,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    NETWORKPRICINGOPSFIELD=>DeepCloneUtility.getSObjectIds(networkobj)
                                                                                }, 
                                                                               null,fieldsToResetChild,null);
                                                                               
        //Network pricing Gurantee
        Map<Id, SObject> networkpriceGrObj= DeepCloneUtility.cloneRelatedSObject(NETWORKGURANTEE,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                NETWORKPRICINGOPS=>DeepCloneUtility.getSObjectIds(networkpriceObj)
                                                                                }, 
                                                                               null,fieldsToResetGrandChild,null);
          //Transaction Fee Sharing
        Map<Id, SObject> trafeesObj= DeepCloneUtility.cloneRelatedSObject(TRANSACTIONFEE,FAF, 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    NETWORKOPS=>DeepCloneUtility.getSObjectIds(networkobj)
                                                                                }, 
                                                                               null,fieldsToResetGrandChild1,null);                                                                    
        }
      /* =================================================================================
                                 Mail Operations and all his child 
        =======================================================================================*/
        if(MailOperations==true){
        List<FAFDeepClone__c> mailOpssetting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:MAILOPERATION OR sObjectType__c=:MAILPRICING OR sObjectType__c=:MAILGURANTEE];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
         Map<String, String> fieldsToResetChild = new Map<String, String>();
         Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        for(FAFDeepClone__c fbobj:mailOpssetting){
           if(fbobj.sObjectType__c=='Mail_Operations__c'){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c=='Mail_Pricing__c'){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
            if(fbobj.sObjectType__c=='Mail_Guarantees__c'){
           fieldsToResetGrandChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
        }
        //Mail Operation
        
        Map<Id, SObject> MailoperationObj = DeepCloneUtility.cloneRelatedSObject(MAILOPERATION,FAF, quoteStrategies, null, fieldsToReset1,null);
        //Mail Pricing
        
        Map<Id, SObject> mailpriceObj= DeepCloneUtility.cloneRelatedSObject(MAILPRICING,FAF, 
                                                                                 new Map<String, Map<Id, Id>> {
                                                                                 FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                 MAILPRICINGFIELD=>DeepCloneUtility.getSObjectIds(MailoperationObj)
                                                                                 }, 
                                                                                 null,fieldsToResetChild,null);
      
        //Mail Gurantee
        Map<Id, SObject> MailObjGurantee= DeepCloneUtility.cloneRelatedSObject(MAILGURANTEE,FAF, 
                                                                                    new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    MAILPRICING=>DeepCloneUtility.getSObjectIds(mailpriceObj)
                                                                                    }, null,fieldsToResetGrandChild,null);                               
        
          }
         /* =================================================================================
                                Rebate Operations and all his child and Grand Child
            =======================================================================================*/
           
        if(RebateOperations==true){
        
        List<FAFDeepClone__c> RebateoppsSeting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c 
                                                 where sObjectType__c=:REBATEOPERATION 
                                                 OR sObjectType__c=:REBATEGURANTEE OR sObjectType__c=:REBATECARVEOUT];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
         Map<String, String> fieldsToResetChild = new Map<String, String>();
         Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        for(FAFDeepClone__c fbobj:RebateoppsSeting){
           if(fbobj.sObjectType__c==REBATEOPERATION){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==REBATEGURANTEE){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
            if(fbobj.sObjectType__c==REBATECARVEOUT){
           fieldsToResetGrandChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
        }
        //Rebate Operation
        Map<Id, SObject> RebateoperationObj = DeepCloneUtility.cloneRelatedSObject(REBATEOPERATION,FAF, quoteStrategies, null, fieldsToReset1,null);
        
        //Rebate Gurantee
        Map<Id, SObject> rebateGuranteeGrObj= DeepCloneUtility.cloneRelatedSObject(REBATEGURANTEE,FAF, 
                                                                                 new Map<String, Map<Id, Id>> {
                                                                                 FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                 REBATEOPERATION=>DeepCloneUtility.getSObjectIds(RebateoperationObj)
                                                                                 }, 
                                                                                 null,fieldsToResetChild,null);
        
        //Rebate Carveout
        Map<Id, SObject> retbatecaveoutGrObj= DeepCloneUtility.cloneRelatedSObject(REBATECARVEOUT,FAF, 
                                                                                 new Map<String, Map<Id, Id>> {
                                                                                 FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                 REBATEOPERATION=>DeepCloneUtility.getSObjectIds(RebateoperationObj)
                                                                                 }, 
                                                                                 null,fieldsToResetGrandChild,null);
        }
         /* =================================================================================
                               Guranteee Information  and all his child and Grand Child
            =======================================================================================*/                                                                     
        if(GuaranteeInformation==true){
        
        List<FAFDeepClone__c> RebateoppsSeting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c 
                                                 where sObjectType__c=:GUARNTEE 
                                                 OR sObjectType__c=:TRNDGUARNTEE OR sObjectType__c=:ASPGUARNTEE];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
        Map<String, String> fieldsToResetChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild2 = new Map<String, String>();
        for(FAFDeepClone__c fbobj:RebateoppsSeting){
           if(fbobj.sObjectType__c==GUARNTEE){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==TRNDGUARNTEE){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
            if(fbobj.sObjectType__c==ASPGUARNTEE){
           fieldsToResetGrandChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
            if(fbobj.sObjectType__c==GDR_GUARNTEE){
           fieldsToResetGrandChild2.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
        }
            
        //Gurantee  
        Map<Id, SObject> GuranteeObj = DeepCloneUtility.cloneRelatedSObject(GUARNTEE,FAF,quoteStrategies, null,fieldsToReset1,null);
        
       //GDR Gurantee
        Map<Id, SObject> GradGuranteeObj= DeepCloneUtility.cloneRelatedSObject(GDR_GUARNTEE,FAF, 
                                                                                    new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    GRADGAURANTEEFIELD=>DeepCloneUtility.getSObjectIds(GuranteeObj)
                                                                                    }, 
                                                                                    null,fieldsToResetGrandChild2,null); 
        //TRND Gurantee
        Map<Id, SObject> trendGuranteeObj= DeepCloneUtility.cloneRelatedSObject(TRNDGUARNTEE,FAF, 
                                                                                    new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    GRADGAURANTEEFIELD=>DeepCloneUtility.getSObjectIds(GuranteeObj)
                                                                                    }, 
                                                                                    null,fieldsToResetChild,null);
        //ASP Gurantee
        Map<Id, SObject> aspGuranteeObj= DeepCloneUtility.cloneRelatedSObject(ASPGUARNTEE,FAF, 
                                                                                    new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    GRADGAURANTEEFIELD=>DeepCloneUtility.getSObjectIds(GuranteeObj)
                                                                                    }, 
                                                                                    null,fieldsToResetGrandChild,null); 
        }
        
         /* =================================================================================
                               Clinical Operations and all his child and Grand Child
            =======================================================================================*/ 
        
        if(ClinicalOperations==true){
        
        List<FAFDeepClone__c> customOppsSeting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c 
                                                 where sObjectType__c=:CLINICAL 
                                                 OR sObjectType__c=:CLINICALSOL ];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
        Map<String, String> fieldsToResetChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        for(FAFDeepClone__c fbobj:customOppsSeting){
           if(fbobj.sObjectType__c==CLINICAL){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==CLINICALSOL){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
        }
        
        // clinical
        Map<Id, SObject>  clinicalObj = DeepCloneUtility.cloneRelatedSObject(CLINICAL,FAF,quoteStrategies, null, fieldsToReset1,null); 
  
        //Clinical sol
        Map<Id, SObject> cliniclsolObj= DeepCloneUtility.cloneRelatedSObject(CLINICALSOL,FAF, 
                                                                              new Map<String, Map<Id, Id>> {
                                                                              FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                              CLINICAL=>DeepCloneUtility.getSObjectIds(clinicalObj)
       
                                                                     }, null,fieldsToResetChild,null); 
                                                                     
        }
          /* =================================================================================
                               Speciality Operations and all his child and Grand Child
            =======================================================================================*/ 
        
         if(SpecialtyOperations==true){
         
         
        List<FAFDeepClone__c> customOppsSeting =[Select FieldName__c,sObjectType__c,Field_Value__c from FAFDeepClone__c 
                                                 where sObjectType__c=:SECIALOPS 
                                                 OR sObjectType__c=:SECIALPRICING OR sObjectType__c=:SECDRUGPRICING 
                                                 OR sObjectType__c=:SECLEGACYPRICING];
        Map<String, String> fieldsToReset1 = new Map<String, String>();
        Map<String, String> fieldsToResetChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
        Map<String, String> fieldsToResetGrandChild2 = new Map<String, String>();
        Map<String, String> fieldsToResetGurantee = new Map<String, String>();
        
        for(FAFDeepClone__c fbobj:customOppsSeting){
           if(fbobj.sObjectType__c==SECIALOPS){
           fieldsToReset1.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==SECIALPRICING){
           fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==SECDRUGPRICING){
           fieldsToResetGrandChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           if(fbobj.sObjectType__c==SPECIALITYGURANTEE){
           fieldsToResetGurantee.put(fbobj.FieldName__c,fbobj.Field_Value__c);
           }
           
        }   
         // Speciality
        Map<Id, SObject>  specialObj = DeepCloneUtility.cloneRelatedSObject(SECIALOPS,FAF,quoteStrategies, null, fieldsToReset1,null);

         //Speciality Pricing
        Map<Id, SObject> specpriceObj= DeepCloneUtility.cloneRelatedSObject(SECIALPRICING,FAF, 
                                                                            new Map<String, Map<Id, Id>> {
                                                                            FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                            SECIALOPS=>DeepCloneUtility.getSObjectIds(specialObj)
                                                                            }, null,fieldsToResetChild,null);
        //Speciality Pricing Gurantee
        Map<Id, SObject> specpriceObjGurantee= DeepCloneUtility.cloneRelatedSObject(SPECIALITYGURANTEE,FAF, 
                                                                                    new Map<String, Map<Id, Id>> {
                                                                                    FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                    SECIALPRICING=>DeepCloneUtility.getSObjectIds(specpriceObj)
                                                                                    }, null,fieldsToResetGurantee,null);                                                                            
                                                                         
        //Speciality DRug LevelPricing
        Map<Id, SObject> specdrugObj= DeepCloneUtility.cloneRelatedSObject(SECDRUGPRICING,FAF, 
                                                                            new Map<String, Map<Id, Id>> {
                                                                            FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                            SECIALOPS=>DeepCloneUtility.getSObjectIds(specialObj)
                                                                            }, 
                                                                            null,fieldsToResetGrandChild,null); 
                                                                            
        //Speciality DRug LevelPricing
        Map<Id, SObject> speclegacyOBJ= DeepCloneUtility.cloneRelatedSObject(SECLEGACYPRICING,FAF, 
                                                                            new Map<String, Map<Id, Id>> {
                                                                            FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                            SPECIALTYLEGACYOPS=>DeepCloneUtility.getSObjectIds(specialObj)
                                                                            }, 
                                                                            null,fieldsToResetGrandChild2,null);  
        } 
        /* =================================================================================
                               Client Information and Platform Specifics
            =======================================================================================*/ 
         Map<String, String> fieldsToResetChild= new Map<String, String>();
        
        if(searchCategory=='NO'){
            List<FAFDeepClone__c> billFieldOps1 =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:CLIENTINFO and Selection__c=true];
            
            for(FAFDeepClone__c fbobj:billFieldOps1){
               fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
            if(boolClient==true){
            fieldsToResetChild.put('Master_Client_Name__c',null);
            }
        }
        else{
            List<FAFDeepClone__c> billFieldOps1 =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:CLIENTINFO and Selection__c=false];
            
            for(FAFDeepClone__c fbobj:billFieldOps1){
               fieldsToResetChild.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
        }
        Client_Information__c clientInfoObjects;
         Map<Id, SObject>  ClientInfoObj= DeepCloneUtility.cloneRelatedSObject(CLIENTINFO,FAF, quoteStrategies, null,fieldsToResetChild,null);
        if(ClientInfoObj.size()>0){
         clientInfoObjects=(Client_Information__c)ClientInfoObj.values()[0]; 
            if(clientInfoObjects.id!=null){
                clientInfoObjects.IsValid__c=false;
                clientInfoObjects.ReleaseFromCI__c=false;
                //Update clientInfoObjects;
             }
        }
       
        //platform specific
        if(searchCategory=='YES' && PlatformSpecifics==true){
            List<FAFDeepClone__c> billFieldOps2=new List<FAFDeepClone__c>();
            billFieldOps2=[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:PlATFORMSPECIFIC];
             Map<String, String> fieldsToResetplatform = new Map<String, String>();
             
            for(FAFDeepClone__c fbobj:billFieldOps2){
               fieldsToResetplatform.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
            List<SObject>  sObjectList=new List<SObject>();
            List<Platform_Specifics__c>  platformList=new List<Platform_Specifics__c>();
            List<Platform_Specifics__c>  platformListUpdate=new List<Platform_Specifics__c>();
            Map<Id, SObject> platformObj= DeepCloneUtility.cloneRelatedSObject(PlATFORMSPECIFIC,FAF, 
                                                                                 new Map<String, Map<Id, Id>> {
                                                                                 FAF=> new Map<Id, Id>{recordId=> cloneQS.id},
                                                                                 PlATFORMSPECIFICFIELD=>DeepCloneUtility.getSObjectIds(ClientInfoObj)
                                                                                 }, 
                                                                                null,fieldsToResetplatform,null);
           
        }
                                    
      
       /* =================================================================================
                                            FAF Instruction
        =======================================================================================*/
        //FAF INSTRUCTION
        if(FAFInstructions==true){
        
            List<FAFDeepClone__c> fafinstructionOps1 =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:FAFINSTRUCTION];
            Map<String, String> fieldsToResetfaf= new Map<String, String>();
            for(FAFDeepClone__c fbobj:fafinstructionOps1){
                fieldsToResetfaf.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
        
        Map<Id, SObject>  fafinstructionObj = DeepCloneUtility.cloneRelatedSObject(FAFINSTRUCTION,FAF, quoteStrategies, null, fieldsToResetfaf,null);
        }
         
       /* =================================================================================
                                             Legal Information
        =======================================================================================*/
        List<FAFDeepClone__c> fafinstructionOps1 =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:LEGALINFO];
            Map<String, String> fieldsToResetLegal= new Map<String, String>();
            for(FAFDeepClone__c fbobj:fafinstructionOps1){
                fieldsToResetLegal.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }
        Map<Id, SObject>  ClientInfoObj1 = DeepCloneUtility.cloneRelatedSObject(LEGALINFO,FAF, quoteStrategies, null,fieldsToResetLegal,null);
        
        
      /* =================================================================================
                                            FAF Links
        =======================================================================================*/
         
        if(FAFLinks==true){
        List<FAFDeepClone__c> fafLinks =[Select FieldName__c,Field_Value__c from FAFDeepClone__c where sObjectType__c=:STRFAFLINKS];
            Map<String, String> fieldsToResetFaflinks= new Map<String, String>();
            for(FAFDeepClone__c fbobj:fafLinks){
                fieldsToResetFaflinks.put(fbobj.FieldName__c,fbobj.Field_Value__c);
            }       
         Map<Id, SObject> FAFLINKSObj= DeepCloneUtility.cloneRelatedSObject(STRFAFLINKS,FULLFAFLINKSFIELD2, quoteStrategies, null, fieldsToResetFaflinks,null); 
         Map<Id, SObject>  FAFLINKSObj1 = DeepCloneUtility.cloneRelatedSObject(STRFAFLINKS,PARTIALFAFLINKSFIELD1, quoteStrategies, null, fieldsToResetFaflinks,null);         
        }
        if(clientInfoObjects!=null){
        cloneQS.Client_Info__c=clientInfoObjects.id; 
        }
        cloneQs.FAF_Copy_In_Progress__c = false; // Update to False after completion of copy process
        update cloneQS;
        FAFTriggerAccessHelper.shareFAFRecord(cloneQS);
        return new PageReference('/'+cloneQS.ID);
    }
    else{
        ShowPopup=true;
         return null;
    }
        
 } 

     /* =================================================================================
         * @Method Name       : BackGroundCopyRequest
         * @author            : Mohit Srivastava
         * @created date      : 20/09/2019
         * @Purpose           : BackGroundCopyRequest
        =======================================================================================*/
        public PageReference BackGroundCopyRequest(){
          if (Label.Background_Copy == 'True' && BackgroundCopyBool == true) {
              system.debug('Copying++++++++++++++');
            //ShowPopup=true;
            if (BillingOperations == null) 
                BillingOperations=false;
            if (ClinicalOperations== null) 
                ClinicalOperations=false;
            if (GuaranteeInformation== null) 
                GuaranteeInformation=false;
            if (FAFInstructions== null) 
                FAFInstructions=false;
            if (FAFLinks== null) 
                FAFLinks=false;
            if (MailOperations== null) 
                MailOperations=false;
            if (NetworkOperations== null) 
                NetworkOperations=false;
            if (PlatformSpecifics== null) 
                PlatformSpecifics=false;
            if (RebateOperations== null) 
                RebateOperations=false;
            if (SpecialtyOperations== null) 
                SpecialtyOperations=false;
                                                                                                                                  
            List<FAF_Copy_Request__c> FAFCopy = new List<FAF_Copy_Request__c>();                           
            FAF_Copy_Request__c cp = new FAF_Copy_Request__c();               
            cp.Billing_Operations__c    = BillingOperations;
            cp.Client_Information__c = true;
            cp.Clinical_Operations__c = ClinicalOperations;
            cp.Guarantee_Information__c = GuaranteeInformation;
            cp.FAF_Instructions__c = FAFInstructions;
            cp.Legal_Information__c= true;
            cp.FAF_Links__c = FAFLinks;
            cp.Mail_Operations__c = MailOperations;
            cp.Network_Operations__c = NetworkOperations;
            cp.Platform_Specifics__c= PlatformSpecifics;
            cp.Rebate_Operations__c= RebateOperations;
            cp.Specialty_Operations__c= SpecialtyOperations;
            cp.Account__c= AccountValue ;
            cp.Opportunity__c= OpportunityValue ;                        
            cp.FAF__c= recordId;
            cp.Status__c = 'Pending';  
            
            FAFCopy.add(cp);
            insert FAFCopy;
            
             //return new PageReference('/lightning/r/'+recordId+'/related/FAF_Copy_Request__r/view?0.source=alohaHeader');
             return new PageReference('/lightning/r/'+recordId+'/related/FAF_Copy_Request__r/view');
        }   
            
        return null;
        }
    
        /* =================================================================================
         * @Method Name       : enableObjectschk
         * @author            : Mohit Srivastava(Accenture)
         * @created date      : 13/07/2018
         * @Purpose           : Deep Clone functionality
        =======================================================================================*/
        public void enableObjectschk(){
            
            BackgroundCopyBool=false;
            List<Billing_Operations__c> billchkObj=[Select ID from Billing_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(billchkObj.size()>0){
              billBool=false;
             
                   BillingOperations=true;
              
            }
            else{
            billBool=true;
            }
            List<Network_Operations__c> networkchkObj=[Select ID from Network_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(networkchkObj.size()>0){
                networkBool=false;
                NetworkOperations=true;
            }
            else{
            networkBool=true;
            }
            List<Specialty_Operations__c> specObj=[Select ID from Specialty_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(specObj.size()>0){
              specBool=false;
              SpecialtyOperations=true;
            }
            else{
            specBool=true;
            }
            List<Mail_Operations__c> mailpos=[Select ID from Mail_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(mailpos.size()>0){
              mailBool=false;
              MailOperations=true;
            }
            else{
            mailBool=true;
            }
            List<Rebate_Operations__c> rebteObjs=[Select ID from Rebate_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(rebteObjs.size()>0){
              rebatBool=false;
              RebateOperations=true;
            }
            else{
            rebatBool=true;
            }
            List<Guarantees_Information__c> guarObjs=[Select ID from Guarantees_Information__c  where FAF_ID__c=:recordId limit 1];
            if(guarObjs.size()>0){
              guarBool=false;
              GuaranteeInformation=true;
            }
            else{
            guarBool=true;
            }
            List<Clinical_Operations__c> clicnicObj=[Select ID from Clinical_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(clicnicObj.size()>0){
              cilnicalBool=false;
              ClinicalOperations=true;
            }
            else{
            cilnicalBool=true;
            }
            List<FAF_Instructions__c> fafObj=[Select ID from  FAF_Instructions__c  where FAF_ID__c=:recordId limit 1];
            if(fafObj.size()>0){
              fafiBool=false;
              FAFInstructions=true;
            }
            else{
            fafiBool=true;
            }
            List<Platform_Specifics__c  > platformObje=[Select ID from  Platform_Specifics__c where FAF_ID__c=:recordId];
            if(platformObje.size()> Integer.valueof(Label.CopyFAFThreshold)){  // Change to FAF Copy Functionality 07/21
              plaformExcludeBool = true;
              plaformBool=true;
              PlatformSpecifics=false;
            }
            else if(platformObje.size()>0){
              plaformExcludeBool = false;
              plaformBool=false;
              PlatformSpecifics=true;
            }
            else{
              plaformBool=true;
              plaformExcludeBool = false;
            }
            
            List<FAF_Link__c> faflinkObje=[Select ID from  FAF_Link__c where Partial_FAF__c=:recordId  or FULL_FAF__c=:recordId];
            if(faflinkObje.size()>0){
              faflinkBool=false;
              FAFLinks=true;
            }
            else{
            faflinkBool=true;
            }
        } 
        /* =================================================================================
         * @Method Name       : enableObjectschkSecondOption
         * @author            : Mohit Srivastava(Accenture)
         * @created date      : 13/07/2018
         * @Purpose           : Deep Clone functionality
        =======================================================================================*/
        public void enableObjectschkSecondOption(){
            
            List<Billing_Operations__c> billchkObj=[Select ID from Billing_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(billchkObj.size()>0){
              billBool=false;
              
                   BillingOperations=true;
              
            }
            else{
            billBool=true;
            }
            List<Network_Operations__c> networkchkObj=[Select ID from Network_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(networkchkObj.size()>0){
              networkBool=false;
              NetworkOperations=true;
            }
            else{
            networkBool=true;
            }
            List<Specialty_Operations__c> specObj=[Select ID from Specialty_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(specObj.size()>0){
              specBool=false;
              SpecialtyOperations=true;
            }
            else{
            specBool=true;
            }
            List<Mail_Operations__c> mailpos=[Select ID from Mail_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(mailpos.size()>0){
              mailBool=false;
              MailOperations=true;
            }
            else{
            mailBool=true;
            }
            List<Rebate_Operations__c> rebteObjs=[Select ID from Rebate_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(rebteObjs.size()>0){
              rebatBool=false;
              RebateOperations=true;
            }
            else{
            rebatBool=true;
            }
            List<Guarantees_Information__c> guarObjs=[Select ID from Guarantees_Information__c  where FAF_ID__c=:recordId limit 1];
            if(guarObjs.size()>0){
              guarBool=false;
              GuaranteeInformation=true;
            }
            else{
            guarBool=true;
            }
            List<Clinical_Operations__c> clicnicObj=[Select ID from Clinical_Operations__c  where FAF_ID__c=:recordId limit 1];
            if(clicnicObj.size()>0){
              cilnicalBool=false;
              ClinicalOperations=true;
            }
            else{
            cilnicalBool=true;
            }
        } 
        /* =================================================================================
         * @Method Name       : Cancel
         * @author            : Mohit Srivastava(Accenture)
         * @created date      : 13/07/2018
         * @Purpose           : Deep Clone functionality
        =======================================================================================*/
        public PageReference Cancel(){
          return new PageReference('/'+recordId);
        }
}