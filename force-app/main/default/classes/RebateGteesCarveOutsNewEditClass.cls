/*********************************************************************************************
 * @ClassName         : RebateGteesCarveOutsNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27/06/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for RebateGteesCarveOutsNewEditPage         
 **********************************************************************************************/
public with sharing class RebateGteesCarveOutsNewEditClass{
    //public ApexPages.StandardController con;
    Public Rebate_Gtees_Specialty_Class_Carve_Outs__c rebCarOutObj{get;set;}   // Object declair for inswert update
    Public Rebate_Operations__c rebateOprObj{get;set;}   //Parent Object Declare
    Public Id rebCarOutID{get;set;}  //For get the Record id
    Public Boolean percentBool{get;set;}    //Boolean to decide which field to rerender on page
    Public List<SelectOption> yearList{get;set;}    //For bind the year value on page
    Public set<string> checkClientYearCount;    //for check year is present in Client share object or not
    Public List<Client_Information__c> clintInfoList; //Fetch the info of Client Information
    Public boolean validateRequiredFlag;
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    public boolean disaSpecFormulary {get;set;}
 /*********************************************************************************************
 Declare Constructor of the RebateGteesCarveOutsNewEditClass
 **********************************************************************************************/
 public RebateGteesCarveOutsNewEditClass(ApexPages.StandardController controller) {
         validateRequiredFlag = false;
         disaSpecFormulary = false;
         operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
        rebCarOutObj = new Rebate_Gtees_Specialty_Class_Carve_Outs__c();
        rebateOprObj = new Rebate_Operations__c();
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        yearList = new List<SelectOption>();
        rebCarOutID = ApexPages.currentPage().getParameters().get('id');
        Id rebOpIdID = ApexPages.currentPage().getParameters().get(Label.RebateCarveOutCustLab); 
        percentBool = true;
        //If the record is new this condition will execute
        if(rebCarOutID == null){
            if(rebOpIdID != null){
                //query the client associated Rebate operation Info for 
                rebateOprObj = [select id, FAF_ID__c, Specialty_Formulary_Option__c, Class_Carve_Out_Guarantee_Percentage__c 
                from Rebate_Operations__c where id =:rebOpIdID];
                rebCarOutObj.FAF_Id__c = rebateOprObj.FAF_ID__C;  
                rebCarOutObj.Rebate_Operations__c = rebOpIdID;    
                percentBool = rebateOprObj.Class_Carve_Out_Guarantee_Percentage__c;
                // Set Speciality Formulary based on Speciality Formulary option on RebateOps PT US231B by Sneha Inturi
                if(!(rebateOprObj.Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE)){
                  rebCarOutObj.Specialty_Formulary__c =  rebateOprObj.Specialty_Formulary_Option__c;
                  disaSpecFormulary = true;
                }
                if(!(string.isBlank(rebateOprObj.FAF_ID__C))){
                    //Query the associated client Information to populate the value in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                     Client_Information__c where FAF_ID__c =:rebateOprObj.FAF_ID__c limit 1];
                 }
                 //clintInfoList is blank or not
                 if(!clintInfoList.isEmpty()){
                     if(!(string.isBlank(clintInfoList[0].year_1__c))){
                         yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));      //Populate empty value in Year field
                         yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
                         checkClientYearCount.add(clintInfoList[0].year_1__c);   // associate value from client Information object
                     }
                     //check year 2 field in Client information is blank
                     if(!(string.isBlank(clintInfoList[0].year_2__c))){     //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK,ConstantsUtil.BLANK));    //Populate empty value in Year field
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                         checkClientYearCount.add(clintInfoList[0].year_2__c);    // associate value from client Information object
                     }
                     //check year 3 field in Client information is blank
                     if(!(string.isBlank(clintInfoList[0].year_3__c))){      //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));      //Populate empty value in Year field
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                         checkClientYearCount.add(clintInfoList[0].year_3__c);     // associate value from client Information object
                     }
                     //check year 4 field in Client information is blank
                     if(!(string.isBlank(clintInfoList[0].year_4__c))){       //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));     //Populate empty value in Year field
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                         checkClientYearCount.add(clintInfoList[0].year_4__c);     // associate value from client Information object
                     }
                     //check year 5 field in Client information is blank
                     if(!(string.isBlank(clintInfoList[0].year_5__c))){       //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));     //Populate empty value in Year field
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
                         checkClientYearCount.add(clintInfoList[0].year_5__c);  // associate value from client Information object
                     }
                 }
            }
        }else{ // //In User edit a record then this condition will execute
            //Fetch Rebate Operation object info to check Carve out Guarantee Check box is true or false
            rebCarOutObj = [select id, name, Drug_Therapy_Class_2__c, Plan_Design__c, Specialty_Formulary__c, FAF_ID__c, Link__c, LOB2__c, Rebate_Operations__c,
            Specialty_Dollar_Amount__c, Specialty_Percentage_Amount__c, Specialty_Retail_Dollar_Amt__c, 
            Specialty_Retail_Percentage_Amount__c, Year__c, Rebate_Operations__r.Class_Carve_Out_Guarantee_Percentage__c,Rebate_Operations__r.Specialty_Formulary_Option__c 
            from Rebate_Gtees_Specialty_Class_Carve_Outs__c where id =: rebCarOutID];
            // Set Speciality Formulary based on Speciality Formulary option on RebateOps PT US231B by Sneha Inturi
                if(!(rebCarOutObj.Rebate_Operations__r.Specialty_Formulary_Option__c == ConstantsUtil.CLIENT_CHOICE)){
                  rebCarOutObj.Specialty_Formulary__c =  rebCarOutObj.Rebate_Operations__r.Specialty_Formulary_Option__c;
                  disaSpecFormulary = true;
                }
            /**end***/
            percentBool = rebCarOutObj.Rebate_Operations__r.Class_Carve_Out_Guarantee_Percentage__c;
            if(!(string.isBlank(rebCarOutObj.FAF_ID__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                Client_Information__c where FAF_ID__c =:rebCarOutObj.FAF_ID__c];
            }
            if(!clintInfoList.isEmpty()){
                if(!(string.isBlank(clintInfoList[0].year_1__c)))
                    yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c)); // Associate the value of ClientInfoList year 1 in year List to populate year Picklist in Edit case
                if(!(string.isBlank(clintInfoList[0].year_2__c)))
                    yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c)); // Associate the value of ClientInfoList year 2 in year List to populate year Picklist in Edit case
                if(!(string.isBlank(clintInfoList[0].year_3__c)))
                    yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c)); // Associate the value of ClientInfoList year 3 in year List to populate year Picklist in Edit case
                if(!(string.isBlank(clintInfoList[0].year_4__c)))
                    yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c)); // Associate the value of ClientInfoList year 4 in year List to populate year Picklist in Edit case
                if(!(string.isBlank(clintInfoList[0].year_5__c)))
                    yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c)); // Associate the value of ClientInfoList year 5 in year List to populate year Picklist in Edit case
            }
        }
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));
    }
    
    
