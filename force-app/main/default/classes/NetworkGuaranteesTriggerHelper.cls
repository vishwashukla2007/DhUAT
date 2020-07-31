/**************************************************************************************************
   * @Author    : Sneha Inturi
   * @Purpose   : Helper class for updating SSG Exclusion List and SSG Exclusivity Period to null
   * @Test_Class: Test_NetworkGuaranteesTriggerHelper
****************************************************************************************************/
public class NetworkGuaranteesTriggerHelper {
    
    public static void resetNPSSGS(List<Retail_Network_Guarantees__c> OldList){
            
            try{
                     set<id> NPIds = new set<id>();
                     List<Network_Pricing__c> NPList = new List<Network_Pricing__c>();
                     List<Network_Pricing__c> NPListUpdate = new List<Network_Pricing__c>();
                     
                     for(Retail_Network_Guarantees__c RNG:OldList){
                          NPIds.add(RNG.Network_Pricing__c);
                      }
                    
                     NPList=[select id,SSG_Exclusion_List__c,SSG_Exclusivity_Period__c,(select id from FAF_Retail_Network_Guarantees__r where SSG__c='NO' Limit 1) from Network_Pricing__c where id IN:NPIds and (SSG_Exclusion_List__c!='' OR SSG_Exclusivity_Period__c!='')];
                     
                        for(Network_Pricing__c NP:NPList){
                            if(NP.FAF_Retail_Network_Guarantees__r.isempty()){
                                Network_Pricing__c temp1= new Network_Pricing__c (id=NP.id,SSG_Exclusion_List__c='',SSG_Exclusivity_Period__c='');
                                NPListUpdate.add(temp1);
                            }
                          }
                        if(NPListUpdate.size()>0)
                                update NPListUpdate;  
              }catch(exception e){OldList[0].adderror(e.getMessage());}  
    }
}