/************************************************************************************************
 * @Class Name        : BillingAdministrativeFeesNewEditClass
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 04 07 2018
 * @Last modified by  : Priyanka Goyal(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for BillingAdministrativeFeesNewEditPage
**************************************************************************************************/ 
public with sharing class BillingAdministrativeFeesNewEditClass {
    Public Billing_Administrative_Fees__c baf{get;set;} // Object declair for insert update
    Public Billing_Operations__c billingOpsObj{get;set;} // Declare parent Object 
    Public List<Client_Information__c> clintInfoList;  // for get the value of client Information
    Public set<string> checkClientYearCount;
    Public Id bafID{get;set;}       //For get the Record id   
    Public List<SelectOption> yearList{get;set;}
    Public String feeTypeStr{get;set;}
    Public Boolean rebateRTMDBool{get;set;} //to check whether realated rebate RTMD is checked
    Public List<Rebate_Operations__c> roList;  //to get the rebate operations List
    Public Boolean feeAdditiveValue{get;set;} //to assign additive checkbox value
    Public List<Billing_Broker_TPA_Payments__c> broTPAList;   //to get the Broker TPA List
    Public Boolean BrokerTPAExist{get;set;}    //to check whether realated Broker TPA Exist 
    public string yearval{get;set;}
    public String operationType;
    
    /******************************************************************************************************************************
     * @Method Name       : BillingAdministrativeFeesNewEditClass
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 25/07/2018
     * @Purpose           : BillingAdministrativeFeesNewEditClass
    *******************************************************************************************************************************/
    public BillingAdministrativeFeesNewEditClass(ApexPages.StandardController controller) {
        feeAdditiveValue = false;
        BrokerTPAExist = false;
        baf = new Billing_Administrative_Fees__c();
        billingOpsObj = new Billing_Operations__c();
        roList = new List<Rebate_Operations__c>();
        broTPAList = new List<Billing_Broker_TPA_Payments__c>();
        rebateRTMDBool = false;
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        yearList = new List<SelectOption>();
        bafID = ApexPages.currentPage().getParameters().get(ConstantsUtil.STRING_ID);// For get the ID from url
        operationType=ApexPages.currentPage().getParameters().get('type'); //for the clone 
        system.debug('operationType'+operationType);
        Id billingOprId = ApexPages.currentPage().getParameters().get(Label.BillingAdminFeesBillOps);  //For get BillingOperation Id from URL
        system.debug('billingOprId   sss'+billingOprId);
          system.debug('billingOprId   sss'+Label.BillingAdminFeesBillOps);
        
        //If the record is new this condition will execute
        if(String.IsBlank(bafID)){
            if(billingOprId != null){
                //query the client associated Billing operation Info
                billingOpsObj = [select id, FAF_ID__c, FAF_ID__r.Client_Info__c from Billing_Operations__c where id =:billingOprId];
                //roList = [select id,Rebate_RTMD__c from Rebate_Operations__c where FAF_ID__c =: billingOpsObj.FAF_ID__c ];
                for(Rebate_Operations__c ro :[select id,Rebate_RTMD__c from Rebate_Operations__c where FAF_ID__c =: billingOpsObj.FAF_ID__c ]){
                    if(ro.Rebate_RTMD__c){
                        rebateRTMDBool = true;
                    }            
                }
                broTPAList = [select id from Billing_Broker_TPA_Payments__c where Billing_Operations__c =: billingOprId];
                if(!broTPAList.isEmpty()){
                    BrokerTPAExist = true;
                }
                baf.FAF_Id__c = billingOpsObj.FAF_ID__C;
                baf.Billing_Operations__c = billingOprId;
                if(!(string.isBlank(billingOpsObj.FAF_ID__C))){
                    //Query the associated client Information to populate the value in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from Client_Information__c where FAF_ID__c =:billingOpsObj.FAF_ID__c limit 1];                    
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
    }
    else{   //In the edit case this condition will execute           
            baf = [select id,Year__c,LOB__c,Admin_Fee_Type__c,Base_Amount__c,Bill_Remit__c,Additive__c,Broker_Amount__c,Billing_Operations__r.FAF_ID__c,FAF_ID__c  from Billing_Administrative_Fees__c where id =: bafID];
            //roList = [select id,Rebate_RTMD__c from Rebate_Operations__c where FAF_ID__c =: baf.FAF_ID__c ];
            broTPAList = [select id from Billing_Broker_TPA_Payments__c where Billing_Operations__c =: baf.Billing_Operations__c];
            if(!broTPAList.isEmpty()){
                BrokerTPAExist = true;
            }                    
            feeAdditiveValue = baf.Additive__c;
            if(!(string.isBlank(baf.Billing_Operations__r.FAF_ID__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                Client_Information__c where FAF_ID__c =:baf.Billing_Operations__r.FAF_ID__c];               
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
            // For checking if Rebate RTMD of related Rebate Operations
            for(Rebate_Operations__c ro :[select id,Rebate_RTMD__c from Rebate_Operations__c where FAF_ID__c =: baf.FAF_ID__c ]){
                if(ro.Rebate_RTMD__c){
                    rebateRTMDBool = true;
                }            
            }
        }
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));   
    }
  
   /******************************************************************************************************************************
     * @Method Name       : saveUpdatebaf
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 25/07/2018
     * @Purpose           : Method for save and update the recoed
    *******************************************************************************************************************************/
    public pagereference saveUpdatebaf(){
     pagereference pr; 
        try{ 
            if(operationType=='Clone'){
                system.debug('################');
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(baf);
                 insert cloneSObj;
                 pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
             else{     
                    if(String.IsBlank(bafID)){
                        insert baf;      // Insert record
                    }else{
                        update baf;      // Update Record
                     }
              
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + baf.id);
                }
                return pr;          
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }    
    
    /******************************************************************************************************************************
     * @Method Name       : FeeAdditiveAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 25/07/2018
     * @Purpose           : Method call on change of Additive__c checkbox
    *******************************************************************************************************************************/
    public void FeeAdditiveAction(){    
        try{
            if(!feeAdditiveValue){
                baf.Broker_Amount__c = null;
            }   
        }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }
    
    /******************************************************************************************************************************
     * @Method Name       : changeYearMeth
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 22/08/2018
     * @Purpose           : Method for assign value on year field onchange
    *******************************************************************************************************************************/
    Public void changeYearMeth(){
        try{
            baf.year__c = yearval;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }
}