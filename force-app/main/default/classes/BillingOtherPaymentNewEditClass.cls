/*************************************************************************************************************************
 * @Trigger Name      : BillingOtherPaymentNewEditClass
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the controller class for BillingOtherPaymentNewEditPage
 *************************************************************************************************************************/
public with sharing class BillingOtherPaymentNewEditClass {
    Public Contractual_Payments__c bop{get;set;}  // To bind the Billing Other Payments Object
    Public Billing_Operations__c billingOpsObj{get;set;} // To store the value of Billing Operation
    Public date contractEndDate{get;set;} // To store the Contract End Date from Client Information Object
    Public List<Client_Information__c> clintInfoList; // To store the year list from Client Information Object
    Public set<string> checkClientYearCount;
    Public Id bopID{get;set;}  // To store the id of Billing Other Payments Object
    Public String yearVal{get;set;}  // For populating the year in the drop dowm
    Public boolean expirationDisable{get;set;} 
    Public List<SelectOption> yearList{get;set;}
    Public Id RecId{get;set;}
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
  //public Boolean expirationNotReq{get;set;} //Boolean to make the expiration field not required when Type__c is equal to Implementation Credit. PT US82 commented by Sneha Inturi.
  //public String typeExp{get;set;}// To Check the Value of Type__c field is  'Implementation Credit' or not. PT US82 commented by Sneha Inturi.
/*************************************************************************************************************************
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Constructor class for Billing Other Payments
 *************************************************************************************************************************/ 
    public BillingOtherPaymentNewEditClass(ApexPages.StandardController controller) {
        bop = new Contractual_Payments__c();
        billingOpsObj = new Billing_Operations__c();
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        operationType=ApexPages.currentPage().getParameters().get('type');
        yearList = new List<SelectOption>();
        bopID = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID);
        Id billingOprId = ApexPages.currentPage().getParameters().get(Label.BillingOthrPaymentBillingOp); 
    if(bopID == null){
      //expirationNotReq=true; //To make Expiration field  required on load of page. US82 commented by Sneha Inturi.
        RecId = billingOprId;
            if(billingOprId != null){
            //query the client associated Billing operation Info
            billingOpsObj = [select id, FAF_ID__c, FAF_ID__r.Client_Info__c from Billing_Operations__c where id =:billingOprId];
            bop.FAF_Id__c = billingOpsObj.FAF_ID__C;
            bop.Billing_Operations__c = billingOprId;
        if(!(string.isBlank(billingOpsObj.FAF_ID__C))){
                    //Query the associated client Information to populate the bvalue in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Contract_End_Date__c from
                    Client_Information__c where FAF_ID__c =:billingOpsObj.FAF_ID__c limit 1];
                 }
         
         if(!clintInfoList.isEmpty()){
             if(clintInfoList[0].Contract_End_Date__c != null){
             bop.Expiration__c = clintInfoList[0].Contract_End_Date__c;
            // contractEndDate = clintInfoList[0].Contract_End_Date__c;                
            }
         //check whether Client Info list is empty or not
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
    }
    }else{ //In the edit case this condition will execute
        RecId = bopID;
        bop = [select id,Additional_Other_Payment_Information__c,Amount__c,Basis__c,Billing_Operations__c,Billing_Operations__r.FAF_ID__r.Client_Info__c,Expiration__c,FAF_ID__c,Link__c,LOB2__c,Payment_Terms__c,Type__c,Years__c, Level__c from Contractual_Payments__c where id =: bopID];
        yearVal = bop.Years__c;
        // To make not required to Expiration field if Type__c= 'Implementation Credit' or else it's required. 
        /* PT US82 commented by Sneha Inturi.
        if(bop.Type__c=='Implementation Credit'){
            expirationNotReq=false;
        }else {
            expirationNotReq=true;
        }
        // Ends Here */
        if(!(string.isBlank(bop.Billing_Operations__r.FAF_ID__c))){
            clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c,Contract_End_Date__c  from
            Client_Information__c where FAF_ID__c =:bop.Billing_Operations__r.FAF_ID__c];
        }                                                
        if(!clintInfoList.isEmpty()){
        // To auto-populate the Contract End date in the Expiration field            
             if(clintInfoList[0].Contract_End_Date__c != null && bop.Expiration__c == null){
             bop.Expiration__c = clintInfoList[0].Contract_End_Date__c;
           //  contractEndDate = clintInfoList[0].Contract_End_Date__c;                
            }
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
        yearList.add(new SelectOption(ConstantsUtil.ALL, ConstantsUtil.ALL));
    }

/*************************************************************************************************************************
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Save method invoked when user clicks on save button from Page 
 *************************************************************************************************************************/    
    public pagereference saveUpdateBOP(){
        try{
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(bop);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if(bopID == null){
                    insert bop;
                }else{
                    update bop;
                }
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + bop.id);
            }
             
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }

/**********************************************************************************************************************************
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Cancel method invoked when user clicks on Cancel button from Page 
 **********************************************************************************************************************************/           
    public pageReference Cancel(){
    try{
        system.debug('==========RecId========='+RecId);
        return new pageReference(ConstantsUtil.FORWARD_SlASH +RecId);
    }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
        }

/**********************************************************************************************************************************
 * @author            : Aman Kumar(Accenture)
 * @created date      : 26/03/2019
 * @Last modified by  : Aman Kumar(Accenture)
 * @Last modified date: 27/03/2019
 * @Purpose           : expirationNotRequiredMethod is used to invoked,when user change the value from Type__c field from Vf Page
                        And If Type__c= 'Implementation Credit' than Expiration__c field is not required or else it's required.
 *********************************************************************************************************************************/  
public void expirationNotRequiredMethod(){
           /* PT US82 commented by Sneha Inturi.
           if(typeExp=='Implementation Credit' || typeExp=='Vendor Fixed Fees'){
            expirationNotReq=false;
            }
            else{
            expirationNotReq=true;
            } */
 }
}