public without sharing class addDrugRecordApexController {     
                        
    @AuraEnabled
    public static String createDrugLevelPricing(String fieldValParam, id specOpsId){
        string pharmacyBenefit = '';
        string lob = '';
        string returnText = '';
        map<id,Specialty_Operations__c> specOpsMap = new map<id,Specialty_Operations__c>([SELECT id, FAF_ID__c, (SELECT id,Pharmacy_Benefit__c,LOB__c FROM Specialty_Pricing__r ORDER BY createdDate ASC LIMIT 1) 
                                                                                         FROM Specialty_Operations__c
                                                                                         WHERE id =:specOpsId]);
        if(specOpsMap.size() > 0){
            list<Specialty_Pricing__c> specPricelist = specOpsMap.get(specOpsId).Specialty_Pricing__r;
            if(specPricelist.size() > 0){
                pharmacyBenefit = specPricelist[0].Pharmacy_Benefit__c;
                lob = specPricelist[0].LOB__c;
            }
            List<fieldValueWrapper> fiedValList = (List<fieldValueWrapper>) JSON.deserialize(fieldValParam, List<fieldValueWrapper>.class);    
            list<Specialty_Drug_Level_Pricing__c> specDrugLevelPricingList = new list<Specialty_Drug_Level_Pricing__c>();            
            for(fieldValueWrapper eachFiedlVal : fiedValList){
                returnTexT = returnText + eachFiedlVal.drugName;
                Specialty_Drug_Level_Pricing__c newSpecDrugLevPrice = new Specialty_Drug_Level_Pricing__c();
                newSpecDrugLevPrice.FAF_ID__c = specOpsMap.get(specOpsId).FAF_ID__c;
                newSpecDrugLevPrice.Specialty_Operations__c = specOpsId;
                newSpecDrugLevPrice.Year__c = eachFiedlVal.year;
                newSpecDrugLevPrice.LOB__c = lob;
                newSpecDrugLevPrice.Pharmacy_Benefit__c = pharmacyBenefit;
                newSpecDrugLevPrice.Drug_Therapy__c = eachFiedlVal.drugTherapy;
                newSpecDrugLevPrice.Drug_Name__c = eachFiedlVal.drugName;
                newSpecDrugLevPrice.Drug_Type__c = eachFiedlVal.drugType;
                newSpecDrugLevPrice.MAC__c = eachFiedlVal.mac;
                newSpecDrugLevPrice.Rate__c = eachFiedlVal.rate;
                newSpecDrugLevPrice.Notes__c = eachFiedlVal.notes;
                specDrugLevelPricingList.add(newSpecDrugLevPrice);
            }
            if(specDrugLevelPricingList.size() > 0 ){
            	insert specDrugLevelPricingList;
        	}
        }
        
                                          		        
        return 'Apex=======' + returnTexT;        		        
    }
    
    @AuraEnabled(cacheable=true)
    public static list<String> getYear(id specOpsId){
        list<string> retString = new list<string>();
        map<id,Specialty_Operations__c> specOpsMap = new map<id,Specialty_Operations__c>([SELECT id,FAF_ID__c, (SELECT id FROM Specialty_Pricing__r ORDER BY createdDate DESC LIMIT 1) 
                                                                                         FROM Specialty_Operations__c
                                                                                         WHERE id =:specOpsId]);
        if(specOpsMap.size()> 0){
            list<Client_Information__c> clientInfoList = [SELECT id, Escalating_Pricing__c, Year_1__c,
                                                         Year_2__c, Year_3__c, Year_4__c, Year_5__c
                                                         FROM Client_Information__c 
                                                         WHERE FAF_ID__c =: specOpsMap.get(specOpsId).FAF_ID__c LIMIT 1];
            if(clientInfoList.size() > 0){
                if(clientInfoList[0].Escalating_Pricing__c){
                    if(clientInfoList[0].Year_1__c != null){
                        retString.add('1');
                    }
                    if(clientInfoList[0].Year_2__c != null){
                        retString.add('2');
                    }
                    if(clientInfoList[0].Year_3__c != null){
                        retString.add('3');
                    }
                    if(clientInfoList[0].Year_4__c != null){
                        retString.add('4');
                    }
                    if(clientInfoList[0].Year_5__c != null){
                        retString.add('5');
                    }
                    retString.add('All');                    
                }else{
                     retString.add('All');
                }
            }else{
                 retString.add('All');
            }
        }    	        
        return retString;
    }
    
    @AuraEnabled(cacheable=true)
    public static wrapperClass checkDuplicateExist(String fieldValParam, id specOpsId){
        wrapperClass returnwrapperClass = new  wrapperClass ();
        boolean wrapper_isDuplicateFound = false;
        List<fieldValueWrapper> wrapper_fieldValueList = new list<fieldValueWrapper>();
        
        List<fieldValueWrapper> fiedValList = (List<fieldValueWrapper>) JSON.deserialize(fieldValParam, List<fieldValueWrapper>.class);            
        map<string,fieldValueWrapper> fieldValMap = new map<string,fieldValueWrapper>();
        for(fieldValueWrapper eachFiedlVal : fiedValList){
            string concatKey = eachFiedlVal.year + eachFiedlVal.drugTherapy + eachFiedlVal.drugName;
        	fieldValMap.put(concatKey.toUpperCase(),eachFiedlVal);     
        }
        
        
        map<string,Specialty_Drug_Level_Pricing__c> specDrugLevMap = new map<string,Specialty_Drug_Level_Pricing__c>();
        for(Specialty_Drug_Level_Pricing__c eachDrugPring : [SELECT id, Year__c, Drug_Therapy__c, Drug_Name__c
                                                            FROM Specialty_Drug_Level_Pricing__c 
                                                            WHERE Specialty_Operations__c =:specOpsId]){
 			string concatKey2 = eachDrugPring.Year__c + eachDrugPring.Drug_Therapy__c + eachDrugPring.Drug_Name__c;
            specDrugLevMap.put(concatKey2.toUpperCase(),eachDrugPring);            
        }
        
        string wrapper_returnText = '';
        /*
        for(string eachStr : fieldValMap.keyset()){
            wrapper_returnText = wrapper_returnText + eachStr;
        }
        */
        
        string wrapper_returnText2 = '';
        /*
        for(string eachStr2 : specDrugLevMap.keyset()){
            //if(specDrugLevMap.get(eachStr2).Drug_Name__c == 'test1'){
              wrapper_returnText2 = wrapper_returnText2 + '-' + specDrugLevMap.get(eachStr2).Drug_Name__c;  
            //}
            
        }
        */
        for(string eachStr3 : fieldValMap.keyset()){
            if(specDrugLevMap.containskey(eachStr3)){
                wrapper_fieldValueList.add(fieldValMap.get(eachStr3));
                wrapper_isDuplicateFound = true;
            }
        }
        
        returnwrapperClass.returnText = wrapper_returnText;
        returnwrapperClass.returnText2 = wrapper_returnText2;
        returnwrapperClass.fieldValueList = wrapper_fieldValueList;
        returnwrapperClass.isDuplicateFound = wrapper_isDuplicateFound;
        return returnwrapperClass;
    }
    
    public class wrapperClass{
        @AuraEnabled public boolean isDuplicateFound{get;set;}
        @AuraEnabled public string returnText{get;set;}
        @AuraEnabled public string returnText2{get;set;}
        @AuraEnabled public List<fieldValueWrapper> fieldValueList{get;set;}       
    }
                   
    public class fieldValueWrapper {
        @AuraEnabled
        public integer id{get;set;}
        @AuraEnabled
        public String drugTherapy{get;set;}
        @AuraEnabled
        public String drugName{get;set;}
        @AuraEnabled
        public String drugType{get;set;}
        @AuraEnabled
        public Double rate{get;set;}
        @AuraEnabled
        public String year{get;set;}
        @AuraEnabled
        public String notes{get;set;}
        @AuraEnabled
        public Boolean mac{get;set;}
        
        
        public fieldValueWrapper(Integer Temp_id,String Temp_drugTherapy,  String Temp_drugName, String Temp_drugType, Double Temp_rate, String Temp_year,String Temp_notes, Boolean Temp_mac) {
            id = Temp_id;
            drugTherapy = Temp_drugTherapy;
            drugName = Temp_drugName;
            drugType = Temp_drugType;
            rate = Temp_rate;
            year = Temp_year;
            notes = Temp_notes;
            mac = Temp_mac;            
        }    
    }
    
}