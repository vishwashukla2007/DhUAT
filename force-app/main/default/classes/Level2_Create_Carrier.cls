public with sharing class Level2_Create_Carrier {
    
    /** Apex Controller to create new Account**/
    @AuraEnabled
    public static List<CAG__c> createCarrier(String CarrierId, String Platform, String Lob, String AccountId, String GroupId, String Recordtype) {
        String sucessCMessage = 'New Account record created successfully'; 
        String failureCMessage = 'Error in New Account record creation'; 
        String failurePrivMessage = 'User dont have proper priviledge for record creation'; 
        String existingCMessage = 'Account Record already Added';
        integer duplicate = 0;
        
        try{
            List<CAG__c> lstCAG = new List<CAG__c>();
            List<Account> lstAcct = new List<Account>();
            List<Account> lstCAcct = new List<Account>();
            
            if (Recordtype == 'A') 
            {
            if(CarrierId != null && AccountId != null ){
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
                          and Platform_Name__c = :Platform
                          and Account_ID__c = :AccountId];
                	
               
             	 if(lstCAG != null && !lstCAG.isEmpty())
                 {	
                   return  null;
                 }
             	 else
            	 {
                       
                 	   CAG__c newC = new CAG__c();
                 	   List<CAG__c> lstCInsert = new List<CAG__c>();
                       newC.Platform_Name__c = Platform;
                       newC.Record_Type__c = 'A';
                       newC.Carrier_ID__c = CarrierId;
                       newC.Account_ID__c = AccountId;
                 	   newC.CAG_ID__c = Platform + CarrierId + AccountId;
                       newC.Carrier_Name__c = 'Non-Validated';
                 	   newC.Account_Name__c = 'Non-Validated';
                       newC.Non_Validated_CAG__c = true;
                       newC.Status__c = 'A';
                       lstCInsert.add(newC);
                 				if (Schema.sObjectType.CAG__c.isCreateable())
                        			{
                          			 Database.insert(lstCInsert);
                           			   return  lstCInsert;
                        			}
                         		else {  return  null; }
                   } 

            }
                 else {
                    return  null; }
          }
               return  null;
        }
        catch(Exception ex){
            return  null;
        }
        
    }
    
    /**** END Apex Controller to insert Platform Specific Record from CAG Search ****/

}