public with sharing class Apttus_Specialty_Operation {
  
  
@AuraEnabled
public static List<ModelErrorMessage> beforeDelSpecialtyRecord(List<id> recordId) {

        List<Specialty_Pricing__c> lstOfspecPricingRec = [select id, FAF_ID__c, Pharmacy_Benefit__c, Price_List__c, 
        Specialty_Operations__c,FAF_ID__r.Name,Specialty_Operations__r.Name,name from Specialty_Pricing__c where id in: recordId];
        List<ModelErrorMessage> lstOfModel=new List<ModelErrorMessage>();
        //system.debug('lstOfspecPricingRec======>'+lstOfspecPricingRec);
        
        Set<Id> fafIdSet = new Set<Id>();
        for(Specialty_Pricing__c spPricingRec:lstOfspecPricingRec){
            if(spPricingRec.FAF_Id__c != null){
                fafIdSet.add(spPricingRec.FAF_Id__c);
            }
        }
        Map<Id, Central_Hub__c> platformSpecificMap =new Map<Id, Central_Hub__c>([SELECT Id,Name,(SELECT Id, Name, Specialty_Pharmacy_Benefit_Price_List__c FROM Platform_Specifics__r) FROM Central_Hub__c WHERE Id in:fafIdSet]);
       
   // system.debug('platformSpecificMap ::'+platformSpecificMap);
        for(Specialty_Pricing__c spPricingRec:lstOfspecPricingRec){
            if(spPricingRec.FAF_Id__c != null && platformSpecificMap.containsKey(spPricingRec.FAF_Id__c)){
                
                String pharmacyBenefit = spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c;
              if('None'.equalsIgnoreCase(spPricingRec.Pharmacy_Benefit__c)){
                    pharmacyBenefit = spPricingRec.Pharmacy_Benefit__c;
                }
               
               // system.debug('pharmacyBenefit value::'+pharmacyBenefit);
                for(Platform_Specifics__c psSpecific:platformSpecificMap.get(spPricingRec.FAF_Id__c).Platform_Specifics__r){
                    system.debug('Platform specific  List::'+platformSpecificMap.get(spPricingRec.FAF_Id__c).Platform_Specifics__r);
                    if(pharmacyBenefit.equalsIgnoreCase(psSpecific.Specialty_Pharmacy_Benefit_Price_List__c)){
                        
                        if('None'.equalsIgnoreCase(spPricingRec.Pharmacy_Benefit__c)){
                           lstOfModel.add( new ModelErrorMessage( spPricingRec.FAF_ID__r.Name+'-'+spPricingRec.Specialty_Operations__r.Name+'-'+spPricingRec.Name,'showErrorMessageNone'));
                           // spPricingRec.addError('Platform Specific record(s) exist with Specialty Pharmacy Benefit and Price List value "None". Please modify the platform specifics records which are utilizing the Specialty Pharmacy Benefit value of "None" before updating the value on "Specialty Pricing record.');
                        }else{
                            lstOfModel.add( new ModelErrorMessage( spPricingRec.FAF_ID__r.Name+'-'+spPricingRec.Specialty_Operations__r.Name+'-'+spPricingRec.Name,'showErrorMessage'));
                            //spPricingRec.addError('Platform Specific record(s) exist with "Specialty Pharmacy Benefit  and Price List" value(s) which is/are being updated/removed on Specialty Pricing. Please modify the platform specifics records which are utilizing the specific Specialty "Pharmacy Benefit" and "Price List" value combination.');
                        }
                        break;
                     }
                } 
            }
        }
        
    if(lstOfModel.isEmpty()){ 
    try{
            delete lstOfspecPricingRec;
        } catch(Exception ex){
             throw new AurahandledException(ex.getDmlMessage(0));
        }
    }
                
        return lstOfModel;
}
@AuraEnabled
public static String checkDelete(String recordId){
    boolean showErrorMessage =false;
    boolean showErrorMessageNone =false;
    boolean    isErrorOccur = false;
    String ConcanateStr ='';
    String FAFIdStr ='';
    boolean checkBool =false;
    
    Boolean returnAll =false;
    
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
                system.debug('specPricingList==>'+specPricingList);
                checkBool = true; 
                showErrorMessage = true;
                showErrorMessageNone = false;
                if(specPricingList.size() > 1){
                    showErrorMessage = false;
                    isErrorOccur = true;
                }
           }else if(specPricingRec.Pharmacy_Benefit__c == ConstantsUtil.const_None){
                ConcanateStr = specPricingRec.Pharmacy_Benefit__c;
                List<Specialty_Pricing__c> specPricingList = [select id, FAF_ID__c, Pharmacy_Benefit__c, Price_List__c, 
                Specialty_Operations__c from Specialty_Pricing__c where Pharmacy_Benefit__c =: specPricingRec.Pharmacy_Benefit__c
                and Specialty_Operations__c =: specOpsId];
               system.debug('specPricingRec.Pharmacy_Benefit__c==>'+specPricingRec.Pharmacy_Benefit__c+'specOpsId====>'+specOpsId);
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
              returnAll =true;
            }else{
                if(checkBool)
                    showErrorMessage = true;
                 else   
                    showErrorMessageNone = true;
                isErrorOccur = true;
            }  
       }     
     if(returnAll==false){  
         if(showErrorMessage){
             return 'showErrorMessage';
         }else if(showErrorMessageNone){
             return 'showErrorMessageNone';
         }else{
             return '';
         }       
     }else{
         return '';
     }
}
  public class ModelErrorMessage{  
    @AuraEnabled public String Name{get; set;}
    @AuraEnabled public String message{get; set;}
    
    public ModelErrorMessage(String Name, String message){
        this.message=message;
        this.Name=Name;
        
    }
 }       
