/* ====================================================================
 * @Trigger Name      : BillingBrokerTPAPageNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27 06 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for BillingBrokerTPAPage
========================================================================*/
public with sharing class BillingBrokerTPAPageNewEditClass {
    Public Billing_Broker_TPA_Payments__c bbtp{get;set;}   // for binding the object 
    Public Billing_Operations__c billingOpsObj{get;set;}   // for store the value of Biolling Operation
    Public List<Client_Information__c> clintInfoList;    // for get the value of client Information
    Public set<string> checkClientYearCount; 
    Public Id btpID{get;set;}     //variable for store broker TPA ID
    //Public String yearVal{get;set;}    // for get the selected value from year picklist
    Public List<SelectOption> yearList{get;set;}     // for populate the year in dropdown
    Public string brokerTpaName{get;set;}
    Public string payOnStr{get;set;}    //pass the selected value foom page to class
    Public Boolean metricReqBool{get;set;}    //Boolean for make the Metric field required
    Public Id RecId{get;set;}
    Public String metricStr{get;set;} //For pass the value of Metric on change
    Public Boolean percentFieldBool{get;set;}  //boolena responsible to make % field required
    Public Boolean dollarFieldBool{get;set;}  //boolena responsible to make $ field required
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    
/* ====================================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27 06 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the constructor of the class
========================================================================*/  
    public BillingBrokerTPAPageNewEditClass(ApexPages.StandardController controller) {
        bbtp = new Billing_Broker_TPA_Payments__c();
        billingOpsObj = new Billing_Operations__c();
        operationType=ApexPages.currentPage().getParameters().get('type');
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        metricReqBool = true;
        dollarFieldBool = false;
        percentFieldBool = false;
        yearList = new List<SelectOption>(); 
        btpID = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID);   // For get the ID from url
        Id billingOprId = ApexPages.currentPage().getParameters().get(Label.BrokerTPAPaymentBillingOp);  //For get BillingOperation Id from URL        
        //If the record is new this condition will execute
        if(btpID == null){
            RecId = billingOprId;
            brokerTpaName = ConstantsUtil.New_Billing_Broker_TPA;
            if(billingOprId != null){
            
                //query the client associated Billing operation Info
                billingOpsObj = [select id, FAF_ID__c, FAF_ID__r.Client_Info__c from Billing_Operations__c where id =:billingOprId];
                bbtp.FAF_Id__c = billingOpsObj.FAF_ID__C;
                bbtp.Billing_Operations__c = billingOprId;
                if(!(string.isBlank(billingOpsObj.FAF_ID__C))){
                
                    //Query the associated client Information to populate the bvalue in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Pricing_Effective_Date__c from
                    Client_Information__c where FAF_ID__c =:billingOpsObj.FAF_ID__c limit 1];
                 }
                 
                 
                 if(!clintInfoList.isEmpty()){      //check weathed Client Info list is empty or not
                 // To auto-populate Effective Date on Broker/TPA when Pricing Effective Date is not blank on Client Info
                 if(clintInfoList[0].Pricing_Effective_Date__c != null){
                     bbtp.Effective_Date__c = clintInfoList[0].Pricing_Effective_Date__c;             
                    }
                     if(!(string.isBlank(clintInfoList[0].year_1__c))){
                         yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));        //Populate empty value in Year field
                         yearList.add(new SelectOption(clintInfoList[0].year_1__c , clintInfoList[0].year_1__c));
                         checkClientYearCount.add(clintInfoList[0].year_1__c);     // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_2__c))){    //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_2__c , clintInfoList[0].year_2__c));
                         checkClientYearCount.add(clintInfoList[0].year_2__c); // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_3__c))){    //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK)); 
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_3__c , clintInfoList[0].year_3__c));
                         checkClientYearCount.add(clintInfoList[0].year_3__c);    // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_4__c))){     //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_4__c , clintInfoList[0].year_4__c));
                         checkClientYearCount.add(clintInfoList[0].year_4__c);    // associate value from client Information object
                     }
                     if(!(string.isBlank(clintInfoList[0].year_5__c))){     //for check value is not empty 
                         if(checkClientYearCount.isEmpty()){
                             yearList.add(new SelectOption(ConstantsUtil.BLANK, ConstantsUtil.BLANK));
                         }
                         yearList.add(new SelectOption(clintInfoList[0].year_5__c , clintInfoList[0].year_5__c));
                         checkClientYearCount.add(clintInfoList[0].year_5__c);  // associate value from client Information object
                     }
                 }
            }
            onchangeMetricAction();
        }else{  //In the edit case this condition will execute
            RecId = btpID;
            bbtp = [select id, name, BrokerTPA_Name__c, FAF_ID__c, Billing_Operations__c, Billing_Operations__r.FAF_ID__r.Client_Info__c, 
            Year__c, LOB2__c, Pay_on__c, Type__c, Metric__c, Amount_Dollar__c, Amount_Percent__c, Effective_Date__c, Frequency__c,
            Termination__c, Additional_Broker_TPA_Payment_Info__c,Level__c from Billing_Broker_TPA_Payments__c where id =: btpID];
            //yearVal = bbtp.Year__c;
            brokerTpaName = bbtp.name;
            payOnStr = bbtp.Pay_On__c;
            metricStr = bbtp.Metric__c;
            onchangePayOn();
            onchangeMetricAction();
            if(!(string.isBlank(bbtp.Billing_Operations__r.FAF_ID__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Pricing_Effective_Date__c from
                Client_Information__c where FAF_ID__c =:bbtp.Billing_Operations__r.FAF_ID__c];
            }
            
            // To auto-populate effective date on broker TPA record ,if pricing effective date is not blank
            if(clintInfoList[0].Pricing_Effective_Date__c != null && bbtp.Effective_Date__c == null){
             bbtp.Effective_Date__c = clintInfoList[0].Pricing_Effective_Date__c;             
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
              if(bbtp.Pay_on__c == ConstantsUtil.CUSTOM){
                  bbtp.Metric__c = ConstantsUtil.BLANK ; // If pay on is emplty Metric should be blank
              }
        }
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL)); // Add ConstantsUtil.ALL value in year dropdown
    }
    

