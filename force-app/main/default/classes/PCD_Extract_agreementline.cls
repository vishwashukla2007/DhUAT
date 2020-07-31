public with sharing class PCD_Extract_agreementline {
  
  
@AuraEnabled
public static List<Apttus__AgreementLineItem__c> Extract_agreementline(String recordId) {
List<Apttus__AgreementLineItem__c> ali = new List<Apttus__AgreementLineItem__c>();
List<Id> Ids = new List<Id>();
Ids.add(recordId);
ali = [Select Id,Apttus__AgreementId__R.Task__c,LOB_Detail__c,PCD_FAF__r.LOB2__c,LOB_ID__c,Med_D_HIF__c,Med_D_IHS__c,Med_D_LTC__c,Med_D_TER__c,Template_Exclude__c,Last_PCD_Question_Answer__c,PCD_Questions_Answered__c,Apttus__AgreementId__c,Network_Operations_Count__c,Network_Pricing_Speciality__c, 
Non_Specialty_Formulary_Option__c,Rebate_Operations_Count__c,Specialty_Formulary_Option__c,Specialty_Operation_Pharmacy_Benefit__c,
Specialty_Operations_Count__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c IN : Ids];

return ali;
}
}