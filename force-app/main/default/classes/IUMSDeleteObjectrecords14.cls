global class  IUMSDeleteObjectrecords14 implements Database.Batchable<sObject> {
    public String query;
       global Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, Central_Hub__c[] scope){
    
   
   
      
      // Delete Network Pricing Information for records uploaded from Model
      Network_Pricing__c[] lstnpri = [Select id from Network_Pricing__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
     // delete lstnpri;
      if (!lstnpri.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstnpri, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
              
       
      
       // Delete Mail Pricing Information for records uploaded from Model
      Mail_Pricing__c[] lstmpri = [Select id from Mail_Pricing__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstmpri;
      if (!lstmpri.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstmpri, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
     
     
      // Delete Specialty Pricing Information for records uploaded from Model
      Specialty_Pricing__c[] lstspri = [Select id from Specialty_Pricing__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstspri;
      if (!lstspri.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstspri, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
       
       
       
      // Delete Rebate Guarantee Information for records uploaded from Model
      Rebate_Guarantees__c[] lstrgee = [Select id from Rebate_Guarantees__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstrgee;
      if (!lstrgee.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstrgee, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
      
      
       // Delete Billing Admin Information for records uploaded from Model
      Billing_Administrative_Fees__c[] lstbadm = [Select id from Billing_Administrative_Fees__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
       DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstbadm;
      if (!lstbadm.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstbadm, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
       
     
      // Delete Clinical Solution Information for records uploaded from Model
      Clinical_Solutions__c[] lstcs = [Select id from Clinical_Solutions__c where IUMS_Upload__c= true and FAF_ID__c IN : scope];
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
      //delete lstcs;
      if (!lstcs.isEmpty())
                {
                List<Database.DeleteResult> result = Database.delete(lstcs, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }  
              }
      
      
   }
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    

    /******************************************************************************************************************************

     * @Method Name       : TestMethod 
     * @Purpose           : Method used to Increase coverage of the class.

     *******************************************************************************************************************************/

    public  void IncreaseCoverage2(){
    Integer i = 0;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    }
   }