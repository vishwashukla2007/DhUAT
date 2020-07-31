/************************************************************
 
 Name: PCD Questionaire Record
 Type: Apex Class  
 Purpose: Apex Class  for  lightning component 
           PCD Questionaire Record.cmp
 ***********************************************************/
public with sharing class CreatePCDQuestionAnswerRecord {

    /**
   * Create a new candidate Record
   *
   * @param Candidate__c candidate  candidate record to be inserted
   * 
   */
    @AuraEnabled
    public static void createRecord (PCD_Question_Answer__c PCD){
        
        try{
            System.debug('CreateCandidateRecord::createRecord::candidate'+PCD);
            
            
                upsert PCD;
                System.debug('PCD'+PCD.id);
            
            
        } catch (Exception ex){
            
        }
        
    }
    //For Lookup Components
     @AuraEnabled
    public static List <String> getPiklistValues() {
        List<String> plValues = new List<String>();
         
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('PCD_Question_Answer__c');
         
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
        //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get('Tier_Option_s__c').getDescribe();
         
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
         
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }
    //For Picklist Components.
    @AuraEnabled 
    public static Map<String, String> getTierOption(){
        Map<String, String> options = new Map<String, String>();
        //get Account Industry Field Describe
        Schema.DescribeFieldResult fieldResult = PCD_Question_Answer__c.Additional_Speciality_Option__c.getDescribe();
        //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
     @AuraEnabled 
    public static Map<String, String> getNetworkType(){
        Map<String, String> options = new Map<String, String>();
        //get Account Industry Field Describe
        Schema.DescribeFieldResult fieldResult = PCD_Question_Answer__c.Network_Type5__c.getDescribe();
        //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(),p.getValue());
        }
        return options;
    }
      
     @AuraEnabled 
      public static Account getAccount(String strID) {
        Task__c task = [Select Account__c from Task__c where Id=:strID limit 1];
        String AccntId;
        if (task != null)
         {
          AccntId = task.Account__c;
         }
        return [Select name FROM Account where Id=:AccntId limit 1];
    }
    @AuraEnabled 
      public static String getAccountId(String strID) {
        Task__c task = [Select Account__c from Task__c where Id=:strID limit 1];
        String AccntId;
        if (task != null)
         {
          AccntId = task.Account__c;
         }
        return AccntId;
    }
    @AuraEnabled
    public static Apttus__APTS_Agreement__c  getAuraAgreementData(String Aggrid) {
     Apttus__APTS_Agreement__c Aggr=[Select Primary_Agreement_Line_Item__c,
                                      PCD_FAF__c,Offer_Category__c,Primary_ALI_LOB__c
                                      FROM Apttus__APTS_Agreement__c Where Id =: Aggrid limit 1];
     return Aggr;
    }
    @AuraEnabled
    public static Apttus__AgreementLineItem__c  getAuraAgreementItemData(String Aggrid) {
     Apttus__APTS_Agreement__c Aggr1=[Select Primary_Agreement_Line_Item__c,
                                      PCD_FAF__c,Offer_Category__c,Primary_ALI_LOB__c
                                      FROM Apttus__APTS_Agreement__c Where Id =: Aggrid limit 1];
    if(Aggr1!=null){
    Apttus__AgreementLineItem__c Aggr=[Select ID,
                                    Med_D_HIF__c,
                                    Med_D_IHS__c,
                                    Med_D_LTC__c,
                                    Med_D_TER__c,
                                    Apttus__AgreementId__c,
                                    Apttus__AgreementId__r.Primary_ALI_LOB__c,
                                    Network_Operations_Count__c,
                                    Rebate_Operations_Count__c,
                                    Specialty_Operations_Count__c,
                                    Specialty_Formulary_Option__c,
                                    Non_Specialty_Formulary_Option__c,
                                    Clinical_Solution_Count__c,
                                    LOB_ID__c
                                    FROM Apttus__AgreementLineItem__c Where Id=:Aggr1.Primary_Agreement_Line_Item__c limit 1];
     return Aggr;
    
    }
    else{
                                      
    return null;
    }
  }
  
  }