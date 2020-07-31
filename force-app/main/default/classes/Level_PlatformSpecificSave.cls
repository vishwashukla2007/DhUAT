public class Level_PlatformSpecificSave {
@AuraEnabled
    public static Platform_Specifics__c SavePlaformSpec(Platform_Specifics__c Platformspec){
        system.debug('test' + Platformspec );
        //String retData = '';
        //PlatformSpecificData data = (PlatformSpecificData)JSON.deserialize(jsonData, PlatformSpecificData.class);
        Platform_Specifics__c psu;
        try {
         psu = (Platform_Specifics__c) Platformspec;
            Database.upsert(psu);   
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
            //Platform_Specifics__c psu = (Platform_Specifics__c) Platformspec;
            //Database.upsert(psu);
          /*  if(data!=null && data.platformSpecifics!=null && (!data.platformSpecifics.isEmpty())){
                data.isValidSave = true;                
                list<Platform_Specifics__c> upsertList=new list<Platform_Specifics__c>();
                for(PlatFormSpecificItem item: data.platformSpecifics){
                    if(item.isNewDelete){
                        //new Item deleted, then continue with next item
                        continue;
                    }
                     
                    upsertList.add(item.platformSpecific);
                }
                upsert upsertList;
                retData= aura_getPlatformSpecificData(data.clientInfoRecId); */
                
  
                    return psu;
    }
  }