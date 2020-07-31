/*********************************************************************************************
 * @ClassName         : TrendGuaranteeNewEditClass
 * @author            : Sanket Saxena(Accenture)
 * @created date      : 23/07/2018
 * @Last modified by  : 
 * @Last modified date: 22/08/2018
 * @Purpose           : This is the controller class for TrendGuaranteeNewEditClass       
 **********************************************************************************************/
public with sharing class TrendGuaranteeNewEditClass{
    Public Trend_Guarantee__c trendGuaranteeObj{get;set;} // Object declare for insert update
    Public Id trendGuaranteeID{get;set;}  //To get the Record id
    Public Guarantees_Information__c guaranteeInfoObj{get;set;} // Object declare for Guarantee Information
    Public Boolean tgReconBool{get;set;} //to check whether "TG Reconciliation Method” is equal to “By Component”
    Public List<Client_Information__c> clintInfoList;  // for get the value of client Information
    Public set<string> checkClientYearCount;
    Public List<SelectOption> yearList{get;set;}
    public string yearval{get;set;}
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    
    //Constructor of the TrendGuaranteeNewEditClass
    public TrendGuaranteeNewEditClass(ApexPages.StandardController controller) {
        tgReconBool = false;
    checkClientYearCount = new set<string>();
        clintInfoList = new List<Client_Information__c>();
        yearList = new List<SelectOption>();

        trendGuaranteeObj = new Trend_Guarantee__c();
        trendGuaranteeID = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID); //Get Id for the record from URL
        Id guarInfoId = ApexPages.currentPage().getParameters().get(Label.GuarInfoIdInTrendGuarantee); //Get Guarantee Information Id from URL 
        operationType=ApexPages.currentPage().getParameters().get('type');
        //If the record is new this condition will execute
        if(String.IsBlank(trendGuaranteeID)){
            if(!String.IsBlank(guarInfoId)){
                guaranteeInfoObj = [select id,Faf_Id__c,Trend_Recon_Method__c from Guarantees_Information__c where id =: guarInfoId];
                trendGuaranteeObj.FAF_ID__c = guaranteeInfoObj.Faf_Id__c;
                trendGuaranteeObj.Guarantee_Information__c = guarInfoId;
                 if(guaranteeInfoObj.Trend_Recon_Method__c != 'By Component'){
                    tgReconBool = true;
                    trendGuaranteeObj.At_Risk_Amount__c = null;
                }
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
        
            //Fetch Trend Guarantee object info
            trendGuaranteeObj = [select id,name,FAF_ID__c,Guarantee_Information__c,Guarantee_Information__r.Faf_Id__c,Guarantee_Information__r.Trend_Recon_Method__c,LOB__c,Year__c,Guarantee_Type__c, Drug_Type__c,Trend__c, At_Risk_Amount__c from Trend_Guarantee__c where id =: trendGuaranteeID];
                 if(trendGuaranteeObj.Guarantee_Information__r.Trend_Recon_Method__c != 'By Component'){
                    tgReconBool = true;
                trendGuaranteeObj.At_Risk_Amount__c = null;
            }
        if(!(string.isBlank(trendGuaranteeObj.Guarantee_Information__r.Faf_Id__c))){
                clintInfoList = [select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                Client_Information__c where FAF_ID__c =:trendGuaranteeObj.Guarantee_Information__r.Faf_Id__c];               
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
    public pagereference saveUpdatetrendGuaranteeObj(){
        try{
        
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(trendGuaranteeObj);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                    if(String.IsBlank(trendGuaranteeID)){
                        insert trendGuaranteeObj;  //Insert Trend Guarantee
                    }else{
                        update trendGuaranteeObj;  //Update Trend Guarantee
                    }
                    pr = new pagereference(ConstantsUtil.FORWARD_SlASH + trendGuaranteeObj.id);
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
        trendGuaranteeObj.Year__c = yearval;
        }catch(Exception excp){
            ApexPages.addMessages(excp);           
        }
    }

}