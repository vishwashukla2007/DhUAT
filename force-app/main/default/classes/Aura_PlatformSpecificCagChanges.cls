/* =================================================================================
 * @Class Name        : Aura_PlatformSpecificCagChanges
 * @author            : Sonal Sharma(Accenture)
 * @created date      : 02/17/2020
 * @Purpose           : Aura_PlatformSpecificCagChanges
=======================================================================================*/
public class Aura_PlatformSpecificCagChanges{
/*=================================================================================
 * @Method Name       : getTotalPlatformSpecific
 * @author            : Sonal Sharma(Accenture)
 * @created date      : 02/17/2020
 * @Last modified by  : Sonal Sharma(Accenture)
 * @Purpose           : Total number of platform Specific records on client info
=======================================================================================*/
    @AuraEnabled
    public static Integer getTotalPlatformSpecific(ID clientId){
        try{
            List<Platform_Specifics__c> count= new List<Platform_Specifics__c>();
            //if (clientId != null && clientId != 'undefined'){
                count=[select id from Platform_Specifics__c where FAF_Client_Information__c =: clientId];
            
            System.debug('size  '+count.size())  ;
            return count.size();
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}