/*********************************************************************************************
 * @ClassName         : GdrGuaranteeNewEditClass
 * @author            : Priyanka Goyal(Accenture)
 * @created date      : 27/07/2018
 * @Last modified by  : 
 * @Last modified date: 
 * @Purpose           : This is the controller class for GdrGuaranteeNewEditPage         
 **********************************************************************************************/
public with sharing class GdrGuaranteeNewEditClass{
    Public GDR_Guarantee__c gdrGuaranteeObj{get;set;} // Object declair for insert update
    Public Id gdrGuaranteeID{get;set;}  //For get the Record id
    Public Guarantees_Information__c guaranteeInfoObj{get;set;} // Object declair for Guarantee Information
    Public Boolean guarPayoutBool{get;set;} //to check whether Guarantee Payout selection is “$ for $ with Max. Cap”
    Public Boolean guarTypeBool{get;set;} //to check Guarantee Type validation 
    public String operationType;// custom clone functionality
    public String CLONE='clone';// custom clone functionality
    
    //Constructor of the GdrGuaranteeNewEditClass
    public GdrGuaranteeNewEditClass(ApexPages.StandardController controller) {
    try{
        guarPayoutBool = false;
        guarTypeBool = false;
        gdrGuaranteeObj = new GDR_Guarantee__c();
        gdrGuaranteeID = ApexPages.currentPage().getParameters().get(ConstantsUtil.ID); //Get Id fo the record from URL
        Id guarInfoId = ApexPages.currentPage().getParameters().get(Label.GuarInfoIdInGdrGuarantee); //Get Guarantee Information Id from URL 
        operationType=ApexPages.currentPage().getParameters().get('type');
        system.debug('=======gdrGuaranteeID======='+gdrGuaranteeID);
        system.debug('=======guarInfoId======='+guarInfoId);
        
        //If the record is new this condition will execute
        if(String.IsBlank(gdrGuaranteeID)){
            if(!String.IsBlank(guarInfoId)){
                guaranteeInfoObj = [select id,Faf_Id__c,GDR_Guarantee_Payout__c from Guarantees_Information__c where id =: guarInfoId];
                gdrGuaranteeObj.FAF_ID__c = guaranteeInfoObj.Faf_Id__c;
                gdrGuaranteeObj.Guarantee_Information__c = guarInfoId;
                if(guaranteeInfoObj.GDR_Guarantee_Payout__c == '$ for $ with Max. Cap'){
                    guarPayoutBool = true;                  
                }
            }           
        }else{ // //In User edit a record then this condition will execute
        
            //Fetch GDR Guarantee object info
            gdrGuaranteeObj = [select id,name,FAF_ID__c,Guarantee_Information__c,Guarantee_Information__r.GDR_Guarantee_Payout__c,Guarantee_Type__c,Link__c,Penalty_Amount__c,Year_1__c,Year_2__c,Year_3__c from GDR_Guarantee__c where id =: gdrGuaranteeID];
            if(gdrGuaranteeObj.Guarantee_Information__r.GDR_Guarantee_Payout__c == '$ for $ with Max. Cap'){
                guarPayoutBool = true;
            }
            
        }
    }catch(Exception excp){
        ApexPages.addMessages(excp);
    }
          
    }
    
 /******************************************************************************************************************************
     * @Method Name       : saveUpdateGdrGuaranteeObj
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 23/08/2018
     * @Purpose           : Method call on save
     *******************************************************************************************************************************/
    public pagereference saveUpdateGdrGuaranteeObj(){               
        try{
            pagereference pr;
            if(operationType==CLONE){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(gdrGuaranteeObj);
                insert cloneSObj;
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH +cloneSObj.id);
            }
            else{
                if(gdrGuaranteeID == null){
                    insert gdrGuaranteeObj;  //Insert GDR Guarantee
                }else{
                    update gdrGuaranteeObj;  //Update GDR Guarantee
                }
                pr = new pagereference(ConstantsUtil.FORWARD_SlASH + gdrGuaranteeObj.id);
            }
            return pr;
        }catch(Exception excp){
            ApexPages.addMessages(excp);
            return null;
        }
    }

}