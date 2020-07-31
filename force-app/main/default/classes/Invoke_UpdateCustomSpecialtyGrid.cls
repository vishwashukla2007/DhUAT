/* =================================================================================
 * @Class Name        : Invoke_UpdateCustomSpecialtyGrid
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/12/2019
 * @Purpose           : Invoke_UpdateSpecialtyPricing
=======================================================================================*/
global class Invoke_UpdateCustomSpecialtyGrid{



/*=================================================================================
 * @Method Name       : UpdateSpecialtyGrid
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/12/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : PUpdateSpecialtyGrid
=======================================================================================*/
@InvocableMethod
global static void UpdateSpecialtyGrid(List<id> objId)
{
  if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
        Map<id,Specialty_Pricing__c> MapYearComb = new Map<id,Specialty_Pricing__c>();
        Set<String> yearstr=new Set<String>();
        List<Specialty_Pricing__c> updatePricing=new List<Specialty_Pricing__c>();
        
       
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(',')){
            FAFStat.add(s);
        }                                                                                             
        List<Specialty_Pricing__c> Scope =[SELECT ID,FAF_ID__c,Specialty_Operations__c,Pharmacy_Benefit__c,
                                           Invokable_Update__c,Custom_Specialty_Grid__c
                                           FROM Specialty_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and Specialty_Operations__c IN:objId];
                                           
        Map<String,Specialty_Pricing__c> uniqueBenefit = new map<String,Specialty_Pricing__c>();
        for(Specialty_Pricing__c record: Scope) {
            if(!uniqueBenefit.containsKey(record.Pharmacy_Benefit__c)) {
                uniqueBenefit.put(record.Pharmacy_Benefit__c,record);
                if(record.Pharmacy_Benefit__c != Label.Pharmacy_Benefit_Exclude)
                {
                  record.Custom_Specialty_Grid__c=true;
                }
                else{
                record.Custom_Specialty_Grid__c=false;
                }
            }
            else{
             record.Custom_Specialty_Grid__c=false;
            }
            if(record.Invokable_Update__c==false){
                record.Invokable_Update__c=true;
            }
            else{
                 record.Invokable_Update__c=false;
            }
            record.Invokable_Update__c=true;
            updatePricing.add(record);
        }
        if(!updatePricing.isEmpty()){
        update updatePricing;
        }
    }
   }
    
}