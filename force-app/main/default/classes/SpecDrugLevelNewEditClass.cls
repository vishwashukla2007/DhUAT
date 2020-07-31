/*********************************************************************************************
 * @ClassName         : SpecDrugLevelNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 02/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 02/08/2018
 * @Purpose           : This is the controller class for SpecDrugLevelNewEditPage
 **********************************************************************************************/
public with sharing class SpecDrugLevelNewEditClass{
    //public ApexPages.StandardController con;
    Public Specialty_Drug_Level_Pricing__c specDrugLevelObj{get;set;} // Object declair for insert update
    Public Id specDrugLevelID{get;set;}  //For get the Record id
    Public List<Client_Information__c> clintInfoList;    // for get the value of client Information
    Public List<SelectOption> yearList{get;set;}     // for populate the year in dropdown
    Public set<string> checkClientYearCount; 
    Public boolean phBenReq{get;set;}
    public Boolean macValBool{get; set;}
    public Boolean rateReqBool{get; set;}
    public string yearval{get;set;}
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    
    /*********************************************************************************************
     * @Method Name       : saveUpdateSpecDrugLevel
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Constructor of the SpecDrugLevelNewEditClass
     **********************************************************************************************/
    public SpecDrugLevelNewEditClass(ApexPages.StandardController controller) {
        specDrugLevelObj = new Specialty_Drug_Level_Pricing__c();
         operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
        yearList = new List<SelectOption>();
        phBenReq = false; 
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        specDrugLevelID = ApexPages.currentPage().getParameters().get(ConstantsUtil.STRING_ID);    //Get Id fo the record from URL
        Id specOpsId = ApexPages.currentPage().getParameters().get(Label.SpecOpsOnDrugLevelLabel);   //Get Speciality operation Id from URL
        //If the record is new this condition will execute
        if(String.IsBlank(specDrugLevelID)){
            if(!String.IsBlank(specOpsId)){
                Specialty_Operations__c specOpsObj = [select id, FaF_Id__c,Pharmacy_Benefit__c from Specialty_Operations__c where id=: specOpsId];
                specDrugLevelObj.Faf_Id__c = specOpsObj.FaF_Id__C;
                specDrugLevelObj.Specialty_Operations__c = specOpsId;
                if(!string.isBlank(specOpsObj.Pharmacy_Benefit__c)){
                if(!specOpsObj.Pharmacy_Benefit__c.equals(ConstantsUtil.CLIENT_CHOICE)){
                specDrugLevelObj.Pharmacy_Benefit__c = specOpsObj.Pharmacy_Benefit__c;
                phBenReq = true;
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
                macValBool = false;
                enabledisableRateMeth();
              //  pharBeneEnabDisbMeth(specOpsId);
            }
        }else{   //In User edit a record then this condition will execute
        
            //Fetch Specialty Operation object info
            specDrugLevelObj = [select id, name, FAF_ID__c, Year__c, Pharmacy_Benefit__c, Drug_Therapy__c, LOB__c, Drug_Name__c,
            Drug_Type__c, MAC__c, Rate__c, Specialty_Operations__c, Specialty_Operations__r.FAF_ID__c from Specialty_Drug_Level_Pricing__c where id =: specDrugLevelID];
            macValBool = specDrugLevelObj.MAC__c;
            enabledisableRateMeth();
            if(!(string.isBlank(specDrugLevelObj.Specialty_Operations__r.FAF_ID__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Pricing_Effective_Date__c from
                Client_Information__c where FAF_ID__c =:specDrugLevelObj.Specialty_Operations__r.FAF_ID__c];
            }
            
            Specialty_Operations__c specOpsObj = [select id, FaF_Id__c,Pharmacy_Benefit__c from Specialty_Operations__c where id=: specDrugLevelObj.Specialty_Operations__c];
             if(!string.isBlank(specOpsObj.Pharmacy_Benefit__c)){
             if(!specOpsObj.Pharmacy_Benefit__c.equals(ConstantsUtil.CLIENT_CHOICE)){
                specDrugLevelObj.Pharmacy_Benefit__c = specOpsObj.Pharmacy_Benefit__c;
                phBenReq = true;
                }
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
         //   pharBeneEnabDisbMeth(specDrugLevelObj.Specialty_Operations__c);
        }
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL)); // Add ConstantsUtil.ALL value in year dropdown
    }
    
    /*********************************************************************************************
     * @Method Name       : saveUpdateSpecDrugLevel
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Method for save and update the recoed
     **********************************************************************************************/
    public pagereference saveUpdateSpecDrugLevel(){
        try{
        pagereference pr;
            system.debug(specDrugLevelID+'========specDrugLevelObj=========='+specDrugLevelObj);
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(specDrugLevelObj);
                insert cloneSObj;
                 pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if(String.IsBlank(specDrugLevelID)){
                        insert specDrugLevelObj;  //Insert Specialty Pricing
                }else{
                        update specDrugLevelObj;  //Update Specialty Pricing
                }
                 pr = new pagereference(ConstantsUtil.FORWARD_SlASH + specDrugLevelObj.id);
            }
           
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            system.debug('===========excp======'+excp);
            return null;
        }
    }
    
    /*
    Commenting as per the SRP change in I8
    ********************************************************************************************
     * @Method Name       : pharBeneEnabDisbMeth
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Method Used to enable disable the Pharmacy Benefit field and set it Null/False in case of disable
     *********************************************************************************************
    Public void pharBeneEnabDisbMeth(Id recId){
        try{
            Specialty_Operations__c spOpr = [select id, pharmacy_Benefit__c from Specialty_Operations__c where id =: recId];
            if(spOpr.pharmacy_Benefit__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE)){
                phBenReq = false;
            }else if(spOpr.pharmacy_Benefit__c.equalsIgnoreCase(ConstantsUtil.exec_Retail_Lock) || spOpr.pharmacy_Benefit__c.equalsIgnoreCase(ConstantsUtil.const_None) ||
             spOpr.pharmacy_Benefit__c.equalsIgnoreCase(ConstantsUtil.open) || spOpr.pharmacy_Benefit__c.equalsIgnoreCase(ConstantsUtil.Preferred)){
                phBenReq = true;
                specDrugLevelObj.pharmacy_Benefit__c = null;
            }
        }catch(Exception excp){
            system.debug('===========excp======'+excp);
            ApexPages.addMessages(excp);
        }
    }*/
    
    /*********************************************************************************************
     * @Method Name       : enabledisableRateMeth
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Method Used to enable disable the Rate field and set it Null/False in case of disable
     **********************************************************************************************/
    Public void enabledisableRateMeth(){
        try{
            if(macValBool){
                rateReqBool = true;
               specDrugLevelObj.Rate__C= null;
            }else {
                rateReqBool = false;
            }
        }catch(Exception excp){
            system.debug('===========excp======'+excp);
            ApexPages.addMessages(excp);
        }
    }
    
    /*********************************************************************************************
     * @Method Name       : changeYearMeth
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 18/08/2018
     * @Purpose           : Method used to assign year Value in the field
     **********************************************************************************************/
    Public void changeYearMeth(){
        try{
            specDrugLevelObj.year__c = yearval;
        }catch(Exception excp){
            system.debug('===========excp======'+excp);
            ApexPages.addMessages(excp);
        }
    }
           
}