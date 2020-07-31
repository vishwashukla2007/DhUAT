/*********************************************************************************************
 * @ClassName         : SpecialtyGuaranteeNewEditClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 02/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 02/08/2018
 * @Purpose           : This is the controller class for SpecialtyGuaranteeNewEditClass
 **********************************************************************************************/
public with sharing class SpecialtyGuaranteeNewEditClass{
    public ApexPages.StandardController con;
    Public Specialty_Guarantee__c specGuaranteeObj{get;set;} // Object declair for insert update
    Public Id specDrugLevelID{get;set;}  //For get the Record id
    public Boolean redirect{get;set;}
    /*********************************************************************************************
     * @Method Name       : SpecialtyGuaranteeNewEditClass
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Constructor of the SpecDrugLevelNewEditClass
     **********************************************************************************************/
    public SpecialtyGuaranteeNewEditClass(ApexPages.StandardController controller) {
        redirect = ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING);
        con = controller;
        specGuaranteeObj = new Specialty_Guarantee__c();
        specDrugLevelID = ApexPages.currentPage().getParameters().get(ConstantsUtil.STRING_ID);    //Get Id fo the record from URL
        Id specPriceId = ApexPages.currentPage().getParameters().get(Label.SpecPricOnGuaranteeLabel);   //Get Speciality operation Id from URL
        //If the record is new this condition will execute
        if(String.IsBlank(specDrugLevelID)){
            if(!String.IsBlank(specPriceId)){
                Specialty_Pricing__c specOpsObj = [select id, FaF_Id__C from Specialty_Pricing__c where id=: specPriceId];
                specGuaranteeObj.Specialty_Pricing__c = specPriceId;
                if(!(string.isBlank(specOpsObj.FAF_ID__C))){
                    specGuaranteeObj.Faf_Id__c = specOpsObj.FaF_Id__C;
                }
            }
        }else{   //In User edit a record then this condition will execute
        
            //Fetch Specialty Operation object info
            specGuaranteeObj = [select id, name, FAF_ID__c, Specialty_Pricing__c, Type__c, Subtype__c,
             Rate__c, ZBD__c, LDD__c, SSG__c, LDD_Exclusion_Option__c, New_to_Market_Brands__c,
              Biosimilars__c, New_to_Market_Generics__c, OTC__c, X340B__c, Compound__c,
               X340B_Exclusion_Option__c, Vaccine__c, Paper__c, COB__c from Specialty_Guarantee__c where id =: specDrugLevelID];           
        }
    }
    
    /*********************************************************************************************
     * @Method Name       : SaveUpdateSpecGuarantee
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 02/08/2018
     * @Purpose           : Method for save and update the recoed
     **********************************************************************************************/
    public pagereference SaveUpdateSpecGuarantee(){
        try{
            if(String.IsBlank(specDrugLevelID)){
                insert specGuaranteeObj;  //Insert Specialty Guarantee
            }else{
                update specGuaranteeObj;  //Update Specialty Guarantee
            }   
     //Added by Sindhu(Expanded view)
            String url = ConstantsUtil.FORWARD_SlASH + specGuaranteeObj.id;
            pagereference pr;
            System.debug(ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING));
            if(ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING)) {
                url = ConstantsUtil.ApttusPricingEV;
                redirect = true;
                pr = null;
            } else {
                pr = new pagereference(url);
            }
            return pr;
            //end 
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }  
    /******************************************************************************************************************************
     * @Method Name       : cancel
     * @author            : 
     * @Last modified by  : 
     * @Last modified date: 
     * @Purpose           : Added by Sindhu(Expanded view)
     *******************************************************************************************************************************/
    public PageReference cancel() {
        try{
            System.debug(ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING));
            if(ApexPages.currentPage().getParameters().containsKey(ConstantsUtil.LIGHTNING)) {
               String url = ConstantsUtil.ApttusPricingEV;
               redirect = true;
               return null;
            } else {
                return con.cancel();
            }   
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }     
}