/* ====================================================================
 * @Class Name      : BillingOtherPaymentsTriggerHelper
 * @author            : Akanksha Singh(Accenture)
 * @created date      : 12 07 2018
 * @Last modified by  : Akanksha Singh(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : This is the Helper class for Billing Other Payment
========================================================================
 * @Last modified by  : Sneha Inturi
 * @Last modified date: 09/23/2019
 * @Purpose           : Class is optimized to exclude Type 'Other - Please Describe*' during duplicity check.
 ========================================================================*/
public with sharing class BillingOtherPaymentsTriggerHelper{
//Method used to check duplicacy on LOB and Year in Billing Other Payments  
   public static void validateLobYearCombinalion(List<Contractual_Payments__c> BOPNew, Boolean isInsertBool, Boolean isUpdateBool) {   
    try{
        set<string> year=new set<string>();
        set<string> lob=new set<string>();
        set<string> basis=new set<string>();
        set<string> type=new set<string>();
        set<id> billingOprIdSet=new set<id>();
        
        for(Contractual_Payments__c b: BOPNew){
            year.add(b.years__c);
            lob.add(b.LOB2__c);
            Basis.add(b.Basis__c);
            type.add(b.Type__c  );
            billingOprIdSet.add(b.billing_operations__c);
        }
       
       List<Contractual_Payments__c > boplist=new list<Contractual_Payments__c>();
       
       boplist= [select id, billing_operations__c, years__c, LOB2__c, Basis__c, Type__c  from Contractual_Payments__c where id NOT IN:BOPNEW and billing_operations__c in: billingOprIdSet and
                 years__c IN: year and LOB2__c IN:lob and  Basis__c IN: Basis and Type__c In:Type ];
            
      for(Contractual_Payments__c b:BOPNew){
          if(b.Type__c!='Other - Please Describe*'){
              for(Contractual_Payments__c b1:boplist){
                  if(b.years__c==b1.years__c && b.LOB2__c==b1.LOB2__c && b.Basis__c==b1.Basis__c && b.Type__c==b1.Type__c){
                      b.addError(ConstantsUtil.YEAR_LOB_BASIS_TYPE_ERROR);
                  }
              }
          }
      }
  }catch(exception e){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));}
 }
}