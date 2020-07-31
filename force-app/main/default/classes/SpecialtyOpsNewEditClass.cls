/*********************************************************************************************
 * @ClassName         : SpecialtyOpsNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 31/07/2018
 * @Last modified by  : 
 * @Last modified date: 31/07/2018
 * @Purpose           : This is the controller class for SpecialtyOpsNewEditPage         
 **********************************************************************************************/
public with sharing class SpecialtyOpsNewEditClass{
    //public ApexPages.StandardController con;
    Public Specialty_Operations__c specOprObj{get;set;} // Object declair for insert update
    Public Id specOpsID{get;set;}  //For get the Record id
    Public Boolean showerrorBool{get;set;} //for show messsage that one FAF can have only one Rebate Operation Record 
    Public String pharmBenValue{get;set;} // to get the value of Pharmacy_Benefit__c
    Public Boolean showPopupBool{get;set;} // variable to show the popup onchange of Pharmacy_Benefit__c
    Public Boolean specPricingExist{get;set;} // variable to check Specialty_Pricing__c records exist
    Public Boolean specDrugPricingExist{get;set;} // variable to check Specialty_Drug_Level_Pricing__c records exist
    List<Specialty_Pricing__c>specPriceList;  //for store the list of Speciality Pricing
    List<Specialty_Drug_Level_Pricing__c>specDrugLevlPriceList;  //for store the list of Speciality Drug Level Pricing
    
     /******************************************************************************************************************************
     * @Method Name       : SpecialtyOpsNewEditClass
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Constructor of the SpecialtyOpsNewEditClass
     *******************************************************************************************************************************/
    public SpecialtyOpsNewEditClass(ApexPages.StandardController controller) {
        showerrorBool = false;
        specPricingExist = false;
        specDrugPricingExist = false;
        pharmBenValue = null;
        showPopupBool = false;
        specOprObj = new Specialty_Operations__c();
        specPriceList = new  List<Specialty_Pricing__c>();
        specDrugLevlPriceList = new  List<Specialty_Drug_Level_Pricing__c>(); 
        
        specOpsID = ApexPages.currentPage().getParameters().get(ConstantsUtil.STRING_ID);    //Get Id fo the record from URL
        Id fafId = ApexPages.currentPage().getParameters().get(Label.FafIdSpecOpsLabel);   //Get FAF Id from URL

        //If the record is new this condition will execute
        if(String.IsBlank(specOpsID)){
            if(!String.IsBlank(fafId)){
            
                List<Specialty_Operations__c>fafDataCount = new List<Specialty_Operations__c>();
                fafDataCount = [select id from Specialty_Operations__c where FAF_Id__c=: fafId];
                
                if(!fafDataCount.isEmpty()){
                    showerrorBool = true;
                }
                specOprObj.Faf_Id__c = fafId;
            }
        }else{ // //In User edit a record then this condition will execute
        
            //Fetch Specialty Operation object info
            specOprObj = [select id, name, FAF_ID__c, Discount_Basis__c, Pharmacy_Benefit__c, Medical_Benefit__c, Billing_Type__c,
            Exclude_Specialty_Class__c, Select_Specialty_Exclusion__c, Specialty_Pricing_Additional_Information__c,Ondansetron_Enoxaparin_Added_to_SFS__c,Lower_of_MAC_Logic_NOT_required__c
            from Specialty_Operations__c where id =: specOpsID];
            pharmBenValue = specOprObj.Pharmacy_Benefit__c;
            specPriceList = [select id from Specialty_Pricing__c where Specialty_Operations__c =:specOprObj.id];  //for store the value of Speciality Pricing
            specDrugLevlPriceList = [select id from Specialty_Drug_Level_Pricing__c where Specialty_Operations__c =:specOprObj.id];  //for store the value of Speciality Drug Level Pricing
            if(!specDrugLevlPriceList.isEmpty()){
                specDrugPricingExist = true;
            }
            if(!specPriceList.isEmpty()){
                specPricingExist = true;
            }
        
        }
        
    }
    
    /******************************************************************************************************************************
     * @Method Name       : saveUpdateSpecInfo
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Method for save and update the recoed
     *******************************************************************************************************************************/
    public pagereference saveUpdateSpecInfo(){
        try{
            List<Specialty_Pricing__c>specPriceList = new  List<Specialty_Pricing__c>();  //for store the value of Speciality Pricing
            List<Specialty_Drug_Level_Pricing__c>specDrugLevlPriceList = new  List<Specialty_Drug_Level_Pricing__c>();  //for store the value of Speciality Drug Level Pricing
            if(String.IsBlank(specOpsID)){
                insert specOprObj;  //Insert Specialty Operation
            }else{
                update specOprObj;  //Update Specialty Operation
                if(!specOprObj.Pharmacy_Benefit__c.equalsIgnoreCase(ConstantsUtil.CLIENT_CHOICE)){
                    for(Specialty_Drug_Level_Pricing__c sp: [select id from Specialty_Drug_Level_Pricing__c where Specialty_Operations__c =:specOprObj.id]){
                        sp.Pharmacy_Benefit__c = specOprObj.Pharmacy_Benefit__c;
                        specDrugLevlPriceList.add(sp);
                    }
                    if(!specDrugLevlPriceList.isEmpty()){
                        update specDrugLevlPriceList;
                    }
                    for(Specialty_Pricing__c sp: [select id from Specialty_Pricing__c where Specialty_Operations__c =:specOprObj.id]){
                        sp.Pharmacy_Benefit__c = specOprObj.Pharmacy_Benefit__c;
                        specPriceList.add(sp);
                    }
                    if(!specPriceList.isEmpty()){
                        update specPriceList;
                    }
                }
            }
            pagereference pr = new pagereference(ConstantsUtil.FORWARD_SlASH + specOprObj.id);
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }
    
    /******************************************************************************************************************************
     * @Method Name       : pharmBenChangeAction
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method call on change of Pharmacy_Benefit__c
     *******************************************************************************************************************************/
    public void pharmBenChangeAction(){
        //system.debug('==========pharmBenValue=========='+pharmBenValue);
        try{
            specOprObj.Pharmacy_Benefit__c = pharmBenValue;
            if(pharmBenValue.equals(ConstantsUtil.CLIENT_CHOICE)){
                showPopupBool = false;
            }else{
                showPopupBool = true;
            }
        }
        catch(Exception excp){
        ApexPages.addMessages(excp); 
        
        }
        
        //system.debug('==========showPopupBool=========='+showPopupBool);
    }
           
}