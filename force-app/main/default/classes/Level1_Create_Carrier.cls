public with sharing class Level1_Create_Carrier {
    
    /** Apex Controller to create new Carrier**/
    @AuraEnabled
    public static List<CAG__c> createCarrier(String CarrierId, String Platform, String Lob, String AccountId, String GroupId, String Recordtype, String PAccountId) {
        String sucessCMessage = 'New Carrier record created successfully'; 
        String failureCMessage = 'Error in New Carrier record creation'; 
        String failurePrivMessage = 'User dont have proper priviledge for record creation'; 
        String existingCMessage = 'Carrier Record already Added';
        integer duplicate = 0;
        String Level1Account = null;
        String SuperCAccount = null;
        
        try{
            List<CAG__c> lstCAG = new List<CAG__c>();
            List<Account> lstAcct = new List<Account>();
            List<Account> lstCAcct = new List<Account>();
            
            if (Recordtype == 'C') 
            {
            if(CarrierId != null){
                lstCAG = [Select Id, 
                          Platform_Name__c, 
                          Carrier_ID__c, 
                          CAG_ID__c,
                          Carrier_Name__c, 
                          Account_ID__c, 
                          Account_Name__c, 
                          Group_ID__c, 
                          Group_Name__c,
                          Record_Type__c
                          FROM CAG__c
                          WHERE Carrier_ID__c = :CarrierId
                          and Platform_Name__c = :Platform];
                	
                lstAcct = [Select Id, 
                            ParentId,
                          	Account_Level__c from Account where Id =: PAccountId];
                if (lstAcct != null && !lstAcct.isEmpty()){
                if (lstAcct[0].Account_Level__c == 'SuperClient')
                {
                     lstCAcct = [Select Id, 
                            ParentId,
                          	Account_Level__c from Account where ParentId =: PAccountId and Account_Level__c = 'Level 1'];
                    if (lstCAcct != null && !lstCAcct.isEmpty()){
                        Level1Account = lstCAcct[0].Id; }
                            SuperCAccount = lstAcct[0].Id;
                }
                else
                {
						   Level1Account = lstAcct[0].Id;
                           SuperCAccount = lstAcct[0].ParentId;                    
                }
                }
             if(lstCAG != null && !lstCAG.isEmpty())
             {	
                return  null;
             }
             else
             {
                       
                 	   CAG__c newC = new CAG__c();
                 	   List<CAG__c> lstCInsert = new List<CAG__c>();
                       newC.Platform_Name__c = Platform;
                       newC.Record_Type__c = 'C';
                       newC.Carrier_ID__c = CarrierId;
                 	   newC.CAG_ID__c = Platform + CarrierId;
                       newC.Carrier_Name__c = 'Non-Validated';
                       newC.Non_Validated_CAG__c = true;
                       newC.Status__c = 'A';
                 	   newC.PBM_Level0_Account__c = SuperCAccount;
                 	   newC.PBM_Level1_Account__c = Level1Account;
                       lstCInsert.add(newC);
                 		if (Schema.sObjectType.CAG__c.isCreateable())
                        {
                           Database.insert(lstCInsert);
                           return lstCInsert;
                        }
                         else {  return null; }
             } 

            }
                 else {
                    return null; }
          }
               return null;
        }
        catch(Exception ex){
            return null;
        }
        
    }
    
    /**** END Apex Controller to insert Platform Specific Record from CAG Search ****/

}