/* =================================================================================
 * @Class Name        : DeepCloneUtility
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 13/07/2018
 * @Purpose           : Deep Clone functionality
=======================================================================================*/
public without sharing class DeepCloneUtility{
    
    /* =================================================================================
    * @Method Name        : myException
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public class myException extends Exception {}
    
     static final String OWNERID_FIELD = 'OwnerId';
     static final String UNIQUE_KEY = 'Unique Key';
     static final String TRUE_VALUE = 'true';
     static final String Name_VALUE = 'Name';
     static final String FALSE_VALUE = 'false';
     public static boolean firstPass = true;
     public static boolean OFF_TRIGGERS_PROCBUILDER = true;
     public static boolean HistoryCheck = true;
     public static boolean OFF_INVOCABLE_CLASS = true;  // PCD Change
     static final String BILLINGOPS='Billing_Operations__c';
    
   
    /* =================================================================================
    * @Method Name       : getSObjectFieldSet
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public static Map<String, Schema.SObjectField> getSObjectFieldSet(String sObjectName) {
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        return describeResult.fields.getMap();
    }
    
    /* =================================================================================
    * @Method Name       : getSObjectRecords
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public static List<SObject> getSObjectRecords(String sObjectName, String filterField, Set<Id> filterValues, String addtlFilterField, Set<String> addtlFilterValues) {
        String soql = String.format('SELECT {0} FROM {1} WHERE {2} in :filterValues',
                                        new String[] {
                                            String.join(new List<String>(getSObjectFieldSet(sObjectName).keySet()),','),
                                                sObjectName,
                                                filterField
                                        }
                                   );
        
        // this is an additional filter
        if (!String.isEmpty(addtlFilterField)) {
                String firstelement = (new list<String>(addtlFilterValues))[0];
                if (firstelement.equalsIgnoreCase(TRUE_VALUE) || firstelement.equalsIgnoreCase(FALSE_VALUE)) {
                                soql += ' AND ' + addtlFilterField + ' = ' + firstelement;
                } else {
                soql += ' AND ' + addtlFilterField + ' in :addtlFilterValues';
                }
        }
        return Database.query(soql);
    }
        
    /* =================================================================================
    * @Method Name       : getSObjectIds
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public static Map<Id, Id> getSObjectIds(Map<Id, SObject> mapSObject) {
        Map<Id, Id> mapSObjectIds = new Map<Id, Id>();
        for (Id sObjectId : mapSObject.keySet()) {
            mapSObjectIds.put(sObjectId, mapSObject.get(sObjectId).Id);
        }
        return mapSObjectIds;
    }
     /* =================================================================================
    * @Method Name       : cloneRelatedSObject
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public static Map<Id, SObject> cloneRelatedSObject(String sObjectName, String filterField, Map<Id, SObject> mapSObject, Map<String, String> benefitStructuresId, Map<String, String> fieldsToReset,String SourceID) { 
        return cloneRelatedSObject(sObjectName, filterField, new Map<String, Map<Id,Id>>{filterField => getSObjectIds(mapSObject)}, benefitStructuresId, fieldsToReset,SourceID);
    }
     /* =================================================================================
    * @Method Name       : cloneRelatedSObject
    * @author            : Mohit Srivastava(Accenture)
    * @created date      : 13/07/2018
    * @Purpose           : Deep Clone functionality
    =======================================================================================*/
    public static Map<Id, SObject> cloneRelatedSObject(String sObjectName, String keyFilterField, Map<String, Map<Id, Id>> referenceObjectIds, Map<String, String> benefitStructuresId, Map<String, String> fieldsToReset,string sourceID) {
        Map<Id, SObject> clonedRelated = new Map<Id, SObject>();
        Map<String, Schema.SObjectField> fieldMap =  DeepCloneUtility.getSObjectFieldSet(sObjectName);
        Boolean hasOwnerField = fieldMap.containsKey(OWNERID_FIELD.toLowerCase()); 
        String key, resetValue, oldBenStructId, addtlFilterField;
        Boolean resetBool;
        Set<String> addtlFilterValues = new Set<String>();
        SObject cloneSObj;
        Integer counter = 0;
        
        for (SObject obj : getSObjectRecords(sObjectName, keyFilterField, referenceObjectIds.get(keyFilterField).keySet(), addtlFilterField, addtlFilterValues)) {
            cloneSObj = obj.clone(false, true);
            if (hasOwnerField) {
                cloneSObj.put(OWNERID_FIELD, userInfo.getUserId());
            }            
            
            // resets the field value
            if (fieldsToReset != null) {
                for (String fieldName: fieldsToReset.keySet()) {
                    if (fieldMap.containsKey(fieldName)) {
                        resetValue = fieldsToReset.get(fieldName);
                       // if (resetValue == UNIQUE_KEY) {
                            //considered String data type only
                            key = String.valueOf(obj.get(fieldName));
                            system.debug('key key fieldNamekey key key key key key ' +fieldName);
                            // unique key is not empty and has benefitstructure ids
                            if (fieldName=='Source_Record_ID__c') {
                            String SourceNAme;
                               
                            system.debug('obj.Name'+obj.get(Name_VALUE));
                            resetValue=String.valueOf(obj.get(Name_VALUE));
                            //cloneSObj.put(fieldName, resetValue); 
                            } 
                                    else if(resetValue=='FALSE')
                                    {
                                       resetBool=false;
                                       cloneSObj.put(fieldName, resetBool); 
                                       System.debug('**cloneSObj**'+cloneSObj);
                                    }
                                    else{
                                        resetValue = null;
                                         cloneSObj.put(fieldName, resetValue); 
                                        
                            }
                            /*if(resetValue=='Null')
                            {
                            system.debug('**********************');
                                resetValue=null;
                            }
                            if(resetValue=='FALSE')
                            {
                                resetBool=false;
                                 cloneSObj.put(fieldName, resetBool); 
                                 System.debug('**cloneSObj**'+cloneSObj);
                            }*/
                            
                            
                       // }
                       
                       
                    }
                }
            }       
            
            // sets up the lookup field value
            for (String lookupField : referenceObjectIds.keySet()) {
                Map<Id, Id> mapSObject = referenceObjectIds.get(lookupField);
                if (!mapSObject.isEmpty()) {
                    Id lookupId = (Id)obj.get(lookupField);
                    cloneSObj.put(lookupField, mapSObject.get(lookupId));
                    
                }
            }
            counter++;
            clonedRelated.put(obj.Id, cloneSObj);
            cloneSObj = null;
        }
        
        firstpass = false;
       try{
       for(SObject soblisObj:clonedRelated.values()){
        Database.insert(clonedRelated.values());
        }
      }
      catch(Exception ex){
          System.debug('The Exception Occured'+ex.getMessage());
      }
        return clonedRelated;
    }
    
   /* =================================================================================
    * @Method Name       : PCDcloneRelatedSObject
    * @author            : Soumendu Chowdhury
    * @created date      : 06/21/2019
    * @Purpose           : Deep Clone functionality for PCD Questionaire response. This method is called from PCDQuestionAnswerTriggerHelper class
    =======================================================================================*/
    public static Map<Id, SObject> PCDcloneRelatedSObject(String sObjectName, String keyFilterField, Map<String, Map<Id, Id>> referenceObjectIds, Map<String, String> benefitStructuresId, Map<String, String> fieldsToReset,string sourceID) {
       
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        DeepCloneUtility.OFF_INVOCABLE_CLASS=false;
        /*
        Map<Id, SObject> clonedRelated = new Map<Id, SObject>();
        Map<String, Schema.SObjectField> fieldMap =  DeepCloneUtility.getSObjectFieldSet(sObjectName);
        Boolean hasOwnerField = fieldMap.containsKey(OWNERID_FIELD.toLowerCase()); 
        String key, resetValue, oldBenStructId, addtlFilterField;
        Boolean resetBool;
        Set<String> addtlFilterValues = new Set<String>();
        SObject cloneSObj;
        Integer counter = 0;
       List<Network_Pricing__c>  NetOps = new List<Network_Pricing__c>();
       List<Specialty_Pricing__c> SpecOps = new List<Specialty_Pricing__c>();
       List<SObject> SpecList = new List<SObject>();
        List<Rebate_Guarantees__c> RebateGtee = new List<Rebate_Guarantees__c>();
        if(sObjectName == 'Network_Pricing__c')
        {
            NetOps = [SELECT ID,FAF_ID__c,FAF_Network_Ops__c,Network_Name__c,Network_Type__c,LOB__c,Retail_Network_Ordinal__c,Year__c,Custom_Network_Description__c FROM Network_Pricing__c where FAF_ID__c= :referenceObjectIds.get(keyFilterField).keySet()]; 
        } 
        else if(sObjectName == 'Specialty_Pricing__c')
        {
            SpecOps = [SELECT  ID,FAF_ID__c,Specialty_Operations__c,Brand_Basis__c,Exclude_Specialty_Class__c,LOB__c,Select_Specialty_Exclusion__c,Year__c,Pharmacy_Benefit__c,Open_HIV__c FROM Specialty_Pricing__c where FAF_ID__c= :referenceObjectIds.get(keyFilterField).keySet()]; 
        }    
        else if(sObjectName == 'Rebate_Guarantees__c')
        {
            RebateGtee = [SELECT  ID,FAF_ID__c,Rebate_Operations__c,Year__c,Plan_Design__c,LOB2__c FROM Rebate_Guarantees__c where FAF_ID__c = :referenceObjectIds.get(keyFilterField).keySet()]; 
        }      
        for (SObject obj : getSObjectRecords(sObjectName, keyFilterField, referenceObjectIds.get(keyFilterField).keySet(), addtlFilterField, addtlFilterValues)) {
            Boolean recexist = false;
            cloneSObj = obj.clone(false, true);
            if (hasOwnerField) {
                cloneSObj.put(OWNERID_FIELD, userInfo.getUserId());
            }            
            // resets the field value
            if (fieldsToReset != null) {
                for (String fieldName: fieldsToReset.keySet()) {
                    if (fieldMap.containsKey(fieldName)) {
                        resetValue = fieldsToReset.get(fieldName);
                            //considered String data type only
                            key = String.valueOf(obj.get(fieldName));
                            // unique key is not empty and has benefitstructure ids
                            if (fieldName=='Source_Record_ID__c')  
                            {               
                                       String SRcId= String.valueOf(obj.get('Id'));
                                       cloneSObj.put('Source_Record_ID__c', SRcId);
                            } 
                            else if(fieldName=='Network_Type__c' && resetValue == 'PCD') // PCD Change
                            {          
                                       String ntype= String.valueOf(obj.get(fieldName));
                                       if (ntype == 'Locked')
                                       {
                                        cloneSObj.put(fieldName, 'Transparent'); 
                                       }
                                       else {cloneSObj.put(fieldName, 'Locked');}
                                 
                             }
                            else if(fieldName=='Agreement_Line_Item__c') // PCD Change
                            {
                              cloneSObj.put(fieldName, resetValue);
                            }                             
                            else if(fieldName=='Network_Pricing__c' ) // PCD Change
                            {          
                                       cloneSObj.put(fieldName, resetValue);
                             }
                           else if(fieldName=='Pharmacy_Benefit__c' ) // PCD Change
                            {          
                                       cloneSObj.put(fieldName, resetValue);
                             }
                           else if(fieldName=='Plan_Design__c' ) // PCD Change
                            {          
                                       cloneSObj.put(fieldName, resetValue);
                             }
                           else if(fieldName=='Retail_30__c' || fieldName=='Retail_30_1__c' || fieldName=='Retail_90__c' || fieldName=='Retail_90_1__c' || fieldName=='Client_Owned_30__c' || fieldName=='Client_Owned_30_1__c' || fieldName=='Client_Owned_90__c' || fieldName=='Client_Owned_90_1__c') // PCD Change
                            {          
                                       cloneSObj.put(fieldName, resetValue);
                             }
                           else if(fieldName=='Mail__c' || fieldName=='Mail_1__c' || fieldName=='Mchoice__c' || fieldName=='Mchoice_1__c' || fieldName=='Specialty_Retail__c' || fieldName=='Specialty_Retail_1__c' || fieldName=='Rebate_Operations__c' ) // PCD Change
                            {          
                                       cloneSObj.put(fieldName, resetValue);
                             }
                           else if(fieldName=='PCDQSCreation__c' ) // PCD Change
                            {          
                                       cloneSObj.put(fieldName, true);
                                       if(sObjectName == 'Network_Pricing__c')
                                       {
                                       for (Network_Pricing__c np : NetOps)
                                          {
                                          if ((cloneSObj.get('Network_Name__c') == np.Network_Name__c) && (cloneSObj.get('LOB__c') == np.LOB__c) && (cloneSObj.get('Network_Type__c') == np.Network_Type__c) && (cloneSObj.get('Year__c') == np.Year__c) && (cloneSObj.get('Custom_Network_Description__c') == np.Custom_Network_Description__c)) 
                                           {
                                            recexist = true;
                                           }
                                          }
                                         if (cloneSObj.get('Network_Name__c') == Label.MCCP || cloneSObj.get('Network_Name__c') == Label.MCCVS) // Logic not to clone  'MC(84-90)CP', 'MC(84-90)CVS' 
                                          {
                                            recexist = true;
                                          }
                                       }
                                       
                                      if(sObjectName == 'Specialty_Pricing__c')
                                       {
                                       for (Specialty_Pricing__c sp : SpecOps)
                                          {
                                          if ((cloneSObj.get('Year__c') == sp.Year__c) && (cloneSObj.get('LOB__c') == sp.LOB__c) && (cloneSObj.get('Pharmacy_Benefit__c') == sp.Pharmacy_Benefit__c)) 
                                           {
                                            recexist = true;
                                           }
                                           
                                           if (cloneSObj.get('Pharmacy_Benefit__c') == Label.PharmacyBenifit_Open)
                                           {
                                           cloneSObj.put('Open_HIV__c', null);
                                           }
                                          }
                                          
                                          if(recexist == false)
                                           {
                                             for(SObject sp : SpecList)
                                             {
                                              if ((cloneSObj.get('Year__c') == sp.get('Year__c')) && (cloneSObj.get('LOB__c') == sp.get('LOB__c')) && (cloneSObj.get('Pharmacy_Benefit__c') == sp.get('Pharmacy_Benefit__c'))) 
                                                {
                                                 recexist = true;
                                                }
                                             }
                                           }
                                           if(recexist == false)
                                           {
                                            SpecList.add(cloneSObj);
                                           }
                                       } 
                                       
                                    if(sObjectName == 'Rebate_Guarantees__c')
                                       {
                                       for (Rebate_Guarantees__c rg : RebateGtee)
                                          {
                                          if ((cloneSObj.get('Year__c') == rg.Year__c) && (cloneSObj.get('LOB2__c') == rg.LOB2__c) && (cloneSObj.get('Plan_Design__c') == rg.Plan_Design__c) && (cloneSObj.get('Plan_Design__c')) != null) 
                                           {
                                            recexist = true;
                                           }
                                          }
                                       }    
                             }
                            else if(resetValue=='FALSE')
                            {
                                       resetBool=false;
                                       cloneSObj.put(fieldName, resetBool); 
                                       System.debug('**cloneSObj**'+cloneSObj);
                             }
                             else{
                                        resetValue = null;
                                         cloneSObj.put(fieldName, resetValue); 
                                        
                            }
                    }
                }
            }       

            counter++;
            if (recexist == false)
            {
             clonedRelated.put(obj.Id, cloneSObj);
            }
            cloneSObj = null;
        }
        firstpass = false;
       try{
       for(SObject soblisObj:clonedRelated.values()){
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Database.insert(clonedRelated.values()); //PCD Change
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        }
      }
      catch(Exception ex){
          System.debug('The Exception Occured'+ex.getMessage());
      }
        return clonedRelated;*/  return null;
    }  
    
    
    
}