/*********************************************************************************************
 Method for save and update the record
 **********************************************************************************************/
     public pagereference saveUpdaterebCarOutObj(){
        try{
            validateRequiredFlag = false; // flag set to false initially but if any error message conditions are satisfied then will be set to true to prevent user from saving record
            pagereference pr;
            if(percentBool){ //Check flag in Rebate Operation is true
                rebCarOutObj.Specialty_Retail_Dollar_Amt__c = null; 
                rebCarOutObj.Specialty_Dollar_Amount__c = null;
                 // Error message for Mail percentage field
            
            if(string.isBlank(string.valueof(rebCarOutObj.Specialty_Percentage_Amount__c )) && string.isBlank(string.valueof(rebCarOutObj.Specialty_Retail_Percentage_Amount__c ))){
             ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, ConstantsUtil.REBATE_PERCENTAGE_REQD );
             ApexPages.addMessage(myMsg2);
             validateRequiredFlag = true;                 
             }
            }else{ //Check flag in Rebate Operation is false
                rebCarOutObj.Specialty_Retail_Percentage_Amount__c = null;
                rebCarOutObj.Specialty_Percentage_Amount__c = null;
             if(string.isBlank(string.valueof(rebCarOutObj.Specialty_Dollar_Amount__c )) && string.isBlank(string.valueof(rebCarOutObj.Specialty_Retail_Dollar_Amt__c ))){              
             ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, ConstantsUtil.REBATE_DOLLAR_REQD );
             ApexPages.addMessage(myMsg2);
             validateRequiredFlag = true;                 
             }
            }
        if(!validateRequiredFlag){
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(rebCarOutObj);
                 insert cloneSObj;
                 pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }else{
        
        
                if(rebCarOutID == null){
                    rebCarOutObj.Required_Validation_Bool__c = false;
                    insert rebCarOutObj;   //Insert record
                     pr = new pagereference(ConstantsUtil.FORWARD_SlASH + rebCarOutObj.id);
                }else{
                    rebCarOutObj.Required_Validation_Bool__c = false;
                    update rebCarOutObj;    //Update Record
                    pr = new pagereference(ConstantsUtil.FORWARD_SlASH + rebCarOutObj.id);  
                } 
            }
        }
        
        else{return null;}                
        return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }
}