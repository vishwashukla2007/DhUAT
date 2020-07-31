/* =============================================================================================================
 * @Class Name        : RebateguaranteeNewEditClass
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for RebateguaranteeNewEditPage
================================================================================================================*/
public without sharing class RebateguaranteeNewEditClass {
    Public Rebate_Guarantees__c Rguarantees{get;set;}  // To bind the Rebate Guarantees Object 
    public string typeStr{get;set;}
    Public Boolean condition{get;set;}              // To restrict user from creating record when rebate offering type is split only
    Public Rebate_operations__c rOperations{get;set;} // To store the value of Rebate Operation
    Public Id rGuaranteeID{get;set;}           // To store the id of Rebate Guarantees Object
    public Boolean perguaranteeFlag{get;set;} // Flag used to set values in enablePercentage and enableDollar booleans
    public Boolean dolspecRetailFlag{get;set;} // Flag used for mirroring functionality
    public Boolean dolretail90Flag{get;set;} // Flag used for mirroring functionality
    public Boolean dolmChoiceFlag{get;set;} // Flag used for mirroring functionality
    Public Boolean enablePercentage{get;set;}  // Flag used to hide percentage fields
    Public Boolean enableDollar{get;set;} // Flag used to hide dollar fields
    Public List<Client_Information__c> clintInfoList; // To store the year list from Client Information Object
    Public set<string> checkClientYearCount;
    Public List<SelectOption> yearList{get;set;}
    // Public List<SelectOption> plandesignList{get;set;} //Akanksha 13 Aug - defect fix for alm 3861 and 3881
    Public boolean validateRequiredFlag;
    // Public string nonspecialtyFormulary{get;set;} //Akanksha 13 Aug - defect fix for alm 3861 and 3881
    //Sridevi 20 Aug - For expanded view
    public boolean isExpandableView {get;set;}
    public boolean disableNonSpecFormulary {get;set;}
    public boolean disableSpecFormulary {get;set;}
    public boolean disableGSTP {get;set;}
    public string urlString {get;set;} 
    public string rebateOprId1 {get;set;} //Added on 08.23.18 by Sridevi for Expanded View
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionalit
    
    public boolean rebateOpsSPMR30{get;set;}
/* =============================================================================================================
 Constructor class for Rebate Guarantees     
================================================================================================================*/
    public RebateguaranteeNewEditClass(ApexPages.StandardController controller) {
    
     operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
     
      //Added on 08.23.18 by Sridevi for Expanded View
      
        if( ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.EXPANDABLEVIEW ) 
                && ApexPages.currentPage().getParameters().get(ConstantsUtil.EXPANDABLEVIEW ) == 'true' )
        {
            isExpandableView = true;
        }
        else isExpandableView = false;
        
        dolspecRetailFlag=true;
        disableNonSpecFormulary = false;
        disableSpecFormulary = false;
        disableGSTP = false;
        validateRequiredFlag = false;
        Rguarantees = new Rebate_Guarantees__c();
        rOperations = new Rebate_operations__c();
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        yearList = new List<SelectOption>();
       // plandesignList = new List<SelectOption>(); 
      //  plandesignList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None)); //Akanksha 13 Aug - defect fix for alm 3861 and 3881
      
        rGuaranteeID = ApexPages.currentPage().getParameters().get('id');
        Id rebateOprId = ApexPages.currentPage().getParameters().get(Label.rebateGuaranteerOperations);

// If condition invoked when creating new rebate guarantee record                  
        if(rGuaranteeID == null){ 
        if(rebateOprId != null){        
            rOperations = [Select id,FAF_ID__c,FAF_ID__r.Client_Info__c,GSTP_Option__c,Non_Specialty_Formulary_Option__c,Specialty_Formulary_Option__c,name,Rebate_Contract_Type__c,Percentage_Guarantee__c,Rebate_Offering_Type__c,Specialty_Rebate_Offering_Type__c,Specialty_Retail_Mirror_Retail_30__c,Retail_90_Mirror_Retail_30__c,MChoice_Mirror_Mail__c from Rebate_operations__c where id =:rebateOprId];
            
            rebateOprId1 = rebateOprId; //Added on 08.23.18 by Sridevi for Expanded View
            Rguarantees.Rebate_Operations__c = rebateOprId;
            Rguarantees.FAF_ID__c = rOperations.FAF_ID__c; 
            
            rebateOpsSPMR30=rOperations.Specialty_Retail_Mirror_Retail_30__c;
            //Product backlog req # 1514
          //  if(!string.isBlank(rOperations.Non_Specialty_Formulary_Option__c)){
            if(!(rOperations.Non_Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE)){
            Rguarantees.Non_Specialty_Formulary_2__c = rOperations.Non_Specialty_Formulary_Option__c;
            disableNonSpecFormulary = true;
            }
        //    }
            //AS 16 Aug- Defect fix 3969
        //    if(!string.isBlank(rOperations.Specialty_Formulary_Option__c)){
            if(!(rOperations.Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE)){
            Rguarantees.Specialty_Formulary__c =  rOperations.Specialty_Formulary_Option__c;
            disableSpecFormulary = true;
        //    }
            }
            
            if(!(rOperations.GSTP_Option__c == ConstantsUtil.CHOICE)){
            Rguarantees.GSTP__c = rOperations.GSTP_Option__c;
            disableGSTP = true;
            }
            //dolspecRetailFlag = rOperations.Specialty_Retail_Mirror_Retail_30__c;
            dolretail90Flag = rOperations.Retail_90_Mirror_Retail_30__c;
            dolmChoiceFlag = rOperations.MChoice_Mirror_Mail__c;
            perguaranteeFlag = rOperations.Percentage_Guarantee__c;
            
             //Akanksha 13 Aug - defect fix for alm 3861 and 3881
             /*
            if(!string.isBlank(rOperations.Non_Specialty_Formulary_Option__c)){          
            if(rOperations.Non_Specialty_Formulary_Option__c.equals(ConstantsUtil.VALUE_FORMULARY_STAND) || rOperations.Non_Specialty_Formulary_Option__c.equals(ConstantsUtil.VALUE_FORMULARY_INCENT)){
             plandesignList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
             plandesignList.add(new SelectOption(ConstantsUtil.CLOSED, ConstantsUtil.CLOSED));
            }else{
            plandesignList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
            plandesignList.add(new SelectOption(ConstantsUtil.TIERQ, ConstantsUtil.TIERQ));
            plandesignList.add(new SelectOption( ConstantsUtil.TIER_NQ, ConstantsUtil.TIER_NQ));
            plandesignList.add(new SelectOption(ConstantsUtil.TIER_Q, ConstantsUtil.TIER_Q));
            plandesignList.add(new SelectOption(ConstantsUtil.CLOSED, ConstantsUtil.CLOSED));
            }
            }else{
            plandesignList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
            plandesignList.add(new SelectOption(ConstantsUtil.TIERQ, ConstantsUtil.TIERQ));
            plandesignList.add(new SelectOption( ConstantsUtil.TIER_NQ, ConstantsUtil.TIER_NQ));
            plandesignList.add(new SelectOption(ConstantsUtil.TIER_Q, ConstantsUtil.TIER_Q));
            plandesignList.add(new SelectOption(ConstantsUtil.CLOSED, ConstantsUtil.CLOSED));
            }
          */  
            if(!(string.isBlank(rOperations.FAF_ID__C))){
            clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
            Client_Information__c where FAF_ID__c =:rOperations.FAF_ID__c limit 1];
            }               
         if(!clintInfoList.isEmpty()){ //check whether Client Info list is empty or not
            if(!(string.isBlank(clintInfoList[0].year_1__c))){
             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK)); //Populate empty value in Year field
             yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
             checkClientYearCount.add(clintInfoList[0].year_1__c); // associate value from client Information object
            }
            if(!(string.isBlank(clintInfoList[0].year_2__c))){ //for check value is not empty 
             if(checkClientYearCount.isEmpty()){
             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));
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
             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));
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
         }
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));
       
   }else{}
 }else if(rGuaranteeID != null){ // To check for an existing guarantee record
    Rguarantees = [select id, name,FAF_ID__c ,Rebate_Operations__c,Rebate_Operations__r.FAF_ID__r.Client_Info__c,Basis__c,Client_Owned_30__c,Client_Owned_30_1__c,Client_Owned_90__c,Client_Owned_90_1__c,Client_Share__c,Exclude_Rebate_Class__c,
     GSTP__c,Link__c,LOB2__c,Mail__c,Mail_1__c,Mchoice__c,Mchoice_1__c,Non_Specialty_Formulary_2__c,Percentage_Basis__c,Plan_Design__c,Retail_30__c,Retail_30_1__c,
     Retail_90__c,Retail_90_1__c,Select_Specialty_Therapy_Class_es_2__c,Specialty__c,Specialty_1__c,Specialty_Formulary__c,Specialty_Retail__c,Specialty_Retail_1__c,Year__c from Rebate_Guarantees__c where id =:rGuaranteeID];
                 
     rOperations = [Select id,FAF_ID__c,Non_Specialty_Formulary_Option__c,Specialty_Formulary_Option__c,name,Rebate_Contract_Type__c,Rebate_Offering_Type__c,Percentage_Guarantee__c,Specialty_Retail_Mirror_Retail_30__c,Retail_90_Mirror_Retail_30__c,MChoice_Mirror_Mail__c,GSTP_Option__c,Specialty_Rebate_Offering_Type__c from Rebate_operations__c where id =:Rguarantees.Rebate_Operations__c];
     rebateOprId1 = rOperations.Id; //Added on 08.23.18 by Sridevi for Expanded View
     //dolspecRetailFlag = rOperations.Specialty_Retail_Mirror_Retail_30__c;
     dolretail90Flag = rOperations.Retail_90_Mirror_Retail_30__c;
     dolmChoiceFlag = rOperations.MChoice_Mirror_Mail__c;
     perguaranteeFlag = rOperations.Percentage_Guarantee__c;
     
     rebateOpsSPMR30=rOperations.Specialty_Retail_Mirror_Retail_30__c;
     
     //set Specialty Retail value based on Rops Specialty Retail Mirror Retail 30 
     if(rebateOpsSPMR30){
         Rguarantees.Specialty_Retail_1__c=Rguarantees.Retail_30_1__c;
         Rguarantees.Specialty_Retail__c=Rguarantees.Retail_30__c;
     }
     else{
         Rguarantees.Specialty_Retail_1__c=Rguarantees.Specialty_1__c;
         Rguarantees.Specialty_Retail__c=Rguarantees.Specialty__c;
     }
     
    // nonspecialtyFormulary = Rguarantees.Non_Specialty_Formulary_2__c; //Akanksha 13 Aug - defect fix for alm 3861 and 3881
    //Product backlog req # 1514
    //if(!string.isBlank(rOperations.Non_Specialty_Formulary_Option__c)){
        if(!(rOperations.Non_Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE)){
        Rguarantees.Non_Specialty_Formulary_2__c = rOperations.Non_Specialty_Formulary_Option__c;
        disableNonSpecFormulary = true;
        }
    //}
    //if(!string.isBlank(rOperations.Specialty_Formulary_Option__c)){
        if(!(rOperations.Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE)){
        Rguarantees.Specialty_Formulary__c =  rOperations.Specialty_Formulary_Option__c;
        disableSpecFormulary = true;
        }
    //}  

        if(!(rOperations.GSTP_Option__c == ConstantsUtil.CHOICE)){
        Rguarantees.GSTP__c = rOperations.GSTP_Option__c;
        disableGSTP = true;
        }
    // changeplanDesign(); //Akanksha 13 Aug - defect fix for alm 3861 and 3881
     
    if(!(string.isBlank(Rguarantees.Rebate_Operations__r.FAF_ID__c))){
        clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
        Client_Information__c where FAF_ID__c =:Rguarantees.Rebate_Operations__r.FAF_ID__c];
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
     }   
    if( rOperations.Rebate_Offering_Type__c.equals(ConstantsUtil.GUARANTEE_ONLY) || 
    rOperations.Rebate_Offering_Type__c.equals(ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE) ||
    rOperations.Rebate_Offering_Type__c.equals(ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER) ||
  // Add Specialty Rebate offering type for user to create RG - PT US260B by Sneha inturi.
     ( rOperations.Rebate_Offering_Type__c.equals(ConstantsUtil.SPLIT_TYPE) && 
        (  rOperations.Specialty_Rebate_Offering_Type__c == ConstantsUtil.GUARANTEE_ONLY ||
           rOperations.Specialty_Rebate_Offering_Type__c == ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE ||
           rOperations.Specialty_Rebate_Offering_Type__c == ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER))){    
    condition = false;   // When Rebate offering Type is not Split only then user can create a new rebate guarantee,hence setting condition flag as false
    if(perguaranteeFlag){ // percentage flag on rebate operation is false,hence dollar fields will be visible
       enablePercentage = false; // To show percentage fields
       enableDollar = true;   // To hide dollar fields 
       Rguarantees.Client_Owned_30__c = null;
       Rguarantees.Client_Owned_90__c = null;
       Rguarantees.Mail__c = null;
       Rguarantees.Mchoice__c = null;
       Rguarantees.Retail_30__c = null;
       Rguarantees.Retail_90__c = null;
       Rguarantees.Specialty__c = null; 
       Rguarantees.Specialty_Retail__c = null;

    }else{
       enablePercentage = true;   // To hide percentage fields  
       enableDollar = false;      // To show dollar fields 
       Rguarantees.Client_Owned_30_1__c = null;
       Rguarantees.Client_Owned_90_1__c = null;
       Rguarantees.Mail_1__c = null;
       Rguarantees.Mchoice_1__c = null;
       Rguarantees.Retail_30_1__c = null;
       Rguarantees.Retail_90_1__c = null;
       Rguarantees.Specialty_1__c = null;
       Rguarantees.Specialty_Retail_1__c = null;
     }
   }else if(rOperations.Rebate_Offering_Type__c.equals(ConstantsUtil.SPLIT_TYPE) && 
   // Add Specialty Rebate offering type for user not to create RG - PT US260A by Sneha inturi.
    (rOperations.Specialty_Rebate_Offering_Type__c==null || rOperations.Specialty_Rebate_Offering_Type__c=='' || rOperations.Specialty_Rebate_Offering_Type__c.equals(ConstantsUtil.SPLIT_TYPE))){              
    condition = true;  // When Rebate offering Type is Split only then user cannot create a new rebate guarantee,hence setting condition flag as true
    enablePercentage = true;
    enableDollar = true;
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ConstantsUtil.REBATE_GUARANTEE_ERROR1);
    ApexPages.addMessage(myMsg);
    }else{}                               
}
/* =============================================================================================================
 Akanksha 13 Aug - defect fix for alm 3861 and 3881  
================================================================================================================*/
    /*
   public void changeplanDesign(){
        try{
            plandesignList = new List<SelectOption>();
            //plandesignList.add(new SelectOption(ConstantsUtil.BLANK , ConstantsUtil.None));
        
            if(!string.isBlank(rOperations.Non_Specialty_Formulary_Option__c) && !string.isBlank(nonspecialtyFormulary)){
                if(rOperations.Non_Specialty_Formulary_Option__c.equals(ConstantsUtil.VALUE_FORMULARY_STAND) || rOperations.Non_Specialty_Formulary_Option__c.equals(ConstantsUtil.VALUE_FORMULARY_INCENT) || 
                (rOperations.Non_Specialty_Formulary_Option__c.equals(ConstantsUtil.CLIENT_CHOICE) && (nonspecialtyFormulary.equals(ConstantsUtil.VALUE_FORMULARY_STAND) || nonspecialtyFormulary.equals(ConstantsUtil.VALUE_FORMULARY_INCENT)))){
                     plandesignList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                     plandesignList.add(new SelectOption(ConstantsUtil.CLOSED, ConstantsUtil.CLOSED));
                }else{
                    plandesignList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                    plandesignList.add(new SelectOption(ConstantsUtil.TIERQ, ConstantsUtil.TIERQ));
                    plandesignList.add(new SelectOption(ConstantsUtil.TIER_NQ, ConstantsUtil.TIER_NQ));
                    plandesignList.add(new SelectOption(ConstantsUtil.TIER_Q, ConstantsUtil.TIER_Q));
                    plandesignList.add(new SelectOption(ConstantsUtil.CLOSED, ConstantsUtil.CLOSED));
                }
            }else{
                plandesignList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.NONE));
                plandesignList.add(new SelectOption(ConstantsUtil.TIERQ, ConstantsUtil.TIERQ));
                plandesignList.add(new SelectOption(ConstantsUtil.TIER_NQ, ConstantsUtil.TIER_NQ));
                plandesignList.add(new SelectOption(ConstantsUtil.TIER_Q, ConstantsUtil.TIER_Q));
                plandesignList.add(new SelectOption(ConstantsUtil.CLOSED, ConstantsUtil.CLOSED));
            }
        }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}     
    }
    */
    