@AuraEnabled
public static List <Specialty_Pricing__c> getSpecialtypricing(String sopId) {
List<Specialty_Pricing__c> specialtyPricings = new List<Specialty_Pricing__c>();

        List<Specialty_Pricing__c> specialtyPricing = [SELECT id, 
                                                   Year__c,
                                                   LOB__c,
                                                   Pharmacy_Benefit__c,
                                                   Price_List__c,
                                                   Open_HIV__c,
                                                   Specialty_Compare_Logic_On__c,
                                                   X340B_Pharmacy_Setup__c,
                                                   Brand_Basis__c,
                                                   Brand_Rate__c,
                                                   Brand_Dispensing_Fee__c,
                                                   Generic_Basis__c,
                                                   Generic_Rate__c,
                                                   Generic_Dispensing_Fee__c,
                                                   Non_MAC_Rate__c,
                                                   MAC_Modeled__c,
                                                   Match_Generics_to_Brands__c,
                                                   Biosimilars_Into_Brands__c,
                                                   New_to_Market_Brand_Rate__c,
                                                   New_to_Market_Generic_Rate__c,
                                                   LDD_No_Access_Rate__c,
                                                   Limited_Distribution_Drug_LDD_Rate__c,
                                                   Biosimilar_Rate__c,
                                                   Method__c,
                                                   Link__c,
                                                   Timeframe__c,
                                                   Level__c,
                                                   Allow_Specialty_To_Be_Dispensed_At_Ot__c,
                                                   Network_ID__c,
                                                   Non_CVS_Specialty_Pricing_Should_Mirror__c,
                                                   Calendar_Year_New_to_Market_Period_Flag__c,
                                                   Custom_Language_Neeeded_to_Limit_Pena__c,
                                                   Specialty_Operations__c
                                                   FROM Specialty_Pricing__c WHERE Specialty_Operations__c =:sopId ];
        for (Specialty_Pricing__c sp : specialtyPricing) {
            specialtyPricings.add(sp);
        }
        return specialtyPricings;
    }    
    
    @AuraEnabled 
    public static void deleteSpecialtyPricingRecord(String pricingRecId){
        System.debug('Delet Record Id:'+pricingRecId);
            Specialty_Pricing__c mailPricing = [SELECT Id From Specialty_Pricing__c where Id = :pricingRecId];
        try{
           delete mailPricing;
        } catch(Exception ex){
             throw new AurahandledException(ex.getDmlMessage(0));
        }
    }
     @AuraEnabled
    public static Boolean  avoidAccessForSalesUser(){
        
        Boolean val=true;
        user u =[select id ,profile.name,profileId from user where id=:Userinfo.getUserId()];
        if(u.profileId==Label.Apttus_sales_Profile || u.profileId==Label.Apttus_Operations_Profile_Id || Test.isRunningTest()){
            val=false;
       
        }
        return val;
    }
    
     @AuraEnabled
    public static void deleteSelectedRecords(List <Specialty_Pricing__c> selectedRecordList) {
       
        try{
            delete selectedRecordList;
        } catch(Exception ex){
            system.debug('Exception' +ex.getMessage());
            throw new AurahandledException(ex.getDmlMessage(0));
        }
    
}
    /*
    @AuraEnabled
    public static Boolean isDeleteButtonVisible () {
        Boolean isDeletable = false;
        isDeletable = Schema.sObjectType.Specialty_Pricing__c.isDeletable();
        return isDeletable; 
    }
    
    
    
     //Ajay added
    @AuraEnabled
    public static Boolean isNewButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Specialty_Pricing__c.isCreateable();
        return isCreateable;
    }
    
    @AuraEnabled
    public static Boolean isEditButtonVisible () {
        Boolean isCreateable = false;
        isCreateable = Schema.sObjectType.Specialty_Pricing__c.isUpdateable();
        return isCreateable;
        }
*/
}