/* ====================================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27 06 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Method for save and update the record
========================================================================*/  
    public pagereference saveUpdateBBTP(){
        try{
            /*system.debug('=====yearVal====='+yearVal);
            if(yearVal == null || yearVal == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Year is Required'));
                return null;
            }
            bbtp.Year__c = yearVal;*/
            
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(bbtp);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
            
                if(bbtp.Pay_on__c == ConstantsUtil.CUSTOM){ // Check if Payon value is Custom
                    bbtp.Metric__c = '';
                    bbtp.Amount_Dollar__c = null;
                    bbtp.Amount_Percent__c = null;
                }else{
                    if(bbtp.Metric__c == ConstantsUtil.DOLLAR){  //Check if value is dollar
                        bbtp.Amount_Percent__c = null;
                    }else if(bbtp.Metric__c == ConstantsUtil.PERC){ //check if value is percent
                        bbtp.Amount_Dollar__c = null;
                    }else{
                        bbtp.Amount_Percent__c = null;
                        bbtp.Amount_Dollar__c = null;
                    }
                }
                if(btpID == null){
                    insert bbtp;   // Insert record
                }else{
                    update bbtp;   // Update Record
                }
             pr = new pagereference(ConstantsUtil.FORWARD_SlASH + bbtp.id);
        }
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }
    
/* ====================================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27 06 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Method call on change the pay On Picklist
========================================================================*/  
    public void onchangePayOn(){
    try{
        if(payOnStr == ConstantsUtil.CUSTOM){
            metricReqBool = false;
            bbtp.Metric__c = null;
            bbtp.Type__c = ConstantsUtil.See_Notes;
            metricStr = ConstantsUtil.BLANK;
        } else{
            metricReqBool = true;
        }
        onchangeMetricAction();
    }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }
    
/* ====================================================================
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 27 06 2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Method call on change the Metric field
========================================================================*/  
    public void onchangeMetricAction(){
    try{
        if(metricStr == ConstantsUtil.DOLLAR){
            dollarFieldBool = false;
            percentFieldBool = true;
            bbtp.Amount_Percent__c = null;
        }else if(metricStr == ConstantsUtil.PERC){
            percentFieldBool = false;
            dollarFieldBool = true;
            bbtp.Amount_Dollar__c = null;
        }else{
            percentFieldBool = true;
            dollarFieldBool = true;
            bbtp.Amount_Percent__c = null;
            bbtp.Amount_Dollar__c = null;
        }
    }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }
}