/* =============================================================================================================
 This save method is calles when user clicks on the save button
================================================================================================================*/
    public pagereference saveUpdateRec(){                   
        try{
            
        validateRequiredFlag = false; // flag set to false initially but if any error message conditions are satisfied then will be set to true to prevent user from saving record
          pagereference pr;
   
        if( !enablePercentage){
        // Error message for Mail percentage field
         if(string.isBlank(string.valueof(Rguarantees.Mail_1__c)) && string.isBlank(string.valueof(Rguarantees.Mchoice_1__c)) && string.isBlank(string.valueof(Rguarantees.Specialty_1__c)) &&
         string.isBlank(string.valueof(Rguarantees.Specialty_Retail_1__c)) && string.isBlank(string.valueof(Rguarantees.Client_Owned_30_1__c)) && string.isBlank(string.valueof(Rguarantees.Client_Owned_90_1__c)) && string.isBlank(string.valueof(Rguarantees.Retail_30_1__c)) &&
         string.isBlank(string.valueof(Rguarantees.Retail_90_1__c))){
         ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, ConstantsUtil.REBATE_PERCENTAGE_REQD);
         ApexPages.addMessage(myMsg2);
         validateRequiredFlag = true;                 
         }
      
         }else if( !enableDollar){ 
      
         if(string.isBlank(string.valueof(Rguarantees.Mail__c)) && string.isBlank(string.valueof(Rguarantees.Mchoice__c)) && 
         string.isBlank(string.valueof(Rguarantees.Specialty_Retail__c)) &&
         string.isBlank(string.valueof(Rguarantees.Retail_30__c)) && string.isBlank(string.valueof(Rguarantees.Retail_90__c)) && string.isBlank(string.valueof(Rguarantees.Client_Owned_90__c)) && string.isBlank(string.valueof(Rguarantees.Client_Owned_30__c)) &&
         string.isBlank(string.valueof(Rguarantees.Specialty__c))){
         ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, ConstantsUtil.REBATE_DOLLAR_REQD);
         ApexPages.addMessage(myMsg2);
         validateRequiredFlag = true;                 
         }
        }       
        if( !validateRequiredFlag){
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(Rguarantees);
                /** US 173 START***/
                if(rOperations.Specialty_Retail_Mirror_Retail_30__c){cloneSObj.put('Specialty_Retail__c',Rguarantees.Specialty__c);}
                if(rOperations.Retail_90_Mirror_Retail_30__c){cloneSObj.put('Retail_90__c',Rguarantees.Retail_30__c);}
                if(rOperations.MChoice_Mirror_Mail__c){cloneSObj.put('Mchoice__c',Rguarantees.Mail__c);}
                /***US 173 END**/
                 insert cloneSObj;
                 pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{ 
                if(rOperations.Percentage_Guarantee__c == true){
                   /* if(rOperations.Specialty_Retail_Mirror_Retail_30__c == true){
                        Rguarantees.Specialty_Retail_1__c = Rguarantees.Specialty_1__c;
                    }*/
                    if(rOperations.Retail_90_Mirror_Retail_30__c == true){
                        Rguarantees.Retail_90_1__c = Rguarantees.Retail_30_1__c;
                    }
                    if(rOperations.Mchoice_Mirror_Mail__c == true){
                        Rguarantees.Mchoice_1__c = Rguarantees.Mail_1__c;
                    }
                }else{
                    /*if(rOperations.Specialty_Retail_Mirror_Retail_30__c == true){
                        Rguarantees.Specialty_Retail__c = Rguarantees.Specialty__c;
                    }*/
                    if(rOperations.Retail_90_Mirror_Retail_30__c == true){
                        Rguarantees.Retail_90__c = Rguarantees.Retail_30__c;
                    }
                    if(rOperations.Mchoice_Mirror_Mail__c == true){
                        Rguarantees.Mchoice__c = Rguarantees.Mail__c;
                    }
                }
                if(rGuaranteeID == null ){                  
                insert Rguarantees;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + Rguarantees.id);
                //Added on 08.23.18 by Sridevi for Expanded View
                if( isExpandableView ){
                  urlString = ConstantsUtil.SLASH+rebateOprId1;
                  return null;   
                } 
                }
                 else{
                update Rguarantees;
                pr = new pagereference(ConstantsUtil.SLASH + Rguarantees.id);
                //Added on 08.23.18 by Sridevi for Expanded View
                if( isExpandableView ){
                  urlString = ConstantsUtil.SLASH+rebateOprId1;
                  return null;  
                } 
                }
            }
      }
      else
      
      {return null;}          
      
      return pr;
    }catch(Exception excp){
        ApexPages.addMessages(excp);
        return null;
    }
    }
}