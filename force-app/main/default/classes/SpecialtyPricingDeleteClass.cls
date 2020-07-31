/* ===================================================================================================
 * @Class Name        : SpecialtyPricingDeleteClass
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 12/10/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 12/10/2018
 * @Purpose           : This class is use to override the delete button on Speciality Pricing Page
======================================================================================================*/
public class SpecialtyPricingDeleteClass{
    
    Public boolean showErrorMessage{get; set;}
    Public boolean showErrorMessageNone{get; set;}
    Public string recordId{get; set;}
    Public Boolean isErrorOccur;
    Public string ConcanateStr;
    Public String FAFIdStr;
    Public Boolean checkBool;
    public SpecialtyPricingDeleteClass(ApexPages.StandardController stdController){
        isErrorOccur = true;
        showErrorMessage = false;
        showErrorMessageNone = false;
        recordId = ApexPages.Currentpage().getParameters().get(ConstantsUtil.ID);
    }
     /******************************************************************************************************************************
     * @Method Name       : deleteRecord
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Method Use to check the criteria before deleting Specialty Pricing Record
     *******************************************************************************************************************************/
    public pageReference deleteRecord(){
        Specialty_Pricing__c specPricingRec = [select id, FAF_ID__c, Pharmacy_Benefit__c, Price_List__c, 
        Specialty_Operations__c from Specialty_Pricing__c where id =: recordId];
        Id specOpsId = specPricingRec.Specialty_Operations__c;
        
        FAFIdStr = specPricingRec.FAF_ID__c;
        if(!string.isBlank(specOpsId)){
            if(specPricingRec.Pharmacy_Benefit__c != ConstantsUtil.const_None){
                ConcanateStr = specPricingRec.Pharmacy_Benefit__c+ConstantsUtil.hyphenStr+specPricingRec.Price_List__c;
                List<Specialty_Pricing__c> specPricingList = [select id, FAF_ID__c, Pharmacy_Benefit__c, Price_List__c, 
                Specialty_Operations__c from Specialty_Pricing__c where Pharmacy_Benefit__c =: specPricingRec.Pharmacy_Benefit__c
                and Price_List__c =: specPricingRec.Price_List__c and Specialty_Operations__c =: specOpsId];
                System.debug('-here1--'+specPricingList);
                checkBool = true;
                showErrorMessage = true;
                showErrorMessageNone = false;
                if(specPricingList.size() > 1){
                    showErrorMessage = false;
                    isErrorOccur = false;
                }
            }else if(specPricingRec.Pharmacy_Benefit__c == ConstantsUtil.const_None){
                ConcanateStr = specPricingRec.Pharmacy_Benefit__c;
                List<Specialty_Pricing__c> specPricingList = [select id, FAF_ID__c, Pharmacy_Benefit__c, Price_List__c, 
                Specialty_Operations__c from Specialty_Pricing__c where Pharmacy_Benefit__c =: specPricingRec.Pharmacy_Benefit__c
                and Specialty_Operations__c =: specOpsId];
                System.debug('-here2--'+specPricingList);
                checkBool = false;
                showErrorMessageNone = true;
                showErrorMessage = false;
                if(specPricingList.size() > 1){
                    showErrorMessageNone = false;
                    isErrorOccur = false;
                }
            }   
        }
        if(isErrorOccur){
            List<Platform_Specifics__c>platSpecList = new List<Platform_Specifics__c>();
            platSpecList = [select id, Specialty_Pharmacy_Benefit_Price_List__c, FAF_Id__c from Platform_Specifics__c
             where FAF_Id__c =: FAFIdStr and Specialty_Pharmacy_Benefit_Price_List__c =: ConcanateStr];
            if(platSpecList.isEmpty()){
                showErrorMessage = false;
                showErrorMessageNone = false;
                isErrorOccur = false;
                delete specPricingRec;
                PageReference pageRef = new PageReference(ConstantsUtil.SLASH+specOpsId);
                pageRef.setRedirect(true);
                return pageRef;
            }else{
                if(checkBool)
                    showErrorMessage = true;
                 else   
                    showErrorMessageNone = true;
                isErrorOccur = true;
            }  
        }else{
            delete specPricingRec;
            PageReference pageRef = new PageReference(ConstantsUtil.SLASH+specOpsId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
}