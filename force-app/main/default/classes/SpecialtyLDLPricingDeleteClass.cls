public class SpecialtyLDLPricingDeleteClass{
    
    Public boolean showErrorMessage{get; set;}
    Public boolean showErrorMessageNone{get; set;}
    Public string recordId{get; set;}
    Public Boolean isErrorOccur;
    Public string ConcanateStr;
    Public String FAFIdStr;
    Public Boolean checkBool;
    public SpecialtyLDLPricingDeleteClass(ApexPages.StandardController stdController){
        isErrorOccur = true;
        showErrorMessage = false;
        showErrorMessageNone = false;
        recordId = ApexPages.Currentpage().getParameters().get(ConstantsUtil.ID);
    }
    
    public pageReference deleteRecord(){
        try{
            Specialty_Legacy_Drug_Level_pricing__c specPricingRec = [select id, Pharmacy_Benefit__c, Price_List_Type__c, 
            Specialty_Ops__c from Specialty_Legacy_Drug_Level_pricing__c where id =: recordId];
            
            Id specOpsId = specPricingRec.Specialty_Ops__c;
            
            List<Specialty_Operations__c> sOPsList = [Select id,FAF_ID__c from Specialty_Operations__c where id =:specOpsId];
            
            FAFIdStr = sOPsList[0].FAF_ID__c;
            if(!string.isBlank(specOpsId)){
            
                    List<Specialty_Pricing__c> specOpsList = [select id  from Specialty_Pricing__c where Specialty_Operations__c =: specOpsId];
                    
                    if(specOpsList.size() > 0){
                        showErrorMessageNone = false;
                        isErrorOccur = false;
                    }else{
                    
                        ConcanateStr = specPricingRec.Pharmacy_Benefit__c;
                        Map<Id, Central_Hub__c> platformSpecificMap =new Map<Id, Central_Hub__c>([SELECT Id,Name,(SELECT Id, Name, Specialty_Pharmacy_Benefit_Price_List__c FROM Platform_Specifics__r where Specialty_Pharmacy_Benefit_Price_List__c!= null) FROM Central_Hub__c WHERE Id =:FAFIdStr ]);
                        List<Specialty_Legacy_Drug_Level_pricing__c> specPricingList = [select id, Specialty_Ops__r.FAF_ID__c, Pharmacy_Benefit__c, Price_List_Type__c, 
                        Specialty_Ops__c  from Specialty_Legacy_Drug_Level_pricing__c
                        where Specialty_Ops__c =: specOpsId];
                        checkBool = false;
                        showErrorMessageNone = true;
                        showErrorMessage = false;
                        if(platformSpecificMap.get(FAFIdStr).Platform_Specifics__r.size()>0){
                            if(specPricingList.size() > 1){
                                showErrorMessageNone = false;
                                isErrorOccur = false;
                            }
                        }else{
                                showErrorMessageNone = false;
                                isErrorOccur = false;
                             }
                  }  
                   
            }
            if(isErrorOccur){
                List<Platform_Specifics__c>platSpecList = new List<Platform_Specifics__c>();
                platSpecList = [select id, Specialty_Pharmacy_Benefit_Price_List__c, FAF_Id__c from Platform_Specifics__c
                 where FAF_Id__c =: FAFIdStr and Specialty_Pharmacy_Benefit_Price_List__c!= null ];
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
           
        }
        catch(exception e){
        system.debug('======e.getMessage()===='+e.getMessage());
        ApexPages.addMessages(e);
         }
        return null;
    }
}