/* =================================================================================
 * @Class Name        : PopulatePricingEffective
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 01/04/2019
 * @Purpose           : PopulatePricingEffective
=======================================================================================*/
public class PopulatePricingEffective{

/*=================================================================================
 * @Method Name       : populateEffectiveDate
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 01/04/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : Populate Effective Date
=======================================================================================*/
@InvocableMethod
public static void populateEffectiveDate(List<id> objId)
{
    map<Id,date> mapClient=new map<Id,date>();
    List<Platform_Specifics__c> platListUpdate=new List<Platform_Specifics__c>();
        for(Client_Information__c cl:[select id,Pricing_Effective_Date__c,FAF_ID__c,Release_FAF__c,FAF_ID__r.Initiate_FAF_Release__c from Client_Information__c where FAF_ID__c in:objId ]){
            mapClient.put(cl.FAF_ID__c,cl.Pricing_Effective_Date__c);
        }
        for(Platform_Specifics__c plat:[select id,XAE__c,EffectiveDate__c,FAF_ID__c from Platform_Specifics__c where FAF_ID__c in:objId ]){
            if(plat.EffectiveDate__c==null){
                if(mapClient.get(plat.FAF_ID__c)!=null){
                    plat.EffectiveDate__c=mapClient.get(plat.FAF_ID__c);
                    plat.XAE__c=false;
               }
               platListUpdate.add(plat);
            }
        }
        try{
            if(!platListUpdate.isEmpty()){
                Database.Update(platListUpdate);
            }
        }
        Catch(Exception ex){
           system.debug('The Excepttion Occured '+ ex);
        }
    }
}