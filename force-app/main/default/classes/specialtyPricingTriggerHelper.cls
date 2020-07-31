/* ====================================================================
 * @Class Name        : specialtyPricingTriggerHelper
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 02/08/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 02/08/2018
 * @Purpose           : This is the Helper class for Specility Pricing Trigger
========================================================================*/
public with sharing class specialtyPricingTriggerHelper{
public static boolean PBANDPLChanged=false;
 public static final String None = 'None';
    /******************************************************************************************************************************
     * @Method Name       : SpecialtyPriceNewEditClass
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Method used to check duplicay on year and LOB in Broker TPA
     *******************************************************************************************************************************/
    public static void validateLobYearCombinalion(List<Specialty_Pricing__c> specPriceList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            Map<Id, set<string>> parentChildMap = new Map<Id, set<string>>(); //Map used to add Speciality Operation Id, year, Lob and Pharmacy Benefit combination in all associated Speciality Pricing
            Map<string, MAP<string, Id>> specPriceIdRelatMap = new Map<string, MAP<string, Id>>();  //Map used to check the combination of Specialty Operation Id and Specialty Pricing Id
            MAP<string, Id> tempMap;
            set<Id> specOpsIdSet = new set<Id>();  //Set contain the Specialty operation id
            set<string> concatinateStr = new set<string>(); //set created to add year and LOB combination in set
            Set<Id>specialtyOprIdSet = new Set<Id>();   //Used to add Specialty operation id for pass in the query
            String str; 
            String str1;
            List<Specialty_Pricing__c> specPriceRecList = new List<Specialty_Pricing__c>();
            
            //Iterate over all Specialty Pricing which are present in the specPriceList list
            for(Specialty_Pricing__c specPric: specPriceList){    
                specialtyOprIdSet.add(specPric.specialty_Operations__c);
            }
            
            //Query data from Specialty Operation Object
            specPriceRecList = [select id, Specialty_operations__c, year__c, LOB__c, Pharmacy_Benefit__c from Specialty_Pricing__c
            where Specialty_operations__c in: specialtyOprIdSet];
            system.debug('==========specPriceRecList=============='+specPriceRecList);
            
            //Iterate over all Specialty Operation which are present in the specPriceList list
            for(Specialty_Pricing__c specPric: specPriceRecList){
                tempMap = new Map<string,Id>();
                concatinateStr = new set<string>();
                if(specOpsIdSet.size()>0){
                    if(specOpsIdSet.contains(specPric.specialty_Operations__c)){
                        concatinateStr.addall(parentChildMap.get(specPric.specialty_Operations__c));   //add all value present with the concerned Specialty Operation
                        concatinateStr.add(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c);  //concatenate and add new value in the set
                        parentChildMap.put(specPric.specialty_Operations__c, concatinateStr);
                        tempMap.put(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c, specPric.Id);     //temp map which contain the year,LOB combination as key and Specialty Pricing id and value
                        str = string.valueOf(specPric.specialty_Operations__c)+string.valueOf(specPric.Id);  //concatenate Specialty Operation id and Specialty pricing Id 
                        specPriceIdRelatMap.put(str,tempMap);
                    }else{
                        concatinateStr.add(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c);   //concatenate and add new value in the set
                        specOpsIdSet.add(specPric.specialty_Operations__c);
                        parentChildMap.put(specPric.specialty_Operations__c, concatinateStr);
                        tempMap.put(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c, specPric.Id);      //temp map which contain the year,LOB combination as key and Specialty Pricing id and value
                        str = string.valueOf(specPric.specialty_Operations__c)+string.valueOf(specPric.Id);   //concatenate Specialty Operation id and Specialty pricing Id 
                        specPriceIdRelatMap.put(str,tempMap);
                    }
                }else{  //This condition will execute first time the loop will execute
                    concatinateStr.add(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c);   //concatenate and add new value in the set
                    specOpsIdSet.add(specPric.specialty_Operations__c);
                    parentChildMap.put(specPric.specialty_Operations__c, concatinateStr);
                    tempMap.put(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c, specPric.Id);       //temp map which contain the year,LOB combination as key and Specialty Pricing id and value
                    str = string.valueOf(specPric.specialty_Operations__c)+string.valueOf(specPric.Id);       //concatenate Specialty Operation id and Specialty pricing Id 
                    specPriceIdRelatMap.put(str,tempMap);
                }
            }
            
            system.debug('=========parentChildMap======'+parentChildMap);
            system.debug('=========specPriceIdRelatMap======'+specPriceIdRelatMap);
            if(isUpdateBool){  //Value to check it is insert case or Update
                for(Specialty_Pricing__c specPric: specPriceList){
                    if(specOpsIdSet.contains(specPric.specialty_Operations__c)){   //check specOpsIdSet set contain Specialty Operation
                        system.debug('============specPric=========='+specPric);
                        if(parentChildMap.get(specPric.specialty_Operations__c).contains(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c)){   //verify that set associated with unique Specialty Operation contains the year, Lob, Pharmacy Benefit combination
                            str1 = specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c;
                            str = string.valueOf(specPric.specialty_Operations__c)+string.valueOf(specPric.Id);   //concatenate Specialty Operation and Specialty pricing id 
                            if(specPriceIdRelatMap.get(str).get(str1) != specPric.id){      //For exclude the update condition
                                specPric.addError(ConstantsUtil.SPECPRICVALMSG);   //Display error
                            }
                        }
                    }     
                }
            }
            if(isInsertBool){ //Boolean used to identify the insert scenario
                for(Specialty_Pricing__c specPric: specPriceList){
                    if(specOpsIdSet.contains(specPric.specialty_Operations__c)){
                        if(parentChildMap.get(specPric.specialty_Operations__c).contains(specPric.year__c + specPric.LOB__c + specPric.Pharmacy_Benefit__c)){  //verify that set associated with unique Specialty Operation contains the year, Lob, Pharmacy Benefit  combination
                            specPric.addError(ConstantsUtil.SPECPRICVALMSG);  //Display error
                        }
                    }     
                }
            }
        }catch(Exception excp){
            ApexPages.addMessages(excp);
        }
    }
    /******************************************************************************************************************************
     * @Method Name       : PharmBenefitValueDupCheck
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 10/08/2018
     * @Purpose           : Method used to avoid user to update or delete a specialty pricing when platform specific field also has None
     *******************************************************************************************************************************/
        public static void PharmBenefitValueDupCheck(List<Specialty_Pricing__c> specPriceList, Boolean isUpdateBool, Boolean isDeleteBool, Map<Id, Specialty_Pricing__c> specPriceOldMap,List<Specialty_Pricing__c> specPriceOldList){
     map<id,set<Specialty_Pricing__c>> mapFAFandSpecPric = new map<id,set<Specialty_Pricing__c>>();
     set<id> FAFIdsSet = new set<id>();
     set<id> FAFIdPlatSpecSet = new set<id>();
     set<Specialty_Pricing__c> specPricIdsSet = new set<Specialty_Pricing__c>();
     list<Specialty_Pricing__c> specPriceRecList = new list<Specialty_Pricing__c>();
     if(isUpdateBool){  //Value to check it is Update or Delete 
     for(Specialty_Pricing__c spec :specPriceList){
        FAFIdsSet.add(spec.FAF_ID__c);
    }

     List<Platform_Specifics__c> platSpecList;
     platSpecList = [select id,FAF_ID__c,Specialty_Pharmacy_Benefit_Price_List__c from Platform_Specifics__c where FAF_ID__c =:FAFIdsSet and Specialty_Pharmacy_Benefit_Price_List__c =:None];    
    
    for(Platform_Specifics__c ps: platSpecList){
    FAFIdPlatSpecSet.add(ps.FAF_ID__c);
    }
     
     
     specPriceRecList = [select id,FAF_ID__c,Pharmacy_Benefit__c from Specialty_Pricing__c where FAF_ID__c in:FAFIdsSet];
         
     for(Specialty_Pricing__c specPric: specPriceRecList){
            if(String.isNotBlank(specPric.Pharmacy_Benefit__c) && specPric.Pharmacy_Benefit__c.equals(ConstantsUtil.const_None)){
            specPricIdsSet.add(specPric);
            }
            mapFAFandSpecPric.put(specPric.FAF_ID__c,specPricIdsSet); 
          }
       
  
        for(Specialty_Pricing__c specPric: specPriceList){
        if(mapFAFandSpecPric.get(specPric.FAF_ID__c).size() == 1 && FAFIdPlatSpecSet.contains(specPric.FAF_ID__c) && specPriceOldMap.get(specPric.id).Pharmacy_Benefit__c.equals(ConstantsUtil.const_None) && specPric.Pharmacy_Benefit__c != specPriceOldMap.get(specPric.id).Pharmacy_Benefit__c ){
        specPric.addError(ConstantsUtil.SPECIALITYPRICINGERRORMESSAGE);
        }       
    }
    }
   
    }
    /******************************************************************************************************************************
     * @Method Name       : onUpdateSpecialtyPricing
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 12/18/2019
     * @Purpose           : Method to show error message if Price Lisr or/and Pharmacy benefit value got updated and met some specific criteria
     *******************************************************************************************************************************/
    public static void onUpdateSpecialtyPricing(List<Specialty_Pricing__c> specPriceList, MAP<id, Specialty_Pricing__c> oldSpecPriceMap, MAP<id, Specialty_Pricing__c> newSpecPriceMap, Boolean isDeleteBool, Boolean isUpdateBool) {
        try{
            set<string> pharmacyBenefitSet = new set<string>(); //Set to hold value of pharmacy Benefit in Specialty Pricicng
            set<string> priceListSet = new set<string>();   //Set to hold value of pricelist in Specialty Pricicng
            List<Platform_Specifics__c>platSpecList = new List<Platform_Specifics__c>();  //List to store the value of Platform_Specifics__c record
            List<Specialty_Pricing__c>specPricingList = new List<Specialty_Pricing__c>();
            Set<Id>specOperationIdSet = new Set<Id>();  //Set to hold specialty Pricing Record id
            set<string> tempSet, tempSet1, tempSet2, tempSet3;
            String tempstr, tempstr1, strConcatnate, strConcatnateWithSpOps;
            Map<string,set<string>> SpecIdPricingCombinationMap = new Map<string,set<string>>();     //Map use to hold the Specialty Operaion Id as a key and Pharamacy Benefit and priceList combination set as value
            MAP<string, String> FAFIdPricingCombinationMap = new MAP<string, String>();   //Map use to hold the Faf id and Specialty Pricing Id combination Id as a key and Pharamacy Benefit and priceList combination set as value
            Map<string, set<string>>FAFIdSpecialtyPricingMap = new MAP<string, set<string>>();  //Map use to hold the Faf id as a key and specialty Pricing Id set as value
            Map<string, set<string>>specOpsFAFIdConcatination = new MAP<string, set<string>>(); //Map use to hold the Faf id as a key and specialty Pricing Id set as value
            set<string>FAFIdSpecialtyPricingSet = new set<string>();  
            set<string>specPricIdSet = new set<string>();
            set<string>FAFIdPricingCombinationSet = new set<string>();
            set<string>specOperationrelationSet = new set<string>();

            if(isUpdateBool){ //for verify record is updated
                for(Specialty_Pricing__c spec: specPriceList){
                    
                    //For check Pharmacy Benefit or Prices has been update or nor
                    if((spec.Pharmacy_Benefit__c != oldSpecPriceMap.get(spec.id).Pharmacy_Benefit__c || spec.Price_List__c != oldSpecPriceMap.get(spec.id).Price_List__c) && isUpdateBool){
                        
                        //concatinate the old pharmacy Benefit value and Price List value
                        strConcatnate = oldSpecPriceMap.get(spec.id).Pharmacy_Benefit__c+ConstantsUtil.hyphenStr+oldSpecPriceMap.get(spec.id).Price_List__c;
                        
                        //concatinate the specialty operation Id, old pharmacy Benefit value and Price List value
                        strConcatnateWithSpOps = string.valueOf(spec.Specialty_Operations__c)+oldSpecPriceMap.get(spec.id).Pharmacy_Benefit__c+ConstantsUtil.hyphenStr+oldSpecPriceMap.get(spec.id).
                        Price_List__c;
                        tempstr = string.valueOf(spec.FAF_ID__c)+string.valueOf(spec.id);
                        pharmacyBenefitSet.add(oldSpecPriceMap.get(spec.id).Pharmacy_Benefit__c);
                        priceListSet.add(oldSpecPriceMap.get(spec.id).Price_List__c);
                        FAFIdPricingCombinationMap.put(tempstr, strConcatnate);
                        FAFIdPricingCombinationSet.add(tempstr);
                        tempSet = new set<string>();
                        if(specOperationIdSet.contains(spec.Specialty_Operations__c)){ 
                            tempSet.addall(SpecIdPricingCombinationMap.get(spec.Specialty_Operations__c));
                            tempSet.add(strConcatnate);
                            SpecIdPricingCombinationMap.put(spec.Specialty_Operations__c, tempSet);
                        }else{
                            tempSet.add(strConcatnate);
                            SpecIdPricingCombinationMap.put(spec.Specialty_Operations__c, tempSet);
                        }
                        specOperationIdSet.add(spec.Specialty_Operations__c);
                        tempSet1 = new set<string>();
                        tempSet2 = new set<string>();
                        tempSet3 = new set<string>();
                        if(specOperationrelationSet.contains(strConcatnateWithSpOps)){
                            tempSet2.addall(specOpsFAFIdConcatination.get(strConcatnateWithSpOps));
                            tempSet2.add(spec.FAF_Id__c);
                            specOpsFAFIdConcatination.put(strConcatnateWithSpOps, tempSet2);
                        }else{
                            tempSet2.add(spec.FAF_ID__c);
                            specOpsFAFIdConcatination.put(strConcatnateWithSpOps, tempSet2);
                        }
                        specOperationrelationSet.add(strConcatnateWithSpOps);
                        if(FAFIdSpecialtyPricingSet.contains(spec.FAF_Id__c)){
                            tempSet3.addall(FAFIdSpecialtyPricingMap.get(spec.FAF_Id__c));
                            tempSet3.add(spec.id);
                            FAFIdSpecialtyPricingMap.put(spec.FAF_Id__c, tempSet3);
                        }else{
                            tempSet3.add(spec.id);
                            FAFIdSpecialtyPricingMap.put(spec.FAF_Id__c, tempSet3);
                        }
                        FAFIdSpecialtyPricingSet.add(spec.FAF_Id__c);
                        specPricIdSet.add(spec.id);
                    }
                }
            }

            tempSet = new set<string>();
            //query the Specialty Pricing record
            specPricingList = [select id, FAF_ID__c, Pharmacy_Benefit__c, Price_List__c, Specialty_Operations__c from Specialty_Pricing__c where Specialty_Operations__c in: specOperationIdSet and Pharmacy_Benefit__c in: pharmacyBenefitSet and Price_List__c in: priceListSet];
            Map<string, set<string>>forDuplicateCheckMap = new Map<string, set<string>>();
            Map<string, set<string>>finalRemoveDupLicateMap = new Map<string, set<string>>();
            Set<string>duplicateRecordSet = new set<string>();
            Set<string>forCheckduplicateSet = new set<string>();
            
            for(Specialty_Pricing__c specPric: specPricingList){
                if(specOperationIdSet.contains(specPric.Specialty_Operations__c)){  //if specialty OPeration id is in set
                    strConcatnate = specPric.Pharmacy_Benefit__c+ConstantsUtil.hyphenStr+specPric.Price_List__c;
                    string strConcatnateWithFAF = string.valueOf(specPric.FAF_ID__c)+string.valueOf(specPric.id);
                    strConcatnateWithSpOps = string.valueOf(specPric.Specialty_Operations__c)+strConcatnate;
                    if(!SpecIdPricingCombinationMap.get(specPric.Specialty_Operations__c).isEmpty() && SpecIdPricingCombinationMap.get(specPric.Specialty_Operations__c).contains(strConcatnate)){  //if SpecIdPricingCombinationMap contains specialty id for speciafic operation
                        tempSet = new set<string>();
                        if(forCheckduplicateSet.contains(strConcatnateWithSpOps)){
                            tempSet.addall(forDuplicateCheckMap.get(strConcatnateWithSpOps));
                            tempSet.add(specPric.id);
                            forDuplicateCheckMap.put(strConcatnateWithSpOps, tempSet);
                            specOpsFAFIdConcatination.remove(strConcatnateWithSpOps);   // for remove the value 
                            if(FAFIdPricingCombinationSet.contains(strConcatnateWithFAF)){
                                FAFIdPricingCombinationMap.remove(strConcatnateWithFAF);
                                FAFIdPricingCombinationSet.remove(strConcatnateWithFAF);
                            }
                        }else{
                            forCheckduplicateSet.add(strConcatnateWithSpOps);
                            tempSet.add(specPric.id);
                            forDuplicateCheckMap.put(strConcatnateWithSpOps, tempSet);
                        }
                    }
                }
            }
            Set<string>fafIdSetNew = new Set<string>();
            for(string str: specOpsFAFIdConcatination.keyset()){
                fafIdSetNew.addall(specOpsFAFIdConcatination.get(str));  
            }
            Specialty_Pricing__c spPricObj = new Specialty_Pricing__c();
            
            //Query Pharmacy Benefit Records
            platSpecList = [select id, Specialty_Pharmacy_Benefit_Price_List__c, FAF_Id__c from Platform_Specifics__c where FAF_Id__c =: fafIdSetNew];
            for(Platform_Specifics__c ps: platSpecList){
                for(string str: FAFIdSpecialtyPricingMap.get(ps.Faf_Id__c)){
                    if(FAFIdPricingCombinationSet.contains(ps.FAF_Id__c+str)){
                        if(ps.Specialty_Pharmacy_Benefit_Price_List__c == (FAFIdPricingCombinationMap.get(ps.FAF_Id__c+str))){
                            Specialty_pricing__c actualRecord;
                            if(isUpdateBool)
                                actualRecord = newSpecPriceMap.get(str); 
                            actualRecord.addError(ConstantsUtil.SPECIALITYPRICINGERRORMESSAGE1); // for show error Message
                        }
                    }
                }
            }
        }catch(Exception excp){
            system.debug('===============excp============'+excp);
        }
    }
    
    public static void validateSpciality(List<Specialty_Pricing__c> specPriceList, Boolean isDelete, Boolean isUpdate,String NewValue,Boolean PbEnable){
        system.debug('validateSpciality() method START ::');
        Set<Id> fafIdSet = new Set<Id>();
        Map<ID,String> newPharmMap=new Map<ID,String>();  //added by sonal sharma to store new pharmacy benefit and pric elist value.
        try{
        for(Specialty_Pricing__c spPricingRec:specPriceList){
            if(spPricingRec.FAF_Id__c != null){
                fafIdSet.add(spPricingRec.FAF_Id__c);
            }
        }
        
        Map<Id, Central_Hub__c> platformSpecificMap =new Map<Id, Central_Hub__c>([SELECT Id,Name,(SELECT Id,FAF_ID__c, Name, Specialty_Pharmacy_Benefit_Price_List__c FROM Platform_Specifics__r),(SELECT Id, Name,FAF_ID__c, Pharmacy_Benefit__c,Price_List__c FROM Specialty_Pricing__r) FROM Central_Hub__c WHERE Id in:fafIdSet]);
        Map<String,Map<String,Integer>> spriceMap = new Map<String,Map<String,Integer>>();
        for(Id fafId: platformSpecificMap.keyset()){
            if(platformSpecificMap.get(fafId).Specialty_Pricing__r.size()>0){
                for(Specialty_Pricing__c spPricingRec:platformSpecificMap.get(fafId).Specialty_Pricing__r){
                    System.debug('--here--'+spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c);
                    String pharmacyBenefit = spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c;
                    newPharmMap.put(spPricingRec.FAF_ID__c,pharmacyBenefit);
                    if(spriceMap.containskey(fafId)){
                        Map<String,Integer> innerMap1 = spriceMap.get(fafId);
                        system.debug('---innerMap1 ---'+innerMap1 );
                        if(innerMap1.containskey(pharmacyBenefit)){
                            System.debug('--here2--'+spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c);
                            Map<String,Integer> innerMap = spriceMap.get(fafId);                   
                            innerMap.put(pharmacyBenefit,innerMap.get(pharmacyBenefit)+1);
                            spriceMap.put(fafId,innerMap) ;
                          }else{
                                System.debug('--here3--'+spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c);  
                                Map<String,Integer> innerMap = spriceMap.get(fafId);                    
                                innerMap.put(pharmacyBenefit,1);
                                spriceMap.put(fafId,innerMap) ;  
                               }     
                      }else{
                            System.debug('--here1-'+spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c);  
                            Map<String,Integer> innerMap = new Map<String,Integer>();                   
                            innerMap.put(pharmacyBenefit,1);
                            spriceMap.put(fafId,innerMap) ;  
                           }  
                }
            }    
        }
        
        
        for(Specialty_Pricing__c spPricingRec:specPriceList){
            if(spPricingRec.FAF_Id__c != null && platformSpecificMap.containsKey(spPricingRec.FAF_Id__c)){
                
                String pharmacyBenefit = spPricingRec.Pharmacy_Benefit__c+'-'+spPricingRec.Price_List__c;
              if('--None--'.equalsIgnoreCase(spPricingRec.Pharmacy_Benefit__c)){
                    pharmacyBenefit = spPricingRec.Pharmacy_Benefit__c;
                }
                System.debug('----'+spriceMap);
                if(spriceMap.get(spPricingRec.FAF_Id__c).get(pharmacyBenefit)== 1){
                system.debug('pharmacyBenefit value::'+pharmacyBenefit);
                for(Platform_Specifics__c psSpecific:platformSpecificMap.get(spPricingRec.FAF_Id__c).Platform_Specifics__r){
                    system.debug('Platform specific  List::'+platformSpecificMap.get(spPricingRec.FAF_Id__c).Platform_Specifics__r);
                    if(pharmacyBenefit.equalsIgnoreCase(psSpecific.Specialty_Pharmacy_Benefit_Price_List__c) && newPharmMap.get(psSpecific.FAF_ID__c)!=NewValue && PbEnable==true){
                        if('None'.equalsIgnoreCase(spPricingRec.Pharmacy_Benefit__c)){
                            spPricingRec.addError('Platform Specific record(s) exist with Specialty Pharmacy Benefit and Price List value \'None\'. Please modify the platform specifics records which are utilizing the Specialty Pharmacy Benefit value of "None" before updating the value on \'Specialty Pricing record\'.');
                        }else{
                            
                            spPricingRec.addError('Platform Specific record(s) exist with \'Specialty Pharmacy Benefit and Price List\' value(s) which is/are being updated/removed on Specialty Pricing. Please modify the platform specifics records which are utilizing the specific Specialty \'Pharmacy Benefit\' and \'Price List\' value combination.');
                        }
                        break;
                    }
                }
              }  
            }
        }
        }catch(Exception ex){
            system.debug('Line Number'+ex.getLineNumber()+'::Error Message::'+ex.getMessage());
            specPriceList[0].addError(ex.getMessage());
        }
        
    }
}