//This controller is used to edit the Platform specific information

public with sharing class EditPlatFormSpecificController {

    public String clientInfoId {set;get;}
    public String recordId{set;get;}
    public String cInfoId{set;get;}
    public String clientSubType{set;get;}
    public Platform_Specifics__c platformSpecific {set;get;}
    public Client_Information__c  cInfo{set;get;} 
    public Specialty_Operations__c sOperations{set;get;}
    public Rebate_Operations__c rOperations{set;get;}
    public Specialty_Pricing__c sPricing{set;get;}   
    public String returnURL;
    public Boolean level1DRequired{get;set;}
    public Boolean effectiveDateRequired{get;set;}
    public Boolean termedDateRequired{get;set;}
    public Boolean clientChoice{get;set;}
    public Boolean rClientChoice{get;set;}
    public Boolean nsfeDateRequired{get;set;}
    public Boolean gstpDateRequired{get;set;}
    public Boolean sfeDateRequired{get;set;}
    public Boolean nsfSectionRequired{get;set;}
    public Boolean gstpSectionRequired{get;set;}
    public Boolean sfSectionRequired{get;set;}
    public Boolean dGSTPFormularyRequired{get;set;}
    public Boolean showTermflag{get;set;}
    public Boolean showTermed{get;set;}
    public Boolean hightlightBlock{get;set;}
    public Boolean SpecialtyPharmacyBenefitPriceList{get;set;}
    public list<SelectOption>  pharmacyBenefitChoiceValues{get;set;} 
    public list<SelectOption>  nonPharmacyBenefitChoiceValues{get;set;}  
    public list<SelectOption>  gstpChoiceValues{get;set;}
    public list<SelectOption>  splFormalityChoiceValues{get;set;}   
    public list<SelectOption>  splFormalityChoicePLValues{get;set;} 
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality   
    
    //single record constructor
    public EditPlatFormSpecificController(ApexPages.StandardController controller) {
        level1DRequired = false;
        rClientChoice = false;
        effectiveDateRequired = false;
        clientChoice = false;
        nsfeDateRequired = false;
        gstpDateRequired = false;
        sfeDateRequired = false;
        termedDateRequired = false;
        nsfSectionRequired = false;
        gstpSectionRequired = false;
        sfSectionRequired = false;
        dGSTPFormularyRequired = false;
          SpecialtyPharmacyBenefitPriceList = false;
        hightlightBlock = false;
        showTermflag = false;
        showTermed = false;
        recordId = controller.getId();
        returnURL = ApexPages.currentPage().getParameters().get('retURL');
        cInfoId = ApexPages.currentPage().getParameters().get('cInfoId');
        operationType=ApexPages.currentPage().getParameters().get('type');
        loadRecord();
        pharmacyBenefitChoiceValues = getPicklistValues('Specialty_Pricing__c', 'Pharmacy_Benefit__c') ; 
        
    }
    
    //method used to load platform specific record by record id
    public void loadRecord(){
            nonPharmacyBenefitChoiceValues = new list<SelectOption>();
        gstpChoiceValues = new list<SelectOption>();  
        splFormalityChoiceValues = new list<SelectOption>() ;   
           splFormalityChoicePLValues  = new list<SelectOption>() ; 
         nonPharmacyBenefitChoiceValues.add(new SelectOption('--None--', '--None--'));
                   gstpChoiceValues.add(new SelectOption('--None--', '--None--'));
                   splFormalityChoiceValues.add(new SelectOption('--None--', '--None--')); 
                     splFormalityChoicePLValues.add(new SelectOption('', '--None--')); 
        //Apexpages.addMessage(new apexpages.message(apexpages.severity.info, ''+recordId));
        if(String.isNotBlank(recordId)){
            //yes record found, then make a query on platform object
            platformSpecific= [Select Id, Name, RecordTypeId, FAF_ID__c, FAF_ID__r.Account_Name__c, 
            Source_Record_ID__c,Specialty_Pharmacy_Benefit_Price_List__c,FAF_Client_Information__c, Platform__c, Level1_Name__c,Level2_Name__c,Level3_Name__c,
            LOB__c, Instruction__c, Level_1_Record_ID__c,Level_1_Record_ID__r.Carrier_ID__c,Level_1_Record_ID__r.Carrier_Name__c, Level_2_Record_ID__r.Account_ID__c,Level_2_Record_ID__r.Account_Name__c,Level_3_Record_ID__r.Group_ID__c,
            Level_3_Record_ID__r.Group_Name__c,Level_2_Record_ID__c,Level_3_Record_ID__c, EffectiveDate__c, 
            DifferentGSTPFormularyEffectiveDates__c, Termed__c,Specialty_Pharmacy_Benefit_Choice__c ,Termed_Date__c, 
            GSTP_Choice__c, GSTPEffectiveDate__c, GSTPEndDate__c, Specialty_Formulary_Choice__c, 
            SpecialtyFormularyEffectiveDate__c, SpecialtyFormularyEndDate__c, Specialty_Pharmacy_Benefit__c,Specialty_Price_List__c,Non_Specialty_Formulary_Choice__c, 
            NonSpecialtyFormularyEffectiveDate__c, NonSpecialtyFormularyRebateEndDate__c     
            FROM Platform_Specifics__c where id=:recordId];
            
            cInfo = [select id,FAF_ID__c,Client_Subtype__c,Pricing_Effective_Date__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where id=:platformSpecific.FAF_Client_Information__c];
            platformSpecific.FAF_ID__c = cInfo.FAF_ID__c ;
            clientSubType = cInfo.Client_Subtype__c;
            if(platformSpecific.Specialty_Operations__c == null){
                List<Specialty_Operations__c> sOpsList = [select id,Medical_Benefit__c,Pharmacy_Benefit__c from Specialty_Operations__c where FAF_ID__c=:cInfo.FAF_ID__c];
                if(!sOpsList.isempty()){
                    sOperations = sOpsList[0];
                    platformSpecific.Specialty_Operations__c = sOpsList[0].id;
                    List<Specialty_Pricing__c> sPricingList = [select id,Price_List__c,Pharmacy_Benefit__c from Specialty_Pricing__c where Specialty_Operations__c=:sOpsList[0].id];
                        if(!sPricingList.isempty()){
                            sPricing = sPricingList[0];
                            platformSpecific.Specialty_Pricing__c = sPricingList[0].id;
                        } 
                }
             } else{
                     if(platformSpecific.Specialty_Pricing__c == null){
                        List<Specialty_Pricing__c> sPricingList = [select id,Price_List__c,Pharmacy_Benefit__c from Specialty_Pricing__c where Specialty_Operations__c=:platformSpecific.Specialty_Operations__c];
                        if(!sPricingList.isempty()){
                            sPricing = sPricingList[0];
                            platformSpecific.Specialty_Pricing__c = sPricingList[0].id;
                        } 
                     }
                   }
             if(platformSpecific.Rebate_Operations__c == null){
                   List<Rebate_Operations__c> rOpsList = [select id,GSTP_Option__c,Specialty_Formulary_Option__c,Non_Specialty_Formulary_Option__c from Rebate_Operations__c where FAF_ID__c=:cInfo.FAF_ID__c];
                        if(!rOpsList.isempty()){
                            rOperations = rOpsList[0];
                            platformSpecific.Rebate_Operations__c = rOpsList[0].id;
                        }   
               }
              
               
                        
        }else{ 
              platformSpecific = new Platform_Specifics__c();
              cInfo = [select id,FAF_ID__c,Client_Subtype__c,Pricing_Effective_Date__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where id=:cInfoId];
              platformSpecific.FAF_ID__c = cInfo.FAF_ID__c ;
              clientSubType = cInfo.Client_Subtype__c;
              platformSpecific.FAF_Client_Information__c = cInfo.id;
               if(platformSpecific.Specialty_Operations__c == null){
                List<Specialty_Operations__c> sOpsList = [select id,Medical_Benefit__c,Pharmacy_Benefit__c from Specialty_Operations__c where FAF_ID__c=:cInfo.FAF_ID__c];
                if(!sOpsList.isempty()){
                    sOperations = sOpsList[0];
                    platformSpecific.Specialty_Operations__c = sOpsList[0].id;
                    List<Specialty_Pricing__c> sPricingList = [select id,Price_List__c,Pharmacy_Benefit__c from Specialty_Pricing__c where Specialty_Operations__c=:sOpsList[0].id];
                        if(!sPricingList.isempty()){
                            sPricing = sPricingList[0];
                            platformSpecific.Specialty_Pricing__c = sPricingList[0].id;
                        } 
                }
             } else{
                     if(platformSpecific.Specialty_Pricing__c == null){
                        List<Specialty_Pricing__c> sPricingList = [select Price_List__c,Pharmacy_Benefit__c from Specialty_Pricing__c where Specialty_Operations__c=:platformSpecific.Specialty_Operations__c];
                        if(!sPricingList.isempty()){
                            sPricing = sPricingList[0];
                            platformSpecific.Specialty_Pricing__c = sPricingList[0].id;
                        } 
                     }
                   }   
              if(platformSpecific.Rebate_Operations__c == null){
                   List<Rebate_Operations__c> rOpsList = [select id,GSTP_Option__c,Specialty_Formulary_Option__c,Non_Specialty_Formulary_Option__c from Rebate_Operations__c where FAF_ID__c=:cInfo.FAF_ID__c];
                        if(!rOpsList.isempty()){
                            rOperations = rOpsList[0];
                            platformSpecific.Rebate_Operations__c = rOpsList[0].id;
                        }   
               } 
               
              if(cInfo.Pricing_Effective_Date__c != null){
                       date cInfoEffectiveDate = cInfo.Pricing_Effective_Date__c;
                       date firstDate = cInfoEffectiveDate.toStartOfMonth();
                       if(cInfo.Pricing_Effective_Date__c == firstDate){
                           platformSpecific.EffectiveDate__c = cInfoEffectiveDate;
                         }
                    } 
              }
              
                
                
        if(sOperations != null){
           if(sOperations.Pharmacy_Benefit__c == 'Client Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
               clientChoice = true; 
                 SpecialtyPharmacyBenefitPriceList = true;
              }
        } 
        
        if(rOperations != null){
        
           if(rOperations.Non_Specialty_Formulary_Option__c == 'Client Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
               rClientChoice = true; 
               nsfSectionRequired = true;
              }
              
           if(rOperations.GSTP_Option__c == 'Choice' && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
               gstpSectionRequired = true;              
              } 
              
           if(rOperations.Specialty_Formulary_Option__c == 'Client Choice'  && (clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')){
               sfSectionRequired = true;              
              }
                                  
           if((clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master')&& nsfSectionRequired || gstpSectionRequired || sfSectionRequired){
              dGSTPFormularyRequired = true;                          
           }  
          
          List<Rebate_Guarantees__c> rGurantees = [select id,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c from Rebate_Guarantees__c where Rebate_Operations__c =: rOperations.Id];
          
          if(rGurantees.size()>0){
               set<String> gstpSet = new set<String>();
               set<String> nsfSet = new set<String>();
               set<String> sfSet = new set<String>();
                  
               for(Rebate_Guarantees__c rg: rGurantees) {
               
                    
                   if(rg.Non_Specialty_Formulary_2__c!= null){ 
                   if(!nsfSet.contains(rg.Non_Specialty_Formulary_2__c)) {
                       nonPharmacyBenefitChoiceValues.add(new SelectOption(rg.Non_Specialty_Formulary_2__c, rg.Non_Specialty_Formulary_2__c));
                       nsfSet.add(rg.Non_Specialty_Formulary_2__c);
                   } 
                   }
                   if(rg.GSTP__c != null){ 
                   if(!gstpSet.contains(rg.GSTP__c)) {
                       gstpChoiceValues.add(new SelectOption(rg.GSTP__c, rg.GSTP__c));
                       gstpSet.add(rg.GSTP__c)  ;
                       }
                   }    
                   if(rg.Specialty_Formulary__c!= null){    
                   if(!sfSet.contains(rg.Specialty_Formulary__c)) {    
                       splFormalityChoiceValues.add(new SelectOption(rg.Specialty_Formulary__c, rg.Specialty_Formulary__c));
                       sfSet.add(rg.Specialty_Formulary__c); 
                       }
                    }      
               }             
            }                 
            
        }        
        system.debug('---'+clientSubType);     
        if(clientSubType != 'Health Plan Master' && clientSubType != 'Coalition Master' && clientSubType != 'TPA Master'){
            dGSTPFormularyRequired = false;
                       
           } 
           
        if(clientSubType == 'Health Plan Master' || clientSubType == 'Coalition Master' || clientSubType == 'TPA Master'){
            level1DRequired = true;
            effectiveDateRequired = true;     
            showTermflag = true;
            showTermed = true; 
           // clientChoice = true;             
           }else{
                   showTermed = false;
                    showTermflag = false;
                }    
           
        system.debug('--level1DRequired ---'+level1DRequired ); 
        if(platformSpecific.Termed__c == true)  {
           termedDateRequired = true;
        } 
        
        if(platformSpecific.DifferentGSTPFormularyEffectiveDates__c == true)  {
            nsfeDateRequired = true;
            gstpDateRequired = true;
            sfeDateRequired = true;
        }
        
        if(platformSpecific.DifferentGSTPFormularyEffectiveDates__c == false )  {
            if(platformSpecific.EffectiveDate__c == null) {
                platformSpecific.GSTPEffectiveDate__c = null;
                platformSpecific.SpecialtyFormularyEffectiveDate__c = null;
                platformSpecific.NonSpecialtyFormularyEffectiveDate__c = null;
            
                }
                /*else{
                      platformSpecific.GSTPEffectiveDate__c = platformSpecific.EffectiveDate__c;
                      platformSpecific.SpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c;
                      platformSpecific.NonSpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c;
                     } */
        }
        
     /*   if(platformSpecific.Level_1_Record_ID__c != null){
            if(string.isblank(platformSpecific.Level1_Name__c)){
            CAG__c cag = [select Record_Type__c,Non_Validated_CAG__c,Carrier_Name__c from CAG__c where id=:platformSpecific.Level_1_Record_ID__c]; 
            if(cag.Non_Validated_CAG__c == true){
                platformSpecific.Level1_Name__c = 'Non-Validated';
                
             }else{
                     platformSpecific.Level1_Name__c = cag.Carrier_Name__c ;
                  //}   
           }        
        }
        
        
        if(platformSpecific.Level_2_Record_ID__c != null){
            if(string.isblank(platformSpecific.Level2_Name__c)){
            CAG__c cag = [select Record_Type__c,Non_Validated_CAG__c,Carrier_Name__c from CAG__c where id=:platformSpecific.Level_2_Record_ID__c]; 
            if(cag.Non_Validated_CAG__c == true){
                platformSpecific.Level2_Name__c = 'Non-Validated';
                
             }else{
                     platformSpecific.Level2_Name__c = cag.Carrier_Name__c ;
                  }   
           }        
        }
        
         if(platformSpecific.Level_3_Record_ID__c != null){
            if(string.isblank(platformSpecific.Level3_Name__c)){
            CAG__c cag = [select Record_Type__c,Non_Validated_CAG__c,Carrier_Name__c from CAG__c where id=:platformSpecific.Level_3_Record_ID__c]; 
            if(cag.Non_Validated_CAG__c == true){
                platformSpecific.Level3_Name__c = 'Non-Validated';
                
             }else{
                     platformSpecific.Level3_Name__c = cag.Carrier_Name__c ;
                  }   
           }        
        }*/
        
        List<Specialty_Pricing__c> sPricingList = [select id,Pharmacy_Benefit__c,Price_List__c from Specialty_Pricing__c where FAF_ID__c=:cInfo.FAF_ID__c];
                          
        if(sPricingList.size()>0){
        
            set<String> pricingSet = new set<String>();
                       
               for(Specialty_Pricing__c sPricing : sPricingList) {
                  
                   String pricingChoiceString = '';
                                   
                   if(sPricing.Pharmacy_Benefit__c!= null && sPricing.Pharmacy_Benefit__c!= '' ){
                       pricingChoiceString += sPricing.Pharmacy_Benefit__c; 
                     }
                  if( sPricing.Pharmacy_Benefit__c!= 'None' ){    
                   if(sPricing.Price_List__c != null && sPricing.Price_List__c!= ''){
                        if(pricingChoiceString == null || pricingChoiceString == ''){
                               pricingChoiceString += sPricing.Price_List__c;
                             }else{
                                     pricingChoiceString += '-'+sPricing.Price_List__c ;
                                  }
                         }              
                        
                   }
                   if(!pricingSet.contains(pricingChoiceString )) {
                       if(pricingChoiceString != ''){
                       splFormalityChoicePLValues.add(new SelectOption(pricingChoiceString,pricingChoiceString));
                       }
                       pricingSet.add(pricingChoiceString );
                     } 
                   
               }    
        
        } else{
                if(sOperations != null){
                
                List<Specialty_Legacy_Drug_Level_pricing__c> sPricingLegacyList = [select id,Pharmacy_Benefit__c,Price_List_Type__c from Specialty_Legacy_Drug_Level_pricing__c where Specialty_Ops__c=:sOperations.Id];
                          
                if(sPricingLegacyList.size()>0){
                
                   /* set<String> pricingSet = new set<String>();
                               
                       for(Specialty_Legacy_Drug_Level_pricing__c sPricing : sPricingLegacyList ) {
                          
                           String pricingChoiceString = '';
                                           
                           if(sPricing.Pharmacy_Benefit__c!= null && sPricing.Pharmacy_Benefit__c!= '' ){
                               pricingChoiceString += sPricing.Pharmacy_Benefit__c; 
                             }
                          if( sPricing.Pharmacy_Benefit__c!= 'None' ){    
                           if(sPricing.Price_List_Type__c!= null && sPricing.Price_List_Type__c!= ''){
                                if(pricingChoiceString == null || pricingChoiceString == ''){
                                       pricingChoiceString += sPricing.Price_List_Type__c;
                                     }else{
                                             pricingChoiceString += '-'+sPricing.Price_List_Type__c;
                                          }
                                 }              
                                
                           }
                           
                           if(!pricingSet.contains(pricingChoiceString )) {
                               if(pricingChoiceString != ''){
                               splFormalityChoicePLValues.add(new SelectOption(pricingChoiceString,pricingChoiceString));
                               }
                               pricingSet.add(pricingChoiceString );
                             } 
                           
                       }    
                     */
                     List<Pharmacy_Benefit_Price_List__mdt> priceList = [SELECT Name__c FROM Pharmacy_Benefit_Price_List__mdt order by name__c ASC];
                  
                      if(priceList.size()>0){
                      
                           for(Pharmacy_Benefit_Price_List__mdt pList : priceList ) {
                               splFormalityChoicePLValues.add(new SelectOption(pList.Name__c,pList.Name__c));
                           }
                      }
                  }                                  
                }
              }     
   
        
      /*  if(nsfeDateRequired == true){
             if(platformSpecific.DifferentGSTPFormularyEffectiveDates__c == false)  {
                     platformSpecific.NonSpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c;
                }      
         }else{
               platformSpecific.NonSpecialtyFormularyEffectiveDate__c = null;
               platformSpecific.Non_Specialty_Formulary_Choice__c = null;
              }
        
        if(gstpDateRequired == true){
                if(platformSpecific.DifferentGSTPFormularyEffectiveDates__c == false)  {
                        platformSpecific.GSTPEffectiveDate__c =platformSpecific.EffectiveDate__c;
               }            
        }else{
               platformSpecific.GSTPEffectiveDate__c = null;
               platformSpecific.GSTP_Choice__c = null;
              }
        
        if(sfeDateRequired == true){
             if(platformSpecific.DifferentGSTPFormularyEffectiveDates__c == false)  {
                   platformSpecific.SpecialtyFormularyEffectiveDate__c  =platformSpecific.EffectiveDate__c;
              }
        }else{
               platformSpecific.SpecialtyFormularyEffectiveDate__c  = null;
               platformSpecific.Specialty_Formulary_Choice__c = null;
              }*/
               
    }
    
    public PageReference doSave(){
        Boolean isValidSave = false;
        system.debug(platformSpecific.Level2_Name__c + 'Leve2Name---');
        platformSpecific.XAE__c = false;
        if(platformSpecific.Termed__c == false){
           platformSpecific.Termed_Date__c = null;
        }
        
        if(platformSpecific.DifferentGSTPFormularyEffectiveDates__c == false )  {
            if(platformSpecific.EffectiveDate__c != null) {               
                      platformSpecific.GSTPEffectiveDate__c = platformSpecific.EffectiveDate__c;
                      platformSpecific.SpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c;
                      platformSpecific.NonSpecialtyFormularyEffectiveDate__c = platformSpecific.EffectiveDate__c; 
             }else{
                      platformSpecific.GSTPEffectiveDate__c = null;
                      platformSpecific.SpecialtyFormularyEffectiveDate__c = null;
                      platformSpecific.NonSpecialtyFormularyEffectiveDate__c = null;
                   }          
        }
        
        if(nsfeDateRequired == false){
             platformSpecific.NonSpecialtyFormularyEffectiveDate__c = null;
             platformSpecific.NonSpecialtyFormularyRebateEndDate__c = null;
                      
        }
        
        if(gstpDateRequired == false){
            platformSpecific.GSTPEffectiveDate__c = null;
            platformSpecific.GSTPEndDate__c = null;
                     
        }
        
        if(sfeDateRequired == false){
              platformSpecific.SpecialtyFormularyEffectiveDate__c  = null;
              platformSpecific.SpecialtyFormularyEndDate__c = null;
        }
        

        try{
        if(operationType==CLONE){
                pagereference pr;
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(platformSpecific);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
                return pr;
        }
        else{
            if(platformSpecific.id == null){
                insert platformSpecific;
            } else{
                update platformSpecific;
            }
        
            
            isValidSave = true;
        }
        }Catch(Exception e){
            isValidSave = false;
            ApexPages.addMessages(e);
        }
        system.debug('---'+returnURL);
        if(isValidSave == true && operationType!=CLONE){
            if(returnURL == null){
                String URL = 'https://pbmfinancecvshealth--apttusdev.lightning.force.com/lightning/r/Client_Information__c/'+platformSpecific.FAF_Client_Information__c+'/view';
                      return new pageReference('/'+platformSpecific.FAF_Client_Information__c);              
                }else{
                        return new Pagereference(returnURL);
                     }           
        }
        return null;
    }
    
    public PageReference doCancel(){
        if(returnURL == null){
                 
                //String URL = 'https://pbmfinancecvshealth--apttusdev.lightning.force.com/lightning/r/Client_Information__c/'+platformSpecific.FAF_Client_Information__c+'/view';
                      return new pageReference('/'+platformSpecific.FAF_Client_Information__c);              
                }else{
                        return new Pagereference(returnURL);
                     } 
    }
    
    
    public pagereference checkLevel1(){
          
        String level1ID = ApexPages.currentPage().getParameters().get('level1ID');
        System.debug('Print--->'+level1ID); 
        if(string.isnotBlank(level1ID)) {
            CAG__c cag = [select Record_Type__c,Non_Validated_CAG__c,Carrier_Name__c from CAG__c where name=:level1ID ];
            System.debug('cag--->'+cag); 
            if(cag.Non_Validated_CAG__c == true){
                platformSpecific.Level1_Name__c = 'Non-Validated';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A valid Level 1 ID is required.'));
                
                return null; 
             }else{
                     platformSpecific.Level1_Name__c = cag.Carrier_Name__c ;
                  }
        }else{
                platformSpecific.Level1_Name__c = null ;
             }
      return null;    
   }
   
    public pagereference checkLevel2(){
          
        String level2ID = ApexPages.currentPage().getParameters().get('level2ID');
        System.debug('Print--->'+level2ID); 
        if(string.isnotBlank(level2ID)) {
            CAG__c cag = [select Record_Type__c,Non_Validated_CAG__c,Carrier_Name__c  from CAG__c where name=:level2ID];
            System.debug('cag--->'+cag); 
            if(cag.Non_Validated_CAG__c == true){
                platformSpecific.Level2_Name__c = 'Non-Validated';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A valid Level 2 ID is required.'));
                return null; 
             }else{
                     platformSpecific.Level2_Name__c = cag.Carrier_Name__c ;
                  }
        }else{
                platformSpecific.Level2_Name__c = null ;
             }
      return null;    
   }
   
   public pagereference checkLevel3(){
          
        String level3ID = ApexPages.currentPage().getParameters().get('level3ID');
        System.debug('Print--->'+level3ID); 
        if(string.isnotBlank(level3ID)) {
            CAG__c cag = [select Record_Type__c,Non_Validated_CAG__c,Carrier_Name__c  from CAG__c where name=:level3ID];
            System.debug('cag--->'+cag); 
            if(cag.Non_Validated_CAG__c == true){
                platformSpecific.Level3_Name__c = 'Non-Validated';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A valid Level 3 ID is required.'));
                return null; 
             }else{
                     platformSpecific.Level3_Name__c = cag.Carrier_Name__c ;
                  }
        }else{
                platformSpecific.Level3_Name__c = null ;
             }
      return null;    
   }
   
   public pagereference checkEffectiveDate(){
          
        String effectiveDateString = ApexPages.currentPage().getParameters().get('effectiveDate');
        System.debug('Print--->'+effectiveDateString); 
        if(string.isnotBlank(effectiveDateString)) {
            Date effectiveDate = date.parse(effectiveDateString);
            platformSpecific.EffectiveDate__c = effectiveDate;
            if(cInfo.Pricing_Effective_Date__c!= null && effectiveDate < cInfo.Pricing_Effective_Date__c){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Platform Specifics Effective Date is earlier than the Pricing Effective Date.'));
               hightlightBlock = true;
               return null; 
            }else{
                    hightlightBlock = false;
                 }
            date firstDate = effectiveDate.toStartOfMonth();
            if(effectiveDate != firstDate){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Platform Specifics Effective Date is not the first day of the month.'));
                    hightlightBlock = true;
                    return null; 
             } else{
                    hightlightBlock = false;
                 } 
          }else{
                  platformSpecific.EffectiveDate__c = null;
               }               
      return null;    
   }
   
   public pagereference terminatedDateCheck(){
          
        String termFlag = ApexPages.currentPage().getParameters().get('termFlag');
        System.debug('Print-termFlag -->'+termFlag ); 
        
         if(termFlag == 'True' ){
             platformSpecific.Termed__c = true;
             termedDateRequired = true;
           }else{
                   termedDateRequired = false;
                   platformSpecific.Termed__c = false;
                   platformSpecific.Termed_Date__c = null;
                }          
      return null;    
   }
   
   public pagereference checkTerminateDate(){
          
        String terminateDateString = ApexPages.currentPage().getParameters().get('terminateDate');
        System.debug('Print--terminateDateString--->'+terminateDateString); 
        if(string.isnotBlank(terminateDateString)) {
            Date terminateDate = date.parse(terminateDateString);
            platformSpecific.Termed_Date__c = terminateDate;
            
            // Production Support Changes : w-000528 Platform Specifics Termed Date Need to Allow All Dates: Mohit Srivastava
             
            if(platformSpecific.EffectiveDate__c != null && platformSpecific.Termed_Date__c < platformSpecific.EffectiveDate__c){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Termed Date must not be earlier than the Platform Specifics Effective Date.'));
               return null; 
            }
            
            date nextMonth = terminateDate.addMonths(1);
            date firstDate = nextMonth.toStartOfMonth();
            date lastDate = firstDate.addDays(-1);
            
            // Production Support Changes : w-000528 Platform Specifics Termed Date Need to Allow All Dates: MohitSrivastava 
            
            /*if(terminateDate != lastDate){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Termed Date must be the last date of a month and must not be earlier than the Platform Specifics Effective Date.'));
                    return null; 
            } */ 
        }           
      return null;    
   }
   
   public pagereference gstpFormularyDatesCheck(){
          
        String gstpFormulary = ApexPages.currentPage().getParameters().get('gstpFormularyFlag');
        System.debug('Print-gstpFormulary-->'+gstpFormulary); 
        
         if(gstpFormulary == 'True' ){
             platformSpecific.DifferentGSTPFormularyEffectiveDates__c = true;
             nsfeDateRequired = true;
             gstpDateRequired = true;
             sfeDateRequired = true; 
           }else{
                   nsfeDateRequired = false;
                   gstpDateRequired = false;
                   sfeDateRequired = false;
                   platformSpecific.DifferentGSTPFormularyEffectiveDates__c = false;
                }          
      return null;    
   }
   
   public pagereference sfEndDateCheck(){
   
        String sfEffectiveDateDateString = ApexPages.currentPage().getParameters().get('sfEffectiveDate');  
        String sfEndDateDateString = ApexPages.currentPage().getParameters().get('sfEndDate');
        
        System.debug('Print--sfEndDateDateString--->'+sfEndDateDateString);
        System.debug('Print--sfEffectiveDateDateString--->'+sfEffectiveDateDateString);
         
        if(string.isnotBlank(sfEndDateDateString)) {
        
            Date sfEndDate = date.parse(sfEndDateDateString);
            platformSpecific.SpecialtyFormularyEndDate__c= sfEndDate;
            System.debug('Print--inside1--->');
            if(string.isnotBlank(sfEffectiveDateDateString)) {
                 System.debug('Print--inside2--->');
                Date sfEffectiveDate = date.parse(sfEffectiveDateDateString);
                platformSpecific.SpecialtyFormularyEffectiveDate__c = sfEffectiveDate;
                System.debug('Print--sfEffectiveDate--->'+sfEffectiveDate);
                System.debug('Print--sfEndDate--->'+sfEndDate);
                
                if(sfEndDate < sfEffectiveDate ){
                System.debug('Print--insde--->');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Specialty Formulary End Date must be greater than the Specialty Formulary Effective Date.'));
                   return null; 
                }
                
            
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Specialty Formulary End Date must be greater than the Specialty Formulary Effective Date.'));
                    return null; 
                 }
            
            
          }  else{
                    platformSpecific.SpecialtyFormularyEndDate__c = null;
                    return null;
                 }   
                       
      return null;    
   }
   
   public pagereference nsfEndDateCheck(){
   
        String nsfEffectiveDateDateString = ApexPages.currentPage().getParameters().get('nsfEffectiveDate');  
        String nsfEndDateDateString = ApexPages.currentPage().getParameters().get('nsfEndDate');
        
        System.debug('Print--sfEndDateDateString--->'+nsfEndDateDateString);
        System.debug('Print--sfEffectiveDateDateString--->'+nsfEffectiveDateDateString);
         
        if(string.isnotBlank(nsfEndDateDateString)) {
        
            Date nsfEndDate = date.parse(nsfEndDateDateString);
            platformSpecific.NonSpecialtyFormularyRebateEndDate__c = nsfEndDate;
            System.debug('Print--inside1--->');
            if(string.isnotBlank(nsfEffectiveDateDateString)) {
                 System.debug('Print--inside2--->');
                Date nsfEffectiveDate = date.parse(nsfEffectiveDateDateString);
                platformSpecific.NonSpecialtyFormularyEffectiveDate__c = nsfEffectiveDate;
                System.debug('Print--sfEffectiveDate--->'+nsfEffectiveDate);
                System.debug('Print--sfEndDate--->'+nsfEndDate);
                
                if(nsfEndDate < nsfEffectiveDate ){
                System.debug('Print--insde--->');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Non-Specialty Formulary End Date must be greater than the Non-Specialty Formulary Effective Date.'));
                   return null; 
                }
                
            
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Non-Specialty Formulary End Date must be greater than the Non-Specialty Formulary Effective Date.'));
                    return null; 
                 }
            
            
          }  else{
                    platformSpecific.NonSpecialtyFormularyRebateEndDate__c = null;
                    return null;
                 }   
                       
      return null;    
   }
   
   public pagereference gstpEndDateCheck(){
   
        String gstpEffectiveDateDateString = ApexPages.currentPage().getParameters().get('gstpEffectiveDate');  
        String gstpEndDateDateString = ApexPages.currentPage().getParameters().get('gstpEndDate');
        
        System.debug('Print--gstpEffectiveDateDateString--->'+gstpEffectiveDateDateString);
        System.debug('Print--gstpEndDateDateString--->'+gstpEndDateDateString);
         
        if(string.isnotBlank(gstpEndDateDateString)) {
        
            Date gstpEndDate = date.parse(gstpEndDateDateString);
            platformSpecific.GSTPEndDate__c = gstpEndDate;
            System.debug('Print--inside1--->');
            if(string.isnotBlank(gstpEffectiveDateDateString)) {
                 System.debug('Print--inside2--->');
                Date gstpEffectiveDate = date.parse(gstpEffectiveDateDateString);
                platformSpecific.GSTPEffectiveDate__c = gstpEffectiveDate;
                System.debug('Print--gstpEffectiveDate--->'+gstpEffectiveDate);
                System.debug('Print--gstpEndDate--->'+gstpEndDate);
                
                if(gstpEndDate < gstpEffectiveDate){
                System.debug('Print--insde--->');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The GSTP End Date must be greater than the GSTP Effective Date.'));
                   return null; 
                }
                
            
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The GSTP End Date must be greater than the GSTP Effective Date.'));
                    return null; 
                 }
            
            
          }  else{
                    platformSpecific.GSTPEndDate__c= null;
                    return null;
                 }   
                       
      return null;    
   }
   
   public pagereference sfEffectiveDateCheck(){
   
        String sfEffectiveDateDateString = ApexPages.currentPage().getParameters().get('sfEffectiveDate1');  
        String effetiveDateString = ApexPages.currentPage().getParameters().get('effetiveDate1');
        
        System.debug('Print--effetiveDateString--->'+effetiveDateString);
        System.debug('Print--sfEffectiveDateDateString--->'+sfEffectiveDateDateString);
         
        if(string.isnotBlank(sfEffectiveDateDateString)) {
        
            Date sfEffectiveDate = date.parse(sfEffectiveDateDateString);
            platformSpecific.SpecialtyFormularyEffectiveDate__c = sfEffectiveDate;
            System.debug('Print--inside1--->');
            
            if(string.isnotBlank(effetiveDateString)) {
                 System.debug('Print--inside2--->');
                Date effetiveDate = date.parse(effetiveDateString);
                platformSpecific.EffectiveDate__c = effetiveDate;
                System.debug('Print--effetiveDate--->'+effetiveDate);
                System.debug('Print--sfEffectiveDate--->'+sfEffectiveDate);
                
                if(sfEffectiveDate < effetiveDate ){
                System.debug('Print--insde--->');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Specialty Formulary Effective Date must be equal to or greater than the Platform Specifics Effective Date.'));
                   return null; 
                }
                
            
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Specialty Formulary Effective Date must be equal to or greater than the Platform Specifics Effective Date.'));
                    return null; 
                 }
            
            
          }  else{
                    platformSpecific.SpecialtyFormularyEffectiveDate__c = null;
                    return null;
                 }   
                       
      return null;    
   }
   
   public pagereference nsfEffectiveDateCheck(){
   
        String nsfEffectiveDateDateString = ApexPages.currentPage().getParameters().get('nsfEffectiveDate2');  
        String effetiveDateString = ApexPages.currentPage().getParameters().get('effetiveDate2');
        
        System.debug('Print--effetiveDateString--->'+effetiveDateString);
        System.debug('Print--nsfEffectiveDateDateString--->'+nsfEffectiveDateDateString);
         
        if(string.isnotBlank(nsfEffectiveDateDateString)) {
        
            Date nsfEffectiveDate = date.parse(nsfEffectiveDateDateString);
            platformSpecific.NonSpecialtyFormularyEffectiveDate__c = nsfEffectiveDate;
            System.debug('Print--inside1--->');
            
            if(string.isnotBlank(effetiveDateString)) {
                 System.debug('Print--inside2--->');
                Date effetiveDate = date.parse(effetiveDateString);
                platformSpecific.EffectiveDate__c = effetiveDate;
                System.debug('Print--effetiveDate--->'+effetiveDate);
                System.debug('Print--nsfEffectiveDate--->'+nsfEffectiveDate);
                
                if(nsfEffectiveDate < effetiveDate ){
                System.debug('Print--insde--->');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Non-Specialty Formulary Effective Date must be equal to or greater than the Platform Specifics Effective Date.'));
                   return null; 
                }
                
            
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Non-Specialty Formulary Effective Date must be equal to or greater than the Platform Specifics Effective Date.'));
                    return null; 
                 }
            
            
          }  else{
                    platformSpecific.NonSpecialtyFormularyEffectiveDate__c = null;
                    return null;
                 }   
                       
      return null;    
   }
   
   public pagereference gstpEffectiveDateCheck(){
   
        String gstpEffectiveDateDateString = ApexPages.currentPage().getParameters().get('gstpEffectiveDate3');  
        String effetiveDateString = ApexPages.currentPage().getParameters().get('effetiveDate3');
        
        System.debug('Print--effetiveDateString--->'+effetiveDateString);
        System.debug('Print--gstpEffectiveDateDateString--->'+gstpEffectiveDateDateString);
         
        if(string.isnotBlank(gstpEffectiveDateDateString)) {
        
            Date gstpEffectiveDate = date.parse(gstpEffectiveDateDateString);
            platformSpecific.GSTPEffectiveDate__c = gstpEffectiveDate;
            System.debug('Print--inside1--->');
            
            if(string.isnotBlank(effetiveDateString)) {
                 System.debug('Print--inside2--->');
                Date effetiveDate = date.parse(effetiveDateString);
                platformSpecific.EffectiveDate__c = effetiveDate;
                System.debug('Print--effetiveDate--->'+effetiveDate);
                System.debug('Print--gstpEffectiveDate--->'+gstpEffectiveDate);
                
                if(gstpEffectiveDate < effetiveDate ){
                System.debug('Print--insde--->');
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The GSTP Effective Date must be equal to or greater than the Platform Specifics Effective Date.'));
                   return null; 
                }
                
            
            }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The GSTP Effective Date must be equal to or greater than the Platform Specifics Effective Date.'));
                    return null; 
                 }
            
            
          }  else{
                    platformSpecific.GSTPEffectiveDate__c = null;
                    return null;
                 }   
                       
      return null;    
   }
   
   Public static list<SelectOption> getPicklistValues(String obj, String fld){
          list<SelectOption> options = new list<SelectOption>();
          Schema.sObjectType objType = Schema.getGlobalDescribe().get(obj);
          Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
          map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
          list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
          options.add(new SelectOption('--None--', '--None--'));
          for (Schema.PicklistEntry a : values)
          { 
             options.add(new SelectOption(a.getLabel(), a.getValue())); 
          }
          return options;
         }
         
    public void onchangePlatform(){
    //   if(platformSpecific.Level_1_Record_ID__c != null){
    //       platformSpecific.Level_1_Record_ID__r.Carrier_ID__c = '';
    //       platformSpecific.Level_1_Record_ID__c = null;
    //       platformSpecific.Level1_Name__c = '';
    //   }
    //   if(platformSpecific.Level_2_record_ID__c != null){
    //       platformSpecific.Level_2_Record_ID__r.Account_Id__c = '';
    //       platformSpecific.Level_2_record_ID__c = null;
    //       platformSpecific.Level2_Name__c = '';
    //   }
    //   if(platformSpecific.Level_3_record_ID__c != null){
    //       platformSpecific.Level_3_record_ID__r.Group_ID__c = '';
      
    //       platformSpecific.Level_3_record_ID__c = null;
    //       platformSpecific.Level3_Name__c = '';
    // }
    //  else{
    //       platformSpecific.Level1_Name__c = 'Non-Validated';
    //  }
   }
    public void onchangeLevel1(){
    //  if(platformSpecific.Level_2_record_ID__c != null || platformSpecific.Level_3_record_ID__c != null ){
//platformSpecific.Level_1_Record_ID__r.Carrier_ID__c = '';
       //    platformSpecific.Level_2_record_ID__c = null;
       //     platformSpecific.Level_3_record_ID__c = null;
        //    platformSpecific.Level2_Name__c = '';
        //    platformSpecific.Level3_Name__c = '';
   
        //}
    }
   public void onchangeLevel2(){
    //   if(platformSpecific.Level_3_record_ID__c != null){
    //         platformSpecific.Level_3_record_ID__c = null;
    //         platformSpecific.Level3_Name__c = '';
   
    //     }
    }

   
}