/*********************************************************************************************
 * @ClassName         : ASPGuaranteeNewEditClass
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 30/07/2018
 * @Last modified by  : 
 * @Last modified date: 
 * @Purpose           : This is the controller class for ASPGuaranteeNewEditPage         
 **********************************************************************************************/
 public with sharing class ASPGuaranteeNewEditClass{
  public boolean hasDefaultErrors{get;set;}
 
    Public Gnc_Guarantee__c ASPGuaranteeObj{get;set;} // Object declare for insert update
    Public Id ASPGuaranteeID{get;set;}  //For get the Record id
    Public Guarantees_Information__c guaranteeInfoObj{get;set;} // Object declare for Guarantee Information
    Public List<Client_Information__c> clintInfoList;  // for get the value of client Information
    Public set<string> checkClientYearCount;
    Public List<SelectOption> yearList{get;set;}
    Public string yearval{get;set;}
   
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    public Guarantees_Information__c ginfo{get;set;}
    //Constructor of the ASPGuaranteeNewEditClass
  
    public ASPGuaranteeNewEditClass(ApexPages.StandardController controller) {
      
        checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        operationType=ApexPages.currentPage().getParameters().get('type');
        yearList = new List<SelectOption>();
        ginfo = new Guarantees_Information__c();

        ASPGuaranteeObj = new Gnc_Guarantee__c();
        ASPGuaranteeID = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID); //Get Id fo the record from URL
        Id guarInfoId = ApexPages.currentPage().getParameters().get(Label.GuarInfoIdInASPGuarantee); //Get Guarantee Information Id from URL
         
        
        //If the record is new this condition will execute   
        if(String.IsBlank(ASPGuaranteeID)){
            // Condition for gnc guarantee record creation- Sindhu A
            List<Guarantees_Information__c > ginfo = [Select id,FAF_ID__c,Guaranteed_Net_Cost_Gnc_Guarantee__c from Guarantees_Information__c where id=:guarInfoId];
            if(!ginfo.isempty()){                 
             if(ginfo[0].Guaranteed_Net_Cost_Gnc_Guarantee__c != 'Yes'){
                hasDefaultErrors = true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Gnc Guarantee cannot be created when Guaranteed Net Cost (Gnc) Guarantee? is No or None');
                ApexPages.addMessage(myMsg);
             }
            }
            if(!String.IsBlank(guarInfoId)){
                guaranteeInfoObj = [select id,Faf_Id__c from Guarantees_Information__c where id =: guarInfoId];
                ASPGuaranteeObj.FAF_ID__c = guaranteeInfoObj.Faf_Id__c;
                ASPGuaranteeObj.Guarantee_Information__c = guarInfoId; 
        if(!(string.isBlank(guaranteeInfoObj.Faf_Id__c))){
                    //Query the associated client Information to populate the value in year field
                    clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from Client_Information__c where FAF_ID__c =:guaranteeInfoObj.Faf_Id__c limit 1];                    
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
        
            //Fetch ASP Guarantee object info
            ASPGuaranteeObj = [select id,name,FAF_ID__c,Guarantee_Information__c,Channel__c,Guarantee_Information__r.Faf_Id__c,Guarantee_Information__r.GDR_Guarantee_Payout__c,LOB__c,Year__c,Per_Claim__c from Gnc_Guarantee__c where id =: ASPGuaranteeID];
        
            if(!(string.isBlank(ASPGuaranteeObj.Guarantee_Information__r.Faf_Id__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                Client_Information__c where FAF_ID__c =:ASPGuaranteeObj.Guarantee_Information__r.Faf_Id__c];               
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
     * @Method Name       : saveUpdatetrendGuaranteeObj
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method call on save
     *******************************************************************************************************************************/
    public pagereference saveUpdateASPGuaranteeObj(){
        try{
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(ASPGuaranteeObj);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if(String.IsBlank(ASPGuaranteeID)){
                    insert ASPGuaranteeObj;  //Insert ASP Guarantee
                }else{
                    update ASPGuaranteeObj;  //Update ASP Guarantee
                }
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + ASPGuaranteeObj.id);
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
     * @Last modified date: 23/08/2018
     * @Purpose           : Method call on year change
     *******************************************************************************************************************************/
   Public void changeYearMeth(){ 
        try{
            ASPGuaranteeObj.Year__c = yearval; 
        }catch(Exception excp){
            ApexPages.addMessages(excp);         
        }  
    }

}