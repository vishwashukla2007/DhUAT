/*********************************************************************************************
 * @ClassName         : SpecLegacyDrugLevelObj
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 02/08/2018
 * @Last modified by  : Sanket Saxena(Accenture)
 * @Last modified date: 02/08/2018
 * @Purpose           : This is the controller class for SpecLegacyDrugLevelNewEditPage
 **********************************************************************************************/
 public with sharing class SpecLegacyDrugLevelNewEditClass{
    Public Specialty_Legacy_Drug_Level_pricing__c SpecLegacyDrugLevelObj{get;set;} // Object declare for insert update
    Public Id SpecLegacyDrugLevelID{get;set;}  //For get the Record id
    Public Specialty_Operations__c SpecOpsObj{get;set;} // Object declare for Specialty Operation
    Public List<Client_Information__c> clintInfoList;  // for get the value of client Information
    Public set<string> checkClientYearCount;
    Public List<SelectOption> yearList{get;set;}
    public string yearval{get;set;}
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    
    /******************************************************************************************************************************
     * @Method Name       : SpecLegacyDrugLevelNewEditClass
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Constructor of the SpecLegacyDrugLevelNewEditClass
     *******************************************************************************************************************************/
    public SpecLegacyDrugLevelNewEditClass(ApexPages.StandardController controller) {
        
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        yearList = new List<SelectOption>();
        operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
        
        SpecLegacyDrugLevelObj = new Specialty_Legacy_Drug_Level_pricing__c();
        SpecLegacyDrugLevelID = ApexPages.currentPage().getParameters().get(ConstantsUtil.STRING_ID); //Get Id fo the record from URL
        Id specOpeId = ApexPages.currentPage().getParameters().get(Label.specOpIdInSpecLegacyDrugLevel); //Get Specialty Operation Id from URL 
        
        //If the record is new this condition will execute
        if(String.IsBlank(SpecLegacyDrugLevelID)){
            if(!String.IsBlank(specOpeId)){
                SpecOpsObj = [select id,Faf_Id__c from Specialty_Operations__c where id =: specOpeId];
                SpecLegacyDrugLevelObj.FAF_ID__c = SpecOpsObj.Faf_Id__c;
                SpecLegacyDrugLevelObj.Specialty_Ops__c = specOpeId;                           
            if(!(string.isBlank(SpecOpsObj.Faf_Id__c))){
                    //Query the associated client Information to populate the value in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from Client_Information__c where FAF_ID__c =:SpecOpsObj.Faf_Id__c limit 1];                    
                 }
                 if(!clintInfoList.isEmpty()){        //check weathed Client Info list is empty or not
                     if(!(string.isBlank(clintInfoList[0].year_1__c))){
                         yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));           //Populate empty value in Year field
                         yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
                         checkClientYearCount.add(clintInfoList[0].year_1__c);  // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_2__c))){   //for check value is not empty
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                         checkClientYearCount.add(clintInfoList[0].year_2__c);  // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_3__c))){   //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                         checkClientYearCount.add(clintInfoList[0].year_3__c);  // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_4__c))){    //for check value is not empty
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                         checkClientYearCount.add(clintInfoList[0].year_4__c);     // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_5__c))){      //for check value is not empty
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
                         checkClientYearCount.add(clintInfoList[0].year_5__c);   // associate value from client Information object
                     }
                 }
            }  
            }else{ // //In User edit a record then this condition will execute
        
            //Fetch Sepcialty Drug Level Pricing object info
            SpecLegacyDrugLevelObj = [select id,name, Specialty_Ops__c, FAF_ID__c,year__c,Path__c,Default_Rate__c,LOB__c,Dispensing_Fee__c,Pharmacy_Benefit__c,Price_List_Type__c,Additional_Speciality_Operations_Inf__c, Specialty_Ops__r.Faf_Id__c  from Specialty_Legacy_Drug_Level_pricing__c where id =: SpecLegacyDrugLevelID];           
                    if(!(string.isBlank(SpecLegacyDrugLevelObj.Specialty_Ops__r.Faf_Id__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                Client_Information__c where FAF_ID__c =:SpecLegacyDrugLevelObj.Specialty_Ops__r.Faf_Id__c];               
            }
            if(!clintInfoList.isEmpty()){
                if(!(string.isBlank(clintInfoList[0].year_1__c)))
                    // Associate the value of ClientInfoList year 1 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
                if(!(string.isBlank(clintInfoList[0].year_2__c)))
                    // Associate the value of ClientInfoList year 2 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                if(!(string.isBlank(clintInfoList[0].year_3__c)))
                    // Associate the value of ClientInfoList year 3 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                if(!(string.isBlank(clintInfoList[0].year_4__c)))
                    // Associate the value of ClientInfoList year 4 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                if(!(string.isBlank(clintInfoList[0].year_5__c)))
                    // Associate the value of ClientInfoList year 5 in year List to populate year Picklist in Edit case
                    yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
            }       
        }
    yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));
    }
    
    /******************************************************************************************************************************
     * @Method Name       : saveUpdatespecLegacyDrugLevel
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Method for save and update the record
     *******************************************************************************************************************************/
    public pagereference saveUpdatespecLegacyDrugLevel(){
        try{
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(SpecLegacyDrugLevelObj);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if(String.IsBlank(SpecLegacyDrugLevelID)){
                    insert SpecLegacyDrugLevelObj;  //Insert Sepcialty Drug Level Pricing
                }else{
                    update SpecLegacyDrugLevelObj;  //Update Sepcialty Drug Level Pricing
                }
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + SpecLegacyDrugLevelObj.id);
            }
             
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
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
            SpecLegacyDrugLevelObj.year__c = yearval;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }

}