/*********************************************************************************************
 * @ClassName         : SpecialtyPriceNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 31/07/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 31/07/2018
 * @Purpose           : This is the controller class for SpecialtyPriceNewEditPage
 **********************************************************************************************/
public with sharing class SpecialtyPriceNewEditClass{
    public ApexPages.StandardController con;
    Public Specialty_Pricing__c specPricObj{get;set;} // Object declair for insert update
    Public Id specPriceID{get;set;}  //For get the Record id
    Public List<Client_Information__c> clintInfoList;    // for get the value of client Information
    Public List<SelectOption> yearList{get;set;}     // for populate the year in dropdown
    Public set<string> checkClientYearCount; 
    Public Boolean disablePharmacyBenefitFlag{get;set;} 
    public string yearval{get;set;}
    public Boolean redirect{get;set;}
    public String operationType;// custom clone functionality
    
    public Specialty_Operations__c specOpsObj1;
    
    /******************************************************************************************************************************
     * @Method Name       : SpecialtyPriceNewEditClass
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Constructor of the SpecialtyPriceNewEditClass
     *******************************************************************************************************************************/
    public SpecialtyPriceNewEditClass(ApexPages.StandardController controller) {
        redirect = ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING);
        operationType=ApexPages.currentPage().getParameters().get(ConstantsUtil.TYPE); //for the clone 
        con = controller;
        disablePharmacyBenefitFlag = false;
        specPricObj = new Specialty_Pricing__c();
        yearList = new List<SelectOption>(); 
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        //hideCancelButton = true;
        specPriceID = ApexPages.currentPage().getParameters().get(ConstantsUtil.STRING_ID);    //Get Id fo the record from URL
        Id specOpsId = ApexPages.currentPage().getParameters().get(Label.SpecialtyOpsLabel);   //Get Speciality operation Id from URL
        //If the record is new this condition will execute
        if(String.IsBlank(specPriceID)){
            if(!String.IsBlank(specOpsId)){
                Specialty_Operations__c specOpsObj = [select id, FaF_Id__c,FAF_ID__r.Client_Subtype__c,Pharmacy_Benefit__c,(select id from Specialty_Legacy_drug_Level_pricings__r limit 1),(select id from Specialty_Pricing__r limit 1) from Specialty_Operations__c where id=: specOpsId];
                specOpsObj1=specOpsObj;
                specPricObj.Faf_Id__c = specOpsObj.FaF_Id__C;
                specPricObj.Specialty_Operations__c = specOpsId;
                if(!string.isBlank(specOpsObj.Pharmacy_Benefit__c)){
                if(!specOpsObj.Pharmacy_Benefit__c.equals(ConstantsUtil.CLIENT_CHOICE)){
                specPricObj.Pharmacy_Benefit__c = specOpsObj.Pharmacy_Benefit__c;
                disablePharmacyBenefitFlag = true;
                }
                }
                if(!(string.isBlank(specOpsObj.FAF_ID__C))){
                
                    //Query the associated client Information to populate the bvalue in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Pricing_Effective_Date__c from
                    Client_Information__c where FAF_ID__c =:specOpsObj.FAF_ID__c limit 1];
                    
                    if(!clintInfoList.isEmpty()){      //check tat Client Info list is empty or not
                        if(!(string.isBlank(clintInfoList[0].year_1__c))){
                            yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));        //Populate empty value in Year field
                            yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
                            checkClientYearCount.add(clintInfoList[0].year_1__c);     // associate value from client Information object
                        }
                        if(!(string.isBlank(clintInfoList[0].year_2__c))){    //for check value is not empty 
                             yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                             checkClientYearCount.add(clintInfoList[0].year_2__c); // associate value from client Information object
                        }
                        if(!(string.isBlank(clintInfoList[0].year_3__c))){    //for check value is not empty 
                             yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                             checkClientYearCount.add(clintInfoList[0].year_3__c);    // associate value from client Information object
                        }
                        if(!(string.isBlank(clintInfoList[0].year_4__c))){     //for check value is not empty 
                             yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                             checkClientYearCount.add(clintInfoList[0].year_4__c);    // associate value from client Information object
                        }
                        if(!(string.isBlank(clintInfoList[0].year_5__c))){     //for check value is not empty 
                             yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
                             checkClientYearCount.add(clintInfoList[0].year_5__c);  // associate value from client Information object
                        }
                     }
                }
            }
        }else{   //In User edit a record then this condition will execute
        
            //Fetch Specialty Operation object info
            specPricObj = [select id, name, FAF_ID__c, Year__c, Pharmacy_Benefit__c, Price_List__c, LOB__c, Specialty_Compare_Logic_On__c, X340B_Pharmacy_Setup__c,
            Brand_Basis__c, Generic_Basis__c, Brand_Rate__c, Generic_Rate__c, Brand_Dispensing_Fee__c, MAC_Modeled__c,
            Match_Generics_to_Brands__c, Non_MAC_Rate__c, Generic_Dispensing_Fee__c, New_to_Market_Brand_Rate__c,
            New_to_Market_Generic_Rate__c, Limited_Distribution_Drug_LDD_Rate__c, Biosimilar_Rate__c, LDD_No_Access_Rate__c,
            Method__c, Level__C, Timeframe__c, Custom_Language_Neeeded_to_Limit_Pena__c, Biosimilars_Into_Brands__c,Open_HIV__c,
            Calendar_Year_New_to_Market_Period_Flag__c, Allow_Specialty_To_Be_Dispensed_At_Ot__c, Network_ID__c,
            Non_CVS_Specialty_Pricing_Should_Mirror__c, Specialty_Operations__c, Specialty_Operations__r.FAF_ID__c,Specialty_Operations__r.Pharmacy_Benefit__c from Specialty_Pricing__c where id =: specPriceID];
            /*if(specPricObj.LOB__c == null){
                hideCancelButton = false;
            }*/
             Specialty_Operations__c specOpsObj = [select id, FaF_Id__c,Pharmacy_Benefit__c from Specialty_Operations__c where id=: specPricObj.Specialty_Operations__c];
             if(!string.isBlank(specOpsObj.Pharmacy_Benefit__c)){
             if(!specOpsObj.Pharmacy_Benefit__c.equals(ConstantsUtil.CLIENT_CHOICE)){
                specPricObj.Pharmacy_Benefit__c = specOpsObj.Pharmacy_Benefit__c;
                disablePharmacyBenefitFlag = true;
                }
                }
            
            if(!(string.isBlank(specPricObj.Specialty_Operations__r.FAF_ID__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Pricing_Effective_Date__c from
                Client_Information__c where FAF_ID__c =:specPricObj.Specialty_Operations__r.FAF_ID__c];
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
        }
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL)); // Add ConstantsUtil.ALL value in year dropdown
    }
    
    /******************************************************************************************************************************
     * @Method Name       : saveUpdateSpecPrice
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Method for save and update the recoed
     *******************************************************************************************************************************/
    public pagereference saveUpdateSpecPrice(){
        try{
            /******** User story W-000488 START Check If there is eligible Platform specifics record exist or not on new SP record creation *************/
            if( specPricObj.id==null  && specPricObj.Pharmacy_Benefit__c !=null && specPricObj.Pharmacy_Benefit__c!='' ){
                if(specOpsObj1!=null && specOpsObj1.FaF_Id__c!=null && (specOpsObj1.FAF_ID__r.Client_Subtype__c=='Health Plan Master' || specOpsObj1.FAF_ID__r.Client_Subtype__c=='TPA Master' || specOpsObj1.FAF_ID__r.Client_Subtype__c=='Coalition Master') &&
                    specOpsObj1.Pharmacy_Benefit__c=='Client Choice' && specOpsObj1.Specialty_Pricing__r.isEmpty() && !specOpsObj1.Specialty_Legacy_drug_Level_pricings__r.isEmpty()){
                    
                          string comp=  (specPricObj.Pharmacy_Benefit__c=='None')?'None':specPricObj.Pharmacy_Benefit__c+ConstantsUtil.hyphenStr+specPricObj.Price_List__c;
                          list<Platform_Specifics__c> PSList= [select id,Specialty_Pharmacy_Benefit_Price_List__c from Platform_Specifics__c
                                                                      where FAF_Id__c =: specOpsObj1.FAF_Id__c and Specialty_Pharmacy_Benefit_Price_List__c !=null];
                           //loop thorugh list if we have records with Specialty_Pharmacy_Benefit_Price_List__c
                           set<string> SPBPset=new set<string>();
                           for(Platform_Specifics__c p:PSList){
                               SPBPset.add(p.Specialty_Pharmacy_Benefit_Price_List__c);
                           }
                           //display only we have platfrom specific records and none matches with specality pricing
                          if(SPBPset.size()>0 && !SPBPset.contains(comp) ){
                              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Platform Specific record(s) exist with \'Specialty Pharmacy Benefit & Price List\' value(s) which is/are no longer applicable. Please modify the platform specifics records which are utilizing the specific Specialty \'Pharmacy Benefit\' and \'Price List\' value combination.'));
                              return null;
                          }
                    }
                    
            }
            
            /********User story W-000488 END Check If there is eligible Platform specifics record exist or not on new SP record creation *************/
            
            String url;
            if(ConstantsUtil.CLONE.equals(operationType)){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(specPricObj);
                insert cloneSObj;
                
                List<Specialty_Guarantee__c>specialtyGuaranteeList = new List<Specialty_Guarantee__c>();
                List<Specialty_Guarantee__c>newSpecialtyGuaranteeList = new List<Specialty_Guarantee__c>();
                specialtyGuaranteeList = [select id, name, FAF_ID__c, Specialty_Pricing__c, Type__c, Subtype__c,
                    Rate__c, ZBD__c, LDD__c, SSG__c, LDD_Exclusion_Option__c, New_to_Market_Brands__c,
                    Biosimilars__c, New_to_Market_Generics__c, OTC__c, X340B__c, Compound__c,
                    X340B_Exclusion_Option__c, Vaccine__c, Paper__c, COB__c FROM Specialty_Guarantee__c where Specialty_Pricing__c = :specPricObj.id];
                for(Specialty_Guarantee__c spg: specialtyGuaranteeList){
                    spg.id = null;
                    spg.Specialty_Pricing__c = cloneSObj.id;
                    newSpecialtyGuaranteeList.add(spg);
                }
                insert newSpecialtyGuaranteeList;
                url = ConstantsUtil.FORWARD_SlASH +cloneSObj.id;
            }else{
                if(String.IsBlank(specPriceID)){
                    insert specPricObj;  //Insert Specialty Pricing
                }else{
                    update specPricObj;  //Update Specialty Pricing
                }
                url = ConstantsUtil.FORWARD_SlASH + specPricObj.id;
            }
            //Added by Sindhu(Expanded view)
            pagereference pr;
            if(ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING)) {
                url = ConstantsUtil.ApttusPricingEV;
                redirect = true;
                pr = null;
            } else {
                pr = new pagereference(url);
            }
            return pr;
            //end 
        }catch(Exception excp){
            return null;
        }
    }
    
    /******************************************************************************************************************************
     * @Method Name       : cancel
     * @author            : 
     * @Last modified by  : 
     * @Last modified date: 
     * @Purpose           : Added by Sindhu(Expanded view)
     *******************************************************************************************************************************/
    public PageReference cancel() {
        try{
            if(ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING)) {
               String url = ConstantsUtil.ApttusPricingEV;
               redirect = true;
               return null;
            } else {
                return con.cancel();
            }   
        }catch(Exception excp){
            
            return null;
        }
    }
    
    /******************************************************************************************************************************
     * @Method Name       : changeYearMeth
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Method for assign value on year field onchange
     *******************************************************************************************************************************/
    Public void changeYearMeth(){
        try{
             specPricObj.year__c = yearval;
            
        }catch(Exception excp){
         ApexPages.addMessages(excp); 
            
        }
    }
           
}